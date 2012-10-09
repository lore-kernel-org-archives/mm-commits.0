From: akpm@linux-foundation.org
Subject: [merged] mm-remove-vma-arg-from-page_evictable.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:13:38 -0700
Message-ID: <20121009181339.4BAC3200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52418 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2JISNm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:13:42 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so364707wgb.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:13:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, hannes@cmpxchg.org, mel@csn.ul.ie, riel@redhat.com, walken@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove vma arg from page_evictable
has been removed from the -mm tree.  Its filename was
     mm-remove-vma-arg-from-page_evictable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove vma arg from page_evictable

page_evictable(page, vma) is an irritant: almost all its callers pass
NULL for vma.  Remove the vma arg and use mlocked_vma_newpage(vma, page)
explicitly in the couple of places it's needed.  But in those places we
don't even need page_evictable() itself!  They're dealing with a freshly
allocated anonymous page, which has no "mapping" and cannot be mlocked yet.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/unevictable-lru.txt |   10 ++-------
 include/linux/swap.h                 |    2 -
 mm/internal.h                        |    5 +---
 mm/ksm.c                             |    2 -
 mm/rmap.c                            |    2 -
 mm/swap.c                            |    2 -
 mm/vmscan.c                          |   27 ++++++++-----------------
 7 files changed, 18 insertions(+), 32 deletions(-)

diff -puN Documentation/vm/unevictable-lru.txt~mm-remove-vma-arg-from-page_evictable Documentation/vm/unevictable-lru.txt
--- a/Documentation/vm/unevictable-lru.txt~mm-remove-vma-arg-from-page_evictable
+++ a/Documentation/vm/unevictable-lru.txt
@@ -197,12 +197,8 @@ the pages are also "rescued" from the un
 freeing them.
 
 page_evictable() also checks for mlocked pages by testing an additional page
-flag, PG_mlocked (as wrapped by PageMlocked()).  If the page is NOT mlocked,
-and a non-NULL VMA is supplied, page_evictable() will check whether the VMA is
-VM_LOCKED via is_mlocked_vma().  is_mlocked_vma() will SetPageMlocked() and
-update the appropriate statistics if the vma is VM_LOCKED.  This method allows
-efficient "culling" of pages in the fault path that are being faulted in to
-VM_LOCKED VMAs.
+flag, PG_mlocked (as wrapped by PageMlocked()), which is set when a page is
+faulted into a VM_LOCKED vma, or found in a vma being VM_LOCKED.
 
 
 VMSCAN'S HANDLING OF UNEVICTABLE PAGES
@@ -651,7 +647,7 @@ PAGE RECLAIM IN shrink_*_list()
 -------------------------------
 
 shrink_active_list() culls any obviously unevictable pages - i.e.
-!page_evictable(page, NULL) - diverting these to the unevictable list.
+!page_evictable(page) - diverting these to the unevictable list.
 However, shrink_active_list() only sees unevictable pages that made it onto the
 active/inactive lru lists.  Note that these pages do not have PageUnevictable
 set - otherwise they would be on the unevictable list and shrink_active_list
diff -puN include/linux/swap.h~mm-remove-vma-arg-from-page_evictable include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-vma-arg-from-page_evictable
+++ a/include/linux/swap.h
@@ -281,7 +281,7 @@ static inline int zone_reclaim(struct zo
 }
 #endif
 
-extern int page_evictable(struct page *page, struct vm_area_struct *vma);
+extern int page_evictable(struct page *page);
 extern void check_move_unevictable_pages(struct page **, int nr_pages);
 
 extern unsigned long scan_unevictable_pages;
diff -puN mm/internal.h~mm-remove-vma-arg-from-page_evictable mm/internal.h
--- a/mm/internal.h~mm-remove-vma-arg-from-page_evictable
+++ a/mm/internal.h
@@ -168,9 +168,8 @@ static inline void munlock_vma_pages_all
 }
 
 /*
- * Called only in fault path via page_evictable() for a new page
- * to determine if it's being mapped into a LOCKED vma.
- * If so, mark page as mlocked.
+ * Called only in fault path, to determine if a new page is being
+ * mapped into a LOCKED vma.  If it is, mark page as mlocked.
  */
 static inline int mlocked_vma_newpage(struct vm_area_struct *vma,
 				    struct page *page)
diff -puN mm/ksm.c~mm-remove-vma-arg-from-page_evictable mm/ksm.c
--- a/mm/ksm.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/ksm.c
@@ -1586,7 +1586,7 @@ struct page *ksm_does_need_to_copy(struc
 		SetPageSwapBacked(new_page);
 		__set_page_locked(new_page);
 
-		if (page_evictable(new_page, vma))
+		if (!mlocked_vma_newpage(vma, new_page))
 			lru_cache_add_lru(new_page, LRU_ACTIVE_ANON);
 		else
 			add_page_to_unevictable_list(new_page);
diff -puN mm/rmap.c~mm-remove-vma-arg-from-page_evictable mm/rmap.c
--- a/mm/rmap.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/rmap.c
@@ -1080,7 +1080,7 @@ void page_add_new_anon_rmap(struct page 
 	else
 		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
 	__page_set_anon_rmap(page, vma, address, 1);
-	if (page_evictable(page, vma))
+	if (!mlocked_vma_newpage(vma, page))
 		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
 	else
 		add_page_to_unevictable_list(page);
diff -puN mm/swap.c~mm-remove-vma-arg-from-page_evictable mm/swap.c
--- a/mm/swap.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/swap.c
@@ -751,7 +751,7 @@ void lru_add_page_tail(struct page *page
 
 	SetPageLRU(page_tail);
 
-	if (page_evictable(page_tail, NULL)) {
+	if (page_evictable(page_tail)) {
 		if (PageActive(page)) {
 			SetPageActive(page_tail);
 			active = 1;
diff -puN mm/vmscan.c~mm-remove-vma-arg-from-page_evictable mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-vma-arg-from-page_evictable
+++ a/mm/vmscan.c
@@ -553,7 +553,7 @@ void putback_lru_page(struct page *page)
 redo:
 	ClearPageUnevictable(page);
 
-	if (page_evictable(page, NULL)) {
+	if (page_evictable(page)) {
 		/*
 		 * For evictable pages, we can use the cache.
 		 * In event of a race, worst case is we end up with an
@@ -587,7 +587,7 @@ redo:
 	 * page is on unevictable list, it never be freed. To avoid that,
 	 * check after we added it to the list, again.
 	 */
-	if (lru == LRU_UNEVICTABLE && page_evictable(page, NULL)) {
+	if (lru == LRU_UNEVICTABLE && page_evictable(page)) {
 		if (!isolate_lru_page(page)) {
 			put_page(page);
 			goto redo;
@@ -709,7 +709,7 @@ static unsigned long shrink_page_list(st
 
 		sc->nr_scanned++;
 
-		if (unlikely(!page_evictable(page, NULL)))
+		if (unlikely(!page_evictable(page)))
 			goto cull_mlocked;
 
 		if (!sc->may_unmap && page_mapped(page))
@@ -1217,7 +1217,7 @@ putback_inactive_pages(struct lruvec *lr
 
 		VM_BUG_ON(PageLRU(page));
 		list_del(&page->lru);
-		if (unlikely(!page_evictable(page, NULL))) {
+		if (unlikely(!page_evictable(page))) {
 			spin_unlock_irq(&zone->lru_lock);
 			putback_lru_page(page);
 			spin_lock_irq(&zone->lru_lock);
@@ -1470,7 +1470,7 @@ static void shrink_active_list(unsigned 
 		page = lru_to_page(&l_hold);
 		list_del(&page->lru);
 
-		if (unlikely(!page_evictable(page, NULL))) {
+		if (unlikely(!page_evictable(page))) {
 			putback_lru_page(page);
 			continue;
 		}
@@ -3414,27 +3414,18 @@ int zone_reclaim(struct zone *zone, gfp_
 /*
  * page_evictable - test whether a page is evictable
  * @page: the page to test
- * @vma: the VMA in which the page is or will be mapped, may be NULL
  *
  * Test whether page is evictable--i.e., should be placed on active/inactive
- * lists vs unevictable list.  The vma argument is !NULL when called from the
- * fault path to determine how to instantate a new page.
+ * lists vs unevictable list.
  *
  * Reasons page might not be evictable:
  * (1) page's mapping marked unevictable
  * (2) page is part of an mlocked VMA
  *
  */
-int page_evictable(struct page *page, struct vm_area_struct *vma)
+int page_evictable(struct page *page)
 {
-
-	if (mapping_unevictable(page_mapping(page)))
-		return 0;
-
-	if (PageMlocked(page) || (vma && mlocked_vma_newpage(vma, page)))
-		return 0;
