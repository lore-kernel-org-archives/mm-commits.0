From: akpm@osdl.org
Subject: - ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:42 -0800
Message-ID: <200612082001.kB8K1gne001894@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56902 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426211AbWLHUBw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     ext2: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext2: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the ext2
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/dir.c   |    2 +-
 fs/ext2/ioctl.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/ext2/dir.c~ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ext2/dir.c
@@ -248,7 +248,7 @@ static int
 ext2_readdir (struct file * filp, void * dirent, filldir_t filldir)
 {
 	loff_t pos = filp->f_pos;
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct super_block *sb = inode->i_sb;
 	unsigned int offset = pos & ~PAGE_CACHE_MASK;
 	unsigned long n = pos >> PAGE_CACHE_SHIFT;
diff -puN fs/ext2/ioctl.c~ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/ext2/ioctl.c
--- a/fs/ext2/ioctl.c~ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/ext2/ioctl.c
@@ -90,7 +90,7 @@ int ext2_ioctl (struct inode * inode, st
 #ifdef CONFIG_COMPAT
 long ext2_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	/* These are just misnamed, they actually get/put from/to user an int */
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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

