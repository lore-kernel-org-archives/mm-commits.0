From: akpm@linux-foundation.org
Subject: - remove-extern-declarations-for-code-data-bss-resource.patch removed from -mm tree
Date: Mon, 19 Nov 2007 15:16:17 -0800
Message-ID: <200711192316.lAJNGH52001760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbXKSXR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 18:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bwalle@suse.de, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Remove extern declarations for code/data/bss resource
has been removed from the -mm tree.  Its filename was
     remove-extern-declarations-for-code-data-bss-resource.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove extern declarations for code/data/bss resource
From: Bernhard Walle <bwalle@suse.de>

This patch removes the extern struct resource declarations for
data_resource, code_resource and bss_resource on x86 and declares that
three structures as static as done on other architectures like IA64.

On i386, these structures are moved to setup_32.c (from e820_32.c) because
that's code that is not specific to e820 and also required on EFI systems. 
That makes the "extern" reference superfluous.

On x86_64, data_resource, code_resource and bss_resource are passed to
e820_reserve_resources() as arguments just as done on i386 and IA64.  That
also avoids the "extern" reference and it's possible to make it static.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/e820_32.c  |  110 -----------------------------------
 arch/x86/kernel/e820_64.c  |   11 +--
 arch/x86/kernel/setup_32.c |  106 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/setup_64.c |    8 +-
 include/asm-x86/e820_32.h  |    6 +
 include/asm-x86/e820_64.h  |    5 +
 include/linux/ioport.h     |    2 
 7 files changed, 127 insertions(+), 121 deletions(-)

diff -puN arch/x86/kernel/e820_32.c~remove-extern-declarations-for-code-data-bss-resource arch/x86/kernel/e820_32.c
--- a/arch/x86/kernel/e820_32.c~remove-extern-declarations-for-code-data-bss-resource
+++ a/arch/x86/kernel/e820_32.c
@@ -37,26 +37,6 @@ unsigned long pci_mem_start = 0x10000000
 EXPORT_SYMBOL(pci_mem_start);
 #endif
 extern int user_defined_memmap;
-struct resource data_resource = {
-	.name	= "Kernel data",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-struct resource code_resource = {
-	.name	= "Kernel code",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-struct resource bss_resource = {
-	.name	= "Kernel bss",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
@@ -111,60 +91,6 @@ static struct resource video_rom_resourc
 	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
 };
 
-static struct resource video_ram_resource = {
-	.name	= "Video RAM area",
-	.start	= 0xa0000,
-	.end	= 0xbffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
-static struct resource standard_io_resources[] = { {
-	.name	= "dma1",
-	.start	= 0x0000,
-	.end	= 0x001f,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "pic1",
-	.start	= 0x0020,
-	.end	= 0x0021,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name   = "timer0",
-	.start	= 0x0040,
-	.end    = 0x0043,
-	.flags  = IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name   = "timer1",
-	.start  = 0x0050,
-	.end    = 0x0053,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "keyboard",
-	.start	= 0x0060,
-	.end	= 0x006f,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "dma page reg",
-	.start	= 0x0080,
-	.end	= 0x008f,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "pic2",
-	.start	= 0x00a0,
-	.end	= 0x00a1,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "dma2",
-	.start	= 0x00c0,
-	.end	= 0x00df,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-}, {
-	.name	= "fpu",
-	.start	= 0x00f0,
-	.end	= 0x00ff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
-} };
-
 #define ROMSIGNATURE 0xaa55
 
 static int __init romsignature(const unsigned char *rom)
@@ -260,10 +186,9 @@ static void __init probe_roms(void)
  * Request address space for all standard RAM and ROM resources
  * and also for regions reported as reserved by the e820.
  */
-static void __init
-legacy_init_iomem_resources(struct resource *code_resource,
-			    struct resource *data_resource,
-			    struct resource *bss_resource)
+void __init legacy_init_iomem_resources(struct resource *code_resource,
+		struct resource *data_resource,
+		struct resource *bss_resource)
 {
 	int i;
 
@@ -305,35 +230,6 @@ legacy_init_iomem_resources(struct resou
 	}
 }
 
-/*
- * Request address space for all standard resources
- *
- * This is called just before pcibios_init(), which is also a
- * subsys_initcall, but is linked in later (in arch/i386/pci/common.c).
- */
-static int __init request_standard_resources(void)
-{
-	int i;
-
-	printk("Setting up standard PCI resources\n");
-	if (efi_enabled)
-		efi_initialize_iomem_resources(&code_resource,
-				&data_resource, &bss_resource);
-	else
-		legacy_init_iomem_resources(&code_resource,
-				&data_resource, &bss_resource);
-
-	/* EFI systems may still have VGA */
-	request_resource(&iomem_resource, &video_ram_resource);
-
-	/* request I/O space for devices used on all i[345]86 PCs */
-	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
-		request_resource(&ioport_resource, &standard_io_resources[i]);
-	return 0;
-}
-
-subsys_initcall(request_standard_resources);
-
 #if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
 /**
  * e820_mark_nosave_regions - Find the ranges of physical addresses that do not
diff -puN arch/x86/kernel/e820_64.c~remove-extern-declarations-for-code-data-bss-resource arch/x86/kernel/e820_64.c
--- a/arch/x86/kernel/e820_64.c~remove-extern-declarations-for-code-data-bss-resource
+++ a/arch/x86/kernel/e820_64.c
@@ -47,8 +47,6 @@ unsigned long end_pfn_map;
  */
 static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 
-extern struct resource code_resource, data_resource, bss_resource;
-
 /* Check for some hardcoded bad areas that early boot is not allowed to touch */
 static inline int bad_addr(unsigned long *addrp, unsigned long size)
 {
@@ -213,7 +211,8 @@ unsigned long __init e820_end_of_ram(voi
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
-void __init e820_reserve_resources(void)
+void __init e820_reserve_resources(struct resource *code_resource,
+		struct resource *data_resource, struct resource *bss_resource)
 {
 	int i;
 	for (i = 0; i < e820.nr_map; i++) {
@@ -235,9 +234,9 @@ void __init e820_reserve_resources(void)
 			 * so we try it repeatedly and let the resource manager
 			 * test it.
 			 */
-			request_resource(res, &code_resource);
-			request_resource(res, &data_resource);
-			request_resource(res, &bss_resource);
+			request_resource(res, code_resource);
+			request_resource(res, data_resource);
+			request_resource(res, bss_resource);
 #ifdef CONFIG_KEXEC
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
diff -puN arch/x86/kernel/setup_32.c~remove-extern-declarations-for-code-data-bss-resource arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~remove-extern-declarations-for-code-data-bss-resource
+++ a/arch/x86/kernel/setup_32.c
@@ -73,9 +73,80 @@ int disable_pse __devinitdata = 0;
 /*
  * Machine setup..
  */
-extern struct resource code_resource;
-extern struct resource data_resource;
-extern struct resource bss_resource;
+static struct resource data_resource = {
+	.name	= "Kernel data",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+static struct resource code_resource = {
+	.name	= "Kernel code",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+static struct resource bss_resource = {
+	.name	= "Kernel bss",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+static struct resource video_ram_resource = {
+	.name	= "Video RAM area",
+	.start	= 0xa0000,
+	.end	= 0xbffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+static struct resource standard_io_resources[] = { {
+	.name	= "dma1",
+	.start	= 0x0000,
+	.end	= 0x001f,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "pic1",
+	.start	= 0x0020,
+	.end	= 0x0021,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name   = "timer0",
+	.start	= 0x0040,
+	.end    = 0x0043,
+	.flags  = IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name   = "timer1",
+	.start  = 0x0050,
+	.end    = 0x0053,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "keyboard",
+	.start	= 0x0060,
+	.end	= 0x006f,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "dma page reg",
+	.start	= 0x0080,
+	.end	= 0x008f,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "pic2",
+	.start	= 0x00a0,
+	.end	= 0x00a1,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "dma2",
+	.start	= 0x00c0,
+	.end	= 0x00df,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+}, {
+	.name	= "fpu",
+	.start	= 0x00f0,
+	.end	= 0x00ff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_IO
+} };
 
 /* cpu data as detected by the assembly code in head.S */
 struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
@@ -693,3 +764,32 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 }
+
+/*
+ * Request address space for all standard resources
+ *
+ * This is called just before pcibios_init(), which is also a
+ * subsys_initcall, but is linked in later (in arch/i386/pci/common.c).
+ */
+static int __init request_standard_resources(void)
+{
+	int i;
+
+	printk(KERN_INFO "Setting up standard PCI resources\n");
+	if (efi_enabled)
+		efi_initialize_iomem_resources(&code_resource,
+				&data_resource, &bss_resource);
+	else
+		legacy_init_iomem_resources(&code_resource,
+				&data_resource, &bss_resource);
+
+	/* EFI systems may still have VGA */
+	request_resource(&iomem_resource, &video_ram_resource);
+
+	/* request I/O space for devices used on all i[345]86 PCs */
+	for (i = 0; i < ARRAY_SIZE(standard_io_resources); i++)
+		request_resource(&ioport_resource, &standard_io_resources[i]);
+	return 0;
+}
+
+subsys_initcall(request_standard_resources);
diff -puN arch/x86/kernel/setup_64.c~remove-extern-declarations-for-code-data-bss-resource arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~remove-extern-declarations-for-code-data-bss-resource
+++ a/arch/x86/kernel/setup_64.c
@@ -123,19 +123,19 @@ struct resource standard_io_resources[] 
 
 #define IORESOURCE_RAM (IORESOURCE_BUSY | IORESOURCE_MEM)
 
-struct resource data_resource = {
+static struct resource data_resource = {
 	.name = "Kernel data",
 	.start = 0,
 	.end = 0,
 	.flags = IORESOURCE_RAM,
 };
-struct resource code_resource = {
+static struct resource code_resource = {
 	.name = "Kernel code",
 	.start = 0,
 	.end = 0,
 	.flags = IORESOURCE_RAM,
 };
-struct resource bss_resource = {
+static struct resource bss_resource = {
 	.name = "Kernel bss",
 	.start = 0,
 	.end = 0,
@@ -438,7 +438,7 @@ void __init setup_arch(char **cmdline_p)
 	/*
 	 * We trust e820 completely. No explicit ROM probing in memory.
  	 */
-	e820_reserve_resources(); 
+	e820_reserve_resources(&code_resource, &data_resource, &bss_resource);
 	e820_mark_nosave_regions();
 
 	{
diff -puN include/asm-x86/e820_32.h~remove-extern-declarations-for-code-data-bss-resource include/asm-x86/e820_32.h
--- a/include/asm-x86/e820_32.h~remove-extern-declarations-for-code-data-bss-resource
+++ a/include/asm-x86/e820_32.h
@@ -12,6 +12,8 @@
 #ifndef __E820_HEADER
 #define __E820_HEADER
 
+#include <linux/ioport.h>
+
 #define HIGH_MEMORY	(1024*1024)
 
 #ifndef __ASSEMBLY__
@@ -26,6 +28,9 @@ extern void register_bootmem_low_pages(u
 extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
+extern void legacy_init_iomem_resources(struct resource *code_resource,
+			    struct resource *data_resource,
+			    struct resource *bss_resource);
 
 #if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
 extern void e820_mark_nosave_regions(void);
@@ -35,5 +40,6 @@ static inline void e820_mark_nosave_regi
 }
 #endif
 
+
 #endif/*!__ASSEMBLY__*/
 #endif/*__E820_HEADER*/
diff -puN include/asm-x86/e820_64.h~remove-extern-declarations-for-code-data-bss-resource include/asm-x86/e820_64.h
--- a/include/asm-x86/e820_64.h~remove-extern-declarations-for-code-data-bss-resource
+++ a/include/asm-x86/e820_64.h
@@ -11,6 +11,8 @@
 #ifndef __E820_HEADER
 #define __E820_HEADER
 
+#include <linux/ioport.h>
+
 #ifndef __ASSEMBLY__
 extern unsigned long find_e820_area(unsigned long start, unsigned long end, 
 				    unsigned size);
@@ -19,7 +21,8 @@ extern void add_memory_region(unsigned l
 extern void setup_memory_region(void);
 extern void contig_e820_setup(void); 
 extern unsigned long e820_end_of_ram(void);
-extern void e820_reserve_resources(void);
+extern void e820_reserve_resources(struct resource *code_resource,
+		struct resource *data_resource, struct resource *bss_resource);
 extern void e820_mark_nosave_regions(void);
 extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
 extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
diff -puN include/linux/ioport.h~remove-extern-declarations-for-code-data-bss-resource include/linux/ioport.h
--- a/include/linux/ioport.h~remove-extern-declarations-for-code-data-bss-resource
+++ a/include/linux/ioport.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_IOPORT_H
 #define _LINUX_IOPORT_H
 
+#ifndef __ASSEMBLY__
 #include <linux/compiler.h>
 #include <linux/types.h>
 /*
@@ -153,4 +154,5 @@ extern struct resource * __devm_request_
 extern void __devm_release_region(struct device *dev, struct resource *parent,
 				  resource_size_t start, resource_size_t n);
 
+#endif /* __ASSEMBLY__ */
 #endif	/* _LINUX_IOPORT_H */
_

Patches currently in -mm which might be from bwalle@suse.de are

rename-_bss-to-__bss_start.patch
git-x86.patch
introduce-flags-for-reserve_bootmem.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
use-bootmem_exclusive-for-kdump.patch
