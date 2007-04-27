From: akpm@linux-foundation.org
Subject: - slub-core-add-explanation-for-locking.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:21:59 -0700
Message-ID: <200704270821.l3R8LxAN023281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbXD0IWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:22:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB: Add explanation for locking
has been removed from the -mm tree.  Its filename was
     slub-core-add-explanation-for-locking.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB: Add explanation for locking
From: Christoph Lameter <clameter@sgi.com>

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+)

diff -puN mm/slub.c~slub-core-add-explanation-for-locking mm/slub.c
--- a/mm/slub.c~slub-core-add-explanation-for-locking
+++ a/mm/slub.c
@@ -26,6 +26,42 @@
  *   1. slab_lock(page)
  *   2. slab->list_lock
  *
+ *   The slab_lock protects operations on the object of a particular
+ *   slab and its metadata in the page struct. If the slab lock
+ *   has been taken the no allocations nor frees can be performed
+ *   on the objects in the slab nor can the slab be added or removed
+ *   from the partial or full lists since this would mean modifying
+ *   the page_struct of the slab.
+ *
+ *   The list_lock protects the partial and full list on each node and
+ *   the partial slab counter. If taken then no new slabs may be added or
+ *   removed from the lists nor make the number of partial slabs be modified.
+ *   (Note that the total number of slabs is an atomic value that may be
+ *   modified without taking the list lock).
+ *   The list_lock is a centralized lock and thus we avoid taking it as
+ *   much as possible. As long as SLUB does not have to handle partial
+ *   slabs operations can continue without any centralized lock. F.e.
+ *   allocating a long series of objects that fill up slabs does not require
+ *   the list lock.
+ *
+ *   The lock order is sometimes inverted when we are trying to get a slab
+ *   off a list. We take the list_lock and then look for a page on the list
+ *   to use. While we do that objects in the slabs may be freed so we can
+ *   only operate on the slab if we have also taken the slab_lock. So we use
+ *   a slab_try_lock() on the page. If trylock was successful then no frees
+ *   can occur anymore and we can use the slab for allocations etc. If the
+ *   slab_try_lock does not succeed then frees are occur to the slab and
+ *   we better stay away from it for awhile since we may cause a bouncing
+ *   cacheline if we would try to acquire the lock. So go onto the next slab.
+ *   If all pages are busy then we may allocate a new slab instead of reusing
+ *   a partial slab. A new slab has no one operating on it and thus there is
+ *   no danger of cacheline contention.
+ *
+ *   Interrupts are disabled during allocation and deallocation in order to
+ *   make the slab allocator safe to use in the context of an irq. In addition
+ *   interrupts are disabled to insure that the processor does not change
+ *   while handling per_cpu slabs.
+ *
  * SLUB assigns one slab for allocation to each processor.
  * Allocations only occur from these slabs called cpu slabs.
  *
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
