From: akpm@linux-foundation.org
Subject: - slub-extract-dma_kmalloc_cache-from-get_cache.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:12 -0700
Message-ID: <200707172301.l6HN1CU9011364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45192 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936477AbXGQXPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: extract dma_kmalloc_cache from get_cache.
has been removed from the -mm tree.  Its filename was
     slub-extract-dma_kmalloc_cache-from-get_cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: extract dma_kmalloc_cache from get_cache.
From: Christoph Lameter <clameter@sgi.com>

The rarely used dma functionality in get_slab() makes the function too
complex.  The compiler begins to spill variables from the working set onto the
stack.  The created function is only used in extremely rare cases so make sure
that the compiler does not decide on its own to merge it back into get_slab().

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   66 ++++++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff -puN mm/slub.c~slub-extract-dma_kmalloc_cache-from-get_cache mm/slub.c
--- a/mm/slub.c~slub-extract-dma_kmalloc_cache-from-get_cache
+++ a/mm/slub.c
@@ -2272,6 +2272,40 @@ panic:
 	panic("Creation of kmalloc slab %s size=%d failed.\n", name, size);
 }
 
+#ifdef CONFIG_ZONE_DMA
+static noinline struct kmem_cache *dma_kmalloc_cache(int index, gfp_t flags)
+{
+	struct kmem_cache *s;
+	struct kmem_cache *x;
+	char *text;
+	size_t realsize;
+
+	s = kmalloc_caches_dma[index];
+	if (s)
+		return s;
+
+	/* Dynamically create dma cache */
+	x = kmalloc(kmem_size, flags & ~SLUB_DMA);
+	if (!x)
+		panic("Unable to allocate memory for dma cache\n");
+
+	if (index <= KMALLOC_SHIFT_HIGH)
+		realsize = 1 << index;
+	else {
+		if (index == 1)
+			realsize = 96;
+		else
+			realsize = 192;
+	}
+
+	text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
+			(unsigned int)realsize);
+	s = create_kmalloc_cache(x, text, realsize, flags);
+	kmalloc_caches_dma[index] = s;
+	return s;
+}
+#endif
+
 static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 {
 	int index = kmalloc_index(size);
@@ -2284,36 +2318,8 @@ static struct kmem_cache *get_slab(size_
 		return NULL;
 
 #ifdef CONFIG_ZONE_DMA
-	if ((flags & SLUB_DMA)) {
-		struct kmem_cache *s;
-		struct kmem_cache *x;
-		char *text;
-		size_t realsize;
-
-		s = kmalloc_caches_dma[index];
-		if (s)
-			return s;
-
-		/* Dynamically create dma cache */
-		x = kmalloc(kmem_size, flags & ~SLUB_DMA);
-		if (!x)
-			panic("Unable to allocate memory for dma cache\n");
-
-		if (index <= KMALLOC_SHIFT_HIGH)
-			realsize = 1 << index;
-		else {
-			if (index == 1)
-				realsize = 96;
-			else
-				realsize = 192;
-		}
-
-		text = kasprintf(flags & ~SLUB_DMA, "kmalloc_dma-%d",
-				(unsigned int)realsize);
-		s = create_kmalloc_cache(x, text, realsize, flags);
-		kmalloc_caches_dma[index] = s;
-		return s;
-	}
+	if ((flags & SLUB_DMA))
+		return dma_kmalloc_cache(index, flags);
 #endif
 	return &kmalloc_caches[index];
 }
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
