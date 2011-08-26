From: akpm@linux-foundation.org
Subject: + mm-add-free_hot_cold_page_list-helper.patch added to -mm tree
Date: Fri, 26 Aug 2011 15:21:38 -0700
Message-ID: <201108262221.p7QMLcjj015827@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213Ab1HZWWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 18:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     mm: add free_hot_cold_page_list() helper
has been added to the -mm tree.  Its filename is
     mm-add-free_hot_cold_page_list-helper.patch

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
Subject: mm: add free_hot_cold_page_list() helper
From: Konstantin Khlebnikov <khlebnikov@openvz.org>

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
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 +
 mm/page_alloc.c     |   12 ++++++++++++
 mm/swap.c           |   14 +++-----------
 mm/vmscan.c         |   20 +-------------------
 4 files changed, 17 insertions(+), 30 deletions(-)

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
@@ -1210,6 +1210,18 @@ out:
 	local_irq_restore(flags);
 }
 
+void free_hot_cold_page_list(struct list_head *list, int cold)
+{
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, list, lru) {
+		trace_mm_pagevec_free(page, cold);
+		free_hot_cold_page(page, cold);
+	}
+
+	INIT_LIST_HEAD(list);
+}
+
 /*
  * split_page takes a non-compound higher-order page, and splits it into
  * n (1<<order) sub-pages: page[0..n]
diff -puN mm/swap.c~mm-add-free_hot_cold_page_list-helper mm/swap.c
--- a/mm/swap.c~mm-add-free_hot_cold_page_list-helper
+++ a/mm/swap.c
@@ -562,11 +562,10 @@ int lru_add_drain_all(void)
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
 
@@ -597,19 +596,12 @@ void release_pages(struct page **pages, 
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
+		list_add_tail(&page->lru, &pages_to_free);
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
