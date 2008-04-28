From: akpm@linux-foundation.org
Subject: - vmallocinfo-add-caller-information.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:52:06 -0700
Message-ID: <200804282152.m3SLq6fN017727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33616 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965055AbYD1VwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     vmallocinfo: add caller information
has been removed from the -mm tree.  Its filename was
     vmallocinfo-add-caller-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmallocinfo: add caller information
From: Christoph Lameter <clameter@sgi.com>

Add caller information so that /proc/vmallocinfo shows where the allocation
request for a slice of vmalloc memory originated.

Results in output like this:

0xffffc20000000000-0xffffc20000801000 8392704 alloc_large_system_hash+0x127/0x246 pages=2048 vmalloc vpages
0xffffc20000801000-0xffffc20000806000   20480 alloc_large_system_hash+0x127/0x246 pages=4 vmalloc
0xffffc20000806000-0xffffc20000c07000 4198400 alloc_large_system_hash+0x127/0x246 pages=1024 vmalloc vpages
0xffffc20000c07000-0xffffc20000c0a000   12288 alloc_large_system_hash+0x127/0x246 pages=2 vmalloc
0xffffc20000c0a000-0xffffc20000c0c000    8192 acpi_os_map_memory+0x13/0x1c phys=cff68000 ioremap
0xffffc20000c0c000-0xffffc20000c0f000   12288 acpi_os_map_memory+0x13/0x1c phys=cff64000 ioremap
0xffffc20000c10000-0xffffc20000c15000   20480 acpi_os_map_memory+0x13/0x1c phys=cff65000 ioremap
0xffffc20000c16000-0xffffc20000c18000    8192 acpi_os_map_memory+0x13/0x1c phys=cff69000 ioremap
0xffffc20000c18000-0xffffc20000c1a000    8192 acpi_os_map_memory+0x13/0x1c phys=fed1f000 ioremap
0xffffc20000c1a000-0xffffc20000c1c000    8192 acpi_os_map_memory+0x13/0x1c phys=cff68000 ioremap
0xffffc20000c1c000-0xffffc20000c1e000    8192 acpi_os_map_memory+0x13/0x1c phys=cff68000 ioremap
0xffffc20000c1e000-0xffffc20000c20000    8192 acpi_os_map_memory+0x13/0x1c phys=cff68000 ioremap
0xffffc20000c20000-0xffffc20000c22000    8192 acpi_os_map_memory+0x13/0x1c phys=cff68000 ioremap
0xffffc20000c22000-0xffffc20000c24000    8192 acpi_os_map_memory+0x13/0x1c phys=cff68000 ioremap
0xffffc20000c24000-0xffffc20000c26000    8192 acpi_os_map_memory+0x13/0x1c phys=e0081000 ioremap
0xffffc20000c26000-0xffffc20000c28000    8192 acpi_os_map_memory+0x13/0x1c phys=e0080000 ioremap
0xffffc20000c28000-0xffffc20000c2d000   20480 alloc_large_system_hash+0x127/0x246 pages=4 vmalloc
0xffffc20000c2d000-0xffffc20000c31000   16384 tcp_init+0xd5/0x31c pages=3 vmalloc
0xffffc20000c31000-0xffffc20000c34000   12288 alloc_large_system_hash+0x127/0x246 pages=2 vmalloc
0xffffc20000c34000-0xffffc20000c36000    8192 init_vdso_vars+0xde/0x1f1
0xffffc20000c36000-0xffffc20000c38000    8192 pci_iomap+0x8a/0xb4 phys=d8e00000 ioremap
0xffffc20000c38000-0xffffc20000c3a000    8192 usb_hcd_pci_probe+0x139/0x295 [usbcore] phys=d8e00000 ioremap
0xffffc20000c3a000-0xffffc20000c3e000   16384 sys_swapon+0x509/0xa15 pages=3 vmalloc
0xffffc20000c40000-0xffffc20000c61000  135168 e1000_probe+0x1c4/0xa32 phys=d8a20000 ioremap
0xffffc20000c61000-0xffffc20000c6a000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc20000c6a000-0xffffc20000c73000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc20000c73000-0xffffc20000c7c000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc20000c7c000-0xffffc20000c7f000   12288 e1000e_setup_tx_resources+0x29/0xbe pages=2 vmalloc
0xffffc20000c80000-0xffffc20001481000 8392704 pci_mmcfg_arch_init+0x90/0x118 phys=e0000000 ioremap
0xffffc20001481000-0xffffc20001682000 2101248 alloc_large_system_hash+0x127/0x246 pages=512 vmalloc
0xffffc20001682000-0xffffc20001e83000 8392704 alloc_large_system_hash+0x127/0x246 pages=2048 vmalloc vpages
0xffffc20001e83000-0xffffc20002204000 3674112 alloc_large_system_hash+0x127/0x246 pages=896 vmalloc vpages
0xffffc20002204000-0xffffc2000220d000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc2000220d000-0xffffc20002216000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc20002216000-0xffffc2000221f000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc2000221f000-0xffffc20002228000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc20002228000-0xffffc20002231000   36864 _xfs_buf_map_pages+0x8e/0xc0 vmap
0xffffc20002231000-0xffffc20002234000   12288 e1000e_setup_rx_resources+0x35/0x122 pages=2 vmalloc
0xffffc20002240000-0xffffc20002261000  135168 e1000_probe+0x1c4/0xa32 phys=d8a60000 ioremap
0xffffc20002261000-0xffffc2000270c000 4894720 sys_swapon+0x509/0xa15 pages=1194 vmalloc vpages
0xffffffffa0000000-0xffffffffa0022000  139264 module_alloc+0x4f/0x55 pages=33 vmalloc
0xffffffffa0022000-0xffffffffa0029000   28672 module_alloc+0x4f/0x55 pages=6 vmalloc
0xffffffffa002b000-0xffffffffa0034000   36864 module_alloc+0x4f/0x55 pages=8 vmalloc
0xffffffffa0034000-0xffffffffa003d000   36864 module_alloc+0x4f/0x55 pages=8 vmalloc
0xffffffffa003d000-0xffffffffa0049000   49152 module_alloc+0x4f/0x55 pages=11 vmalloc
0xffffffffa0049000-0xffffffffa0050000   28672 module_alloc+0x4f/0x55 pages=6 vmalloc

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/ioremap.c   |   15 +++++---
 include/linux/vmalloc.h |    3 +
 mm/vmalloc.c            |   65 +++++++++++++++++++++++++++-----------
 3 files changed, 59 insertions(+), 24 deletions(-)

diff -puN arch/x86/mm/ioremap.c~vmallocinfo-add-caller-information arch/x86/mm/ioremap.c
--- a/arch/x86/mm/ioremap.c~vmallocinfo-add-caller-information
+++ a/arch/x86/mm/ioremap.c
@@ -117,8 +117,8 @@ int ioremap_change_attr(unsigned long va
  * have to convert them into an offset in a page-aligned mapping, but the
  * caller shouldn't need to know that small detail.
  */
-static void __iomem *__ioremap(resource_size_t phys_addr, unsigned long size,
-			       unsigned long prot_val)
+static void __iomem *__ioremap_caller(resource_size_t phys_addr,
+		unsigned long size, unsigned long prot_val, void *caller)
 {
 	unsigned long pfn, offset, vaddr;
 	resource_size_t last_addr;
@@ -212,7 +212,7 @@ static void __iomem *__ioremap(resource_
 	/*
 	 * Ok, go for it..
 	 */
-	area = get_vm_area(size, VM_IOREMAP);
+	area = get_vm_area_caller(size, VM_IOREMAP, caller);
 	if (!area)
 		return NULL;
 	area->phys_addr = phys_addr;
@@ -255,7 +255,8 @@ static void __iomem *__ioremap(resource_
  */
 void __iomem *ioremap_nocache(resource_size_t phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_CACHE_UC);
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_UC,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_nocache);
 
@@ -272,7 +273,8 @@ EXPORT_SYMBOL(ioremap_nocache);
 void __iomem *ioremap_wc(unsigned long phys_addr, unsigned long size)
 {
 	if (pat_wc_enabled)
-		return __ioremap(phys_addr, size, _PAGE_CACHE_WC);
+		return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WC,
+					__builtin_return_address(0));
 	else
 		return ioremap_nocache(phys_addr, size);
 }
@@ -280,7 +282,8 @@ EXPORT_SYMBOL(ioremap_wc);
 
 void __iomem *ioremap_cache(resource_size_t phys_addr, unsigned long size)
 {
-	return __ioremap(phys_addr, size, _PAGE_CACHE_WB);
+	return __ioremap_caller(phys_addr, size, _PAGE_CACHE_WB,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(ioremap_cache);
 
diff -puN include/linux/vmalloc.h~vmallocinfo-add-caller-information include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~vmallocinfo-add-caller-information
+++ a/include/linux/vmalloc.h
@@ -31,6 +31,7 @@ struct vm_struct {
 	struct page		**pages;
 	unsigned int		nr_pages;
 	unsigned long		phys_addr;
+	void			*caller;
 };
 
 /*
@@ -66,6 +67,8 @@ static inline size_t get_vm_area_size(co
 }
 
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
+extern struct vm_struct *get_vm_area_caller(unsigned long size,
+					unsigned long flags, void *caller);
 extern struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 					unsigned long start, unsigned long end);
 extern struct vm_struct *get_vm_area_node(unsigned long size,
diff -puN mm/vmalloc.c~vmallocinfo-add-caller-information mm/vmalloc.c
--- a/mm/vmalloc.c~vmallocinfo-add-caller-information
+++ a/mm/vmalloc.c
@@ -16,6 +16,7 @@
 #include <linux/interrupt.h>
 #include <linux/seq_file.h>
 #include <linux/vmalloc.h>
+#include <linux/kallsyms.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
@@ -25,7 +26,7 @@ DEFINE_RWLOCK(vmlist_lock);
 struct vm_struct *vmlist;
 
 static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
-			    int node);
+			    int node, void *caller);
 
 static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end)
 {
@@ -204,9 +205,9 @@ unsigned long vmalloc_to_pfn(const void 
 }
 EXPORT_SYMBOL(vmalloc_to_pfn);
 
-static struct vm_struct *__get_vm_area_node(unsigned long size, unsigned long flags,
-					    unsigned long start, unsigned long end,
-					    int node, gfp_t gfp_mask)
+static struct vm_struct *
+__get_vm_area_node(unsigned long size, unsigned long flags, unsigned long start,
+		unsigned long end, int node, gfp_t gfp_mask, void *caller)
 {
 	struct vm_struct **p, *tmp, *area;
 	unsigned long align = 1;
@@ -269,6 +270,7 @@ found:
 	area->pages = NULL;
 	area->nr_pages = 0;
 	area->phys_addr = 0;
+	area->caller = caller;
 	write_unlock(&vmlist_lock);
 
 	return area;
@@ -284,7 +286,8 @@ out:
 struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 				unsigned long start, unsigned long end)
 {
-	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL);
+	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+						__builtin_return_address(0));
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
 
@@ -299,14 +302,22 @@ EXPORT_SYMBOL_GPL(__get_vm_area);
  */
 struct vm_struct *get_vm_area(unsigned long size, unsigned long flags)
 {
-	return __get_vm_area(size, flags, VMALLOC_START, VMALLOC_END);
+	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+				-1, GFP_KERNEL, __builtin_return_address(0));
+}
+
+struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
+				void *caller)
+{
+	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END,
+						-1, GFP_KERNEL, caller);
 }
 
 struct vm_struct *get_vm_area_node(unsigned long size, unsigned long flags,
 				   int node, gfp_t gfp_mask)
 {
 	return __get_vm_area_node(size, flags, VMALLOC_START, VMALLOC_END, node,
-				  gfp_mask);
+				  gfp_mask, __builtin_return_address(0));
 }
 
 /* Caller must hold vmlist_lock */
@@ -455,9 +466,11 @@ void *vmap(struct page **pages, unsigned
 	if (count > num_physpages)
 		return NULL;
 
-	area = get_vm_area((count << PAGE_SHIFT), flags);
+	area = get_vm_area_caller((count << PAGE_SHIFT), flags,
+					__builtin_return_address(0));
 	if (!area)
 		return NULL;
+
 	if (map_vm_area(area, prot, &pages)) {
 		vunmap(area->addr);
 		return NULL;
@@ -468,7 +481,7 @@ void *vmap(struct page **pages, unsigned
 EXPORT_SYMBOL(vmap);
 
 static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
-				 pgprot_t prot, int node)
+				 pgprot_t prot, int node, void *caller)
 {
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
@@ -480,7 +493,7 @@ static void *__vmalloc_area_node(struct 
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
 		pages = __vmalloc_node(array_size, gfp_mask | __GFP_ZERO,
-					PAGE_KERNEL, node);
+				PAGE_KERNEL, node, caller);
 		area->flags |= VM_VPAGES;
 	} else {
 		pages = kmalloc_node(array_size,
@@ -488,6 +501,7 @@ static void *__vmalloc_area_node(struct 
 				node);
 	}
 	area->pages = pages;
+	area->caller = caller;
 	if (!area->pages) {
 		remove_vm_area(area->addr);
 		kfree(area);
@@ -521,7 +535,8 @@ fail:
 
 void *__vmalloc_area(struct vm_struct *area, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_area_node(area, gfp_mask, prot, -1);
+	return __vmalloc_area_node(area, gfp_mask, prot, -1,
+					__builtin_return_address(0));
 }
 
 /**
@@ -536,7 +551,7 @@ void *__vmalloc_area(struct vm_struct *a
  *	kernel virtual space, using a pagetable protection of @prot.
  */
 static void *__vmalloc_node(unsigned long size, gfp_t gfp_mask, pgprot_t prot,
-			    int node)
+						int node, void *caller)
 {
 	struct vm_struct *area;
 
@@ -544,16 +559,19 @@ static void *__vmalloc_node(unsigned lon
 	if (!size || (size >> PAGE_SHIFT) > num_physpages)
 		return NULL;
 
-	area = get_vm_area_node(size, VM_ALLOC, node, gfp_mask);
+	area = __get_vm_area_node(size, VM_ALLOC, VMALLOC_START, VMALLOC_END,
+						node, gfp_mask, caller);
+
 	if (!area)
 		return NULL;
 
-	return __vmalloc_area_node(area, gfp_mask, prot, node);
+	return __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 }
 
 void *__vmalloc(unsigned long size, gfp_t gfp_mask, pgprot_t prot)
 {
-	return __vmalloc_node(size, gfp_mask, prot, -1);
+	return __vmalloc_node(size, gfp_mask, prot, -1,
+				__builtin_return_address(0));
 }
 EXPORT_SYMBOL(__vmalloc);
 
@@ -568,7 +586,8 @@ EXPORT_SYMBOL(__vmalloc);
  */
 void *vmalloc(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL);
+	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+					-1, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc);
 
@@ -608,7 +627,8 @@ EXPORT_SYMBOL(vmalloc_user);
  */
 void *vmalloc_node(unsigned long size, int node)
 {
-	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL, node);
+	return __vmalloc_node(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL,
+					node, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(vmalloc_node);
 
@@ -843,7 +863,8 @@ struct vm_struct *alloc_vm_area(size_t s
 {
 	struct vm_struct *area;
 
-	area = get_vm_area(size, VM_IOREMAP);
+	area = get_vm_area_caller(size, VM_IOREMAP,
+				__builtin_return_address(0));
 	if (area == NULL)
 		return NULL;
 
@@ -914,6 +935,14 @@ static int s_show(struct seq_file *m, vo
 	seq_printf(m, "0x%p-0x%p %7ld",
 		v->addr, v->addr + v->size, v->size);
 
+	if (v->caller) {
+		char buff[2 * KSYM_NAME_LEN];
+
+		seq_putc(m, ' ');
+		sprint_symbol(buff, (unsigned long)v->caller);
+		seq_puts(m, buff);
+	}
+
 	if (v->nr_pages)
 		seq_printf(m, " pages=%d", v->nr_pages);
 
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-pekka.patch
page-allcoator-smarter-retry-of-costly-order-allocations.patch
page-allocator-explicitly-retry-hugepage-allocations.patch
ipc-add-definitions-of-ushort_max-and-others.patch
mm-add-nr_writeback_temp-counter.patch
remove-div_long_long_rem.patch
slab-add-a-flag-to-prevent-debug_free-checks-on-a-kmem_cache.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
x86-use-kbuildh.patch
mips-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
alpha-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
ia64-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
arm-use-kbuildh-instead-of-macros-in-asm-offsetsc.patch
xtensa-use-kbuildh-macros-instead-of-defining-them-in-asm-offsetsc.patch
sparc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch
blackfin-use-kbuildh-instead-of-defining-macros-in-asm-macrosc.patch
frv-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
h8300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
m68k-m68kmmu-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
mn10300-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
parisc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
ppc-powerpc-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
s390-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc-update.patch
sh-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
v850-use-kbuildh-instead-of-defining-macros-in-asm-offsetsc.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

