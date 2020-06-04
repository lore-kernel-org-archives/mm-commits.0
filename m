From: akpm@linux-foundation.org
Subject: [merged]
 mm-simplify-calling-a-compound-page-destructor.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:19:38 -0700
Message-ID: <20200604171938.Y7MV5lRzJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730081AbgFDRTi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anshuman.khandual@arm.com, david@redhat.com, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, willy@infradead.org


The patch titled
     Subject: mm: simplify calling a compound page destructor
has been removed from the -mm tree.  Its filename was
     mm-simplify-calling-a-compound-page-destructor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: simplify calling a compound page destructor

None of the three callers of get_compound_page_dtor() want to know the
value; they just want to call the function.  Replace it with
destroy_compound_page() which calls the dtor for them.

Link: http://lkml.kernel.org/r/20200517105051.9352-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++--
 mm/swap.c          |    5 +----
 mm/vmscan.c        |    4 ++--
 3 files changed, 5 insertions(+), 8 deletions(-)

--- a/include/linux/mm.h~mm-simplify-calling-a-compound-page-destructor
+++ a/include/linux/mm.h
@@ -876,10 +876,10 @@ static inline void set_compound_page_dto
 	page[1].compound_dtor = compound_dtor;
 }
 
-static inline compound_page_dtor *get_compound_page_dtor(struct page *page)
+static inline void destroy_compound_page(struct page *page)
 {
 	VM_BUG_ON_PAGE(page[1].compound_dtor >= NR_COMPOUND_DTORS, page);
-	return compound_page_dtors[page[1].compound_dtor];
+	compound_page_dtors[page[1].compound_dtor](page);
 }
 
 static inline unsigned int compound_order(struct page *page)
--- a/mm/swap.c~mm-simplify-calling-a-compound-page-destructor
+++ a/mm/swap.c
@@ -102,8 +102,6 @@ static void __put_single_page(struct pag
 
 static void __put_compound_page(struct page *page)
 {
-	compound_page_dtor *dtor;
-
 	/*
 	 * __page_cache_release() is supposed to be called for thp, not for
 	 * hugetlb. This is because hugetlb page does never have PageLRU set
@@ -112,8 +110,7 @@ static void __put_compound_page(struct p
 	 */
 	if (!PageHuge(page))
 		__page_cache_release(page);
-	dtor = get_compound_page_dtor(page);
-	(*dtor)(page);
+	destroy_compound_page(page);
 }
 
 void __put_page(struct page *page)
--- a/mm/vmscan.c~mm-simplify-calling-a-compound-page-destructor
+++ a/mm/vmscan.c
@@ -1438,7 +1438,7 @@ free_it:
 		 * appear not as the counts should be low
 		 */
 		if (unlikely(PageTransHuge(page)))
-			(*get_compound_page_dtor(page))(page);
+			destroy_compound_page(page);
 		else
 			list_add(&page->lru, &free_pages);
 		continue;
@@ -1859,7 +1859,7 @@ static unsigned noinline_for_stack move_
 
 			if (unlikely(PageCompound(page))) {
 				spin_unlock_irq(&pgdat->lru_lock);
-				(*get_compound_page_dtor(page))(page);
+				destroy_compound_page(page);
 				spin_lock_irq(&pgdat->lru_lock);
 			} else
 				list_add(&page->lru, &pages_to_free);
_

Patches currently in -mm which might be from willy@infradead.org are

ipc-convert-ipcs_idr-to-xarray.patch
ipc-convert-ipcs_idr-to-xarray-update.patch
