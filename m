From: akpm@linux-foundation.org
Subject: + page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch added to -mm tree
Date: Thu, 12 Nov 2009 12:34:50 -0800
Message-ID: <200911122034.nACKYojm002969@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753435AbZKLUfs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Nov 2009 15:35:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, cl@linux-foundation.org, elendil@planet.nl, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     page allocator: wait on both sync and async congestion after direct reclaim
has been added to the -mm tree.  Its filename is
     page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch

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
@@ -737,22 +737,41 @@ EXPORT_SYMBOL(set_bdi_congested);
 
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
@@ -1733,7 +1733,7 @@ __alloc_pages_high_priority(gfp_t gfp_ma
 			preferred_zone, migratetype);
 
 		if (!page && gfp_mask & __GFP_NOFAIL)
-			congestion_wait(BLK_RW_ASYNC, HZ/50);
+			congestion_wait(BLK_RW_BOTH, HZ/50);
 	} while (!page && (gfp_mask & __GFP_NOFAIL));
 
 	return page;
@@ -1904,7 +1904,7 @@ rebalance:
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
@@ -1797,7 +1797,7 @@ static unsigned long do_try_to_free_page
 
 		/* Take a nap, wait for some writeback to complete */
 		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
-			congestion_wait(BLK_RW_ASYNC, HZ/10);
+			congestion_wait(BLK_RW_BOTH, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scanning_global_lru(sc))
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-always-wake-kswapd-when-restarting-an-allocation-attempt-after-direct-reclaim-failed.patch
page-allocator-do-not-allow-interrupts-to-use-alloc_harder.patch
linux-next.patch
mm-add-notifier-in-pageblock-isolation-for-balloon-drivers.patch
powerpc-make-the-cmm-memory-hotplug-aware.patch
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
vmscan-take-order-into-consideration-when-deciding-if-kswapd-is-in-trouble.patch
add-debugging-aid-for-memory-initialisation-problems.patch

