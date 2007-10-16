From: akpm@linux-foundation.org
Subject: - ia64-sparsemem_vmemmap-16k-page-size-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:31 -0700
Message-ID: <200710162030.l9GKUVhx014412@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966176AbXJPVs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     IA64: SPARSEMEM_VMEMMAP 16K page size support
has been removed from the -mm tree.  Its filename was
     ia64-sparsemem_vmemmap-16k-page-size-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IA64: SPARSEMEM_VMEMMAP 16K page size support
From: Christoph Lameter <clameter@sgi.com>

Equip IA64 sparsemem with a virtual memmap.  This is similar to the existing
CONFIG_VIRTUAL_MEM_MAP functionality for DISCONTIGMEM.  It uses a PAGE_SIZE
mapping.

This is provided as a minimally intrusive solution.  We split the 128TB
VMALLOC area into two 64TB areas and use one for the virtual memmap.

This should replace CONFIG_VIRTUAL_MEM_MAP long term.

[apw@shadowen.org: convert to new helper based initialisation]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig          |    1 +
 arch/ia64/mm/discontig.c   |    8 ++++++++
 include/asm-ia64/pgtable.h |    6 ++++++
 3 files changed, 15 insertions(+)

diff -puN arch/ia64/Kconfig~ia64-sparsemem_vmemmap-16k-page-size-support arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~ia64-sparsemem_vmemmap-16k-page-size-support
+++ a/arch/ia64/Kconfig
@@ -348,6 +348,7 @@ config ARCH_FLATMEM_ENABLE
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
+	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y if (IA64_SGI_SN2 || IA64_GENERIC || IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB)
diff -puN arch/ia64/mm/discontig.c~ia64-sparsemem_vmemmap-16k-page-size-support arch/ia64/mm/discontig.c
--- a/arch/ia64/mm/discontig.c~ia64-sparsemem_vmemmap-16k-page-size-support
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
diff -puN include/asm-ia64/pgtable.h~ia64-sparsemem_vmemmap-16k-page-size-support include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~ia64-sparsemem_vmemmap-16k-page-size-support
+++ a/include/asm-ia64/pgtable.h
@@ -236,8 +236,14 @@ ia64_phys_addr_valid (unsigned long addr
 # define VMALLOC_END		vmalloc_end
   extern unsigned long vmalloc_end;
 #else
+#if defined(CONFIG_SPARSEMEM) && defined(CONFIG_SPARSEMEM_VMEMMAP)
+/* SPARSEMEM_VMEMMAP uses half of vmalloc... */
+# define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 10)))
+# define vmemmap		((struct page *)VMALLOC_END)
+#else
 # define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
 #endif
+#endif
 
 /* fs/proc/kcore.c */
 #define	kc_vaddr_to_offset(v) ((v) - RGN_BASE(RGN_GATE))
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
pa-risc-use-page-allocator-instead-of-slab-allocator.patch
dma-use-dev_to_node-to-get-node-for-device-in-dma_alloc_pages.patch
x86-fix-cpu_to_node-references.patch
x86-convert-x86_cpu_to_apicid-to-be-a-per-cpu-variable.patch
x86-convert-cpu_llc_id-to-be-a-per-cpu-variable.patch
x86-acpi-use-cpu_physical_id.patch
x86-convert-cpuinfo_x86-array-to-a-per_cpu-array.patch
slub-simplify-irq-off-handling.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-move-prototypes-to-appropriate-header-file.patch
oom-move-constraints-to-enum.patch
oom-change-all_unreclaimable-zone-member-to-flags.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-add-per-zone-locking.patch
oom-serialize-out-of-memory-calls.patch
oom-add-oom_kill_allocating_task-sysctl.patch
oom-suppress-extraneous-stack-and-memory-dump.patch
oom-compare-cpuset-mems_allowed-instead-of-exclusive.patch
oom-do-not-take-callback_mutex.patch
oom-do-not-take-callback_mutex-fix.patch
oom-prevent-including-schedh-in-header-file.patch
oom-add-header-file-to-kbuild-as-unifdef.patch
oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch
mm-test-and-set-zone-reclaim-lock-before-starting.patch
mm-test-and-set-zone-reclaim-lock-before-starting-cleanup.patch
avoid-negative-and-full-width-shifts-in-radix-treec.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
documentation-vm-slabinfoc-clean-up-this-code.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
bit_spin_lock-use-lock-bitops.patch
ext3-support-large-blocksize-up-to-pagesize.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
