From: akpm@osdl.org
Subject: - 9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:08 -0800
Message-ID: <200612082002.kB8K28vQ001948@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57019 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761167AbWLHUC1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     9p: change uses of f_{dentry,vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: 9p: change uses of f_{dentry,vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the 9p
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/9p/vfs_addr.c |    2 +-
 fs/9p/vfs_dir.c  |    4 ++--
 fs/9p/vfs_file.c |    8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/9p/vfs_addr.c~9p-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/9p/vfs_addr.c
--- a/fs/9p/vfs_addr.c~9p-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/9p/vfs_addr.c
@@ -54,7 +54,7 @@ static int v9fs_vfs_readpage(struct file
 	int retval = -EIO;
 	loff_t offset = page_offset(page);
 	int count = PAGE_CACHE_SIZE;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	int rsize = v9ses->maxdata - V9FS_IOHDRSZ;
 	struct v9fs_fid *v9f = filp->private_data;
diff -puN fs/9p/vfs_dir.c~9p-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/9p/vfs_dir.c
--- a/fs/9p/vfs_dir.c~9p-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/9p/vfs_dir.c
@@ -71,7 +71,7 @@ static inline int dt_type(struct v9fs_st
 static int v9fs_dir_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
 	struct v9fs_fcall *fcall = NULL;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	struct v9fs_fid *file = filp->private_data;
 	unsigned int i, n, s;
@@ -80,7 +80,7 @@ static int v9fs_dir_readdir(struct file 
 	struct v9fs_stat stat;
 	int over = 0;
 
-	dprintk(DEBUG_VFS, "name %s\n", filp->f_dentry->d_name.name);
+	dprintk(DEBUG_VFS, "name %s\n", filp->f_path.dentry->d_name.name);
 
 	fid = file->fid;
 
diff -puN fs/9p/vfs_file.c~9p-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~9p-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/9p/vfs_file.c
@@ -60,7 +60,7 @@ int v9fs_file_open(struct inode *inode, 
 
 	dprintk(DEBUG_VFS, "inode: %p file: %p \n", inode, file);
 
-	vfid = v9fs_fid_lookup(file->f_dentry);
+	vfid = v9fs_fid_lookup(file->f_path.dentry);
 	if (!vfid) {
 		dprintk(DEBUG_ERROR, "Couldn't resolve fid from dentry\n");
 		return -EBADF;
@@ -133,7 +133,7 @@ free_fcall:
 static int v9fs_file_lock(struct file *filp, int cmd, struct file_lock *fl)
 {
 	int res = 0;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 
 	dprintk(DEBUG_VFS, "filp: %p lock: %p\n", filp, fl);
 
@@ -161,7 +161,7 @@ static ssize_t
 v9fs_file_read(struct file *filp, char __user * data, size_t count,
 	       loff_t * offset)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	struct v9fs_fid *v9f = filp->private_data;
 	struct v9fs_fcall *fcall = NULL;
@@ -225,7 +225,7 @@ static ssize_t
 v9fs_file_write(struct file *filp, const char __user * data,
 		size_t count, loff_t * offset)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
 	struct v9fs_fid *v9fid = filp->private_data;
 	struct v9fs_fcall *fcall;
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

