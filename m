From: akpm@linux-foundation.org
Subject: + slab-allocators-support-__gfp_zero-in-all-allocators.patch added to -mm tree
Date: Tue, 19 Jun 2007 12:19:11 -0700
Message-ID: <200706191919.l5JJJCwc019048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933197AbXFSTTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 15:19:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, penberg@cs.helsinki.fi


The patch titled
     Slab allocators: support __GFP_ZERO in all allocators
has been added to the -mm tree.  Its filename is
     slab-allocators-support-__gfp_zero-in-all-allocators.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Slab allocators: support __GFP_ZERO in all allocators
From: Christoph Lameter <clameter@sgi.com>

A kernel convention for many allocators is that if __GFP_ZERO is passed to an
allocator then the allocated memory should be zeroed.

This is currently not supported by the slab allocators.  The inconsistency
makes it difficult to implement in derived allocators such as in the uncached
allocator and the pool allocators.

In addition the support zeroed allocations in the slab allocators does not
have a consistent API.  There are no zeroing allocator functions for NUMA node
placement (kmalloc_node, kmem_cache_alloc_node).  The zeroing allocations are
only provided for default allocs (kzalloc, kmem_cache_zalloc_node). 
__GFP_ZERO will make zeroing universally available and does not require any
addititional functions.

So add the necessary logic to all slab allocators to support __GFP_ZERO.

The code is added to the hot path.  The gfp flags are on the stack and so the
cacheline is readily available for checking if we want a zeroed object.

Zeroing while allocating is now a frequent operation and we seem to be
gradually approaching a 1-1 parity between zeroing and not zeroing allocs. 
The current tree has 3476 uses of kmalloc vs 2731 uses of kzalloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    8 +++++++-
 mm/slob.c |    2 ++
 mm/slub.c |   24 +++++++++++++++---------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff -puN mm/slab.c~slab-allocators-support-__gfp_zero-in-all-allocators mm/slab.c
--- a/mm/slab.c~slab-allocators-support-__gfp_zero-in-all-allocators
+++ a/mm/slab.c
@@ -2734,7 +2734,7 @@ static int cache_grow(struct kmem_cache 
 	 * Be lazy and only check for valid flags here,  keeping it out of the
 	 * critical path in kmem_cache_alloc().
 	 */
-	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
+	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
 
 	local_flags = (flags & GFP_LEVEL_MASK);
 	/* Take the l3 list lock to change the colour_next on this node */
@@ -3380,6 +3380,9 @@ __cache_alloc_node(struct kmem_cache *ca
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
+	if (unlikely((flags & __GFP_ZERO) && ptr))
+		memset(ptr, 0, cachep->buffer_size);
+
 	return ptr;
 }
 
@@ -3431,6 +3434,9 @@ __cache_alloc(struct kmem_cache *cachep,
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	prefetchw(objp);
 
+	if (unlikely((flags & __GFP_ZERO) && objp))
+		memset(objp, 0, cachep->buffer_size);
+
 	return objp;
 }
 
diff -puN mm/slob.c~slab-allocators-support-__gfp_zero-in-all-allocators mm/slob.c
--- a/mm/slob.c~slab-allocators-support-__gfp_zero-in-all-allocators
+++ a/mm/slob.c
@@ -293,6 +293,8 @@ static void *slob_alloc(size_t size, gfp
 		BUG_ON(!b);
 		spin_unlock_irqrestore(&slob_lock, flags);
 	}
+	if (unlikely((gfp & __GFP_ZERO) && b))
+		memset(b, 0, size);
 	return b;
 }
 
diff -puN mm/slub.c~slab-allocators-support-__gfp_zero-in-all-allocators mm/slub.c
--- a/mm/slub.c~slab-allocators-support-__gfp_zero-in-all-allocators
+++ a/mm/slub.c
@@ -1087,7 +1087,7 @@ static struct page *new_slab(struct kmem
 	void *last;
 	void *p;
 
-	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
+	BUG_ON(flags & ~(GFP_DMA | __GFP_ZERO | GFP_LEVEL_MASK));
 
 	if (flags & __GFP_WAIT)
 		local_irq_enable();
@@ -1550,7 +1550,7 @@ debug:
  * Otherwise we can simply pick the next object from the lockless free list.
  */
 static void __always_inline *slab_alloc(struct kmem_cache *s,
-				gfp_t gfpflags, int node, void *addr)
+		gfp_t gfpflags, int node, void *addr, int length)
 {
 	struct page *page;
 	void **object;
@@ -1568,19 +1568,25 @@ static void __always_inline *slab_alloc(
 		page->lockless_freelist = object[page->offset];
 	}
 	local_irq_restore(flags);
+
+	if (unlikely((gfpflags & __GFP_ZERO) && object))
+		memset(object, 0, length);
+
 	return object;
 }
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
 {
-	return slab_alloc(s, gfpflags, -1, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, -1,
+			__builtin_return_address(0), s->objsize);
 }
 EXPORT_SYMBOL(kmem_cache_alloc);
 
 #ifdef CONFIG_NUMA
 void *kmem_cache_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	return slab_alloc(s, gfpflags, node, __builtin_return_address(0));
+	return slab_alloc(s, gfpflags, node,
+		__builtin_return_address(0), s->objsize);
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node);
 #endif
@@ -2328,7 +2334,7 @@ void *__kmalloc(size_t size, gfp_t flags
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, flags, -1, __builtin_return_address(0));
+	return slab_alloc(s, flags, -1, __builtin_return_address(0), size);
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -2340,7 +2346,7 @@ void *__kmalloc_node(size_t size, gfp_t 
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, flags, node, __builtin_return_address(0));
+	return slab_alloc(s, flags, node, __builtin_return_address(0), size);
 }
 EXPORT_SYMBOL(__kmalloc_node);
 #endif
@@ -2663,7 +2669,7 @@ void *kmem_cache_zalloc(struct kmem_cach
 {
 	void *x;
 
-	x = slab_alloc(s, flags, -1, __builtin_return_address(0));
+	x = slab_alloc(s, flags, -1, __builtin_return_address(0), 0);
 	if (x)
 		memset(x, 0, s->objsize);
 	return x;
@@ -2713,7 +2719,7 @@ void *__kmalloc_track_caller(size_t size
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, gfpflags, -1, caller);
+	return slab_alloc(s, gfpflags, -1, caller, size);
 }
 
 void *__kmalloc_node_track_caller(size_t size, gfp_t gfpflags,
@@ -2724,7 +2730,7 @@ void *__kmalloc_node_track_caller(size_t
 	if (ZERO_OR_NULL_PTR(s))
 		return s;
 
-	return slab_alloc(s, gfpflags, node, caller);
+	return slab_alloc(s, gfpflags, node, caller, size);
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_SLUB_DEBUG)
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
