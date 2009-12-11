From: akpm@linux-foundation.org
Subject: [obsolete] page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch removed from -mm tree
Date: Thu, 10 Dec 2009 21:45:06 -0800
Message-ID: <200912110545.nBB5j6oL019393@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbZLKFqj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Dec 2009 00:46:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, cl@linux-foundation.org, elendil@planet.nl, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     page allocator: wait on both sync and async congestion after direct reclaim
has been removed from the -mm tree.  Its filename was
     page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: wait on both sync and async congestion after direct reclaim
From: Mel Gorman <mel@csn.ul.ie>

Testing by Frans Pop indicated that in the 2.6.30..2.6.31 window at least
that the commits 373c0a7e 8aa7e847 dramatically increased the number of
GFP_ATOMIC failures that were occuring within a wireless driver. 
Reverting this patch seemed to help a lot even though it was pointed out
that the congestion changes were very far away from high-order atomic
allocations.

The key to why the revert makes such a big difference is down to timing
and how long direct reclaimers wait versus kswapd.  With the patch
reverted, the congestion_wait() is on the SYNC queue instead of the ASYNC.
 As a significant part of the workload involved reads, it makes sense that
the SYNC list is what was truely congested and with the revert processes
were waiting on congestion as expected.  Hence, direct reclaimers stalled
properly and kswapd was able to do its job with fewer stalls.

This patch aims to fix the congestion_wait() behaviour for SYNC and ASYNC
for direct reclaimers.  Instead of making the congestion_wait() on the
SYNC queue which would only fix a particular type of workload, this patch
adds a third type of congestion_wait - BLK_RW_BOTH which first waits on
the ASYNC and then the SYNC queue if the timeout has not been reached.  In
tests, this counter-intuitively results in kswapd stalling less and
freeing up pages resulting in fewer allocation failures and fewer
direct-reclaim-orientated stalls.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    1 +
 mm/backing-dev.c            |   25 ++++++++++++++++++++++---
 mm/page_alloc.c             |    4 ++--
 mm/vmscan.c                 |    2 +-
 4 files changed, 26 insertions(+), 6 deletions(-)

diff -puN include/linux/backing-dev.h~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim
+++ a/include/linux/backing-dev.h
@@ -276,6 +276,7 @@ static inline int bdi_rw_congested(struc
 enum {
 	BLK_RW_ASYNC	= 0,
 	BLK_RW_SYNC	= 1,
+	BLK_RW_BOTH	= 2,
 };
 
 void clear_bdi_congested(struct backing_dev_info *bdi, int sync);
diff -puN mm/backing-dev.c~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim mm/backing-dev.c
--- a/mm/backing-dev.c~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim
+++ a/mm/backing-dev.c
@@ -741,22 +741,41 @@ EXPORT_SYMBOL(set_bdi_congested);
 
 /**
  * congestion_wait - wait for a backing_dev to become uncongested
- * @sync: SYNC or ASYNC IO
+ * @sync: SYNC, ASYNC or BOTH IO
  * @timeout: timeout in jiffies
  *
  * Waits for up to @timeout jiffies for a backing_dev (any backing_dev) to exit
  * write congestion.  If no backing_devs are congested then just wait for the
  * next write to be completed.
  */
-long congestion_wait(int sync, long timeout)
+long congestion_wait(int sync_request, long timeout)
 {
 	long ret;
 	DEFINE_WAIT(wait);
-	wait_queue_head_t *wqh = &congestion_wqh[sync];
+	int sync;
+	wait_queue_head_t *wqh;
+
+	/* If requested to sync both, wait on ASYNC first, then SYNC */
+	if (sync_request == BLK_RW_BOTH)
+		sync = BLK_RW_ASYNC;
+	else
+		sync = sync_request;
+
+again:
+	wqh = &congestion_wqh[sync];
 
 	prepare_to_wait(wqh, &wait, TASK_UNINTERRUPTIBLE);
 	ret = io_schedule_timeout(timeout);
 	finish_wait(wqh, &wait);
+
+	if (sync_request == BLK_RW_BOTH) {
+		sync_request = 0;
+		sync = BLK_RW_SYNC;
+		timeout = ret;
+		if (timeout)
+			goto again;
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait);
diff -puN mm/page_alloc.c~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim
+++ a/mm/page_alloc.c
@@ -1743,7 +1743,7 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 			preferred_zone, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
-			congestion_wait(BLK_RW_ASYNC, HZ/50);
+			congestion_wait(BLK_RW_BOTH, HZ/50);
 	} while (!page && (gfp_mask & __GFP_NOFAIL));
 
 	return page;
@@ -1914,7 +1914,7 @@ rebalance:
 	pages_reclaimed += did_some_progress;
 	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
+		congestion_wait(BLK_RW_BOTH, HZ/50);
 		goto rebalance;
 	}
 
diff -puN mm/vmscan.c~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim mm/vmscan.c
--- a/mm/vmscan.c~page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim
+++ a/mm/vmscan.c
@@ -1793,7 +1793,7 @@ static unsigned long do_try_to_free_page
 
 		/* Take a nap, wait for some writeback to complete */
 		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
-			congestion_wait(BLK_RW_ASYNC, HZ/10);
+			congestion_wait(BLK_RW_BOTH, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scanning_global_lru(sc))
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
powerpc-make-the-cmm-memory-hotplug-aware-update.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
nodemask-make-nodemask_alloc-more-general.patch
hugetlb-rework-hstate_next_node_-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions.patch
hugetlb-add-nodemask-arg-to-huge-page-alloc-free-and-surplus-adjust-functions-fix.patch
hugetlb-factor-init_nodemask_of_node.patch
hugetlb-derive-huge-pages-nodes-allowed-from-task-mempolicy.patch
hugetlb-add-generic-definition-of-numa_no_node.patch
hugetlb-add-per-node-hstate-attributes.patch
hugetlb-update-hugetlb-documentation-for-numa-controls.patch
hugetlb-use-only-nodes-with-memory-for-huge-pages.patch
mm-clear-node-in-n_high_memory-and-stop-kswapd-when-all-memory-is-offlined.patch
hugetlb-handle-memory-hot-plug-events.patch
hugetlb-offload-per-node-attribute-registrations.patch
mm-add-gfp-flags-for-nodemask_alloc-slab-allocations.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
vmscan-stop-kswapd-waiting-on-congestion-when-the-min-watermark-is-not-being-met-v2.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep-fix-1.patch
vmscan-separate-scswap_cluster_max-and-scnr_max_reclaim.patch
vmscan-kill-hibernation-specific-reclaim-logic-and-unify-it.patch
vmscan-zone_reclaim-dont-use-insane-swap_cluster_max.patch
vmscan-kill-scswap_cluster_max.patch
vmscan-make-consistent-of-reclaim-bale-out-between-do_try_to_free_page-and-shrink_zone.patch
ksm-fix-mlockfreed-to-munlocked.patch
hugetlb-prevent-deadlock-in-__unmap_hugepage_range-when-alloc_huge_page-fails-2.patch
hugetlb-acquire-the-i_mmap_lock-before-walking-the-prio_tree-to-unmap-a-page-v2.patch
hugetlb-abort-a-hugepage-pool-resize-if-a-signal-is-pending.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch
add-debugging-aid-for-memory-initialisation-problems.patch

