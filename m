From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:43 -0700
Message-ID: <51db11fb.hCAWW8JVFCJkCHK9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:43 -0700


The patch titled
     Subject: mm: vmscan: have kswapd writeback pages based on dirty pages encountered, not priority
has been removed from the -mm tree.  Its filename was
     mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: have kswapd writeback pages based on dirty pages encountered, not priority

Currently kswapd queues dirty pages for writeback if scanning at an
elevated priority but the priority kswapd scans at is not related to the
number of unqueued dirty encountered.  Since commit "mm: vmscan: Flatten
kswapd priority loop", the priority is related to the size of the LRU and
the zone watermark which is no indication as to whether kswapd should
write pages or not.

This patch tracks if an excessive number of unqueued dirty pages are being
encountered at the end of the LRU.  If so, it indicates that dirty pages
are being recycled before flusher threads can clean them and flags the
zone so that kswapd will start writing pages until the zone is balanced.

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

 include/linux/mmzone.h |    9 +++++++++
 mm/vmscan.c            |   31 +++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority
+++ a/include/linux/mmzone.h
@@ -495,6 +495,10 @@ typedef enum {
 	ZONE_CONGESTED,			/* zone has many dirty pages backed by
 					 * a congested BDI
 					 */
+	ZONE_TAIL_LRU_DIRTY,		/* reclaim scanning has recently found
+					 * many dirty file pages at the tail
+					 * of the LRU.
+					 */
 } zone_flags_t;
 
 static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
@@ -517,6 +521,11 @@ static inline int zone_is_reclaim_conges
 	return test_bit(ZONE_CONGESTED, &zone->flags);
 }
 
+static inline int zone_is_reclaim_dirty(const struct zone *zone)
+{
+	return test_bit(ZONE_TAIL_LRU_DIRTY, &zone->flags);
+}
+
 static inline int zone_is_reclaim_locked(const struct zone *zone)
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
diff -puN mm/vmscan.c~mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority
+++ a/mm/vmscan.c
@@ -676,13 +676,14 @@ static unsigned long shrink_page_list(st
 				      struct zone *zone,
 				      struct scan_control *sc,
 				      enum ttu_flags ttu_flags,
-				      unsigned long *ret_nr_dirty,
+				      unsigned long *ret_nr_unqueued_dirty,
 				      unsigned long *ret_nr_writeback,
 				      bool force_reclaim)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
 	int pgactivate = 0;
+	unsigned long nr_unqueued_dirty = 0;
 	unsigned long nr_dirty = 0;
 	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
@@ -808,14 +809,17 @@ static unsigned long shrink_page_list(st
 		if (PageDirty(page)) {
 			nr_dirty++;
 
+			if (!PageWriteback(page))
+				nr_unqueued_dirty++;
+
 			/*
 			 * Only kswapd can writeback filesystem pages to
-			 * avoid risk of stack overflow but do not writeback
-			 * unless under significant pressure.
+			 * avoid risk of stack overflow but only writeback
+			 * if many dirty pages have been encountered.
 			 */
 			if (page_is_file_cache(page) &&
 					(!current_is_kswapd() ||
-					 sc->priority >= DEF_PRIORITY - 2)) {
+					 !zone_is_reclaim_dirty(zone))) {
 				/*
 				 * Immediately reclaim when written back.
 				 * Similar in principal to deactivate_page()
@@ -960,7 +964,7 @@ keep:
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
 	mem_cgroup_uncharge_end();
-	*ret_nr_dirty += nr_dirty;
+	*ret_nr_unqueued_dirty += nr_unqueued_dirty;
 	*ret_nr_writeback += nr_writeback;
 	return nr_reclaimed;
 }
@@ -1373,6 +1377,15 @@ shrink_inactive_list(unsigned long nr_to
 			(nr_taken >> (DEF_PRIORITY - sc->priority)))
 		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
 
+	/*
+	 * Similarly, if many dirty pages are encountered that are not
+	 * currently being written then flag that kswapd should start
+	 * writing back pages.
+	 */
+	if (global_reclaim(sc) && nr_dirty &&
+			nr_dirty >= (nr_taken >> (DEF_PRIORITY - sc->priority)))
+		zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
+
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
@@ -2769,8 +2782,12 @@ static unsigned long balance_pgdat(pg_da
 				end_zone = i;
 				break;
 			} else {
-				/* If balanced, clear the congested flag */
+				/*
+				 * If balanced, clear the dirty and congested
+				 * flags
+				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
+				zone_clear_flag(zone, ZONE_TAIL_LRU_DIRTY);
 			}
 		}
 
@@ -2888,8 +2905,10 @@ static unsigned long balance_pgdat(pg_da
 				 * possible there are dirty pages backed by
 				 * congested BDIs but as pressure is relieved,
 				 * speculatively avoid congestion waits
+				 * or writing pages from kswapd context.
 				 */
 				zone_clear_flag(zone, ZONE_CONGESTED);
+				zone_clear_flag(zone, ZONE_TAIL_LRU_DIRTY);
 		}
 
 		/*
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

