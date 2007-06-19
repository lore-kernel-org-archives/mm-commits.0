From: akpm@linux-foundation.org
Subject: + slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch added to -mm tree
Date: Tue, 19 Jun 2007 12:19:05 -0700
Message-ID: <200706191919.l5JJJ5vL019042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933158AbXFSTTS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 15:19:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     Slab allocators: consolidate code for krealloc in mm/util.c
has been added to the -mm tree.  Its filename is
     slab-allocators-consolidate-code-for-krealloc-in-mm-utilc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -3715,52 +3715,6 @@ EXPORT_SYMBOL(__kmalloc);
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
@@ -407,39 +407,6 @@ void *__kmalloc(size_t size, gfp_t gfp)
 }
 EXPORT_SYMBOL(__kmalloc);
 
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
@@ -2477,43 +2477,6 @@ int kmem_cache_shrink(struct kmem_cache 
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
@@ -81,6 +81,40 @@ void *kmemdup(const void *src, size_t le
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
  * @s: The string to duplicate
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
