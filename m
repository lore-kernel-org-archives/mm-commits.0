From: akpm@linux-foundation.org
Subject: - slub-do-not-use-length-parameter-in-slab_alloc.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:24 -0700
Message-ID: <200707172301.l6HN1Oav011388@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35412 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936448AbXGQXPs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:15:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Do not use length parameter in slab_alloc()
has been removed from the -mm tree.  Its filename was
     slub-do-not-use-length-parameter-in-slab_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: Do not use length parameter in slab_alloc()
From: Christoph Lameter <clameter@sgi.com>

We can get to the length of the object through the kmem_cache_structure.  The
additional parameter does no good and causes the compiler to generate bad
code.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-do-not-use-length-parameter-in-slab_alloc mm/slub.c
--- a/mm/slub.c~slub-do-not-use-length-parameter-in-slab_alloc
+++ a/mm/slub.c
@@ -1541,7 +1541,7 @@ debug:
  * Otherwise we can simply pick the next object from the lockless free list.
  */
 static void __always_inline *slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr, int length)
+		gfp_t gfpflags, int node, void *addr)
 {
 	struct page *page;
 	void **object;
@@ -1561,23 +1561,21 @@ static void __always_inline *slab_alloc(
 	local_irq_restore(flags);
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
-		memset(object, 0, length);
+		memset(object, 0, s->objsize);
 
 	return object;
 }
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1,
-			__builtin_return_address(0), s->objsize);
+	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node,
-		__builtin_return_address(0), s->objsize);
+	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -2369,7 +2367,7 @@ void *__kmalloc(size_t size, gfp_t flags
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0), size);
+	return slab_alloc(s, flags, -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2381,7 +2379,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0), size);
+	return slab_alloc(s, flags, node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2712,7 +2710,7 @@ void *kmem_cache_zalloc(struct kmem_cach
 {
 	void *x;
 
-	x = slab_alloc(s, flags, -1, __builtin_return_address(0), 0);
+	x = slab_alloc(s, flags, -1, __builtin_return_address(0));
 	if (x)
 		memset(x, 0, s->objsize);
 	return x;
@@ -2762,7 +2760,7 @@ void *__kmalloc_track_caller(size_t size
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, gfpflags, -1, caller, size);
+	return slab_alloc(s, gfpflags, -1, caller);
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
@@ -2773,7 +2771,7 @@ void *__kmalloc_node_track_caller(size_t
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, gfpflags, node, caller, size);
+	return slab_alloc(s, gfpflags, node, caller);
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
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
