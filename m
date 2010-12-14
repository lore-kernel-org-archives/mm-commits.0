From: akpm@linux-foundation.org
Subject: + mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch added to -mm tree
Date: Tue, 14 Dec 2010 14:47:53 -0800
Message-ID: <201012142247.oBEMls0G014533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760142Ab0LNWsa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Dec 2010 17:48:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, dave@linux.vnet.ibm.com, emunson@mgebm.net, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, riel@redhat.com, shaohua.li@intel.com, sim@hostway.ca


The patch titled
     mm: kswapd: use the classzone idx that kswapd was using for sleeping_prematurely()
has been added to the -mm tree.  Its filename is
     mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch

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
Subject: mm: kswapd: use the classzone idx that kswapd was using for sleeping_prematurely()
From: Mel Gorman <mel@csn.ul.ie>

When kswapd is woken up for a high-order allocation, it takes account of
the highest usable zone by the caller (the classzone idx).  During
allocation, this index is used to select the lowmem_reserve[] that should
be applied to the watermark calculation in zone_watermark_ok().

When balancing a node, kswapd considers the highest unbalanced zone to be
the classzone index.  This will always be at least be the callers
classzone_idx and can be higher.  However, sleeping_prematurely() always
considers the lowest zone (e.g.  ZONE_DMA) to be the classzone index. 
This means that sleeping_prematurely() can consider a zone to be balanced
that is unusable by the allocation request that originally woke kswapd. 
This patch changes sleeping_prematurely() to use a classzone_idx matching
the value it used in balance_pgdat().

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Eric B Munson <emunson@mgebm.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Simon Kirby <sim@hostway.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff -puN mm/vmscan.c~mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely mm/vmscan.c
--- a/mm/vmscan.c~mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely
+++ a/mm/vmscan.c
@@ -2227,7 +2227,8 @@ static bool pgdat_balanced(pg_data_t *pg
 }
 
 /* is kswapd sleeping prematurely? */
-static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining)
+static bool sleeping_prematurely(pg_data_t *pgdat, int order, long remaining,
+					int classzone_idx)
 {
 	int i;
 	unsigned long balanced = 0;
@@ -2235,7 +2236,7 @@ static bool sleeping_prematurely(pg_data
 
 	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
 	if (remaining)
-		return 1;
+		return true;
 
 	/* Check the watermark levels */
 	for (i = 0; i < pgdat->nr_zones; i++) {
@@ -2256,7 +2257,7 @@ static bool sleeping_prematurely(pg_data
 		}
 
 		if (!zone_watermark_ok_safe(zone, order, high_wmark_pages(zone),
-								0, 0))
+							classzone_idx, 0))
 			all_zones_ok = false;
 		else
 			balanced += zone->present_pages;
@@ -2268,7 +2269,7 @@ static bool sleeping_prematurely(pg_data
 	 * must be balanced
 	 */
 	if (order)
-		return pgdat_balanced(pgdat, balanced, 0);
+		return pgdat_balanced(pgdat, balanced, classzone_idx);
 	else
 		return !all_zones_ok;
 }
@@ -2295,7 +2296,7 @@ static bool sleeping_prematurely(pg_data
  * of pages is balanced across the zones.
  */
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
-							int classzone_idx)
+							int *classzone_idx)
 {
 	int all_zones_ok;
 	unsigned long balanced;
@@ -2358,6 +2359,7 @@ loop_again:
 			if (!zone_watermark_ok_safe(zone, order,
 					high_wmark_pages(zone), 0, 0)) {
 				end_zone = i;
+				*classzone_idx = i;
 				break;
 			}
 		}
@@ -2451,12 +2453,12 @@ loop_again:
 				 * spectulatively avoid congestion waits
 				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
-				if (i <= classzone_idx)
+				if (i <= *classzone_idx)
 					balanced += zone->present_pages;
 			}
 
 		}
-		if (all_zones_ok || (order && pgdat_balanced(pgdat, balanced, classzone_idx)))
+		if (all_zones_ok || (order && pgdat_balanced(pgdat, balanced, *classzone_idx)))
 			break;		/* kswapd: all done */
 		/*
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
@@ -2485,7 +2487,7 @@ out:
 	 * high-order: Balanced zones must make up at least 25% of the node
 	 *             for the node to be balanced
 	 */
-	if (!(all_zones_ok || (order && pgdat_balanced(pgdat, balanced, classzone_idx)))) {
+	if (!(all_zones_ok || (order && pgdat_balanced(pgdat, balanced, *classzone_idx)))) {
 		cond_resched();
 
 		try_to_freeze();
@@ -2546,10 +2548,11 @@ out:
 	 * if another caller entered the allocator slow path while kswapd
 	 * was awake, order will remain at the higher level
 	 */
+	*classzone_idx = end_zone;
 	return order;
 }
 
-static void kswapd_try_to_sleep(pg_data_t *pgdat, int order)
+static void kswapd_try_to_sleep(pg_data_t *pgdat, int order, int classzone_idx)
 {
 	long remaining = 0;
 	DEFINE_WAIT(wait);
@@ -2560,7 +2563,7 @@ static void kswapd_try_to_sleep(pg_data_
 	prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
 
 	/* Try to sleep for a short interval */
-	if (!sleeping_prematurely(pgdat, order, remaining)) {
+	if (!sleeping_prematurely(pgdat, order, remaining, classzone_idx)) {
 		remaining = schedule_timeout(HZ/10);
 		finish_wait(&pgdat->kswapd_wait, &wait);
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
@@ -2570,7 +2573,7 @@ static void kswapd_try_to_sleep(pg_data_
 	 * After a short sleep, check if it was a premature sleep. If not, then
 	 * go fully to sleep until explicitly woken up.
 	 */
-	if (!sleeping_prematurely(pgdat, order, remaining)) {
+	if (!sleeping_prematurely(pgdat, order, remaining, classzone_idx)) {
 		trace_mm_vmscan_kswapd_sleep(pgdat->node_id);
 
 		/*
@@ -2658,7 +2661,7 @@ static int kswapd(void *p)
 			order = new_order;
 			classzone_idx = new_classzone_idx;
 		} else {
-			kswapd_try_to_sleep(pgdat, order);
+			kswapd_try_to_sleep(pgdat, order, classzone_idx);
 			order = pgdat->kswapd_max_order;
 			classzone_idx = pgdat->classzone_idx;
 			pgdat->kswapd_max_order = 0;
@@ -2675,7 +2678,7 @@ static int kswapd(void *p)
 		 */
 		if (!ret) {
 			trace_mm_vmscan_kswapd_wake(pgdat->node_id, order);
-			order = balance_pgdat(pgdat, order, classzone_idx);
+			order = balance_pgdat(pgdat, order, &classzone_idx);
 		}
 	}
 	return 0;
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

