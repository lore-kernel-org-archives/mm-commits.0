From: akpm@osdl.org
Subject: - fix-memory-corruption-from-misinterpreted-bad_inode_ops-tidy.patch removed from -mm tree
Date: Fri, 05 Jan 2007 16:14:18 -0800
Message-ID: <200701060014.l060Eieb011437@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44839 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbXAFAOw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 19:14:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mm-commits@vger.kernel.org


The patch titled
     fix-memory-corruption-from-misinterpreted-bad_inode_ops tidy
has been removed from the -mm tree.  Its filename was
     fix-memory-corruption-from-misinterpreted-bad_inode_ops-tidy.patch

This patch was dropped because it was folded into fix-memory-corruption-from-misinterpreted-bad_inode_ops.patch

------------------------------------------------------
Subject: fix-memory-corruption-from-misinterpreted-bad_inode_ops tidy
From: Eric Sandeen <sandeen@redhat.com>

Mostly cosmetic, making placement of * for pointers consistently " *foo"
not "* foo," (was a mishmash before, from cut-n-paste), but also making
.poll return POLLERR.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/bad_inode.c |   43 +++++++++++++++++++++----------------------
 1 files changed, 21 insertions(+), 22 deletions(-)

diff -puN fs/bad_inode.c~fix-memory-corruption-from-misinterpreted-bad_inode_ops-tidy fs/bad_inode.c
--- a/fs/bad_inode.c~fix-memory-corruption-from-misinterpreted-bad_inode_ops-tidy
+++ a/fs/bad_inode.c
@@ -46,18 +46,17 @@ static ssize_t bad_file_aio_write(struct
 	return -EIO;
 }
 
-static int bad_file_readdir(struct file * filp, void * dirent,
-			filldir_t filldir)
+static int bad_file_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	return -EIO;
 }
 
 static unsigned int bad_file_poll(struct file *filp, poll_table *wait)
 {
-	return -EIO;
+	return POLLERR;
 }
 
-static int bad_file_ioctl (struct inode * inode, struct file * filp,
+static int bad_file_ioctl (struct inode *inode, struct file *filp,
 			unsigned int cmd, unsigned long arg)
 {
 	return -EIO;
@@ -75,12 +74,12 @@ static long bad_file_compat_ioctl(struct
 	return -EIO;
 }
 
-static int bad_file_mmap(struct file * file, struct vm_area_struct * vma)
+static int bad_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	return -EIO;
 }
 
-static int bad_file_open(struct inode * inode, struct file * filp)
+static int bad_file_open(struct inode *inode, struct file *filp)
 {
 	return -EIO;
 }
@@ -90,12 +89,12 @@ static int bad_file_flush(struct file *f
 	return -EIO;
 }
 
-static int bad_file_release(struct inode * inode, struct file * filp)
+static int bad_file_release(struct inode *inode, struct file *filp)
 {
 	return -EIO;
 }
 
-static int bad_file_fsync(struct file * file, struct dentry *dentry,
+static int bad_file_fsync(struct file *file, struct dentry *dentry,
 			int datasync)
 {
 	return -EIO;
@@ -140,7 +139,7 @@ static int bad_file_check_flags(int flag
 	return -EIO;
 }
 
-static int bad_file_dir_notify(struct file * file, unsigned long arg)
+static int bad_file_dir_notify(struct file *file, unsigned long arg)
 {
 	return -EIO;
 }
@@ -194,54 +193,54 @@ static const struct file_operations bad_
 	.splice_read	= bad_file_splice_read,
 };
 
-static int bad_inode_create (struct inode * dir, struct dentry * dentry,
+static int bad_inode_create (struct inode *dir, struct dentry *dentry,
 		int mode, struct nameidata *nd)
 {
 	return -EIO;
 }
 
-static struct dentry *bad_inode_lookup(struct inode * dir,
+static struct dentry *bad_inode_lookup(struct inode *dir,
 			struct dentry *dentry, struct nameidata *nd)
 {
 	return ERR_PTR(-EIO);
 }
 
-static int bad_inode_link (struct dentry * old_dentry, struct inode * dir,
+static int bad_inode_link (struct dentry *old_dentry, struct inode *dir,
 		struct dentry *dentry)
 {
 	return -EIO;
 }
 
-static int bad_inode_unlink(struct inode * dir, struct dentry *dentry)
+static int bad_inode_unlink(struct inode *dir, struct dentry *dentry)
 {
 	return -EIO;
 }
 
-static int bad_inode_symlink (struct inode * dir, struct dentry *dentry,
-		const char * symname)
+static int bad_inode_symlink (struct inode *dir, struct dentry *dentry,
+		const char *symname)
 {
 	return -EIO;
 }
 
-static int bad_inode_mkdir(struct inode * dir, struct dentry * dentry,
+static int bad_inode_mkdir(struct inode *dir, struct dentry *dentry,
 			int mode)
 {
 	return -EIO;
 }
 
-static int bad_inode_rmdir (struct inode * dir, struct dentry *dentry)
+static int bad_inode_rmdir (struct inode *dir, struct dentry *dentry)
 {
 	return -EIO;
 }
 
-static int bad_inode_mknod (struct inode * dir, struct dentry *dentry,
+static int bad_inode_mknod (struct inode *dir, struct dentry *dentry,
 			int mode, dev_t rdev)
 {
 	return -EIO;
 }
 
-static int bad_inode_rename (struct inode * old_dir, struct dentry *old_dentry,
-		struct inode * new_dir, struct dentry *new_dentry)
+static int bad_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry)
 {
 	return -EIO;
 }
@@ -337,7 +336,7 @@ static struct inode_operations bad_inode
  *	on it to fail from this point on.
  */
  
-void make_bad_inode(struct inode * inode) 
+void make_bad_inode(struct inode *inode)
 {
 	remove_inode_hash(inode);
 
@@ -362,7 +361,7 @@ EXPORT_SYMBOL(make_bad_inode);
  *	Returns true if the inode in question has been marked as bad.
  */
  
-int is_bad_inode(struct inode * inode) 
+int is_bad_inode(struct inode *inode)
 {
 	return (inode->i_op == &bad_inode_ops);	
 }
_

Patches currently in -mm which might be from sandeen@redhat.com are

fix-memory-corruption-from-misinterpreted-bad_inode_ops.patch
fix-memory-corruption-from-misinterpreted-bad_inode_ops-tidy.patch
