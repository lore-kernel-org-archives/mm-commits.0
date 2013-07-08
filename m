From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:24:54 -0700
Message-ID: <51db1206.ec0BwaVA8fONr0TG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50299 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3GHTYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, trond.myklebust@fys.uio.no, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,trond.myklebust@fys.uio.no,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:54 -0700


The patch titled
     Subject: mm: vmscan: stall page reclaim after a list of pages have been processed
has been removed from the -mm tree.  Its filename was
     mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: stall page reclaim after a list of pages have been processed

Commit "mm: vmscan: Block kswapd if it is encountering pages under
writeback" blocks page reclaim if it encounters pages under writeback
marked for immediate reclaim.  It blocks while pages are still isolated
from the LRU which is unnecessary.  This patch defers the blocking until
after the isolated pages have been processed and tidies up some of the
comments.

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

 mm/vmscan.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3 mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3
+++ a/mm/vmscan.c
@@ -697,6 +697,7 @@ static unsigned long shrink_page_list(st
 				      enum ttu_flags ttu_flags,
 				      unsigned long *ret_nr_unqueued_dirty,
 				      unsigned long *ret_nr_writeback,
+				      unsigned long *ret_nr_immediate,
 				      bool force_reclaim)
 {
 	LIST_HEAD(ret_pages);
@@ -707,6 +708,7 @@ static unsigned long shrink_page_list(st
 	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_writeback = 0;
+	unsigned long nr_immediate = 0;
 
 	cond_resched();
 
@@ -773,8 +775,8 @@ static unsigned long shrink_page_list(st
 		 *    IO can complete. Waiting on the page itself risks an
 		 *    indefinite stall if it is impossible to writeback the
 		 *    page due to IO error or disconnected storage so instead
-		 *    block for HZ/10 or until some IO completes then clear the
-		 *    ZONE_WRITEBACK flag to recheck if the condition exists.
+		 *    note that the LRU is being scanned too quickly and the
+		 *    caller can stall after page list has been processed.
 		 *
 		 * 2) Global reclaim encounters a page, memcg encounters a
 		 *    page that is not marked for immediate reclaim or
@@ -804,10 +806,8 @@ static unsigned long shrink_page_list(st
 			if (current_is_kswapd() &&
 			    PageReclaim(page) &&
 			    zone_is_reclaim_writeback(zone)) {
-				unlock_page(page);
-				congestion_wait(BLK_RW_ASYNC, HZ/10);
-				zone_clear_flag(zone, ZONE_WRITEBACK);
-				goto keep;
+				nr_immediate++;
+				goto keep_locked;
 
 			/* Case 2 above */
 			} else if (global_reclaim(sc) ||
@@ -1033,6 +1033,7 @@ keep:
 	mem_cgroup_uncharge_end();
 	*ret_nr_unqueued_dirty += nr_unqueued_dirty;
 	*ret_nr_writeback += nr_writeback;
+	*ret_nr_immediate += nr_immediate;
 	return nr_reclaimed;
 }
 
@@ -1044,7 +1045,7 @@ unsigned long reclaim_clean_pages_from_l
 		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
-	unsigned long ret, dummy1, dummy2;
+	unsigned long ret, dummy1, dummy2, dummy3;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
 
@@ -1057,7 +1058,7 @@ unsigned long reclaim_clean_pages_from_l
 
 	ret = shrink_page_list(&clean_pages, zone, &sc,
 				TTU_UNMAP|TTU_IGNORE_ACCESS,
-				&dummy1, &dummy2, true);
+				&dummy1, &dummy2, &dummy3, true);
 	list_splice(&clean_pages, page_list);
 	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
 	return ret;
@@ -1353,6 +1354,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_taken;
 	unsigned long nr_unqueued_dirty = 0;
 	unsigned long nr_writeback = 0;
+	unsigned long nr_immediate = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct zone *zone = lruvec_zone(lruvec);
@@ -1394,7 +1396,8 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 
 	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
-				&nr_unqueued_dirty, &nr_writeback, false);
+			&nr_unqueued_dirty, &nr_writeback, &nr_immediate,
+			false);
 
 	spin_lock_irq(&zone->lru_lock);
 
@@ -1447,14 +1450,28 @@ shrink_inactive_list(unsigned long nr_to
 	}
 
 	/*
-	 * Similarly, if many dirty pages are encountered that are not
-	 * currently being written then flag that kswapd should start
-	 * writing back pages and stall to give a chance for flushers
-	 * to catch up.
+	 * memcg will stall in page writeback so only consider forcibly
+	 * stalling for global reclaim
 	 */
-	if (global_reclaim(sc) && nr_unqueued_dirty == nr_taken) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
-		zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
+	if (global_reclaim(sc)) {
+		/*
+		 * If dirty pages are scanned that are not queued for IO, it
+		 * implies that flushers are not keeping up. In this case, flag
+		 * the zone ZONE_TAIL_LRU_DIRTY and kswapd will start writing
+		 * pages from reclaim context. It will forcibly stall in the
+		 * next check.
+		 */
+		if (nr_unqueued_dirty == nr_taken)
+			zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
+
+		/*
+		 * In addition, if kswapd scans pages marked marked for
+		 * immediate reclaim and under writeback (nr_immediate), it
+		 * implies that pages are cycling through the LRU faster than
+		 * they are written so also forcibly stall.
+		 */
+		if (nr_unqueued_dirty == nr_taken || nr_immediate)
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
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

