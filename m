From: akpm@linux-foundation.org
Subject: - slub-faster-more-efficient-slab-determination-for-__kmalloc.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:16 -0700
Message-ID: <200707172301.l6HN1GMT011373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936495AbXGQXPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: faster more efficient slab determination for __kmalloc
has been removed from the -mm tree.  Its filename was
     slub-faster-more-efficient-slab-determination-for-__kmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: faster more efficient slab determination for __kmalloc
From: Christoph Lameter <clameter@sgi.com>

kmalloc_index is a long series of comparisons.  The attempt to replace
kmalloc_index with something more efficient like ilog2 failed due to compiler
issues with constant folding on gcc 3.3 / powerpc.

kmalloc_index()'es long list of comparisons works fine for constant folding
since all the comparisons are optimized away.  However, SLUB also uses
kmalloc_index to determine the slab to use for the __kmalloc_xxx functions. 
This leads to a large set of comparisons in get_slab().

The patch here allows to get rid of that list of comparisons in get_slab():

1. If the requested size is larger than 192 then we can simply use
   fls to determine the slab index since all larger slabs are
   of the power of two type.

2. If the requested size is smaller then we cannot use fls since there
   are non power of two caches to be considered. However, the sizes are
   in a managable range. So we divide the size by 8. Then we have only
   24 possibilities left and then we simply look up the kmalloc index
   in a table.

Code size of slub.o decreases by more than 200 bytes through this patch.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   71 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 7 deletions(-)

diff -puN mm/slub.c~slub-faster-more-efficient-slab-determination-for-__kmalloc mm/slub.c
--- a/mm/slub.c~slub-faster-more-efficient-slab-determination-for-__kmalloc
+++ a/mm/slub.c
@@ -2313,20 +2313,59 @@ static noinline struct kmem_cache *dma_k
 }
 #endif
 
+/*
+ * Conversion table for small slabs sizes / 8 to the index in the
+ * kmalloc array. This is necessary for slabs < 192 since we have non power
+ * of two cache sizes there. The size of larger slabs can be determined using
+ * fls.
+ */
+static s8 size_index[24] = {
+	3,	/* 8 */
+	4,	/* 16 */
+	5,	/* 24 */
+	5,	/* 32 */
+	6,	/* 40 */
+	6,	/* 48 */
+	6,	/* 56 */
+	6,	/* 64 */
+	1,	/* 72 */
+	1,	/* 80 */
+	1,	/* 88 */
+	1,	/* 96 */
+	7,	/* 104 */
+	7,	/* 112 */
+	7,	/* 120 */
+	7,	/* 128 */
+	2,	/* 136 */
+	2,	/* 144 */
+	2,	/* 152 */
+	2,	/* 160 */
+	2,	/* 168 */
+	2,	/* 176 */
+	2,	/* 184 */
+	2	/* 192 */
+};
+
 static struct kmem_cache *get_slab(size_t size, gfp_t flags)
 {
-	int index = kmalloc_index(size);
+	int index;
 
-	if (!index)
-		return ZERO_SIZE_PTR;
+	if (size <= 192) {
+		if (!size)
+			return ZERO_SIZE_PTR;
 
-	/* Allocation too large? */
-	if (index < 0)
-		return NULL;
+		index = size_index[(size - 1) / 8];
+	} else {
+		if (size > KMALLOC_MAX_SIZE)
+			return NULL;
+
+		index = fls(size - 1);
+	}
 
 #ifdef CONFIG_ZONE_DMA
-	if ((flags & SLUB_DMA))
+	if (unlikely((flags & SLUB_DMA)))
 		return dma_kmalloc_cache(index, flags);
+
 #endif
 	return &kmalloc_caches[index];
 }
@@ -2532,6 +2571,24 @@ void __init kmem_cache_init(void)
 		caches++;
 	}
 
+
+	/*
+	 * Patch up the size_index table if we have strange large alignment
+	 * requirements for the kmalloc array. This is only the case for
+	 * mips it seems. The standard arches will not generate any code here.
+	 *
+	 * Largest permitted alignment is 256 bytes due to the way we
+	 * handle the index determination for the smaller caches.
+	 *
+	 * Make sure that nothing crazy happens if someone starts tinkering
+	 * around with ARCH_KMALLOC_MINALIGN
+	 */
+	BUILD_BUG_ON(KMALLOC_MIN_SIZE > 256 ||
+		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));
+
+	for (i = 8; i < KMALLOC_MIN_SIZE;i++)
+		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;
+
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
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
