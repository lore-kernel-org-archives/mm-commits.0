From: akpm@linux-foundation.org
Subject: + sys_swapon-move-setting-of-error-nearer-use.patch added to -mm tree
Date: Mon, 07 Mar 2011 14:10:02 -0800
Message-ID: <201103072210.p27MA2un029996@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755982Ab1CGWRJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 17:17:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cesarb@cesarb.net, emunson@mgebm.net, hughd@google.com, jj@chaosbits.net, kamezawa.hiroyu@jp.fujitsu.com, penberg@kernel.org


The patch titled
     sys_swapon: move setting of error nearer use
has been added to the -mm tree.  Its filename is
     sys_swapon-move-setting-of-error-nearer-use.patch

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
Subject: sys_swapon: move setting of error nearer use
From: Cesar Eduardo Barros <cesarb@cesarb.net>

Move the setting of the error variable nearer the goto in a few places.

Avoids calling PTR_ERR() if not IS_ERR() in two places, and makes the
error condition more explicit in two other places.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
Tested-by: Eric B Munson <emunson@mgebm.net>
Acked-by: Eric B Munson <emunson@mgebm.net>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN mm/swapfile.c~sys_swapon-move-setting-of-error-nearer-use mm/swapfile.c
--- a/mm/swapfile.c~sys_swapon-move-setting-of-error-nearer-use
+++ a/mm/swapfile.c
@@ -1917,14 +1917,14 @@ SYSCALL_DEFINE2(swapon, const char __use
 		return PTR_ERR(p);
 
 	name = getname(specialfile);
-	error = PTR_ERR(name);
 	if (IS_ERR(name)) {
+		error = PTR_ERR(name);
 		name = NULL;
 		goto bad_swap_2;
 	}
 	swap_file = filp_open(name, O_RDWR|O_LARGEFILE, 0);
-	error = PTR_ERR(swap_file);
 	if (IS_ERR(swap_file)) {
+		error = PTR_ERR(swap_file);
 		swap_file = NULL;
 		goto bad_swap_2;
 	}
@@ -1933,17 +1933,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 	mapping = swap_file->f_mapping;
 	inode = mapping->host;
 
-	error = -EBUSY;
 	for (i = 0; i < nr_swapfiles; i++) {
 		struct swap_info_struct *q = swap_info[i];
 
 		if (q == p || !q->swap_file)
 			continue;
-		if (mapping == q->swap_file->f_mapping)
+		if (mapping == q->swap_file->f_mapping) {
+			error = -EBUSY;
 			goto bad_swap;
+		}
 	}
 
-	error = -EINVAL;
 	if (S_ISBLK(inode->i_mode)) {
 		bdev = bdgrab(I_BDEV(inode));
 		error = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL,
@@ -1968,6 +1968,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 			goto bad_swap;
 		}
 	} else {
+		error = -EINVAL;
 		goto bad_swap;
 	}
 
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

