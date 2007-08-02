From: akpm@linux-foundation.org
Subject: + x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch added to -mm tree
Date: Thu, 02 Aug 2007 12:08:05 -0700
Message-ID: <200708021908.l72J85ee004633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbXHBTI7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Aug 2007 15:08:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, ak@suse.de, clameter@sgi.com, just.for.lkml@googlemail.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     vmemmap x86_64: ensure end of section memmap is initialised
has been added to the -mm tree.  Its filename is
     x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmemmap x86_64: ensure end of section memmap is initialised
From: Andy Whitcroft <apw@shadowen.org>

Similar to the generic initialisers, the x86_64 vmemmap initialisation may
incorrectly skip the last page of a section if the section start is not
aligned to the page.

Where we have a section spanning the end of a PMD we will check the start
of the section at A populating it.  We will then move on 1 PMD page to C
and find ourselves beyond the end of the section which ends at B we will
complete without checking the second PMD page.

        |     PMD     |     PMD     |
                 | SECTION |
                 A         B   C

We should round ourselves to the end of the PMD as we iterate.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/init.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/mm/init.c~x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised
+++ a/arch/x86_64/mm/init.c
@@ -792,9 +792,10 @@ int __meminit vmemmap_populate_pmd(pud_t
 						unsigned long end, int node)
 {
 	pmd_t *pmd;
+	unsigned long next;
 
-	for (pmd = pmd_offset(pud, addr); addr < end;
-						pmd++, addr += PMD_SIZE)
+	for (pmd = pmd_offset(pud, addr); addr < end; pmd++, addr = next) {
+		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd)) {
 			pte_t entry;
 			void *p = vmemmap_alloc_block(PMD_SIZE, node);
@@ -808,8 +809,8 @@ int __meminit vmemmap_populate_pmd(pud_t
 			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
 				addr, addr + PMD_SIZE - 1, p, node);
 		} else
-			vmemmap_verify((pte_t *)pmd, node,
-						pmd_addr_end(addr, end), end);
+			vmemmap_verify((pte_t *)pmd, node, next, end);
+	}
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
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
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
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
