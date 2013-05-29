From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered.patch added to -mm tree
Date: Wed, 29 May 2013 12:54:41 -0700
Message-ID: <51a65d01.lOngaVeWsV5ei8Di%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758817Ab3E2Tym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 15:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: + mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered.patch added to -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 12:54:41 -0700


The patch titled
     Subject: mm: vmscan: stall page reclaim and writeback pages based on dirty/writepage pages encountered
has been added to the -mm tree.  Its filename is
     mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered.patch

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
Subject: mm: vmscan: stall page reclaim and writeback pages based on dirty/writepage pages encountered

The patch "mm: vmscan: Have kswapd writeback pages based on dirty pages
encountered, not priority" decides whether to writeback pages from reclaim
context based on the number of dirty pages encountered.  This situation is
flagged too easily and flushers are not given the chance to catch up
resulting in more pages being written from reclaim context and potentially
impacting IO performance.  The check for PageWriteback is also misplaced
as it happens within a PageDirty check which is nonsense as the dirty may
have been cleared for IO.  The accounting is updated very late and pages
that are already under writeback, were reactivated, could not unmapped or
could not be released are all missed.  Finally, it considers stalling and
writing back filesystem pages due to encountering dirty anonymous pages at
the tail of the LRU which is dumb.

This patch causes kswapd to begin writing filesystem pages from reclaim
context only if page reclaim found that all filesystem pages at the tail
of the LRU were unqueued dirty pages.  Before it starts writing filesystem
pages, it will stall to give flushers a chance to catch up.  The decision
on whether wait_iff_congested is also now determined by dirty filesystem
pages only.

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

 mm/vmscan.c |   52 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered
+++ a/mm/vmscan.c
@@ -669,6 +669,27 @@ static enum page_references page_check_r
 	return PAGEREF_RECLAIM;
 }
 
+/* Check if a page is dirty or under writeback */
+static void page_check_dirty_writeback(struct page *page,
+				       bool *dirty, bool *writeback)
+{
+	struct address_space *mapping;
+
+	/*
+	 * Anonymous pages are not handled by flushers and must be written
+	 * from reclaim context. Do not stall reclaim based on them
+	 */
+	if (!page_is_file_cache(page)) {
+		*dirty = false;
+		*writeback = false;
+		return;
+	}
+
+	/* By default assume that the page flags are accurate */
+	*dirty = PageDirty(page);
+	*writeback = PageWriteback(page);
+}
+
 /*
  * shrink_page_list() returns the number of reclaimed pages
  */
@@ -697,6 +718,7 @@ static unsigned long shrink_page_list(st
 		struct page *page;
 		int may_enter_fs;
 		enum page_references references = PAGEREF_RECLAIM_CLEAN;
+		bool dirty, writeback;
 
 		cond_resched();
 
@@ -725,6 +747,19 @@ static unsigned long shrink_page_list(st
 			(PageSwapCache(page) && (sc->gfp_mask & __GFP_IO));
 
 		/*
+		 * The number of dirty pages determines if a zone is marked
+		 * reclaim_congested which affects wait_iff_congested. kswapd
+		 * will stall and start writing pages if the tail of the LRU
+		 * is all dirty unqueued pages.
+		 */
+		page_check_dirty_writeback(page, &dirty, &writeback);
+		if (dirty || writeback)
+			nr_dirty++;
+
+		if (dirty && !writeback)
+			nr_unqueued_dirty++;
+
+		/*
 		 * If a page at the tail of the LRU is under writeback, there
 		 * are three cases to consider.
 		 *
@@ -841,11 +876,6 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
-			nr_dirty++;
-
-			if (!PageWriteback(page))
-				nr_unqueued_dirty++;
-
 			/*
 			 * Only kswapd can writeback filesystem pages to
 			 * avoid risk of stack overflow but only writeback
@@ -1318,7 +1348,7 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_taken;
-	unsigned long nr_dirty = 0;
+	unsigned long nr_unqueued_dirty = 0;
 	unsigned long nr_writeback = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
@@ -1361,7 +1391,7 @@ shrink_inactive_list(unsigned long nr_to
 		return 0;
 
 	nr_reclaimed = shrink_page_list(&page_list, zone, sc, TTU_UNMAP,
-					&nr_dirty, &nr_writeback, false);
+				&nr_unqueued_dirty, &nr_writeback, false);
 
 	spin_lock_irq(&zone->lru_lock);
 
@@ -1416,11 +1446,13 @@ shrink_inactive_list(unsigned long nr_to
 	/*
 	 * Similarly, if many dirty pages are encountered that are not
 	 * currently being written then flag that kswapd should start
-	 * writing back pages.
+	 * writing back pages and stall to give a chance for flushers
+	 * to catch up.
 	 */
-	if (global_reclaim(sc) && nr_dirty &&
-			nr_dirty >= (nr_taken >> (DEF_PRIORITY - sc->priority)))
+	if (global_reclaim(sc) && nr_unqueued_dirty == nr_taken) {
+		congestion_wait(BLK_RW_ASYNC, HZ/10);
 		zone_set_flag(zone, ZONE_TAIL_LRU_DIRTY);
+	}
 
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
 		zone_idx(zone),
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

