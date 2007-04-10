From: akpm@linux-foundation.org
Subject: + slub-core-add-explanation-for-locking.patch added to -mm tree
Date: Tue, 10 Apr 2007 14:53:01 -0700
Message-ID: <200704102153.l3ALr215018499@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47685 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbXDJVxF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 17:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Add explanation for locking
has been added to the -mm tree.  Its filename is
     slub-core-add-explanation-for-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
