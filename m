From: akpm@linux-foundation.org
Subject: - move-free-pages-between-lists-on-steal.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:38 -0700
Message-ID: <200710162034.l9GKYcTw014961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761564AbXJPVzJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, andyw@uk.ibm.com, bjorn.helgaas@hp.com, bob.picco@hp.com, clameter@engr.sgi.com, y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Move free pages between lists on steal
has been removed from the -mm tree.  Its filename was
     move-free-pages-between-lists-on-steal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Move free pages between lists on steal
From: Mel Gorman <mel@csn.ul.ie>

When a fallback occurs, there will be free pages for one allocation type
stored on the list for another.  When a large steal occurs, this patch will
move all the free pages within one list to the other.

[y-goto@jp.fujitsu.com: fix BUG_ON check at move_freepages()]
[apw@shadowen.org: Move to using pfn_valid_within()]
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andy Whitcroft <andyw@uk.ibm.com>
Cc: Bob Picco <bob.picco@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   74 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 71 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~move-free-pages-between-lists-on-steal mm/page_alloc.c
--- a/mm/page_alloc.c~move-free-pages-between-lists-on-steal
+++ a/mm/page_alloc.c
@@ -680,6 +680,72 @@ static int fallbacks[MIGRATE_TYPES][MIGR
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
+#ifndef CONFIG_HOLES_IN_ZONE
+	/*
+	 * page_zone is not safe to call in this context when
+	 * CONFIG_HOLES_IN_ZONE is set. This bug check is probably redundant
+	 * anyway as we check zone boundaries in move_freepages_block().
+	 * Remove at a later date when no bug reports exist related to
+	 * CONFIG_PAGE_GROUP_BY_MOBILITY
+	 */
+	BUG_ON(page_zone(start_page) != page_zone(end_page));
+#endif
+
+	for (page = start_page; page <= end_page;) {
+		if (!pfn_valid_within(page_to_pfn(page))) {
+			page++;
+			continue;
+		}
+
+		if (!PageBuddy(page)) {
+			page++;
+			continue;
+		}
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
+	unsigned long start_pfn, end_pfn;
+	struct page *start_page, *end_page;
+
+	start_pfn = page_to_pfn(page);
+	start_pfn = start_pfn & ~(MAX_ORDER_NR_PAGES-1);
+	start_page = pfn_to_page(start_pfn);
+	end_page = start_page + MAX_ORDER_NR_PAGES - 1;
+	end_pfn = start_pfn + MAX_ORDER_NR_PAGES - 1;
+
+	/* Do not cross zone boundaries */
+	if (start_pfn < zone->zone_start_pfn)
+		start_page = page;
+	if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
+		return 0;
+
+	return move_freepages(zone, start_page, end_page, migratetype);
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static struct page *__rmqueue_fallback(struct zone *zone, int order,
 						int start_migratetype)
@@ -704,11 +770,13 @@ static struct page *__rmqueue_fallback(s
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

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
