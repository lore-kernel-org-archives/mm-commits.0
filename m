From: akpm@linux-foundation.org
Subject: [merged]
 fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch removed from -mm tree
Date: Mon, 09 Jun 2014 12:32:37 -0700
Message-ID: <53960bd5.20oPFYX4GUjxe83C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaFITch (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:32:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, dushistov@mail.ru, fabf@skynet.be

Subject: [merged] fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch removed from -mm tree
To: fabf@skynet.be,dushistov@mail.ru,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:32:37 -0700


The patch titled
     Subject: fs/ufs/balloc.c: remove err parameter in ufs_add_fragments
has been removed from the -mm tree.  Its filename was
     fs-ufs-ballocc-remove-err-parameter-in-ufs_add_fragments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

