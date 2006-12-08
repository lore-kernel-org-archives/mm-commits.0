From: akpm@osdl.org
Subject: - struct-path-convert-reiserfs.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:04:46 -0800
Message-ID: <200612082004.kB8K4k9a002225@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57390 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426305AbWLHUEv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:04:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert reiserfs
has been removed from the -mm tree.  Its filename was
     struct-path-convert-reiserfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert reiserfs
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiserfs/dir.c    |    4 ++--
 fs/reiserfs/file.c   |    4 ++--
 fs/reiserfs/ioctl.c  |    2 +-
 fs/reiserfs/procfs.c |    2 +-
 fs/reiserfs/xattr.c  |   10 +++++-----
 5 files changed, 11 insertions(+), 11 deletions(-)

diff -puN fs/reiserfs/dir.c~struct-path-convert-reiserfs fs/reiserfs/dir.c
--- a/fs/reiserfs/dir.c~struct-path-convert-reiserfs
+++ a/fs/reiserfs/dir.c
@@ -45,7 +45,7 @@ static int reiserfs_dir_fsync(struct fil
 //
 static int reiserfs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cpu_key pos_key;	/* key of current position in the directory (key of directory entry) */
 	INITIALIZE_PATH(path_to_entry);
 	struct buffer_head *bh;
@@ -135,7 +135,7 @@ static int reiserfs_readdir(struct file 
 				/* Ignore the .reiserfs_priv entry */
 				if (reiserfs_xattrs(inode->i_sb) &&
 				    !old_format_only(inode->i_sb) &&
-				    filp->f_dentry == inode->i_sb->s_root &&
+				    filp->f_path.dentry == inode->i_sb->s_root &&
 				    REISERFS_SB(inode->i_sb)->priv_root &&
 				    REISERFS_SB(inode->i_sb)->priv_root->d_inode
 				    && deh_objectid(deh) ==
diff -puN fs/reiserfs/file.c~struct-path-convert-reiserfs fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~struct-path-convert-reiserfs
+++ a/fs/reiserfs/file.c
@@ -1288,7 +1288,7 @@ static ssize_t reiserfs_file_write(struc
 	loff_t pos;		// Current position in the file.
 	ssize_t res;		// return value of various functions that we call.
 	int err = 0;
-	struct inode *inode = file->f_dentry->d_inode;	// Inode of the file that we are writing to.
+	struct inode *inode = file->f_path.dentry->d_inode;	// Inode of the file that we are writing to.
 	/* To simplify coding at this time, we store
 	   locked pages in array for now */
 	struct page *prepared_pages[REISERFS_WRITE_PAGES_AT_A_TIME];
@@ -1335,7 +1335,7 @@ static ssize_t reiserfs_file_write(struc
 	if (count == 0)
 		goto out;
 
-	res = remove_suid(file->f_dentry);
+	res = remove_suid(file->f_path.dentry);
 	if (res)
 		goto out;
 
diff -puN fs/reiserfs/ioctl.c~struct-path-convert-reiserfs fs/reiserfs/ioctl.c
--- a/fs/reiserfs/ioctl.c~struct-path-convert-reiserfs
+++ a/fs/reiserfs/ioctl.c
@@ -99,7 +99,7 @@ int reiserfs_ioctl(struct inode *inode, 
 long reiserfs_compat_ioctl(struct file *file, unsigned int cmd,
 				unsigned long arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	/* These are just misnamed, they actually get/put from/to user an int */
diff -puN fs/reiserfs/procfs.c~struct-path-convert-reiserfs fs/reiserfs/procfs.c
--- a/fs/reiserfs/procfs.c~struct-path-convert-reiserfs
+++ a/fs/reiserfs/procfs.c
@@ -295,7 +295,7 @@ static int show_oidmap(struct seq_file *
 	}
 #if defined( REISERFS_USE_OIDMAPF )
 	if (sb_info->oidmap.use_file && (sb_info->oidmap.mapf != NULL)) {
-		loff_t size = sb_info->oidmap.mapf->f_dentry->d_inode->i_size;
+		loff_t size = sb_info->oidmap.mapf->f_path.dentry->d_inode->i_size;
 		total_used += size / sizeof(reiserfs_oidinterval_d_t);
 	}
 #endif
diff -puN fs/reiserfs/xattr.c~struct-path-convert-reiserfs fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~struct-path-convert-reiserfs
+++ a/fs/reiserfs/xattr.c
@@ -274,7 +274,7 @@ static struct file *open_xa_file(const s
  */
 static int __xattr_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cpu_key pos_key;	/* key of current position in the directory (key of directory entry) */
 	INITIALIZE_PATH(path_to_entry);
 	struct buffer_head *bh;
@@ -420,7 +420,7 @@ static int __xattr_readdir(struct file *
 static
 int xattr_readdir(struct file *file, filldir_t filler, void *buf)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
 	if (!file->f_op || !file->f_op->readdir)
 		goto out;
@@ -508,7 +508,7 @@ reiserfs_xattr_set(struct inode *inode, 
 		goto out;
 	}
 
-	xinode = fp->f_dentry->d_inode;
+	xinode = fp->f_path.dentry->d_inode;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* we need to copy it off.. */
@@ -527,7 +527,7 @@ reiserfs_xattr_set(struct inode *inode, 
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 	mutex_lock(&xinode->i_mutex);
-	err = notify_change(fp->f_dentry, &newattrs);
+	err = notify_change(fp->f_path.dentry, &newattrs);
 	if (err)
 		goto out_filp;
 
@@ -626,7 +626,7 @@ reiserfs_xattr_get(const struct inode *i
 		goto out;
 	}
 
-	xinode = fp->f_dentry->d_inode;
+	xinode = fp->f_path.dentry->d_inode;
 	isize = xinode->i_size;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

