From: akpm@linux-foundation.org
Subject: + slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch added to -mm tree
Date: Thu, 26 Apr 2007 23:33:50 -0700
Message-ID: <200704270633.l3R6Xptp021364@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38367 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398AbXD0Gdy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 02:33:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Conform more to SLABs SLAB_HWCACHE_ALIGN behavior
has been added to the -mm tree.  Its filename is
     slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Conform more to SLABs SLAB_HWCACHE_ALIGN behavior
From: Christoph Lameter <clameter@sgi.com>

Currently SLUB is using a strict L1_CACHE_BYTES alignment if
SLAB_HWCACHE_ALIGN is specified. SLAB does not align to a cacheline if the
object is smaller than half of a cacheline. Small objects are then aligned
by SLAB to a fraction of a cacheline.

Make SLUB just forget about the alignment requirement if the object size
is less than L1_CACHE_BYTES. It seems that fractional alignments are no
good because they grow the object and reduce the object density in a cache
line needlessly causing additional cache line fetches.

If we are already throwing the user suggestion of a cache line alignment
away then lets do the best we can. Maybe SLAB_HWCACHE_ALIGN also needs
to be tossed given its wishy-washy handling but doing so would require
an audit of all kmem_cache_allocs throughout the kernel source.

In any case one needs to explictly specify an alignment during
kmem_cache_create to either slab allocator in order to ensure that the
objects are cacheline aligned.

[Patch has a nice memory compaction effect on 32 bit platforms]

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff -puN mm/slub.c~slub-core-conform-more-to-slabs-slab_hwcache_align-behavior mm/slub.c
--- a/mm/slub.c~slub-core-conform-more-to-slabs-slab_hwcache_align-behavior
+++ a/mm/slub.c
@@ -1474,9 +1474,19 @@ static int calculate_order(int size)
  * various ways of specifying it.
  */
 static unsigned long calculate_alignment(unsigned long flags,
-		unsigned long align)
+		unsigned long align, unsigned long size)
 {
-	if (flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN))
+	/*
+	 * If the user wants hardware cache aligned objects then
+	 * follow that suggestion if the object is sufficiently
+	 * large.
+	 *
+	 * The hardware cache alignment cannot override the
+	 * specified alignment though. If that is greater
+	 * then use it.
+	 */
+	if ((flags & (SLAB_MUST_HWCACHE_ALIGN | SLAB_HWCACHE_ALIGN)) &&
+			size > L1_CACHE_BYTES / 2)
 		return max_t(unsigned long, align, L1_CACHE_BYTES);
 
 	if (align < ARCH_SLAB_MINALIGN)
@@ -1664,7 +1674,7 @@ static int calculate_sizes(struct kmem_c
 	 * user specified (this is unecessarily complex due to the attempt
 	 * to be compatible with SLAB. Should be cleaned up some day).
 	 */
-	align = calculate_alignment(flags, align);
+	align = calculate_alignment(flags, align, s->objsize);
 
 	/*
 	 * SLUB stores one object immediately after another beginning from
@@ -2252,7 +2262,7 @@ static struct kmem_cache *find_mergeable
 		return NULL;
 
 	size = ALIGN(size, sizeof(void *));
-	align = calculate_alignment(flags, align);
+	align = calculate_alignment(flags, align, size);
 	size = ALIGN(size, align);
 
 	list_for_each(h, &slab_caches) {
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
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
extend-print_symbol-capability-fix-fix.patch
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
slub-i386-support.patch
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
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
