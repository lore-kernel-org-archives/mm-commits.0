From: akpm@linux-foundation.org
Subject: - x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:01:16 -0700
Message-ID: <200710160401.l9G41GwK007731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32792 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbXJPEB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     vmemmap x86_64: convert to new helper based initialisation
has been removed from the -mm tree.  Its filename was
     x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation.patch

This patch was dropped because it was folded into x86_64-sparsemem_vmemmap-2m-page-size-support.patch

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

 arch/x86/mm/init_64.c |   26 ++++++++++++++++++++------
 arch/x86_64/Kconfig   |    9 +--------
 2 files changed, 21 insertions(+), 14 deletions(-)

diff -puN arch/x86/mm/init_64.c~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation
+++ a/arch/x86/mm/init_64.c
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
diff -puN arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-vmemmap-x86_64-convert-to-new-helper-based-initialisation
+++ a/arch/x86_64/Kconfig
@@ -406,14 +406,7 @@ config ARCH_DISCONTIGMEM_DEFAULT
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
_

Patches currently in -mm which might be from apw@shadowen.org are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
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
