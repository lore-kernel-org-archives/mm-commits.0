From: akpm@linux-foundation.org
Subject: - add-a-configure-option-to-group-pages-by-mobility.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:34 -0700
Message-ID: <200710162034.l9GKYY4M014951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55243 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934491AbXJPVhH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:37:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, jschopp@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add a configure option to group pages by mobility
has been removed from the -mm tree.  Its filename was
     add-a-configure-option-to-group-pages-by-mobility.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add a configure option to group pages by mobility
From: Mel Gorman <mel@csn.ul.ie>

The grouping mechanism has some memory overhead and a more complex allocation
path.  This patch allows the strategy to be disabled for small memory systems
or if it is known the workload is suffering because of the strategy.  It also
acts to show where the page groupings strategy interacts with the standard
buddy allocator.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Joel Schopp <jschopp@austin.ibm.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++++
 init/Kconfig           |   13 +++++++++
 mm/page_alloc.c        |   51 ++++++++++++++++++++++++++++-----------
 3 files changed, 56 insertions(+), 14 deletions(-)

diff -puN include/linux/mmzone.h~add-a-configure-option-to-group-pages-by-mobility include/linux/mmzone.h
--- a/include/linux/mmzone.h~add-a-configure-option-to-group-pages-by-mobility
+++ a/include/linux/mmzone.h
@@ -33,9 +33,15 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_MOVABLE       1
 #define MIGRATE_TYPES         2
+#else
+#define MIGRATE_UNMOVABLE     0
+#define MIGRATE_MOVABLE       0
+#define MIGRATE_TYPES         1
+#endif
 
 #define for_each_migratetype_order(order, type) \
 	for (order = 0; order < MAX_ORDER; order++) \
diff -puN init/Kconfig~add-a-configure-option-to-group-pages-by-mobility init/Kconfig
--- a/init/Kconfig~add-a-configure-option-to-group-pages-by-mobility
+++ a/init/Kconfig
@@ -607,6 +607,19 @@ config BASE_SMALL
 	default 0 if BASE_FULL
 	default 1 if !BASE_FULL
 
+config PAGE_GROUP_BY_MOBILITY
+	bool "Group pages based on their mobility in the page allocator"
+	def_bool y
+	help
+	  The standard allocator will fragment memory over time which means
+	  that high order allocations will fail even if kswapd is running. If
+	  this option is set, the allocator will try and group page types
+	  based on their ability to migrate or reclaim. This is a best effort
+	  attempt at lowering fragmentation which a few workloads care about.
+	  The loss is a more complex allocator that may perform slower. If
+	  you are interested in working with large pages, say Y and set
+	  /proc/sys/vm/min_free_bytes to 16374. Otherwise say N
+
 menuconfig MODULES
 	bool "Enable loadable module support"
 	help
diff -puN mm/page_alloc.c~add-a-configure-option-to-group-pages-by-mobility mm/page_alloc.c
--- a/mm/page_alloc.c~add-a-configure-option-to-group-pages-by-mobility
+++ a/mm/page_alloc.c
@@ -158,6 +158,7 @@ int nr_node_ids __read_mostly = MAX_NUMN
 EXPORT_SYMBOL(nr_node_ids);
 #endif
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 static inline int get_pageblock_migratetype(struct page *page)
 {
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
@@ -174,6 +175,22 @@ static inline int gfpflags_to_migratetyp
 	return ((gfp_flags & __GFP_MOVABLE) != 0);
 }
 
+#else
+static inline int get_pageblock_migratetype(struct page *page)
+{
+	return MIGRATE_UNMOVABLE;
+}
+
+static void set_pageblock_migratetype(struct page *page, int migratetype)
+{
+}
+
+static inline int gfpflags_to_migratetype(gfp_t gfp_flags)
+{
+	return MIGRATE_UNMOVABLE;
+}
+#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
+
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -653,6 +670,7 @@ static int prep_new_page(struct page *pa
 	return 0;
 }
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
@@ -709,6 +727,13 @@ static struct page *__rmqueue_fallback(s
 
 	return NULL;
 }
+#else
+static struct page *__rmqueue_fallback(struct zone *zone, int order,
+						int start_migratetype)
+{
+	return NULL;
+}
+#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 
 /* 
  * Do the hard work of removing an element from the buddy allocator.
@@ -953,27 +978,25 @@ again:
 			if (unlikely(!pcp->count))
 				goto failed;
 		}
+
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 		/* Find a page of the appropriate migrate type */
-		list_for_each_entry(page, &pcp->list, lru) {
-			if (page_private(page) == migratetype) {
-				list_del(&page->lru);
-				pcp->count--;
+		list_for_each_entry(page, &pcp->list, lru)
+			if (page_private(page) == migratetype)
 				break;
-			}
-		}
 
-		/*
-		 * Check if a page of the appropriate migrate type
-		 * was found. If not, allocate more to the pcp list
-		 */
-		if (&page->lru == &pcp->list) {
+		/* Allocate more to the pcp list if necessary */
+		if (unlikely(&page->lru == &pcp->list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list, migratetype);
 			page = list_entry(pcp->list.next, struct page, lru);
-			VM_BUG_ON(page_private(page) != migratetype);
-			list_del(&page->lru);
-			pcp->count--;
 		}
+#else
+		page = list_entry(pcp->list.next, struct page, lru);
+#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
+
+		list_del(&page->lru);
+		pcp->count--;
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
