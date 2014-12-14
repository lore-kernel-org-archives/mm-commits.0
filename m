From: akpm@linux-foundation.org
Subject: [merged] mm-debug-pagealloc-cleanup-page-guard-code.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:07:02 -0800
Message-ID: <548d0ce6.mY5S9xACpC9kKeDQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47537 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbaLNEGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, gioh.kim@lge.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug-pagealloc: cleanup page guard code
has been removed from the -mm tree.  Its filename was
     mm-debug-pagealloc-cleanup-page-guard-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/debug-pagealloc: cleanup page guard code

Page guard is used by debug-pagealloc feature.  Currently, it is
open-coded, but, I think that more abstraction of it makes core page
allocator code more readable.

There is no functional difference.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Gioh Kim <gioh.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN mm/page_alloc.c~mm-debug-pagealloc-cleanup-page-guard-code mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-pagealloc-cleanup-page-guard-code
+++ a/mm/page_alloc.c
@@ -439,18 +439,29 @@ static int __init debug_guardpage_minord
 }
 __setup("debug_guardpage_minorder=", debug_guardpage_minorder_setup);
 
-static inline void set_page_guard_flag(struct page *page)
+static inline void set_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype)
 {
 	__set_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+	INIT_LIST_HEAD(&page->lru);
+	set_page_private(page, order);
+	/* Guard pages are not available for any usage */
+	__mod_zone_freepage_state(zone, -(1 << order), migratetype);
 }
 
-static inline void clear_page_guard_flag(struct page *page)
+static inline void clear_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype)
 {
 	__clear_bit(PAGE_DEBUG_FLAG_GUARD, &page->debug_flags);
+	set_page_private(page, 0);
+	if (!is_migrate_isolate(migratetype))
+		__mod_zone_freepage_state(zone, (1 << order), migratetype);
 }
 #else
-static inline void set_page_guard_flag(struct page *page) { }
-static inline void clear_page_guard_flag(struct page *page) { }
+static inline void set_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype) {}
+static inline void clear_page_guard(struct zone *zone, struct page *page,
+				unsigned int order, int migratetype) {}
 #endif
 
 static inline void set_page_order(struct page *page, unsigned int order)
@@ -581,12 +592,7 @@ static inline void __free_one_page(struc
 		 * merge with it and move up one order.
 		 */
 		if (page_is_guard(buddy)) {
-			clear_page_guard_flag(buddy);
-			set_page_private(buddy, 0);
-			if (!is_migrate_isolate(migratetype)) {
-				__mod_zone_freepage_state(zone, 1 << order,
-							  migratetype);
-			}
+			clear_page_guard(zone, buddy, order, migratetype);
 		} else {
 			list_del(&buddy->lru);
 			zone->free_area[order].nr_free--;
@@ -861,23 +867,17 @@ static inline void expand(struct zone *z
 		size >>= 1;
 		VM_BUG_ON_PAGE(bad_range(zone, &page[size]), &page[size]);
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		if (high < debug_guardpage_minorder()) {
+		if (IS_ENABLED(CONFIG_DEBUG_PAGEALLOC) &&
+			high < debug_guardpage_minorder()) {
 			/*
 			 * Mark as guard pages (or page), that will allow to
 			 * merge back to allocator when buddy will be freed.
 			 * Corresponding page table entries will not be touched,
 			 * pages will stay not present in virtual address space
 			 */
-			INIT_LIST_HEAD(&page[size].lru);
-			set_page_guard_flag(&page[size]);
-			set_page_private(&page[size], high);
-			/* Guard pages are not available for any usage */
-			__mod_zone_freepage_state(zone, -(1 << high),
-						  migratetype);
+			set_page_guard(zone, &page[size], high, migratetype);
 			continue;
 		}
-#endif
 		list_add(&page[size].lru, &area->free_list[migratetype]);
 		area->nr_free++;
 		set_page_order(&page[size], high);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-cma-split-cma-reserved-in-dmesg-log.patch
fs-proc-include-cma-info-in-proc-meminfo.patch

