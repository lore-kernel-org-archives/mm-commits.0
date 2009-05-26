From: akpm@linux-foundation.org
Subject: [merged] mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:51 -0700
Message-ID: <200905261935.n4QJZpoT006619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701AbZEZThD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:37:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mm: double check that memmap is actually valid with a memmap that has unexpected holes
has been removed from the -mm tree.  Its filename was
     mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: double check that memmap is actually valid with a memmap that has unexpected holes
From: Mel Gorman <mel@csn.ul.ie>

pfn_valid() is meant to be able to tell if a given PFN has valid memmap
associated with it or not.  In FLATMEM, it is expected that holes always
have valid memmap as long as there is valid PFNs either side of the hole. 
In SPARSEMEM, it is assumed that a valid section has a memmap for the
entire section.

However, ARM and maybe other embedded architectures in the future free
memmap backing holes to save memory on the assumption the memmap is never
used.  The page_zone linkages are then broken even though pfn_valid()
returns true.  A walker of the full memmap must then do this additional
check to ensure the memmap they are looking at is sane by making sure the
zone and PFN linkages are still valid.  This is expensive, but walkers of
the full memmap are extremely rare.

This was caught before for FLATMEM and hacked around but it hits again for
SPARSEMEM because the page_zone linkages can look ok where the PFN
linkages are totally screwed.  This looks like a hatchet job but the
reality is that any clean solution would end up consumning all the memory
saved by punching these unexpected holes in the memmap.  For example, we
tried marking the memmap within the section invalid but the section size
exceeds the size of the hole in most cases so pfn_valid() starts returning
false where valid memmap exists.  Shrinking the size of the section would
increase memory consumption offsetting the gains.

This patch identifies when an architecture is punching unexpected holes in
the memmap that the memory model cannot automatically detect and sets
ARCH_HAS_HOLES_MEMORYMODEL.  At the moment, this is restricted to EP93xx
which is the model sub-architecture this has been reported on but may
expand later.  When set, walkers of the full memmap must call
memmap_valid_within() for each PFN and passing in what it expects the page
and zone to be for that PFN.  If it finds the linkages to be broken, it
assumes the memmap is invalid for that PFN.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig       |    6 +++---
 include/linux/mmzone.h |   26 ++++++++++++++++++++++++++
 mm/mmzone.c            |   15 +++++++++++++++
 mm/vmstat.c            |   19 ++++---------------
 4 files changed, 48 insertions(+), 18 deletions(-)

diff -puN arch/arm/Kconfig~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes arch/arm/Kconfig
--- a/arch/arm/Kconfig~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes
+++ a/arch/arm/Kconfig
@@ -281,6 +281,7 @@ config ARCH_EP93XX
 	select HAVE_CLK
 	select COMMON_CLKDEV
 	select ARCH_REQUIRE_GPIOLIB
+	select ARCH_HAS_HOLES_MEMORYMODEL
 	help
 	  This enables support for the Cirrus EP93xx series of CPUs.
 
@@ -1007,10 +1008,9 @@ config OABI_COMPAT
 	  UNPREDICTABLE (in fact it can be predicted that it won't work
 	  at all). If in doubt say Y.
 
-config ARCH_FLATMEM_HAS_HOLES
+config ARCH_HAS_HOLES_MEMORYMODEL
 	bool
-	default y
-	depends on FLATMEM
+	default n
 
 # Discontigmem is deprecated
 config ARCH_DISCONTIGMEM_ENABLE
diff -puN include/linux/mmzone.h~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes
+++ a/include/linux/mmzone.h
@@ -1108,6 +1108,32 @@ unsigned long __init node_memmap_size_by
 #define pfn_valid_within(pfn) (1)
 #endif
 
+#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
+/*
+ * pfn_valid() is meant to be able to tell if a given PFN has valid memmap
+ * associated with it or not. In FLATMEM, it is expected that holes always
+ * have valid memmap as long as there is valid PFNs either side of the hole.
+ * In SPARSEMEM, it is assumed that a valid section has a memmap for the
+ * entire section.
+ *
+ * However, an ARM, and maybe other embedded architectures in the future
+ * free memmap backing holes to save memory on the assumption the memmap is
+ * never used. The page_zone linkages are then broken even though pfn_valid()
+ * returns true. A walker of the full memmap must then do this additional
+ * check to ensure the memmap they are looking at is sane by making sure
+ * the zone and PFN linkages are still valid. This is expensive, but walkers
+ * of the full memmap are extremely rare.
+ */
+int memmap_valid_within(unsigned long pfn,
+					struct page *page, struct zone *zone);
+#else
+static inline int memmap_valid_within(unsigned long pfn,
+					struct page *page, struct zone *zone)
+{
+	return 1;
+}
+#endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
+
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
diff -puN mm/mmzone.c~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes mm/mmzone.c
--- a/mm/mmzone.c~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes
+++ a/mm/mmzone.c
@@ -6,6 +6,7 @@
 
 
 #include <linux/stddef.h>
+#include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/module.h>
 
@@ -72,3 +73,17 @@ struct zoneref *next_zones_zonelist(stru
 	*zone = zonelist_zone(z);
 	return z;
 }
+
+#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
+int memmap_valid_within(unsigned long pfn,
+					struct page *page, struct zone *zone)
+{
+	if (page_to_pfn(page) != pfn)
+		return 0;
+
+	if (page_zone(page) != zone)
+		return 0;
+
+	return 1;
+}
+#endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
diff -puN mm/vmstat.c~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes mm/vmstat.c
--- a/mm/vmstat.c~mm-double-check-that-memmap-is-actually-valid-with-a-memmap-that-has-unexpected-holes
+++ a/mm/vmstat.c
@@ -509,22 +509,11 @@ static void pagetypeinfo_showblockcount_
 			continue;
 
 		page = pfn_to_page(pfn);
-#ifdef CONFIG_ARCH_FLATMEM_HAS_HOLES
-		/*
-		 * Ordinarily, memory holes in flatmem still have a valid
-		 * memmap for the PFN range. However, an architecture for
-		 * embedded systems (e.g. ARM) can free up the memmap backing
-		 * holes to save memory on the assumption the memmap is
-		 * never used. The page_zone linkages are then broken even
-		 * though pfn_valid() returns true. Skip the page if the
-		 * linkages are broken. Even if this test passed, the impact
-		 * is that the counters for the movable type are off but
-		 * fragmentation monitoring is likely meaningless on small
-		 * systems.
-		 */
-		if (page_zone(page) != zone)
+
+		/* Watch for unexpected holes punched in the memmap */
+		if (!memmap_valid_within(pfn, page, zone))
 			continue;
-#endif
+
 		mtype = get_pageblock_migratetype(page);
 
 		if (mtype < MIGRATE_TYPES)
_

Patches currently in -mm which might be from mel@csn.ul.ie are

linux-next.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
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
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark-replace-the-watermark-related-union-in-struct-zone-with-a-watermark-array.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
add-debugging-aid-for-memory-initialisation-problems.patch

