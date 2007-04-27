From: akpm@linux-foundation.org
Subject: - slub-core-explain-sizing-of-slabs-in-detail.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:22:05 -0700
Message-ID: <200704270822.l3R8M5VS023290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755552AbXD0IWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:22:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: explain sizing of slabs in detail
has been removed from the -mm tree.  Its filename was
     slub-core-explain-sizing-of-slabs-in-detail.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB: explain sizing of slabs in detail
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   68 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 65 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-core-explain-sizing-of-slabs-in-detail mm/slub.c
--- a/mm/slub.c~slub-core-explain-sizing-of-slabs-in-detail
+++ a/mm/slub.c
@@ -1381,6 +1381,27 @@ static int slub_debug;
 
 static char *slub_debug_slabs;
 
+/*
+ * Calculate the order of allocation given an slab object size.
+ *
+ * The order of allocation has significant impact on other elements
+ * of the system. Generally order 0 allocations should be preferred
+ * since they do not cause fragmentation in the page allocator. Larger
+ * objects may have problems with order 0 because there may be too much
+ * space left unused in a slab. We go to a higher order if more than 1/8th
+ * of the slab would be wasted.
+ *
+ * In order to reach satisfactory performance we must insure that
+ * a minimum number of objects is in one slab. Otherwise we may
+ * generate too much activity on the partial lists. This is less a
+ * concern for large slabs though. slub_max_order specified the order
+ * where we begin to stop considering the number of objects in a slab.
+ *
+ * Higher order allocations also allow the placement of more objects
+ * in a slab and thereby reduce object handling overhead. If the user
+ * has requested a higher mininum order then we start with that one
+ * instead of zero.
+ */
 static int calculate_order(int size)
 {
 	int order;
@@ -1408,6 +1429,10 @@ static int calculate_order(int size)
 	return order;
 }
 
+/*
+ * Function to figure out which alignment to use from the
+ * various ways of specifying it.
+ */
 static unsigned long calculate_alignment(unsigned long flags,
 		unsigned long align)
 {
@@ -1520,28 +1545,48 @@ static int init_kmem_cache_nodes(struct 
 }
 #endif
 
+/*
+ * calculate_sizes() determines the order and the distribution of data within
+ * a slab object.
+ */
 static int calculate_sizes(struct kmem_cache *s)
 {
 	unsigned long flags = s->flags;
 	unsigned long size = s->objsize;
 	unsigned long align = s->align;
 
+	/*
+	 * Determine if we can poison the object itself. If the user of
+	 * the slab may touch the object after free or before allocation
+	 * then we should never poison the object itself.
+	 */
 	if ((flags & SLAB_POISON) && !(flags & SLAB_DESTROY_BY_RCU) &&
 			!s->ctor && !s->dtor)
 		flags |= __OBJECT_POISON;
 	else
 		flags &= ~__OBJECT_POISON;
 
+	/*
+	 * Round up object size to the next word boundary. We can only
+	 * place the free pointer at word boundaries and this determines
+	 * the possible location of the free pointer.
+	 */
 	size = ALIGN(size, sizeof(void *));
 
 	/*
-	 * If we redzone then check if we have space through above
-	 * alignment. If not then add an additional word, so
-	 * that we have a guard value to check for overwrites.
+	 * If we redzone then check if we there is some space between the
+	 * end of the object and the free pointer. If not then add an
+	 * additional word, so that we can establish a redzone between
+	 * the object and the freepointer to be able to chek for overwrites.
 	 */
 	if ((flags & SLAB_RED_ZONE) && size == s->objsize)
 		size += sizeof(void *);
 
+	/*
+	 * With that we have determined how much of the slab is in actual
+	 * use by the object. This is the potential offset to the free
+	 * pointer.
+	 */
 	s->inuse = size;
 
 	if (((flags & (SLAB_DESTROY_BY_RCU | SLAB_POISON)) ||
@@ -1559,10 +1604,24 @@ static int calculate_sizes(struct kmem_c
 	}
 
 	if (flags & SLAB_STORE_USER)
+		/*
+		 * Need to store information about allocs and frees after
+		 * the object.
+		 */
 		size += 2 * sizeof(struct track);
 
+	/*
+	 * Determine the alignment based on various parameters that the
+	 * user specified (this is unecessarily complex due to the attempt
+	 * to be compatible with SLAB. Should be cleaned up some day).
+	 */
 	align = calculate_alignment(flags, align);
 
+	/*
+	 * SLUB stores one object immediately after another beginning from
+	 * offset 0. In order to align the objects we have to simply size
+	 * each object to conform to the alignment.
+	 */
 	size = ALIGN(size, align);
 	s->size = size;
 
@@ -1570,6 +1629,9 @@ static int calculate_sizes(struct kmem_c
 	if (s->order < 0)
 		return 0;
 
+	/*
+	 * Determine the number of objects per slab
+	 */
 	s->objects = (PAGE_SIZE << s->order) / size;
 
 	/*
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-core-fix-kmem_cache_destroy.patch
slub-core-fix-validation.patch
slub-core-add-after-object-padding.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
slub-core-update-cpu-after-new_slab.patch
slub-core-fix-sysfs-directory-handling.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
