From: akpm@linux-foundation.org
Subject: [merged] mm-add-free_hot_cold_page_list-helper.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:26:17 -0800
Message-ID: <20120111212617.B3ACB1E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:46539 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKV0S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:26:18 -0500
Received: by yhpp56 with SMTP id p56so153681yhp.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:26:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add free_hot_cold_page_list() helper
has been removed from the -mm tree.  Its filename was
     mm-add-free_hot_cold_page_list-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: add free_hot_cold_page_list() helper

This patch adds helper free_hot_cold_page_list() to free list of 0-order
pages.  It frees pages directly from list without temporary page-vector. 
It also calls trace_mm_pagevec_free() to simulate pagevec_free()
behaviour.

bloat-o-meter:

add/remove: 1/1 grow/shrink: 1/3 up/down: 267/-295 (-28)
function                                     old     new   delta
free_hot_cold_page_list                        -     264    +264
get_page_from_freelist                      2129    2132      +3
__pagevec_free                               243     239      -4
split_free_page                              380     373      -7
release_pages                                606     510     -96
free_page_list                               188       -    -188

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 +
 mm/page_alloc.c     |   13 +++++++++++++
 mm/swap.c           |   14 +++-----------
 mm/vmscan.c         |   20 +-------------------
 4 files changed, 18 insertions(+), 30 deletions(-)

diff -puN include/linux/gfp.h~mm-add-free_hot_cold_page_list-helper include/linux/gfp.h
--- a/include/linux/gfp.h~mm-add-free_hot_cold_page_list-helper
+++ a/include/linux/gfp.h
@@ -358,6 +358,7 @@ void *alloc_pages_exact_nid(int nid, siz
 extern void __free_pages(struct page *page, unsigned int order);
 extern void free_pages(unsigned long addr, unsigned int order);
 extern void free_hot_cold_page(struct page *page, int cold);
+extern void free_hot_cold_page_list(struct list_head *list, int cold);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr), 0)
diff -puN mm/page_alloc.c~mm-add-free_hot_cold_page_list-helper mm/page_alloc.c
--- a/mm/page_alloc.c~mm-add-free_hot_cold_page_list-helper
+++ a/mm/page_alloc.c
@@ -1189,6 +1189,19 @@ out:
 }
 
 /*
+ * Free a list of 0-order pages
+ */
+void free_hot_cold_page_list(struct list_head *list, int cold)
+{
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, list, lru) {
+		trace_mm_pagevec_free(page, cold);
+		free_hot_cold_page(page, cold);
+	}
+}
+
+/*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
  * Each sub-page must be freed individually.
diff -puN mm/swap.c~mm-add-free_hot_cold_page_list-helper mm/swap.c
--- a/mm/swap.c~mm-add-free_hot_cold_page_list-helper
+++ a/mm/swap.c
@@ -585,11 +585,10 @@ int lru_add_drain_all(void)
 void release_pages(struct page **pages, int nr, int cold)
 {
 	int i;
-	struct pagevec pages_to_free;
+	LIST_HEAD(pages_to_free);
 	struct zone *zone = NULL;
 	unsigned long uninitialized_var(flags);
 
-	pagevec_init(&pages_to_free, cold);
 	for (i = 0; i < nr; i++) {
 		struct page *page = pages[i];
 
@@ -620,19 +619,12 @@ void release_pages(struct page **pages, 
 			del_page_from_lru(zone, page);
 		}
 
-		if (!pagevec_add(&pages_to_free, page)) {
-			if (zone) {
-				spin_unlock_irqrestore(&zone->lru_lock, flags);
-				zone = NULL;
-			}
-			__pagevec_free(&pages_to_free);
-			pagevec_reinit(&pages_to_free);
-  		}
+		list_add(&page->lru, &pages_to_free);
 	}
 	if (zone)
 		spin_unlock_irqrestore(&zone->lru_lock, flags);
 
-	pagevec_free(&pages_to_free);
+	free_hot_cold_page_list(&pages_to_free, cold);
 }
 EXPORT_SYMBOL(release_pages);
 
diff -puN mm/vmscan.c~mm-add-free_hot_cold_page_list-helper mm/vmscan.c
--- a/mm/vmscan.c~mm-add-free_hot_cold_page_list-helper
+++ a/mm/vmscan.c
@@ -734,24 +734,6 @@ static enum page_references page_check_r
 	return PAGEREF_RECLAIM;
 }
 
-static noinline_for_stack void free_page_list(struct list_head *free_pages)
-{
-	struct pagevec freed_pvec;
-	struct page *page, *tmp;
-
-	pagevec_init(&freed_pvec, 1);
-
-	list_for_each_entry_safe(page, tmp, free_pages, lru) {
-		list_del(&page->lru);
-		if (!pagevec_add(&freed_pvec, page)) {
-			__pagevec_free(&freed_pvec);
-			pagevec_reinit(&freed_pvec);
-		}
-	}
-
-	pagevec_free(&freed_pvec);
-}
