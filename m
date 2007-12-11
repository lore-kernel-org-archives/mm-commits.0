From: akpm@linux-foundation.org
Subject: + x86-boot-use-e820-memory-map-on-efi-32-platform.patch added to -mm tree
Date: Tue, 11 Dec 2007 15:38:17 -0800
Message-ID: <200712112338.lBBNcHTQ014931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39038 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbXLKXjg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Dec 2007 18:39:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86 boot: use E820 memory map on EFI 32 platform
has been added to the -mm tree.  Its filename is
     x86-boot-use-e820-memory-map-on-efi-32-platform.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86 boot: use E820 memory map on EFI 32 platform
From: "Huang, Ying" <ying.huang@intel.com>

Because the EFI memory map are converted to e820 memory map in bootloader, the
EFI memory map handling code is removed to clean up.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820_32.c  |  117 ++-------------------------
 arch/x86/kernel/efi_32.c   |  150 -----------------------------------
 arch/x86/kernel/setup_32.c |   16 +--
 arch/x86/mm/init_32.c      |   18 ----
 include/asm-x86/e820_32.h  |    2 
 5 files changed, 16 insertions(+), 287 deletions(-)

diff -puN arch/x86/kernel/e820_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform arch/x86/kernel/e820_32.c
--- a/arch/x86/kernel/e820_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform
+++ a/arch/x86/kernel/e820_32.c
@@ -7,7 +7,6 @@
 #include <linux/kexec.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <linux/efi.h>
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
@@ -181,7 +180,7 @@ static void __init probe_roms(void)
  * Request address space for all standard RAM and ROM resources
  * and also for regions reported as reserved by the e820.
  */
-void __init legacy_init_iomem_resources(struct resource *code_resource,
+void __init init_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource,
 		struct resource *bss_resource)
 {
@@ -261,19 +260,17 @@ void __init add_memory_region(unsigned l
 {
 	int x;
 
-	if (!efi_enabled) {
-       		x = e820.nr_map;
+	x = e820.nr_map;
 
-		if (x == E820MAX) {
-		    printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
-		    return;
-		}
-
-		e820.map[x].addr = start;
-		e820.map[x].size = size;
-		e820.map[x].type = type;
-		e820.nr_map++;
+	if (x == E820MAX) {
+		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
+		return;
 	}
+
+	e820.map[x].addr = start;
+	e820.map[x].size = size;
+	e820.map[x].type = type;
+	e820.nr_map++;
 } /* add_memory_region */
 
 /*
@@ -489,29 +486,6 @@ int __init copy_e820_map(struct e820entr
 }
 
 /*
- * Callback for efi_memory_walk.
- */
-static int __init
-efi_find_max_pfn(unsigned long start, unsigned long end, void *arg)
-{
-	unsigned long *max_pfn = arg, pfn;
-
-	if (start < end) {
-		pfn = PFN_UP(end -1);
-		if (pfn > *max_pfn)
-			*max_pfn = pfn;
-	}
-	return 0;
-}
-
-static int __init
-efi_memory_present_wrapper(unsigned long start, unsigned long end, void *arg)
-{
-	memory_present(0, PFN_UP(start), PFN_DOWN(end));
-	return 0;
-}
-
-/*
  * Find the highest page frame number we have available
  */
 void __init find_max_pfn(void)
@@ -519,11 +493,6 @@ void __init find_max_pfn(void)
 	int i;
 
 	max_pfn = 0;
-	if (efi_enabled) {
-		efi_memmap_walk(efi_find_max_pfn, &max_pfn);
-		efi_memmap_walk(efi_memory_present_wrapper, NULL);
-		return;
-	}
 
 	for (i = 0; i < e820.nr_map; i++) {
 		unsigned long start, end;
@@ -541,34 +510,12 @@ void __init find_max_pfn(void)
 }
 
 /*
- * Free all available memory for boot time allocation.  Used
- * as a callback function by efi_memory_walk()
- */
-
-static int __init
-free_available_memory(unsigned long start, unsigned long end, void *arg)
-{
-	/* check max_low_pfn */
-	if (start >= (max_low_pfn << PAGE_SHIFT))
-		return 0;
-	if (end >= (max_low_pfn << PAGE_SHIFT))
-		end = max_low_pfn << PAGE_SHIFT;
-	if (start < end)
-		free_bootmem(start, end - start);
-
-	return 0;
-}
-/*
  * Register fully available low RAM pages with the bootmem allocator.
  */
 void __init register_bootmem_low_pages(unsigned long max_low_pfn)
 {
 	int i;
 
-	if (efi_enabled) {
-		efi_memmap_walk(free_available_memory, NULL);
-		return;
-	}
 	for (i = 0; i < e820.nr_map; i++) {
 		unsigned long curr_pfn, last_pfn, size;
 		/*
@@ -676,56 +623,12 @@ void __init print_memory_map(char *who)
 	}
 }
 
-static __init __always_inline void efi_limit_regions(unsigned long long size)
-{
-	unsigned long long current_addr = 0;
-	efi_memory_desc_t *md, *next_md;
-	void *p, *p1;
-	int i, j;
-
-	j = 0;
-	p1 = memmap.map;
-	for (p = p1, i = 0; p < memmap.map_end; p += memmap.desc_size, i++) {
-		md = p;
-		next_md = p1;
-		current_addr = md->phys_addr +
-			PFN_PHYS(md->num_pages);
-		if (is_available_memory(md)) {
-			if (md->phys_addr >= size) continue;
-			memcpy(next_md, md, memmap.desc_size);
-			if (current_addr >= size) {
-				next_md->num_pages -=
-					PFN_UP(current_addr-size);
-			}
-			p1 += memmap.desc_size;
-			next_md = p1;
-			j++;
-		} else if ((md->attribute & EFI_MEMORY_RUNTIME) ==
-			   EFI_MEMORY_RUNTIME) {
-			/* In order to make runtime services
-			 * available we have to include runtime
-			 * memory regions in memory map */
-			memcpy(next_md, md, memmap.desc_size);
-			p1 += memmap.desc_size;
-			next_md = p1;
-			j++;
-		}
-	}
-	memmap.nr_map = j;
-	memmap.map_end = memmap.map +
-		(memmap.nr_map * memmap.desc_size);
-}
-
 void __init limit_regions(unsigned long long size)
 {
 	unsigned long long current_addr;
 	int i;
 
 	print_memory_map("limit_regions start");
-	if (efi_enabled) {
-		efi_limit_regions(size);
-		return;
-	}
 	for (i = 0; i < e820.nr_map; i++) {
 		current_addr = e820.map[i].addr + e820.map[i].size;
 		if (current_addr < size)
diff -puN arch/x86/kernel/efi_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform arch/x86/kernel/efi_32.c
--- a/arch/x86/kernel/efi_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform
+++ a/arch/x86/kernel/efi_32.c
@@ -125,22 +125,6 @@ void efi_call_phys_epilog(void) __releas
 	spin_unlock(&efi_rt_lock);
 }
 
-int is_available_memory(efi_memory_desc_t * md)
-{
-	if (!(md->attribute & EFI_MEMORY_WB))
-		return 0;
-
-	switch (md->type) {
-		case EFI_LOADER_CODE:
-		case EFI_LOADER_DATA:
-		case EFI_BOOT_SERVICES_CODE:
-		case EFI_BOOT_SERVICES_DATA:
-		case EFI_CONVENTIONAL_MEMORY:
-			return 1;
-	}
-	return 0;
-}
-
 /*
  * We need to map the EFI memory map again after paging_init().
  */
@@ -155,137 +139,3 @@ void __init efi_map_memmap(void)
 
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 }
-
-/*
- * Walks the EFI memory map and calls CALLBACK once for each EFI
- * memory descriptor that has memory that is available for kernel use.
- */
-void efi_memmap_walk(efi_freemem_callback_t callback, void *arg)
-{
-	int prev_valid = 0;
-	struct range {
-		unsigned long start;
-		unsigned long end;
-	} uninitialized_var(prev), curr;
-	efi_memory_desc_t *md;
-	unsigned long start, end;
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-
-		if ((md->num_pages == 0) || (!is_available_memory(md)))
-			continue;
-
-		curr.start = md->phys_addr;
-		curr.end = curr.start + (md->num_pages << EFI_PAGE_SHIFT);
-
-		if (!prev_valid) {
-			prev = curr;
-			prev_valid = 1;
-		} else {
-			if (curr.start < prev.start)
-				printk(KERN_INFO PFX "Unordered memory map\n");
-			if (prev.end == curr.start)
-				prev.end = curr.end;
-			else {
-				start =
-				    (unsigned long) (PAGE_ALIGN(prev.start));
-				end = (unsigned long) (prev.end & PAGE_MASK);
-				if ((end > start)
-				    && (*callback) (start, end, arg) < 0)
-					return;
-				prev = curr;
-			}
-		}
-	}
-	if (prev_valid) {
-		start = (unsigned long) PAGE_ALIGN(prev.start);
-		end = (unsigned long) (prev.end & PAGE_MASK);
-		if (end > start)
-			(*callback) (start, end, arg);
-	}
-}
-
-void __init
-efi_initialize_iomem_resources(struct resource *code_resource,
-			       struct resource *data_resource,
-			       struct resource *bss_resource)
-{
-	struct resource *res;
-	efi_memory_desc_t *md;
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-
-		if ((md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT)) >
-		    0x100000000ULL)
-			continue;
-		res = kzalloc(sizeof(struct resource), GFP_ATOMIC);
-		switch (md->type) {
-		case EFI_RESERVED_TYPE:
-			res->name = "Reserved Memory";
-			break;
-		case EFI_LOADER_CODE:
-			res->name = "Loader Code";
-			break;
-		case EFI_LOADER_DATA:
-			res->name = "Loader Data";
-			break;
-		case EFI_BOOT_SERVICES_DATA:
-			res->name = "BootServices Data";
-			break;
-		case EFI_BOOT_SERVICES_CODE:
-			res->name = "BootServices Code";
-			break;
-		case EFI_RUNTIME_SERVICES_CODE:
-			res->name = "Runtime Service Code";
-			break;
-		case EFI_RUNTIME_SERVICES_DATA:
-			res->name = "Runtime Service Data";
-			break;
-		case EFI_CONVENTIONAL_MEMORY:
-			res->name = "Conventional Memory";
-			break;
-		case EFI_UNUSABLE_MEMORY:
-			res->name = "Unusable Memory";
-			break;
-		case EFI_ACPI_RECLAIM_MEMORY:
-			res->name = "ACPI Reclaim";
-			break;
-		case EFI_ACPI_MEMORY_NVS:
-			res->name = "ACPI NVS";
-			break;
-		case EFI_MEMORY_MAPPED_IO:
-			res->name = "Memory Mapped IO";
-			break;
-		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
-			res->name = "Memory Mapped IO Port Space";
-			break;
-		default:
-			res->name = "Reserved";
-			break;
-		}
-		res->start = md->phys_addr;
-		res->end = res->start + ((md->num_pages << EFI_PAGE_SHIFT) - 1);
-		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		if (request_resource(&iomem_resource, res) < 0)
-			printk(KERN_ERR PFX "Failed to allocate res %s : "
-				"0x%llx-0x%llx\n", res->name,
-				(unsigned long long)res->start,
-				(unsigned long long)res->end);
-		/*
-		 * We don't know which region contains kernel data so we try
-		 * it repeatedly and let the resource manager test it.
-		 */
-		if (md->type == EFI_CONVENTIONAL_MEMORY) {
-			request_resource(res, code_resource);
-			request_resource(res, data_resource);
-			request_resource(res, bss_resource);
-#ifdef CONFIG_KEXEC
-			request_resource(res, &crashk_res);
-#endif
-		}
-	}
-}
diff -puN arch/x86/kernel/setup_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform
+++ a/arch/x86/kernel/setup_32.c
@@ -644,12 +644,12 @@ void __init setup_arch(char **cmdline_p)
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
 	ARCH_SETUP
+
+	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
+	print_memory_map(memory_setup());
+
 	if (efi_enabled)
 		efi_init();
-	else {
-		printk(KERN_INFO "BIOS-provided physical RAM map:\n");
-		print_memory_map(memory_setup());
-	}
 
 	copy_edd();
 
@@ -767,14 +767,8 @@ static int __init request_standard_resou
 	int i;
 
 	printk(KERN_INFO "Setting up standard PCI resources\n");
-	if (efi_enabled)
-		efi_initialize_iomem_resources(&code_resource,
-				&data_resource, &bss_resource);
-	else
-		legacy_init_iomem_resources(&code_resource,
-				&data_resource, &bss_resource);
+	init_iomem_resources(&code_resource, &data_resource, &bss_resource);
 
-	/* EFI systems may still have VGA */
 	request_resource(&iomem_resource, &video_ram_resource);
 
 	/* request I/O space for devices used on all i[345]86 PCs */
diff -puN arch/x86/mm/init_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~x86-boot-use-e820-memory-map-on-efi-32-platform
+++ a/arch/x86/mm/init_32.c
@@ -27,7 +27,6 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
-#include <linux/efi.h>
 #include <linux/memory_hotplug.h>
 #include <linux/initrd.h>
 #include <linux/cpumask.h>
@@ -216,23 +215,6 @@ int page_is_ram(unsigned long pagenr)
 	int i;
 	unsigned long addr, end;
 
-	if (efi_enabled) {
-		efi_memory_desc_t *md;
-		void *p;
-
-		for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-			md = p;
-			if (!is_available_memory(md))
-				continue;
-			addr = (md->phys_addr+PAGE_SIZE-1) >> PAGE_SHIFT;
-			end = (md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT)) >> PAGE_SHIFT;
-
-			if ((pagenr >= addr) && (pagenr < end))
-				return 1;
-		}
-		return 0;
-	}
-
 	for (i = 0; i < e820.nr_map; i++) {
 
 		if (e820.map[i].type != E820_RAM)	/* not usable memory */
diff -puN include/asm-x86/e820_32.h~x86-boot-use-e820-memory-map-on-efi-32-platform include/asm-x86/e820_32.h
--- a/include/asm-x86/e820_32.h~x86-boot-use-e820-memory-map-on-efi-32-platform
+++ a/include/asm-x86/e820_32.h
@@ -28,7 +28,7 @@ extern void register_bootmem_low_pages(u
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
-extern void legacy_init_iomem_resources(struct resource *code_resource,
+extern void init_iomem_resources(struct resource *code_resource,
 			    struct resource *data_resource,
 			    struct resource *bss_resource);
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
x86-boot-use-e820-memory-map-on-efi-32-platform.patch
x86-boot-export-boot_params-via-sysfs.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
