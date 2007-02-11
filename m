From: akpm@linux-foundation.org
Subject: - set-config_zone_dma-for-arches-with-generic_isa_dma.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:46 -0800
Message-ID: <200702112246.l1BMkkcd015515@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59539 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbXBKWqt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Set CONFIG_ZONE_DMA for arches with GENERIC_ISA_DMA
has been removed from the -mm tree.  Its filename was
     set-config_zone_dma-for-arches-with-generic_isa_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Set CONFIG_ZONE_DMA for arches with GENERIC_ISA_DMA
From: Christoph Lameter <clameter@sgi.com>

As Andi pointed out: CONFIG_GENERIC_ISA_DMA only disables the ISA DMA
channel management.  Other functionality may still expect GFP_DMA to
provide memory below 16M.  So we need to make sure that CONFIG_ZONE_DMA is
set independent of CONFIG_GENERIC_ISA_DMA.  Undo the modifications to
mm/Kconfig where we made ZONE_DMA dependent on GENERIC_ISA_DMA and set
theses explicitly in each arches Kconfig.

Reviews must occur for each arch in order to determine if ZONE_DMA can be
switched off.  It can only be switched off if we know that all devices
supported by a platform are capable of performing DMA transfers to all of
memory (Some arches already support this: uml, avr32, sh sh64, parisc and
IA64/Altix).

In order to switch ZONE_DMA off conditionally, one would have to establish
a scheme by which one can assure that no drivers are enabled that are only
capable of doing I/O to a part of memory, or one needs to provide an
alternate means of performing an allocation from a specific range of memory
(like provided by alloc_pages_range()) and insure that all drivers use that
call.  In that case the arches alloc_dma_coherent() may need to be modified
to call alloc_pages_range() instead of relying on GFP_DMA.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig   |    4 ++++
 arch/arm/Kconfig     |    4 ++++
 arch/arm26/Kconfig   |    4 ++++
 arch/i386/Kconfig    |    4 ++++
 arch/m32r/Kconfig    |    4 ++++
 arch/m68k/Kconfig    |    4 ++++
 arch/mips/Kconfig    |    4 ++++
 arch/powerpc/Kconfig |    4 ++++
 arch/ppc/Kconfig     |    4 ++++
 arch/sparc/Kconfig   |    4 ++++
 arch/sparc64/Kconfig |    4 ++++
 arch/x86_64/Kconfig  |    4 ++++
 mm/Kconfig           |    4 ----
 13 files changed, 48 insertions(+), 4 deletions(-)

diff -puN arch/alpha/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/alpha/Kconfig
@@ -41,6 +41,10 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
diff -puN arch/arm/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/arm/Kconfig
--- a/arch/arm/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/arm/Kconfig
@@ -100,6 +100,10 @@ config GENERIC_BUST_SPINLOCK
 config ARCH_MAY_HAVE_PC_FDC
 	bool
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 
diff -puN arch/arm26/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/arm26/Kconfig
--- a/arch/arm26/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/arm26/Kconfig
@@ -60,6 +60,10 @@ config GENERIC_CALIBRATE_DELAY
 config GENERIC_BUST_SPINLOCK
 	bool
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 
diff -puN arch/i386/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/i386/Kconfig
--- a/arch/i386/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/i386/Kconfig
@@ -38,6 +38,10 @@ config MMU
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config SBUS
 	bool
 
diff -puN arch/m32r/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/m32r/Kconfig
@@ -16,6 +16,10 @@ config GENERIC_ISA_DMA
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_HARDIRQS
 	bool
 	default y
diff -puN arch/m68k/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/m68k/Kconfig
@@ -439,6 +439,10 @@ config GENERIC_ISA_DMA
 	depends on Q40 || AMIGA_PCMCIA || GG2
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 source "drivers/pci/Kconfig"
 
 source "drivers/zorro/Kconfig"
diff -puN arch/mips/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/mips/Kconfig
--- a/arch/mips/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/mips/Kconfig
@@ -8,6 +8,10 @@ mainmenu "Linux/MIPS Kernel Configuratio
 
 menu "Machine selection"
 
+config ZONE_DMA
+	bool
+	default y
+
 choice
 	prompt "System type"
 	default SGI_IP22
diff -puN arch/powerpc/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/powerpc/Kconfig
@@ -977,6 +977,10 @@ config ISA
 	  have an IBM RS/6000 or pSeries machine or a PReP machine, say Y.  If
 	  you have an embedded board, consult your board documentation.
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 	depends on PPC64 || POWER4 || 6xx && !CPM2
diff -puN arch/ppc/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/ppc/Kconfig
--- a/arch/ppc/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/ppc/Kconfig
@@ -1177,6 +1177,10 @@ config ISA
 	  have an IBM RS/6000 or pSeries machine or a PReP machine, say Y.  If
 	  you have an embedded board, consult your board documentation.
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 	depends on 6xx && !CPM2
diff -puN arch/sparc/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/sparc/Kconfig
@@ -13,6 +13,10 @@ config HIGHMEM
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
diff -puN arch/sparc64/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/sparc64/Kconfig
@@ -232,6 +232,10 @@ config LARGE_ALLOCS
 
 source "mm/Kconfig"
 
+config ZONE_DMA
+	bool
+	default y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
diff -puN arch/x86_64/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/arch/x86_64/Kconfig
@@ -44,6 +44,10 @@ config MMU
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config ISA
 	bool
 
diff -puN mm/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma mm/Kconfig
--- a/mm/Kconfig~set-config_zone_dma-for-arches-with-generic_isa_dma
+++ a/mm/Kconfig
@@ -139,10 +139,6 @@ config SPLIT_PTLOCK_CPUS
 	default "4096" if PARISC && !PA20
 	default "4"
 
-config ZONE_DMA
-	def_bool y
-	depends on GENERIC_ISA_DMA
-
 #
 # support for page migration
 #
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids-fix.patch
slab-reduce-size-of-alien-cache-to-cover-only-possible-nodes.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
mm-implement-swap-prefetching-vs-zvc-stuff.patch
mm-implement-swap-prefetching-vs-zvc-stuff-2.patch
zvc-support-nr_slab_reclaimable--nr_slab_unreclaimable-swap_prefetch.patch
reduce-max_nr_zones-swap_prefetch-remove-incorrect-use-of-zone_highmem.patch
numa-add-zone_to_nid-function-swap_prefetch.patch
remove-uses-of-kmem_cache_t-from-mm-and-include-linux-slabh-prefetch.patch
readahead-state-based-method-aging-accounting.patch
readahead-state-based-method-aging-accounting-vs-zvc-changes.patch
