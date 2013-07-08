From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-flatten-kswapd-priority-loop.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:24:37 -0700
Message-ID: <51db11f5.x3zp8UQwamJ6tdbs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50233 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-flatten-kswapd-priority-loop.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:37 -0700


The patch titled
     Subject: mm: vmscan: flatten kswapd priority loop
has been removed from the -mm tree.  Its filename was
     mm-vmscan-flatten-kswapd-priority-loop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: flatten kswapd priority loop

kswapd stops raising the scanning priority when at least SWAP_CLUSTER_MAX
pages have been reclaimed or the pgdat is considered balanced.  It then
rechecks if it needs to restart at DEF_PRIORITY and whether high-order
reclaim needs to be reset.  This is not wrong per-se but it is confusing
to follow and forcing kswapd to stay at DEF_PRIORITY may require several
restarts before it has scanned enough pages to meet the high watermark
even at 100% efficiency.  This patch irons out the logic a bit by
controlling when priority is raised and removing the "goto loop_again".

This patch has kswapd raise the scanning priority until it is scanning
enough pages that it could meet the high watermark in one shrink of the
LRU lists if it is able to reclaim at 100% efficiency.  It will not raise
the scanning prioirty higher unless it is failing to reclaim any pages.

To avoid infinite looping for high-order allocation requests kswapd will
not reclaim for high-order allocations when it has reclaimed at least
twice the number of pages as the allocation request.

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

 mm/vmscan.c |   86 +++++++++++++++++++++++---------------------------
 1 file changed, 41 insertions(+), 45 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-flatten-kswapd-priority-loop mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-flatten-kswapd-priority-loop
+++ a/mm/vmscan.c
@@ -2654,8 +2654,12 @@ static bool prepare_kswapd_sleep(pg_data
 /*
  * kswapd shrinks the zone by the number of pages required to reach
  * the high watermark.
+ *
+ * Returns true if kswapd scanned at least the requested number of pages to
+ * reclaim. This is used to determine if the scanning priority needs to be
+ * raised.
  */
-static void kswapd_shrink_zone(struct zone *zone,
+static bool kswapd_shrink_zone(struct zone *zone,
 			       struct scan_control *sc,
 			       unsigned long lru_pages)
 {
@@ -2675,6 +2679,8 @@ static void kswapd_shrink_zone(struct zo
 
 	if (nr_slab == 0 && !zone_reclaimable(zone))
 		zone->all_unreclaimable = 1;
+
+	return sc->nr_scanned >= sc->nr_to_reclaim;
 }
 
 /*
@@ -2701,26 +2707,26 @@ static void kswapd_shrink_zone(struct zo
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 							int *classzone_idx)
 {
-	bool pgdat_is_balanced = false;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
+		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 		.may_swap = 1,
+		.may_writepage = !laptop_mode,
 		.order = order,
 		.target_mem_cgroup = NULL,
 	};
-loop_again:
-	sc.priority = DEF_PRIORITY;
-	sc.nr_reclaimed = 0;
-	sc.may_writepage = !laptop_mode;
 	count_vm_event(PAGEOUTRUN);
 
 	do {
 		unsigned long lru_pages = 0;
+		bool raise_priority = true;
+
+		sc.nr_reclaimed = 0;
 
 		/*
 		 * Scan in the highmem->dma direction for the highest
@@ -2762,10 +2768,8 @@ loop_again:
 			}
 		}
 
-		if (i < 0) {
-			pgdat_is_balanced = true;
+		if (i < 0)
 			goto out;
-		}
 
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
@@ -2832,8 +2836,16 @@ loop_again:
 
 			if ((buffer_heads_over_limit && is_highmem_idx(i)) ||
 			    !zone_balanced(zone, testorder,
-					   balance_gap, end_zone))
-				kswapd_shrink_zone(zone, &sc, lru_pages);
+					   balance_gap, end_zone)) {
+				/*
+				 * There should be no need to raise the
+				 * scanning priority if enough pages are
+				 * already being scanned that high
+				 * watermark would be met at 100% efficiency.
+				 */
+				if (kswapd_shrink_zone(zone, &sc, lru_pages))
+					raise_priority = false;
+			}
 
 			/*
 			 * If we're getting trouble reclaiming, start doing
@@ -2868,46 +2880,29 @@ loop_again:
 				pfmemalloc_watermark_ok(pgdat))
 			wake_up(&pgdat->pfmemalloc_wait);
 
-		if (pgdat_balanced(pgdat, order, *classzone_idx)) {
-			pgdat_is_balanced = true;
-			break;		/* kswapd: all done */
-		}
-
 		/*
-		 * We do this so kswapd doesn't build up large priorities for
-		 * example when it is freeing in parallel with allocators. It
-		 * matches the direct reclaim path behaviour in terms of impact
-		 * on zone->*_priority.
+		 * Fragmentation may mean that the system cannot be rebalanced
+		 * for high-order allocations in all zones. If twice the
+		 * allocation size has been reclaimed and the zones are still
+		 * not balanced then recheck the watermarks at order-0 to
+		 * prevent kswapd reclaiming excessively. Assume that a
+		 * process requested a high-order can direct reclaim/compact.
 		 */
-		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
-			break;
-	} while (--sc.priority >= 0);
-
-out:
-	if (!pgdat_is_balanced) {
-		cond_resched();
+		if (order && sc.nr_reclaimed >= 2UL << order)
+			order = sc.order = 0;
 
-		try_to_freeze();
+		/* Check if kswapd should be suspending */
+		if (try_to_freeze() || kthread_should_stop())
+			break;
 
 		/*
-		 * Fragmentation may mean that the system cannot be
-		 * rebalanced for high-order allocations in all zones.
-		 * At this point, if nr_reclaimed < SWAP_CLUSTER_MAX,
-		 * it means the zones have been fully scanned and are still
-		 * not balanced. For high-order allocations, there is
-		 * little point trying all over again as kswapd may
-		 * infinite loop.
-		 *
-		 * Instead, recheck all watermarks at order-0 as they
-		 * are the most important. If watermarks are ok, kswapd will go
-		 * back to sleep. High-order users can still perform direct
-		 * reclaim if they wish.
+		 * Raise priority if scanning rate is too low or there was no
+		 * progress in reclaiming pages
 		 */
-		if (sc.nr_reclaimed < SWAP_CLUSTER_MAX)
-			order = sc.order = 0;
-
-		goto loop_again;
-	}
+		if (raise_priority || !sc.nr_reclaimed)
+			sc.priority--;
+	} while (sc.priority >= 0 &&
+		 !pgdat_balanced(pgdat, order, *classzone_idx));
 
 	/*
 	 * If kswapd was reclaiming at a higher order, it has the option of
@@ -2936,6 +2931,7 @@ out:
 			compact_pgdat(pgdat, order);
 	}
 
+out:
 	/*
 	 * Return the order we were reclaiming at so prepare_kswapd_sleep()
 	 * makes a decision on the order we were last reclaiming at. However,
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

