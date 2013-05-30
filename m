From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
 added to -mm tree
Date: Thu, 30 May 2013 12:55:03 -0700
Message-ID: <51a7ae97.3YVqPYml3mZw7WDP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59507 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3E3TzE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 15:55:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, trond.myklebust@fys.uio.no, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: + mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch added to -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,trond.myklebust@fys.uio.no,zcalusic@bitsync.net
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 12:55:03 -0700


The patch titled
     Subject: mm: vmscan: move direct reclaim wait_iff_congested into shrink_list
has been added to the -mm tree.  Its filename is
     mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch

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
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-memmap_init_zone-performance-improvement.patch

