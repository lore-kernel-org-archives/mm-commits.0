From: akpm@linux-foundation.org
Subject: + i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support.patch added to -mm tree
Date: Fri, 21 Dec 2007 00:24:21 -0800
Message-ID: <200712210824.lBL8OLxN004642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbXLUIZd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 03:25:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     i386 EFI runtime service support: fixes in sync with x86_64 support
has been added to the -mm tree.  Its filename is
     i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386 EFI runtime service support: fixes in sync with x86_64 support
From: "Huang, Ying" <ying.huang@intel.com>

This patch fixes several issues of i386 EFI basic runtime service
support according to fixes of x86_64 support.

- Delete efi_rt_lock because it is used during system early boot,
  before SMP is initialized.

- Change local_flush_tlb() to __flush_tlb_all() to flush global page
  mapping.

- Clean up includes.

- Revise Kconfig description.

- Enable noefi kernel parameter on i386.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt   |    2 +
 Documentation/x86_64/boot-options.txt |    4 ---
 arch/x86/Kconfig                      |   19 +++++++-----------
 arch/x86/kernel/efi.c                 |    7 ++++++
 arch/x86/kernel/efi_32.c              |   25 ++++--------------------
 arch/x86/kernel/efi_64.c              |    7 ------
 arch/x86/kernel/setup_32.c            |    6 ++---
 7 files changed, 25 insertions(+), 45 deletions(-)

diff -puN arch/x86/Kconfig~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support arch/x86/Kconfig
--- a/arch/x86/Kconfig~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support
+++ a/arch/x86/Kconfig
@@ -993,21 +993,18 @@ config MTRR
 
 config EFI
 	def_bool n
-	prompt "Boot from EFI support"
+	prompt "EFI runtime service support"
 	depends on ACPI
 	---help---
-	This enables the kernel to boot on EFI platforms using
-	system configuration information passed to it from the firmware.
-	This also enables the kernel to use any EFI runtime services that are
+	This enables the kernel to use EFI runtime services that are
 	available (such as the EFI variable services).
 
-	This option is only useful on systems that have EFI firmware
-	and will result in a kernel image that is ~8k larger.  In addition,
-	you must use the latest ELILO loader available at
-	<http://elilo.sourceforge.net> in order to take advantage of
-	kernel initialization using EFI information (neither GRUB nor LILO know
-	anything about EFI).  However, even with this option, the resultant
-	kernel should continue to boot on existing non-EFI platforms.
+	This option is only useful on systems that have EFI firmware.
+  	In addition, you should use the latest ELILO loader available
+  	at <http://elilo.sourceforge.net> in order to take advantage
+  	of EFI runtime services. However, even with this option, the
+  	resultant kernel should continue to boot on existing non-EFI
+  	platforms.
 
 config IRQBALANCE
 	def_bool y
diff -puN arch/x86/kernel/efi_32.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support arch/x86/kernel/efi_32.c
--- a/arch/x86/kernel/efi_32.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support
+++ a/arch/x86/kernel/efi_32.c
@@ -20,27 +20,15 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/mm.h>
 #include <linux/types.h>
-#include <linux/time.h>
-#include <linux/spinlock.h>
-#include <linux/bootmem.h>
 #include <linux/ioport.h>
-#include <linux/module.h>
 #include <linux/efi.h>
-#include <linux/kexec.h>
 
-#include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/desc.h>
 #include <asm/tlbflush.h>
 
-#define PFX 		"EFI: "
-
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
  * prelog/epilog before/after the invocation to disable interrupt, to
@@ -49,16 +37,14 @@
  */
 
 static unsigned long efi_rt_eflags;
-static DEFINE_SPINLOCK(efi_rt_lock);
 static pgd_t efi_bak_pg_dir_pointer[2];
 
-void efi_call_phys_prelog(void) __acquires(efi_rt_lock)
+void efi_call_phys_prelog(void)
 {
 	unsigned long cr4;
 	unsigned long temp;
 	struct desc_ptr gdt_descr;
 
-	spin_lock(&efi_rt_lock);
 	local_irq_save(efi_rt_eflags);
 
 	/*
@@ -88,14 +74,14 @@ void efi_call_phys_prelog(void) __acquir
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	local_flush_tlb();
+	__flush_tlb_all();
 
 	gdt_descr.address = __pa(get_cpu_gdt_table(0));
 	gdt_descr.size = GDT_SIZE - 1;
 	load_gdt(&gdt_descr);
 }
 
-void efi_call_phys_epilog(void) __releases(efi_rt_lock)
+void efi_call_phys_epilog(void)
 {
 	unsigned long cr4;
 	struct desc_ptr gdt_descr;
@@ -119,10 +105,9 @@ void efi_call_phys_epilog(void) __releas
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
-	local_flush_tlb();
+	__flush_tlb_all();
 
 	local_irq_restore(efi_rt_eflags);
-	spin_unlock(&efi_rt_lock);
 }
 
 /*
@@ -135,7 +120,7 @@ void __init efi_map_memmap(void)
 	memmap.map = bt_ioremap((unsigned long) memmap.phys_map,
 			(memmap.nr_map * memmap.desc_size));
 	if (memmap.map == NULL)
-		printk(KERN_ERR PFX "Could not remap the EFI memmap!\n");
+		printk(KERN_ERR "Could not remap the EFI memmap!\n");
 
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 }
diff -puN arch/x86/kernel/efi_64.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support arch/x86/kernel/efi_64.c
--- a/arch/x86/kernel/efi_64.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support
+++ a/arch/x86/kernel/efi_64.c
@@ -40,13 +40,6 @@
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
 
-static int __init setup_noefi(char *arg)
-{
-	efi_enabled = 0;
-	return 0;
-}
-early_param("noefi", setup_noefi);
-
 static void __init early_mapping_set_exec(unsigned long start,
 					  unsigned long end,
 					  int executable)
diff -puN arch/x86/kernel/efi.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support arch/x86/kernel/efi.c
--- a/arch/x86/kernel/efi.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support
+++ a/arch/x86/kernel/efi.c
@@ -55,6 +55,13 @@ struct efi_memory_map memmap;
 struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
+static int __init setup_noefi(char *arg)
+{
+	efi_enabled = 0;
+	return 0;
+}
+early_param("noefi", setup_noefi);
+
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	return efi_call_virt2(get_time, tm, tc);
diff -puN arch/x86/kernel/setup_32.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support
+++ a/arch/x86/kernel/setup_32.c
@@ -649,9 +649,6 @@ void __init setup_arch(char **cmdline_p)
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	print_memory_map(memory_setup());
 
-	if (efi_enabled)
-		efi_init();
-
 	copy_edd();
 
 	if (!boot_params.hdr.root_flags)
@@ -678,6 +675,9 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	if (efi_enabled)
+		efi_init();
+
 	max_low_pfn = setup_memory();
 
 #ifdef CONFIG_VMI
diff -puN Documentation/kernel-parameters.txt~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support
+++ a/Documentation/kernel-parameters.txt
@@ -1155,6 +1155,8 @@ and is between 256 and 4096 characters. 
 
 	nodisconnect	[HW,SCSI,M68K] Disables SCSI disconnects.
 
+	noefi		[X86-32,X86-64] Disable EFI runtime services support.
+
 	noexec		[IA-64]
 
 	noexec		[X86-32,X86-64]
diff -puN Documentation/x86_64/boot-options.txt~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support
+++ a/Documentation/x86_64/boot-options.txt
@@ -306,8 +306,4 @@ Debugging
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
-EFI
-
-  noefi		Disable EFI support
-
 Miscellaneous
_

Patches currently in -mm which might be from ying.huang@intel.com are

git-x86.patch
i386-efi-runtime-service-support-fixes-in-sync-with-x86_64-support.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
