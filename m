From: akpm@linux-foundation.org
Subject: + split-the-free-lists-for-movable-and-unmovable-allocations.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:31 -0800
Message-ID: <200703022141.l22LfWTY019759@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42044 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbXCBVlh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Split the free lists for movable and unmovable allocations
has been added to the -mm tree.  Its filename is
     split-the-free-lists-for-movable-and-unmovable-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Split the free lists for movable and unmovable allocations
From: Mel Gorman <mel@csn.ul.ie>

This patch adds the core of the fragmentation reduction strategy.  It works by
grouping pages together based on their ability to migrate or be reclaimed. 
Basically, it works by breaking the list in zone->free_area list into
MIGRATE_TYPES number of lists.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h          |   10 +-
 include/linux/pageblock-flags.h |    1 
 mm/page_alloc.c                 |  140 +++++++++++++++++++++++++-----
 3 files changed, 127 insertions(+), 24 deletions(-)

diff -puN include/linux/mmzone.h~split-the-free-lists-for-movable-and-unmovable-allocations include/linux/mmzone.h
--- a/include/linux/mmzone.h~split-the-free-lists-for-movable-and-unmovable-allocations
+++ a/include/linux/mmzone.h
@@ -25,8 +25,16 @@
 #endif
 #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
 
+#define MIGRATE_UNMOVABLE     0
+#define MIGRATE_MOVABLE       1
+#define MIGRATE_TYPES         2
+
+#define for_each_migratetype_order(order, type) \
+	for (order = 0; order < MAX_ORDER; order++) \
+		for (type = 0; type < MIGRATE_TYPES; type++)
+
 struct free_area {
-	struct list_head	free_list;
+	struct list_head	free_list[MIGRATE_TYPES];
 	unsigned long		nr_free;
 };
 
diff -puN include/linux/pageblock-flags.h~split-the-free-lists-for-movable-and-unmovable-allocations include/linux/pageblock-flags.h
--- a/include/linux/pageblock-flags.h~split-the-free-lists-for-movable-and-unmovable-allocations
+++ a/include/linux/pageblock-flags.h
@@ -31,6 +31,7 @@
 
 /* Bit indices that affect a whole block of pages */
 enum pageblock_bits {
+	PB_range(PB_migrate, 1), /* 1 bit required for migrate types */
 	NR_PAGEBLOCK_BITS
 };
 
diff -puN mm/page_alloc.c~split-the-free-lists-for-movable-and-unmovable-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~split-the-free-lists-for-movable-and-unmovable-allocations
+++ a/mm/page_alloc.c
@@ -136,6 +136,22 @@ static unsigned long __initdata dma_rese
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
+static inline int get_pageblock_migratetype(struct page *page)
+{
+	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
+}
+
+static void set_pageblock_migratetype(struct page *page, int migratetype)
+{
+	set_pageblock_flags_group(page, (unsigned long)migratetype,
+					PB_migrate, PB_migrate_end);
+}
+
+static inline int gfpflags_to_migratetype(gfp_t gfp_flags)
+{
+	return ((gfp_flags & __GFP_MOVABLE) != 0);
+}
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -391,6 +407,7 @@ static inline void __free_one_page(struc
 {
 	unsigned long page_idx;
 	int order_size = 1 << order;
+	int migratetype = get_pageblock_migratetype(page);
 
 	if (unlikely(PageCompound(page)))
 		destroy_compound_page(page, order);
@@ -403,7 +420,6 @@ static inline void __free_one_page(struc
 	__mod_zone_page_state(zone, NR_FREE_PAGES, order_size);
 	while (order < MAX_ORDER-1) {
 		unsigned long combined_idx;
-		struct free_area *area;
 		struct page *buddy;
 
 		buddy = __page_find_buddy(page, page_idx, order);
@@ -411,8 +427,7 @@ static inline void __free_one_page(struc
 			break;		/* Move the buddy up one level. */
 
 		list_del(&buddy->lru);
-		area = zone->free_area + order;
-		area->nr_free--;
+		zone->free_area[order].nr_free--;
 		rmv_page_order(buddy);
 		combined_idx = __find_combined_index(page_idx, order);
 		page = page + (combined_idx - page_idx);
@@ -420,7 +435,8 @@ static inline void __free_one_page(struc
 		order++;
 	}
 	set_page_order(page, order);
-	list_add(&page->lru, &zone->free_area[order].free_list);
+	list_add(&page->lru,
+		&zone->free_area[order].free_list[migratetype]);
 	zone->free_area[order].nr_free++;
 }
 
@@ -560,7 +576,8 @@ void fastcall __init __free_pages_bootme
  * -- wli
  */
 static inline void expand(struct zone *zone, struct page *page,
- 	int low, int high, struct free_area *area)
+	int low, int high, struct free_area *area,
+	int migratetype)
 {
 	unsigned long size = 1 << high;
 
@@ -569,7 +586,7 @@ static inline void expand(struct zone *z
 		high--;
 		size >>= 1;
 		VM_BUG_ON(bad_range(zone, &page[size]));
-		list_add(&page[size].lru, &area->free_list);
+		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
 		set_page_order(&page[size], high);
 	}
@@ -623,31 +640,95 @@ static int prep_new_page(struct page *pa
 	return 0;
 }
 
+/*
+ * This array describes the order lists are fallen back to when
+ * the free lists for the desirable migrate type are depleted
+ */
+static int fallbacks[MIGRATE_TYPES][MIGRATE_TYPES-1] = {
+	[MIGRATE_UNMOVABLE] = { MIGRATE_MOVABLE   },
+	[MIGRATE_MOVABLE]   = { MIGRATE_UNMOVABLE },
+};
+
+/* Remove an element from the buddy allocator from the fallback list */
+static struct page *__rmqueue_fallback(struct zone *zone, int order,
+						int start_migratetype)
+{
+	struct free_area * area;
+	int current_order;
+	struct page *page;
+	int migratetype, i;
+
+	/* Find the largest possible block of pages in the other list */
+	for (current_order = MAX_ORDER-1; current_order >= order;
+						--current_order) {
+		for (i = 0; i < MIGRATE_TYPES - 1; i++) {
+			migratetype = fallbacks[start_migratetype][i];
+
+			area = &(zone->free_area[current_order]);
+			if (list_empty(&area->free_list[migratetype]))
+				continue;
+
+			page = list_entry(area->free_list[migratetype].next,
+					struct page, lru);
+			area->nr_free--;
+
+			/*
+			 * If breaking a large block of pages, place the buddies
+			 * on the preferred allocation list
+			 */
+			if (unlikely(current_order >= MAX_ORDER / 2))
+				migratetype = start_migratetype;
+
+			/* Remove the page from the freelists */
+			list_del(&page->lru);
+			rmv_page_order(page);
+			__mod_zone_page_state(zone, NR_FREE_PAGES,
+							-(1UL << order));
+
+			if (current_order == MAX_ORDER - 1)
+				set_pageblock_migratetype(page,
+							start_migratetype);
+
+			expand(zone, page, order, current_order, area, migratetype);
+			return page;
+		}
+	}
+
+	return NULL;
+}
+
 /* 
  * Do the hard work of removing an element from the buddy allocator.
  * Call me with the zone->lock already held.
  */
-static struct page *__rmqueue(struct zone *zone, unsigned int order)
+static struct page *__rmqueue(struct zone *zone, unsigned int order,
+						int migratetype)
 {
 	struct free_area * area;
 	unsigned int current_order;
 	struct page *page;
 
+	/* Find a page of the appropriate size in the preferred list */
 	for (current_order = order; current_order < MAX_ORDER; ++current_order) {
-		area = zone->free_area + current_order;
-		if (list_empty(&area->free_list))
+		area = &(zone->free_area[current_order]);
+		if (list_empty(&area->free_list[migratetype]))
 			continue;
 
-		page = list_entry(area->free_list.next, struct page, lru);
+		page = list_entry(area->free_list[migratetype].next,
+							struct page, lru);
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
 		__mod_zone_page_state(zone, NR_FREE_PAGES, - (1UL << order));
-		expand(zone, page, order, current_order, area);
-		return page;
+		expand(zone, page, order, current_order, area, migratetype);
+		goto got_page;
 	}
 
-	return NULL;
+	page = __rmqueue_fallback(zone, order, migratetype);
+
+got_page:
+
+	return page;
 }
 
 /* 
@@ -656,13 +737,14 @@ static struct page *__rmqueue(struct zon
  * Returns the number of new pages which were placed at *list.
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order, 
-			unsigned long count, struct list_head *list)
+			unsigned long count, struct list_head *list,
+			int migratetype)
 {
 	int i;
 	
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
-		struct page *page = __rmqueue(zone, order);
+		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
 		list_add_tail(&page->lru, list);
@@ -764,7 +846,7 @@ void mark_free_pages(struct zone *zone)
 {
 	unsigned long pfn, max_zone_pfn;
 	unsigned long flags;
-	int order;
+	int order, t;
 	struct list_head *curr;
 
 	if (!zone->spanned_pages)
@@ -781,14 +863,15 @@ void mark_free_pages(struct zone *zone)
 				ClearPageNosaveFree(page);
 		}
 
-	for (order = MAX_ORDER - 1; order >= 0; --order)
-		list_for_each(curr, &zone->free_area[order].free_list) {
+	for_each_migratetype_order(order, t) {
+		list_for_each(curr, &zone->free_area[order].free_list[t]) {
 			unsigned long i;
 
 			pfn = page_to_pfn(list_entry(curr, struct page, lru));
 			for (i = 0; i < (1UL << order); i++)
 				SetPageNosaveFree(pfn_to_page(pfn + i));
 		}
+	}
 
 	spin_unlock_irqrestore(&zone->lock, flags);
 }
@@ -878,6 +961,7 @@ static struct page *buffered_rmqueue(str
 	struct page *page;
 	int cold = !!(gfp_flags & __GFP_COLD);
 	int cpu;
+	int migratetype = gfpflags_to_migratetype(gfp_flags);
 
 again:
 	cpu  = get_cpu();
@@ -888,7 +972,7 @@ again:
 		local_irq_save(flags);
 		if (!pcp->count) {
 			pcp->count = rmqueue_bulk(zone, 0,
-						pcp->batch, &pcp->list);
+					pcp->batch, &pcp->list, migratetype);
 			if (unlikely(!pcp->count))
 				goto failed;
 		}
@@ -897,7 +981,7 @@ again:
 		pcp->count--;
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
-		page = __rmqueue(zone, order);
+		page = __rmqueue(zone, order, migratetype);
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
@@ -1978,6 +2062,16 @@ void __meminit memmap_init_zone(unsigned
 		init_page_count(page);
 		reset_page_mapcount(page);
 		SetPageReserved(page);
+
+		/*
+		 * Mark the block movable so that blocks are reserved for
+		 * movable at startup. This will force kernel allocations
+		 * to reserve their blocks rather than leaking throughout
+		 * the address space during boot when many long-lived
+		 * kernel allocations are made
+		 */
+		set_pageblock_migratetype(page, MIGRATE_MOVABLE);
+
 		INIT_LIST_HEAD(&page->lru);
 #ifdef WANT_PAGE_VIRTUAL
 		/* The shift won't overflow because ZONE_NORMAL is below 4G. */
@@ -1990,9 +2084,9 @@ void __meminit memmap_init_zone(unsigned
 void zone_init_free_lists(struct pglist_data *pgdat, struct zone *zone,
 				unsigned long size)
 {
-	int order;
-	for (order = 0; order < MAX_ORDER ; order++) {
-		INIT_LIST_HEAD(&zone->free_area[order].free_list);
+	int order, t;
+	for_each_migratetype_order(order, t) {
+		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
 		zone->free_area[order].nr_free = 0;
 	}
 }
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
