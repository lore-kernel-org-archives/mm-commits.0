From: akpm@osdl.org
Subject: - autofs-change-uses-of-f_dentry.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:12 -0800
Message-ID: <200612082002.kB8K2C9v001954@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57020 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761168AbWLHUC2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:02:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     autofs: change uses of f_{dentry, vfsmnt} to use f_path
has been removed from the -mm tree.  Its filename was
     autofs-change-uses-of-f_dentry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: autofs: change uses of f_{dentry, vfsmnt} to use f_path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Change all the uses of f_{dentry,vfsmnt} to f_path.{dentry,mnt} in the autofs
filesystem.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/autofs/root.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/autofs/root.c~autofs-change-uses-of-f_dentry fs/autofs/root.c
--- a/fs/autofs/root.c~autofs-change-uses-of-f_dentry
+++ a/fs/autofs/root.c
@@ -45,7 +45,7 @@ static int autofs_root_readdir(struct fi
 	struct autofs_dir_ent *ent = NULL;
 	struct autofs_dirhash *dirhash;
 	struct autofs_sb_info *sbi;
-	struct inode * inode = filp->f_dentry->d_inode;
+	struct inode * inode = filp->f_path.dentry->d_inode;
 	off_t onr, nr;
 
 	lock_kernel();
@@ -557,7 +557,7 @@ static int autofs_root_ioctl(struct inod
 	case AUTOFS_IOC_SETTIMEOUT:
 		return autofs_get_set_timeout(sbi, argp);
 	case AUTOFS_IOC_EXPIRE:
-		return autofs_expire_run(inode->i_sb, sbi, filp->f_vfsmnt,
+		return autofs_expire_run(inode->i_sb, sbi, filp->f_path.mnt,
 					 argp);
 	default:
 		return -ENOSYS;
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

