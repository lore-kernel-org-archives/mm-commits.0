From: akpm@linux-foundation.org
Subject: + sys_swapon-remove-bdev-variable.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:06 -0800
Message-ID: <201103072210.p27MA7uL030007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab1CGWOr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:14:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     sys_swapon: remove bdev variable
has been added to the -mm tree.  Its filename is
     sys_swapon-remove-bdev-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sys_swapon: remove bdev variable
From: Cesar Eduardo Barros <cesarb@cesarb.net>

The bdev variable is always equivalent to (S_ISBLK(inode->i_mode) ?
p->bdev : NULL), as long as it being set is moved to a bit earlier. Use
this fact to remove the bdev variable.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-remove-bdev-variable mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-remove-bdev-variable
+++ a/mm/swapfile.c
@@ -1893,7 +1893,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 {
 	struct swap_info_struct *p;
 	char *name;
-	struct block_device *bdev = NULL;
 	struct file *swap_file = NULL;
 	struct address_space *mapping;
 	int i, prev;
@@ -1944,19 +1943,19 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 
 	if (S_ISBLK(inode->i_mode)) {
-		bdev = bdgrab(I_BDEV(inode));
-		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
+		p->bdev = bdgrab(I_BDEV(inode));
+		error = blkdev_get(p->bdev,
+				   FMODE_READ | FMODE_WRITE | FMODE_EXCL,
 				   sys_swapon);
 		if (error < 0) {
-			bdev = NULL;
+			p->bdev = NULL;
 			error = -EINVAL;
 			goto bad_swap;
 		}
-		p->old_block_size = block_size(bdev);
-		error = set_blocksize(bdev, PAGE_SIZE);
+		p->old_block_size = block_size(p->bdev);
+		error = set_blocksize(p->bdev, PAGE_SIZE);
 		if (error < 0)
 			goto bad_swap;
-		p->bdev = bdev;
 		p->flags |= SWP_BLKDEV;
 	} else if (S_ISREG(inode->i_mode)) {
 		p->bdev = inode->i_sb->s_bdev;
@@ -2140,9 +2139,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	error = 0;
 	goto out;
 bad_swap:
-	if (bdev) {
-		set_blocksize(bdev, p->old_block_size);
-		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+	if (S_ISBLK(inode->i_mode) && p->bdev) {
+		set_blocksize(p->bdev, p->old_block_size);
+		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 	}
 	destroy_swap_extents(p);
 	swap_cgroup_swapoff(p->type);
_

Patches currently in -mm which might be from cesarb@cesarb.net are

sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-do-not-depend-on-type-after-allocation.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-did_down-variable.patch
sys_swapon-remove-bdev-variable.patch
sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch
sys_swapon-use-a-single-error-label.patch
sys_swapon-separate-bdev-claim-and-inode-lock.patch
sys_swapon-simplify-error-flow-in-claim_swapfile.patch
sys_swapon-move-setting-of-swapfilepages-near-use.patch
sys_swapon-separate-parsing-of-swapfile-header.patch
sys_swapon-simplify-error-flow-in-read_swap_header.patch
sys_swapon-call-swap_cgroup_swapon-earlier.patch
sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch
sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch
sys_swapon-remove-nr_good_pages-variable.patch
sys_swapon-move-printk-outside-lock.patch
sys_swapoff-change-order-to-match-sys_swapon.patch
sys_swapon-separate-final-enabling-of-the-swapfile.patch

