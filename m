From: akpm@linux-foundation.org
Subject: [merged] vmscan-merge-duplicate-code-in-shrink_active_list.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:36:26 -0700
Message-ID: <200906171836.n5HIaQse002498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760259AbZFQSh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, hannes@cmpxchg.org, minchan.kim@gmail.com, penberg@cs.helsinki.fi, peterz@infradead.org, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: merge duplicate code in shrink_active_list()
has been removed from the -mm tree.  Its filename was
     vmscan-merge-duplicate-code-in-shrink_active_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: merge duplicate code in shrink_active_list()
From: Wu Fengguang <fengguang.wu@intel.com>

The "move pages to active list" and "move pages to inactive list" code
blocks are mostly identical and can be served by a function.

Thanks to Andrew Morton for pointing this out.

Note that buffer_heads_over_limit check will also be carried out for
re-activated pages, which is slightly different from pre-2.6.28 kernels. 
Also, Rik's "vmscan: evict use-once pages first" patch could totally stop
scans of active file list when memory pressure is low.  So the net effect
could be, the number of buffer heads is now more likely to grow large.

However that's fine according to Johannes' comments:

  I don't think that this could be harmful.  We just preserve the buffer
  mappings of what we consider the working set and with low memory
  pressure, as you say, this set is not big.

  As to stripping of reactivated pages: the only pages we re-activate
  for now are those VM_EXEC mapped ones.  Since we don't expect IO from
  or to these pages, removing the buffer mappings in case they grow too
  large should be okay, I guess.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   95 ++++++++++++++++++++++----------------------------
 1 file changed, 42 insertions(+), 53 deletions(-)

diff -puN mm/vmscan.c~vmscan-merge-duplicate-code-in-shrink_active_list mm/vmscan.c
--- a/mm/vmscan.c~vmscan-merge-duplicate-code-in-shrink_active_list
+++ a/mm/vmscan.c
@@ -1204,6 +1204,43 @@ static inline void note_zone_scanning_pr
  * But we had to alter page->flags anyway.
  */
 
+static void move_active_pages_to_lru(struct zone *zone,
+				     struct list_head *list,
+				     enum lru_list lru)
+{
+	unsigned long pgmoved = 0;
+	struct pagevec pvec;
+	struct page *page;
+
+	pagevec_init(&pvec, 1);
+
+	while (!list_empty(list)) {
+		page = lru_to_page(list);
+		prefetchw_prev_lru_page(page, list, flags);
+
+		VM_BUG_ON(PageLRU(page));
+		SetPageLRU(page);
+
+		VM_BUG_ON(!PageActive(page));
+		if (!is_active_lru(lru))
+			ClearPageActive(page);	/* we are de-activating */
+
+		list_move(&page->lru, &zone->lru[lru].list);
+		mem_cgroup_add_lru_list(page, lru);
+		pgmoved++;
+
+		if (!pagevec_add(&pvec, page) || list_empty(list)) {
+			spin_unlock_irq(&zone->lru_lock);
+			if (buffer_heads_over_limit)
+				pagevec_strip(&pvec);
+			__pagevec_release(&pvec);
+			spin_lock_irq(&zone->lru_lock);
+		}
+	}
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	if (!is_active_lru(lru))
+		__count_vm_events(PGDEACTIVATE, pgmoved);
+}
 
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			struct scan_control *sc, int priority, int file)
@@ -1215,8 +1252,6 @@ static void shrink_active_list(unsigned 
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	struct page *page;
-	struct pagevec pvec;
-	enum lru_list lru;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	lru_add_drain();
@@ -1233,6 +1268,7 @@ static void shrink_active_list(unsigned 
 	}
 	reclaim_stat->recent_scanned[!!file] += pgmoved;
 
+	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
 	else
@@ -1275,8 +1311,6 @@ static void shrink_active_list(unsigned 
 	/*
 	 * Move pages back to the lru list.
 	 */
-	pagevec_init(&pvec, 1);
-
 	spin_lock_irq(&zone->lru_lock);
 	/*
 	 * Count referenced pages from currently used mappings as rotated,
@@ -1286,57 +1320,12 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
-	pgmoved = 0;  /* count pages moved to inactive list */
-	lru = LRU_BASE + file * LRU_FILE;
-	while (!list_empty(&l_inactive)) {
-		page = lru_to_page(&l_inactive);
-		prefetchw_prev_lru_page(page, &l_inactive, flags);
-		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
-		VM_BUG_ON(!PageActive(page));
-		ClearPageActive(page);
-
-		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_add_lru_list(page, lru);
-		pgmoved++;
-		if (!pagevec_add(&pvec, page)) {
-			spin_unlock_irq(&zone->lru_lock);
-			if (buffer_heads_over_limit)
-				pagevec_strip(&pvec);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
-		}
-	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	__count_zone_vm_events(PGREFILL, zone, pgscanned);
-	__count_vm_events(PGDEACTIVATE, pgmoved);
-
-	pgmoved = 0;  /* count pages moved back to active list */
-	lru = LRU_ACTIVE + file * LRU_FILE;
-	while (!list_empty(&l_active)) {
-		page = lru_to_page(&l_active);
-		prefetchw_prev_lru_page(page, &l_active, flags);
-		VM_BUG_ON(PageLRU(page));
-		SetPageLRU(page);
-		VM_BUG_ON(!PageActive(page));
-
-		list_move(&page->lru, &zone->lru[lru].list);
-		mem_cgroup_add_lru_list(page, lru);
-		pgmoved++;
-		if (!pagevec_add(&pvec, page)) {
-			spin_unlock_irq(&zone->lru_lock);
-			if (buffer_heads_over_limit)
-				pagevec_strip(&pvec);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
-		}
-	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
+	move_active_pages_to_lru(zone, &l_active,
+						LRU_ACTIVE + file * LRU_FILE);
+	move_active_pages_to_lru(zone, &l_inactive,
+						LRU_BASE   + file * LRU_FILE);
 
 	spin_unlock_irq(&zone->lru_lock);
-	if (buffer_heads_over_limit)
-		pagevec_strip(&pvec);
-	pagevec_release(&pvec);
 }
 
 static int inactive_anon_is_low_global(struct zone *zone)
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch

