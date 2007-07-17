From: akpm@linux-foundation.org
Subject: - slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:59 -0700
Message-ID: <200707172300.l6HN0x9Q011338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935374AbXGQXBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: ensure that the number of objects per slab stays low for high orders
has been removed from the -mm tree.  Its filename was
     slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: ensure that the number of objects per slab stays low for high orders
From: Christoph Lameter <clameter@sgi.com>

Currently SLUB has no provision to deal with too high page orders that may
be specified on the kernel boot line.  If an order higher than 6 (on a 4k
platform) is generated then we will BUG() because slabs get more than 65535
objects.

Add some logic that decreases order for slabs that have too many objects. 
This allow booting with slab sizes up to MAX_ORDER.

For example

	slub_min_order=10

will boot with a default slab size of 4M and reduce slab sizes for small
object sizes to lower orders if the number of objects becomes too big. 
Large slab sizes like that allow a concentration of objects of the same
slab cache under as few as possible TLB entries and thus potentially
reduces TLB pressure.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff -puN mm/slub.c~slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders mm/slub.c
--- a/mm/slub.c~slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders
+++ a/mm/slub.c
@@ -205,6 +205,11 @@ static inline void ClearSlabDebug(struct
 #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
 #endif
 
+/*
+ * The page->inuse field is 16 bit thus we have this limitation
+ */
+#define MAX_OBJECTS_PER_SLAB 65535
+
 /* Internal SLUB flags */
 #define __OBJECT_POISON 0x80000000	/* Poison object */
 
@@ -1736,8 +1741,17 @@ static inline int slab_order(int size, i
 {
 	int order;
 	int rem;
+	int min_order = slub_min_order;
 
-	for (order = max(slub_min_order,
+	/*
+	 * If we would create too many object per slab then reduce
+	 * the slab order even if it goes below slub_min_order.
+	 */
+	while (min_order > 0 &&
+		(PAGE_SIZE << min_order) >= MAX_OBJECTS_PER_SLAB * size)
+			min_order--;
+
+	for (order = max(min_order,
 				fls(min_objects * size - 1) - PAGE_SHIFT);
 			order <= max_order; order++) {
 
@@ -1751,6 +1765,9 @@ static inline int slab_order(int size, i
 		if (rem <= slab_size / fract_leftover)
 			break;
 
+		/* If the next size is too high then exit now */
+		if (slab_size * 2 >= MAX_OBJECTS_PER_SLAB * size)
+			break;
 	}
 
 	return order;
@@ -2037,7 +2054,7 @@ static int calculate_sizes(struct kmem_c
 	 * The page->inuse field is only 16 bit wide! So we cannot have
 	 * more than 64k objects per slab.
 	 */
-	if (!s->objects || s->objects > 65535)
+	if (!s->objects || s->objects > MAX_OBJECTS_PER_SLAB)
 		return 0;
 	return 1;
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
quicklist-support-for-x86_64.patch
x86_64-get-mp_bus_to_node-as-early.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
page-owner-tracking-leak-detector.patch
