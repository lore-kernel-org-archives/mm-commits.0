From: akpm@linux-foundation.org
Subject: + slub-core-explain-sizing-of-slabs-in-detail.patch added to -mm tree
Date: Tue, 10 Apr 2007 16:47:35 -0700
Message-ID: <200704102347.l3ANle0g023337@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52583 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161062AbXDJXro (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 19:47:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: explain sizing of slabs in detail
has been added to the -mm tree.  Its filename is
     slub-core-explain-sizing-of-slabs-in-detail.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
