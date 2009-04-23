From: akpm@linux-foundation.org
Subject: + page-allocator-update-nr_free_pages-only-as-necessary.patch added to -mm tree
Date: Thu, 23 Apr 2009 16:08:21 -0700
Message-ID: <200904232308.n3NN8MI4009832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760761AbZDWXNi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi


The patch titled
     page allocator: update NR_FREE_PAGES only as necessary
has been added to the -mm tree.  Its filename is
     page-allocator-update-nr_free_pages-only-as-necessary.patch

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
Subject: page allocator: update NR_FREE_PAGES only as necessary
From: Mel Gorman <mel@csn.ul.ie>

When pages are being freed to the buddy allocator, the zone NR_FREE_PAGES
counter must be updated.  In the case of bulk per-cpu page freeing, it's
updated once per page.  This retouches cache lines more than necessary. 
Update the counters one per per-cpu bulk free.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-update-nr_free_pages-only-as-necessary mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-update-nr_free_pages-only-as-necessary
+++ a/mm/page_alloc.c
@@ -460,7 +460,6 @@ static inline void __free_one_page(struc
 		int migratetype)
 {
 	unsigned long page_idx;
-	int order_size = 1 << order;
 
 	if (unlikely(PageCompound(page)))
 		if (unlikely(destroy_compound_page(page, order)))
@@ -470,10 +469,9 @@ static inline void __free_one_page(struc
 
 	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
 
-	VM_BUG_ON(page_idx & (order_size - 1));
+	VM_BUG_ON(page_idx & ((1 << order) - 1));
 	VM_BUG_ON(bad_range(zone, page));
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, order_size);
 	while (order < MAX_ORDER-1) {
 		unsigned long combined_idx;
 		struct page *buddy;
@@ -528,6 +526,8 @@ static void free_pages_bulk(struct zone 
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
+
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
 	while (count--) {
 		struct page *page;
 
@@ -546,6 +546,8 @@ static void free_one_page(struct zone *z
 	spin_lock(&zone->lock);
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
+
+	__mod_zone_page_state(zone, NR_FREE_PAGES, 1 << order);
 	__free_one_page(page, zone, order, migratetype);
 	spin_unlock(&zone->lock);
 }
@@ -690,7 +692,6 @@ struct page *__rmqueue_smallest(struct z
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
-		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
 		expand(zone, page, order, current_order, area, migratetype);
 		return page;
 	}
@@ -830,8 +831,6 @@ __rmqueue_fallback(struct zone *zone, in
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
 			rmv_page_order(page);
-			__mod_zone_page_state(zone, NR_FREE_PAGES,
-							-(1UL << order));
 
 			if (current_order == pageblock_order)
 				set_pageblock_migratetype(page,
@@ -904,6 +903,7 @@ static int rmqueue_bulk(struct zone *zon
 		set_page_private(page, migratetype);
 		list = &page->lru;
 	}
+	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
 	return i;
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
add-debugging-aid-for-memory-initialisation-problems.patch

