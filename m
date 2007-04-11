From: akpm@linux-foundation.org
Subject: + slub-mm-only-make-slub-the-default-slab-allocator.patch added to -mm tree
Date: Tue, 10 Apr 2007 17:59:43 -0700
Message-ID: <200704110059.l3B0xh2E024709@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54484 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161135AbXDKA7s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 20:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: mm-only: Make SLUB the default slab allocator
has been added to the -mm tree.  Its filename is
     slub-mm-only-make-slub-the-default-slab-allocator.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: mm-only: Make SLUB the default slab allocator
From: Christoph Lameter <clameter@sgi.com>

Make SLUB the default slab allocator

WARNING: This is a new allocator. No guarantees.

Known areas of concern:

A. i386 and FRV arches have been disabled by setting
   ARCH_USES_SLAB_PAGE_STRUCT. SLUB cannot be enabled on those platforms.

   The issue is that both arches use the page->index and page->private field
   of memory allocated via the slab. SLUB uses these fields too. There are
   a variety of patches out there (some by me, some by Bill Irwin) to address
   this but without those you may be stuck until Bill Irwin comes up with a
   definite solution.

B. There may be undiscovered locations in arch code that are as badly
   behaved as i386 and FRV which will likely cause the arch not to boot
   and fail with mysterious error messages.

C. Unlike SLAB, SLUB does not special case page sized allocations. SLAB
   aligns kmallocs of page sized allocation on page boundaries.
   SLUB also does that most of the time but does not guarantee alignment
   beyond KMALLOC_ARCH_MINALIGN that is valid for other kmalloc slabs.
   In particular enabling debugging will add some tracking information
   to slabs which will usually cause page sized slabs to become no longer
   aligned on page boundaries.

   If there is arch code that relies on this behavior then we are likely
   to see funky behavior. Code that uses page sized allocations via kmalloc
   should either use the page allocator or explictly request page aligned
   data from the slab by creating a custom slab with the needed alignment.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN init/Kconfig~slub-mm-only-make-slub-the-default-slab-allocator init/Kconfig
--- a/init/Kconfig~slub-mm-only-make-slub-the-default-slab-allocator
+++ a/init/Kconfig
@@ -521,7 +521,7 @@ config PROC_KPAGEMAP
 
 choice
 	prompt "Choose SLAB allocator"
-	default SLAB
+	default SLUB
 	help
 	   This option allows to select a slab allocator.
 
@@ -534,7 +534,7 @@ config SLAB
 	  slab allocator.
 
 config SLUB
-	depends on EXPERIMENTAL && !ARCH_USES_SLAB_PAGE_STRUCT
+	depends on !ARCH_USES_SLAB_PAGE_STRUCT
 	bool "SLUB (Unqueued Allocator)"
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
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
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
