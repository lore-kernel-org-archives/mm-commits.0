From: akpm@osdl.org
Subject: - sysfs-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:37 -0800
Message-ID: <200612082001.kB8K1bxU001884@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56849 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426213AbWLHUBk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     sysfs: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     sysfs-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysfs: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the sysfs
filesystem code.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/sysfs/bin.c  |   14 +++++++-------
 fs/sysfs/dir.c  |   10 +++++-----
 fs/sysfs/file.c |   16 ++++++++--------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/sysfs/bin.c~sysfs-change-uses-of-f_dentry fs/sysfs/bin.c
--- a/fs/sysfs/bin.c~sysfs-change-uses-of-f_dentry
+++ a/fs/sysfs/bin.c
@@ -35,7 +35,7 @@ static ssize_t
 read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
 {
 	char *buffer = file->private_data;
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 	int ret;
@@ -81,7 +81,7 @@ static ssize_t write(struct file * file,
 		     size_t count, loff_t * off)
 {
 	char *buffer = file->private_data;
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	int size = dentry->d_inode->i_size;
 	loff_t offs = *off;
 
@@ -105,7 +105,7 @@ static ssize_t write(struct file * file,
 
 static int mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct dentry *dentry = file->f_dentry;
+	struct dentry *dentry = file->f_path.dentry;
 	struct bin_attribute *attr = to_bin_attr(dentry);
 	struct kobject *kobj = to_kobj(dentry->d_parent);
 
@@ -117,8 +117,8 @@ static int mmap(struct file *file, struc
 
 static int open(struct inode * inode, struct file * file)
 {
-	struct kobject *kobj = sysfs_get_kobject(file->f_dentry->d_parent);
-	struct bin_attribute * attr = to_bin_attr(file->f_dentry);
+	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
+	struct bin_attribute * attr = to_bin_attr(file->f_path.dentry);
 	int error = -EINVAL;
 
 	if (!kobj || !attr)
@@ -153,8 +153,8 @@ static int open(struct inode * inode, st
 
 static int release(struct inode * inode, struct file * file)
 {
-	struct kobject * kobj = to_kobj(file->f_dentry->d_parent);
-	struct bin_attribute * attr = to_bin_attr(file->f_dentry);
+	struct kobject * kobj = to_kobj(file->f_path.dentry->d_parent);
+	struct bin_attribute * attr = to_bin_attr(file->f_path.dentry);
 	u8 * buffer = file->private_data;
 
 	if (kobj) 
diff -puN fs/sysfs/dir.c~sysfs-change-uses-of-f_dentry fs/sysfs/dir.c
--- a/fs/sysfs/dir.c~sysfs-change-uses-of-f_dentry
+++ a/fs/sysfs/dir.c
@@ -419,7 +419,7 @@ out:
 
 static int sysfs_dir_open(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -432,7 +432,7 @@ static int sysfs_dir_open(struct inode *
 
 static int sysfs_dir_close(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 	struct sysfs_dirent * cursor = file->private_data;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
@@ -452,7 +452,7 @@ static inline unsigned char dt_type(stru
 
 static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 {
-	struct dentry *dentry = filp->f_dentry;
+	struct dentry *dentry = filp->f_path.dentry;
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
 	struct sysfs_dirent *cursor = filp->private_data;
 	struct list_head *p, *q = &cursor->s_sibling;
@@ -509,7 +509,7 @@ static int sysfs_readdir(struct file * f
 
 static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
 {
-	struct dentry * dentry = file->f_dentry;
+	struct dentry * dentry = file->f_path.dentry;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (origin) {
@@ -519,7 +519,7 @@ static loff_t sysfs_dir_lseek(struct fil
 			if (offset >= 0)
 				break;
 		default:
-			mutex_unlock(&file->f_dentry->d_inode->i_mutex);
+			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {
diff -puN fs/sysfs/file.c~sysfs-change-uses-of-f_dentry fs/sysfs/file.c
--- a/fs/sysfs/file.c~sysfs-change-uses-of-f_dentry
+++ a/fs/sysfs/file.c
@@ -154,7 +154,7 @@ sysfs_read_file(struct file *file, char 
 
 	down(&buffer->sem);
 	if (buffer->needs_read_fill) {
-		if ((retval = fill_read_buffer(file->f_dentry,buffer)))
+		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
@@ -245,7 +245,7 @@ sysfs_write_file(struct file *file, cons
 	down(&buffer->sem);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_dentry, buffer, len);
+		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
 	up(&buffer->sem);
@@ -254,8 +254,8 @@ sysfs_write_file(struct file *file, cons
 
 static int check_perm(struct inode * inode, struct file * file)
 {
-	struct kobject *kobj = sysfs_get_kobject(file->f_dentry->d_parent);
-	struct attribute * attr = to_attr(file->f_dentry);
+	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
+	struct attribute * attr = to_attr(file->f_path.dentry);
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error = 0;
@@ -337,8 +337,8 @@ static int sysfs_open_file(struct inode 
 
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
-	struct kobject * kobj = to_kobj(filp->f_dentry->d_parent);
-	struct attribute * attr = to_attr(filp->f_dentry);
+	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
+	struct attribute * attr = to_attr(filp->f_path.dentry);
 	struct module * owner = attr->owner;
 	struct sysfs_buffer * buffer = filp->private_data;
 
@@ -372,8 +372,8 @@ static int sysfs_release(struct inode * 
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_buffer * buffer = filp->private_data;
-	struct kobject * kobj = to_kobj(filp->f_dentry->d_parent);
-	struct sysfs_dirent * sd = filp->f_dentry->d_fsdata;
+	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
+	struct sysfs_dirent * sd = filp->f_path.dentry->d_fsdata;
 	int res = 0;
 
 	poll_wait(filp, &kobj->poll, wait);
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

sysfs-change-uses-of-f_dentry.patch
proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext4-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
fat-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
isofs-change-uses-of-f_dentry.patch
nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

