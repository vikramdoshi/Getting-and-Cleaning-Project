if (!file.exists("UCI HAR Dataset")) 
{
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, "UCI-HAR-dataset.zip")
  unzip("UCI-HAR-dataset.zip")
}

# Load column names
features <- read.table("./UCI HAR Dataset/features.txt")

# 1. Merges the training and the test sets to create one data set.
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features[,2])
X <- rbind(X_test, X_train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
ExtractedFeatures <- features[grep("(mean|std)\\(", features[,2]),]
X_mean_and_std <- X[,ExtractedFeatures[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity'))
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))
y <- rbind(y_test, y_train)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

for (i in 1:nrow(activity_labels)) {
  label <- as.numeric(activity_labels[i, 1])
  label_desc <- as.character(activity_labels[i, 2])
  y[y$activity == label, ] <- label_desc
}

# 4. Appropriately label the data set with descriptive variable names.  
#   In this step, the feature names are cleaned of hyphens and parentheses, and 
#   then attached as column names to the data set.
features[,2] <- gsub("\\(\\)","",features[,2])
features[,2] <- gsub("\\-","\\_",features[,2])
colnames(X)<-features[,2]


# 5. Creates a tidy data set with the average of each variable for each activity and each subject. 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))
subject <- rbind(subject_test, subject_train)
average_by_activityandsubject <- aggregate(X, by = list(activity = y[,1], subject = subject[,1]), mean)

write.table(average_by_activityandsubject, file='Tidy_DataSet_average_by_activityandsubject.txt', row.names=FALSE)
