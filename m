From: akpm@linux-foundation.org
Subject: + swapfile-swapon-randomize-if-nonrot.patch added to -mm tree
Date: Tue, 25 Nov 2008 17:23:52 -0800
Message-ID: <200811260123.mAQ1NqKW008700@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936AbYKZBYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:24:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx, nickpiggin@yahoo.com.au, teheo@suse.de


The patch titled
     swapfile: swapon randomize if nonrot
has been added to the -mm tree.  Its filename is
     swapfile-swapon-randomize-if-nonrot.patch

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
Subject: swapfile: swapon randomize if nonrot
From: Hugh Dickins <hugh@veritas.com>

Swap allocation has always started from the beginning of the swap area;
but if we're dealing with a solidstate swap device which can only remap
blocks within limited zones, that would sooner wear out the first zone.

Therefore sys_swapon() test whether blk_queue is non-rotational, and if so
randomize the cluster_next starting position for allocation.

If blk_queue is nonrot, note SWP_SOLIDSTATE for later use, and report it
with an "SS" at the right end of the kernel's "Adding ...  swap" message
(so that if it's both nonrot and discardable, "SSD" will be shown there). 
Perhaps something should be shown in /proc/swaps (swapon -s), but we have
to be more cautious before making any addition to that format.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Joern Engel <joern@logfs.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Donjun Shin <djshin90@gmail.com>
Cc: Tejun Heo <teheo@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 +
 mm/swapfile.c        |   11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~swapfile-swapon-randomize-if-nonrot include/linux/swap.h
--- a/include/linux/swap.h~swapfile-swapon-randomize-if-nonrot
+++ a/include/linux/swap.h
@@ -122,6 +122,7 @@ enum {
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
 	SWP_DISCARDABLE = (1 << 2),	/* blkdev supports discard */
 	SWP_DISCARDING	= (1 << 3),	/* now discarding a free cluster */
+	SWP_SOLIDSTATE	= (1 << 4),	/* blkdev seeks are cheap */
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
diff -puN mm/swapfile.c~swapfile-swapon-randomize-if-nonrot mm/swapfile.c
--- a/mm/swapfile.c~swapfile-swapon-randomize-if-nonrot
+++ a/mm/swapfile.c
@@ -16,6 +16,7 @@
 #include <linux/namei.h>
 #include <linux/shm.h>
 #include <linux/blkdev.h>
+#include <linux/random.h>
 #include <linux/writeback.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -1797,6 +1798,11 @@ asmlinkage long sys_swapon(const char __
 		goto bad_swap;
 	}
 
+	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+		p->flags |= SWP_SOLIDSTATE;
+		srandom32((u32)get_seconds());
+		p->cluster_next = 1 + (random32() % p->highest_bit);
+	}
 	if (discard_swap(p) == 0)
 		p->flags |= SWP_DISCARDABLE;
 
@@ -1813,10 +1819,11 @@ asmlinkage long sys_swapon(const char __
 	total_swap_pages += nr_good_pages;
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
-			"Priority:%d extents:%d across:%lluk%s\n",
+			"Priority:%d extents:%d across:%lluk %s%s\n",
 		nr_good_pages<<(PAGE_SHIFT-10), name, p->prio,
 		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
-		(p->flags & SWP_DISCARDABLE) ? " D" : "");
+		(p->flags & SWP_SOLIDSTATE) ? "SS" : "",
+		(p->flags & SWP_DISCARDABLE) ? "D" : "");
 
 	/* insert swap space into swap_list: */
 	prev = -1;
_

Patches currently in -mm which might be from hugh@veritas.com are

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
make-get_user_pages-interruptible.patch
make-get_user_pages-interruptible-update.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

