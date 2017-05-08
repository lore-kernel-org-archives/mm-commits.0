From: akpm@linux-foundation.org
Subject: [patch 003/114] mm, page_alloc: split smallest stolen page
 in fallback
Date: Mon, 08 May 2017 15:54:37 -0700
Message-ID: <20170508225437.Kxm8D2IpK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45374 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751596AbdEHWyj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:54:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: split smallest stolen page in fallback

The __rmqueue_fallback() function is called when there's no free page of
requested migratetype, and we need to steal from a different one.  There
are various heuristics to make this event infrequent and reduce permanent
fragmentation.  The main one is to try stealing from a pageblock that has
the most free pages, and possibly steal them all at once and convert the
whole pageblock.  Precise searching for such pageblock would be expensive,
so instead the heuristics walks the free lists from MAX_ORDER down to
requested order and assumes that the block with highest-order free page is
likely to also have the most free pages in total.

Chances are that together with the highest-order page, we steal also pages
of lower orders from the same block.  But then we still split the highest
order page.  This is wasteful and can contribute to fragmentation instead
of avoiding it.

This patch thus changes __rmqueue_fallback() to just steal the page(s) and
put them on the freelist of the requested migratetype, and only report
whether it was successful.  Then we pick (and eventually split) the
smallest page with __rmqueue_smallest().  This all happens under zone
lock, so nobody can steal it from us in the process.  This should reduce
fragmentation due to fallbacks.  At worst we are only stealing a single
highest-order page and waste some cycles by moving it between lists and
then removing it, but fallback is not exactly hot path so that should not
be a concern.  As a side benefit the patch removes some duplicate code by
reusing __rmqueue_smallest().

[vbabka@suse.cz: fix endless loop in the modified __rmqueue()]
  Link: http://lkml.kernel.org/r/59d71b35-d556-4fc9-ee2e-1574259282fd@suse.cz
Link: http://lkml.kernel.org/r/20170307131545.28577-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   62 +++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-split-smallest-stolen-page-in-fallback mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-split-smallest-stolen-page-in-fallback
+++ a/mm/page_alloc.c
@@ -1948,23 +1948,44 @@ static bool can_steal_fallback(unsigned
  * use it's pages as requested migratetype in the future.
  */
 static void steal_suitable_fallback(struct zone *zone, struct page *page,
-							  int start_type)
+					int start_type, bool whole_block)
 {
 	unsigned int current_order = page_order(page);
+	struct free_area *area;
 	int pages;
 
+	/*
+	 * This can happen due to races and we want to prevent broken
+	 * highatomic accounting.
+	 */
+	if (is_migrate_highatomic_page(page))
+		goto single_page;
+
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		change_pageblock_range(page, current_order, start_type);
-		return;
+		goto single_page;
 	}
 
+	/* We are not allowed to try stealing from the whole block */
+	if (!whole_block)
+		goto single_page;
+
 	pages = move_freepages_block(zone, page, start_type);
+	/* moving whole block can fail due to zone boundary conditions */
+	if (!pages)
+		goto single_page;
 
 	/* Claim the whole block if over half of it is free */
 	if (pages >= (1 << (pageblock_order-1)) ||
 			page_group_by_mobility_disabled)
 		set_pageblock_migratetype(page, start_type);
+
+	return;
+
+single_page:
+	area = &zone->free_area[current_order];
+	list_move(&page->lru, &area->free_list[start_type]);
 }
 
 /*
@@ -2123,8 +2144,13 @@ static bool unreserve_highatomic_pageblo
 	return false;
 }
 
-/* Remove an element from the buddy allocator from the fallback list */
-static inline struct page *
+/*
+ * Try finding a free buddy page on the fallback list and put it on the free
+ * list of requested migratetype, possibly along with other pages from the same
+ * block, depending on fragmentation avoidance heuristics. Returns true if
+ * fallback was found so that __rmqueue_smallest() can grab it.
+ */
+static inline bool
 __rmqueue_fallback(struct zone *zone, unsigned int order, int start_migratetype)
 {
 	struct free_area *area;
@@ -2145,32 +2171,17 @@ __rmqueue_fallback(struct zone *zone, un
 
 		page = list_first_entry(&area->free_list[fallback_mt],
 						struct page, lru);
-		if (can_steal && !is_migrate_highatomic_page(page))
-			steal_suitable_fallback(zone, page, start_migratetype);
 
-		/* Remove the page from the freelists */
-		area->nr_free--;
-		list_del(&page->lru);
-		rmv_page_order(page);
-
-		expand(zone, page, order, current_order, area,
-					start_migratetype);
-		/*
-		 * The pcppage_migratetype may differ from pageblock's
-		 * migratetype depending on the decisions in
-		 * find_suitable_fallback(). This is OK as long as it does not
-		 * differ for MIGRATE_CMA pageblocks. Those can be used as
-		 * fallback only via special __rmqueue_cma_fallback() function
-		 */
-		set_pcppage_migratetype(page, start_migratetype);
+		steal_suitable_fallback(zone, page, start_migratetype,
+								can_steal);
 
 		trace_mm_page_alloc_extfrag(page, order, current_order,
 			start_migratetype, fallback_mt);
 
-		return page;
+		return true;
 	}
 
-	return NULL;
+	return false;
 }
 
 /*
@@ -2182,13 +2193,14 @@ static struct page *__rmqueue(struct zon
 {
 	struct page *page;
 
+retry:
 	page = __rmqueue_smallest(zone, order, migratetype);
 	if (unlikely(!page)) {
 		if (migratetype == MIGRATE_MOVABLE)
 			page = __rmqueue_cma_fallback(zone, order);
 
-		if (!page)
-			page = __rmqueue_fallback(zone, order, migratetype);
+		if (!page && __rmqueue_fallback(zone, order, migratetype))
+			goto retry;
 	}
 
 	trace_mm_page_alloc_zone_locked(page, order, migratetype);
_
