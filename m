From: akpm@linux-foundation.org
Subject: [merged] vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:41 -0700
Message-ID: <20120322201741.8AFD7A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:44214 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270Ab2CVURn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:43 -0400
Received: by mail-bk0-f74.google.com with SMTP id jm19so134208bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, aarcange@redhat.com, dhillf@gmail.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: reclaim at order 0 when compaction is enabled
has been removed from the -mm tree.  Its filename was
     vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: vmscan: reclaim at order 0 when compaction is enabled

When built with CONFIG_COMPACTION, kswapd should not try to free
contiguous pages, because it is not trying hard enough to have a real
chance at being successful, but still disrupts the LRU enough to break
other things.

Do not do higher order page isolation unless we really are in lumpy
reclaim mode.

Stop reclaiming pages once we have enough free pages that compaction can
deal with things, and we hit the normal order 0 watermarks used by kswapd.

Also remove a line of code that increments balanced right before exiting
the function.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff -puN mm/vmscan.c~vmscan-reclaim-at-order-0-when-compaction-is-enabled mm/vmscan.c
--- a/mm/vmscan.c~vmscan-reclaim-at-order-0-when-compaction-is-enabled
+++ a/mm/vmscan.c
@@ -1138,7 +1138,7 @@ int __isolate_lru_page(struct page *page
  * @mz:		The mem_cgroup_zone to pull pages from.
  * @dst:	The temp list to put pages on to.
  * @nr_scanned:	The number of pages that were scanned.
- * @order:	The caller's attempted allocation order
+ * @sc:		The scan_control struct for this reclaim session
  * @mode:	One of the LRU isolation modes
  * @active:	True [1] if isolating active pages
  * @file:	True [1] if isolating file [!anon] pages
@@ -1147,8 +1147,8 @@ int __isolate_lru_page(struct page *page
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct mem_cgroup_zone *mz, struct list_head *dst,
-		unsigned long *nr_scanned, int order, isolate_mode_t mode,
-		int active, int file)
+		unsigned long *nr_scanned, struct scan_control *sc,
+		isolate_mode_t mode, int active, int file)
 {
 	struct lruvec *lruvec;
 	struct list_head *src;
@@ -1194,7 +1194,7 @@ static unsigned long isolate_lru_pages(u
 			BUG();
 		}
 
-		if (!order)
+		if (!sc->order || !(sc->reclaim_mode & RECLAIM_MODE_LUMPYRECLAIM))
 			continue;
 
 		/*
@@ -1208,8 +1208,8 @@ static unsigned long isolate_lru_pages(u
 		 */
 		zone_id = page_zone_id(page);
 		page_pfn = page_to_pfn(page);
-		pfn = page_pfn & ~((1 << order) - 1);
-		end_pfn = pfn + (1 << order);
+		pfn = page_pfn & ~((1 << sc->order) - 1);
+		end_pfn = pfn + (1 << sc->order);
 		for (; pfn < end_pfn; pfn++) {
 			struct page *cursor_page;
 
@@ -1275,7 +1275,7 @@ static unsigned long isolate_lru_pages(u
 
 	*nr_scanned = scan;
 
-	trace_mm_vmscan_lru_isolate(order,
+	trace_mm_vmscan_lru_isolate(sc->order,
 			nr_to_scan, scan,
 			nr_taken,
 			nr_lumpy_taken, nr_lumpy_dirty, nr_lumpy_failed,
@@ -1533,9 +1533,8 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list,
-				     &nr_scanned, sc->order,
-				     isolate_mode, 0, file);
+	nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list, &nr_scanned,
+				     sc, isolate_mode, 0, file);
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1711,8 +1710,7 @@ static void shrink_active_list(unsigned 
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_lru_pages(nr_to_scan, mz, &l_hold,
-				     &nr_scanned, sc->order,
+	nr_taken = isolate_lru_pages(nr_to_scan, mz, &l_hold, &nr_scanned, sc,
 				     isolate_mode, 1, file);
 	if (global_reclaim(sc))
 		zone->pages_scanned += nr_scanned;
@@ -2758,7 +2756,7 @@ loop_again:
 		 */
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
-			int nr_slab;
+			int nr_slab, testorder;
 			unsigned long balance_gap;
 
 			if (!populated_zone(zone))
@@ -2791,7 +2789,20 @@ loop_again:
 				(zone->present_pages +
 					KSWAPD_ZONE_BALANCE_GAP_RATIO-1) /
 				KSWAPD_ZONE_BALANCE_GAP_RATIO);
-			if (!zone_watermark_ok_safe(zone, order,
+			/*
+			 * Kswapd reclaims only single pages with compaction
+			 * enabled. Trying too hard to reclaim until contiguous
+			 * free pages have become available can hurt performance
+			 * by evicting too much useful data from memory.
+			 * Do not reclaim more than needed for compaction.
+			 */
+			testorder = order;
+			if (COMPACTION_BUILD && order &&
+					compaction_suitable(zone, order) !=
+						COMPACT_SKIPPED)
+				testorder = 0;
+
+			if (!zone_watermark_ok_safe(zone, testorder,
 					high_wmark_pages(zone) + balance_gap,
 					end_zone, 0)) {
 				shrink_zone(priority, zone, &sc);
@@ -2820,7 +2831,7 @@ loop_again:
 				continue;
 			}
 
-			if (!zone_watermark_ok_safe(zone, order,
+			if (!zone_watermark_ok_safe(zone, testorder,
 					high_wmark_pages(zone), end_zone, 0)) {
 				all_zones_ok = 0;
 				/*
@@ -2917,6 +2928,10 @@ out:
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;
 
+			/* Would compaction fail due to lack of free memory? */
+			if (compaction_suitable(zone, order) == COMPACT_SKIPPED)
+				goto loop_again;
+
 			/* Confirm the zone is balanced for order-0 */
 			if (!zone_watermark_ok(zone, 0,
 					high_wmark_pages(zone), 0, 0)) {
@@ -2926,8 +2941,6 @@ out:
 
 			/* If balanced, clear the congested flag */
 			zone_clear_flag(zone, ZONE_CONGESTED);
-			if (i <= *classzone_idx)
-				balanced += zone->present_pages;
 		}
 	}
 
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
mm-add-extra-free-kbytes-tunable.patch
mm-add-extra-free-kbytes-tunable-update.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
smp-introduce-a-generic-on_each_cpu_mask-function.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func.patch
smp-add-func-to-ipi-cpus-based-on-parameter-func-v9.patch
slub-only-ipi-cpus-that-have-per-cpu-obj-to-flush.patch
mm-only-ipi-cpus-to-drain-local-pages-if-they-exist.patch

