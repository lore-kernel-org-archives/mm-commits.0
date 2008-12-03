From: akpm@linux-foundation.org
Subject: + swapfile-let-others-seed-random.patch added to -mm tree
Date: Tue, 02 Dec 2008 16:48:48 -0800
Message-ID: <200812030048.mB30mmNJ019681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56045 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751505AbYLCAto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 19:49:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx, nickpiggin@yahoo.com.au, teheo@suse.de


The patch titled
     swapfile: let others seed random
has been added to the -mm tree.  Its filename is
     swapfile-let-others-seed-random.patch

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
Subject: swapfile: let others seed random
From: Hugh Dickins <hugh@veritas.com>

Remove the srandom32((u32)get_seconds()) from non-rotational swapon:
there's been a coincidental discussion of earlier randomization, assume
that goes ahead, let swapon be a client rather than stirring for itself.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Donjun Shin <djshin90@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Joern Engel <joern@logfs.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Tejun Heo <teheo@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/swapfile.c~swapfile-let-others-seed-random mm/swapfile.c
--- a/mm/swapfile.c~swapfile-let-others-seed-random
+++ a/mm/swapfile.c
@@ -1842,7 +1842,6 @@ asmlinkage long sys_swapon(const char __
 
 	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		p->flags |= SWP_SOLIDSTATE;
-		srandom32((u32)get_seconds());
 		p->cluster_next = 1 + (random32() % p->highest_bit);
 	}
 	if (discard_swap(p) == 0)
_

Patches currently in -mm which might be from hugh@veritas.com are

ksym_symbol_len-fixes.patch
linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
swapfile-change-discard-pgoff_t-to-sector_t.patch
swapfile-change-discard-pgoff_t-to-sector_t-fix.patch
swapfile-let-others-seed-random.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

