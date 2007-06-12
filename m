From: akpm@linux-foundation.org
Subject: - slub-return-zero_size_ptr-for-kmalloc0.patch removed from -mm tree
Date: Tue, 12 Jun 2007 11:56:49 -0700
Message-ID: <200706121856.l5CIunaw018421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47549 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755806AbXFLS5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jun 2007 14:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     SLUB: return ZERO_SIZE_PTR for kmalloc(0)
has been removed from the -mm tree.  Its filename was
     slub-return-zero_size_ptr-for-kmalloc0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SLUB: return ZERO_SIZE_PTR for kmalloc(0)
From: Christoph Lameter <clameter@sgi.com>

Instead of returning the smallest available object return ZERO_SIZE_PTR.

A ZERO_SIZE_PTR can be legitimately used as an object pointer as long as it
is not deferenced.  The dereference of ZERO_SIZE_PTR causes a distinctive
fault.  kfree can handle a ZERO_SIZE_PTR in the same way as NULL.

This enables functions to use zero sized object. e.g. n = number of objects.

	objects = kmalloc(n * sizeof(object));

	for (i = 0; i < n; i++)
		objects[i].x = y;

	kfree(objects);

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |   25 +++++++++++++++++--------
 mm/slub.c                |   26 ++++++++++++++++++--------
 2 files changed, 35 insertions(+), 16 deletions(-)

diff -puN include/linux/slub_def.h~slub-return-zero_size_ptr-for-kmalloc0 include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-return-zero_size_ptr-for-kmalloc0
+++ a/include/linux/slub_def.h
@@ -70,11 +70,8 @@ extern struct kmem_cache kmalloc_caches[
  */
 static inline int kmalloc_index(size_t size)
 {
-	/*
-	 * We should return 0 if size == 0 but we use the smallest object
-	 * here for SLAB legacy reasons.
-	 */
-	WARN_ON_ONCE(size == 0);
+	if (!size)
+		return 0;
 
 	if (size > KMALLOC_MAX_SIZE)
 		return -1;
@@ -153,13 +150,25 @@ static inline struct kmem_cache *kmalloc
 #define SLUB_DMA 0
 #endif
 
+
+/*
+ * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.
+ *
+ * Dereferencing ZERO_SIZE_PTR will lead to a distinct access fault.
+ *
+ * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
+ * Both make kfree a no-op.
+ */
+#define ZERO_SIZE_PTR ((void *)16)
+
+
 static inline void *kmalloc(size_t size, gfp_t flags)
 {
 	if (__builtin_constant_p(size) && !(flags & SLUB_DMA)) {
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return ZERO_SIZE_PTR;
 
 		return kmem_cache_alloc(s, flags);
 	} else
@@ -172,7 +181,7 @@ static inline void *kzalloc(size_t size,
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return ZERO_SIZE_PTR;
 
 		return kmem_cache_zalloc(s, flags);
 	} else
@@ -188,7 +197,7 @@ static inline void *kmalloc_node(size_t 
 		struct kmem_cache *s = kmalloc_slab(size);
 
 		if (!s)
-			return NULL;
+			return ZERO_SIZE_PTR;
 
 		return kmem_cache_alloc_node(s, flags, node);
 	} else
diff -puN mm/slub.c~slub-return-zero_size_ptr-for-kmalloc0 mm/slub.c
--- a/mm/slub.c~slub-return-zero_size_ptr-for-kmalloc0
+++ a/mm/slub.c
@@ -2241,7 +2241,7 @@ void *__kmalloc(size_t size, gfp_t flags
 
 	if (s)
 		return slab_alloc(s, flags, -1, __builtin_return_address(0));
-	return NULL;
+	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2252,16 +2252,20 @@ void *__kmalloc_node(size_t size, gfp_t 
 
 	if (s)
 		return slab_alloc(s, flags, node, __builtin_return_address(0));
-	return NULL;
+	return ZERO_SIZE_PTR;
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
 
 size_t ksize(const void *object)
 {
-	struct page *page = get_object_page(object);
+	struct page *page;
 	struct kmem_cache *s;
 
+	if (object == ZERO_SIZE_PTR)
+		return 0;
+
+	page = get_object_page(object);
 	BUG_ON(!page);
 	s = page->slab;
 	BUG_ON(!s);
@@ -2293,7 +2297,13 @@ void kfree(const void *x)
 	struct kmem_cache *s;
 	struct page *page;
 
-	if (!x)
+	/*
+	 * This has to be an unsigned comparison. According to Linus
+	 * some gcc version treat a pointer as a signed entity. Then
+	 * this comparison would be true for all "negative" pointers
+	 * (which would cover the whole upper half of the address space).
+	 */
+	if ((unsigned long)x <= (unsigned long)ZERO_SIZE_PTR)
 		return;
 
 	page = virt_to_head_page(x);
@@ -2398,12 +2408,12 @@ void *krealloc(const void *p, size_t new
 	void *ret;
 	size_t ks;
 
-	if (unlikely(!p))
+	if (unlikely(!p || p == ZERO_SIZE_PTR))
 		return kmalloc(new_size, flags);
 
 	if (unlikely(!new_size)) {
 		kfree(p);
-		return NULL;
+		return ZERO_SIZE_PTR;
 	}
 
 	ks = ksize(p);
@@ -2652,7 +2662,7 @@ void *__kmalloc_track_caller(size_t size
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	return slab_alloc(s, gfpflags, -1, caller);
 }
@@ -2663,7 +2673,7 @@ void *__kmalloc_node_track_caller(size_t
 	struct kmem_cache *s = get_slab(size, gfpflags);
 
 	if (!s)
-		return NULL;
+		return ZERO_SIZE_PTR;
 
 	return slab_alloc(s, gfpflags, node, caller);
 }
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
group-short-lived-and-reclaimable-kernel-allocations-fix.patch
cpuset-zero-malloc-fix-for-old-cpusets.patch
fix-get_policy-for-stacked-shared-memory-files.patch
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
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
