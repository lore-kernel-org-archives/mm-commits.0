From: akpm@linux-foundation.org
Subject: - generic-virtual-memmap-support-for-sparsemem.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:24 -0700
Message-ID: <200710162030.l9GKUOqa014402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35095 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965598AbXJPV4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, apw@shadowen.org, benh@kernel.crashing.org, davem@davemloft.net, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, paulus@samba.org, tony.luck@intel.com, mm


The patch titled
     Generic Virtual Memmap support for SPARSEMEM
has been removed from the -mm tree.  Its filename was
     generic-virtual-memmap-support-for-sparsemem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic Virtual Memmap support for SPARSEMEM
From: Christoph Lameter <clameter@sgi.com>

SPARSEMEM is a pretty nice framework that unifies quite a bit of code over all
the arches.  It would be great if it could be the default so that we can get
rid of various forms of DISCONTIG and other variations on memory maps.  So far
what has hindered this are the additional lookups that SPARSEMEM introduces
for virt_to_page and page_address.  This goes so far that the code to do this
has to be kept in a separate function and cannot be used inline.

This patch introduces a virtual memmap mode for SPARSEMEM, in which the memmap
is mapped into a virtually contigious area, only the active sections are
physically backed.  This allows virt_to_page page_address and cohorts become
simple shift/add operations.  No page flag fields, no table lookups, nothing
involving memory is required.

The two key operations pfn_to_page and page_to_page become:

   #define __pfn_to_page(pfn)      (vmemmap + (pfn))
   #define __page_to_pfn(page)     ((page) - vmemmap)

By having a virtual mapping for the memmap we allow simple access without
wasting physical memory.  As kernel memory is typically already mapped 1:1
this introduces no additional overhead.  The virtual mapping must be big
enough to allow a struct page to be allocated and mapped for all valid
physical pages.  This vill make a virtual memmap difficult to use on 32 bit
platforms that support 36 address bits.

However, if there is enough virtual space available and the arch already maps
its 1-1 kernel space using TLBs (f.e.  true of IA64 and x86_64) then this
technique makes SPARSEMEM lookups even more efficient than CONFIG_FLATMEM. 
FLATMEM needs to read the contents of the mem_map variable to get the start of
the memmap and then add the offset to the required entry.  vmemmap is a
constant to which we can simply add the offset.

This patch has the potential to allow us to make SPARSMEM the default (and
even the only) option for most systems.  It should be optimal on UP, SMP and
NUMA on most platforms.  Then we may even be able to remove the other memory
models: FLATMEM, DISCONTIG etc.

[apw@shadowen.org: config cleanups, resplit code etc]
[kamezawa.hiroyu@jp.fujitsu.com: Fix sparsemem_vmemmap init]
[apw@shadowen.org: vmemmap: remove excess debugging]
[apw@shadowen.org: simplify initialisation code and reduce duplication]
[apw@shadowen.org: pull out the vmemmap code into its own file]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/memory_model.h |    6 
 include/linux/mm.h                 |    6 
 mm/Makefile                        |    1 
 mm/sparse-vmemmap.c                |  181 +++++++++++++++++++++++++++
 mm/sparse.c                        |   21 ++-
 5 files changed, 211 insertions(+), 4 deletions(-)

diff -puN include/asm-generic/memory_model.h~generic-virtual-memmap-support-for-sparsemem include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~generic-virtual-memmap-support-for-sparsemem
+++ a/include/asm-generic/memory_model.h
@@ -46,6 +46,12 @@
 	 __pgdat->node_start_pfn;					\
 })
 
+#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
+
+/* memmap is virtually contigious.  */
+#define __pfn_to_page(pfn)	(vmemmap + (pfn))
+#define __page_to_pfn(page)	((page) - vmemmap)
+
 #elif defined(CONFIG_SPARSEMEM)
 /*
  * Note: section's mem_map is encorded to reflect its start_pfn.
diff -puN include/linux/mm.h~generic-virtual-memmap-support-for-sparsemem include/linux/mm.h
--- a/include/linux/mm.h~generic-virtual-memmap-support-for-sparsemem
+++ a/include/linux/mm.h
@@ -1218,5 +1218,11 @@ extern int randomize_va_space;
 
 const char * arch_vma_name(struct vm_area_struct *vma);
 
+struct page *sparse_early_mem_map_populate(unsigned long pnum, int nid);
+int vmemmap_populate(struct page *start_page, unsigned long pages, int node);
+int vmemmap_populate_pmd(pud_t *, unsigned long, unsigned long, int);
+void *vmemmap_alloc_block(unsigned long size, int node);
+void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff -puN mm/Makefile~generic-virtual-memmap-support-for-sparsemem mm/Makefile
--- a/mm/Makefile~generic-virtual-memmap-support-for-sparsemem
+++ a/mm/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_SWAP)	+= page_io.o swap_sta
 obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
 obj-$(CONFIG_NUMA) 	+= mempolicy.o
 obj-$(CONFIG_SPARSEMEM)	+= sparse.o
+obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
 obj-$(CONFIG_SHMEM) += shmem.o
 obj-$(CONFIG_TMPFS_POSIX_ACL) += shmem_acl.o
 obj-$(CONFIG_TINY_SHMEM) += tiny-shmem.o
diff -puN /dev/null mm/sparse-vmemmap.c
--- /dev/null
+++ a/mm/sparse-vmemmap.c
@@ -0,0 +1,181 @@
+/*
+ * Virtual Memory Map support
+ *
+ * (C) 2007 sgi. Christoph Lameter <clameter@sgi.com>.
+ *
+ * Virtual memory maps allow VM primitives pfn_to_page, page_to_pfn,
+ * virt_to_page, page_address() to be implemented as a base offset
+ * calculation without memory access.
+ *
+ * However, virtual mappings need a page table and TLBs. Many Linux
+ * architectures already map their physical space using 1-1 mappings
+ * via TLBs. For those arches the virtual memmory map is essentially
+ * for free if we use the same page size as the 1-1 mappings. In that
+ * case the overhead consists of a few additional pages that are
+ * allocated to create a view of memory for vmemmap.
+ *
+ * Special Kconfig settings:
+ *
+ * CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
+ *
+ * 	The architecture has its own functions to populate the memory
+ * 	map and provides a vmemmap_populate function.
+ *
+ * CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
+ *
+ * 	The architecture provides functions to populate the pmd level
+ * 	of the vmemmap mappings.  Allowing mappings using large pages
+ * 	where available.
+ *
+ * 	If neither are set then PAGE_SIZE mappings are generated which
+ * 	require one PTE/TLB per PAGE_SIZE chunk of the virtual memory map.
+ */
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/bootmem.h>
+#include <linux/highmem.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+#include <asm/dma.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
+
+/*
+ * Allocate a block of memory to be used to back the virtual memory map
+ * or to back the page tables that are used to create the mapping.
+ * Uses the main allocators if they are available, else bootmem.
+ */
+void * __meminit vmemmap_alloc_block(unsigned long size, int node)
+{
+	/* If the main allocator is up use that, fallback to bootmem. */
+	if (slab_is_available()) {
+		struct page *page = alloc_pages_node(node,
+				GFP_KERNEL | __GFP_ZERO, get_order(size));
+		if (page)
+			return page_address(page);
+		return NULL;
+	} else
+		return __alloc_bootmem_node(NODE_DATA(node), size, size,
+				__pa(MAX_DMA_ADDRESS));
+}
+
+#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP
+void __meminit vmemmap_verify(pte_t *pte, int node,
+				unsigned long start, unsigned long end)
+{
+	unsigned long pfn = pte_pfn(*pte);
+	int actual_node = early_pfn_to_nid(pfn);
+
+	if (actual_node != node)
+		printk(KERN_WARNING "[%lx-%lx] potential offnode "
+			"page_structs\n", start, end - 1);
+}
+
+#ifndef CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD
+static int __meminit vmemmap_populate_pte(pmd_t *pmd, unsigned long addr,
+					unsigned long end, int node)
+{
+	pte_t *pte;
+
+	for (pte = pte_offset_kernel(pmd, addr); addr < end;
+						pte++, addr += PAGE_SIZE)
+		if (pte_none(*pte)) {
+			pte_t entry;
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			entry = pfn_pte(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
+			set_pte(pte, entry);
+
+		} else
+			vmemmap_verify(pte, node, addr + PAGE_SIZE, end);
+
+	return 0;
+}
+
+int __meminit vmemmap_populate_pmd(pud_t *pud, unsigned long addr,
+						unsigned long end, int node)
+{
+	pmd_t *pmd;
+	int error = 0;
+	unsigned long next;
+
+	for (pmd = pmd_offset(pud, addr); addr < end && !error;
+						pmd++, addr = next) {
+		if (pmd_none(*pmd)) {
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			pmd_populate_kernel(&init_mm, pmd, p);
+		} else
+			vmemmap_verify((pte_t *)pmd, node,
+					pmd_addr_end(addr, end), end);
+		next = pmd_addr_end(addr, end);
+		error = vmemmap_populate_pte(pmd, addr, next, node);
+	}
+	return error;
+}
+#endif /* CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP_PMD */
+
+static int __meminit vmemmap_populate_pud(pgd_t *pgd, unsigned long addr,
+						unsigned long end, int node)
+{
+	pud_t *pud;
+	int error = 0;
+	unsigned long next;
+
+	for (pud = pud_offset(pgd, addr); addr < end && !error;
+						pud++, addr = next) {
+		if (pud_none(*pud)) {
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			pud_populate(&init_mm, pud, p);
+		}
+		next = pud_addr_end(addr, end);
+		error = vmemmap_populate_pmd(pud, addr, next, node);
+	}
+	return error;
+}
+
+int __meminit vmemmap_populate(struct page *start_page,
+						unsigned long nr, int node)
+{
+	pgd_t *pgd;
+	unsigned long addr = (unsigned long)start_page;
+	unsigned long end = (unsigned long)(start_page + nr);
+	unsigned long next;
+	int error = 0;
+
+	printk(KERN_DEBUG "[%lx-%lx] Virtual memory section"
+		" (%ld pages) node %d\n", addr, end - 1, nr, node);
+
+	for (pgd = pgd_offset_k(addr); addr < end && !error;
+					pgd++, addr = next) {
+		if (pgd_none(*pgd)) {
+			void *p = vmemmap_alloc_block(PAGE_SIZE, node);
+			if (!p)
+				return -ENOMEM;
+
+			pgd_populate(&init_mm, pgd, p);
+		}
+		next = pgd_addr_end(addr,end);
+		error = vmemmap_populate_pud(pgd, addr, next, node);
+	}
+	return error;
+}
+#endif /* !CONFIG_ARCH_POPULATES_SPARSEMEM_VMEMMAP */
+
+struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
+{
+	struct page *map = pfn_to_page(pnum * PAGES_PER_SECTION);
+	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
+	if (error)
+		return NULL;
+
+	return map;
+}
diff -puN mm/sparse.c~generic-virtual-memmap-support-for-sparsemem mm/sparse.c
--- a/mm/sparse.c~generic-virtual-memmap-support-for-sparsemem
+++ a/mm/sparse.c
@@ -9,6 +9,8 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <asm/dma.h>
+#include <asm/pgalloc.h>
+#include <asm/pgtable.h>
 
 /*
  * Permanent SPARSEMEM data:
@@ -222,11 +224,10 @@ void *alloc_bootmem_high_node(pg_data_t 
 	return NULL;
 }
 
-static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
+#ifndef CONFIG_SPARSEMEM_VMEMMAP
+struct page __init *sparse_early_mem_map_populate(unsigned long pnum, int nid)
 {
 	struct page *map;
-	struct mem_section *ms = __nr_to_section(pnum);
-	int nid = sparse_early_nid(ms);
 
 	map = alloc_remap(nid, sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)
@@ -239,10 +240,22 @@ static struct page __init *sparse_early_
 
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
+	return map;
+}
+#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
+
+struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
+{
+	struct page *map;
+	struct mem_section *ms = __nr_to_section(pnum);
+	int nid = sparse_early_nid(ms);
+
+	map = sparse_early_mem_map_populate(pnum, nid);
 	if (map)
 		return map;
 
-	printk(KERN_WARNING "%s: allocation failed\n", __FUNCTION__);
+	printk(KERN_ERR "%s: sparsemem memory map backing failed "
+			"some memory will not be available.\n", __FUNCTION__);
 	ms->section_mem_map = 0;
 	return NULL;
 }
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
