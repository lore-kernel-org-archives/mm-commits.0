From: akpm@linux-foundation.org
Subject: + sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:41:43 -0700
Message-ID: <200708151941.l7FJfhfk011741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52634 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbXHOTmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 15:42:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie


The patch titled
     vmemmap sparc64: convert to new config options
has been added to the -mm tree.  Its filename is
     sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1655,7 +1655,7 @@ EXPORT_SYMBOL(_PAGE_E);
 unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
-#ifdef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
 
 #define VMEMMAP_CHUNK_SHIFT	22
 #define VMEMMAP_CHUNK		(1UL << VMEMMAP_CHUNK_SHIFT)
@@ -1705,7 +1705,7 @@ int __meminit vmemmap_populate(struct pa
 	}
 	return 0;
 }
-#endif /* CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP */
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 static void prot_init_common(unsigned long page_none,
 			     unsigned long page_shared,
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
sparc64-sparsemem_vmemmap-support-vmemmap-convert-to-new-config-options.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
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
