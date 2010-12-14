From: akpm@linux-foundation.org
Subject: + mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch added to -mm tree
Date: Tue, 14 Dec 2010 14:47:44 -0800
Message-ID: <201012142247.oBEMljZB014518@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760127Ab0LNWs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 17:48:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, dave@linux.vnet.ibm.com, emunson@mgebm.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, sim@hostway.ca


The patch titled
     mm: kswapd: keep kswapd awake for high-order allocations until a percentage of the node is balanced
has been added to the -mm tree.  Its filename is
     mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch

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
Subject: mm: kswapd: keep kswapd awake for high-order allocations until a percentage of the node is balanced
From: Mel Gorman <mel@csn.ul.ie>

When reclaiming for high-orders, kswapd is responsible for balancing a
node but it should not reclaim excessively.  It avoids excessive reclaim
by considering if any zone in a node is balanced then the node is
balanced.  In the cases where there are imbalanced zone sizes (e.g. 
ZONE_DMA with both ZONE_DMA32 and ZONE_NORMAL), kswapd can go to sleep
prematurely as just one small zone was balanced.

This alters the sleep logic of kswapd slightly.  It counts the number of
pages that make up the balanced zones.  If the total number of balanced
pages is more than a quarter of the zone, kswapd will go back to sleep. 
This should keep a node balanced without reclaiming an excessive number of
pages.

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

 mm/vmscan.c |   58 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 49 insertions(+), 9 deletions(-)

diff -puN mm/vmscan.c~mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced
+++ a/mm/vmscan.c
@@ -2198,10 +2198,40 @@ unsigned long try_to_free_mem_cgroup_pag
 }
 #endif
 
+/*
+ * pgdat_balanced is used when checking if a node is balanced for high-order
+ * allocations. Only zones that meet watermarks and are in a zone allowed
+ * by the callers classzone_idx are added to balanced_pages. The total of
+ * balanced pages must be at least 25% of the zones allowed by classzone_idx
+ * for the node to be considered balanced. Forcing all zones to be balanced
+ * for high orders can cause excessive reclaim when there are imbalanced zones.
+ * The choice of 25% is due to
+ *   o a 16M DMA zone that is balanced will not balance a zone on any
+ *     reasonable sized machine
+ *   o On all other machines, the top zone must be at least a reasonable
+ *     precentage of the middle zones. For example, on 32-bit x86, highmem
+ *     would need to be at least 256M for it to be balance a whole node.
+ *     Similarly, on x86-64 the Normal zone would need to be at least 1G
+ *     to balance a node on its own. These seemed like reasonable ratios.
+ */
+static bool pgdat_balanced(pg_data_t *pgdat, unsigned long balanced_pages,
+						int classzone_idx)
+{
+	unsigned long present_pages = 0;
+	int i;
+
+	for (i = 0; i <= classzone_idx; i++)
+		present_pages += pgdat->node_zones[i].present_pages;
+
+	return balanced_pages > (present_pages >> 2);
+}
+
 /* is kswapd sleeping prematurely? */
 static int sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
 {
 	int i;
+	unsigned long balanced = 0;
+	bool all_zones_ok = true;
 
 	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
 	if (remaining)
@@ -2219,10 +2249,20 @@ static int sleeping_prematurely(pg_data_
 
 		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
 								0, 0))
-			return 1;
+			all_zones_ok = false;
+		else
+			balanced += zone->present_pages;
 	}
 
-	return 0;
+	/*
+	 * For high-order requests, the balanced zones must contain at least
+	 * 25% of the nodes pages for kswapd to sleep. For order-0, all zones
+	 * must be balanced
+	 */
+	if (order)
+		return pgdat_balanced(pgdat, balanced, 0);
+	else
+		return !all_zones_ok;
 }
 
 /*
@@ -2250,7 +2290,7 @@ static unsigned long balance_pgdat(pg_da
 							int classzone_idx)
 {
 	int all_zones_ok;
-	int any_zone_ok;
+	unsigned long balanced;
 	int priority;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
@@ -2284,7 +2324,7 @@ loop_again:
 			disable_swap_token();
 
 		all_zones_ok = 1;
-		any_zone_ok = 0;
+		balanced = 0;
 
 		/*
 		 * Scan in the highmem->dma direction for the highest
@@ -2404,11 +2444,11 @@ loop_again:
 				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
 				if (i <= classzone_idx)
-					any_zone_ok = 1;
+					balanced += zone->present_pages;
 			}
 
 		}
-		if (all_zones_ok || (order && any_zone_ok))
+		if (all_zones_ok || (order && pgdat_balanced(pgdat, balanced, classzone_idx)))
 			break;		/* kswapd: all done */
 		/*
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
@@ -2434,10 +2474,10 @@ out:
 
 	/*
 	 * order-0: All zones must meet high watermark for a balanced node
-	 * high-order: Any zone below pgdats classzone_idx must meet the high
-	 *             watermark for a balanced node
+	 * high-order: Balanced zones must make up at least 25% of the node
+	 *             for the node to be balanced
 	 */
-	if (!(all_zones_ok || (order && any_zone_ok))) {
+	if (!(all_zones_ok || (order && pgdat_balanced(pgdat, balanced, classzone_idx)))) {
 		cond_resched();
 
 		try_to_freeze();
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
mm-compactionc-avoid-double-mem_cgroup_del_lru.patch
mm-vmscan-tracepoint-account-for-scanned-pages-similarly-for-both-ftrace-and-vmstat.patch
mm-page-allocator-adjust-the-per-cpu-counter-threshold-when-memory-is-low.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-update.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix-set_pgdat_percpu_threshold-dont-use-for_each_online_cpu.patch
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
writeback-enabling-gate-for-light-dirtied-bdi.patch
writeback-enabling-gate-for-light-dirtied-bdi-fix.patch
writeback-safety-margin-for-bdi-stat-error.patch
vmscan-factor-out-kswapd-sleeping-logic-from-kswapd.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
vmscan-make-kswapd-use-a-correct-order.patch
add-debugging-aid-for-memory-initialisation-problems.patch

