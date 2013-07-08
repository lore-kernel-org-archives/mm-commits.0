From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:58 -0700
Message-ID: <51db120a.EGtaoPV4oU1G2GDn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3GHTZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, trond.myklebust@fys.uio.no, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,trond.myklebust@fys.uio.no,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:58 -0700


The patch titled
     Subject: mm: vmscan: move direct reclaim wait_iff_congested into shrink_list
has been removed from the -mm tree.  Its filename was
     mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: move direct reclaim wait_iff_congested into shrink_list

shrink_inactive_list makes decisions on whether to stall based on the
number of dirty pages encountered.  The wait_iff_congested() call in
shrink_page_list does no such thing and it's arbitrary.

This patch moves the decision on whether to set ZONE_CONGESTED and the
wait_iff_congested call into shrink_page_list.  This keeps all the
decisions on whether to stall or not in the one place.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   62 ++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 29 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list
+++ a/mm/vmscan.c
@@ -695,7 +695,9 @@ static unsigned long shrink_page_list(st
 				      struct zone *zone,
 				      struct scan_control *sc,
 				      enum ttu_flags ttu_flags,
+				      unsigned long *ret_nr_dirty,
 				      unsigned long *ret_nr_unqueued_dirty,
+				      unsigned long *ret_nr_congested,
 				      unsigned long *ret_nr_writeback,
 				      unsigned long *ret_nr_immediate,
 				      bool force_reclaim)
@@ -1017,20 +1019,13 @@ keep:
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
 
-	/*
-	 * Tag a zone as congested if all the dirty pages encountered were
-	 * backed by a congested BDI. In this case, reclaimers should just
-	 * back off and wait for congestion to clear because further reclaim
-	 * will encounter the same problem
-	 */
-	if (nr_dirty && nr_dirty == nr_congested && global_reclaim(sc))
-		zone_set_flag(zone, ZONE_CONGESTED);
-
 	free_hot_cold_page_list(&free_pages, 1);
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 	mem_cgroup_uncharge_end();
+	*ret_nr_dirty += nr_dirty;
+	*ret_nr_congested += nr_congested;
 	*ret_nr_unqueued_dirty += nr_unqueued_dirty;
 	*ret_nr_writeback += nr_writeback;
 	*ret_nr_immediate += nr_immediate;
@@ -1045,7 +1040,7 @@ unsigned long reclaim_clean_pages_from_l
 		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
-	unsigned long ret, dummy1, dummy2, dummy3;
+	unsigned long ret, dummy1, dummy2, dummy3, dummy4, dummy5;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
 
@@ -1057,8 +1052,8 @@ unsigned long reclaim_clean_pages_from_l
 	}
 
 	ret = shrink_page_list(&clean_pages, zone, &sc,
-				TTU_UNMAP|TTU_IGNORE_ACCESS,
-				&dummy1, &dummy2, &dummy3, true);
+			TTU_UNMAP|TTU_IGNORE_ACCESS,
+			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
 	list_splice(&clean_pages, page_list);
 	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
 	return ret;
@@ -1352,6 +1347,8 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_taken;
+	unsigned long nr_dirty = 0;
+	unsigned long nr_congested = 0;
 	unsigned long nr_unqueued_dirty = 0;
 	unsigned long nr_writeback = 0;
 	unsigned long nr_immediate = 0;
@@ -1396,8 +1393,9 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 
 	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
-			&nr_unqueued_dirty, &nr_writeback, &nr_immediate,
-			false);
+				&nr_dirty, &nr_unqueued_dirty, &nr_congested,
+				&nr_writeback, &nr_immediate,
+				false);
 
 	spin_lock_irq(&zone->lru_lock);
 
@@ -1431,7 +1429,7 @@ shrink_inactive_list(unsigned long nr_to
 	 * same way balance_dirty_pages() manages.
 	 *
 	 * This scales the number of dirty pages that must be under writeback
-	 * before throttling depending on priority. It is a simple backoff
+	 * before a zone gets flagged ZONE_WRITEBACK. It is a simple backoff
 	 * function that has the most effect in the range DEF_PRIORITY to
 	 * DEF_PRIORITY-2 which is the priority reclaim is considered to be
 	 * in trouble and reclaim is considered to be in trouble.
@@ -1442,12 +1440,14 @@ shrink_inactive_list(unsigned long nr_to
 	 * ...
 	 * DEF_PRIORITY-6 For SWAP_CLUSTER_MAX isolated pages, throttle if any
 	 *                     isolated page is PageWriteback
+	 *
+	 * Once a zone is flagged ZONE_WRITEBACK, kswapd will count the number
+	 * of pages under pages flagged for immediate reclaim and stall if any
+	 * are encountered in the nr_immediate check below.
 	 */
 	if (nr_writeback && nr_writeback >=
-			(nr_taken >> (DEF_PRIORITY - sc->priority))) {
+			(nr_taken >> (DEF_PRIORITY - sc->priority)))
 		zone_set_flag(zone, ZONE_WRITEBACK);
-		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
-	}
 
 	/*
 	 * memcg will stall in page writeback so only consider forcibly
@@ -1455,6 +1455,13 @@ shrink_inactive_list(unsigned long nr_to
 	 */
 	if (global_reclaim(sc)) {
 		/*
+		 * Tag a zone as congested if all the dirty pages scanned were
+		 * backed by a congested BDI and wait_iff_congested will stall.
+		 */
+		if (nr_dirty && nr_dirty == nr_congested)
+			zone_set_flag(zone, ZONE_CONGESTED);
+
+		/*
 		 * If dirty pages are scanned that are not queued for IO, it
 		 * implies that flushers are not keeping up. In this case, flag
 		 * the zone ZONE_TAIL_LRU_DIRTY and kswapd will start writing
@@ -1474,6 +1481,14 @@ shrink_inactive_list(unsigned long nr_to
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
+	/*
+	 * Stall direct reclaim for IO completions if underlying BDIs or zone
+	 * is congested. Allow kswapd to continue until it starts encountering
+	 * unqueued dirty pages or cycling through the LRU too quickly.
+	 */
+	if (!sc->hibernation_mode && !current_is_kswapd())
+		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
+
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
@@ -2374,17 +2389,6 @@ static unsigned long do_try_to_free_page
 						WB_REASON_TRY_TO_FREE_PAGES);
 			sc->may_writepage = 1;
 		}
-
-		/* Take a nap, wait for some writeback to complete */
-		if (!sc->hibernation_mode && sc->nr_scanned &&
-		    sc->priority < DEF_PRIORITY - 2) {
-			struct zone *preferred_zone;
-
-			first_zones_zonelist(zonelist, gfp_zone(sc->gfp_mask),
-						&cpuset_current_mems_allowed,
-						&preferred_zone);
-			wait_iff_congested(preferred_zone, BLK_RW_ASYNC, HZ/10);
-		}
 	} while (--sc->priority >= 0);
 
 out:
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

