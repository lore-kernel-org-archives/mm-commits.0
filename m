From: akpm@linux-foundation.org
Subject: - slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:03 -0700
Message-ID: <200707172301.l6HN13uo011350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936255AbXGQXBc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Slab allocators: consolidate code for krealloc in mm/util.c
has been removed from the -mm tree.  Its filename was
     slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Slab allocators: consolidate code for krealloc in mm/util.c
From: Christoph Lameter <clameter@sgi.com>

The size of a kmalloc object is readily available via ksize().  ksize is
provided by all allocators and thus we canb implement krealloc in a generic
way.

Implement krealloc in mm/util.c and drop slab specific implementations of
krealloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   46 ----------------------------------------------
 mm/slob.c |   33 ---------------------------------
 mm/slub.c |   37 -------------------------------------
 mm/util.c |   34 ++++++++++++++++++++++++++++++++++
 4 files changed, 34 insertions(+), 116 deletions(-)

diff -puN mm/slab.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc mm/slab.c
--- a/mm/slab.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc
+++ a/mm/slab.c
@@ -3726,52 +3726,6 @@ EXPORT_SYMBOL(__kmalloc);
 #endif
 
 /**
- * krealloc - reallocate memory. The contents will remain unchanged.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
- */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	struct kmem_cache *cache, *new_cache;
-	void *ret;
-
-	if (unlikely(!p))
-		return kmalloc_track_caller(new_size, flags);
-
-	if (unlikely(!new_size)) {
-		kfree(p);
-		return NULL;
-	}
-
-	cache = virt_to_cache(p);
-	new_cache = __find_general_cachep(new_size, flags);
-
-	/*
- 	 * If new size fits in the current cache, bail out.
- 	 */
-	if (likely(cache == new_cache))
-		return (void *)p;
-
-	/*
- 	 * We are on the slow-path here so do not use __cache_alloc
- 	 * because it bloats kernel text.
- 	 */
-	ret = kmalloc_track_caller(new_size, flags);
-	if (ret) {
-		memcpy(ret, p, min(new_size, ksize(p)));
-		kfree(p);
-	}
-	return ret;
-}
-EXPORT_SYMBOL(krealloc);
-
-/**
  * kmem_cache_free - Deallocate an object
  * @cachep: The cache the allocation was from.
  * @objp: The previously allocated object.
diff -puN mm/slob.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc mm/slob.c
--- a/mm/slob.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc
+++ a/mm/slob.c
@@ -446,39 +446,6 @@ void *__kmalloc_node(size_t size, gfp_t 
 }
 EXPORT_SYMBOL(__kmalloc_node);
 
-/**
- * krealloc - reallocate memory. The contents will remain unchanged.
- *
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
- */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	void *ret;
-
-	if (unlikely(!p))
-		return kmalloc_track_caller(new_size, flags);
-
-	if (unlikely(!new_size)) {
-		kfree(p);
-		return NULL;
-	}
-
-	ret = kmalloc_track_caller(new_size, flags);
-	if (ret) {
-		memcpy(ret, p, min(new_size, ksize(p)));
-		kfree(p);
-	}
-	return ret;
-}
-EXPORT_SYMBOL(krealloc);
-
 void kfree(const void *block)
 {
 	struct slob_page *sp;
diff -puN mm/slub.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc mm/slub.c
--- a/mm/slub.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc
+++ a/mm/slub.c
@@ -2467,43 +2467,6 @@ int kmem_cache_shrink(struct kmem_cache 
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-/**
- * krealloc - reallocate memory. The contents will remain unchanged.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @flags: the type of memory to allocate.
- *
- * The contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.  If @p is %NULL, krealloc()
- * behaves exactly like kmalloc().  If @size is 0 and @p is not a
- * %NULL pointer, the object pointed to is freed.
- */
-void *krealloc(const void *p, size_t new_size, gfp_t flags)
-{
-	void *ret;
-	size_t ks;
-
-	if (unlikely(!p || p == ZERO_SIZE_PTR))
-		return kmalloc(new_size, flags);
-
-	if (unlikely(!new_size)) {
-		kfree(p);
-		return ZERO_SIZE_PTR;
-	}
-
-	ks = ksize(p);
-	if (ks >= new_size)
-		return (void *)p;
-
-	ret = kmalloc(new_size, flags);
-	if (ret) {
-		memcpy(ret, p, min(new_size, ks));
-		kfree(p);
-	}
-	return ret;
-}
-EXPORT_SYMBOL(krealloc);
-
 /********************************************************************
  *			Basic setup of slabs
  *******************************************************************/
diff -puN mm/util.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc mm/util.c
--- a/mm/util.c~slab-allocators-consolidate-code-for-krealloc-in-mm-utilc
+++ a/mm/util.c
@@ -58,6 +58,40 @@ void *kmemdup(const void *src, size_t le
 }
 EXPORT_SYMBOL(kmemdup);
 
+/**
+ * krealloc - reallocate memory. The contents will remain unchanged.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate.
+ *
+ * The contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.  If @p is %NULL, krealloc()
+ * behaves exactly like kmalloc().  If @size is 0 and @p is not a
+ * %NULL pointer, the object pointed to is freed.
+ */
+void *krealloc(const void *p, size_t new_size, gfp_t flags)
+{
+	void *ret;
+	size_t ks;
+
+	if (unlikely(!new_size)) {
+		kfree(p);
+		return NULL;
+	}
+
+	ks = ksize(p);
+	if (ks >= new_size)
+		return (void *)p;
+
+	ret = kmalloc_track_caller(new_size, flags);
+	if (ret) {
+		memcpy(ret, p, min(new_size, ks));
+		kfree(p);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(krealloc);
+
 /*
  * strndup_user - duplicate an existing string from user space
  *
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
