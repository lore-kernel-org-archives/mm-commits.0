From: akpm@linux-foundation.org
Subject: + x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch added to -mm tree
Date: Tue, 27 Nov 2007 02:03:17 -0800
Message-ID: <200711271003.lARA3HRr006004@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58993 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757860AbXK0KEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 05:04:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64 EFI runtime service support: remove duplicated code from efi_32.c
has been added to the -mm tree.  Its filename is
     x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64 EFI runtime service support: remove duplicated code from efi_32.c
From: "Huang, Ying" <ying.huang@intel.com>

This patch removes the duplicated code between efi_32.c and efi.c.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/Makefile_32 |    2 
 arch/x86/kernel/e820_32.c   |    5 
 arch/x86/kernel/efi_32.c    |  430 ----------------------------------
 arch/x86/kernel/setup_32.c  |   11 
 include/asm-x86/efi.h       |   42 +++
 5 files changed, 47 insertions(+), 443 deletions(-)

diff -puN arch/x86/kernel/Makefile_32~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c arch/x86/kernel/Makefile_32
--- a/arch/x86/kernel/Makefile_32~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c
+++ a/arch/x86/kernel/Makefile_32
@@ -35,7 +35,7 @@ obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_
 obj-$(CONFIG_KPROBES)		+= kprobes_32.o
 obj-$(CONFIG_MODULES)		+= module_32.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
-obj-$(CONFIG_EFI) 		+= efi_32.o efi_stub_32.o
+obj-$(CONFIG_EFI) 		+= efi.o efi_32.o efi_stub_32.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault_32.o
 obj-$(CONFIG_VM86)		+= vm86_32.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff -puN arch/x86/kernel/e820_32.c~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c arch/x86/kernel/e820_32.c
--- a/arch/x86/kernel/e820_32.c~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c
+++ a/arch/x86/kernel/e820_32.c
@@ -17,11 +17,6 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 
-#ifdef CONFIG_EFI
-int efi_enabled = 0;
-EXPORT_SYMBOL(efi_enabled);
-#endif
-
 struct e820map e820;
 struct change_member {
 	struct e820entry *pbios; /* pointer to original bios entry */
diff -puN arch/x86/kernel/efi_32.c~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c arch/x86/kernel/efi_32.c
--- a/arch/x86/kernel/efi_32.c~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c
+++ a/arch/x86/kernel/efi_32.c
@@ -39,21 +39,8 @@
 #include <asm/desc.h>
 #include <asm/tlbflush.h>
 
-#define EFI_DEBUG	0
 #define PFX 		"EFI: "
 
-extern efi_status_t asmlinkage efi_call_phys(void *, ...);
-
-struct efi efi;
-EXPORT_SYMBOL(efi);
-static struct efi efi_phys;
-struct efi_memory_map memmap;
-
-/*
- * We require an early boot_ioremap mapping mechanism initially
- */
-extern void * boot_ioremap(unsigned long, unsigned long);
-
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
  * prelog/epilog before/after the invocation to disable interrupt, to
@@ -65,7 +52,7 @@ static unsigned long efi_rt_eflags;
 static DEFINE_SPINLOCK(efi_rt_lock);
 static pgd_t efi_bak_pg_dir_pointer[2];
 
-static void efi_call_phys_prelog(void) __acquires(efi_rt_lock)
+void efi_call_phys_prelog(void) __acquires(efi_rt_lock)
 {
 	unsigned long cr4;
 	unsigned long temp;
@@ -108,7 +95,7 @@ static void efi_call_phys_prelog(void) _
 	load_gdt(&gdt_descr);
 }
 
-static void efi_call_phys_epilog(void) __releases(efi_rt_lock)
+void efi_call_phys_epilog(void) __releases(efi_rt_lock)
 {
 	unsigned long cr4;
 	struct Xgt_desc_struct gdt_descr;
@@ -138,87 +125,6 @@ static void efi_call_phys_epilog(void) _
 	spin_unlock(&efi_rt_lock);
 }
 
-static efi_status_t
-phys_efi_set_virtual_address_map(unsigned long memory_map_size,
-				 unsigned long descriptor_size,
-				 u32 descriptor_version,
-				 efi_memory_desc_t *virtual_map)
-{
-	efi_status_t status;
-
-	efi_call_phys_prelog();
-	status = efi_call_phys(efi_phys.set_virtual_address_map,
-				     memory_map_size, descriptor_size,
-				     descriptor_version, virtual_map);
-	efi_call_phys_epilog();
-	return status;
-}
-
-static efi_status_t
-phys_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
-{
-	efi_status_t status;
-
-	efi_call_phys_prelog();
-	status = efi_call_phys(efi_phys.get_time, tm, tc);
-	efi_call_phys_epilog();
-	return status;
-}
-
-inline int efi_set_rtc_mmss(unsigned long nowtime)
-{
-	int real_seconds, real_minutes;
-	efi_status_t 	status;
-	efi_time_t 	eft;
-	efi_time_cap_t 	cap;
-
-	spin_lock(&efi_rt_lock);
-	status = efi.get_time(&eft, &cap);
-	spin_unlock(&efi_rt_lock);
-	if (status != EFI_SUCCESS)
-		panic("Ooops, efitime: can't read time!\n");
-	real_seconds = nowtime % 60;
-	real_minutes = nowtime / 60;
-
-	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
-		real_minutes += 30;
-	real_minutes %= 60;
-
-	eft.minute = real_minutes;
-	eft.second = real_seconds;
-
-	if (status != EFI_SUCCESS) {
-		printk("Ooops: efitime: can't read time!\n");
-		return -1;
-	}
-	return 0;
-}
-/*
- * This is used during kernel init before runtime
- * services have been remapped and also during suspend, therefore,
- * we'll need to call both in physical and virtual modes.
- */
-inline unsigned long efi_get_time(void)
-{
-	efi_status_t status;
-	efi_time_t eft;
-	efi_time_cap_t cap;
-
-	if (efi.get_time) {
-		/* if we are in virtual mode use remapped function */
- 		status = efi.get_time(&eft, &cap);
-	} else {
-		/* we are in physical mode */
-		status = phys_efi_get_time(&eft, &cap);
-	}
-
-	if (status != EFI_SUCCESS)
-		printk("Oops: efitime: can't read time status: 0x%lx\n",status);
-
-	return mktime(eft.year, eft.month, eft.day, eft.hour,
-			eft.minute, eft.second);
-}
-
 int is_available_memory(efi_memory_desc_t * md)
 {
 	if (!(md->attribute & EFI_MEMORY_WB))
@@ -250,24 +156,6 @@ void __init efi_map_memmap(void)
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 }
 
-#if EFI_DEBUG
-static void __init print_efi_memmap(void)
-{
-	efi_memory_desc_t *md;
-	void *p;
-	int i;
-
-	for (p = memmap.map, i = 0; p < memmap.map_end; p += memmap.desc_size, i++) {
-		md = p;
-		printk(KERN_INFO "mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
-			i, md->type, md->attribute, md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
-	}
-}
-#endif  /*  EFI_DEBUG  */
-
 /*
  * Walks the EFI memory map and calls CALLBACK once for each EFI
  * memory descriptor that has memory that is available for kernel use.
@@ -319,288 +207,6 @@ void efi_memmap_walk(efi_freemem_callbac
 	}
 }
 
-void __init efi_init(void)
-{
-	efi_config_table_t *config_tables;
-	efi_runtime_services_t *runtime;
-	efi_char16_t *c16;
-	char vendor[100] = "unknown";
-	unsigned long num_config_tables;
-	int i = 0;
-
-	memset(&efi, 0, sizeof(efi) );
-	memset(&efi_phys, 0, sizeof(efi_phys));
-
-	efi_phys.systab =
-		(efi_system_table_t *)boot_params.efi_info.efi_systab;
-	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
-	memmap.nr_map = boot_params.efi_info.efi_memmap_size/
-		boot_params.efi_info.efi_memdesc_size;
-	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
-	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
-
-	efi.systab = (efi_system_table_t *)
-		boot_ioremap((unsigned long) efi_phys.systab,
-			sizeof(efi_system_table_t));
-	/*
-	 * Verify the EFI Table
-	 */
-	if (efi.systab == NULL)
-		printk(KERN_ERR PFX "Woah! Couldn't map the EFI system table.\n");
-	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		printk(KERN_ERR PFX "Woah! EFI system table signature incorrect\n");
-	if ((efi.systab->hdr.revision >> 16) == 0)
-		printk(KERN_ERR PFX "Warning: EFI system table version "
-		       "%d.%02d, expected 1.00 or greater\n",
-		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff);
-
-	/*
-	 * Grab some details from the system table
-	 */
-	num_config_tables = efi.systab->nr_tables;
-	config_tables = (efi_config_table_t *)efi.systab->tables;
-	runtime = efi.systab->runtime;
-
-	/*
-	 * Show what we know for posterity
-	 */
-	c16 = (efi_char16_t *) boot_ioremap(efi.systab->fw_vendor, 2);
-	if (c16) {
-		for (i = 0; i < (sizeof(vendor) - 1) && *c16; ++i)
-			vendor[i] = *c16++;
-		vendor[i] = '\0';
-	} else
-		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
-
-	printk(KERN_INFO PFX "EFI v%u.%.02u by %s \n",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
-
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables = (efi_config_table_t *)
-				boot_ioremap((unsigned long) config_tables,
-			        num_config_tables * sizeof(efi_config_table_t));
-
-	if (config_tables == NULL)
-		printk(KERN_ERR PFX "Could not map EFI Configuration Table!\n");
-
-	efi.mps        = EFI_INVALID_TABLE_ADDR;
-	efi.acpi       = EFI_INVALID_TABLE_ADDR;
-	efi.acpi20     = EFI_INVALID_TABLE_ADDR;
-	efi.smbios     = EFI_INVALID_TABLE_ADDR;
-	efi.sal_systab = EFI_INVALID_TABLE_ADDR;
-	efi.boot_info  = EFI_INVALID_TABLE_ADDR;
-	efi.hcdp       = EFI_INVALID_TABLE_ADDR;
-	efi.uga        = EFI_INVALID_TABLE_ADDR;
-
-	for (i = 0; i < num_config_tables; i++) {
-		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
-			efi.mps = config_tables[i].table;
-			printk(KERN_INFO " MPS=0x%lx ", config_tables[i].table);
-		} else
-		    if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) == 0) {
-			efi.acpi20 = config_tables[i].table;
-			printk(KERN_INFO " ACPI 2.0=0x%lx ", config_tables[i].table);
-		} else
-		    if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) == 0) {
-			efi.acpi = config_tables[i].table;
-			printk(KERN_INFO " ACPI=0x%lx ", config_tables[i].table);
-		} else
-		    if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) == 0) {
-			efi.smbios = config_tables[i].table;
-			printk(KERN_INFO " SMBIOS=0x%lx ", config_tables[i].table);
-		} else
-		    if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) == 0) {
-			efi.hcdp = config_tables[i].table;
-			printk(KERN_INFO " HCDP=0x%lx ", config_tables[i].table);
-		} else
-		    if (efi_guidcmp(config_tables[i].guid, UGA_IO_PROTOCOL_GUID) == 0) {
-			efi.uga = config_tables[i].table;
-			printk(KERN_INFO " UGA=0x%lx ", config_tables[i].table);
-		}
-	}
-	printk("\n");
-
-	/*
-	 * Check out the runtime services table. We need to map
-	 * the runtime services table so that we can grab the physical
-	 * address of several of the EFI runtime functions, needed to
-	 * set the firmware into virtual mode.
-	 */
-
-	runtime = (efi_runtime_services_t *) boot_ioremap((unsigned long)
-						runtime,
-				      		sizeof(efi_runtime_services_t));
-	if (runtime != NULL) {
-		/*
-	 	 * We will only need *early* access to the following
-		 * two EFI runtime services before set_virtual_address_map
-		 * is invoked.
- 	 	 */
-		efi_phys.get_time = (efi_get_time_t *) runtime->get_time;
-		efi_phys.set_virtual_address_map =
-			(efi_set_virtual_address_map_t *)
-				runtime->set_virtual_address_map;
-	} else
-		printk(KERN_ERR PFX "Could not map the runtime service table!\n");
-
-	/* Map the EFI memory map for use until paging_init() */
-	memmap.map = boot_ioremap(boot_params.efi_info.efi_memmap,
-				  boot_params.efi_info.efi_memmap_size);
-	if (memmap.map == NULL)
-		printk(KERN_ERR PFX "Could not map the EFI memory map!\n");
-
-	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
-
-#if EFI_DEBUG
-	print_efi_memmap();
-#endif
-}
-
-static inline void __init check_range_for_systab(efi_memory_desc_t *md)
-{
-	if (((unsigned long)md->phys_addr <= (unsigned long)efi_phys.systab) &&
-		((unsigned long)efi_phys.systab < md->phys_addr +
-		((unsigned long)md->num_pages << EFI_PAGE_SHIFT))) {
-		unsigned long addr;
-
-		addr = md->virt_addr - md->phys_addr +
-			(unsigned long)efi_phys.systab;
-		efi.systab = (efi_system_table_t *)addr;
-	}
-}
-
-/*
- * Wrap all the virtual calls in a way that forces the parameters on the stack.
- */
-
-#define efi_call_virt(f, args...) \
-     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
-
-static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
-{
-	return efi_call_virt(get_time, tm, tc);
-}
-
-static efi_status_t virt_efi_set_time (efi_time_t *tm)
-{
-	return efi_call_virt(set_time, tm);
-}
-
-static efi_status_t virt_efi_get_wakeup_time (efi_bool_t *enabled,
-					      efi_bool_t *pending,
-					      efi_time_t *tm)
-{
-	return efi_call_virt(get_wakeup_time, enabled, pending, tm);
-}
-
-static efi_status_t virt_efi_set_wakeup_time (efi_bool_t enabled,
-					      efi_time_t *tm)
-{
-	return efi_call_virt(set_wakeup_time, enabled, tm);
-}
-
-static efi_status_t virt_efi_get_variable (efi_char16_t *name,
-					   efi_guid_t *vendor, u32 *attr,
-					   unsigned long *data_size, void *data)
-{
-	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
-}
-
-static efi_status_t virt_efi_get_next_variable (unsigned long *name_size,
-						efi_char16_t *name,
-						efi_guid_t *vendor)
-{
-	return efi_call_virt(get_next_variable, name_size, name, vendor);
-}
-
-static efi_status_t virt_efi_set_variable (efi_char16_t *name,
-					   efi_guid_t *vendor,
-					   unsigned long attr,
-					   unsigned long data_size, void *data)
-{
-	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
-}
-
-static efi_status_t virt_efi_get_next_high_mono_count (u32 *count)
-{
-	return efi_call_virt(get_next_high_mono_count, count);
-}
-
-static void virt_efi_reset_system (int reset_type, efi_status_t status,
-				   unsigned long data_size,
-				   efi_char16_t *data)
-{
-	efi_call_virt(reset_system, reset_type, status, data_size, data);
-}
-
-/*
- * This function will switch the EFI runtime services to virtual mode.
- * Essentially, look through the EFI memmap and map every region that
- * has the runtime attribute bit set in its memory descriptor and update
- * that memory descriptor with the virtual address obtained from ioremap().
- * This enables the runtime services to be called without having to
- * thunk back into physical mode for every invocation.
- */
-
-void __init efi_enter_virtual_mode(void)
-{
-	efi_memory_desc_t *md;
-	efi_status_t status;
-	void *p;
-
-	efi.systab = NULL;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-
-		if (!(md->attribute & EFI_MEMORY_RUNTIME))
-			continue;
-
-		md->virt_addr = (unsigned long)ioremap(md->phys_addr,
-			md->num_pages << EFI_PAGE_SHIFT);
-		if (!(unsigned long)md->virt_addr) {
-			printk(KERN_ERR PFX "ioremap of 0x%lX failed\n",
-				(unsigned long)md->phys_addr);
-		}
-		/* update the virtual address of the EFI system table */
-		check_range_for_systab(md);
-	}
-
-	BUG_ON(!efi.systab);
-
-	status = phys_efi_set_virtual_address_map(
-			memmap.desc_size * memmap.nr_map,
-			memmap.desc_size,
-			memmap.desc_version,
-		       	memmap.phys_map);
-
-	if (status != EFI_SUCCESS) {
-		printk (KERN_ALERT "You are screwed! "
-			"Unable to switch EFI into virtual mode "
-			"(status=%lx)\n", status);
-		panic("EFI call to SetVirtualAddressMap() failed!");
-	}
-
-	/*
-	 * Now that EFI is in virtual mode, update the function
-	 * pointers in the runtime service table to the new virtual addresses.
-	 */
-
-	efi.get_time = virt_efi_get_time;
-	efi.set_time = virt_efi_set_time;
-	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-	efi.set_wakeup_time = virt_efi_set_wakeup_time;
-	efi.get_variable = virt_efi_get_variable;
-	efi.get_next_variable = virt_efi_get_next_variable;
-	efi.set_variable = virt_efi_set_variable;
-	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
-	efi.reset_system = virt_efi_reset_system;
-}
-
 void __init
 efi_initialize_iomem_resources(struct resource *code_resource,
 			       struct resource *data_resource,
@@ -683,35 +289,3 @@ efi_initialize_iomem_resources(struct re
 		}
 	}
 }
-
-/*
- * Convenience functions to obtain memory types and attributes
- */
-
-u32 efi_mem_type(unsigned long phys_addr)
-{
-	efi_memory_desc_t *md;
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) && (phys_addr <
-			(md->phys_addr + (md-> num_pages << EFI_PAGE_SHIFT)) ))
-			return md->type;
-	}
-	return 0;
-}
-
-u64 efi_mem_attributes(unsigned long phys_addr)
-{
-	efi_memory_desc_t *md;
-	void *p;
-
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) && (phys_addr <
-			(md->phys_addr + (md-> num_pages << EFI_PAGE_SHIFT)) ))
-			return md->attribute;
-	}
-	return 0;
-}
diff -puN arch/x86/kernel/setup_32.c~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c
+++ a/arch/x86/kernel/setup_32.c
@@ -618,16 +618,9 @@ void __init setup_arch(char **cmdline_p)
 	pre_setup_arch_hook();
 	early_cpu_init();
 
-	/*
-	 * FIXME: This isn't an official loader_type right
-	 * now but does currently work with elilo.
-	 * If we were configured as an EFI kernel, check to make
-	 * sure that we were loaded correctly from elilo and that
-	 * the system table is valid.  If not, then initialize normally.
-	 */
 #ifdef CONFIG_EFI
-	if ((boot_params.hdr.type_of_loader == 0x50) &&
-	    boot_params.efi_info.efi_systab)
+	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+		     "EL32", 4))
 		efi_enabled = 1;
 #endif
 
diff -puN include/asm-x86/efi.h~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c include/asm-x86/efi.h
--- a/include/asm-x86/efi.h~x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c
+++ a/include/asm-x86/efi.h
@@ -2,6 +2,48 @@
 #define _ASM_X86_EFI_H
 
 #ifdef CONFIG_X86_32
+
+extern unsigned long asmlinkage efi_call_phys(void *, ...);
+
+#define efi_call_phys0(f)		efi_call_phys(f)
+#define efi_call_phys1(f, a1)		efi_call_phys(f, a1)
+#define efi_call_phys2(f, a1, a2)	efi_call_phys(f, a1, a2)
+#define efi_call_phys3(f, a1, a2, a3)	efi_call_phys(f, a1, a2, a3)
+#define efi_call_phys4(f, a1, a2, a3, a4)	\
+	efi_call_phys(f, a1, a2, a3, a4)
+#define efi_call_phys5(f, a1, a2, a3, a4, a5)	\
+	efi_call_phys(f, a1, a2, a3, a4, a5)
+#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)	\
+	efi_call_phys(f, a1, a2, a3, a4, a5, a6)
+/*
+ * Wrap all the virtual calls in a way that forces the parameters on the stack.
+ */
+
+#define efi_call_virt(f, args...) \
+     ((efi_##f##_t __attribute__((regparm(0)))*)efi.systab->runtime->f)(args)
+
+#define efi_call_virt0(f)		efi_call_virt(f)
+#define efi_call_virt1(f, a1)		efi_call_virt(f, a1)
+#define efi_call_virt2(f, a1, a2)	efi_call_virt(f, a1, a2)
+#define efi_call_virt3(f, a1, a2, a3)	efi_call_virt(f, a1, a2, a3)
+#define efi_call_virt4(f, a1, a2, a3, a4)	\
+	efi_call_virt(f, a1, a2, a3, a4)
+#define efi_call_virt5(f, a1, a2, a3, a4, a5)	\
+	efi_call_virt(f, a1, a2, a3, a4, a5)
+#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
+	efi_call_virt(f, a1, a2, a3, a4, a5, a6)
+/*
+ * We require an early boot_ioremap mapping mechanism initially
+ */
+extern void *boot_ioremap(unsigned long, unsigned long);
+
+#define efi_early_ioremap(addr, size)		boot_ioremap(addr, size)
+#define efi_early_iounmap(vaddr, size)
+
+#define efi_ioremap(addr, size)			ioremap(addr, size)
+
+#define end_pfn_map				max_low_pfn
+
 #else /* !CONFIG_X86_32 */
 
 #define MAX_EFI_IO_PAGES	100
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-boot-support-efi-frame-buffer.patch
x86_64-efi-boot-support-efi-boot-document.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
