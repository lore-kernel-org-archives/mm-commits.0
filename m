From: akpm@linux-foundation.org
Subject: - x86_64-sparsemem_vmemmap-2m-page-size-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:29 -0700
Message-ID: <200710162030.l9GKUTjP014408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933800AbXJPVzS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     x86_64: SPARSEMEM_VMEMMAP 2M page size support
has been removed from the -mm tree.  Its filename was
     x86_64-sparsemem_vmemmap-2m-page-size-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: SPARSEMEM_VMEMMAP 2M page size support
From: Christoph Lameter <clameter@sgi.com>

x86_64 uses 2M page table entries to map its 1-1 kernel space.  We also
implement the virtual memmap using 2M page table entries.  So there is no
additional runtime overhead over FLATMEM, initialisation is slightly more
complex.  As FLATMEM still references memory to obtain the mem_map pointer and
SPARSEMEM_VMEMMAP uses a compile time constant, SPARSEMEM_VMEMMAP should be
superior.

With this SPARSEMEM becomes the most efficient way of handling virt_to_page,
pfn_to_page and friends for UP, SMP and NUMA on x86_64.

[apw@shadowen.org: code resplit, style fixups]
[apw@shadowen.org: vmemmap x86_64: ensure end of section memmap is initialised]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/mm.txt  |    1 
 arch/x86/mm/init_64.c        |   45 +++++++++++++++++++++++++++++++++
 arch/x86_64/Kconfig          |    1 
 include/asm-x86/page_64.h    |    1 
 include/asm-x86/pgtable_64.h |    1 
 5 files changed, 49 insertions(+)

diff -puN Documentation/x86_64/mm.txt~x86_64-sparsemem_vmemmap-2m-page-size-support Documentation/x86_64/mm.txt
--- a/Documentation/x86_64/mm.txt~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/Documentation/x86_64/mm.txt
@@ -9,6 +9,7 @@ ffff800000000000 - ffff80ffffffffff (=40
 ffff810000000000 - ffffc0ffffffffff (=46 bits) direct mapping of all phys. memory
 ffffc10000000000 - ffffc1ffffffffff (=40 bits) hole
 ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
+ffffe20000000000 - ffffe2ffffffffff (=40 bits) virtual memory map (1TB)
 ... unused hole ...
 ffffffff80000000 - ffffffff82800000 (=40 MB)   kernel text mapping, from phys 0
 ... unused hole ...
diff -puN arch/x86/mm/init_64.c~x86_64-sparsemem_vmemmap-2m-page-size-support arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/arch/x86/mm/init_64.c
@@ -748,3 +748,48 @@ const char *arch_vma_name(struct vm_area
 		return "[vsyscall]";
 	return NULL;
 }
+
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+/*
+ * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
+ */
+int __meminit vmemmap_populate(struct page *start_page,
+						unsigned long size, int node)
+{
+	unsigned long addr = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + size);
+	unsigned long next;
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	for (; addr < end; addr = next) {
+		next = pmd_addr_end(addr, end);
+
+		pgd = vmemmap_pgd_populate(addr, node);
+		if (!pgd)
+			return -ENOMEM;
+		pud = vmemmap_pud_populate(pgd, addr, node);
+		if (!pud)
+			return -ENOMEM;
+
+		pmd = pmd_offset(pud, addr);
+		if (pmd_none(*pmd)) {
+			pte_t entry;
+			void *p = vmemmap_alloc_block(PMD_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+			mk_pte_huge(entry);
+			set_pmd(pmd, __pmd(pte_val(entry)));
+
+			printk(KERN_DEBUG " [%lx-%lx] PMD ->%p on node %d\n",
+				addr, addr + PMD_SIZE - 1, p, node);
+		} else
+			vmemmap_verify((pte_t *)pmd, node, addr, next);
+	}
+
+	return 0;
+}
+#endif
diff -puN arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-2m-page-size-support arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/arch/x86_64/Kconfig
@@ -409,6 +409,7 @@ config ARCH_DISCONTIGMEM_DEFAULT
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on (NUMA || EXPERIMENTAL)
+	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_MEMORY_PROBE
 	def_bool y
diff -puN include/asm-x86/page_64.h~x86_64-sparsemem_vmemmap-2m-page-size-support include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/include/asm-x86/page_64.h
@@ -134,6 +134,7 @@ extern unsigned long __phys_addr(unsigne
 	 VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #define __HAVE_ARCH_GATE_AREA 1	
+#define vmemmap ((struct page *)VMEMMAP_START)
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/page.h>
diff -puN include/asm-x86/pgtable_64.h~x86_64-sparsemem_vmemmap-2m-page-size-support include/asm-x86/pgtable_64.h
--- a/include/asm-x86/pgtable_64.h~x86_64-sparsemem_vmemmap-2m-page-size-support
+++ a/include/asm-x86/pgtable_64.h
@@ -137,6 +137,7 @@ static inline pte_t ptep_get_and_clear_f
 #define MAXMEM		 _AC(0x3fffffffffff, UL)
 #define VMALLOC_START    _AC(0xffffc20000000000, UL)
 #define VMALLOC_END      _AC(0xffffe1ffffffffff, UL)
+#define VMEMMAP_START	 _AC(0xffffe20000000000, UL)
 #define MODULES_VADDR    _AC(0xffffffff88000000, UL)
 #define MODULES_END      _AC(0xfffffffffff00000, UL)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
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
