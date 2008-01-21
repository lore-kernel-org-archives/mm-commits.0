From: akpm@linux-foundation.org
Subject: - efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch removed from -mm tree
Date: Mon, 21 Jan 2008 15:08:50 -0800
Message-ID: <200801212308.m0LN8orO024693@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYAUXJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jan 2008 18:09:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     EFI: split EFI tables parsing code from EFI runtime service support code
has been removed from the -mm tree.  Its filename was
     efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch

This patch was dropped because git-x86 changes trashed it

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: EFI: split EFI tables parsing code from EFI runtime service support code
From: "Huang, Ying" <ying.huang@intel.com>

Split EFI tables parsing code from EFI runtime service support code.  This
makes ACPI support and DMI support on EFI platform not depend on EFI
runtime service support.  Both EFI32 and EFI64 tables parsing functions are
provided on i386 and x86_64.  This makes it possible to use EFI information
in i386 kernel on x86_64 with EFI64 firmware or in x86_64 kernel on x86_64
with EFI32 firmware.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/acpi.c      |    6 -
 arch/ia64/kernel/efi.c       |   30 +++---
 arch/ia64/kernel/setup.c     |    2 
 arch/ia64/sn/kernel/setup.c  |    4 
 arch/x86/Kconfig             |    4 
 arch/x86/kernel/Makefile     |    1 
 arch/x86/kernel/efi.c        |  115 ++++++--------------------
 arch/x86/kernel/efi_tables.c |  144 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_32.c   |    9 +-
 arch/x86/kernel/setup_64.c   |    9 +-
 drivers/acpi/osl.c           |   11 +-
 drivers/firmware/dmi_scan.c  |    7 -
 drivers/firmware/efivars.c   |   53 ++++++------
 drivers/firmware/pcdp.c      |    6 -
 include/asm-ia64/setup.h     |    5 +
 include/asm-ia64/sn/sn_sal.h |    2 
 include/asm-x86/efi.h        |    7 +
 include/asm-x86/setup.h      |    9 ++
 include/linux/efi.h          |   64 ++++++++++++--
 19 files changed, 331 insertions(+), 157 deletions(-)

diff -puN arch/ia64/kernel/acpi.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/ia64/kernel/acpi.c
@@ -74,9 +74,9 @@ static unsigned long __init acpi_find_rs
 {
 	unsigned long rsdp_phys = 0;
 
-	if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
-		rsdp_phys = efi.acpi20;
-	else if (efi.acpi != EFI_INVALID_TABLE_ADDR)
+	if (efi_tables.acpi20 != EFI_INVALID_TABLE_ADDR)
+		rsdp_phys = efi_tables.acpi20;
+	else if (efi_tables.acpi != EFI_INVALID_TABLE_ADDR)
 		printk(KERN_WARNING PREFIX
 		       "v1.0/r0.71 tables no longer supported\n");
 	return rsdp_phys;
diff -puN arch/ia64/kernel/efi.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/ia64/kernel/efi.c
@@ -43,6 +43,8 @@ extern efi_status_t efi_call_phys (void 
 
 struct efi efi;
 EXPORT_SYMBOL(efi);
+struct efi_tables efi_tables;
+EXPORT_SYMBOL_GPL(efi_tables);
 static efi_runtime_services_t *runtime;
 static unsigned long mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
 
@@ -466,33 +468,33 @@ efi_init (void)
 	printk(KERN_INFO "EFI v%u.%.02u by %s:",
 	       efi.systab->hdr.revision >> 16, efi.systab->hdr.revision & 0xffff, vendor);
 
-	efi.mps        = EFI_INVALID_TABLE_ADDR;
-	efi.acpi       = EFI_INVALID_TABLE_ADDR;
-	efi.acpi20     = EFI_INVALID_TABLE_ADDR;
-	efi.smbios     = EFI_INVALID_TABLE_ADDR;
-	efi.sal_systab = EFI_INVALID_TABLE_ADDR;
-	efi.boot_info  = EFI_INVALID_TABLE_ADDR;
-	efi.hcdp       = EFI_INVALID_TABLE_ADDR;
-	efi.uga        = EFI_INVALID_TABLE_ADDR;
+	efi_tables.mps        = EFI_INVALID_TABLE_ADDR;
+	efi_tables.acpi       = EFI_INVALID_TABLE_ADDR;
+	efi_tables.acpi20     = EFI_INVALID_TABLE_ADDR;
+	efi_tables.smbios     = EFI_INVALID_TABLE_ADDR;
+	efi_tables.sal_systab = EFI_INVALID_TABLE_ADDR;
+	efi_tables.boot_info  = EFI_INVALID_TABLE_ADDR;
+	efi_tables.hcdp       = EFI_INVALID_TABLE_ADDR;
+	efi_tables.uga        = EFI_INVALID_TABLE_ADDR;
 
 	for (i = 0; i < (int) efi.systab->nr_tables; i++) {
 		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) == 0) {
-			efi.mps = config_tables[i].table;
+			efi_tables.mps = config_tables[i].table;
 			printk(" MPS=0x%lx", config_tables[i].table);
 		} else if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) == 0) {
-			efi.acpi20 = config_tables[i].table;
+			efi_tables.acpi20 = config_tables[i].table;
 			printk(" ACPI 2.0=0x%lx", config_tables[i].table);
 		} else if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) == 0) {
-			efi.acpi = config_tables[i].table;
+			efi_tables.acpi = config_tables[i].table;
 			printk(" ACPI=0x%lx", config_tables[i].table);
 		} else if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) == 0) {
-			efi.smbios = config_tables[i].table;
+			efi_tables.smbios = config_tables[i].table;
 			printk(" SMBIOS=0x%lx", config_tables[i].table);
 		} else if (efi_guidcmp(config_tables[i].guid, SAL_SYSTEM_TABLE_GUID) == 0) {
-			efi.sal_systab = config_tables[i].table;
+			efi_tables.sal_systab = config_tables[i].table;
 			printk(" SALsystab=0x%lx", config_tables[i].table);
 		} else if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) == 0) {
-			efi.hcdp = config_tables[i].table;
+			efi_tables.hcdp = config_tables[i].table;
 			printk(" HCDP=0x%lx", config_tables[i].table);
 		}
 	}
diff -puN arch/ia64/kernel/setup.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/ia64/kernel/setup.c
--- a/arch/ia64/kernel/setup.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/ia64/kernel/setup.c
@@ -503,7 +503,7 @@ setup_arch (char **cmdline_p)
 	find_memory();
 
 	/* process SAL system table: */
-	ia64_sal_init(__va(efi.sal_systab));
+	ia64_sal_init(__va(efi_tables.sal_systab));
 
 #ifdef CONFIG_SMP
 	cpu_physical_id(0) = hard_smp_processor_id();
diff -puN arch/ia64/sn/kernel/setup.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/ia64/sn/kernel/setup.c
--- a/arch/ia64/sn/kernel/setup.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/ia64/sn/kernel/setup.c
@@ -323,10 +323,10 @@ sn_scan_pcdp(void)
 	struct pcdp_interface_pci if_pci;
 	extern struct efi efi;
 
-	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
+	if (efi_tables.hcdp == EFI_INVALID_TABLE_ADDR)
 		return;		/* no hcdp/pcdp table */
 
-	pcdp = __va(efi.hcdp);
+	pcdp = __va(efi_tables.hcdp);
 
 	if (pcdp->rev < 3)
 		return;		/* only support PCDP (rev >= 3) */
diff -puN arch/x86/Kconfig~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/x86/Kconfig
--- a/arch/x86/Kconfig~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/x86/Kconfig
@@ -1029,11 +1029,9 @@ config IRQBALANCE
 	  The default yes will allow the kernel to do irq load balancing.
 	  Saying no will keep the kernel from doing irq load balancing.
 
-# turning this on wastes a bunch of space.
-# Summit needs it only when NUMA is on
 config BOOT_IOREMAP
 	def_bool y
-	depends on X86_32 && (((X86_SUMMIT || X86_GENERICARCH) && NUMA) || (X86 && EFI))
+	depends on X86_32
 
 config SECCOMP
 	def_bool y
diff -puN arch/x86/kernel/Makefile~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/x86/kernel/Makefile
@@ -24,6 +24,7 @@ obj-y			+= tsc_$(BITS).o io_delay.o rtc.
 obj-y				+= i387.o
 obj-y				+= ptrace.o
 obj-y				+= ds.o
+obj-y				+= efi_tables.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
diff -puN arch/x86/kernel/efi.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/x86/kernel/efi.c
--- a/arch/x86/kernel/efi.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/x86/kernel/efi.c
@@ -45,10 +45,10 @@
 #define PFX 		"EFI: "
 
 int efi_enabled;
-EXPORT_SYMBOL(efi_enabled);
+EXPORT_SYMBOL_GPL(efi_enabled);
 
 struct efi efi;
-EXPORT_SYMBOL(efi);
+EXPORT_SYMBOL_GPL(efi);
 
 struct efi_memory_map memmap;
 
@@ -233,12 +233,7 @@ static void __init print_efi_memmap(void
 
 void __init efi_init(void)
 {
-	efi_config_table_t *config_tables;
 	efi_runtime_services_t *runtime;
-	efi_char16_t *c16;
-	char vendor[100] = "unknown";
-	int i = 0;
-	void *tmp;
 
 #ifdef CONFIG_X86_32
 	efi_phys.systab = (efi_system_table_t *)boot_params.efi_info.efi_systab;
@@ -258,78 +253,21 @@ void __init efi_init(void)
 
 	efi.systab = efi_early_ioremap((unsigned long)efi_phys.systab,
 				       sizeof(efi_system_table_t));
-	if (efi.systab == NULL)
+	if (efi.systab == NULL) {
 		printk(KERN_ERR "Couldn't map the EFI system table!\n");
+		goto error;
+	}
 	memcpy(&efi_systab, efi.systab, sizeof(efi_system_table_t));
 	efi_early_iounmap(efi.systab, sizeof(efi_system_table_t));
 	efi.systab = &efi_systab;
 
 	/*
-	 * Verify the EFI Table
+	 * Verify the EFI System Table
 	 */
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
-		printk(KERN_ERR "EFI system table signature incorrect!\n");
+		goto error;
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		printk(KERN_ERR "Warning: EFI system table version "
-		       "%d.%02d, expected 1.00 or greater!\n",
-		       efi.systab->hdr.revision >> 16,
-		       efi.systab->hdr.revision & 0xffff);
-
-	/*
-	 * Show what we know for posterity
-	 */
-	c16 = tmp = efi_early_ioremap(efi.systab->fw_vendor, 2);
-	if (c16) {
-		for (i = 0; i < sizeof(vendor) && *c16; ++i)
-			vendor[i] = *c16++;
-		vendor[i] = '\0';
-	} else
-		printk(KERN_ERR PFX "Could not map the firmware vendor!\n");
-	efi_early_iounmap(tmp, 2);
-
-	printk(KERN_INFO "EFI v%u.%.02u by %s \n",
-	       efi.systab->hdr.revision >> 16,
-	       efi.systab->hdr.revision & 0xffff, vendor);
-
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables = efi_early_ioremap(
-		efi.systab->tables,
-		efi.systab->nr_tables * sizeof(efi_config_table_t));
-	if (config_tables == NULL)
-		printk(KERN_ERR "Could not map EFI Configuration Table!\n");
-
-	printk(KERN_INFO);
-	for (i = 0; i < efi.systab->nr_tables; i++) {
-		if (!efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID)) {
-			efi.mps = config_tables[i].table;
-			printk(" MPS=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_20_TABLE_GUID)) {
-			efi.acpi20 = config_tables[i].table;
-			printk(" ACPI 2.0=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					ACPI_TABLE_GUID)) {
-			efi.acpi = config_tables[i].table;
-			printk(" ACPI=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					SMBIOS_TABLE_GUID)) {
-			efi.smbios = config_tables[i].table;
-			printk(" SMBIOS=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					HCDP_TABLE_GUID)) {
-			efi.hcdp = config_tables[i].table;
-			printk(" HCDP=0x%lx ", config_tables[i].table);
-		} else if (!efi_guidcmp(config_tables[i].guid,
-					UGA_IO_PROTOCOL_GUID)) {
-			efi.uga = config_tables[i].table;
-			printk(" UGA=0x%lx ", config_tables[i].table);
-		}
-	}
-	printk("\n");
-	efi_early_iounmap(config_tables,
-			  efi.systab->nr_tables * sizeof(efi_config_table_t));
+		goto error;
 
 	/*
 	 * Check out the runtime services table. We need to map
@@ -339,31 +277,31 @@ void __init efi_init(void)
 	 */
 	runtime = efi_early_ioremap((unsigned long)efi.systab->runtime,
 				    sizeof(efi_runtime_services_t));
-	if (runtime != NULL) {
-		/*
-		 * We will only need *early* access to the following
-		 * two EFI runtime services before set_virtual_address_map
-		 * is invoked.
-		 */
-		efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
-		efi_phys.set_virtual_address_map =
-			(efi_set_virtual_address_map_t *)
-			runtime->set_virtual_address_map;
-		/*
-		 * Make efi_get_time can be called before entering
-		 * virtual mode.
-		 */
-		efi.get_time = phys_efi_get_time;
-	} else
+	if (runtime == NULL) {
 		printk(KERN_ERR "Could not map the EFI runtime service "
 		       "table!\n");
+		goto error;
+	}
+	/*
+	 * We will only need *early* access to the following two EFI
+	 * runtime services before set_virtual_address_map is invoked.
+	 */
+	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
+	efi_phys.set_virtual_address_map = (efi_set_virtual_address_map_t *)
+		runtime->set_virtual_address_map;
+	/*
+	 * Make efi_get_time can be called before entering virtual mode.
+	 */
+	efi.get_time = phys_efi_get_time;
 	efi_early_iounmap(runtime, sizeof(efi_runtime_services_t));
 
 	/* Map the EFI memory map */
 	memmap.map = efi_early_ioremap((unsigned long)memmap.phys_map,
 				       memmap.nr_map * memmap.desc_size);
-	if (memmap.map == NULL)
+	if (memmap.map == NULL) {
 		printk(KERN_ERR "Could not map the EFI memory map!\n");
+		goto error;
+	}
 	memmap.map_end = memmap.map + (memmap.nr_map * memmap.desc_size);
 	if (memmap.desc_size != sizeof(efi_memory_desc_t))
 		printk(KERN_WARNING "Kernel-defined memdesc"
@@ -377,6 +315,9 @@ void __init efi_init(void)
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
+	return;
+error:
+	efi_enabled = 0;
 }
 
 /*
diff -puN /dev/null arch/x86/kernel/efi_tables.c
--- /dev/null
+++ a/arch/x86/kernel/efi_tables.c
@@ -0,0 +1,144 @@
+/*
+ * EFI tables parsing functions
+ *
+ * Copyright (C) 2007 Intel Co.
+ *	Huang Ying <ying.huang@intel.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/efi.h>
+#include <linux/io.h>
+
+#include <asm/setup.h>
+#include <asm/efi.h>
+
+struct efi_tables efi_tables;
+EXPORT_SYMBOL_GPL(efi_tables);
+
+#define EFI_TABLE_PARSE(bt)						\
+static void __init efi_tables_parse ## bt(void)				\
+{									\
+	struct efi_config_table ## bt *config_tables;			\
+	struct efi_system_table ## bt systab, *psystab;			\
+	efi_char16_t *c16;						\
+	char vendor[100] = "unknown";					\
+	u64 n;								\
+	int i;								\
+	void *tmp;							\
+									\
+	n = boot_params.efi_info.efi_systab;				\
+	if (bt == 64)							\
+		n |= ((u64)boot_params.efi_info.efi_systab_hi<<32);	\
+	if (!EFI_CHECK_ADDR(n))						\
+		return;							\
+	psystab = efi_early_ioremap(n, sizeof(systab));			\
+	if (psystab == NULL) {						\
+		printk(KERN_ERR "Could not map the EFI system table!\n"); \
+		return;							\
+	}								\
+	memcpy(&systab, psystab, sizeof(systab));			\
+	efi_early_iounmap(psystab, sizeof(systab));			\
+									\
+	if (systab.hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {	\
+		printk(KERN_ERR "EFI system table signature "		\
+		       "incorrect!\n");					\
+		return;							\
+	}								\
+	if ((systab.hdr.revision >> 16) == 0) {				\
+		printk(KERN_ERR "Warning: EFI system table version "	\
+		       "%d.%02d, expected 1.00 or greater!\n",		\
+		       systab.hdr.revision >> 16,			\
+		       systab.hdr.revision & 0xffff);			\
+		return;							\
+	}								\
+									\
+	if (EFI_CHECK_ADDR(systab.fw_vendor)) {				\
+		c16 = tmp = efi_early_ioremap(systab.fw_vendor, 2);	\
+		if (c16 == NULL) {					\
+			printk(KERN_ERR "Could not map the EFI "	\
+			       "firmware vendor!\n");			\
+			return;						\
+		}							\
+		for (i = 0; i < sizeof(vendor) && *c16; ++i)		\
+			vendor[i] = *c16++;				\
+		vendor[i] = '\0';					\
+		efi_early_iounmap(tmp, 2);				\
+	}								\
+									\
+	printk(KERN_INFO "EFI %u v%u.%.02u by %s \n",			\
+	       bt, systab.hdr.revision >> 16,				\
+	       systab.hdr.revision & 0xffff, vendor);			\
+									\
+	if (!EFI_CHECK_ADDR(systab.tables))				\
+		return;							\
+									\
+	config_tables = efi_early_ioremap(				\
+		systab.tables,						\
+		systab.nr_tables * sizeof(struct efi_config_table ## bt)); \
+	if (config_tables == NULL) {					\
+		printk(KERN_ERR "Could not map EFI Configuration "	\
+		       "Table!\n");					\
+		return;							\
+	}								\
+									\
+	printk(KERN_INFO);						\
+	for (i = 0; i < systab.nr_tables; i++) {			\
+		efi_guid_t guid = config_tables[i].guid;		\
+		unsigned long table = config_tables[i].table;		\
+		if (!EFI_CHECK_ADDR(config_tables[i].table))		\
+			continue;					\
+		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {		\
+			efi_tables.mps = table;				\
+			printk(" MPS=0x%lx ", table);			\
+		} else if (!efi_guidcmp(guid, ACPI_20_TABLE_GUID)) {	\
+			efi_tables.acpi20 = table;			\
+			printk(" ACPI 2.0=0x%lx ", table);		\
+		} else if (!efi_guidcmp(guid, ACPI_TABLE_GUID)) {	\
+			efi_tables.acpi = table;			\
+			printk(" ACPI=0x%lx ", table);			\
+		} else if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID)) {	\
+			efi_tables.smbios = table;			\
+			printk(" SMBIOS=0x%lx ", table);		\
+		} else if (!efi_guidcmp(guid, HCDP_TABLE_GUID)) {	\
+			efi_tables.hcdp = table;			\
+			printk(" HCDP=0x%lx ", table);			\
+		} else if (!efi_guidcmp(guid, UGA_IO_PROTOCOL_GUID)) {	\
+			efi_tables.uga = table;				\
+			printk(" UGA=0x%lx ", table);			\
+		}							\
+	}								\
+	printk("\n");							\
+	efi_early_iounmap(						\
+		config_tables,						\
+		systab.nr_tables * sizeof(struct efi_config_table ## bt)); \
+}
+
+EFI_TABLE_PARSE(32)
+EFI_TABLE_PARSE(64)
+
+void __init efi_tables_parse(void)
+{
+	switch (bios_type) {
+	case BIOS_EFI32:
+		efi_tables_parse32();
+		break;
+	case BIOS_EFI64:
+		efi_tables_parse64();
+		break;
+	default:
+		break;
+	}
+}
+
+void __init efi_check_bios_type(void)
+{
+	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+		     "EL32", 4))
+		bios_type = BIOS_EFI32;
+	else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
+			  "EL64", 4))
+		bios_type = BIOS_EFI64;
+}
diff -puN arch/x86/kernel/setup_32.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/x86/kernel/setup_32.c
--- a/arch/x86/kernel/setup_32.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/x86/kernel/setup_32.c
@@ -64,6 +64,7 @@
 #include <setup_arch.h>
 #include <asm/bios_ebda.h>
 #include <asm/cacheflush.h>
+#include <asm/efi.h>
 
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
@@ -203,6 +204,9 @@ struct boot_params __initdata boot_param
 struct boot_params boot_params;
 #endif
 
+enum bios_type bios_type = BIOS_LEGACY;
+EXPORT_SYMBOL_GPL(bios_type);
+
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 struct edd edd;
 #ifdef CONFIG_EDD_MODULE
@@ -706,9 +710,9 @@ void __init setup_arch(char **cmdline_p)
 	early_cpu_init();
 	early_trap_init();
 
+	efi_check_bios_type();
 #ifdef CONFIG_EFI
-	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL32", 4))
+	if (bios_type == BIOS_EFI32)
 		efi_enabled = 1;
 #endif
 
@@ -762,6 +766,7 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
+	efi_tables_parse();
 	if (efi_enabled)
 		efi_init();
 
diff -puN arch/x86/kernel/setup_64.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code arch/x86/kernel/setup_64.c
--- a/arch/x86/kernel/setup_64.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/arch/x86/kernel/setup_64.c
@@ -155,6 +155,9 @@ static struct resource bss_resource = {
 	.flags = IORESOURCE_RAM,
 };
 
+enum bios_type bios_type = BIOS_LEGACY;
+EXPORT_SYMBOL_GPL(bios_type);
+
 static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
 
 #ifdef CONFIG_PROC_VMCORE
@@ -321,9 +324,9 @@ void __init setup_arch(char **cmdline_p)
 	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
 	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
 #endif
+	efi_check_bios_type();
 #ifdef CONFIG_EFI
-	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
-		     "EL64", 4))
+	if (bios_type == BIOS_EFI64)
 		efi_enabled = 1;
 #endif
 
@@ -375,6 +378,8 @@ void __init setup_arch(char **cmdline_p)
 	discover_ebda();
 
 	init_memory_mapping(0, (end_pfn_map << PAGE_SHIFT));
+
+	efi_tables_parse();
 	if (efi_enabled)
 		efi_init();
 
diff -puN drivers/acpi/osl.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/drivers/acpi/osl.c
@@ -42,6 +42,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/processor.h>
 #include <asm/uaccess.h>
+#include <asm/setup.h>
 
 #include <linux/efi.h>
 #include <linux/ioport.h>
@@ -209,11 +210,11 @@ void acpi_os_vprintf(const char *fmt, va
 
 acpi_physical_address __init acpi_os_get_root_pointer(void)
 {
-	if (efi_enabled) {
-		if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
-			return efi.acpi20;
-		else if (efi.acpi != EFI_INVALID_TABLE_ADDR)
-			return efi.acpi;
+	if (bios_type == BIOS_EFI64 || bios_type == BIOS_EFI32) {
+		if (efi_tables.acpi20 != EFI_INVALID_TABLE_ADDR)
+			return efi_tables.acpi20;
+		else if (efi_tables.acpi != EFI_INVALID_TABLE_ADDR)
+			return efi_tables.acpi;
 		else {
 			printk(KERN_ERR PREFIX
 			       "System description tables not found\n");
diff -puN drivers/firmware/dmi_scan.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code drivers/firmware/dmi_scan.c
--- a/drivers/firmware/dmi_scan.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/drivers/firmware/dmi_scan.c
@@ -7,6 +7,7 @@
 #include <linux/bootmem.h>
 #include <linux/slab.h>
 #include <asm/dmi.h>
+#include <asm/setup.h>
 
 static char dmi_empty_string[] = "        ";
 
@@ -316,15 +317,15 @@ void __init dmi_scan_machine(void)
 	char __iomem *p, *q;
 	int rc;
 
-	if (efi_enabled) {
-		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
+	if (bios_type == BIOS_EFI64 || bios_type == BIOS_EFI32) {
+		if (efi_tables.smbios == EFI_INVALID_TABLE_ADDR)
 			goto out;
 
 		/* This is called as a core_initcall() because it isn't
 		 * needed during early boot.  This also means we can
 		 * iounmap the space when we're done with it.
 		 */
-		p = dmi_ioremap(efi.smbios, 32);
+		p = dmi_ioremap(efi_tables.smbios, 32);
 		if (p == NULL)
 			goto out;
 
diff -puN drivers/firmware/efivars.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code drivers/firmware/efivars.c
--- a/drivers/firmware/efivars.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/drivers/firmware/efivars.c
@@ -79,6 +79,7 @@
 #include <linux/device.h>
 
 #include <asm/uaccess.h>
+#include <asm/setup.h>
 
 #define EFIVARS_VERSION "0.08"
 #define EFIVARS_DATE "2004-May-17"
@@ -541,20 +542,20 @@ static ssize_t systab_show(struct kobjec
 	if (!kobj || !buf)
 		return -EINVAL;
 
-	if (efi.mps != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "MPS=0x%lx\n", efi.mps);
-	if (efi.acpi20 != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "ACPI20=0x%lx\n", efi.acpi20);
-	if (efi.acpi != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "ACPI=0x%lx\n", efi.acpi);
-	if (efi.smbios != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "SMBIOS=0x%lx\n", efi.smbios);
-	if (efi.hcdp != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "HCDP=0x%lx\n", efi.hcdp);
-	if (efi.boot_info != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
-	if (efi.uga != EFI_INVALID_TABLE_ADDR)
-		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
+	if (efi_tables.mps != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "MPS=0x%lx\n", efi_tables.mps);
+	if (efi_tables.acpi20 != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "ACPI20=0x%lx\n", efi_tables.acpi20);
+	if (efi_tables.acpi != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "ACPI=0x%lx\n", efi_tables.acpi);
+	if (efi_tables.smbios != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "SMBIOS=0x%lx\n", efi_tables.smbios);
+	if (efi_tables.hcdp != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "HCDP=0x%lx\n", efi_tables.hcdp);
+	if (efi_tables.boot_info != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "BOOTINFO=0x%lx\n", efi_tables.boot_info);
+	if (efi_tables.uga != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "UGA=0x%lx\n", efi_tables.uga);
 
 	return str - buf;
 }
@@ -653,7 +654,7 @@ efivars_init(void)
 	unsigned long variable_name_size = 1024;
 	int error = 0;
 
-	if (!efi_enabled)
+	if (bios_type != BIOS_EFI64 && bios_type != BIOS_EFI32)
 		return -ENODEV;
 
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
@@ -662,9 +663,6 @@ efivars_init(void)
 		return -ENOMEM;
 	}
 
-	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
-	       EFIVARS_DATE);
-
 	/* For now we'll register the efi directory at /sys/firmware/efi */
 	efi_kobj = kobject_create_and_add("efi", firmware_kobj);
 	if (!efi_kobj) {
@@ -673,6 +671,20 @@ efivars_init(void)
 		goto out_free;
 	}
 
+	/* Don't forget the systab entry */
+	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
+	if (error) {
+		printk(KERN_ERR "efivars: Sysfs attribute export failed "
+		       "with error %d.\n", error);
+		goto out_firmware_unregister;
+	}
+
+	if (!efi_enabled)
+		goto out_free;
+
+	printk(KERN_INFO "EFI Variables Facility v%s %s\n", EFIVARS_VERSION,
+	       EFIVARS_DATE);
+
 	vars_kset = kset_create_and_add("vars", NULL, efi_kobj);
 	if (!vars_kset) {
 		printk(KERN_ERR "efivars: Subsystem registration failed.\n");
@@ -721,11 +733,6 @@ efivars_init(void)
 	if (error)
 		printk(KERN_ERR "efivars: unable to create del_var sysfs file"
 			" due to error %d\n", error);
-
-	/* Don't forget the systab entry */
-	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
-	if (error)
-		printk(KERN_ERR "efivars: Sysfs attribute export failed with error %d.\n", error);
 	else
 		goto out_free;
 
diff -puN drivers/firmware/pcdp.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code drivers/firmware/pcdp.c
--- a/drivers/firmware/pcdp.c~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/drivers/firmware/pcdp.c
@@ -92,11 +92,11 @@ efi_setup_pcdp_console(char *cmdline)
 	int i, serial = 0;
 	int rc = -ENODEV;
 
-	if (efi.hcdp == EFI_INVALID_TABLE_ADDR)
+	if (efi_tables.hcdp == EFI_INVALID_TABLE_ADDR)
 		return -ENODEV;
 
-	pcdp = ioremap(efi.hcdp, 4096);
-	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi.hcdp);
+	pcdp = ioremap(efi_tables.hcdp, 4096);
+	printk(KERN_INFO "PCDP: v%d at 0x%lx\n", pcdp->rev, efi_tables.hcdp);
 
 	if (strstr(cmdline, "console=hcdp")) {
 		if (pcdp->rev < 3)
diff -puN include/asm-ia64/setup.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code include/asm-ia64/setup.h
--- a/include/asm-ia64/setup.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/include/asm-ia64/setup.h
@@ -3,4 +3,9 @@
 
 #define COMMAND_LINE_SIZE	2048
 
+#define BIOS_EFI64		1
+#define BIOS_EFI32		2
+
+#define bios_type		BIOS_EFI64
+
 #endif
diff -puN include/asm-ia64/sn/sn_sal.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code include/asm-ia64/sn/sn_sal.h
--- a/include/asm-ia64/sn/sn_sal.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/include/asm-ia64/sn/sn_sal.h
@@ -165,7 +165,7 @@
 static inline u32
 sn_sal_rev(void)
 {
-	struct ia64_sal_systab *systab = __va(efi.sal_systab);
+	struct ia64_sal_systab *systab = __va(efi_tables.sal_systab);
 
 	return (u32)(systab->sal_b_rev_major << 8 | systab->sal_b_rev_minor);
 }
diff -puN include/asm-x86/efi.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code include/asm-x86/efi.h
--- a/include/asm-x86/efi.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/include/asm-x86/efi.h
@@ -44,6 +44,8 @@ extern void *boot_ioremap(unsigned long,
 
 #define end_pfn_map				max_low_pfn
 
+#define EFI_CHECK_ADDR(addr)	((addr) <= -1UL)
+
 #else /* !CONFIG_X86_32 */
 
 #define MAX_EFI_IO_PAGES	100
@@ -102,6 +104,8 @@ extern void *efi_ioremap(unsigned long o
 
 extern int efi_time;
 
+#define EFI_CHECK_ADDR(addr)	1
+
 #endif /* CONFIG_X86_32 */
 
 extern void efi_reserve_bootmem(void);
@@ -109,4 +113,7 @@ extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 extern void runtime_code_page_mkexec(void);
 
+extern void efi_tables_parse(void);
+extern void efi_check_bios_type(void);
+
 #endif
diff -puN include/asm-x86/setup.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code include/asm-x86/setup.h
--- a/include/asm-x86/setup.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/include/asm-x86/setup.h
@@ -61,6 +61,15 @@ extern unsigned long init_pg_tables_end;
 
 
 #endif /* __i386__ */
+
+enum bios_type {
+	BIOS_LEGACY,
+	BIOS_EFI32,
+	BIOS_EFI64,
+};
+
+extern enum bios_type bios_type;
+
 #endif /* _SETUP */
 #endif /* __ASSEMBLY__ */
 #endif  /*  __KERNEL__  */
diff -puN include/linux/efi.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code include/linux/efi.h
--- a/include/linux/efi.h~efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code
+++ a/include/linux/efi.h
@@ -212,6 +212,16 @@ typedef struct {
 	unsigned long table;
 } efi_config_table_t;
 
+struct efi_config_table64 {
+	efi_guid_t guid;
+	u64 table;
+};
+
+struct efi_config_table32 {
+	efi_guid_t guid;
+	u32 table;
+};
+
 #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
 
 typedef struct {
@@ -230,6 +240,39 @@ typedef struct {
 	unsigned long tables;
 } efi_system_table_t;
 
+struct efi_system_table64 {
+	efi_table_hdr_t hdr;
+	u64 fw_vendor;
+	u32 fw_revision;
+	u32 _pad1;
+	u64 con_in_handle;
+	u64 con_in;
+	u64 con_out_handle;
+	u64 con_out;
+	u64 stderr_handle;
+	u64 stderr;
+	u64 runtime;
+	u64 boottime;
+	u64 nr_tables;
+	u64 tables;
+};
+
+struct efi_system_table32 {
+	efi_table_hdr_t hdr;
+	u32 fw_vendor;
+	u32 fw_revision;
+	u32 con_in_handle;
+	u32 con_in;
+	u32 con_out_handle;
+	u32 con_out;
+	u32 stderr_handle;
+	u32 stderr;
+	u32 runtime;
+	u32 boottime;
+	u32 nr_tables;
+	u32 tables;
+};
+
 struct efi_memory_map {
 	void *phys_map;
 	void *map;
@@ -246,14 +289,6 @@ struct efi_memory_map {
  */
 extern struct efi {
 	efi_system_table_t *systab;	/* EFI system table */
-	unsigned long mps;		/* MPS table */
-	unsigned long acpi;		/* ACPI table  (IA64 ext 0.71) */
-	unsigned long acpi20;		/* ACPI table  (ACPI 2.0) */
-	unsigned long smbios;		/* SM BIOS table */
-	unsigned long sal_systab;	/* SAL system table */
-	unsigned long boot_info;	/* boot info table */
-	unsigned long hcdp;		/* HCDP table */
-	unsigned long uga;		/* UGA table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
@@ -266,6 +301,19 @@ extern struct efi {
 	efi_set_virtual_address_map_t *set_virtual_address_map;
 } efi;
 
+struct efi_tables {
+	unsigned long mps;		/* MPS table */
+	unsigned long acpi;		/* ACPI table  (IA64 ext 0.71) */
+	unsigned long acpi20;		/* ACPI table  (ACPI 2.0) */
+	unsigned long smbios;		/* SM BIOS table */
+	unsigned long sal_systab;	/* SAL system table */
+	unsigned long boot_info;	/* boot info table */
+	unsigned long hcdp;		/* HCDP table */
+	unsigned long uga;		/* UGA table */
+};
+
+extern struct efi_tables efi_tables;
+
 static inline int
 efi_guidcmp (efi_guid_t left, efi_guid_t right)
 {
_

Patches currently in -mm which might be from ying.huang@intel.com are

git-x86.patch
efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch
