From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 078/131] mm: simplify calling a compound page
 destructor
Date: Wed, 03 Jun 2020 16:01:09 -0700
Message-ID: <20200603230109.YkSjoqPvO%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXBK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:01:10 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, david@redhat.com, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, willy@infradead.org

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
