From: akpm@linux-foundation.org
Subject: - slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:01:06 -0700
Message-ID: <200707172301.l6HN16Fv011353@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60302 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936654AbXGQXQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     Slab allocators: consistent ZERO_SIZE_PTR support and NULL result semantics
has been removed from the -mm tree.  Its filename was
     slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Slab allocators: consistent ZERO_SIZE_PTR support and NULL result semantics
From: Christoph Lameter <clameter@sgi.com>

Define ZERO_OR_NULL_PTR macro to be able to remove the checks from the
allocators.  Move ZERO_SIZE_PTR related stuff into slab.h.

Make ZERO_SIZE_PTR work for all slab allocators and get rid of the
WARN_ON_ONCE(size == 0) that is still remaining in SLAB.

Make slub return NULL like the other allocators if a too large memory segment
is requested via __kmalloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h     |   13 +++++++++++++
 include/linux/slab_def.h |   12 ++++++++++++
 include/linux/slub_def.h |   12 ------------
 mm/slab.c                |   13 ++++++++-----
 mm/slob.c                |   11 +++++++----
 mm/slub.c                |   29 ++++++++++++++++-------------
 mm/util.c                |    2 +-
 7 files changed, 57 insertions(+), 35 deletions(-)

diff -puN include/linux/slab.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/include/linux/slab.h
@@ -31,6 +31,19 @@
 #define SLAB_TRACE		0x00200000UL	/* Trace allocations and frees */
 
 /*
+ * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
+ *
+ * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
+ *
+ * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
+ * Both make kfree a no-op.
+ */
+#define ZERO_SIZE_PTR ((void *)16)
+
+#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) < \
+				(unsigned long)ZERO_SIZE_PTR)
+
+/*
  * struct kmem_cache related prototypes
  */
 void __init kmem_cache_init(void);
diff -puN include/linux/slab_def.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics include/linux/slab_def.h
--- a/include/linux/slab_def.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/include/linux/slab_def.h
@@ -32,6 +32,10 @@ static inline void *kmalloc(size_t size,
 {
 	if (__builtin_constant_p(size)) {
 		int i = 0;
+
+		if (!size)
+			return ZERO_SIZE_PTR;
+
 #define CACHE(x) \
 		if (size <= x) \
 			goto found; \
@@ -58,6 +62,10 @@ static inline void *kzalloc(size_t size,
 {
 	if (__builtin_constant_p(size)) {
 		int i = 0;
+
+		if (!size)
+			return ZERO_SIZE_PTR;
+
 #define CACHE(x) \
 		if (size <= x) \
 			goto found; \
@@ -88,6 +96,10 @@ static inline void *kmalloc_node(size_t 
 {
 	if (__builtin_constant_p(size)) {
 		int i = 0;
+
+		if (!size)
+			return ZERO_SIZE_PTR;
+
 #define CACHE(x) \
 		if (size <= x) \
 			goto found; \
diff -puN include/linux/slub_def.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics include/linux/slub_def.h
--- a/include/linux/slub_def.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/include/linux/slub_def.h
@@ -159,18 +159,6 @@ static inline struct kmem_cache *kmalloc
 #define SLUB_DMA 0
 #endif
 
-
-/*
- * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
- *
- * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
- *
- * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
- * Both make kfree a no-op.
- */
-#define ZERO_SIZE_PTR ((void *)16)
-
-
 void *kmem_cache_alloc(struct kmem_cache *, gfp_t);
 void *__kmalloc(size_t size, gfp_t flags);
 
diff -puN mm/slab.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics mm/slab.c
--- a/mm/slab.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/mm/slab.c
@@ -775,6 +775,9 @@ static inline struct kmem_cache *__find_
 	 */
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
+	if (!size)
+		return ZERO_SIZE_PTR;
+
 	while (size > csizep->cs_size)
 		csizep++;
 
@@ -2351,7 +2354,7 @@ kmem_cache_create (const char *name, siz
 		 * this should not happen at all.
 		 * But leave a BUG_ON for some lucky dude.
 		 */
-		BUG_ON(!cachep->slabp_cache);
+		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
 	}
 	cachep->ctor = ctor;
 	cachep->name = name;
@@ -3653,8 +3656,8 @@ __do_kmalloc_node(size_t size, gfp_t fla
 	struct kmem_cache *cachep;
 
 	cachep = kmem_find_general_cachep(size, flags);
-	if (unlikely(cachep == NULL))
-		return NULL;
+	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
+		return cachep;
 	return kmem_cache_alloc_node(cachep, flags, node);
 }
 
@@ -3760,7 +3763,7 @@ void kfree(const void *objp)
 	struct kmem_cache *c;
 	unsigned long flags;
 
-	if (unlikely(!objp))
+	if (unlikely(ZERO_OR_NULL_PTR(objp)))
 		return;
 	local_irq_save(flags);
 	kfree_debugcheck(objp);
@@ -4447,7 +4450,7 @@ const struct seq_operations slabstats_op
  */
 size_t ksize(const void *objp)
 {
-	if (unlikely(objp == NULL))
+	if (unlikely(ZERO_OR_NULL_PTR(objp)))
 		return 0;
 
 	return obj_size(virt_to_cache(objp));
diff -puN mm/slob.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics mm/slob.c
--- a/mm/slob.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/mm/slob.c
@@ -347,7 +347,7 @@ static void slob_free(void *block, int s
 	slobidx_t units;
 	unsigned long flags;
 
-	if (!block)
+	if (ZERO_OR_NULL_PTR(block))
 		return;
 	BUG_ON(!size);
 
@@ -424,10 +424,13 @@ out:
 
 void *__kmalloc_node(size_t size, gfp_t gfp, int node)
 {
+	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 
 	if (size < PAGE_SIZE - align) {
-		unsigned int *m;
+		if (!size)
+			return ZERO_SIZE_PTR;
+
 		m = slob_alloc(size + align, gfp, align, node);
 		if (m)
 			*m = size;
@@ -450,7 +453,7 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
-	if (!block)
+	if (ZERO_OR_NULL_PTR(block))
 		return;
 
 	sp = (struct slob_page *)virt_to_page(block);
@@ -468,7 +471,7 @@ size_t ksize(const void *block)
 {
 	struct slob_page *sp;
 
-	if (!block)
+	if (ZERO_OR_NULL_PTR(block))
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff -puN mm/slub.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics mm/slub.c
--- a/mm/slub.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/mm/slub.c
@@ -2270,10 +2270,11 @@ static struct kmem_cache *get_slab(size_
 	int index = kmalloc_index(size);
 
 	if (!index)
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	/* Allocation too large? */
-	BUG_ON(index < 0);
+	if (index < 0)
+		return NULL;
 
 #ifdef CONFIG_ZONE_DMA
 	if ((flags & SLUB_DMA)) {
@@ -2314,9 +2315,10 @@ void *__kmalloc(size_t size, gfp_t flags
 {
 	struct kmem_cache *s = get_slab(size, flags);
 
-	if (s)
-		return slab_alloc(s, flags, -1, __builtin_return_address(0));
-	return ZERO_SIZE_PTR;
+	if (ZERO_OR_NULL_PTR(s))
+		return s;
+
+	return slab_alloc(s, flags, -1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2325,9 +2327,10 @@ void *__kmalloc_node(size_t size, gfp_t 
 {
 	struct kmem_cache *s = get_slab(size, flags);
 
-	if (s)
-		return slab_alloc(s, flags, node, __builtin_return_address(0));
-	return ZERO_SIZE_PTR;
+	if (ZERO_OR_NULL_PTR(s))
+		return s;
+
+	return slab_alloc(s, flags, node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2378,7 +2381,7 @@ void kfree(const void *x)
 	 * this comparison would be true for all "negative" pointers
 	 * (which would cover the whole upper half of the address space).
 	 */
-	if ((unsigned long)x <= (unsigned long)ZERO_SIZE_PTR)
+	if (ZERO_OR_NULL_PTR(x))
 		return;
 
 	page = virt_to_head_page(x);
@@ -2687,8 +2690,8 @@ void *__kmalloc_track_caller(size_t size
 {
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
-	if (!s)
-		return ZERO_SIZE_PTR;
+	if (ZERO_OR_NULL_PTR(s))
+		return s;
 
 	return slab_alloc(s, gfpflags, -1, caller);
 }
@@ -2698,8 +2701,8 @@ void *__kmalloc_node_track_caller(size_t
 {
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
-	if (!s)
-		return ZERO_SIZE_PTR;
+	if (ZERO_OR_NULL_PTR(s))
+		return s;
 
 	return slab_alloc(s, gfpflags, node, caller);
 }
diff -puN mm/util.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics mm/util.c
--- a/mm/util.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/mm/util.c
@@ -76,7 +76,7 @@ void *krealloc(const void *p, size_t new
 
 	if (unlikely(!new_size)) {
 		kfree(p);
-		return NULL;
+		return ZERO_SIZE_PTR;
 	}
 
 	ks = ksize(p);
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
