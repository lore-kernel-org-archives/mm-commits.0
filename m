From: akpm@linux-foundation.org
Subject: - generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch removed from -mm tree
Date: Mon, 15 Oct 2007 20:58:42 -0700
Message-ID: <200710160358.l9G3wgkr007611@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758753AbXJPD7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 23:59:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     vmemmap: remove excess debugging
has been removed from the -mm tree.  Its filename was
     generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch

This patch was dropped because it was folded into generic-virtual-memmap-support-for-sparsemem.patch

------------------------------------------------------
Subject: vmemmap: remove excess debugging
From: Andy Whitcroft <apw@shadowen.org>

Outputting each and every PTE as it is loaded is somewhat overkill zap this
debug.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging mm/sparse.c
--- a/mm/sparse.c~generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging
+++ a/mm/sparse.c
@@ -306,9 +306,6 @@ static int __meminit vmemmap_populate_pt
 			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 			set_pte(pte, entry);
 
-			printk(KERN_DEBUG "[%lx-%lx] PTE ->%p on node %d\n",
-				addr, addr + PAGE_SIZE - 1, p, node);
-
 		} else
 			vmemmap_verify(pte, node, addr + PAGE_SIZE, end);
 
_

Patches currently in -mm which might be from apw@shadowen.org are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch
sparc64-sparsemem_vmemmap-support.patch
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function-fix.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
update-n_high_memory-node-state-for-memory-hotadd-fix.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
fix-calculation-in-move_freepages_block-for-counting-pages.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap.patch
memory-hotplug-hot-add-with-sparsemem-vmemmap-update.patch
hugetlb-move-update_and_free_page.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_private-mappings.patch
hugetlb-try-to-grow-hugetlb-pool-for-map_shared-mappings.patch
hugetlb-add-hugetlb_dynamic_pool-sysctl.patch
update-checkpatchpl-to-version-010.patch
printk-add-kern_cont-annotation.patch
page-owner-tracking-leak-detector.patch
