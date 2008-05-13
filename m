From: akpm@linux-foundation.org
Subject: - uml-hppfs-fixes.patch removed from -mm tree
Date: Tue, 13 May 2008 14:32:25 -0700
Message-ID: <200805132132.m4DLWPT8000682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759718AbYEMVco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     uml: hppfs fixes
has been removed from the -mm tree.  Its filename was
     uml-hppfs-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: hppfs fixes
From: Jeff Dike <jdike@addtoit.com>

hppfs tidying and fixes noticed during hch's get_inode work -
      style fixes
      a copy_to_user got its return value checked
      hppfs_write no longer fiddles file->f_pos because it gets and
returns pos in its arguments
      hppfs_delete_inode dputs the underlyng procfs dentry stored in
its private data and mntputs the vfsmnt stashed in s_fs_info
      hppfs_put_super no longer needs to mntput the s_fs_info, so it
no longer needs to exist
      hppfs_readlink and hppfs_follow_link were doing a bunch of stuff
with a struct file which they didn't use
      there is now a ->permission which calls generic_permission
      get_inode was always returning 0 for some reason - it now
returns an inode if nothing bad happened

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hppfs/hppfs_kern.c |   82 ++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 52 deletions(-)

diff -puN fs/hppfs/hppfs_kern.c~uml-hppfs-fixes fs/hppfs/hppfs_kern.c
--- a/fs/hppfs/hppfs_kern.c~uml-hppfs-fixes
+++ a/fs/hppfs/hppfs_kern.c
@@ -33,7 +33,7 @@ struct hppfs_private {
 };
 
 struct hppfs_inode_info {
-        struct dentry *proc_dentry;
+	struct dentry *proc_dentry;
 	struct inode vfs_inode;
 };
 
@@ -52,7 +52,7 @@ static int is_pid(struct dentry *dentry)
 	int i;
 
 	sb = dentry->d_sb;
-	if ((sb->s_op != &hppfs_sbops) || (dentry->d_parent != sb->s_root))
+	if (dentry->d_parent != sb->s_root)
 		return 0;
 
 	for (i = 0; i < dentry->d_name.len; i++) {
@@ -136,7 +136,7 @@ static int file_removed(struct dentry *d
 }
 
 static struct dentry *hppfs_lookup(struct inode *ino, struct dentry *dentry,
-                                  struct nameidata *nd)
+				   struct nameidata *nd)
 {
 	struct dentry *proc_dentry, *new, *parent;
 	struct inode *inode;
@@ -254,6 +254,8 @@ static ssize_t hppfs_read(struct file *f
 	int err;
 
 	if (hppfs->contents != NULL) {
+		int rem;
+
 		if (*ppos >= hppfs->len)
 			return 0;
 
@@ -267,8 +269,10 @@ static ssize_t hppfs_read(struct file *f
 
 		if (off + count > hppfs->len)
 			count = hppfs->len - off;
-		copy_to_user(buf, &data->contents[off], count);
-		*ppos += count;
+		rem = copy_to_user(buf, &data->contents[off], count);
+		*ppos += count - rem;
+		if (rem > 0)
+			return -EFAULT;
 	} else if (hppfs->host_fd != -1) {
 		err = os_seek_file(hppfs->host_fd, *ppos);
 		if (err) {
@@ -285,21 +289,15 @@ static ssize_t hppfs_read(struct file *f
 	return count;
 }
 
-static ssize_t hppfs_write(struct file *file, const char __user *buf, size_t len,
-			   loff_t *ppos)
+static ssize_t hppfs_write(struct file *file, const char __user *buf,
+			   size_t len, loff_t *ppos)
 {
 	struct hppfs_private *data = file->private_data;
 	struct file *proc_file = data->proc_file;
 	ssize_t (*write)(struct file *, const char __user *, size_t, loff_t *);
-	int err;
 
 	write = proc_file->f_path.dentry->d_inode->i_fop->write;
-
-	proc_file->f_pos = file->f_pos;
-	err = (*write)(proc_file, buf, len, &proc_file->f_pos);
-	file->f_pos = proc_file->f_pos;
-
-	return err;
+	return (*write)(proc_file, buf, len, ppos);
 }
 
 static int open_host_sock(char *host_file, int *filter_out)
@@ -357,7 +355,7 @@ static struct hppfs_data *hppfs_get_data
 
 	if (filter) {
 		while ((n = read_proc(proc_file, data->contents,
-				     sizeof(data->contents), NULL, 0)) > 0)
+				      sizeof(data->contents), NULL, 0)) > 0)
 			os_write_file(fd, data->contents, n);
 		err = os_shutdown_socket(fd, 0, 1);
 		if (err) {
@@ -429,8 +427,8 @@ static int file_mode(int fmode)
 static int hppfs_open(struct inode *inode, struct file *file)
 {
 	struct hppfs_private *data;
-	struct dentry *proc_dentry;
 	struct vfsmount *proc_mnt;
+	struct dentry *proc_dentry;
 	char *host_file;
 	int err, fd, type, filter;
 
@@ -492,8 +490,8 @@ static int hppfs_open(struct inode *inod
 static int hppfs_dir_open(struct inode *inode, struct file *file)
 {
 	struct hppfs_private *data;
-	struct dentry *proc_dentry;
 	struct vfsmount *proc_mnt;
+	struct dentry *proc_dentry;
 	int err;
 
 	err = -ENOMEM;
@@ -620,6 +618,9 @@ static struct inode *hppfs_alloc_inode(s
 
 void hppfs_delete_inode(struct inode *ino)
 {
+	dput(HPPFS_I(ino)->proc_dentry);
+	mntput(ino->i_sb->s_fs_info);
+
 	clear_inode(ino);
 }
 
@@ -628,69 +629,46 @@ static void hppfs_destroy_inode(struct i
 	kfree(HPPFS_I(inode));
 }
 
-static void hppfs_put_super(struct super_block *sb)
-{
-	mntput(sb->s_fs_info);
-}
-
 static const struct super_operations hppfs_sbops = {
 	.alloc_inode	= hppfs_alloc_inode,
 	.destroy_inode	= hppfs_destroy_inode,
 	.delete_inode	= hppfs_delete_inode,
 	.statfs		= hppfs_statfs,
-	.put_super	= hppfs_put_super,
 };
 
 static int hppfs_readlink(struct dentry *dentry, char __user *buffer,
 			  int buflen)
 {
-	struct file *proc_file;
 	struct dentry *proc_dentry;
-	struct vfsmount *proc_mnt;
-	int ret;
 
 	proc_dentry = HPPFS_I(dentry->d_inode)->proc_dentry;
-	proc_mnt = dentry->d_sb->s_fs_info;
-
-	proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt), O_RDONLY);
-	if (IS_ERR(proc_file))
-		return PTR_ERR(proc_file);
-
-	ret = proc_dentry->d_inode->i_op->readlink(proc_dentry, buffer, buflen);
-
-	fput(proc_file);
-
-	return ret;
+	return proc_dentry->d_inode->i_op->readlink(proc_dentry, buffer,
+						    buflen);
 }
 
-static void* hppfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+static void *hppfs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	struct file *proc_file;
 	struct dentry *proc_dentry;
-	struct vfsmount *proc_mnt;
-	void *ret;
 
 	proc_dentry = HPPFS_I(dentry->d_inode)->proc_dentry;
-	proc_mnt = dentry->d_sb->s_fs_info;
-
-	proc_file = dentry_open(dget(proc_dentry), mntget(proc_mnt), O_RDONLY);
-	if (IS_ERR(proc_file))
-		return proc_file;
-
-	ret = proc_dentry->d_inode->i_op->follow_link(proc_dentry, nd);
 
-	fput(proc_file);
+	return proc_dentry->d_inode->i_op->follow_link(proc_dentry, nd);
+}
 
-	return ret;
+int hppfs_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	return generic_permission(inode, mask, NULL);
 }
 
 static const struct inode_operations hppfs_dir_iops = {
 	.lookup		= hppfs_lookup,
+	.permission	= hppfs_permission,
 };
 
 static const struct inode_operations hppfs_link_iops = {
 	.readlink	= hppfs_readlink,
 	.follow_link	= hppfs_follow_link,
+	.permission	= hppfs_permission,
 };
 
 static struct inode *get_inode(struct super_block *sb, struct dentry *dentry)
@@ -712,7 +690,7 @@ static struct inode *get_inode(struct su
 		inode->i_fop = &hppfs_file_fops;
 	}
 
-	HPPFS_I(inode)->proc_dentry = dentry;
+	HPPFS_I(inode)->proc_dentry = dget(dentry);
 
 	inode->i_uid = proc_ino->i_uid;
 	inode->i_gid = proc_ino->i_gid;
@@ -725,7 +703,7 @@ static struct inode *get_inode(struct su
 	inode->i_size = proc_ino->i_size;
 	inode->i_blocks = proc_ino->i_blocks;
 
-	return 0;
+	return inode;
 }
 
 static int hppfs_fill_super(struct super_block *sb, void *d, int silent)
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
linux-next.patch
asm-alphah8300umv850xtensa-paramh-unbreak-hz-for-userspace.patch
arch-um-kernel-irqc-clean-up-some-functions.patch
arch-um-kernel-memc-remove-arch_validate.patch
uml-make-several-more-things-static.patch

