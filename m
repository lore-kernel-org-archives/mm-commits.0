From: akpm@linux-foundation.org
Subject: + fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
 added to -mm tree
Date: Thu, 24 Apr 2014 10:47:11 -0700
Message-ID: <53594e1f.rXJY0if3Z7IDvJcK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbaDXRrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Apr 2014 13:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be

Subject: + fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch added to -mm tree
To: fabf@skynet.be,dushistov@mail.ru
From: akpm@linux-foundation.org
Date: Thu, 24 Apr 2014 10:47:11 -0700


The patch titled
     Subject: fs/ufs/balloc.c: remove err parameter in ufs_add_fragments
has been added to the -mm tree.  Its filename is
     fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/ufs/balloc.c: remove err parameter in ufs_add_fragments

err is used in ufs_new_fragments (ufs_add_fragments only callsite)
not in ufs_add_fragments.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/balloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/ufs/balloc.c~fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments fs/ufs/balloc.c
--- a/fs/ufs/balloc.c~fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments
+++ a/fs/ufs/balloc.c
@@ -24,7 +24,7 @@
 
 #define INVBLOCK ((u64)-1L)
 
-static u64 ufs_add_fragments(struct inode *, u64, unsigned, unsigned, int *);
+static u64 ufs_add_fragments(struct inode *, u64, unsigned, unsigned);
 static u64 ufs_alloc_fragments(struct inode *, unsigned, u64, unsigned, int *);
 static u64 ufs_alloccg_block(struct inode *, struct ufs_cg_private_info *, u64, int *);
 static u64 ufs_bitmap_search (struct super_block *, struct ufs_cg_private_info *, u64, unsigned);
@@ -432,7 +432,7 @@ u64 ufs_new_fragments(struct inode *inod
 	/*
 	 * resize block
 	 */
-	result = ufs_add_fragments (inode, tmp, oldcount, newcount, err);
+	result = ufs_add_fragments(inode, tmp, oldcount, newcount);
 	if (result) {
 		*err = 0;
 		UFS_I(inode)->i_lastfrag = max(UFS_I(inode)->i_lastfrag,
@@ -491,7 +491,7 @@ u64 ufs_new_fragments(struct inode *inod
 }		
 
 static u64 ufs_add_fragments(struct inode *inode, u64 fragment,
-			     unsigned oldcount, unsigned newcount, int *err)
+			     unsigned oldcount, unsigned newcount)
 {
 	struct super_block * sb;
 	struct ufs_sb_private_info * uspi;
_

Patches currently in -mm which might be from fabf@skynet.be are

ntfs-remove-null-value-assignments.patch
ocfs2-remove-null-assignments-on-static.patch
fs-ocfs2-superc-use-ocfs2_max_vol_label_len-and-strlcpy.patch
fs-9p-v9fsc-add-__init-to-v9fs_sysfs_init.patch
sys_sgetmask-sys_ssetmask-add-config_sgetmask_syscall.patch
fs-binfmt_elfc-fix-bool-assignements.patch
fs-autofs4-dev-ioctlc-add-__init-to-autofs_dev_ioctl_init.patch
fs-befs-linuxvfsc-replace-strncpy-by-strlcpy.patch
fs-befs-btreec-replace-strncpy-by-strlcpy-coding-style-fixing.patch
fs-isofs-logging-clean-up.patch
fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch
fs-reiserfs-bitmapc-coding-style-fixes.patch
fs-affs-filec-remove-unnecessary-function-parameters.patch
fs-affs-convert-printk-to-pr_foo.patch
fs-affs-pr_debug-cleanup.patch
linux-next.patch
ufs-sb-mutex-merge-mutex_destroy.patch

