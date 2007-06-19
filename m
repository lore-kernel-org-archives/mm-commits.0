From: akpm@linux-foundation.org
Subject: + slub-faster-more-efficient-slab-determination-for-__kmalloc.patch added to -mm tree
Date: Tue, 19 Jun 2007 12:19:26 -0700
Message-ID: <200706191919.l5JJJRh3019069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52283 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933530AbXFSTTg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 19 Jun 2007 15:19:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: faster more efficient slab determination for __kmalloc
has been added to the -mm tree.  Its filename is
     slub-faster-more-efficient-slab-determination-for-__kmalloc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 64 insertions(+), 7 deletions(-)

diff -puN mm/slub.c~slub-faster-more-efficient-slab-determination-for-__kmalloc mm/slub.c
--- a/mm/slub.c~slub-faster-more-efficient-slab-determination-for-__kmalloc
+++ a/mm/slub.c
@@ -2323,20 +2323,59 @@ static noinline struct kmem_cache *dma_k
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
+		index = fls(size - 1) + 1;
+	}
 
 #ifdef CONFIG_ZONE_DMA
-	if ((flags & SLUB_DMA))
+	if (unlikely((flags & SLUB_DMA)))
 		return dma_kmalloc_cache(index, flags);
+
 #endif
 	return &kmalloc_caches[index];
 }
@@ -2551,6 +2590,24 @@ void __init kmem_cache_init(void)
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
+	BUG_ON(KMALLOC_MIN_SIZE > 256 ||
+		(KMALLOC_MIN_SIZE & (KMALLOC_MIN_SIZE - 1)));
+
+	for (i = 8; i < KMALLOC_MIN_SIZE;i++)
+		size_index[(i - 1) / 8] = KMALLOC_SHIFT_LOW;
+
 	slab_state = UP;
 
 	/* Provide the correct kmalloc names now that the caches are up */
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
