From: akpm@linux-foundation.org
Subject: - ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:02:45 -0700
Message-ID: <200710160402.l9G42jlB007771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36099 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008AbXJPEDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, benh@kernel.crashing.org, clameter@sgi.com, haveblue@us.ibm.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     vmemmap ppc64: convert VMM_* macros to a real function
has been removed from the -mm tree.  Its filename was
     ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch

This patch was dropped because it was folded into ppc64-sparsemem_vmemmap-support.patch

------------------------------------------------------
Subject: vmemmap ppc64: convert VMM_* macros to a real function
From: Andy Whitcroft <apw@shadowen.org>

The code to convert an address within the vmemmap to the start of the section
is currently implemented using macros.  Convert these over to a new helper
function, clarifying the code and gaining type checking.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/init_64.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function arch/powerpc/mm/init_64.c
--- a/arch/powerpc/mm/init_64.c~ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function
+++ a/arch/powerpc/mm/init_64.c
@@ -187,14 +187,19 @@ void pgtable_cache_init(void)
 #ifdef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
 
 /*
- * Convert an address within the vmemmap into a pfn.  Note that we have
- * to do this by hand as the proffered address may not be correctly aligned.
+ * Given an address within the vmemmap, determine the pfn of the page that
+ * represents the start of the section it is within.  Note that we have to
+ * do this by hand as the proffered address may not be correctly aligned.
  * Subtraction of non-aligned pointers produces undefined results.
  */
-#define VMM_SECTION(addr) \
-		(((((unsigned long)(addr)) - ((unsigned long)(vmemmap))) / \
-		sizeof(struct page)) >> PFN_SECTION_SHIFT)
-#define VMM_SECTION_PAGE(addr)	(VMM_SECTION(addr) << PFN_SECTION_SHIFT)
+unsigned long __meminit vmemmap_section_start(struct page *page)
+{
+	unsigned long offset = ((unsigned long)page) -
+						((unsigned long)(vmemmap));
+
+	/* Return the pfn of the start of the section. */
+	return (offset / sizeof(struct page)) & PAGE_SECTION_MASK;
+}
 
 /*
  * Check if this vmemmap page is already initialised.  If any section
@@ -206,7 +211,7 @@ int __meminit vmemmap_populated(unsigned
 	unsigned long end = start + page_size;
 
 	for (; start < end; start += (PAGES_PER_SECTION * sizeof(struct page)))
-		if (pfn_valid(VMM_SECTION_PAGE(start)))
+		if (pfn_valid(vmemmap_section_start(start)))
 			return 1;
 
 	return 0;
_

Patches currently in -mm which might be from apw@shadowen.org are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
sparc64-sparsemem_vmemmap-support.patch
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
