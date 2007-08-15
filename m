From: akpm@linux-foundation.org
Subject: + x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:34:03 -0700
Message-ID: <200708151934.l7FJY6Qu011488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50208 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754668AbXHOTf4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 15:35:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     vmemmap x86_64: convert to new helper based initialisation
has been added to the -mm tree.  Its filename is
     x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vmemmap x86_64: convert to new helper based initialisation
From: Andy Whitcroft <apw@shadowen.org>

Convert over to the new helper initialialisation and Kconfig options.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig   |    9 +--------
 arch/x86_64/mm/init.c |   26 ++++++++++++++++++++------
 2 files changed, 21 insertions(+), 14 deletions(-)

diff -puN arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation
+++ a/arch/x86_64/Kconfig
@@ -405,14 +405,7 @@ config ARCH_DISCONTIGMEM_DEFAULT
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on (NUMA || EXPERIMENTAL)
-
-config SPARSEMEM_VMEMMAP
-	def_bool y
-	depends on SPARSEMEM
-
-config ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
-	def_bool y
-	depends on SPARSEMEM_VMEMMAP
+	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_MEMORY_PROBE
 	def_bool y
diff -puN arch/x86_64/mm/init.c~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation
+++ a/arch/x86_64/mm/init.c
@@ -749,18 +749,31 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
-#ifdef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
  */
-int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
-						unsigned long end, int node)
+int __meminit vmemmap_populate(struct page *start_page,
+						unsigned long size, int node)
 {
-	pmd_t *pmd;
+	unsigned long addr = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + size);
 	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
 
-	for (pmd = pmd_offset(pud, addr); addr < end; pmd++, addr = next) {
+	for (; addr < end; addr = next) {
 		next = pmd_addr_end(addr, end);
+
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+		pud = vmemmap_pud_populate(pgd, addr, node);
+		if (!pud)
+			return -ENOMEM;
+
+		pmd = pmd_offset(pud, addr);
 		if (pmd_none(*pmd)) {
 			pte_t entry;
 			void *p = vmemmap_alloc_block(PMD_SIZE, node);
@@ -774,8 +787,9 @@ int __meminit vmemmap_populate_pmd(pud_t
 			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
 				addr, addr + PMD_SIZE - 1, p, node);
 		} else
-			vmemmap_verify((pte_t *)pmd, node, next, end);
+			vmemmap_verify((pte_t *)pmd, node, addr, next);
 	}
+
 	return 0;
 }
 #endif
_

Patches currently in -mm which might be from apw@shadowen.org are

sparsemem-ensure-we-initialise-the-node-mapping-for-sparsemem_static.patch
ensure-we-count-pages-transitioning-inactive-via-clear_active_flags.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas.patch
wait-for-page-writeback-when-directly-reclaiming-contiguous-areas-fix.patch
x86_64-get-mp_bus_to_node-as-early-v3.patch
x86_64-use-bus-conf-in-nb-conf-fun1-to-get-bus-range-on-node.patch
try-parent-numa_node-at-first-before-using-default.patch
net-use-numa_node-in-net_devcice-dev-instead-of-parent.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-for-sparsemem-fix.patch
generic-virtual-memmap-support-for-sparsemem-remove-excess-debugging.patch
generic-virtual-memmap-support-for-sparsemem-simplify-initialisation-code-and-reduce-duplication.patch
generic-virtual-memmap-support-for-sparsemem-pull-out-the-vmemmap-code-into-its-own-file.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
x86_64-sparsemem_vmemmap-2m-page-size-support-ensure-end-of-section-memmap-is-initialised.patch
x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
vmemmap-ppc64-convert-to-new-config-options.patch
vmemmap-sparc64-convert-to-new-config-options.patch
vmemmap-ia64-convert-to-new-helper-based-initialisation.patch
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
