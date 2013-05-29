From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed.patch added to -mm tree
Date: Wed, 29 May 2013 12:54:45 -0700
Message-ID: <51a65d05.lsAw8icplUhxAZV3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934455Ab3E2Tyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 15:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: + mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed.patch added to -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 12:54:45 -0700


The patch titled
     Subject: mm: vmscan: stall page reclaim after a list of pages have been processed
has been added to the -mm tree.  Its filename is
     mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: stall page reclaim after a list of pages have been processed

Commit "mm: vmscan: Block kswapd if it is encountering pages under
writeback" blocks page reclaim if it encounters pages under writeback
marked for immediate reclaim.  It blocks while pages are still isolated
from the LRU which is necessary.  This patch defers the blocking until
after the isolated pages have been processed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed
+++ a/mm/vmscan.c
@@ -699,6 +699,7 @@ static unsigned long shrink_page_list(st
 				      enum ttu_flags ttu_flags,
 				      unsigned long *ret_nr_unqueued_dirty,
 				      unsigned long *ret_nr_writeback,
+				      unsigned long *ret_nr_immediate,
 				      bool force_reclaim)
 {
 	LIST_HEAD(ret_pages);
@@ -709,6 +710,7 @@ static unsigned long shrink_page_list(st
 	unsigned long nr_congested = 0;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_writeback = 0;
+	unsigned long nr_immediate = 0;
 
 	cond_resched();
 
@@ -770,8 +772,8 @@ static unsigned long shrink_page_list(st
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
@@ -801,10 +803,8 @@ static unsigned long shrink_page_list(st
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
@@ -1030,6 +1030,7 @@ keep:
 	mem_cgroup_uncharge_end();
 	*ret_nr_unqueued_dirty += nr_unqueued_dirty;
 	*ret_nr_writeback += nr_writeback;
+	*ret_nr_immediate += nr_immediate;
 	return nr_reclaimed;
 }
 
@@ -1041,7 +1042,7 @@ unsigned long reclaim_clean_pages_from_l
 		.priority = DEF_PRIORITY,
 		.may_unmap = 1,
 	};
-	unsigned long ret, dummy1, dummy2;
+	unsigned long ret, dummy1, dummy2, dummy3;
 	struct page *page, *next;
 	LIST_HEAD(clean_pages);
 
@@ -1054,7 +1055,7 @@ unsigned long reclaim_clean_pages_from_l
 
 	ret = shrink_page_list(&clean_pages, zone, &sc,
 				TTU_UNMAP|TTU_IGNORE_ACCESS,
-				&dummy1, &dummy2, true);
+				&dummy1, &dummy2, &dummy3, true);
 	list_splice(&clean_pages, page_list);
 	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
 	return ret;
@@ -1350,6 +1351,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_taken;
 	unsigned long nr_unqueued_dirty = 0;
 	unsigned long nr_writeback = 0;
+	unsigned long nr_immediate = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
 	struct zone *zone = lruvec_zone(lruvec);
@@ -1391,7 +1393,7 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 
 	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
-				&nr_unqueued_dirty, &nr_writeback, false);
+			&nr_unqueued_dirty, &nr_writeback, &nr_immediate, false);
 
 	spin_lock_irq(&zone->lru_lock);
 
@@ -1444,14 +1446,21 @@ shrink_inactive_list(unsigned long nr_to
 	}
 
 	/*
-	 * Similarly, if many dirty pages are encountered that are not
-	 * currently being written then flag that kswapd should start
-	 * writing back pages and stall to give a chance for flushers
-	 * to catch up.
+	 * Similarly, if pages marked for immediate reclaim and under writeback
+	 * are encountered it implies that pages are cycling through the LRU
+	 * faster than they can be written. If dirty pages are encountered that
+	 * are not queued for IO, it implies that flushers are not keeping up.
+	 * In this case, be more aggressive about stalling and start writing
+	 * pages from reclaim context if necessary.
 	 */
-	if (global_reclaim(sc) && nr_unqueued_dirty == nr_taken) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
-		zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
+	if (global_reclaim(sc)) {
+		if (nr_unqueued_dirty == nr_taken || nr_immediate) {
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
+			zone_clear_flag(zone, ZONE_WRITEBACK);
+		}
+
+		if (nr_unqueued_dirty == nr_taken)
+			zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
 	}
 
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-memmap_init_zone-performance-improvement.patch

