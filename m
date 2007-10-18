From: akpm@linux-foundation.org
Subject: + kexec-add-bss-to-resource-tree.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:30:17 -0700
Message-ID: <200710182130.l9ILUHeH032048@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758027AbXJRVam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, ebiederm@xmission.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de, vgoyal@in.ibm.com


The patch titled
     kexec: add BSS to resource tree
has been added to the -mm tree.  Its filename is
     kexec-add-bss-to-resource-tree.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kexec: add BSS to resource tree
From: Bernhard Walle <bwalle@suse.de>

Add the BSS to the resource tree just as kernel text and kernel data are in
the resource tree.  The main reason behind this is to avoid crashkernel
reservation in that area.

While it's not strictly necessary to have the BSS in the resource tree (the
actual collision detection is done in the reserve_bootmem() function before),
the usage of the BSS resource should be presented to the user in /proc/iomem
just as Kernel data and Kernel code.

Note: The patch currently is only implemented for x86 and ia64 (because
efi_initialize_iomem_resources() has the same signature on i386 and ia64).

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>
Cc: <linux-arch@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c     |    4 +++-
 arch/ia64/kernel/setup.c   |   14 +++++++++++---
 arch/x86/kernel/e820_32.c  |   18 +++++++++++++++---
 arch/x86/kernel/e820_64.c  |    3 ++-
 arch/x86/kernel/efi_32.c   |    4 +++-
 arch/x86/kernel/setup_32.c |    4 ++++
 arch/x86/kernel/setup_64.c |    9 +++++++++
 include/linux/efi.h        |    2 +-
 8 files changed, 48 insertions(+), 10 deletions(-)

diff -puN arch/ia64/kernel/efi.c~kexec-add-bss-to-resource-tree arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~kexec-add-bss-to-resource-tree
+++ a/arch/ia64/kernel/efi.c
@@ -1090,7 +1090,8 @@ efi_memmap_init(unsigned long *s, unsign
 
 void
 efi_initialize_iomem_resources(struct resource *code_resource,
-			       struct resource *data_resource)
+			       struct resource *data_resource,
+			       struct resource *bss_resource)
 {
 	struct resource *res;
 	void *efi_map_start, *efi_map_end, *p;
@@ -1171,6 +1172,7 @@ efi_initialize_iomem_resources(struct re
 			 */
 			insert_resource(res, code_resource);
 			insert_resource(res, data_resource);
+			insert_resource(res, bss_resource);
 #ifdef CONFIG_KEXEC
                         insert_resource(res, &efi_memmap_res);
                         insert_resource(res, &boot_param_res);
diff -puN arch/ia64/kernel/setup.c~kexec-add-bss-to-resource-tree arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~kexec-add-bss-to-resource-tree
+++ a/arch/ia64/kernel/setup.c
@@ -90,7 +90,12 @@ static struct resource code_resource = {
 	.name	= "Kernel code",
 	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
 };
-extern char _text[], _end[], _etext[];
+
+static struct resource bss_resource = {
+	.name	= "Kernel bss",
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+extern char _text[], _end[], _etext[], _edata[], _bss[];
 
 unsigned long ia64_max_cacheline_size;
 
@@ -200,8 +205,11 @@ static int __init register_memory(void)
 	code_resource.start = ia64_tpa(_text);
 	code_resource.end   = ia64_tpa(_etext) - 1;
 	data_resource.start = ia64_tpa(_etext);
-	data_resource.end   = ia64_tpa(_end) - 1;
-	efi_initialize_iomem_resources(&code_resource, &data_resource);
+	data_resource.end   = ia64_tpa(_edata) - 1;
+	bss_resource.start  = ia64_tpa(_bss);
+	bss_resource.end    = ia64_tpa(_end) - 1;
+	efi_initialize_iomem_resources(&code_resource, &data_resource,
+			&bss_resource);
 
 	return 0;
 }
diff -puN arch/x86/kernel/e820_32.c~kexec-add-bss-to-resource-tree arch/x86/kernel/e820_32.c
--- a/arch/x86/kernel/e820_32.c~kexec-add-bss-to-resource-tree
+++ a/arch/x86/kernel/e820_32.c
@@ -51,6 +51,13 @@ struct resource code_resource = {
 	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
 };
 
+struct resource bss_resource = {
+	.name	= "Kernel bss",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
 	.start	= 0xf0000,
@@ -254,7 +261,9 @@ static void __init probe_roms(void)
  * and also for regions reported as reserved by the e820.
  */
 static void __init
-legacy_init_iomem_resources(struct resource *code_resource, struct resource *data_resource)
+legacy_init_iomem_resources(struct resource *code_resource,
+			    struct resource *data_resource,
+			    struct resource *bss_resource)
 {
 	int i;
 
@@ -287,6 +296,7 @@ legacy_init_iomem_resources(struct resou
 			 */
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
+			request_resource(res, bss_resource);
 #ifdef CONFIG_KEXEC
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
@@ -307,9 +317,11 @@ static int __init request_standard_resou
 
 	printk("Setting up standard PCI resources\n");
 	if (efi_enabled)
-		efi_initialize_iomem_resources(&code_resource, &data_resource);
+		efi_initialize_iomem_resources(&code_resource,
+				&data_resource, &bss_resource);
 	else
-		legacy_init_iomem_resources(&code_resource, &data_resource);
+		legacy_init_iomem_resources(&code_resource,
+				&data_resource, &bss_resource);
 
 	/* EFI systems may still have VGA */
 	request_resource(&iomem_resource, &video_ram_resource);
diff -puN arch/x86/kernel/e820_64.c~kexec-add-bss-to-resource-tree arch/x86/kernel/e820_64.c
--- a/arch/x86/kernel/e820_64.c~kexec-add-bss-to-resource-tree
+++ a/arch/x86/kernel/e820_64.c
@@ -47,7 +47,7 @@ unsigned long end_pfn_map; 
  */
 static unsigned long __initdata end_user_pfn = MAXMEM>>PAGE_SHIFT;
 
-extern struct resource code_resource, data_resource;
+extern struct resource code_resource, data_resource, bss_resource;
 
 /* Check for some hardcoded bad areas that early boot is not allowed to touch */ 
 static inline int bad_addr(unsigned long *addrp, unsigned long size)
@@ -225,6 +225,7 @@ void __init e820_reserve_resources(void)
 			 */
 			request_resource(res, &code_resource);
 			request_resource(res, &data_resource);
+			request_resource(res, &bss_resource);
 #ifdef CONFIG_KEXEC
 			if (crashk_res.start != crashk_res.end)
 				request_resource(res, &crashk_res);
diff -puN arch/x86/kernel/efi_32.c~kexec-add-bss-to-resource-tree arch/x86/kernel/efi_32.c
--- a/arch/x86/kernel/efi_32.c~kexec-add-bss-to-resource-tree
+++ a/arch/x86/kernel/efi_32.c
@@ -603,7 +603,8 @@ void __init efi_enter_virtual_mode(void)
 
 void __init
 efi_initialize_iomem_resources(struct resource *code_resource,
-			       struct resource *data_resource)
+                               struct resource *data_resource,
+			       struct resource *bss_resource)
 {
 	struct resource *res;
 	efi_memory_desc_t *md;
@@ -675,6 +676,7 @@ efi_initialize_iomem_resources(struct re
 		if (md->type == EFI_CONVENTIONAL_MEMORY) {
 			request_resource(res, code_resource);
 			request_resource(res, data_resource);
+			request_resource(res, bss_resource);
 #ifdef CONFIG_KEXEC
 			request_resource(res, &crashk_res);
 #endif
diff -puN arch/x86/kernel/setup_32.c~kexec-add-bss-to-resource-tree arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~kexec-add-bss-to-resource-tree
+++ a/arch/x86/kernel/setup_32.c
@@ -60,6 +60,7 @@
 #include <asm/vmi.h>
 #include <setup_arch.h>
 #include <bios_ebda.h>
+#include <asm/cacheflush.h>
 
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
@@ -73,6 +74,7 @@ int disable_pse __devinitdata = 0;
  */
 extern struct resource code_resource;
 extern struct resource data_resource;
+extern struct resource bss_resource;
 
 /* cpu data as detected by the assembly code in head.S */
 struct cpuinfo_x86 new_cpu_data __cpuinitdata = { 0, 0, 0, 0, -1, 1, 0, 0, -1 };
@@ -600,6 +602,8 @@ void __init setup_arch(char **cmdline_p)
 	code_resource.end = virt_to_phys(_etext)-1;
 	data_resource.start = virt_to_phys(_etext);
 	data_resource.end = virt_to_phys(_edata)-1;
+	bss_resource.start = virt_to_phys(&__bss_start);
+	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
 	parse_early_param();
 
diff -puN arch/x86/kernel/setup_64.c~kexec-add-bss-to-resource-tree arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~kexec-add-bss-to-resource-tree
+++ a/arch/x86/kernel/setup_64.c
@@ -58,6 +58,7 @@
 #include <asm/numa.h>
 #include <asm/sections.h>
 #include <asm/dmi.h>
+#include <asm/cacheflush.h>
 
 /*
  * Machine setup..
@@ -133,6 +134,12 @@ struct resource code_resource = {
 	.end = 0,
 	.flags = IORESOURCE_RAM,
 };
+struct resource bss_resource = {
+	.name = "Kernel bss",
+	.start = 0,
+	.end = 0,
+	.flags = IORESOURCE_RAM,
+};
 
 #ifdef CONFIG_PROC_VMCORE
 /* elfcorehdr= specifies the location of elf core header
@@ -276,6 +283,8 @@ void __init setup_arch(char **cmdline_p)
 	code_resource.end = virt_to_phys(&_etext)-1;
 	data_resource.start = virt_to_phys(&_etext);
 	data_resource.end = virt_to_phys(&_edata)-1;
+	bss_resource.start = virt_to_phys(&__bss_start);
+	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
 	early_identify_cpu(&boot_cpu_data);
 
diff -puN include/linux/efi.h~kexec-add-bss-to-resource-tree include/linux/efi.h
--- a/include/linux/efi.h~kexec-add-bss-to-resource-tree
+++ a/include/linux/efi.h
@@ -298,7 +298,7 @@ extern int efi_mem_attribute_range (unsi
 				    u64 attr);
 extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
-					struct resource *data_resource);
+		struct resource *data_resource, struct resource *bss_resource);
 extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern int is_available_memory(efi_memory_desc_t * md);
_

Patches currently in -mm which might be from bwalle@suse.de are

origin.patch
extended-crashkernel-command-line.patch
extended-crashkernel-command-line-update.patch
extended-crashkernel-command-line-comment-fix.patch
extended-crashkernel-command-line-improve-error-handling-in-parse_crashkernel_mem.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-i386-update.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-x86_64-update.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ia64-update.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-ppc64-update.patch
use-extended-crashkernel-command-line-on-sh.patch
use-extended-crashkernel-command-line-on-sh-update.patch
add-documentation-for-extended-crashkernel-syntax.patch
add-documentation-for-extended-crashkernel-syntax-add-extended-crashkernel-syntax-to-kernel-parameterstxt.patch
kexec-add-bss-to-resource-tree.patch
kexec-introduce-bootmem_exclusive.patch
kexec-use-bootmem_exclusive-on-x86.patch
