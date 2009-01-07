From: akpm@linux-foundation.org
Subject: - swapfile-swapon-randomize-if-nonrot.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:30 -0800
Message-ID: <200901072213.n07MDUko013541@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758852AbZAGWN4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx


The patch titled
     swapfile: swapon randomize if nonrot
has been removed from the -mm tree.  Its filename was
     swapfile-swapon-randomize-if-nonrot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1806,6 +1807,11 @@ asmlinkage long sys_swapon(const char __
 		goto bad_swap;
 	}
 
+	if (blk_queue_nonrot(bdev_get_queue(p->bdev))) {
+		p->flags |= SWP_SOLIDSTATE;
+		srandom32((u32)get_seconds());
+		p->cluster_next = 1 + (random32() % p->highest_bit);
+	}
 	if (discard_swap(p) == 0)
 		p->flags |= SWP_DISCARDABLE;
 
@@ -1822,10 +1828,11 @@ asmlinkage long sys_swapon(const char __
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

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

