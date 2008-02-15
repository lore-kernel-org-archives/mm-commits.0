From: akpm@linux-foundation.org
Subject: + r-o-bind-mounts-elevate-write-count-for-opens.patch added to -mm tree
Date: Fri, 15 Feb 2008 14:49:11 -0800
Message-ID: <200802152249.m1FMnC5D028180@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935095AbYBOW6X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 17:58:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haveblue@us.ibm.com, akpm@linux-foundation.org, hch@lst.de, viro@ZenIV.linux.org.uk


The patch titled
     r/o bind mounts: elevate write count for open()s
has been added to the -mm tree.  Its filename is
     r-o-bind-mounts-elevate-write-count-for-opens.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: elevate write count for open()s
From: Dave Hansen <haveblue@us.ibm.com>

This is the first really tricky patch in the series.  It elevates the writer
count on a mount each time a non-special file is opened for write.

We used to do this in may_open(), but Miklos pointed out that __dentry_open()
is used as well to create filps.  This will cover even those cases, while a
call in may_open() would not have.

There is also an elevated count around the vfs_create() call in open_namei(). 
See the comments for more details, but we need this to fix a 'create, remount,
fail r/w open()' race.

Some filesystems forego the use of normal vfs calls to create struct files. 
Make sure that these users elevate the mnt writer count because they will get
__fput(), and we need to make sure they're balanced.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/file_table.c |   14 ++++++++
 fs/namei.c      |   75 +++++++++++++++++++++++++++++++++++++++-------
 fs/open.c       |   36 ++++++++++++++++++++--
 ipc/mqueue.c    |   16 ++++++++-
 4 files changed, 127 insertions(+), 14 deletions(-)

diff -puN fs/file_table.c~r-o-bind-mounts-elevate-write-count-for-opens fs/file_table.c
--- a/fs/file_table.c~r-o-bind-mounts-elevate-write-count-for-opens
+++ a/fs/file_table.c
@@ -199,6 +199,17 @@ int init_file(struct file *file, struct 
 	file->f_mapping = dentry->d_inode->i_mapping;
 	file->f_mode = mode;
 	file->f_op = fop;
+
+	/*
+	 * These mounts don't really matter in practice
+	 * for r/o bind mounts.  They aren't userspace-
+	 * visible.  We do this for consistency, and so
+	 * that we can do debugging checks at __fput()
+	 */
+	if ((mode & FMODE_WRITE) && !special_file(dentry->d_inode->i_mode)) {
+		error = mnt_want_write(mnt);
+		WARN_ON(error);
+	}
 	return error;
 }
 EXPORT_SYMBOL(init_file);
@@ -221,10 +232,13 @@ EXPORT_SYMBOL(fput);
  */
 void drop_file_write_access(struct file *file)
 {
+	struct vfsmount *mnt = file->f_path.mnt;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 
 	put_write_access(inode);
+	if (!special_file(inode->i_mode))
+		mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL_GPL(drop_file_write_access);
 
diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-for-opens fs/namei.c
--- a/fs/namei.c~r-o-bind-mounts-elevate-write-count-for-opens
+++ a/fs/namei.c
@@ -1623,8 +1623,7 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (acc_mode & MAY_WRITE))
-		return -EROFS;
+	}
 
 	error = vfs_permission(nd, acc_mode);
 	if (error)
@@ -1724,18 +1723,32 @@ static inline int open_to_namei_flags(in
 	return flag;
 }
 
+static int open_will_write_to_fs(int flag, struct inode *inode)
+{
+	/*
+	 * We'll never write to the fs underlying
+	 * a device file.
+	 */
+	if (special_file(inode->i_mode))
+		return 0;
+	return (flag & O_TRUNC);
+}
+
 /*
- * Note that the low bits of "flag" aren't the same as in the open
- * system call.  See open_to_namei_flags().
+ * Note that the low bits of the passed in "open_flag"
+ * are not the same as in the local variable "flag". See
+ * open_to_namei_flags() for more details.
  */
 struct file *do_filp_open(int dfd, const char *pathname,
 		int open_flag, int mode)
 {
+	struct file *filp;
 	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
 	int count = 0;
+	int will_write;
 	int flag = open_to_namei_flags(open_flag);
 
 	acc_mode = ACC_MODE(flag);
@@ -1791,17 +1804,30 @@ do_last:
 	}
 
 	if (IS_ERR(nd.intent.open.file)) {
-		mutex_unlock(&dir->d_inode->i_mutex);
 		error = PTR_ERR(nd.intent.open.file);
-		goto exit_dput;
+		goto exit_mutex_unlock;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = __open_namei_create(&nd, &path, flag, mode);
+		/*
+		 * This write is needed to ensure that a
+		 * ro->rw transition does not occur between
+		 * the time when the file is created and when
+		 * a permanent write count is taken through
+		 * the 'struct file' in nameidata_to_filp().
+		 */
+		error = mnt_want_write(nd.path.mnt);
 		if (error)
+			goto exit_mutex_unlock;
+		error = __open_namei_create(&nd, &path, flag, mode);
+		if (error) {
+			mnt_drop_write(nd.path.mnt);
 			goto exit;
-		return nameidata_to_filp(&nd, open_flag);
+		}
+		filp = nameidata_to_filp(&nd, open_flag);
+		mnt_drop_write(nd.path.mnt);
+		return filp;
 	}
 
 	/*
@@ -1831,11 +1857,40 @@ do_last:
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
+	/*
+	 * Consider:
+	 * 1. may_open() truncates a file
+	 * 2. a rw->ro mount transition occurs
+	 * 3. nameidata_to_filp() fails due to
+	 *    the ro mount.
+	 * That would be inconsistent, and should
+	 * be avoided. Taking this mnt write here
+	 * ensures that (2) can not occur.
+	 */
+	will_write = open_will_write_to_fs(flag, nd.path.dentry->d_inode);
+	if (will_write) {
+		error = mnt_want_write(nd.path.mnt);
+		if (error)
+			goto exit;
+	}
 	error = may_open(&nd, acc_mode, flag);
-	if (error)
+	if (error) {
+		if (will_write)
+			mnt_drop_write(nd.path.mnt);
 		goto exit;
-	return nameidata_to_filp(&nd, open_flag);
+	}
+	filp = nameidata_to_filp(&nd, open_flag);
+	/*
+	 * It is now safe to drop the mnt write
+	 * because the filp has had a write taken
+	 * on its behalf.
+	 */
+	if (will_write)
+		mnt_drop_write(nd.path.mnt);
+	return filp;
 
+exit_mutex_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 exit_dput:
 	path_put_conditional(&path, &nd);
 exit:
diff -puN fs/open.c~r-o-bind-mounts-elevate-write-count-for-opens fs/open.c
--- a/fs/open.c~r-o-bind-mounts-elevate-write-count-for-opens
+++ a/fs/open.c
@@ -730,6 +730,35 @@ out:
 	return error;
 }
 
+/*
+ * You have to be very careful that these write
+ * counts get cleaned up in error cases and
+ * upon __fput().  This should probably never
+ * be called outside of __dentry_open().
+ */
+static inline int __get_file_write_access(struct inode *inode,
+					  struct vfsmount *mnt)
+{
+	int error;
+	error = get_write_access(inode);
+	if (error)
+		return error;
+	/*
+	 * Do not take mount writer counts on
+	 * special files since no writes to
+	 * the mount itself will occur.
+	 */
+	if (!special_file(inode->i_mode)) {
+		/*
+		 * Balanced in __fput()
+		 */
+		error = mnt_want_write(mnt);
+		if (error)
+			put_write_access(inode);
+	}
+	return error;
+}
+
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					int flags, struct file *f,
 					int (*open)(struct inode *, struct file *))
@@ -742,7 +771,7 @@ static struct file *__dentry_open(struct
 				FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = get_write_access(inode);
+		error = __get_file_write_access(inode, mnt);
 		if (error)
 			goto cleanup_file;
 	}
@@ -784,8 +813,11 @@ static struct file *__dentry_open(struct
 
 cleanup_all:
 	fops_put(f->f_op);
-	if (f->f_mode & FMODE_WRITE)
+	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
+		if (!special_file(inode->i_mode))
+			mnt_drop_write(mnt);
+	}
 	file_kill(f);
 	f->f_path.dentry = NULL;
 	f->f_path.mnt = NULL;
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-for-opens ipc/mqueue.c
--- a/ipc/mqueue.c~r-o-bind-mounts-elevate-write-count-for-opens
+++ a/ipc/mqueue.c
@@ -598,6 +598,7 @@ static struct file *do_create(struct den
 			int oflag, mode_t mode, struct mq_attr __user *u_attr)
 {
 	struct mq_attr attr;
+	struct file *result;
 	int ret;
 
 	if (u_attr) {
@@ -612,13 +613,24 @@ static struct file *do_create(struct den
 	}
 
 	mode &= ~current->fs->umask;
+	ret = mnt_want_write(mqueue_mnt);
+	if (ret)
+		goto out;
 	ret = vfs_create(dir->d_inode, dentry, mode, NULL);
 	dentry->d_fsdata = NULL;
 	if (ret)
-		goto out;
+		goto out_drop_write;
 
-	return dentry_open(dentry, mqueue_mnt, oflag);
+	result = dentry_open(dentry, mqueue_mnt, oflag);
+	/*
+	 * dentry_open() took a persistent mnt_want_write(),
+	 * so we can now drop this one.
+	 */
+	mnt_drop_write(mqueue_mnt);
+	return result;
 
+out_drop_write:
+	mnt_drop_write(mqueue_mnt);
 out:
 	dput(dentry);
 	mntput(mqueue_mnt);
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

enable-hotplug-memory-remove-for-ppc64.patch
reiserfs-eliminate-private-use-of-struct-file-in-xattr.patch
hppfs-pass-vfsmount-to-dentry_open.patch
check-for-null-vfsmount-in-dentry_open.patch
fix-up-new-filp-allocators.patch
do-namei_flags-calculation-inside-open_namei.patch
merge-open_namei-and-do_filp_open.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-create-helper-to-drop-file-write-access.patch
r-o-bind-mounts-drop-write-during-emergency-remount.patch
r-o-bind-mounts-elevate-write-count-for-vfs_rmdir.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir.patch
r-o-bind-mounts-elevate-mnt_writers-for-unlink-callers.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers.patch
r-o-bind-mounts-elevate-write-count-for-ncp_ioctl.patch
r-o-bind-mounts-write-counts-for-time-functions.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-write-count-for-file_update_time.patch
r-o-bind-mounts-write-counts-for-link-symlink.patch
r-o-bind-mounts-elevate-write-count-for-ioctls.patch
r-o-bind-mounts-elevate-write-count-for-opens.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers.patch
r-o-bind-mounts-elevate-write-count-for-chmod-chown-callers.patch
r-o-bind-mounts-write-counts-for-truncate.patch
r-o-bind-mounts-elevate-count-for-xfs-timestamp-updates.patch
r-o-bind-mounts-make-access-use-new-r-o-helper.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create.patch
r-o-bind-mounts-track-numbers-of-writers-to-mounts.patch
r-o-bind-mounts-honor-mount-writer-counts-at-remount.patch
r-o-bind-mounts-debugging-for-missed-calls.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
