From: akpm@linux-foundation.org
Subject: + move-free-pages-between-lists-on-steal.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:39 -0800
Message-ID: <200703022141.l22LfdiM019773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42055 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932234AbXCBVln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Move free pages between lists on steal
has been added to the -mm tree.  Its filename is
     move-free-pages-between-lists-on-steal.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Move free pages between lists on steal
From: Mel Gorman <mel@csn.ul.ie>

When a fallback occurs, there will be free pages for one allocation type
stored on the list for another.  When a large steal occurs, this patch will
move all the free pages within one list to the other.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   65 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 62 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~move-free-pages-between-lists-on-steal mm/page_alloc.c
--- a/mm/page_alloc.c~move-free-pages-between-lists-on-steal
+++ a/mm/page_alloc.c
@@ -667,6 +667,63 @@ static int fallbacks[MIGRATE_TYPES][MIGR
 	[MIGRATE_MOVABLE]   = { MIGRATE_UNMOVABLE },
 };
 
+/*
+ * Move the free pages in a range to the free lists of the requested type.
+ * Note that start_page and end_pages are not aligned in a MAX_ORDER_NR_PAGES
+ * boundary. If alignment is required, use move_freepages_block()
+ */
+int move_freepages(struct zone *zone,
+			struct page *start_page, struct page *end_page,
+			int migratetype)
+{
+	struct page *page;
+	unsigned long order;
+	int blocks_moved = 0;
+
+	BUG_ON(page_zone(start_page) != page_zone(end_page));
+
+	for (page = start_page; page < end_page;) {
+		if (!PageBuddy(page)) {
+			page++;
+			continue;
+		}
+#ifdef CONFIG_HOLES_IN_ZONE
+		if (!pfn_valid(page_to_pfn(page))) {
+			page++;
+			continue;
+		}
+#endif
+
+		order = page_order(page);
+		list_del(&page->lru);
+		list_add(&page->lru,
+			&zone->free_area[order].free_list[migratetype]);
+		page += 1 << order;
+		blocks_moved++;
+	}
+
+	return blocks_moved;
+}
+
+int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
+{
+	unsigned long start_pfn;
+	struct page *start_page, *end_page;
+
+	start_pfn = page_to_pfn(page);
+	start_pfn = start_pfn & ~(MAX_ORDER_NR_PAGES-1);
+	start_page = pfn_to_page(start_pfn);
+	end_page = start_page + MAX_ORDER_NR_PAGES;
+
+	/* Do not cross zone boundaries */
+	if (page_zone(page) != page_zone(start_page))
+		start_page = page;
+	if (page_zone(page) != page_zone(end_page))
+		return 0;
+
+	return move_freepages(zone, start_page, end_page, migratetype);
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
 						int start_migratetype)
@@ -691,11 +748,13 @@ static struct page *__rmqueue_fallback(s
 			area->nr_free--;
 
 			/*
-			 * If breaking a large block of pages, place the buddies
-			 * on the preferred allocation list
+			 * If breaking a large block of pages, move all free
+			 * pages to the preferred allocation list
 			 */
-			if (unlikely(current_order >= MAX_ORDER / 2))
+			if (unlikely(current_order >= MAX_ORDER / 2)) {
 				migratetype = start_migratetype;
+				move_freepages_block(zone, page, migratetype);
+			}
 
 			/* Remove the page from the freelists */
 			list_del(&page->lru);
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
