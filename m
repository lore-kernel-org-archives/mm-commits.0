From: akpm@linux-foundation.org
Subject: [obsolete] linux-next-git-rejects.patch removed from -mm tree
Date: Wed, 12 Oct 2016 12:07:37 -0700
Message-ID: <57fe89f9.DQeHwbjh/wsMFTKE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33051 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755382AbcJLTHw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been removed from the -mm tree.  Its filename was
     linux-next-git-rejects.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/overlayfs/super.c |    7 -------
 fs/ubifs/dir.c       |    4 ----
 2 files changed, 11 deletions(-)

diff -puN fs/overlayfs/super.c~linux-next-git-rejects fs/overlayfs/super.c
--- a/fs/overlayfs/super.c~linux-next-git-rejects
+++ a/fs/overlayfs/super.c
@@ -274,17 +274,10 @@ static bool ovl_is_opaquedir(struct dent
 	int res;
 	char val;
 
-<<<<<<< HEAD
-	if (!S_ISDIR(inode->i_mode) || !(inode->i_opflags & IOP_XATTR))
-		return false;
-
-	res = __vfs_getxattr(dentry, inode, OVL_XATTR_OPAQUE, &val, 1);
-=======
 	if (!d_is_dir(dentry))
 		return false;
 
 	res = vfs_getxattr(dentry, OVL_XATTR_OPAQUE, &val, 1);
->>>>>>> linux-next/akpm-base
 	if (res == 1 && val == 'y')
 		return true;
 
diff -puN fs/ubifs/dir.c~linux-next-git-rejects fs/ubifs/dir.c
--- a/fs/ubifs/dir.c~linux-next-git-rejects
+++ a/fs/ubifs/dir.c
@@ -1387,11 +1387,7 @@ const struct inode_operations ubifs_dir_
 	.mkdir       = ubifs_mkdir,
 	.rmdir       = ubifs_rmdir,
 	.mknod       = ubifs_mknod,
-<<<<<<< HEAD
-	.rename     = ubifs_rename,
-=======
 	.rename     = ubifs_rename2,
->>>>>>> linux-next/akpm-base
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
 	.listxattr   = ubifs_listxattr,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
b.patch

