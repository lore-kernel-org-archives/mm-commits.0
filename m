From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 11 Oct 2016 13:58:40 -0700
Message-ID: <57fd5280.9lAIJwc2vU83m4DU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38511 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753781AbcJKU6l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:58:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

