From: akpm@linux-foundation.org
Subject: - introduce-config_zone_dma.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:46:34 -0800
Message-ID: <200702112246.l1BMkYvc015500@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59557 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932626AbXBKWqz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, James.Bottomley@steeleye.com, ak@suse.de, kyle@mcmartin.ca, lethal@linux-sh.org, tony.luck@intel.com, willy@debian.org, mm-commits@vger.kernel.org


The patch titled
     optional ZONE_DMA: introduce CONFIG_ZONE_DMA
has been removed from the -mm tree.  Its filename was
     introduce-config_zone_dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: optional ZONE_DMA: introduce CONFIG_ZONE_DMA
From: Christoph Lameter <clameter@sgi.com>

This patch simply defines CONFIG_ZONE_DMA for all arches.  We later do special
things with CONFIG_ZONE_DMA after the VM and an arch are prepared to work
without ZONE_DMA.

CONFIG_ZONE_DMA can be defined in two ways depending on how an architecture
handles ISA DMA.

First if CONFIG_GENERIC_ISA_DMA is set by the arch then we know that the arch
needs ZONE_DMA because ISA DMA devices are supported.  We can catch this in
mm/Kconfig and do not need to modify arch code.

Second, arches may use ZONE_DMA in an unknown way.  We set CONFIG_ZONE_DMA for
all arches that do not set CONFIG_GENERIC_ISA_DMA in order to insure backwards
compatibility.  The arches may later undefine ZONE_DMA if their arch code has
been verified to not depend on ZONE_DMA.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Matthew Wilcox <willy@debian.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/Kconfig      |    4 ++++
 arch/frv/Kconfig       |    4 ++++
 arch/h8300/Kconfig     |    4 ++++
 arch/ia64/Kconfig      |    4 ++++
 arch/m68knommu/Kconfig |    4 ++++
 arch/s390/Kconfig      |    4 ++++
 arch/v850/Kconfig      |    3 +++
 arch/xtensa/Kconfig    |    4 ++++
 mm/Kconfig             |    4 ++++
 9 files changed, 35 insertions(+)

diff -puN arch/cris/Kconfig~introduce-config_zone_dma arch/cris/Kconfig
--- a/arch/cris/Kconfig~introduce-config_zone_dma
+++ a/arch/cris/Kconfig
@@ -9,6 +9,10 @@ config MMU
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
diff -puN arch/frv/Kconfig~introduce-config_zone_dma arch/frv/Kconfig
--- a/arch/frv/Kconfig~introduce-config_zone_dma
+++ a/arch/frv/Kconfig
@@ -6,6 +6,10 @@ config FRV
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
diff -puN arch/h8300/Kconfig~introduce-config_zone_dma arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~introduce-config_zone_dma
+++ a/arch/h8300/Kconfig
@@ -17,6 +17,10 @@ config SWAP
 	bool
 	default n
 
+config ZONE_DMA
+	bool
+	default y
+
 config FPU
 	bool
 	default n
diff -puN arch/ia64/Kconfig~introduce-config_zone_dma arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~introduce-config_zone_dma
+++ a/arch/ia64/Kconfig
@@ -24,6 +24,10 @@ config 64BIT
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config MMU
 	bool
 	default y
diff -puN arch/m68knommu/Kconfig~introduce-config_zone_dma arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~introduce-config_zone_dma
+++ a/arch/m68knommu/Kconfig
@@ -17,6 +17,10 @@ config FPU
 	bool
 	default n
 
+config ZONE_DMA
+	bool
+	default y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
diff -puN arch/s390/Kconfig~introduce-config_zone_dma arch/s390/Kconfig
--- a/arch/s390/Kconfig~introduce-config_zone_dma
+++ a/arch/s390/Kconfig
@@ -7,6 +7,10 @@ config MMU
 	bool
 	default y
 
+config ZONE_DMA
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
diff -puN arch/v850/Kconfig~introduce-config_zone_dma arch/v850/Kconfig
--- a/arch/v850/Kconfig~introduce-config_zone_dma
+++ a/arch/v850/Kconfig
@@ -10,6 +10,9 @@ mainmenu "uClinux/v850 (w/o MMU) Kernel 
 config MMU
        	bool
 	default n
+config ZONE_DMA
+	bool
+	default y
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
diff -puN arch/xtensa/Kconfig~introduce-config_zone_dma arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~introduce-config_zone_dma
+++ a/arch/xtensa/Kconfig
@@ -7,6 +7,10 @@ config FRAME_POINTER
 	bool
 	default n
 
+config ZONE_DMA
+	bool
+	default y
+
 config XTENSA
 	bool
 	default y
diff -puN mm/Kconfig~introduce-config_zone_dma mm/Kconfig
--- a/mm/Kconfig~introduce-config_zone_dma
+++ a/mm/Kconfig
@@ -139,6 +139,10 @@ config SPLIT_PTLOCK_CPUS
 	default "4096" if PARISC && !PA20
 	default "4"
 
+config ZONE_DMA
+	def_bool y
+	depends on GENERIC_ISA_DMA
+
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
