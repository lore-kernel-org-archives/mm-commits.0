From: akpm@osdl.org
Subject: + virtual-memmap-on-sparsemem-v3-map-and-unmap.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:30:38 -0800
Message-ID: <200612090030.kB90UcYL011048@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57316 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760168AbWLIAec (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:34:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com


The patch titled
     virtual memmap on sparsemem: map and unmap
has been added to the -mm tree.  Its filename is
     virtual-memmap-on-sparsemem-v3-map-and-unmap.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: virtual memmap on sparsemem: map and unmap
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

When using SPARSEMEM, pfn_to_page()/page_to_pfn() accesses global big table of
mem_section.  if SPARSEMEM_EXTREME, this is 2-level table lookup.

If we can map mem_section->mem_map in (virtually) linear address, we can
expect optimzed pfn <-> page translation.

Virtual mem_map is not useful for 32bit archs.  This uses huge virtual address
range.


This patch:

When we want to map pages into the kernel space by vmalloc()'s routine, we
always need 'struct page' to do that.

There are cases where there is no page struct to use (bootstrap, etc..).  This
function is designed to help map any memory to anywhere, anytime.

Users should manage their virtual/physical space by themselves.  Because it's
complex and danger to manage virtual address space by each function's own
code, it's better to use fixed address.

Note: My first purpose is supporting virtual mem_map both at boot/hotplug
      sharing the same logic.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/vmalloc.h |   36 ++++++
 mm/vmalloc.c            |  200 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 236 insertions(+)

diff -puN include/linux/vmalloc.h~virtual-memmap-on-sparsemem-v3-map-and-unmap include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~virtual-memmap-on-sparsemem-v3-map-and-unmap
+++ a/include/linux/vmalloc.h
@@ -3,6 +3,7 @@
 
 #include <linux/spinlock.h>
 #include <asm/page.h>		/* pgprot_t */
+#include <asm/pgtable.h>	/* pud_t */
 
 struct vm_area_struct;
 
@@ -74,4 +75,39 @@ extern void unmap_vm_area(struct vm_stru
 extern rwlock_t vmlist_lock;
 extern struct vm_struct *vmlist;
 
+/*
+ * map kernel memory with callback routine. this function is designed
+ * for assisting special mappings in the kernel space, in other words,
+ * not managed by standard vmap calls.
+ * The caller has to be responsible to manage his own virtual address space.
+ *
+ * Bootstrap consideration:
+ * you can pass pud/pmd/pte alloc functions to map_generic_kernel().
+ * So you can use bootmem function or something to alloc page tables if
+ * necessary.
+ */
+
+struct gen_map_kern_ops {
+	/* must be defined */
+	int	(*k_pte_set)(pte_t *pte, unsigned long addr, void *data);
+	int	(*k_pte_clear)(pte_t *pte, unsigned long addr, void *data);
+	/* optional */
+	int 	(*k_pud_alloc)(pgd_t *pgd, unsigned long addr, void *data);
+	int 	(*k_pmd_alloc)(pud_t *pud, unsigned long addr, void *data);
+	int 	(*k_pte_alloc)(pmd_t *pmd, unsigned long addr, void *data);
+};
+
+/*
+ * call set_pte for specified address range.
+ */
+extern int map_generic_kernel(unsigned long addr, unsigned long size,
+			      struct gen_map_kern_ops *ops, void *data);
+/*
+ * call clear_pte() callback against all ptes found.
+ * pgtable itself is not freed.
+ */
+extern int unmap_generic_kernel(unsigned long addr, unsigned long size,
+				struct gen_map_kern_ops *ops, void *data);
+
+
 #endif /* _LINUX_VMALLOC_H */
diff -puN mm/vmalloc.c~virtual-memmap-on-sparsemem-v3-map-and-unmap mm/vmalloc.c
--- a/mm/vmalloc.c~virtual-memmap-on-sparsemem-v3-map-and-unmap
+++ a/mm/vmalloc.c
@@ -747,3 +747,203 @@ out_einval_locked:
 }
 EXPORT_SYMBOL(remap_vmalloc_range);
 
+
+
+/*
+ * Generic VM mapper for kernel routines.
+ * Can be used even in bootstrap (before memory is availabe) if callback
+ * func support it.
+ * for usual use, please use vmalloc/vfree/map_vm_ara/unmap_vm_area.
+ */
+
+static int map_generic_pte_range(pmd_t *pmd, unsigned long addr,
+				 unsigned long end,
+				 struct gen_map_kern_ops *ops, void *data)
+{
+	pte_t *pte;
+	int ret = 0;
+	unsigned long next;
+	if (!pmd_present(*pmd)) {
+		if (ops->k_pte_alloc) {
+			ret = ops->k_pte_alloc(pmd, addr, data);
+			if (ret)
+				return ret;
+		} else {
+			pte = pte_alloc_kernel(pmd, addr);
+			if (!pte)
+				return -ENOMEM;
+		}
+	}
+	pte = pte_offset_kernel(pmd, addr);
+
+	do {
+		WARN_ON(!pte_none(*pte));
+		BUG_ON(!ops->k_pte_set);
+		ret = ops->k_pte_set(pte, addr, data);
+		if (ret)
+			break;
+		next = addr + PAGE_SIZE;
+	} while (pte++, addr = next, addr != end);
+	return ret;
+}
+
+static int map_generic_pmd_range(pud_t *pud, unsigned long addr,
+				 unsigned long end,
+				 struct gen_map_kern_ops *ops, void *data)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int ret;
+
+	if (pud_none(*pud)) {
+		if (ops->k_pmd_alloc) {
+			ret = ops->k_pmd_alloc(pud, addr, data);
+			if (ret)
+				return ret;
+		} else {
+			pmd = pmd_alloc(&init_mm, pud, addr);
+			if (!pmd)
+				return -ENOMEM;
+		}
+	}
+	pmd = pmd_offset(pud, addr);
+	do {
+		next = pmd_addr_end(addr, end);
+		ret = map_generic_pte_range(pmd, addr, next, ops, data);
+		if (ret)
+			break;
+	} while (pmd++, addr = next, addr != end);
+	return ret;
+}
+
+static int map_generic_pud_range(pgd_t *pgd, unsigned long addr,
+				 unsigned long end,
+				 struct gen_map_kern_ops *ops, void *data)
+{
+	pud_t *pud;
+	unsigned long next;
+	int ret;
+	if (pgd_none(*pgd)) {
+		if (ops->k_pud_alloc) {
+			ret = ops->k_pud_alloc(pgd, addr, data);
+			if (ret)
+				return ret;
+		} else {
+			pud = pud_alloc(&init_mm, pgd, addr);
+			if (!pud)
+				return -ENOMEM;
+		}
+	}
+	pud = pud_offset(pgd, addr);
+	do {
+		next = pud_addr_end(addr, end);
+		ret = map_generic_pmd_range(pud, addr, next, ops, data);
+		if (ret)
+			break;
+
+	} while (pud++, addr = next, addr != end);
+	return ret;
+}
+
+int map_generic_kernel(unsigned long addr, unsigned long size,
+		       struct gen_map_kern_ops *ops, void *data)
+{
+	pgd_t *pgd;
+	unsigned long end = addr + size;
+	unsigned long next;
+	int ret;
+
+	do {
+		pgd = pgd_offset_k(addr);
+		next = pgd_addr_end(addr, end);
+		ret = map_generic_pud_range(pgd, addr, next, ops, data);
+		if (ret)
+			break;
+
+	} while (addr = next, addr != end);
+	flush_cache_vmap(addr, end);
+	return ret;
+}
+
+static int
+unmap_generic_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
+			struct gen_map_kern_ops *ops, void *data)
+{
+	pte_t *pte;
+	int err = 0;
+	pte = pte_offset_kernel(pmd, addr);
+	do {
+		if (!pte_present(*pte))
+			continue;
+		err = ops->k_pte_clear(pte, addr, data);
+		if (err)
+			break;
+	} while (pte++, addr += PAGE_SIZE, addr != end);
+	return err;
+}
+
+static int
+unmap_generic_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
+			struct gen_map_kern_ops *ops, void *data)
+{
+	pmd_t *pmd;
+	unsigned long next;
+	int err = 0;
+
+	pmd = pmd_offset(pud, addr);
+
+	do {
+		next = pmd_addr_end(addr, end);
+		if (pmd_none_or_clear_bad(pmd))
+			continue;
+		err = unmap_generic_pte_range(pmd, addr, next, ops, data);
+		if (err)
+			break;
+	} while (pmd++, addr = next, addr != end);
+	return err;
+}
+
+static int
+unmap_generic_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end,
+			struct gen_map_kern_ops *ops, void *data)
+{
+	pud_t *pud;
+	unsigned long next;
+	int err = 0;
+
+	pud = pud_offset(pgd, addr);
+
+	do {
+		next = pud_addr_end(addr, end);
+		if (pud_none_or_clear_bad(pud))
+			continue;
+		err = unmap_generic_pmd_range(pud, addr, next, ops, data);
+		if (err)
+			break;
+	} while (pud++, addr = next, addr != end);
+	return err;
+}
+
+int unmap_generic_kernel(unsigned long addr, unsigned long size,
+			 struct gen_map_kern_ops *ops, void *data)
+{
+	unsigned long next, end;
+	pgd_t *pgd;
+	int err = 0;
+
+	end = addr + size;
+	flush_cache_vmap(addr, end);
+
+	pgd = pgd_offset_k(addr);
+
+	do {
+		next = pgd_addr_end(addr, end);
+		if (pgd_none_or_clear_bad(pgd))
+			continue;
+		err = unmap_generic_pud_range(pgd, addr, next, ops, data);
+		if (err)
+			break;
+	} while (pgd++, addr = next, addr != end);
+	flush_tlb_kernel_range((unsigned long)start_addr, end_addr);
+	return err;
+}
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

