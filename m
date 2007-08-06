From: akpm@linux-foundation.org
Subject: + generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch added to -mm tree
Date: Mon, 06 Aug 2007 11:52:44 -0700
Message-ID: <200708061852.l76Iqiix009326@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754032AbXHFSxx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:53:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, haveblue@us.ibm.com, mel@csn.ul.ie


The patch titled
     vmemmap: remove excess debugging
has been added to the -mm tree.  Its filename is
     generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

x86_64-get-mp_bus_to_node-as-early-v2.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default-v2.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
pci-device-ensure-sysdata-initialised-v4.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static-fix.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
vmemmap-simplify-initialisation-code-and-reduce-duplication.patch
vmemmap-pull-out-the-vmemmap-code-into-its-own-file.patch
vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
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
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
do-not-depend-on-max_order-when-grouping-pages-by-mobility.patch
print-out-statistics-in-relation-to-fragmentation-avoidance-to-proc-pagetypeinfo.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
page-owner-tracking-leak-detector.patch
