From: akpm@osdl.org
Subject: - ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:44 -0800
Message-ID: <200612082001.kB8K1ixr001897@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56928 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426231AbWLHUB6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     ext3: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the ext3
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/dir.c   |    8 ++++----
 fs/ext3/file.c  |    2 +-
 fs/ext3/ioctl.c |    2 +-
 fs/ext3/namei.c |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/ext3/dir.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ext3/dir.c
@@ -103,7 +103,7 @@ static int ext3_readdir(struct file * fi
 	struct ext3_dir_entry_2 *de;
 	struct super_block *sb;
 	int err;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	int ret = 0;
 
 	sb = inode->i_sb;
@@ -122,7 +122,7 @@ static int ext3_readdir(struct file * fi
 		 * We don't set the inode dirty flag since it's not
 		 * critical that it get flushed back to the disk.
 		 */
-		EXT3_I(filp->f_dentry->d_inode)->i_flags &= ~EXT3_INDEX_FL;
+		EXT3_I(filp->f_path.dentry->d_inode)->i_flags &= ~EXT3_INDEX_FL;
 	}
 #endif
 	stored = 0;
@@ -402,7 +402,7 @@ static int call_filldir(struct file * fi
 {
 	struct dir_private_info *info = filp->private_data;
 	loff_t	curr_pos;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block * sb;
 	int error;
 
@@ -432,7 +432,7 @@ static int ext3_dx_readdir(struct file *
 			 void * dirent, filldir_t filldir)
 {
 	struct dir_private_info *info = filp->private_data;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct fname *fname;
 	int	ret;
 
diff -puN fs/ext3/file.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ext3/file.c
--- a/fs/ext3/file.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ext3/file.c
@@ -52,7 +52,7 @@ ext3_file_write(struct kiocb *iocb, cons
 		unsigned long nr_segs, loff_t pos)
 {
 	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	ssize_t ret;
 	int err;
 
diff -puN fs/ext3/ioctl.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ext3/ioctl.c
--- a/fs/ext3/ioctl.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ext3/ioctl.c
@@ -257,7 +257,7 @@ flags_err:
 #ifdef CONFIG_COMPAT
 long ext3_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	/* These are just misnamed, they actually get/put from/to user an int */
diff -puN fs/ext3/namei.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ext3/namei.c
--- a/fs/ext3/namei.c~ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ext3/namei.c
@@ -602,7 +602,7 @@ int ext3_htree_fill_tree(struct file *di
 
 	dxtrace(printk("In htree_fill_tree, start hash: %x:%x\n", start_hash,
 		       start_minor_hash));
-	dir = dir_file->f_dentry->d_inode;
+	dir = dir_file->f_path.dentry->d_inode;
 	if (!(EXT3_I(dir)->i_flags & EXT3_INDEX_FL)) {
 		hinfo.hash_version = EXT3_SB(dir->i_sb)->s_def_hash_version;
 		hinfo.seed = EXT3_SB(dir->i_sb)->s_hash_seed;
@@ -613,7 +613,7 @@ int ext3_htree_fill_tree(struct file *di
 	}
 	hinfo.hash = start_hash;
 	hinfo.minor_hash = 0;
-	frame = dx_probe(NULL, dir_file->f_dentry->d_inode, &hinfo, frames, &err);
+	frame = dx_probe(NULL, dir_file->f_path.dentry->d_inode, &hinfo, frames, &err);
 	if (!frame)
 		return err;
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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

