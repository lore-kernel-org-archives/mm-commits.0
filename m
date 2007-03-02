From: akpm@linux-foundation.org
Subject: + add-a-configure-option-to-group-pages-by-mobility.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:35 -0800
Message-ID: <200703022141.l22LfZcO019767@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42059 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192AbXCBVlq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, jschopp@austin.ibm.com


The patch titled
     Add a configure option to group pages by mobility
has been added to the -mm tree.  Its filename is
     add-a-configure-option-to-group-pages-by-mobility.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 ++++++
 init/Kconfig           |   13 +++++++++++++
 mm/page_alloc.c        |   31 +++++++++++++++++++++++++++++++
 3 files changed, 50 insertions(+)

diff -puN include/linux/mmzone.h~add-a-configure-option-to-group-pages-by-mobility include/linux/mmzone.h
--- a/include/linux/mmzone.h~add-a-configure-option-to-group-pages-by-mobility
+++ a/include/linux/mmzone.h
@@ -25,9 +25,15 @@
 #endif
 #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
 
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
@@ -495,6 +495,19 @@ config SLOB
 	default !SLAB
 	bool
 
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
 menu "Loadable module support"
 
 config MODULES
diff -puN mm/page_alloc.c~add-a-configure-option-to-group-pages-by-mobility mm/page_alloc.c
--- a/mm/page_alloc.c~add-a-configure-option-to-group-pages-by-mobility
+++ a/mm/page_alloc.c
@@ -136,6 +136,7 @@ static unsigned long __initdata dma_rese
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 static inline int get_pageblock_migratetype(struct page *page)
 {
 	return get_pageblock_flags_group(page, PB_migrate, PB_migrate_end);
@@ -152,6 +153,22 @@ static inline int gfpflags_to_migratetyp
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
@@ -640,6 +657,7 @@ static int prep_new_page(struct page *pa
 	return 0;
 }
 
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 /*
  * This array describes the order lists are fallen back to when
  * the free lists for the desirable migrate type are depleted
@@ -696,6 +714,13 @@ static struct page *__rmqueue_fallback(s
 
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
@@ -978,6 +1003,7 @@ again:
 			if (unlikely(!pcp->count))
 				goto failed;
 		}
+#ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 		/* Find a page of the appropriate migrate type */
 		list_for_each_entry(page, &pcp->list, lru) {
 			if (page_private(page) == migratetype) {
@@ -999,6 +1025,11 @@ again:
 			list_del(&page->lru);
 			pcp->count--;
 		}
+#else
+		page = list_entry(pcp->list.next, struct page, lru);
+		list_del(&page->lru);
+		pcp->count--;
+#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
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
