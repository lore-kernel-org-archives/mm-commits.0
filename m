From: akpm@linux-foundation.org
Subject: - ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:01:32 -0700
Message-ID: <200710160401.l9G41Wp1007734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbXJPECO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:02:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     vmemmap ia64: convert to new helper based initialisation
has been removed from the -mm tree.  Its filename was
     ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation.patch

This patch was dropped because it was folded into ia64-sparsemem_vmemmap-16k-page-size-support.patch

------------------------------------------------------
Subject: vmemmap ia64: convert to new helper based initialisation
From: Andy Whitcroft <apw@shadowen.org>

Convert over to the new helper initialialisation and Kconfig options.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig        |    5 +----
 arch/ia64/mm/discontig.c |    8 ++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/ia64/Kconfig~ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation
+++ a/arch/ia64/Kconfig
@@ -348,10 +348,7 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
-
-config SPARSEMEM_VMEMMAP
-	def_bool y
-	depends on SPARSEMEM
+	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y if (IA64_SGI_SN2 || IA64_GENERIC || IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB)
diff -puN arch/ia64/mm/discontig.c~ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-sparsemem_vmemmap-16k-page-size-support-convert-to-new-helper-based-initialisation
+++ a/arch/ia64/mm/discontig.c
@@ -715,3 +715,11 @@ void arch_refresh_nodedata(int update_no
 	scatter_node_data();
 }
 #endif
+
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+int __meminit vmemmap_populate(struct page *start_page,
+						unsigned long size, int node)
+{
+	return vmemmap_populate_basepages(start_page, size, node);
+}
+#endif
_

Patches currently in -mm which might be from apw@shadowen.org are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
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
