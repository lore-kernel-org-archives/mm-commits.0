From: akpm@linux-foundation.org
Subject: - sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch removed from -mm tree
Date: Mon, 15 Oct 2007 21:02:02 -0700
Message-ID: <200710160402.l9G422mY007763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbXJPECu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 00:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     vmemmap sparc64: convert to new config options
has been removed from the -mm tree.  Its filename was
     sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch

This patch was dropped because it was folded into sparc64-sparsemem_vmemmap-support.patch

------------------------------------------------------
Subject: vmemmap sparc64: convert to new config options
From: Andy Whitcroft <apw@shadowen.org>

Convert over to the new Kconfig options.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/Kconfig   |    9 +--------
 arch/sparc64/mm/init.c |    4 ++--
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN arch/sparc64/Kconfig~sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options
+++ a/arch/sparc64/Kconfig
@@ -240,20 +240,13 @@ config ARCH_SELECT_MEMORY_MODEL
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
+	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
 
 source "mm/Kconfig"
 
-config SPARSEMEM_VMEMMAP
-	def_bool y
-	depends on SPARSEMEM
-
-config ARCH_POPULATES_SPARSEMEM_VMEMMAP
-	def_bool y
-	depends on SPARSEMEM_VMEMMAP
-
 config ISA
 	bool
 	help
diff -puN arch/sparc64/mm/init.c~sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options
+++ a/arch/sparc64/mm/init.c
@@ -1645,7 +1645,7 @@ EXPORT_SYMBOL(_PAGE_E);
 unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
-#ifdef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 
 #define VMEMMAP_CHUNK_SHIFT	22
 #define VMEMMAP_CHUNK		(1UL << VMEMMAP_CHUNK_SHIFT)
@@ -1695,7 +1695,7 @@ int __meminit vmemmap_populate(struct pa
 	}
 	return 0;
 }
-#endif /* CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP */
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,
 			     unsigned long page_shared,
_

Patches currently in -mm which might be from apw@shadowen.org are

sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
generic-virtual-memmap-support-vmemmap-generify-initialisation-via-helpers.patch
x86_64-sparsemem_vmemmap-2m-page-size-support.patch
ia64-sparsemem_vmemmap-16k-page-size-support.patch
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
