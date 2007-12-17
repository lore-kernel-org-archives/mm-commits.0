From: akpm@linux-foundation.org
Subject: - x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:41:01 -0800
Message-ID: <200712172341.lBHNf12f008349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48309 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937653AbXLQXw6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, mouli@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64 EFI runtime service support: EFI basic runtime service support
has been removed from the -mm tree.  Its filename was
     x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64 EFI runtime service support: EFI basic runtime service support
From: "Huang, Ying" <ying.huang@intel.com>

This patch adds basic runtime services support for EFI x86_64 system.  The
main file of the patch is the addition of efi_64.c for x86_64.  This file is
modeled after the EFI IA32 avatar.  EFI runtime services initialization are
implemented in efi_64.c.  Some x86_64 specifics are worth noting here.  On
x86_64, parameters passed to EFI firmware services need to follow the EFI
calling convention.  For this purpose, a set of functions named efi_call<x>
(<x> is the number of parameters) are implemented.  EFI function calls are
wrapped before calling the firmware service.  The duplicated code between
efi_32.c and efi_64.c is placed in efi.c to remove them from efi_32.c.

Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig              |    2 
 arch/x86/kernel/Makefile_64   |    1 
 arch/x86/kernel/efi.c         |  480 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/efi_64.c      |  163 ++++++++++
 arch/x86/kernel/efi_stub_64.S |  109 +++++++
 arch/x86/kernel/setup_64.c    |   17 +
 include/asm-x86/bootparam.h   |    5 
 include/asm-x86/efi.h         |   70 ++++
 include/asm-x86/fixmap_64.h   |    3 
 9 files changed, 846 insertions(+), 4 deletions(-)

diff -puN arch/x86/Kconfig~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/arch/x86/Kconfig
@@ -991,7 +991,7 @@ config MTRR
 config EFI
 	def_bool n
 	prompt "Boot from EFI support"
-	depends on X86_32 && ACPI
+	depends on ACPI
 	---help---
 	This enables the kernel to boot on EFI platforms using
 	system configuration information passed to it from the firmware.
diff -puN arch/x86/kernel/Makefile_64~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support arch/x86/kernel/Makefile_64
--- a/arch/x86/kernel/Makefile_64~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/arch/x86/kernel/Makefile_64
@@ -39,6 +39,7 @@ obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit_64.o
+obj-$(CONFIG_EFI)		+= efi.o efi_64.o efi_stub_64.o
 
 obj-$(CONFIG_MODULES)		+= module_64.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
diff -puN /dev/null arch/x86/kernel/efi.c
--- /dev/null
+++ a/arch/x86/kernel/efi.c
@@ -0,0 +1,480 @@
+/*
+ * Common EFI (Extensible Firmware Interface) support functions
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
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * Copied from efi_32.c to eliminate the duplicated code between EFI
+ * 32/64 support code. --ying 2007-10-26
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
+#include <linux/efi.h>
+#include <linux/bootmem.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/time.h>
+#include <linux/io.h>
+#include <linux/reboot.h>
+#include <linux/bcd.h>
+
+#include <asm/setup.h>
+#include <asm/efi.h>
+#include <asm/time.h>
+
+#define EFI_DEBUG	1
+#define PFX 		"EFI: "
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
+
+static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	return efi_call_virt2(get_time, tm, tc);
+}
+
+static efi_status_t virt_efi_set_time(efi_time_t *tm)
+{
+	return efi_call_virt1(set_time, tm);
+}
+
+static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
+					     efi_bool_t *pending,
+					     efi_time_t *tm)
+{
+	return efi_call_virt3(get_wakeup_time,
+			      enabled, pending, tm);
+}
+
+static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	return efi_call_virt2(set_wakeup_time,
+			      enabled, tm);
+}
+
+static efi_status_t virt_efi_get_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 *attr,
+					  unsigned long *data_size,
+					  void *data)
+{
+	return efi_call_virt5(get_variable,
+			      name, vendor, attr,
+			      data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
+					       efi_char16_t *name,
+					       efi_guid_t *vendor)
+{
+	return efi_call_virt3(get_next_variable,
+			      name_size, name, vendor);
+}
+
+static efi_status_t virt_efi_set_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  unsigned long attr,
+					  unsigned long data_size,
+					  void *data)
+{
+	return efi_call_virt5(set_variable,
+			      name, vendor, attr,
+			      data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
+{
+	return efi_call_virt1(get_next_high_mono_count, count);
+}
+
+static void virt_efi_reset_system(int reset_type,
+				  efi_status_t status,
+				  unsigned long data_size,
+				  efi_char16_t *data)
+{
+	efi_call_virt4(reset_system, reset_type, status,
+		       data_size, data);
+}
+
+static efi_status_t virt_efi_set_virtual_address_map(
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map)
+{
+	return efi_call_virt4(set_virtual_address_map,
+			      memory_map_size, descriptor_size,
+			      descriptor_version, virtual_map);
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
+	status = efi_call_phys4(efi_phys.set_virtual_address_map,
+				memory_map_size, descriptor_size,
+				descriptor_version, virtual_map);
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
+	status = efi_call_phys2(efi_phys.get_time, tm, tc);
+	efi_call_phys_epilog();
+	return status;
+}
+
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
+#if EFI_DEBUG
+static void __init print_efi_memmap(void)
+{
+	efi_memory_desc_t *md;
+	void *p;
+	int i;
+
+	for (p = memmap.map, i = 0;
+	     p < memmap.map_end;
+	     p += memmap.desc_size, i++) {
+		md = p;
+		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
+			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+			i, md->type, md->attribute, md->phys_addr,
+			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+	}
+}
+#endif  /*  EFI_DEBUG  */
+
+void __init efi_init(void)
+{
+	efi_config_table_t *config_tables;
+	efi_runtime_services_t *runtime;
+	efi_char16_t *c16;
+	char vendor[100] = "unknown";
+	int i = 0;
+	void *tmp;
+
+#ifdef CONFIG_X86_32
+	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
+	memmap.phys_map = (void *)boot_params.efi_info.efi_memmap;
+#else
+	efi_phys.systab = (efi_system_table_t *)
+		(boot_params.efi_info.efi_systab |
+		 ((__u64)boot_params.efi_info.efi_systab_hi<<32));
+	memmap.phys_map = (void *)
+		(boot_params.efi_info.efi_memmap |
+		 ((__u64)boot_params.efi_info.efi_memmap_hi<<32));
+#endif
+	memmap.nr_map = boot_params.efi_info.efi_memmap_size /
+		boot_params.efi_info.efi_memdesc_size;
+	memmap.desc_version = boot_params.efi_info.efi_memdesc_version;
+	memmap.desc_size = boot_params.efi_info.efi_memdesc_size;
+
+	efi.systab = efi_early_ioremap((unsigned long)efi_phys.systab,
+				       sizeof(efi_system_table_t));
+	if (efi.systab == NULL)
+		printk(KERN_ERR "Couldn't map the EFI system table!\n");
+	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
+	efi_early_iounmap(efi.systab, sizeof(efi_system_table_t));
+	efi.systab = &efi_systab;
+
+	/*
+	 * Verify the EFI Table
+	 */
+	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
+		printk(KERN_ERR "EFI system table signature incorrect!\n");
+	if ((efi.systab->hdr.revision >> 16) == 0)
+		printk(KERN_ERR "Warning: EFI system table version "
+		       "%d.%02d, expected 1.00 or greater!\n",
+		       efi.systab->hdr.revision >> 16,
+		       efi.systab->hdr.revision & 0xffff);
+
+	/*
+	 * Show what we know for posterity
+	 */
+	c16 = tmp = efi_early_ioremap(efi.systab->fw_vendor, 2);
+	if (c16) {
+		for (i = 0; i < sizeof(vendor) && *c16; ++i)
+			vendor[i] = *c16++;
+		vendor[i] = '\0';
+	} else
+		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
+	efi_early_iounmap(tmp, 2);
+
+	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
+	       efi.systab->hdr.revision >> 16,
+	       efi.systab->hdr.revision & 0xffff, vendor);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables = efi_early_ioremap(
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
+	efi_early_iounmap(config_tables,
+			  efi.systab->nr_tables * sizeof(efi_config_table_t));
+
+	/*
+	 * Check out the runtime services table. We need to map
+	 * the runtime services table so that we can grab the physical
+	 * address of several of the EFI runtime functions, needed to
+	 * set the firmware into virtual mode.
+	 */
+	runtime = efi_early_ioremap((unsigned long)efi.systab->runtime,
+				    sizeof(efi_runtime_services_t));
+	if (runtime != NULL) {
+		/*
+		 * We will only need *early* access to the following
+		 * two EFI runtime services before set_virtual_address_map
+		 * is invoked.
+		 */
+		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
+		efi_phys.set_virtual_address_map =
+			(efi_set_virtual_address_map_t *)
+			runtime->set_virtual_address_map;
+		/*
+		 * Make efi_get_time can be called before entering
+		 * virtual mode.
+		 */
+		efi.get_time = phys_efi_get_time;
+	} else
+		printk(KERN_ERR "Could not map the EFI runtime service "
+		       "table!\n");
+	efi_early_iounmap(runtime, sizeof(efi_runtime_services_t));
+
+	/* Map the EFI memory map */
+	memmap.map = efi_early_ioremap((unsigned long)memmap.phys_map,
+				       memmap.nr_map * memmap.desc_size);
+	if (memmap.map == NULL)
+		printk(KERN_ERR "Could not map the EFI memory map!\n");
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+	if (memmap.desc_size != sizeof(efi_memory_desc_t))
+		printk(KERN_WARNING "Kernel-defined memdesc"
+		       "doesn't match the one from EFI!\n");
+
+#ifdef CONFIG_X86_64
+	/* Setup for EFI runtime service */
+	reboot_type = BOOT_EFI;
+
+#endif
+#if EFI_DEBUG
+	print_efi_memmap();
+#endif
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
+		if ((md->attribute & EFI_MEMORY_WB) &&
+		    (((md->phys_addr + (md->num_pages<<EFI_PAGE_SHIFT)) >>
+		      PAGE_SHIFT) < end_pfn_map))
+			md->virt_addr = (unsigned long)__va(md->phys_addr);
+		else
+			md->virt_addr = (unsigned long)
+				efi_ioremap(md->phys_addr,
+					    md->num_pages << EFI_PAGE_SHIFT);
+		if (!md->virt_addr)
+			printk(KERN_ERR PFX "ioremap of 0x%llX failed!\n",
+			       (unsigned long long)md->phys_addr);
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT);
+		if ((md->phys_addr <= (unsigned long)efi_phys.systab) &&
+		    ((unsigned long)efi_phys.systab < end))
+			efi.systab = (efi_system_table_t *)(unsigned long)
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
+		printk(KERN_ALERT "Unable to switch EFI into virtual mode "
+		       "(status=%lx)!\n", status);
+		panic("EFI call to SetVirtualAddressMap() failed!");
+	}
+
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Call EFI services through wrapper functions.
+	 */
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
+	efi.set_virtual_address_map = virt_efi_set_virtual_address_map;
+#ifdef CONFIG_X86_64
+	runtime_code_page_mkexec();
+#endif
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
diff -puN /dev/null arch/x86/kernel/efi_64.c
--- /dev/null
+++ a/arch/x86/kernel/efi_64.c
@@ -0,0 +1,163 @@
+/*
+ * x86_64 specific EFI support functions
+ * Based on Extensible Firmware Interface Specification version 1.0
+ *
+ * Copyright (C) 2005-2008 Intel Co.
+ *	Fenghua Yu <fenghua.yu@intel.com>
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Chandramouli Narayanan <mouli@linux.intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * Code to convert EFI to E820 map has been implemented in elilo bootloader
+ * based on a EFI patch by Edgar Hucek. Based on the E820 map, the page table
+ * is setup appropriately for EFI runtime code.
+ * - mouli 06/14/2007.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/types.h>
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
+#include <asm/page.h>
+#include <asm/e820.h>
+#include <asm/pgtable.h>
+#include <asm/tlbflush.h>
+#include <asm/cacheflush.h>
+#include <asm/proto.h>
+#include <asm/efi.h>
+
+static pgd_t save_pgd __initdata;
+static unsigned long efi_flags __initdata;
+
+static int __init setup_noefi(char *arg)
+{
+	efi_enabled = 0;
+	return 0;
+}
+early_param("noefi", setup_noefi);
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
+void __init efi_call_phys_prelog(void)
+{
+	unsigned long vaddress;
+
+	local_irq_save(efi_flags);
+	early_runtime_code_mapping_set_exec(1);
+	vaddress = (unsigned long)__va(0x0UL);
+	pgd_val(save_pgd) = pgd_val(*pgd_offset_k(0x0UL));
+	set_pgd(pgd_offset_k(0x0UL), *pgd_offset_k(vaddress));
+	__flush_tlb_all();
+}
+
+void __init efi_call_phys_epilog(void)
+{
+	/*
+	 * After the lock is released, the original page table is restored.
+	 */
+	set_pgd(pgd_offset_k(0x0UL), save_pgd);
+	early_runtime_code_mapping_set_exec(0);
+	__flush_tlb_all();
+	local_irq_restore(efi_flags);
+}
+
+/*
+ * We need to map the EFI memory map again after init_memory_mapping().
+ */
+void __init efi_map_memmap(void)
+{
+	memmap.map = __va(memmap.phys_map);
+	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
+}
+
+void __init efi_reserve_bootmem(void)
+{
+	reserve_bootmem_generic((unsigned long)memmap.phys_map,
+				memmap.nr_map * memmap.desc_size);
+}
+
+void __init runtime_code_page_mkexec(void)
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
+	__flush_tlb_all();
+}
+
+void __iomem * __init efi_ioremap(unsigned long offset,
+				  unsigned long size)
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
diff -puN /dev/null arch/x86/kernel/efi_stub_64.S
--- /dev/null
+++ a/arch/x86/kernel/efi_stub_64.S
@@ -0,0 +1,109 @@
+/*
+ * Function calling ABI conversion from Linux to EFI for x86_64
+ *
+ * Copyright (C) 2007 Intel Corp
+ *	Bibo Mao <bibo.mao@intel.com>
+ *	Huang Ying <ying.huang@intel.com>
+ */
+
+#include <linux/linkage.h>
+
+#define SAVE_XMM			\
+	mov %rsp, %rax;			\
+	subq $0x70, %rsp;		\
+	and $~0xf, %rsp;		\
+	mov %rax, (%rsp);		\
+	mov %cr0, %rax;			\
+	clts;				\
+	mov %rax, 0x8(%rsp);		\
+	movaps %xmm0, 0x60(%rsp);	\
+	movaps %xmm1, 0x50(%rsp);	\
+	movaps %xmm2, 0x40(%rsp);	\
+	movaps %xmm3, 0x30(%rsp);	\
+	movaps %xmm4, 0x20(%rsp);	\
+	movaps %xmm5, 0x10(%rsp)
+
+#define RESTORE_XMM			\
+	movaps 0x60(%rsp), %xmm0;	\
+	movaps 0x50(%rsp), %xmm1;	\
+	movaps 0x40(%rsp), %xmm2;	\
+	movaps 0x30(%rsp), %xmm3;	\
+	movaps 0x20(%rsp), %xmm4;	\
+	movaps 0x10(%rsp), %xmm5;	\
+	mov 0x8(%rsp), %rsi;		\
+	mov %rsi, %cr0;			\
+	mov (%rsp), %rsp
+
+ENTRY(efi_call0)
+	SAVE_XMM
+	subq $32, %rsp
+	call *%rdi
+	addq $32, %rsp
+	RESTORE_XMM
+	ret
+
+ENTRY(efi_call1)
+	SAVE_XMM
+	subq $32, %rsp
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $32, %rsp
+	RESTORE_XMM
+	ret
+
+ENTRY(efi_call2)
+	SAVE_XMM
+	subq $32, %rsp
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $32, %rsp
+	RESTORE_XMM
+	ret
+
+ENTRY(efi_call3)
+	SAVE_XMM
+	subq $32, %rsp
+	mov  %rcx, %r8
+	mov  %rsi, %rcx
+	call *%rdi
+	addq $32, %rsp
+	RESTORE_XMM
+	ret
+
+ENTRY(efi_call4)
+	SAVE_XMM
+	subq $32, %rsp
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $32, %rsp
+	RESTORE_XMM
+	ret
+
+ENTRY(efi_call5)
+	SAVE_XMM
+	subq $48, %rsp
+	mov %r9, 32(%rsp)
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $48, %rsp
+	RESTORE_XMM
+	ret
+
+ENTRY(efi_call6)
+	SAVE_XMM
+	mov (%rsp), %rax
+	mov 8(%rax), %rax
+	subq $48, %rsp
+	mov %r9, 32(%rsp)
+	mov %rax, 40(%rsp)
+	mov %r8, %r9
+	mov %rcx, %r8
+	mov %rsi, %rcx
+	call *%rdi
+	addq $48, %rsp
+	RESTORE_XMM
+	ret
diff -puN arch/x86/kernel/setup_64.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/arch/x86/kernel/setup_64.c
@@ -30,6 +30,7 @@
 #include <linux/crash_dump.h>
 #include <linux/root_dev.h>
 #include <linux/pci.h>
+#include <linux/efi.h>
 #include <linux/acpi.h>
 #include <linux/kallsyms.h>
 #include <linux/edd.h>
@@ -299,6 +300,11 @@ void __init setup_arch(char **cmdline_p)
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
+#ifdef CONFIG_EFI
+	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+		     "EL64", 4))
+		efi_enabled = 1;
+#endif
 
 	ARCH_SETUP
 
@@ -341,6 +347,8 @@ void __init setup_arch(char **cmdline_p)
 	discover_ebda();
 
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+	if (efi_enabled)
+		efi_init();
 
 	dmi_scan_machine();
 
@@ -412,6 +420,12 @@ void __init setup_arch(char **cmdline_p)
 	 */
        acpi_reserve_bootmem();
 #endif
+
+	if (efi_enabled) {
+		efi_map_memmap();
+		efi_reserve_bootmem();
+	}
+
        /*
 	* Find and reserve possible boot-time SMP configuration:
 	*/
@@ -477,7 +491,8 @@ void __init setup_arch(char **cmdline_p)
 
 #ifdef CONFIG_VT
 #if defined(CONFIG_VGA_CONSOLE)
-	conswitchp = &vga_con;
+	if (!efi_enabled || (efi_mem_type(0xa0000) != EFI_CONVENTIONAL_MEMORY))
+		conswitchp = &vga_con;
 #elif defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
diff -puN include/asm-x86/bootparam.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support include/asm-x86/bootparam.h
--- a/include/asm-x86/bootparam.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/include/asm-x86/bootparam.h
@@ -54,13 +54,14 @@ struct sys_desc_table {
 };
 
 struct efi_info {
-	__u32 _pad1;
+	__u32 efi_loader_signature;
 	__u32 efi_systab;
 	__u32 efi_memdesc_size;
 	__u32 efi_memdesc_version;
 	__u32 efi_memmap;
 	__u32 efi_memmap_size;
-	__u32 _pad2[2];
+	__u32 efi_systab_hi;
+	__u32 efi_memmap_hi;
 };
 
 /* The so-called "zeropage" */
diff -puN /dev/null include/asm-x86/efi.h
--- /dev/null
+++ a/include/asm-x86/efi.h
@@ -0,0 +1,70 @@
+#ifndef _ASM_X86_EFI_H
+#define _ASM_X86_EFI_H
+
+#ifdef CONFIG_X86_32
+#else /* !CONFIG_X86_32 */
+
+#define MAX_EFI_IO_PAGES	100
+
+extern u64 efi_call0(void *fp);
+extern u64 efi_call1(void *fp, u64 arg1);
+extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
+extern u64 efi_call3(void *fp, u64 arg1, u64 arg2, u64 arg3);
+extern u64 efi_call4(void *fp, u64 arg1, u64 arg2, u64 arg3, u64 arg4);
+extern u64 efi_call5(void *fp, u64 arg1, u64 arg2, u64 arg3,
+		     u64 arg4, u64 arg5);
+extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
+		     u64 arg4, u64 arg5, u64 arg6);
+
+#define efi_call_phys0(f)			\
+	efi_call0((void *)(f))
+#define efi_call_phys1(f, a1)			\
+	efi_call1((void *)(f), (u64)(a1))
+#define efi_call_phys2(f, a1, a2)			\
+	efi_call2((void *)(f), (u64)(a1), (u64)(a2))
+#define efi_call_phys3(f, a1, a2, a3)				\
+	efi_call3((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3))
+#define efi_call_phys4(f, a1, a2, a3, a4)				\
+	efi_call4((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+		  (u64)(a4))
+#define efi_call_phys5(f, a1, a2, a3, a4, a5)				\
+	efi_call5((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+		  (u64)(a4), (u64)(a5))
+#define efi_call_phys6(f, a1, a2, a3, a4, a5, a6)			\
+	efi_call6((void *)(f), (u64)(a1), (u64)(a2), (u64)(a3),		\
+		  (u64)(a4), (u64)(a5), (u64)(a6))
+
+#define efi_call_virt0(f)				\
+	efi_call0((void *)(efi.systab->runtime->f))
+#define efi_call_virt1(f, a1)					\
+	efi_call1((void *)(efi.systab->runtime->f), (u64)(a1))
+#define efi_call_virt2(f, a1, a2)					\
+	efi_call2((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
+#define efi_call_virt3(f, a1, a2, a3)					\
+	efi_call3((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+		  (u64)(a3))
+#define efi_call_virt4(f, a1, a2, a3, a4)				\
+	efi_call4((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+		  (u64)(a3), (u64)(a4))
+#define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
+	efi_call5((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+		  (u64)(a3), (u64)(a4), (u64)(a5))
+#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
+	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
+
+#define efi_early_ioremap(addr, size)		early_ioremap(addr, size)
+#define efi_early_iounmap(vaddr, size)		early_iounmap(vaddr, size)
+
+extern void *efi_ioremap(unsigned long offset, unsigned long size);
+
+extern int efi_time;
+
+#endif /* CONFIG_X86_32 */
+
+extern void efi_reserve_bootmem(void);
+extern void efi_call_phys_prelog(void);
+extern void efi_call_phys_epilog(void);
+extern void runtime_code_page_mkexec(void);
+
+#endif
diff -puN include/asm-x86/fixmap_64.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support include/asm-x86/fixmap_64.h
--- a/include/asm-x86/fixmap_64.h~x86_64-efi-runtime-service-support-efi-basic-runtime-service-support
+++ a/include/asm-x86/fixmap_64.h
@@ -15,6 +15,7 @@
 #include <asm/apicdef.h>
 #include <asm/page.h>
 #include <asm/vsyscall.h>
+#include <asm/efi.h>
 
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

git-x86.patch
vmcoreinfo-add-the-array-length-of-free_list-for-filtering-free-pages.patch
