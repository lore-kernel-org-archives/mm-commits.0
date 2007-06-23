From: akpm@linux-foundation.org
Subject: + pa-risc-use-page-allocator-instead-of-slab-allocator.patch added to -mm tree
Date: Sat, 23 Jun 2007 09:49:34 -0700
Message-ID: <200706231649.l5NGnVHI019551@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37277 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbXFWQvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 12:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, grundler@parisc-linux.org, hugh@veritas.com, kyle@mcmartin.ca, willy@debian.org


The patch titled
     PA-RISC: Use page allocator instead of slab allocator
has been added to the -mm tree.  Its filename is
     pa-risc-use-page-allocator-instead-of-slab-allocator.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PA-RISC: Use page allocator instead of slab allocator
From: Christoph Lameter <clameter@sgi.com>

Slab pages obtained via kmalloc are not cachline aligned.  Nor is it
advisable to perform VM operations designed for page allocator pages on
memory obtained via kmalloc.

So replace the page sized allocations in kernel/pci-dma.c with page allocator
pages.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>,
Cc: Matthew Wilcox <willy@debian.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/pci-dma.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/parisc/kernel/pci-dma.c~pa-risc-use-page-allocator-instead-of-slab-allocator arch/parisc/kernel/pci-dma.c
--- a/arch/parisc/kernel/pci-dma.c~pa-risc-use-page-allocator-instead-of-slab-allocator
+++ a/arch/parisc/kernel/pci-dma.c
@@ -572,7 +572,7 @@ static void *pa11_dma_alloc_noncoherent(
 	void *addr = NULL;
 
 	/* rely on kmalloc to be cacheline aligned */
-	addr = kmalloc(size, flag);
+	addr = (void *)__get_free_pages(flag, get_order(size));
 	if(addr)
 		*dma_handle = (dma_addr_t)virt_to_phys(addr);
 
@@ -582,7 +582,7 @@ static void *pa11_dma_alloc_noncoherent(
 static void pa11_dma_free_noncoherent(struct device *dev, size_t size,
 					void *vaddr, dma_addr_t iova)
 {
-	kfree(vaddr);
+	free_pages((unsigned long)vaddr, get_order(size));
 	return;
 }
 
_

Patches currently in -mm which might be from clameter@sgi.com are

slub-fix-behavior-if-the-text-output-of-list_locations-overflows-page_size.patch
sched-fix-next_interval-determination-in-idle_balance.patch
slab-allocators-max_order-one-off-fix.patch
git-ubi.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
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
numa-mempolicy-trivial-debug-fixes.patch
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
slub-faster-more-efficient-slab-determination-for-__kmalloc-fix.patch
add-vm_bug_on-in-case-someone-uses-page_mapping-on-a-slab-page.patch
define-config_bounce-to-avoid-useless-inclusion-of-bounce-buffer.patch
revoke-core-code.patch
mm-implement-swap-prefetching.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-cpuset-zero-malloc-fix-for-new-containers.patch
print-out-page_owner-statistics-in-relation-to-fragmentation-avoidance.patch
