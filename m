From: akpm@linux-foundation.org
Subject: - uml-make-hostfs_setattr-support-operations-on-unlinked-open-files.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:43 -0700
Message-ID: <200705090243.l492hhjn008505@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970023AbXEICns (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:43:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albertito@gmail.com, blaisorblade@yahoo.it, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: make hostfs_setattr() support operations on unlinked open files
has been removed from the -mm tree.  Its filename was
     uml-make-hostfs_setattr-support-operations-on-unlinked-open-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: make hostfs_setattr() support operations on unlinked open files
From: Alberto Bertogli <albertito@gmail.com>

This patch allows hostfs_setattr() to work on unlinked open files by calling
set_attr() (the userspace part) with the inode's fd.

Without this, applications that depend on doing attribute changes to unlinked
open files will fail.

It works by using the fd versions instead of the path ones (for example
fchmod() instead of chmod(), fchown() instead of chown()) when an fd is
available.

Signed-off-by: Alberto Bertogli <albertito@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hostfs/hostfs.h      |    4 -
 fs/hostfs/hostfs_kern.c |    6 +-
 fs/hostfs/hostfs_user.c |  106 ++++++++++++++++++++++++--------------
 3 files changed, 73 insertions(+), 43 deletions(-)

diff -puN fs/hostfs/hostfs.h~uml-make-hostfs_setattr-support-operations-on-unlinked-open-files fs/hostfs/hostfs.h
--- a/fs/hostfs/hostfs.h~uml-make-hostfs_setattr-support-operations-on-unlinked-open-files
+++ a/fs/hostfs/hostfs.h
@@ -55,7 +55,7 @@ extern int stat_file(const char *path, u
 		     int *mode_out, int *nlink_out, int *uid_out, int *gid_out,
 		     unsigned long long *size_out, struct timespec *atime_out,
 		     struct timespec *mtime_out, struct timespec *ctime_out,
-		     int *blksize_out, unsigned long long *blocks_out);
+		     int *blksize_out, unsigned long long *blocks_out, int fd);
 extern int access_file(char *path, int r, int w, int x);
 extern int open_file(char *path, int r, int w, int append);
 extern int file_type(const char *path, int *maj, int *min);
@@ -71,7 +71,7 @@ extern int lseek_file(int fd, long long 
 extern int fsync_file(int fd, int datasync);
 extern int file_create(char *name, int ur, int uw, int ux, int gr,
 		       int gw, int gx, int or, int ow, int ox);
-extern int set_attr(const char *file, struct hostfs_iattr *attrs);
+extern int set_attr(const char *file, struct hostfs_iattr *attrs, int fd);
 extern int make_symlink(const char *from, const char *to);
 extern int unlink_file(const char *file);
 extern int do_mkdir(const char *file, int mode);
diff -puN fs/hostfs/hostfs_kern.c~uml-make-hostfs_setattr-support-operations-on-unlinked-open-files fs/hostfs/hostfs_kern.c
--- a/fs/hostfs/hostfs_kern.c~uml-make-hostfs_setattr-support-operations-on-unlinked-open-files
+++ a/fs/hostfs/hostfs_kern.c
@@ -147,7 +147,7 @@ static int read_name(struct inode *ino, 
 
 	err = stat_file(name, &i_ino, &i_mode, &i_nlink, &ino->i_uid,
 			&ino->i_gid, &i_size, &ino->i_atime, &ino->i_mtime,
-			&ino->i_ctime, &i_blksize, &i_blocks);
+			&ino->i_ctime, &i_blksize, &i_blocks, -1);
 	if(err)
 		return(err);
 
@@ -820,6 +820,8 @@ int hostfs_setattr(struct dentry *dentry
 	char *name;
 	int err;
 
+	int fd = HOSTFS_I(dentry->d_inode)->fd;
+
 	err = inode_change_ok(dentry->d_inode, attr);
 	if (err)
 		return err;
@@ -864,7 +866,7 @@ int hostfs_setattr(struct dentry *dentry
 	}
 	name = dentry_name(dentry, 0);
 	if(name == NULL) return(-ENOMEM);
-	err = set_attr(name, &attrs);
+	err = set_attr(name, &attrs, fd);
 	kfree(name);
 	if(err)
 		return(err);
diff -puN fs/hostfs/hostfs_user.c~uml-make-hostfs_setattr-support-operations-on-unlinked-open-files fs/hostfs/hostfs_user.c
--- a/fs/hostfs/hostfs_user.c~uml-make-hostfs_setattr-support-operations-on-unlinked-open-files
+++ a/fs/hostfs/hostfs_user.c
@@ -21,12 +21,16 @@ int stat_file(const char *path, unsigned
 	      int *nlink_out, int *uid_out, int *gid_out,
 	      unsigned long long *size_out, struct timespec *atime_out,
 	      struct timespec *mtime_out, struct timespec *ctime_out,
-	      int *blksize_out, unsigned long long *blocks_out)
+	      int *blksize_out, unsigned long long *blocks_out, int fd)
 {
 	struct stat64 buf;
 
-	if(lstat64(path, &buf) < 0)
+	if(fd >= 0) {
+		if (fstat64(fd, &buf) < 0)
+			return(-errno);
+	} else if(lstat64(path, &buf) < 0) {
 		return(-errno);
+	}
 
 	if(inode_out != NULL) *inode_out = buf.st_ino;
 	if(mode_out != NULL) *mode_out = buf.st_mode;
@@ -202,58 +206,82 @@ int file_create(char *name, int ur, int 
 	return(fd);
 }
 
-int set_attr(const char *file, struct hostfs_iattr *attrs)
+int set_attr(const char *file, struct hostfs_iattr *attrs, int fd)
 {
-	struct utimbuf buf;
+	struct timeval times[2];
+	struct timespec atime_ts, mtime_ts;
 	int err, ma;
 
-	if(attrs->ia_valid & HOSTFS_ATTR_MODE){
-		if(chmod(file, attrs->ia_mode) != 0) return(-errno);
-	}
-	if(attrs->ia_valid & HOSTFS_ATTR_UID){
-		if(chown(file, attrs->ia_uid, -1)) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_MODE) {
+		if (fd >= 0) {
+			if (fchmod(fd, attrs->ia_mode) != 0)
+				return (-errno);
+		} else if (chmod(file, attrs->ia_mode) != 0) {
+			return (-errno);
+		}
 	}
-	if(attrs->ia_valid & HOSTFS_ATTR_GID){
-		if(chown(file, -1, attrs->ia_gid)) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_UID) {
+		if (fd >= 0) {
+			if (fchown(fd, attrs->ia_uid, -1))
+				return (-errno);
+		} else if(chown(file, attrs->ia_uid, -1)) {
+			return (-errno);
+		}
 	}
-	if(attrs->ia_valid & HOSTFS_ATTR_SIZE){
-		if(truncate(file, attrs->ia_size)) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_GID) {
+		if (fd >= 0) {
+			if (fchown(fd, -1, attrs->ia_gid))
+				return (-errno);
+		} else if (chown(file, -1, attrs->ia_gid)) {
+			return (-errno);
+		}
 	}
-	ma = HOSTFS_ATTR_ATIME_SET | HOSTFS_ATTR_MTIME_SET;
-	if((attrs->ia_valid & ma) == ma){
-		buf.actime = attrs->ia_atime.tv_sec;
-		buf.modtime = attrs->ia_mtime.tv_sec;
-		if(utime(file, &buf) != 0) return(-errno);
+	if (attrs->ia_valid & HOSTFS_ATTR_SIZE) {
+		if (fd >= 0) {
+			if (ftruncate(fd, attrs->ia_size))
+				return (-errno);
+		} else if (truncate(file, attrs->ia_size)) {
+			return (-errno);
+		}
 	}
-	else {
-		struct timespec ts;
 
-		if(attrs->ia_valid & HOSTFS_ATTR_ATIME_SET){
-			err = stat_file(file, NULL, NULL, NULL, NULL, NULL,
-					NULL, NULL, &ts, NULL, NULL, NULL);
-			if(err != 0)
-				return(err);
-			buf.actime = attrs->ia_atime.tv_sec;
-			buf.modtime = ts.tv_sec;
-			if(utime(file, &buf) != 0)
-				return(-errno);
+	/* Update accessed and/or modified time, in two parts: first set
+	 * times according to the changes to perform, and then call futimes()
+	 * or utimes() to apply them. */
+	ma = (HOSTFS_ATTR_ATIME_SET | HOSTFS_ATTR_MTIME_SET);
+	if (attrs->ia_valid & ma) {
+		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
+				&atime_ts, &mtime_ts, NULL, NULL, NULL, fd);
+		if (err != 0)
+			return err;
+
+		times[0].tv_sec = atime_ts.tv_sec;
+		times[0].tv_usec = atime_ts.tv_nsec * 1000;
+		times[1].tv_sec = mtime_ts.tv_sec;
+		times[1].tv_usec = mtime_ts.tv_nsec * 1000;
+
+		if (attrs->ia_valid & HOSTFS_ATTR_ATIME_SET) {
+			times[0].tv_sec = attrs->ia_atime.tv_sec;
+			times[0].tv_usec = attrs->ia_atime.tv_nsec * 1000;
 		}
-		if(attrs->ia_valid & HOSTFS_ATTR_MTIME_SET){
-			err = stat_file(file, NULL, NULL, NULL, NULL, NULL,
-					NULL, &ts, NULL, NULL, NULL, NULL);
-			if(err != 0)
-				return(err);
-			buf.actime = ts.tv_sec;
-			buf.modtime = attrs->ia_mtime.tv_sec;
-			if(utime(file, &buf) != 0)
-				return(-errno);
+		if (attrs->ia_valid & HOSTFS_ATTR_MTIME_SET) {
+			times[1].tv_sec = attrs->ia_mtime.tv_sec;
+			times[1].tv_usec = attrs->ia_mtime.tv_nsec * 1000;
+		}
+
+		if (fd >= 0) {
+			if (futimes(fd, times) != 0)
+				return (-errno);
+		} else if (utimes(file, times) != 0) {
+			return (-errno);
 		}
 	}
+
 	if(attrs->ia_valid & HOSTFS_ATTR_CTIME) ;
 	if(attrs->ia_valid & (HOSTFS_ATTR_ATIME | HOSTFS_ATTR_MTIME)){
 		err = stat_file(file, NULL, NULL, NULL, NULL, NULL, NULL,
 				&attrs->ia_atime, &attrs->ia_mtime, NULL,
-				NULL, NULL);
+				NULL, NULL, fd);
 		if(err != 0) return(err);
 	}
 	return(0);
_

Patches currently in -mm which might be from albertito@gmail.com are

origin.patch
