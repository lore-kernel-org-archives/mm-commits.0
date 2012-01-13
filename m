From: akpm@linux-foundation.org
Subject: [merged] mm-take-pagevecs-off-reclaim-stack.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:43 -0800
Message-ID: <20120113203543.BD8C6100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42894 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab2AMUfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:44 -0500
Received: by mail-yw0-f74.google.com with SMTP id j52so102112yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: take pagevecs off reclaim stack
has been removed from the -mm tree.  Its filename was
     mm-take-pagevecs-off-reclaim-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: take pagevecs off reclaim stack

Replace pagevecs in putback_lru_pages() and move_active_pages_to_lru()
by lists of pages_to_free: then apply Konstantin Khlebnikov's
free_hot_cold_page_list() to them instead of pagevec_release().

Which simplifies the flow (no need to drop and retake lock whenever
pagevec fills up) and reduces stale addresses in stack backtraces
(which often showed through the pagevecs); but more importantly,
removes another 120 bytes from the deepest stacks in page reclaim.
Although I've not recently seen an actual stack overflow here with
a vanilla kernel, move_active_pages_to_lru() has often featured in
deep backtraces.

However, free_hot_cold_page_list() does not handle compound pages
(nor need it: a Transparent HugePage would have been split by the
time it reaches the call in shrink_page_list()), but it is possible
for putback_lru_pages() or move_active_pages_to_lru() to be left
holding the last reference on a THP, so must exclude the unlikely
compound case before putting on pages_to_free.

Remove pagevec_strip(), its work now done in move_active_pages_to_lru().
The pagevec in scan_mapping_unevictable_pages() remains in mm/vmscan.c,
but that is never on the reclaim path, and cannot be replaced by a list.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    2 -
 mm/swap.c               |   19 ------------
 mm/vmscan.c             |   58 ++++++++++++++++++++++++++------------
 3 files changed, 40 insertions(+), 39 deletions(-)

diff -puN include/linux/pagevec.h~mm-take-pagevecs-off-reclaim-stack include/linux/pagevec.h
--- a/include/linux/pagevec.h~mm-take-pagevecs-off-reclaim-stack
+++ a/include/linux/pagevec.h
@@ -22,7 +22,6 @@ struct pagevec {
 
 void __pagevec_release(struct pagevec *pvec);
 void ____pagevec_lru_add(struct pagevec *pvec, enum lru_list lru);
-void pagevec_strip(struct pagevec *pvec);
 unsigned pagevec_lookup(struct pagevec *pvec, struct address_space *mapping,
 		pgoff_t start, unsigned nr_pages);
 unsigned pagevec_lookup_tag(struct pagevec *pvec,
@@ -59,7 +58,6 @@ static inline unsigned pagevec_add(struc
 	return pagevec_space(pvec);
 }
 
-
 static inline void pagevec_release(struct pagevec *pvec)
 {
 	if (pagevec_count(pvec))
diff -puN mm/swap.c~mm-take-pagevecs-off-reclaim-stack mm/swap.c
--- a/mm/swap.c~mm-take-pagevecs-off-reclaim-stack
+++ a/mm/swap.c
@@ -23,7 +23,6 @@
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/mm_inline.h>
-#include <linux/buffer_head.h>	/* for try_to_release_page() */
 #include <linux/percpu_counter.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
@@ -730,24 +729,6 @@ void ____pagevec_lru_add(struct pagevec 
 
 EXPORT_SYMBOL(____pagevec_lru_add);
 
-/*
- * Try to drop buffers from the pages in a pagevec
- */
-void pagevec_strip(struct pagevec *pvec)
-{
-	int i;
-
-	for (i = 0; i < pagevec_count(pvec); i++) {
-		struct page *page = pvec->pages[i];
-
-		if (page_has_private(page) && trylock_page(page)) {
-			if (page_has_private(page))
-				try_to_release_page(page, 0);
-			unlock_page(page);
-		}
-	}
-}
-
 /**
  * pagevec_lookup - gang pagecache lookup
  * @pvec:	Where the resulting pages are placed
diff -puN mm/vmscan.c~mm-take-pagevecs-off-reclaim-stack mm/vmscan.c
--- a/mm/vmscan.c~mm-take-pagevecs-off-reclaim-stack
+++ a/mm/vmscan.c
@@ -1398,12 +1398,10 @@ putback_lru_pages(struct mem_cgroup_zone
 		  struct list_head *page_list)
 {
 	struct page *page;
-	struct pagevec pvec;
+	LIST_HEAD(pages_to_free);
 	struct zone *zone = mz->zone;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 
-	pagevec_init(&pvec, 1);
-
 	/*
 	 * Put back any unfreeable pages.
 	 */
@@ -1427,17 +1425,24 @@ putback_lru_pages(struct mem_cgroup_zone
 			int numpages = hpage_nr_pages(page);
 			reclaim_stat->recent_rotated[file] += numpages;
 		}
-		if (!pagevec_add(&pvec, page)) {
-			spin_unlock_irq(&zone->lru_lock);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
+		if (put_page_testzero(page)) {
+			__ClearPageLRU(page);
+			__ClearPageActive(page);
+			del_page_from_lru_list(zone, page, lru);
+
+			if (unlikely(PageCompound(page))) {
+				spin_unlock_irq(&zone->lru_lock);
+				(*get_compound_page_dtor(page))(page);
+				spin_lock_irq(&zone->lru_lock);
+			} else
+				list_add(&page->lru, &pages_to_free);
 		}
 	}
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON, -nr_anon);
 	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -nr_file);
 
 	spin_unlock_irq(&zone->lru_lock);
-	pagevec_release(&pvec);
+	free_hot_cold_page_list(&pages_to_free, 1);
 }
 
 static noinline_for_stack void
@@ -1647,13 +1652,23 @@ shrink_inactive_list(unsigned long nr_to
 
 static void move_active_pages_to_lru(struct zone *zone,
 				     struct list_head *list,
+				     struct list_head *pages_to_free,
 				     enum lru_list lru)
 {
 	unsigned long pgmoved = 0;
-	struct pagevec pvec;
 	struct page *page;
 
-	pagevec_init(&pvec, 1);
+	if (buffer_heads_over_limit) {
+		spin_unlock_irq(&zone->lru_lock);
+		list_for_each_entry(page, list, lru) {
+			if (page_has_private(page) && trylock_page(page)) {
+				if (page_has_private(page))
+					try_to_release_page(page, 0);
+				unlock_page(page);
+			}
+		}
+		spin_lock_irq(&zone->lru_lock);
+	}
 
 	while (!list_empty(list)) {
 		struct lruvec *lruvec;
@@ -1667,12 +1682,17 @@ static void move_active_pages_to_lru(str
 		list_move(&page->lru, &lruvec->lists[lru]);
 		pgmoved += hpage_nr_pages(page);
 
-		if (!pagevec_add(&pvec, page) || list_empty(list)) {
-			spin_unlock_irq(&zone->lru_lock);
-			if (buffer_heads_over_limit)
-				pagevec_strip(&pvec);
-			__pagevec_release(&pvec);
-			spin_lock_irq(&zone->lru_lock);
+		if (put_page_testzero(page)) {
+			__ClearPageLRU(page);
+			__ClearPageActive(page);
+			del_page_from_lru_list(zone, page, lru);
+
+			if (unlikely(PageCompound(page))) {
+				spin_unlock_irq(&zone->lru_lock);
+				(*get_compound_page_dtor(page))(page);
+				spin_lock_irq(&zone->lru_lock);
+			} else
+				list_add(&page->lru, pages_to_free);
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
@@ -1766,12 +1786,14 @@ static void shrink_active_list(unsigned 
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
 
-	move_active_pages_to_lru(zone, &l_active,
+	move_active_pages_to_lru(zone, &l_active, &l_hold,
 						LRU_ACTIVE + file * LRU_FILE);
-	move_active_pages_to_lru(zone, &l_inactive,
+	move_active_pages_to_lru(zone, &l_inactive, &l_hold,
 						LRU_BASE   + file * LRU_FILE);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
+
+	free_hot_cold_page_list(&l_hold, 1);
 }
 
 #ifdef CONFIG_SWAP
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
prio_tree-debugging-patch.patch

