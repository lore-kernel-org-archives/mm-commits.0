From: akpm@osdl.org
Subject: - affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:10 -0800
Message-ID: <200612082002.kB8K2A68001951@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57041 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426243AbWLHUCl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     affs: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: affs: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the affs
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/affs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/affs/dir.c~affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path fs/affs/dir.c
--- a/fs/affs/dir.c~affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path
+++ a/fs/affs/dir.c
@@ -41,7 +41,7 @@ struct inode_operations affs_dir_inode_o
 static int
 affs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 {
-	struct inode		*inode = filp->f_dentry->d_inode;
+	struct inode		*inode = filp->f_path.dentry->d_inode;
 	struct super_block	*sb = inode->i_sb;
 	struct buffer_head	*dir_bh;
 	struct buffer_head	*fh_bh;
@@ -71,7 +71,7 @@ affs_readdir(struct file *filp, void *di
 		stored++;
 	}
 	if (f_pos == 1) {
-		if (filldir(dirent, "..", 2, f_pos, parent_ino(filp->f_dentry), DT_DIR) < 0)
+		if (filldir(dirent, "..", 2, f_pos, parent_ino(filp->f_path.dentry), DT_DIR) < 0)
 			return stored;
 		filp->f_pos = f_pos = 2;
 		stored++;
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

