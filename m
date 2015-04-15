From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-factor-out-fallback-freepage-checking.patch removed from -mm
 tree
Date: Wed, 15 Apr 2015 12:09:37 -0700
Message-ID: <552eb771.gfWp2aqQbMqqgN3y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbbDOTJi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Apr 2015 15:09:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: factor out fallback freepage checking
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-factor-out-fallback-freepage-checking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_alloc: factor out fallback freepage checking

This is preparation step to use page allocator's anti fragmentation logic
in compaction.  This patch just separates fallback freepage checking part
from fallback freepage management part.  Therefore, there is no functional
change.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |  153 ++++++++++++++++++++++++++++------------------
 1 file changed, 96 insertions(+), 57 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-factor-out-fallback-freepage-checking mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-factor-out-fallback-freepage-checking
+++ a/mm/page_alloc.c
@@ -1145,14 +1145,40 @@ static void change_pageblock_range(struc
  * as fragmentation caused by those allocations polluting movable pageblocks
  * is worse than movable allocations stealing from unmovable and reclaimable
  * pageblocks.
- *
- * If we claim more than half of the pageblock, change pageblock's migratetype
- * as well.
  */
-static void try_to_steal_freepages(struct zone *zone, struct page *page,
-				  int start_type, int fallback_type)
+static bool can_steal_fallback(unsigned int order, int start_mt)
+{
+	/*
+	 * Leaving this order check is intended, although there is
+	 * relaxed order check in next check. The reason is that
+	 * we can actually steal whole pageblock if this condition met,
+	 * but, below check doesn't guarantee it and that is just heuristic
+	 * so could be changed anytime.
+	 */
+	if (order >= pageblock_order)
+		return true;
+
+	if (order >= pageblock_order / 2 ||
+		start_mt == MIGRATE_RECLAIMABLE ||
+		start_mt == MIGRATE_UNMOVABLE ||
+		page_group_by_mobility_disabled)
+		return true;
+
+	return false;
+}
+
+/*
+ * This function implements actual steal behaviour. If order is large enough,
+ * we can steal whole pageblock. If not, we first move freepages in this
+ * pageblock and check whether half of pages are moved or not. If half of
+ * pages are moved, we can change migratetype of pageblock and permanently
+ * use it's pages as requested migratetype in the future.
+ */
+static void steal_suitable_fallback(struct zone *zone, struct page *page,
+							  int start_type)
 {
 	int current_order = page_order(page);
+	int pages;
 
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
@@ -1160,19 +1186,40 @@ static void try_to_steal_freepages(struc
 		return;
 	}
 
-	if (current_order >= pageblock_order / 2 ||
-	    start_type == MIGRATE_RECLAIMABLE ||
-	    start_type == MIGRATE_UNMOVABLE ||
-	    page_group_by_mobility_disabled) {
-		int pages;
-
-		pages = move_freepages_block(zone, page, start_type);
-
-		/* Claim the whole block if over half of it is free */
-		if (pages >= (1 << (pageblock_order-1)) ||
-				page_group_by_mobility_disabled)
-			set_pageblock_migratetype(page, start_type);
+	pages = move_freepages_block(zone, page, start_type);
+
+	/* Claim the whole block if over half of it is free */
+	if (pages >= (1 << (pageblock_order-1)) ||
+			page_group_by_mobility_disabled)
+		set_pageblock_migratetype(page, start_type);
+}
+
+/* Check whether there is a suitable fallback freepage with requested order. */
+static int find_suitable_fallback(struct free_area *area, unsigned int order,
+					int migratetype, bool *can_steal)
+{
+	int i;
+	int fallback_mt;
+
+	if (area->nr_free == 0)
+		return -1;
+
+	*can_steal = false;
+	for (i = 0;; i++) {
+		fallback_mt = fallbacks[migratetype][i];
+		if (fallback_mt == MIGRATE_RESERVE)
+			break;
+
+		if (list_empty(&area->free_list[fallback_mt]))
+			continue;
+
+		if (can_steal_fallback(order, migratetype))
+			*can_steal = true;
+
+		return fallback_mt;
 	}
+
+	return -1;
 }
 
 /* Remove an element from the buddy allocator from the fallback list */
@@ -1182,53 +1229,45 @@ __rmqueue_fallback(struct zone *zone, un
 	struct free_area *area;
 	unsigned int current_order;
 	struct page *page;
+	int fallback_mt;
+	bool can_steal;
 
 	/* Find the largest possible block of pages in the other list */
 	for (current_order = MAX_ORDER-1;
 				current_order >= order && current_order <= MAX_ORDER-1;
 				--current_order) {
-		int i;
-		for (i = 0;; i++) {
-			int migratetype = fallbacks[start_migratetype][i];
-			int buddy_type = start_migratetype;
-
-			/* MIGRATE_RESERVE handled later if necessary */
-			if (migratetype == MIGRATE_RESERVE)
-				break;
-
-			area = &(zone->free_area[current_order]);
-			if (list_empty(&area->free_list[migratetype]))
-				continue;
-
-			page = list_entry(area->free_list[migratetype].next,
-					struct page, lru);
-			area->nr_free--;
-
-			try_to_steal_freepages(zone, page, start_migratetype,
-								migratetype);
-
-			/* Remove the page from the freelists */
-			list_del(&page->lru);
-			rmv_page_order(page);
-
-			expand(zone, page, order, current_order, area,
-					buddy_type);
-
-			/*
-			 * The freepage_migratetype may differ from pageblock's
-			 * migratetype depending on the decisions in
-			 * try_to_steal_freepages(). This is OK as long as it
-			 * does not differ for MIGRATE_CMA pageblocks. For CMA
-			 * we need to make sure unallocated pages flushed from
-			 * pcp lists are returned to the correct freelist.
-			 */
-			set_freepage_migratetype(page, buddy_type);
+		area = &(zone->free_area[current_order]);
+		fallback_mt = find_suitable_fallback(area, current_order,
+				start_migratetype, &can_steal);
+		if (fallback_mt == -1)
+			continue;
+
+		page = list_entry(area->free_list[fallback_mt].next,
+						struct page, lru);
+		if (can_steal)
+			steal_suitable_fallback(zone, page, start_migratetype);
+
+		/* Remove the page from the freelists */
+		area->nr_free--;
+		list_del(&page->lru);
+		rmv_page_order(page);
+
+		expand(zone, page, order, current_order, area,
+					start_migratetype);
+		/*
+		 * The freepage_migratetype may differ from pageblock's
+		 * migratetype depending on the decisions in
+		 * try_to_steal_freepages(). This is OK as long as it
+		 * does not differ for MIGRATE_CMA pageblocks. For CMA
+		 * we need to make sure unallocated pages flushed from
+		 * pcp lists are returned to the correct freelist.
+		 */
+		set_freepage_migratetype(page, start_migratetype);
 
-			trace_mm_page_alloc_extfrag(page, order, current_order,
-				start_migratetype, migratetype);
+		trace_mm_page_alloc_extfrag(page, order, current_order,
+			start_migratetype, fallback_mt);
 
-			return page;
-		}
+		return page;
 	}
 
 	return NULL;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3.patch
slub-bulk-alloc-extract-objects-from-the-per-cpu-slab.patch
slub-bulk-allocation-from-per-cpu-partial-pages.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
mm-compaction-reset-compaction-scanner-positions.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure.patch
hugetlbfs-add-minimum-size-accounting-to-subpools.patch
hugetlbfs-accept-subpool-min_size-mount-option-and-setup-accordingly.patch
hugetlbfs-document-min_size-mount-option-and-cleanup.patch
mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
mm-cma-add-trace-events-for-cma-allocations-and-freeings.patch
mm-cma-add-trace-events-for-cma-allocations-and-freeings-fix.patch
mm-cma-add-functions-to-get-region-pages-counters.patch
mm-cma-add-functions-to-get-region-pages-counters-fix.patch
mm-cma-add-functions-to-get-region-pages-counters-fix-2.patch
mm-cma-add-functions-to-get-region-pages-counters-fix-3.patch
mm-cma_debugc-remove-blank-lines-before-define_simple_attribute.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zsmalloc-zsmalloc-documentation.patch

