From: akpm@osdl.org
Subject: + virtual-memmap-on-sparsemem-v3-generic-virtual.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:30:40 -0800
Message-ID: <200612090030.kB90UfwH011051@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57123 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947585AbWLIAb0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:31:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com


The patch titled
     virtual memmap on sparsemem: generic virtual  mem_map on sparsemem
has been added to the -mm tree.  Its filename is
     virtual-memmap-on-sparsemem-v3-generic-virtual.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtual memmap on sparsemem: generic virtual  mem_map on sparsemem
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

This patch implements of virtual mem_map on sparsemem.  This includes only
arch independent part and depends on generic map/unmap in the kernel function
in this patch series.

Usual sparsemem(_extreme) have to do global table look up in
pfn_to_page()/page_to_pfn(), this seems a bit costly.

If an arch has enough address space to map all mem_map in linear, it is good
to map sprase mem_map as linear mem_map.  This redcuces cost of
pfn_to_page()/page_to_pfn().  This concept is used by ia64's VIRTUAL_MEM_MAP.

pfn_valid() works as same as usual sparsemem.

callbacks to create vmem_map are used for using alloc_bootmem_node() for
allocationg pud/pmd/pte.

How to use:
fix struct page *mem_map's pointing address before calling sparse_init().
that's all.

Note:
I assumes that mem_map per each section is always aligned to PAGE_SIZE.
For example, ia64.
sizeof(struct page) = 56 && PAGES_PER_SECTION=65536. Then mem_map per
section is aligned to 56 * 65536 bytes.
#error will detect this.

Signed-off-by: KAMEZAWA Hiruyoki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-generic/memory_model.h |    6 +
 include/linux/mmzone.h             |    9 +-
 mm/Kconfig                         |   10 ++
 mm/memory.c                        |    6 +
 mm/sparse.c                        |  112 ++++++++++++++++++++++++++-
 5 files changed, 138 insertions(+), 5 deletions(-)

diff -puN include/asm-generic/memory_model.h~virtual-memmap-on-sparsemem-v3-generic-virtual include/asm-generic/memory_model.h
--- a/include/asm-generic/memory_model.h~virtual-memmap-on-sparsemem-v3-generic-virtual
+++ a/include/asm-generic/memory_model.h
@@ -47,6 +47,11 @@
 })
 
 #elif defined(CONFIG_SPARSEMEM)
+
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#define __page_to_pfn(pg)		((pg) - mem_map)
+#define __pfn_to_page(pfn)		(mem_map + (pfn))
+#else
 /*
  * Note: section's mem_map is encorded to reflect its start_pfn.
  * section[i].section_mem_map == mem_map's address - start_pfn;
@@ -62,6 +67,7 @@
 	struct mem_section *__sec = __pfn_to_section(__pfn);	\
 	__section_mem_map_addr(__sec) + __pfn;		\
 })
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 #endif /* CONFIG_FLATMEM/DISCONTIGMEM/SPARSEMEM */
 
 #ifdef CONFIG_OUT_OF_LINE_PFN_TO_PAGE
diff -puN include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-generic-virtual include/linux/mmzone.h
--- a/include/linux/mmzone.h~virtual-memmap-on-sparsemem-v3-generic-virtual
+++ a/include/linux/mmzone.h
@@ -386,7 +386,7 @@ struct node_active_region {
 };
 #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
 
-#ifndef CONFIG_DISCONTIGMEM
+#if !defined(CONFIG_DISCONTIGMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 /* The array of struct pages - for discontigmem use pgdat->lmem_map */
 extern struct page *mem_map;
 #endif
@@ -689,6 +689,13 @@ extern int __section_nr(struct mem_secti
 #define SECTION_MAP_MASK	(~(SECTION_MAP_LAST_BIT-1))
 #define SECTION_NID_SHIFT	2
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#if (((BITS_PER_LONG/4) * PAGES_PER_SECTION) % PAGE_SIZE) != 0
+#error "PAGE_SIZE/SECTION_SIZE relationship is not suitable for vmem_map"
+#endif
+extern struct page* mem_map;
+#endif
+
 static inline struct page *__section_mem_map_addr(struct mem_section *section)
 {
 	unsigned long map = section->section_mem_map;
diff -puN mm/Kconfig~virtual-memmap-on-sparsemem-v3-generic-virtual mm/Kconfig
--- a/mm/Kconfig~virtual-memmap-on-sparsemem-v3-generic-virtual
+++ a/mm/Kconfig
@@ -112,12 +112,22 @@ config SPARSEMEM_EXTREME
 	def_bool y
 	depends on SPARSEMEM && !SPARSEMEM_STATIC
 
+config SPARSEMEM_VMEMMAP
+	bool	"Virutally contiguous mem_map on sparsemem"
+	depends on SPARSEMEM && !SPARSEMEM_STATIC && ARCH_SPARSEMEM_VMEMMAP
+	help
+	  This allows micro optimization to reduce costs of accessing
+	  infrastructure of memory management.
+	  But this consumes huge amount of virtual memory(not physical).
+	  This option is selectable only if your arch supports it.
+
 # eventually, we can have this option just 'select SPARSEMEM'
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
 	depends on HOTPLUG && !SOFTWARE_SUSPEND && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC64)
+	depends on !SPARSEMEM_VMEMMAP
 
 comment "Memory hotplug is currently incompatible with Software Suspend"
 	depends on SPARSEMEM && HOTPLUG && SOFTWARE_SUSPEND
diff -puN mm/memory.c~virtual-memmap-on-sparsemem-v3-generic-virtual mm/memory.c
--- a/mm/memory.c~virtual-memmap-on-sparsemem-v3-generic-virtual
+++ a/mm/memory.c
@@ -69,6 +69,12 @@ EXPORT_SYMBOL(max_mapnr);
 EXPORT_SYMBOL(mem_map);
 #endif
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+/* for the virtual mem_map */
+struct page *mem_map;
+EXPORT_SYMBOL(mem_map);
+#endif
+
 unsigned long num_physpages;
 /*
  * A number of key systems in x86 including ioremap() rely on the assumption
diff -puN mm/sparse.c~virtual-memmap-on-sparsemem-v3-generic-virtual mm/sparse.c
--- a/mm/sparse.c~virtual-memmap-on-sparsemem-v3-generic-virtual
+++ a/mm/sparse.c
@@ -9,6 +9,8 @@
 #include <linux/spinlock.h>
 #include <linux/vmalloc.h>
 #include <asm/dma.h>
+#include <asm/pgtable.h>
+#include <asm/pgalloc.h>
 
 /*
  * Permanent SPARSEMEM data:
@@ -99,6 +101,106 @@ static inline int sparse_index_init(unsi
 }
 #endif
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+
+struct vmemmap_create_arg {
+	int section_nr;
+	int nid;
+};
+
+/* call backs for memory map */
+static int
+__init pte_alloc_vmemmap_boot(pmd_t *pmd, unsigned long addr, void *data)
+{
+	struct vmemmap_create_arg *arg = data;
+	void *pg = alloc_bootmem_pages_node(NODE_DATA(arg->nid), PAGE_SIZE);
+	BUG_ON(!pg);
+	pmd_populate_kernel(&init_mm, pmd, pg);
+	return 0;
+}
+static int
+__init pmd_alloc_vmemmap_boot(pud_t *pud, unsigned long addr, void *data)
+{
+	struct vmemmap_create_arg *arg = data;
+	void *pg = alloc_bootmem_pages_node(NODE_DATA(arg->nid), PAGE_SIZE);
+	BUG_ON(!pg);
+	pud_populate(&init_mm, pud, pg);
+	return 0;
+}
+
+static int
+__init pud_alloc_vmemmap_boot(pgd_t *pgd, unsigned long addr, void *data)
+{
+	struct vmemmap_create_arg *arg = data;
+	void *pg = alloc_bootmem_pages_node(NODE_DATA(arg->nid), PAGE_SIZE);
+	BUG_ON(!pg);
+	pgd_populate(&init_mm, pgd, pg);
+	return 0;
+}
+
+static int
+__init pte_set_vmemmap_boot(pte_t *pte, unsigned long addr, void *data)
+{
+	struct vmemmap_create_arg *arg = data;
+	struct mem_section *ms = __nr_to_section(arg->section_nr);
+	unsigned long pmap, vmap, section_pfn, pfn;
+
+	section_pfn = section_nr_to_pfn(arg->section_nr);
+	/* we already have mem_map in linear address space. calc it */
+
+	/* decode encoded value of base address. */
+	pmap = ms->section_mem_map & SECTION_MAP_MASK;
+	pmap = (unsigned long)((struct page *)pmap + section_pfn);
+	/* section's start */
+	vmap = (unsigned long)pfn_to_page(section_pfn);
+
+	pfn = (__pa(pmap) + (addr - vmap)) >> PAGE_SHIFT;
+	set_pte(pte, pfn_pte(pfn, PAGE_KERNEL));
+	return 0;
+}
+
+static int
+__init pte_clear_vmemmap(pte_t *pte, unsigned long addr, void *data)
+{
+	BUG();
+}
+
+struct gen_map_kern_ops vmemmap_boot_ops = {
+	.k_pte_set	= pte_set_vmemmap_boot,
+	.k_pte_clear	= pte_clear_vmemmap,
+	.k_pud_alloc	= pud_alloc_vmemmap_boot,
+	.k_pmd_alloc	= pmd_alloc_vmemmap_boot,
+	.k_pte_alloc	= pte_alloc_vmemmap_boot,
+};
+
+static int
+__init map_virtual_mem_map(unsigned long section, int nid)
+{
+	struct vmemmap_create_arg arg;
+	unsigned long vmap_start, vmap_size;
+	vmap_start = (unsigned long)pfn_to_page(section_nr_to_pfn(section));
+	vmap_size = PAGES_PER_SECTION * sizeof(struct page);
+	arg.section_nr = section;
+	arg.nid = nid;
+
+	if (system_state == SYSTEM_BOOTING) {
+		map_generic_kernel(vmap_start, vmap_size, &vmemmap_boot_ops,
+				   &arg);
+	} else {
+		BUG();
+	}
+	/* if bug, panic occurs.*/
+	return 0;
+}
+#else
+static int
+__init map_virtual_mem_map(unsigned long section, int nid)
+{
+	return 0;
+}
+#endif
+
+
 /*
  * Although written for the SPARSEMEM_EXTREME case, this happens
  * to also work for the flat array case becase
@@ -115,7 +217,7 @@ int __section_nr(struct mem_section* ms)
 			continue;
 
 		if ((ms >= root) && (ms < (root + SECTIONS_PER_ROOT)))
-		     break;
+			break;
 	}
 
 	return (root_nr * SECTIONS_PER_ROOT) + (ms - root);
@@ -198,13 +300,14 @@ struct page *sparse_decode_mem_map(unsig
 }
 
 static int sparse_init_one_section(struct mem_section *ms,
-		unsigned long pnum, struct page *mem_map)
+		unsigned long pnum, struct page *mem_map, int node)
 {
 	if (!valid_section(ms))
 		return -EINVAL;
 
 	ms->section_mem_map &= ~SECTION_MAP_MASK;
 	ms->section_mem_map |= sparse_encode_mem_map(mem_map, pnum);
+	map_virtual_mem_map(pnum, node);
 
 	return 1;
 }
@@ -284,7 +387,8 @@ void sparse_init(void)
 		map = sparse_early_mem_map_alloc(pnum);
 		if (!map)
 			continue;
-		sparse_init_one_section(__nr_to_section(pnum), pnum, map);
+		sparse_init_one_section(__nr_to_section(pnum), pnum, map,
+				sparse_early_nid(__nr_to_section(pnum)));
 	}
 }
 
@@ -319,7 +423,7 @@ int sparse_add_one_section(struct zone *
 	}
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 
-	ret = sparse_init_one_section(ms, section_nr, memmap);
+	ret = sparse_init_one_section(ms, section_nr, memmap, pgdat->node_id);
 
 out:
 	pgdat_resize_unlock(pgdat, &flags);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
virtual-memmap-on-sparsemem-v3-map-and-unmap.patch
virtual-memmap-on-sparsemem-v3-generic-virtual.patch
virtual-memmap-on-sparsemem-v3-static-virtual.patch
virtual-memmap-on-sparsemem-v3-ia64-support.patch
sched-avoid-taking-rq-lock-in-wake_priority_sleeper.patch
sched-remove-staggering-of-load-balancing.patch
sched-disable-interrupts-for-locking-in-load_balance.patch
sched-extract-load-calculation-from-rebalance_tick.patch
sched-move-idle-status-calculation-into-rebalance_tick.patch
sched-use-softirq-for-load-balancing.patch
sched-call-tasklet-less-frequently.patch
sched-add-option-to-serialize-load-balancing.patch
sched-add-option-to-serialize-load-balancing-fix.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch

