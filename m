From: akpm@linux-foundation.org
Subject: + slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch added to -mm tree
Date: Tue, 19 Jun 2007 12:19:08 -0700
Message-ID: <200706191919.l5JJJ8H5019045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39070 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933508AbXFSTTU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 15:19:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     Slab allocators: consistent ZERO_SIZE_PTR support and NULL result semantics
has been added to the -mm tree.  Its filename is
     slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 include/linux/slub_def.h |   11 -----------
 mm/slab.c                |   14 ++++++++------
 mm/slob.c                |   11 +++++++----
 mm/slub.c                |   29 ++++++++++++++++-------------
 mm/util.c                |    2 +-
 7 files changed, 57 insertions(+), 35 deletions(-)

diff -puN include/linux/slab.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics include/linux/slab.h
--- a/include/linux/slab.h~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/include/linux/slab.h
@@ -33,6 +33,19 @@
 #define SLAB_RECLAIM_ACCOUNT	0x00020000UL		/* Objects are reclaimable */
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
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
@@ -29,6 +29,10 @@ static inline void *kmalloc(size_t size,
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
@@ -55,6 +59,10 @@ static inline void *kzalloc(size_t size,
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
@@ -84,6 +92,10 @@ static inline void *kmalloc_node(size_t 
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
@@ -160,17 +160,6 @@ static inline struct kmem_cache *kmalloc
 #endif
 
 
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
 static inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
diff -puN mm/slab.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics mm/slab.c
--- a/mm/slab.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/mm/slab.c
@@ -774,7 +774,9 @@ static inline struct kmem_cache *__find_
 	 */
 	BUG_ON(malloc_sizes[INDEX_AC].cs_cachep == NULL);
 #endif
-	WARN_ON_ONCE(size == 0);
+	if (!size)
+		return ZERO_SIZE_PTR;
+
 	while (size > csizep->cs_size)
 		csizep++;
 
@@ -2340,7 +2342,7 @@ kmem_cache_create (const char *name, siz
 		 * this should not happen at all.
 		 * But leave a BUG_ON for some lucky dude.
 		 */
-		BUG_ON(!cachep->slabp_cache);
+		BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));
 	}
 	cachep->ctor = ctor;
 	cachep->name = name;
@@ -3642,8 +3644,8 @@ __do_kmalloc_node(size_t size, gfp_t fla
 	struct kmem_cache *cachep;
 
 	cachep = kmem_find_general_cachep(size, flags);
-	if (unlikely(cachep == NULL))
-		return NULL;
+	if (unlikely(ZERO_OR_NULL_PTR(cachep)))
+		return cachep;
 	return kmem_cache_alloc_node(cachep, flags, node);
 }
 
@@ -3749,7 +3751,7 @@ void kfree(const void *objp)
 	struct kmem_cache *c;
 	unsigned long flags;
 
-	if (unlikely(!objp))
+	if (unlikely(ZERO_OR_NULL_PTR(objp)))
 		return;
 	local_irq_save(flags);
 	kfree_debugcheck(objp);
@@ -4436,7 +4438,7 @@ const struct seq_operations slabstats_op
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
@@ -306,7 +306,7 @@ static void slob_free(void *block, int s
 	slobidx_t units;
 	unsigned long flags;
 
-	if (!block)
+	if (ZERO_OR_NULL_PTR(block))
 		return;
 	BUG_ON(!size);
 
@@ -384,10 +384,13 @@ out:
 
 void *__kmalloc(size_t size, gfp_t gfp)
 {
+	unsigned int *m;
 	int align = max(ARCH_KMALLOC_MINALIGN, ARCH_SLAB_MINALIGN);
 
 	if (size < PAGE_SIZE - align) {
-		unsigned int *m;
+		if (!size)
+			return ZERO_SIZE_PTR;
+
 		m = slob_alloc(size + align, gfp, align);
 		if (m)
 			*m = size;
@@ -411,7 +414,7 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
-	if (!block)
+	if (ZERO_OR_NULL_PTR(block))
 		return;
 
 	sp = (struct slob_page *)virt_to_page(block);
@@ -430,7 +433,7 @@ size_t ksize(const void *block)
 {
 	struct slob_page *sp;
 
-	if (!block)
+	if (ZERO_OR_NULL_PTR(block))
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff -puN mm/slub.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics mm/slub.c
--- a/mm/slub.c~slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics
+++ a/mm/slub.c
@@ -2280,10 +2280,11 @@ static struct kmem_cache *get_slab(size_
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
@@ -2324,9 +2325,10 @@ void *__kmalloc(size_t size, gfp_t flags
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
 
@@ -2335,9 +2337,10 @@ void *__kmalloc_node(size_t size, gfp_t 
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
@@ -2388,7 +2391,7 @@ void kfree(const void *x)
 	 * this comparison would be true for all "negative" pointers
 	 * (which would cover the whole upper half of the address space).
 	 */
-	if ((unsigned long)x <= (unsigned long)ZERO_SIZE_PTR)
+	if (ZERO_OR_NULL_PTR(x))
 		return;
 
 	page = virt_to_head_page(x);
@@ -2707,8 +2710,8 @@ void *__kmalloc_track_caller(size_t size
 {
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
-	if (!s)
-		return ZERO_SIZE_PTR;
+	if (ZERO_OR_NULL_PTR(s))
+		return s;
 
 	return slab_alloc(s, gfpflags, -1, caller);
 }
@@ -2718,8 +2721,8 @@ void *__kmalloc_node_track_caller(size_t
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
@@ -99,7 +99,7 @@ void *krealloc(const void *p, size_t new
 
 	if (unlikely(!new_size)) {
 		kfree(p);
-		return NULL;
+		return ZERO_SIZE_PTR;
 	}
 
 	ks = ksize(p);
_

Patches currently in -mm which might be from clameter@sgi.com are

git-ubi.patch
quicklist-support-for-x86_64.patch
change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
make-proc-slabinfo-use-seq_list_xxx-helpers.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
slub-support-slub_debug-on-by-default.patch
slub-support-slub_debug-on-by-default-tidy.patch
numa-mempolicy-dynamic-interleave-map-for-system-init.patch
gfph-gfp_thisnode-can-go-to-other-nodes-if-some-are-unpopulated.patch
numa-mempolicy-trivial-debug-fixes.patch
add-populated_map-to-account-for-memoryless-nodes.patch
add-populated_map-to-account-for-memoryless-nodes-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-reduce-antifrag-max-order.patch
slub-reduce-antifrag-max-order-use-antifrag-constant-instead-of-hardcoding-page-order.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely-fix.patch
slub-remove-useless-export_symbol.patch
slub-use-list_for_each_entry-for-loops-over-all-slabs.patch
slub-slab-validation-move-tracking-information-alloc-outside-of.patch
slub-ensure-that-the-object-per-slabs-stays-low-for-high-orders.patch
slub-debug-fix-initial-object-debug-state-of-numa-bootstrap-objects.patch
slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch
slab-allocators-consistent-zero_size_ptr-support-and-null-result-semantics.patch
slab-allocators-support-__gfp_zero-in-all-allocators.patch
slab-allocators-cleanup-zeroing-allocations.patch
slab-allocators-replace-explicit-zeroing-with-__gfp_zero.patch
slub-add-some-more-inlines-and-ifdef-config_slub_debug.patch
slub-extract-dma_kmalloc_cache-from-get_cache.patch
slub-do-proper-locking-during-dma-slab-creation.patch
slub-faster-more-efficient-slab-determination-for-__kmalloc.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
