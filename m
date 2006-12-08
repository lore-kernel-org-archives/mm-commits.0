From: akpm@osdl.org
Subject: - fat-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:48 -0800
Message-ID: <200612082001.kB8K1mdq001903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56973 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761159AbWLHUCP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     fat: change uses of f_{dentry,vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     fat-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fat: change uses of f_{dentry,vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the fat
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/fat/dir.c  |    6 +++---
 fs/fat/file.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/fat/dir.c~fat-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/fat/dir.c
--- a/fs/fat/dir.c~fat-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/fat/dir.c
@@ -579,7 +579,7 @@ parse_record:
 	if (!memcmp(de->name, MSDOS_DOT, MSDOS_NAME))
 		inum = inode->i_ino;
 	else if (!memcmp(de->name, MSDOS_DOTDOT, MSDOS_NAME)) {
-		inum = parent_ino(filp->f_dentry);
+		inum = parent_ino(filp->f_path.dentry);
 	} else {
 		loff_t i_pos = fat_make_i_pos(sb, bh, de);
 		struct inode *tmp = fat_iget(sb, i_pos);
@@ -643,7 +643,7 @@ out:
 
 static int fat_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode *inode = filp->f_dentry->d_inode;
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	return __fat_readdir(inode, filp, dirent, filldir, 0, 0);
 }
 
@@ -782,7 +782,7 @@ static long fat_compat_dir_ioctl(struct 
 
 	set_fs(KERNEL_DS);
 	lock_kernel();
-	ret = fat_dir_ioctl(file->f_dentry->d_inode, file,
+	ret = fat_dir_ioctl(file->f_path.dentry->d_inode, file,
 			    cmd, (unsigned long) &d);
 	unlock_kernel();
 	set_fs(oldfs);
diff -puN fs/fat/file.c~fat-change-uses-of-f_dentryvfsmnt-to-use-f_path fs/fat/file.c
--- a/fs/fat/file.c~fat-change-uses-of-f_dentryvfsmnt-to-use-f_path
+++ a/fs/fat/file.c
@@ -92,7 +92,7 @@ int fat_generic_ioctl(struct inode *inod
 		}
 
 		/* This MUST be done before doing anything irreversible... */
-		err = notify_change(filp->f_dentry, &ia);
+		err = notify_change(filp->f_path.dentry, &ia);
 		if (err)
 			goto up;
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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

