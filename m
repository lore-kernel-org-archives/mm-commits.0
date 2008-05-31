From: akpm@linux-foundation.org
Subject: - vfs-create-file_truncate-helper.patch removed from -mm tree
Date: Sat, 31 May 2008 00:42:49 -0700
Message-ID: <200805310742.m4V7gnv7000937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40203 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbYEaHqY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 31 May 2008 03:46:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: create file_truncate() helper
has been removed from the -mm tree.  Its filename was
     vfs-create-file_truncate-helper.patch

This patch was dropped because it's more controversial than was first thought, and it was sent off-list

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: create file_truncate() helper
From: Miklos Szeredi <mszeredi@suse.cz>

Clean up do_truncate() API:

  - create a new function file_truncate()

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c          |    2 +-
 fs/open.c          |   24 ++++++++++++++++++++----
 include/linux/fs.h |    2 ++
 mm/tiny-shmem.c    |    2 +-
 4 files changed, 24 insertions(+), 6 deletions(-)

diff -puN fs/exec.c~vfs-create-file_truncate-helper fs/exec.c
--- a/fs/exec.c~vfs-create-file_truncate-helper
+++ a/fs/exec.c
@@ -1768,7 +1768,7 @@ int do_coredump(long signr, int exit_cod
 		goto close_fail;
 	if (!file->f_op->write)
 		goto close_fail;
-	if (!ispipe && do_truncate(file->f_path.dentry, 0, 0, file) != 0)
+	if (!ispipe && file_truncate(file, 0, 0) != 0)
 		goto close_fail;
 
 	retval = binfmt->core_dump(signr, regs, file, core_limit);
diff -puN fs/open.c~vfs-create-file_truncate-helper fs/open.c
--- a/fs/open.c~vfs-create-file_truncate-helper
+++ a/fs/open.c
@@ -195,6 +195,13 @@ out:
 	return error;
 }
 
+/*
+ * do_truncate - truncate (or extend) an inode
+ * @dentry: the dentry to truncate
+ * @length: the new length
+ * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
+ * @filp: an open file or NULL (see file_truncate() as well)
+ */
 int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 	struct file *filp)
 {
@@ -221,6 +228,17 @@ int do_truncate(struct dentry *dentry, l
 	return err;
 }
 
+/*
+ * file_truncate - truncate (or extend) an open file
+ * @filp: the open file
+ * @length: the new length
+ * @time_attrs: file times to be updated (e.g. ATTR_MTIME|ATTR_CTIME)
+ */
+int file_truncate(struct file *filp, loff_t length, unsigned int time_attrs)
+{
+	return do_truncate(filp->f_path.dentry, length, time_attrs, filp);
+}
+
 static long do_sys_truncate(const char __user * path, loff_t length)
 {
 	struct nameidata nd;
@@ -294,7 +312,6 @@ asmlinkage long sys_truncate(const char 
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
 	struct inode * inode;
-	struct dentry *dentry;
 	struct file * file;
 	int error;
 
@@ -310,8 +327,7 @@ static long do_sys_ftruncate(unsigned in
 	if (file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = file->f_path.dentry;
-	inode = dentry->d_inode;
+	inode = file->f_path.dentry->d_inode;
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(file->f_mode & FMODE_WRITE))
 		goto out_putf;
@@ -327,7 +343,7 @@ static long do_sys_ftruncate(unsigned in
 
 	error = locks_verify_truncate(inode, file, length);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, file);
+		error = file_truncate(file, length, ATTR_MTIME|ATTR_CTIME);
 out_putf:
 	fput(file);
 out:
diff -puN include/linux/fs.h~vfs-create-file_truncate-helper include/linux/fs.h
--- a/include/linux/fs.h~vfs-create-file_truncate-helper
+++ a/include/linux/fs.h
@@ -1622,6 +1622,8 @@ static inline int break_lease(struct ino
 
 extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
 		       struct file *filp);
+extern int file_truncate(struct file *filp, loff_t start,
+			 unsigned int time_attrs);
 extern long do_sys_open(int dfd, const char __user *filename, int flags,
 			int mode);
 extern struct file *filp_open(const char *, int, int);
diff -puN mm/tiny-shmem.c~vfs-create-file_truncate-helper mm/tiny-shmem.c
--- a/mm/tiny-shmem.c~vfs-create-file_truncate-helper
+++ a/mm/tiny-shmem.c
@@ -80,7 +80,7 @@ struct file *shmem_file_setup(char *name
 	inode->i_nlink = 0;	/* It is unlinked */
 
 	/* notify everyone as to the change of file size */
-	error = do_truncate(dentry, size, 0, file);
+	error = file_truncate(file, size, 0);
 	if (error < 0)
 		goto close_file;
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

vfs-create-file_truncate-helper.patch
vfs-utimes-immutable-fix.patch
vfs-utimes-cleanup.patch
vfs-dcache-cleanups.patch
vfs-fix-sys_getcwd-for-detached-mounts.patch
git-unprivileged-mounts.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

