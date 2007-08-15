From: akpm@linux-foundation.org
Subject: - x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch removed from -mm tree
Date: Wed, 15 Aug 2007 16:17:47 -0700
Message-ID: <200708152317.l7FNHlBJ020115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934046AbXHOXSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 19:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, adurbin@google.com, ak@suse.de, mouli@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 EFI runtime service support: EFI basic runtime service support
has been removed from the -mm tree.  Its filename was
     x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64 EFI runtime service support: EFI basic runtime service support
From: "Huang, Ying" <ying.huang@intel.com>

Add basic runtime services support for EFI x86_64 system.  The main file of
the patch is the addition of efi.c for x86_64.  This file is modeled after the
EFI IA32 avatar.  EFI runtime services initialization are implemented in
efi.c.  Some x86_64 specifics are worth noting here.  On x86_64, parameters
passed to UEFI firmware services need to follow the UEFI calling convention. 
For this purpose, a set of functions named lin2win<x> (<x> is the number of
parameters) are implemented.  EFI function calls are wrapped before calling
the firmware service.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Aaron Durbin <adurbin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/Kconfig               |   13 
 arch/x86_64/kernel/Makefile       |    1 
 arch/x86_64/kernel/efi.c          |  581 ++++++++++++++++++++++++++++
 arch/x86_64/kernel/efi_callwrap.S |   69 +++
 arch/x86_64/kernel/setup.c        |   15 
 include/asm-x86_64/bootsetup.h    |    6 
 include/asm-x86_64/eficallwrap.h  |   33 +
 include/asm-x86_64/efidef.h       |    6 
 include/asm-x86_64/fixmap.h       |    3 
 9 files changed, 726 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/Kconfig~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/arch/x86_64/Kconfig
@@ -268,6 +268,19 @@ config X86_HT
 	depends on SMP && !MK8
 	default y
 
+config EFI
+	bool "Boot from EFI support (EXPERIMENTAL)"
+	---help---
+	  This enables the the kernel to boot on EFI platforms using
+	  system configuration information passed to it from the firmware.
+	  This also enables the kernel to use any EFI runtime services that are
+	  available (such as the EFI variable services).
+	  This option is only useful on systems that have EFI firmware
+	  and will result in a kernel image that is ~8k larger. However,
+	  even with this option, the resultant kernel should continue to
+	  boot on existing non-EFI platforms. For more information on
+	  how to set up [U]EFI64 system, see Documentation/x86_64/uefi.txt.
+
 config MATH_EMULATION
 	bool
 
diff -puN arch/x86_64/kernel/Makefile~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support arch/x86_64/kernel/Makefile
--- a/arch/x86_64/kernel/Makefile~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/arch/x86_64/kernel/Makefile
@@ -26,6 +26,7 @@ obj-y				+= io_apic.o mpparse.o genapic.
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_PM)		+= suspend.o
+obj-$(CONFIG_EFI)		+= efi.o efi_callwrap.o
 obj-$(CONFIG_HIBERNATION)	+= suspend_asm.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
diff -puN /dev/null arch/x86_64/kernel/efi.c
--- /dev/null
+++ a/arch/x86_64/kernel/efi.c
@@ -0,0 +1,581 @@
+/*
+ * Extensible Firmware Interface
+ *
+ * Based on Extensible Firmware Interface Specification version 1.0
+ *
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond@valinux.com>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ *	David Mosberger-Tang <davidm@hpl.hp.com>
+ *	Stephane Eranian <eranian@hpl.hp.com>
+ * Copyright (C) 2005-2008 Intel Co.
+ *	Fenghua Yu <fenghua.yu@intel.com>
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Chandramouli Narayanan <mouli@linux.intel.com>
+ *
+ * Code to convert EFI to E820 map has been implemented in elilo bootloader
+ * based on a EFI patch by Edgar Hucek. Based on the E820 map, the page table
+ * is setup appropriately for EFI runtime code.
+ * - mouli 06/14/2007.
+ *
+ * All EFI Runtime Services are not implemented yet as EFI only
+ * supports physical mode addressing on SoftSDV. This is to be fixed
+ * in a future version.  --drummond 1999-07-20
+ *
+ * Implemented EFI runtime services and virtual mode calls.  --davidm
+ *
+ * Goutham Rao: <goutham.rao@intel.com>
+ *	Skip non-WB memory and ignore empty memory ranges.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/time.h>
+#include <linux/spinlock.h>
+#include <linux/bootmem.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/efi.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+#include <linux/reboot.h>
+
+#include <asm/setup.h>
+#include <asm/bootsetup.h>
+#include <asm/page.h>
+#include <asm/e820.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
+#include <asm/proto.h>
+#include <asm/eficallwrap.h>
+#include <asm/efidef.h>
+#include <asm/time.h>
+
+int efi_enabled;
+EXPORT_SYMBOL(efi_enabled);
+
+struct efi efi;
+EXPORT_SYMBOL(efi);
+
+struct efi_memory_map memmap;
+
+struct efi efi_phys __initdata;
+static efi_system_table_t efi_systab __initdata;
+static unsigned long efi_flags __initdata;
+/* efi_lock protects efi physical mode call */
+static spinlock_t efi_lock __initdata = SPIN_LOCK_UNLOCKED;
+static pgd_t save_pgd __initdata;
+static int noefi_time __initdata;
+
+static int __init setup_noefi(char *arg)
+{
+	efi_enabled = 0;
+	return 0;
+}
+early_param("noefi", setup_noefi);
+
+static int __init setup_noefi_time(char *arg)
+{
+	noefi_time = 1;
+	return 0;
+}
+early_param("noefi_time", setup_noefi_time);
+
+static efi_status_t _efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	return lin2win2((void *)efi.systab->runtime->get_time,
+			(u64)tm, (u64)tc);
+}
+
+static efi_status_t _efi_set_time(efi_time_t *tm)
+{
+	return lin2win1((void *)efi.systab->runtime->set_time, (u64)tm);
+}
+
+static efi_status_t _efi_get_wakeup_time(efi_bool_t *enabled,
+					 efi_bool_t *pending,
+					 efi_time_t *tm)
+{
+	return lin2win3((void *)efi.systab->runtime->get_wakeup_time,
+			(u64)enabled, (u64)pending, (u64)tm);
+}
+
+static efi_status_t _efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	return lin2win2((void *)efi.systab->runtime->set_wakeup_time,
+			(u64)enabled, (u64)tm);
+}
+
+static efi_status_t _efi_get_variable(efi_char16_t *name,
+				      efi_guid_t *vendor,
+				      u32 *attr,
+				      unsigned long *data_size,
+				      void *data)
+{
+	return lin2win5((void *)efi.systab->runtime->get_variable,
+			(u64)name, (u64)vendor, (u64)attr,
+			(u64)data_size, (u64)data);
+}
+
+static efi_status_t _efi_get_next_variable(unsigned long *name_size,
+					   efi_char16_t *name,
+					   efi_guid_t *vendor)
+{
+	return lin2win3((void *)efi.systab->runtime->get_next_variable,
+			(u64)name_size, (u64)name, (u64)vendor);
+}
+
+static efi_status_t _efi_set_variable(
+			efi_char16_t *name, efi_guid_t *vendor,
+			u64 attr, u64 data_size, void *data)
+{
+	return lin2win5((void *)efi.systab->runtime->set_variable,
+			(u64)name, (u64)vendor, (u64)attr,
+			(u64)data_size, (u64)data);
+}
+
+static efi_status_t _efi_get_next_high_mono_count(u32 *count)
+{
+	return lin2win1((void *)efi.systab->runtime->get_next_high_mono_count,
+			(u64)count);
+}
+
+static efi_status_t _efi_reset_system(int reset_type,
+				      efi_status_t status,
+				      unsigned long data_size,
+				      efi_char16_t *data)
+{
+	return lin2win4((void *)efi.systab->runtime->reset_system,
+			(u64)reset_type, (u64)status,
+			(u64)data_size, (u64)data);
+}
+
+static efi_status_t _efi_set_virtual_address_map(
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map)
+{
+	return lin2win4((void *)efi.systab->runtime->set_virtual_address_map,
+			(u64)memory_map_size, (u64)descriptor_size,
+			(u64)descriptor_version, (u64)virtual_map);
+}
+
+static void __init early_mapping_set_exec(unsigned long start,
+					  unsigned long end,
+					  int executable)
+{
+	pte_t *kpte;
+
+	while (start < end) {
+		kpte = lookup_address((unsigned long)__va(start));
+		BUG_ON(!kpte);
+		if (executable)
+			set_pte(kpte, pte_mkexec(*kpte));
+		else
+			set_pte(kpte, __pte((pte_val(*kpte) | _PAGE_NX) & \
+					    __supported_pte_mask));
+		if (pte_huge(*kpte))
+			start = (start + PMD_SIZE) & PMD_MASK;
+		else
+			start = (start + PAGE_SIZE) & PAGE_MASK;
+	}
+}
+
+static void __init early_runtime_code_mapping_set_exec(int executable)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	/* Make EFI runtime service code area executable */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (md->type == EFI_RUNTIME_SERVICES_CODE) {
+			unsigned long end;
+			end = md->phys_addr + (md->num_pages << PAGE_SHIFT);
+			early_mapping_set_exec(md->phys_addr, end, executable);
+		}
+	}
+}
+
+static void __init efi_call_phys_prelog(void) __acquires(efi_lock)
+{
+	unsigned long vaddress;
+
+	/*
+	 * Lock sequence is different from normal case because
+	 * efi_flags is global
+	 */
+	spin_lock(&efi_lock);
+	local_irq_save(efi_flags);
+	early_runtime_code_mapping_set_exec(1);
+	vaddress = (unsigned long)__va(0x0UL);
+	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
+	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
+	global_flush_tlb();
+}
+
+static void __init efi_call_phys_epilog(void) __releases(efi_lock)
+{
+	/*
+	 * After the lock is released, the original page table is restored.
+	 */
+	set_pgd(pgd_offset_k(0x0UL), save_pgd);
+	early_runtime_code_mapping_set_exec(0);
+	global_flush_tlb();
+	local_irq_restore(efi_flags);
+	spin_unlock(&efi_lock);
+}
+
+static efi_status_t __init phys_efi_set_virtual_address_map(
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = lin2win4((void *)efi_phys.set_virtual_address_map,
+			  (u64)memory_map_size, (u64)descriptor_size,
+			  (u64)descriptor_version, (u64)virtual_map);
+	efi_call_phys_epilog();
+	return status;
+}
+
+static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
+					     efi_time_cap_t *tc)
+{
+	efi_status_t status;
+
+	efi_call_phys_prelog();
+	status = lin2win2((void *)efi_phys.get_time, (u64)tm, (u64)tc);
+	efi_call_phys_epilog();
+	return status;
+}
+
+/*
+ * To call this function, the irq must be disabled and rtc_lock in
+ * time.c must be held.
+ */
+int efi_set_rtc_mmss(unsigned long nowtime)
+{
+	int real_seconds, real_minutes;
+	efi_status_t 	status;
+	efi_time_t 	eft;
+	efi_time_cap_t 	cap;
+
+	status = efi.get_time(&eft, &cap);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+		return -1;
+	}
+
+	real_seconds = nowtime % 60;
+	real_minutes = nowtime / 60;
+	if (((abs(real_minutes - eft.minute) + 15)/30) & 1)
+		real_minutes += 30;
+	real_minutes %= 60;
+	eft.minute = real_minutes;
+	eft.second = real_seconds;
+
+	status = efi.set_time(&eft);
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ERR "Oops: efitime: can't write time!\n");
+		return -1;
+	}
+	return 0;
+}
+
+/*
+ * To call this function, the irq must be disabled and rtc_lock in
+ * time.c must be held.
+ */
+unsigned long efi_get_time(void)
+{
+	efi_status_t status;
+	efi_time_t eft;
+	efi_time_cap_t cap;
+
+	status = efi.get_time(&eft, &cap);
+	if (status != EFI_SUCCESS)
+		printk(KERN_ERR "Oops: efitime: can't read time!\n");
+
+	return mktime(eft.year, eft.month, eft.day, eft.hour,
+		      eft.minute, eft.second);
+}
+
+void __init efi_init(void)
+{
+	efi_config_table_t *config_tables;
+	efi_runtime_services_t *runtime;
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i = 0;
+
+	memset(&efi, 0, sizeof(efi));
+	memset(&efi_phys, 0, sizeof(efi_phys));
+
+	efi_phys.systab = (efi_system_table_t *)EFI_SYSTAB;
+	memmap.phys_map = (void *)EFI_MEMMAP;
+	memmap.nr_map = EFI_MEMMAP_SIZE/EFI_MEMDESC_SIZE;
+	memmap.desc_version = EFI_MEMDESC_VERSION;
+	memmap.desc_size = EFI_MEMDESC_SIZE;
+
+	efi.systab = early_ioremap((unsigned long)efi_phys.systab,
+				   sizeof(efi_system_table_t));
+	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
+	efi.systab = &efi_systab;
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		printk(KERN_ERR "Woah! EFI system table "
+		       "signature incorrect\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_ERR "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater\n",
+		       efi.systab->hdr.revision >> 16,
+		       efi.systab->hdr.revision & 0xffff);
+
+	/*
+	 * Show what we know for posterity
+	 */
+	c16 = early_ioremap(efi.systab->fw_vendor, 2);
+	if (!probe_kernel_address(c16, i)) {
+		for (i = 0; i < sizeof(vendor) && *c16; ++i)
+			vendor[i] = *c16++;
+		vendor[i] = '\0';
+	}
+
+	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
+	       efi.systab->hdr.revision >> 16,
+	       efi.systab->hdr.revision & 0xffff, vendor);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables = early_ioremap(
+		efi.systab->tables,
+		efi.systab->nr_tables * sizeof(efi_config_table_t));
+	if (config_tables == NULL)
+		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
+
+	printk(KERN_INFO);
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
+			efi.mps = config_tables[i].table;
+			printk(" MPS=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					ACPI_20_TABLE_GUID)) {
+			efi.acpi20 = config_tables[i].table;
+			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					ACPI_TABLE_GUID)) {
+			efi.acpi = config_tables[i].table;
+			printk(" ACPI=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					SMBIOS_TABLE_GUID)) {
+			efi.smbios = config_tables[i].table;
+			printk(" SMBIOS=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					HCDP_TABLE_GUID)) {
+			efi.hcdp = config_tables[i].table;
+			printk(" HCDP=0x%lx ", config_tables[i].table);
+		} else if (!efi_guidcmp(config_tables[i].guid,
+					UGA_IO_PROTOCOL_GUID)) {
+			efi.uga = config_tables[i].table;
+			printk(" UGA=0x%lx ", config_tables[i].table);
+		}
+	}
+	printk("\n");
+
+	/*
+	 * Check out the runtime services table. We need to map
+	 * the runtime services table so that we can grab the physical
+	 * address of several of the EFI runtime functions, needed to
+	 * set the firmware into virtual mode.
+	 */
+	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+				sizeof(efi_runtime_services_t));
+	if (runtime != NULL) {
+		/*
+		 * We will only need *early* access to the following
+		 * two EFI runtime services before set_virtual_address_map
+		 * is invoked.
+		 */
+		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
+		efi_phys.set_virtual_address_map =
+			(efi_set_virtual_address_map_t *)runtime->set_virtual_address_map;
+		/*
+		 * Make efi_get_time can be called before entering
+		 * virtual mode.
+		 */
+		efi.get_time = phys_efi_get_time;
+	} else
+		printk(KERN_ERR "Could not map the EFI runtime service "
+		       "table!\n");
+
+	/* Map the EFI memory map */
+	memmap.map = __va((unsigned long)memmap.phys_map);
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+	if (EFI_MEMDESC_SIZE != sizeof(efi_memory_desc_t))
+		printk(KERN_WARNING "Kernel-defined memdesc"
+		       "doesn't match the one from EFI!\n");
+
+	/* Setup for EFI runtime service */
+	reboot_type = BOOT_EFI;
+
+	if (!noefi_time) {
+		get_wallclock = efi_get_time;
+		set_wallclock = efi_set_rtc_mmss;
+	}
+}
+
+static void __init runtime_code_page_mkexec(void)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	/* Make EFI runtime service code area executable */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			change_page_attr_addr(md->virt_addr,
+					      md->num_pages,
+					      PAGE_KERNEL_EXEC);
+	}
+	global_flush_tlb();
+}
+
+static void __iomem * __init efi_ioremap(unsigned long offset,
+					 unsigned long size)
+{
+	static unsigned pages_mapped;
+	unsigned long last_addr;
+	unsigned i, pages;
+
+	last_addr = offset + size - 1;
+	offset &= PAGE_MASK;
+	pages = (PAGE_ALIGN(last_addr) - offset) >> PAGE_SHIFT;
+	if (pages_mapped + pages > MAX_EFI_IO_PAGES)
+		return NULL;
+
+	for (i = 0; i < pages; i++) {
+		set_fixmap_nocache(FIX_EFI_IO_MAP_FIRST_PAGE - pages_mapped,
+				   offset);
+		offset += PAGE_SIZE;
+		pages_mapped++;
+	}
+
+	return (void __iomem *)__fix_to_virt(FIX_EFI_IO_MAP_FIRST_PAGE - \
+					     (pages_mapped - pages));
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor and update
+ * that memory descriptor with the virtual address obtained from ioremap().
+ * This enables the runtime services to be called without having to
+ * thunk back into physical mode for every invocation.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_memory_desc_t *md;
+	efi_status_t status;
+	unsigned long end;
+	void *p;
+
+	efi.systab = NULL;
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (md->attribute & EFI_MEMORY_WB)
+			md->virt_addr = (unsigned long)__va(md->phys_addr);
+		else if (md->attribute & (EFI_MEMORY_UC | EFI_MEMORY_WC))
+			md->virt_addr = (unsigned long)
+				efi_ioremap(md->phys_addr,
+					    md->num_pages << EFI_PAGE_SHIFT);
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
+		    ((unsigned long)efi_phys.systab < end))
+			efi.systab = (efi_system_table_t *)
+				(md->virt_addr - md->phys_addr +
+				 (unsigned long)efi_phys.systab);
+	}
+
+	BUG_ON(!efi.systab);
+
+	status = phys_efi_set_virtual_address_map(
+		memmap.desc_size * memmap.nr_map,
+		memmap.desc_size,
+		memmap.desc_version,
+		memmap.phys_map);
+
+	if (status != EFI_SUCCESS) {
+		printk(KERN_ALERT "You are screwed! "
+		       "Unable to switch EFI into virtual mode "
+		       "(status=%lx)\n", status);
+		panic("EFI call to SetVirtualAddressMap() failed!");
+	}
+
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Call EFI services through wrapper functions.
+	 */
+	efi.get_time = (efi_get_time_t *)_efi_get_time;
+	efi.set_time = (efi_set_time_t *)_efi_set_time;
+	efi.get_wakeup_time = (efi_get_wakeup_time_t *)_efi_get_wakeup_time;
+	efi.set_wakeup_time = (efi_set_wakeup_time_t *)_efi_set_wakeup_time;
+	efi.get_variable = (efi_get_variable_t *)_efi_get_variable;
+	efi.get_next_variable = (efi_get_next_variable_t *)
+		_efi_get_next_variable;
+	efi.set_variable = (efi_set_variable_t *)_efi_set_variable;
+	efi.get_next_high_mono_count = (efi_get_next_high_mono_count_t *)
+		_efi_get_next_high_mono_count;
+	efi.reset_system = (efi_reset_system_t *)_efi_reset_system;
+	efi.set_virtual_address_map = (efi_set_virtual_address_map_t *)
+		_efi_set_virtual_address_map;
+
+	runtime_code_page_mkexec();
+}
+
+/*
+ * Convenience functions to obtain memory types and attributes
+ */
+u32 efi_mem_type(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md->type;
+	}
+	return 0;
+}
+
+u64 efi_mem_attributes(unsigned long phys_addr)
+{
+	efi_memory_desc_t *md;
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		if ((md->phys_addr <= phys_addr) &&
+		    (phys_addr < (md->phys_addr +
+				  (md->num_pages << EFI_PAGE_SHIFT))))
+			return md->attribute;
+	}
+	return 0;
+}
diff -puN /dev/null arch/x86_64/kernel/efi_callwrap.S
--- /dev/null
+++ a/arch/x86_64/kernel/efi_callwrap.S
@@ -0,0 +1,69 @@
+/*
+ * linux/arch/x86_64/kernel/efi_callwrap.S -- Function calling ABI
+ *	conversion from SYSV to Windows for x86_64
+ *
+ * Copyright (C) 2007 Intel Corp
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ */
+
+#include <linux/linkage.h>
+
+ENTRY(lin2win0)
+	subq $40, %rsp
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win1)
+	subq $40, %rsp
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win2)
+	subq $40, %rsp
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win3)
+	subq $40, %rsp
+	mov  %rcx, %r8
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win4)
+	subq $40, %rsp
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win5)
+	subq $40, %rsp
+	mov %r9, 32(%rsp)
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $40, %rsp
+	ret
+
+ENTRY(lin2win6)
+	subq $56, %rsp
+	mov 56+8(%rsp), %rax
+	mov %r9, 32(%rsp)
+	mov %rax, 40(%rsp)
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $56, %rsp
+	ret
diff -puN arch/x86_64/kernel/setup.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support arch/x86_64/kernel/setup.c
--- a/arch/x86_64/kernel/setup.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/arch/x86_64/kernel/setup.c
@@ -44,6 +44,7 @@
 #include <linux/dmi.h>
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
+#include <linux/efi.h>
 
 #include <asm/mtrr.h>
 #include <asm/uaccess.h>
@@ -236,6 +237,10 @@ void __init setup_arch(char **cmdline_p)
 	rd_prompt = ((RAMDISK_FLAGS & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((RAMDISK_FLAGS & RAMDISK_LOAD_FLAG) != 0);
 #endif
+#ifdef CONFIG_EFI
+	if (!strncmp(EFI_LOADER_SIG, "EFIL", 4))
+		efi_enabled = 1;
+#endif
 	setup_memory_region();
 	copy_edd();
 
@@ -273,6 +278,8 @@ void __init setup_arch(char **cmdline_p)
 	discover_ebda();
 
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+	if (efi_enabled)
+		efi_init();
 
 	dmi_scan_machine();
 
@@ -360,6 +367,11 @@ void __init setup_arch(char **cmdline_p)
         */
        acpi_reserve_bootmem();
 #endif
+
+	/* Reserve efi memory map */
+	if (efi_enabled)
+		reserve_bootmem_generic(EFI_MEMMAP, EFI_MEMMAP_SIZE);
+
 	/*
 	 * Find and reserve possible boot-time SMP configuration:
 	 */
@@ -432,7 +444,8 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
+	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
diff -puN include/asm-x86_64/bootsetup.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support include/asm-x86_64/bootsetup.h
--- a/include/asm-x86_64/bootsetup.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/include/asm-x86_64/bootsetup.h
@@ -17,6 +17,12 @@ extern char x86_boot_params[BOOT_PARAM_S
 #define APM_BIOS_INFO (*(struct apm_bios_info *) (PARAM+0x40))
 #define DRIVE_INFO (*(struct drive_info_struct *) (PARAM+0x80))
 #define SYS_DESC_TABLE (*(struct sys_desc_table_struct*)(PARAM+0xa0))
+#define EFI_LOADER_SIG ((unsigned char *)(PARAM+0x1c0))
+#define EFI_MEMDESC_SIZE (*((unsigned int *) (PARAM+0x1c4)))
+#define EFI_MEMDESC_VERSION (*((unsigned int *) (PARAM+0x1c8)))
+#define EFI_MEMMAP_SIZE (*((unsigned int *) (PARAM+0x1cc)))
+#define EFI_MEMMAP (*((unsigned long *)(PARAM+0x1d0)))
+#define EFI_SYSTAB (*((unsigned long *)(PARAM+0x1d8)))
 #define MOUNT_ROOT_RDONLY (*(unsigned short *) (PARAM+0x1F2))
 #define RAMDISK_FLAGS (*(unsigned short *) (PARAM+0x1F8))
 #define SAVED_VIDEO_MODE (*(unsigned short *) (PARAM+0x1FA))
diff -puN /dev/null include/asm-x86_64/eficallwrap.h
--- /dev/null
+++ a/include/asm-x86_64/eficallwrap.h
@@ -0,0 +1,33 @@
+/*
+ *  Copyright (C) 2007 Intel Corp
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ *  Function calling ABI conversion from SYSV to Windows for x86_64
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#ifndef __ASM_X86_64_EFICALLWRAP_H
+#define __ASM_X86_64_EFICALLWRAP_H
+
+extern efi_status_t lin2win0(void *fp);
+extern efi_status_t lin2win1(void *fp, u64 arg1);
+extern efi_status_t lin2win2(void *fp, u64 arg1, u64 arg2);
+extern efi_status_t lin2win3(void *fp, u64 arg1, u64 arg2, u64 arg3);
+extern efi_status_t lin2win4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
+extern efi_status_t lin2win5(void *fp, u64 arg1, u64 arg2, u64 arg3,
+			     u64 arg4, u64 arg5);
+extern efi_status_t lin2win6(void *fp, u64 arg1, u64 arg2, u64 arg3,
+			     u64 arg4, u64 arg5, u64 arg6);
+
+#endif
diff -puN /dev/null include/asm-x86_64/efidef.h
--- /dev/null
+++ a/include/asm-x86_64/efidef.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_X86_64_EFIDEF_H
+#define __ASM_X86_64_EFIDEF_H
+
+#define MAX_EFI_IO_PAGES	100
+
+#endif
diff -puN include/asm-x86_64/fixmap.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support include/asm-x86_64/fixmap.h
--- a/include/asm-x86_64/fixmap.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/include/asm-x86_64/fixmap.h
@@ -15,6 +15,7 @@
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
+#include <asm/efidef.h>
 
 /*
  * Here we define all the compile-time 'special' virtual
@@ -41,6 +42,8 @@ enum fixed_addresses {
 	FIX_APIC_BASE,	/* local (CPU) APIC) -- required for SMP or not */
 	FIX_IO_APIC_BASE_0,
 	FIX_IO_APIC_BASE_END = FIX_IO_APIC_BASE_0 + MAX_IO_APICS-1,
+	FIX_EFI_IO_MAP_LAST_PAGE,
+	FIX_EFI_IO_MAP_FIRST_PAGE = FIX_EFI_IO_MAP_LAST_PAGE+MAX_EFI_IO_PAGES-1,
 	__end_of_fixed_addresses
 };
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-boot-support-efi-frame-buffer-driver.patch
x86_64-efi-boot-support-efi-boot-document.patch
