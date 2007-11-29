From: akpm@linux-foundation.org
Subject: + x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch added to -mm tree
Date: Thu, 29 Nov 2007 12:55:45 -0800
Message-ID: <200711292055.lATKtj36006976@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36833 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758778AbXK2U4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 15:56:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, mouli@linux.intel.com, tglx@linutronix.de


The patch titled
     x86_64 EFI runtime service support: EFI basic runtime service support fixes
has been added to the -mm tree.  Its filename is
     x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 EFI runtime service support: EFI basic runtime service support fixes
From: "Huang, Ying" <ying.huang@intel.com>

This patch fixes several issues of x86_64 EFI basic runtime service
support patch per comments from Andrew Moton.

- Delete efi_lock because it is used during system early boot, before
  smp is initialized. The global_flush_tlb() is changed to
  __flush_tlb_all for some reason.

- Revise some messages.

- Turn on debug by default.

- Remove unnecessary memset of static variable.

This patch has been tested against 2.6.24-rc3-mm1 kernel on Intel
platforms with 64-bit EFI1.10 and UEFI2.0 firmware.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/efi.c    |   24 ++++++++++--------------
 arch/x86/kernel/efi_64.c |   18 +++++-------------
 2 files changed, 15 insertions(+), 27 deletions(-)

diff -puN arch/x86/kernel/efi.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes arch/x86/kernel/efi.c
--- a/arch/x86/kernel/efi.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes
+++ a/arch/x86/kernel/efi.c
@@ -41,7 +41,8 @@
 #include <asm/efi.h>
 #include <asm/time.h>
 
-#define EFI_DEBUG	0
+#define EFI_DEBUG	1
+#define PFX 		"EFI: "
 
 int efi_enabled;
 EXPORT_SYMBOL(efi_enabled);
@@ -214,7 +215,7 @@ static void __init print_efi_memmap(void
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		printk(KERN_INFO "mem%02u: type=%u, attr=0x%llx, "
+		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
 			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
@@ -232,9 +233,6 @@ void __init efi_init(void)
 	int i = 0;
 	void *tmp;
 
-	memset(&efi, 0, sizeof(efi));
-	memset(&efi_phys, 0, sizeof(efi_phys));
-
 #ifdef CONFIG_X86_32
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
 	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
@@ -254,7 +252,7 @@ void __init efi_init(void)
 	efi.systab = efi_early_ioremap((unsigned long)efi_phys.systab,
 				       sizeof(efi_system_table_t));
 	if (efi.systab == NULL)
-		printk(KERN_ERR "Woah! Couldn't map the EFI systema table.\n");
+		printk(KERN_ERR "Couldn't map the EFI system table!\n");
 	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
 	efi_early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
@@ -263,11 +261,10 @@ void __init efi_init(void)
 	 * Verify the EFI Table
 	 */
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		printk(KERN_ERR "Woah! EFI system table "
-		       "signature incorrect\n");
+		printk(KERN_ERR "EFI system table signature incorrect!\n");
 	if ((efi.systab->hdr.revision >> 16) == 0)
 		printk(KERN_ERR "Warning: EFI system table version "
-		       "%d.%02d, expected 1.00 or greater\n",
+		       "%d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
@@ -280,7 +277,7 @@ void __init efi_init(void)
 			vendor[i] = *c16++;
 		vendor[i] = '\0';
 	} else
-		printk(KERN_ERR "Could not map the firmware vendor!\n");
+		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
 	efi_early_iounmap(tmp, 2);
 
 	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
@@ -404,7 +401,7 @@ void __init efi_enter_virtual_mode(void)
 				efi_ioremap(md->phys_addr,
 					    md->num_pages << EFI_PAGE_SHIFT);
 		if (!md->virt_addr)
-			printk(KERN_ERR "ioremap of 0x%llX failed!\n",
+			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
 			       (unsigned long long)md->phys_addr);
 		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
 		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
@@ -423,9 +420,8 @@ void __init efi_enter_virtual_mode(void)
 		memmap.phys_map);
 
 	if (status != EFI_SUCCESS) {
-		printk(KERN_ALERT "You are screwed! "
-		       "Unable to switch EFI into virtual mode "
-		       "(status=%lx)\n", status);
+		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
+		       "(status=%lx)!\n", status);
 		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
diff -puN arch/x86/kernel/efi_64.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes arch/x86/kernel/efi_64.c
--- a/arch/x86/kernel/efi_64.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes
+++ a/arch/x86/kernel/efi_64.c
@@ -39,8 +39,6 @@
 
 static pgd_t save_pgd __initdata;
 static unsigned long efi_flags __initdata;
-/* efi_lock protects efi physical mode call */
-static __initdata DEFINE_SPINLOCK(efi_lock);
 
 static int __init setup_noefi(char *arg)
 {
@@ -86,33 +84,27 @@ static void __init early_runtime_code_ma
 	}
 }
 
-void __init efi_call_phys_prelog(void) __acquires(efi_lock)
+void __init efi_call_phys_prelog(void)
 {
 	unsigned long vaddress;
 
-	/*
-	 * Lock sequence is different from normal case because
-	 * efi_flags is global
-	 */
-	spin_lock(&efi_lock);
 	local_irq_save(efi_flags);
 	early_runtime_code_mapping_set_exec(1);
 	vaddress = (unsigned long)__va(0x0UL);
 	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
 	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
-	global_flush_tlb();
+	__flush_tlb_all();
 }
 
-void __init efi_call_phys_epilog(void) __releases(efi_lock)
+void __init efi_call_phys_epilog(void)
 {
 	/*
 	 * After the lock is released, the original page table is restored.
 	 */
 	set_pgd(pgd_offset_k(0x0UL), save_pgd);
 	early_runtime_code_mapping_set_exec(0);
-	global_flush_tlb();
+	__flush_tlb_all();
 	local_irq_restore(efi_flags);
-	spin_unlock(&efi_lock);
 }
 
 /*
@@ -143,7 +135,7 @@ void __init runtime_code_page_mkexec(voi
 					      md->num_pages,
 					      PAGE_KERNEL_EXEC);
 	}
-	global_flush_tlb();
+	__flush_tlb_all();
 }
 
 void __iomem * __init efi_ioremap(unsigned long offset,
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
