From: akpm@osdl.org
Subject: - configfs-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:16 -0800
Message-ID: <200612082002.kB8K2GLG001960@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57044 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426239AbWLHUCm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     configfs: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     configfs-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: configfs: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the
configfs filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/configfs/dir.c  |   10 +++++-----
 fs/configfs/file.c |   12 ++++++------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/configfs/dir.c~configfs-change-uses-of-f_dentry fs/configfs/dir.c
--- a/fs/configfs/dir.c~configfs-change-uses-of-f_dentry
+++ a/fs/configfs/dir.c
@@ -980,7 +980,7 @@ int configfs_rename_dir(struct config_it
 
 static int configfs_dir_open(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 	struct configfs_dirent * parent_sd = dentry->d_fsdata;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -993,7 +993,7 @@ static int configfs_dir_open(struct inod
 
 static int configfs_dir_close(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 	struct configfs_dirent * cursor = file->private_data;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -1013,7 +1013,7 @@ static inline unsigned char dt_type(stru
 
 static int configfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct configfs_dirent * parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->s_sibling;
@@ -1070,7 +1070,7 @@ static int configfs_readdir(struct file 
 
 static loff_t configfs_dir_lseek(struct file * file, loff_t offset, int origin)
 {
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (origin) {
@@ -1080,7 +1080,7 @@ static loff_t configfs_dir_lseek(struct 
 			if (offset >= 0)
 				break;
 		default:
-			mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {
diff -puN fs/configfs/file.c~configfs-change-uses-of-f_dentry fs/configfs/file.c
--- a/fs/configfs/file.c~configfs-change-uses-of-f_dentry
+++ a/fs/configfs/file.c
@@ -134,7 +134,7 @@ configfs_read_file(struct file *file, ch
 
 	down(&buffer->sem);
 	if (buffer->needs_read_fill) {
-		if ((retval = fill_read_buffer(file->f_dentry,buffer)))
+		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
@@ -222,7 +222,7 @@ configfs_write_file(struct file *file, c
 	down(&buffer->sem);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_dentry, buffer, count);
+		len = flush_write_buffer(file->f_path.dentry, buffer, count);
 	if (len > 0)
 		*ppos += len;
 	up(&buffer->sem);
@@ -231,8 +231,8 @@ configfs_write_file(struct file *file, c
 
 static int check_perm(struct inode * inode, struct file * file)
 {
-	struct config_item *item = configfs_get_config_item(file->f_dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(file->f_dentry);
+	struct config_item *item = configfs_get_config_item(file->f_path.dentry->d_parent);
+	struct configfs_attribute * attr = to_attr(file->f_path.dentry);
 	struct configfs_buffer * buffer;
 	struct configfs_item_operations * ops = NULL;
 	int error = 0;
@@ -305,8 +305,8 @@ static int configfs_open_file(struct ino
 
 static int configfs_release(struct inode * inode, struct file * filp)
 {
-	struct config_item * item = to_item(filp->f_dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(filp->f_dentry);
+	struct config_item * item = to_item(filp->f_path.dentry->d_parent);
+	struct configfs_attribute * attr = to_attr(filp->f_path.dentry);
 	struct module * owner = attr->ca_owner;
 	struct configfs_buffer * buffer = filp->private_data;
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

