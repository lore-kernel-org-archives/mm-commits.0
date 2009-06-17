From: akpm@linux-foundation.org
Subject: [merged] page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:34:06 -0700
Message-ID: <200906171834.n5HIY6uv032593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35019 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760021AbZFQSee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.h


The patch titled
     page allocator: do not call get_pageblock_migratetype() more than necessary
has been removed from the -mm tree.  Its filename was
     page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page allocator: do not call get_pageblock_migratetype() more than necessary
From: Mel Gorman <mel@csn.ul.ie>

get_pageblock_migratetype() is potentially called twice for every page
free.  Once, when being freed to the pcp lists and once when being freed
back to buddy.  When freeing from the pcp lists, it is known what the
pageblock type was at the time of free so use it rather than rechecking. 
In low memory situations under memory pressure, this might skew
anti-fragmentation slightly but the interference is minimal and decisions
that are fragmenting memory are being made anyway.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary
+++ a/mm/page_alloc.c
@@ -452,16 +452,18 @@ static inline int page_is_buddy(struct p
  */
 
 static inline void __free_one_page(struct page *page,
-		struct zone *zone, unsigned int order)
+		struct zone *zone, unsigned int order,
+		int migratetype)
 {
 	unsigned long page_idx;
 	int order_size = 1 << order;
-	int migratetype = get_pageblock_migratetype(page);
 
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
 			return;
 
+	VM_BUG_ON(migratetype == -1);
+
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
 	VM_BUG_ON(page_idx & (order_size - 1));
@@ -530,17 +532,18 @@ static void free_pages_bulk(struct zone 
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
-		__free_one_page(page, zone, order);
+		__free_one_page(page, zone, order, page_private(page));
 	}
 	spin_unlock(&zone->lock);
 }
 
-static void free_one_page(struct zone *zone, struct page *page, int order)
+static void free_one_page(struct zone *zone, struct page *page, int order,
+				int migratetype)
 {
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
-	__free_one_page(page, zone, order);
+	__free_one_page(page, zone, order, migratetype);
 	spin_unlock(&zone->lock);
 }
 
@@ -565,7 +568,8 @@ static void __free_pages_ok(struct page 
 
 	local_irq_save(flags);
 	__count_vm_events(PGFREE, 1 << order);
-	free_one_page(page_zone(page), page, order);
+	free_one_page(page_zone(page), page, order,
+					get_pageblock_migratetype(page));
 	local_irq_restore(flags);
 }
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
linux-next.patch
page_alloc-oops-when-setting-percpu_pagelist_fraction.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
add-debugging-aid-for-memory-initialisation-problems.patch

