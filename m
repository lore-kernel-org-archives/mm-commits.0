From: akpm@linux-foundation.org
Subject: [merged] mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:45:58 -0800
Message-ID: <201101142248.p0EMmm63005235@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752525Ab1ANWtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, dave@linux.vnet.ibm.com, emunson@mgebm.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     mm: kswapd: use the order that kswapd was reclaiming at for sleeping_prematurely()
has been removed from the -mm tree.  Its filename was
     mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: kswapd: use the order that kswapd was reclaiming at for sleeping_prematurely()
From: Mel Gorman <mel@csn.ul.ie>

Before kswapd goes to sleep, it uses sleeping_prematurely() to check if
there was a race pushing a zone below its watermark.  If the race
happened, it stays awake.  However, balance_pgdat() can decide to reclaim
at order-0 if it decides that high-order reclaim is not working as
expected.  This information is not passed back to sleeping_prematurely(). 
The impact is that kswapd remains awake reclaiming pages long after it
should have gone to sleep.  This patch passes the adjusted order to
sleeping_prematurely and uses the same logic as balance_pgdat to decide if
it's ok to go to sleep.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Cc: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely
+++ a/mm/vmscan.c
@@ -2227,7 +2227,7 @@ static bool pgdat_balanced(pg_data_t *pg
 }
 
 /* is kswapd sleeping prematurely? */
-static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
+static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
 {
 	int i;
 	unsigned long balanced = 0;
@@ -2237,7 +2237,7 @@ static int sleeping_prematurely(pg_data_
 	if (remaining)
 		return 1;
 
-	/* If after HZ/10, a zone is below the high mark, it's premature */
+	/* Check the watermark levels */
 	for (i = 0; i < pgdat->nr_zones; i++) {
 		struct zone *zone = pgdat->node_zones + i;
 
@@ -2269,7 +2269,7 @@ static int sleeping_prematurely(pg_data_
  * For kswapd, balance_pgdat() will work across all this node's zones until
  * they are all at high_wmark_pages(zone).
  *
- * Returns the number of pages which were actually freed.
+ * Returns the final order kswapd was reclaiming at
  *
  * There is special handling here for zones which are full of pinned pages.
  * This can happen if the pages are all mlocked, or if they are all used by
@@ -2532,7 +2532,13 @@ out:
 		}
 	}
 
-	return sc.nr_reclaimed;
+	/*
+	 * Return the order we were reclaiming at so sleeping_prematurely()
+	 * makes a decision on the order we were last reclaiming at. However,
+	 * if another caller entered the allocator slow path while kswapd
+	 * was awake, order will remain at the higher level
+	 */
+	return order;
 }
 
 static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
@@ -2659,7 +2665,7 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			balance_pgdat(pgdat, order, classzone_idx);
+			order = balance_pgdat(pgdat, order, classzone_idx);
 		}
 	}
 	return 0;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
writeback-io-less-balance_dirty_pages.patch
writeback-consolidate-variable-names-in-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages.patch
writeback-per-task-rate-limit-on-balance_dirty_pages-fix.patch
writeback-prevent-duplicate-balance_dirty_pages_ratelimited-calls.patch
writeback-account-per-bdi-accumulated-written-pages.patch
writeback-bdi-write-bandwidth-estimation.patch
writeback-bdi-write-bandwidth-estimation-fix.patch
writeback-show-bdi-write-bandwidth-in-debugfs.patch
writeback-quit-throttling-when-bdi-dirty-pages-dropped-low.patch
writeback-reduce-per-bdi-dirty-threshold-ramp-up-time.patch
writeback-make-reasonable-gap-between-the-dirty-background-thresholds.patch
writeback-scale-down-max-throttle-bandwidth-on-concurrent-dirtiers.patch
writeback-add-trace-event-for-balance_dirty_pages.patch
writeback-make-nr_to_write-a-per-file-limit.patch
writeback-make-nr_to_write-a-per-file-limit-fix.patch
thp-add-pagetranscompound.patch
add-debugging-aid-for-memory-initialisation-problems.patch

