From: akpm@linux-foundation.org
Subject: + slub-extract-dma_kmalloc_cache-from-get_cache.patch added to -mm tree
Date: Tue, 19 Jun 2007 12:19:22 -0700
Message-ID: <200706191919.l5JJJM3E019063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933523AbXFSTTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 15:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: extract dma_kmalloc_cache from get_cache.
has been added to the -mm tree.  Its filename is
     slub-extract-dma_kmalloc_cache-from-get_cache.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 36 insertions(+), 30 deletions(-)

diff -puN mm/slub.c~slub-extract-dma_kmalloc_cache-from-get_cache mm/slub.c
--- a/mm/slub.c~slub-extract-dma_kmalloc_cache-from-get_cache
+++ a/mm/slub.c
@@ -2282,6 +2282,40 @@ panic:
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
@@ -2294,36 +2328,8 @@ static struct kmem_cache *get_slab(size_
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
