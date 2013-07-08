From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:39 -0700
Message-ID: <51db11f7.qp1NHirwDhicd3Cw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50243 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:39 -0700


The patch titled
     Subject: mm: vmscan: decide whether to compact the pgdat based on reclaim progress
has been removed from the -mm tree.  Its filename was
     mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: decide whether to compact the pgdat based on reclaim progress

In the past, kswapd makes a decision on whether to compact memory after
the pgdat was considered balanced.  This more or less worked but it is
late to make such a decision and does not fit well now that kswapd makes a
decision whether to exit the zone scanning loop depending on reclaim
progress.

This patch will compact a pgdat if at least the requested number of pages
were reclaimed from unbalanced zones for a given priority.  If any zone is
currently balanced, kswapd will not call compaction as it is expected the
necessary pages are already available.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   59 +++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress
+++ a/mm/vmscan.c
@@ -2661,7 +2661,8 @@ static bool prepare_kswapd_sleep(pg_data
  */
 static bool kswapd_shrink_zone(struct zone *zone,
 			       struct scan_control *sc,
-			       unsigned long lru_pages)
+			       unsigned long lru_pages,
+			       unsigned long *nr_attempted)
 {
 	unsigned long nr_slab;
 	struct reclaim_state *reclaim_state = current->reclaim_state;
@@ -2677,6 +2678,9 @@ static bool kswapd_shrink_zone(struct zo
 	nr_slab = shrink_slab(&shrink, sc->nr_scanned, lru_pages);
 	sc->nr_reclaimed += reclaim_state->reclaimed_slab;
 
+	/* Account for the number of pages attempted to reclaim */
+	*nr_attempted += sc->nr_to_reclaim;
+
 	if (nr_slab == 0 && !zone_reclaimable(zone))
 		zone->all_unreclaimable = 1;
 
@@ -2724,7 +2728,9 @@ static unsigned long balance_pgdat(pg_da
 
 	do {
 		unsigned long lru_pages = 0;
+		unsigned long nr_attempted = 0;
 		bool raise_priority = true;
+		bool pgdat_needs_compaction = (order > 0);
 
 		sc.nr_reclaimed = 0;
 
@@ -2774,7 +2780,21 @@ static unsigned long balance_pgdat(pg_da
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
 
+			if (!populated_zone(zone))
+				continue;
+
 			lru_pages += zone_reclaimable_pages(zone);
+
+			/*
+			 * If any zone is currently balanced then kswapd will
+			 * not call compaction as it is expected that the
+			 * necessary pages are already available.
+			 */
+			if (pgdat_needs_compaction &&
+					zone_watermark_ok(zone, order,
+						low_wmark_pages(zone),
+						*classzone_idx, 0))
+				pgdat_needs_compaction = false;
 		}
 
 		/*
@@ -2843,7 +2863,8 @@ static unsigned long balance_pgdat(pg_da
 				 * already being scanned that high
 				 * watermark would be met at 100% efficiency.
 				 */
-				if (kswapd_shrink_zone(zone, &sc, lru_pages))
+				if (kswapd_shrink_zone(zone, &sc, lru_pages,
+						       &nr_attempted))
 					raise_priority = false;
 			}
 
@@ -2896,6 +2917,13 @@ static unsigned long balance_pgdat(pg_da
 			break;
 
 		/*
+		 * Compact if necessary and kswapd is reclaiming at least the
+		 * high watermark number of pages as requsted
+		 */
+		if (pgdat_needs_compaction && sc.nr_reclaimed > nr_attempted)
+			compact_pgdat(pgdat, order);
+
+		/*
 		 * Raise priority if scanning rate is too low or there was no
 		 * progress in reclaiming pages
 		 */
@@ -2904,33 +2932,6 @@ static unsigned long balance_pgdat(pg_da
 	} while (sc.priority >= 0 &&
 		 !pgdat_balanced(pgdat, order, *classzone_idx));
 
-	/*
-	 * If kswapd was reclaiming at a higher order, it has the option of
-	 * sleeping without all zones being balanced. Before it does, it must
-	 * ensure that the watermarks for order-0 on *all* zones are met and
-	 * that the congestion flags are cleared. The congestion flag must
-	 * be cleared as kswapd is the only mechanism that clears the flag
-	 * and it is potentially going to sleep here.
-	 */
-	if (order) {
-		int zones_need_compaction = 1;
-
-		for (i = 0; i <= end_zone; i++) {
-			struct zone *zone = pgdat->node_zones + i;
-
-			if (!populated_zone(zone))
-				continue;
-
-			/* Check if the memory needs to be defragmented. */
-			if (zone_watermark_ok(zone, order,
-				    low_wmark_pages(zone), *classzone_idx, 0))
-				zones_need_compaction = 0;
-		}
-
-		if (zones_need_compaction)
-			compact_pgdat(pgdat, order);
-	}
-
 out:
 	/*
 	 * Return the order we were reclaiming at so prepare_kswapd_sleep()
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

