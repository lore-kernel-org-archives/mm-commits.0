From: akpm@linux-foundation.org
Subject: + vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch added to -mm tree
Date: Tue, 05 May 2009 13:16:46 -0700
Message-ID: <200905052016.n45KGknp005938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbZEEUW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 16:22:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     vmscan: ZVC updates in shrink_active_list() can be done once
has been added to the -mm tree.  Its filename is
     vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch

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
Subject: vmscan: ZVC updates in shrink_active_list() can be done once
From: Wu Fengguang <fengguang.wu@intel.com>

This effectively lifts the unit of updates to nr_inactive_* and
pgdeactivate from PAGEVEC_SIZE=14 to SWAP_CLUSTER_MAX=32, or
MAX_ORDER_NR_PAGES=1024 for reclaim_zone().

Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~vmscan-zvc-updates-in-shrink_active_list-can-be-done-once mm/vmscan.c
--- a/mm/vmscan.c~vmscan-zvc-updates-in-shrink_active_list-can-be-done-once
+++ a/mm/vmscan.c
@@ -1221,7 +1221,6 @@ static void shrink_active_list(unsigned 
 			struct scan_control *sc, int priority, int file)
 {
 	unsigned long pgmoved;
-	int pgdeactivate = 0;
 	unsigned long pgscanned;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
 	LIST_HEAD(l_inactive);
@@ -1250,7 +1249,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
-	pgmoved = 0;
+	pgmoved = 0;  /* count referenced (mapping) mapped pages */
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
@@ -1284,7 +1283,7 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
-	pgmoved = 0;
+	pgmoved = 0;  /* count pages moved to inactive list */
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
 		prefetchw_prev_lru_page(page, &l_inactive, flags);
@@ -1297,10 +1296,7 @@ static void shrink_active_list(unsigned 
 		mem_cgroup_add_lru_list(page, lru);
 		pgmoved++;
 		if (!pagevec_add(&pvec, page)) {
-			__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
 			spin_unlock_irq(&zone->lru_lock);
-			pgdeactivate += pgmoved;
-			pgmoved = 0;
 			if (buffer_heads_over_limit)
 				pagevec_strip(&pvec);
 			__pagevec_release(&pvec);
@@ -1308,9 +1304,8 @@ static void shrink_active_list(unsigned 
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	pgdeactivate += pgmoved;
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
-	__count_vm_events(PGDEACTIVATE, pgdeactivate);
+	__count_vm_events(PGDEACTIVATE, pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 	if (buffer_heads_over_limit)
 		pagevec_strip(&pvec);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive.patch
inotify-use-gfp_nofs-in-kernel_event-to-work-around-a-lockdep-false-positive-fix.patch
linux-next.patch
readahead-make-mmap_miss-an-unsigned-int.patch
readahead-move-max_sane_readahead-calls-into-force_page_cache_readahead.patch
readahead-apply-max_sane_readahead-limit-in-ondemand_readahead.patch
readahead-remove-one-unnecessary-radix-tree-lookup.patch
readahead-increase-interleaved-readahead-size.patch
readahead-remove-sync-async-readahead-call-dependency.patch
readahead-clean-up-and-simplify-the-code-for-filemap-page-fault-readahead.patch
readahead-sequential-mmap-readahead.patch
readahead-enforce-full-readahead-size-on-async-mmap-readahead.patch
readahead-record-mmap-read-around-states-in-file_ra_state.patch
radix-tree-add-radix_tree_prev_hole.patch
readahead-move-the-random-read-case-to-bottom.patch
readahead-introduce-context-readahead-algorithm.patch
readahead-introduce-context-readahead-algorithm-update.patch
readahead-remove-redundant-test-in-shrink_readahead_size_eio.patch
readahead-enforce-full-sync-mmap-readahead-size.patch
pagemap-document-clarifications.patch
pagemap-documentation-9-more-exported-page-flags.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages.patch
proc-kpagecount-kpageflags-code-cleanup.patch
proc-export-more-page-flags-in-proc-kpageflags.patch
vmscan-cleanup-the-scan-batching-code.patch
vmscan-dont-export-nr_saved_scan-in-proc-zoneinfo.patch
vmscan-zvc-updates-in-shrink_active_list-can-be-done-once.patch

