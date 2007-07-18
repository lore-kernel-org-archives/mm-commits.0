From: akpm@linux-foundation.org
Subject: + mmconfig-validate-against-acpi-motherboard-resources.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:00:00 -0700
Message-ID: <200707182200.l6IM00IA031079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38352 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752120AbXGRWAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:00:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hancockr@shaw.ca, ak@suse.de, greg@kroah.com, jbarnes@virtuousgeek.org, rajesh.shah@intel.com, torvalds@linux-foundation.org


The patch titled
     MMCONFIG: validate against ACPI motherboard resources
has been added to the -mm tree.  Its filename is
     mmconfig-validate-against-acpi-motherboard-resources.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MMCONFIG: validate against ACPI motherboard resources
From: Robert Hancock <hancockr@shaw.ca>

This path adds validation of the MMCONFIG table against the ACPI reserved
motherboard resources.  If the MMCONFIG table is found to be reserved in
ACPI, we don't bother checking the E820 table.  The PCI Express firmware
spec apparently tells BIOS developers that reservation in ACPI is required
and E820 reservation is optional, so checking against ACPI first makes
sense.  Many BIOSes don't reserve the MMCONFIG region in E820 even though
it is perfectly functional, the existing check needlessly disables MMCONFIG
in these cases.

In order to do this, MMCONFIG setup has been split into two phases.  If PCI
configuration type 1 is not available then MMCONFIG is enabled early as
before.  Otherwise, it is enabled later after the ACPI interpreter is
enabled, since we need to be able to execute control methods in order to
check the ACPI reserved resources.  Presently this is just triggered off
the end of ACPI interpreter initialization.

There are a few other behavioral changes here:

- Validate all MMCONFIG configurations provided, not just the first one.

- Validate the entire required length of each configuration according to
  the provided ending bus number is reserved, not just the minimum required
  allocation.

- Validate that the area is reserved even if we read it from the chipset
  directly and not from the MCFG table.  This catches the case where the
  BIOS didn't set the location properly in the chipset and has mapped it
  over other things it shouldn't have.

This also cleans up the MMCONFIG initialization functions so that they
simply do nothing if MMCONFIG is not compiled in.

Based on an original patch by Rajesh Shah from Intel.

[akpm@linux-foundation.org: many fixes and cleanups]
Signed-off-by: Robert Hancock <hancockr@shaw.ca>
Cc: Rajesh Shah <rajesh.shah@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/init.c            |    4 
 arch/i386/pci/mmconfig-shared.c |  151 ++++++++++++++++++++++++++----
 arch/i386/pci/pci.h             |    1 
 drivers/acpi/bus.c              |    2 
 include/linux/pci.h             |    8 +
 5 files changed, 144 insertions(+), 22 deletions(-)

diff -puN arch/i386/pci/init.c~mmconfig-validate-against-acpi-motherboard-resources arch/i386/pci/init.c
--- a/arch/i386/pci/init.c~mmconfig-validate-against-acpi-motherboard-resources
+++ a/arch/i386/pci/init.c
@@ -11,9 +11,7 @@ static __init int pci_access_init(void)
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();
 #endif
-#ifdef CONFIG_PCI_MMCONFIG
-	pci_mmcfg_init(type);
-#endif
+	pci_mmcfg_early_init(type);
 	if (raw_pci_ops)
 		return 0;
 #ifdef CONFIG_PCI_BIOS
diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-validate-against-acpi-motherboard-resources arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-validate-against-acpi-motherboard-resources
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -206,9 +206,78 @@ static void __init pci_mmcfg_insert_reso
 	pci_mmcfg_resources_inserted = 1;
 }
 
-static void __init pci_mmcfg_reject_broken(int type)
+static acpi_status __init check_mcfg_resource(struct acpi_resource *res,
+					      void *data)
+{
+	struct resource *mcfg_res = data;
+	struct acpi_resource_address64 address;
+	acpi_status status;
+
+	if (res->type == ACPI_RESOURCE_TYPE_FIXED_MEMORY32) {
+		struct acpi_resource_fixed_memory32 *fixmem32 =
+			&res->data.fixed_memory32;
+		if (!fixmem32)
+			return AE_OK;
+		if ((mcfg_res->start >= fixmem32->address) &&
+		    (mcfg_res->end < (fixmem32->address +
+		    		      fixmem32->address_length))) {
+			mcfg_res->flags = 1;
+			return AE_CTRL_TERMINATE;
+		}
+	}
+	if ((res->type != ACPI_RESOURCE_TYPE_ADDRESS32) &&
+	    (res->type != ACPI_RESOURCE_TYPE_ADDRESS64))
+		return AE_OK;
+
+	status = acpi_resource_to_address64(res, &address);
+	if (ACPI_FAILURE(status) ||
+	   (address.address_length <= 0) ||
+	   (address.resource_type != ACPI_MEMORY_RANGE))
+		return AE_OK;
+
+	if ((mcfg_res->start >= address.minimum) &&
+	    (mcfg_res->end < (address.minimum + address.address_length))) {
+		mcfg_res->flags = 1;
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+static acpi_status __init find_mboard_resource(acpi_handle handle, u32 lvl,
+		void *context, void **rv)
+{
+	struct resource *mcfg_res = context;
+
+	acpi_walk_resources(handle, METHOD_NAME__CRS,
+	  		    check_mcfg_resource, context);
+
+	if (mcfg_res->flags)
+		return AE_CTRL_TERMINATE;
+
+	return AE_OK;
+}
+
+static int __init is_acpi_reserved(unsigned long start, unsigned long end)
+{
+	struct resource mcfg_res;
+
+	mcfg_res.start = start;
+	mcfg_res.end = end;
+	mcfg_res.flags = 0;
+
+	acpi_get_devices("PNP0C01", find_mboard_resource, &mcfg_res, NULL);
+
+	if (!mcfg_res.flags)
+		acpi_get_devices("PNP0C02", find_mboard_resource, &mcfg_res,
+				 NULL);
+
+	return mcfg_res.flags;
+}
+
+static void __init pci_mmcfg_reject_broken(void)
 {
 	typeof(pci_mmcfg_config[0]) *cfg;
+	int i;
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -229,17 +298,37 @@ static void __init pci_mmcfg_reject_brok
 		goto reject;
 	}
 
-	/*
-	 * Only do this check when type 1 works. If it doesn't work
-	 * assume we run on a Mac and always use MCFG
-	 */
-	if (type == 1 && !e820_all_mapped(cfg->address,
-					  cfg->address + MMCONFIG_APER_MIN,
-					  E820_RESERVED)) {
-		printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
-		       " E820-reserved\n", cfg->address);
-		goto reject;
+	for (i = 0; i < pci_mmcfg_config_num; i++) {
+		u32 size = (cfg->end_bus_number + 1) << 20;
+		cfg = &pci_mmcfg_config[i];
+		printk(KERN_NOTICE "PCI: MCFG configuration %d: base %lu "
+		       "segment %hu buses %u - %u\n",
+		       i, (unsigned long)cfg->address, cfg->pci_segment,
+		       (unsigned int)cfg->start_bus_number,
+		       (unsigned int)cfg->end_bus_number);
+		if (is_acpi_reserved(cfg->address, cfg->address + size - 1)) {
+			printk(KERN_NOTICE "PCI: MCFG area at %Lx reserved "
+			       "in ACPI motherboard resources\n",
+			       cfg->address);
+		} else {
+			printk(KERN_ERR "PCI: BIOS Bug: MCFG area at %Lx is not"
+			       " reserved in ACPI motherboard resources\n",
+			       cfg->address);
+			/* Don't try to do this check unless configuration
+			   type 1 is available. */
+			if ((pci_probe & PCI_PROBE_CONF1) &&
+			    e820_all_mapped(cfg->address,
+			                    cfg->address + size - 1,
+					    E820_RESERVED))
+				printk(KERN_NOTICE
+				       "PCI: MCFG area at %Lx reserved in "
+					"E820\n",
+				       cfg->address);
+			else
+				goto reject;
+		}
 	}
+
 	return;
 
 reject:
@@ -249,20 +338,46 @@ reject:
 	pci_mmcfg_config_num = 0;
 }
 
-void __init pci_mmcfg_init(int type)
+void __init pci_mmcfg_early_init(int type)
+{
+	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
+		return;
+
+	/* If type 1 access is available, no need to enable MMCONFIG yet, we can
+	   defer until later when the ACPI interpreter is available to better
+	   validate things. */
+	if (type == 1)
+		return;
+
+	acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
+
+	if ((pci_mmcfg_config_num == 0) ||
+	    (pci_mmcfg_config == NULL) ||
+	    (pci_mmcfg_config[0].address == 0))
+		return;
+
+	if (pci_mmcfg_arch_init())
+		pci_probe = (pci_probe & ~PCI_PROBE_MASK) | PCI_PROBE_MMCONF;
+}
+
+void __init pci_mmcfg_late_init(void)
 {
 	int known_bridge = 0;
 
+	/* MMCONFIG disabled */
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
-	if (type == 1 && pci_mmcfg_check_hostbridge())
-		known_bridge = 1;
+	/* MMCONFIG already enabled */
+	if (!(pci_probe & PCI_PROBE_MASK & ~PCI_PROBE_MMCONF))
+		return;
 
-	if (!known_bridge) {
+	if ((pci_probe & PCI_PROBE_CONF1) && pci_mmcfg_check_hostbridge())
+		known_bridge = 1;
+	else
 		acpi_table_parse(ACPI_SIG_MCFG, acpi_parse_mcfg);
-		pci_mmcfg_reject_broken(type);
-	}
+
+	pci_mmcfg_reject_broken();
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -270,7 +385,7 @@ void __init pci_mmcfg_init(int type)
 		return;
 
 	if (pci_mmcfg_arch_init()) {
-		if (type == 1)
+		if (pci_probe & PCI_PROBE_CONF1)
 			unreachable_devices();
 		if (known_bridge)
 			pci_mmcfg_insert_resources(IORESOURCE_BUSY);
diff -puN arch/i386/pci/pci.h~mmconfig-validate-against-acpi-motherboard-resources arch/i386/pci/pci.h
--- a/arch/i386/pci/pci.h~mmconfig-validate-against-acpi-motherboard-resources
+++ a/arch/i386/pci/pci.h
@@ -91,7 +91,6 @@ extern int pci_conf1_read(unsigned int s
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
 extern void pci_pcbios_init(void);
-extern void pci_mmcfg_init(int type);
 extern void pcibios_sort(void);
 
 /* pci-mmconfig.c */
diff -puN drivers/acpi/bus.c~mmconfig-validate-against-acpi-motherboard-resources drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~mmconfig-validate-against-acpi-motherboard-resources
+++ a/drivers/acpi/bus.c
@@ -35,6 +35,7 @@
 #ifdef CONFIG_X86
 #include <asm/mpspec.h>
 #endif
+#include <linux/pci.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 
@@ -759,6 +760,7 @@ static int __init acpi_init(void)
 	result = acpi_bus_init();
 
 	if (!result) {
+		pci_mmcfg_late_init();
 #ifdef CONFIG_PM_LEGACY
 		if (!PM_IS_ACTIVE())
 			pm_active = 1;
diff -puN include/linux/pci.h~mmconfig-validate-against-acpi-motherboard-resources include/linux/pci.h
--- a/include/linux/pci.h~mmconfig-validate-against-acpi-motherboard-resources
+++ a/include/linux/pci.h
@@ -888,5 +888,13 @@ extern unsigned long pci_cardbus_mem_siz
 
 extern int pcibios_add_platform_entries(struct pci_dev *dev);
 
+#ifdef CONFIG_PCI_MMCONFIG
+extern void __init pci_mmcfg_early_init(int type);
+extern void __init pci_mmcfg_late_init(void);
+#else
+static inline void pci_mmcfg_early_init(int type) { }
+static inline void pci_mmcfg_late_init(void) { }
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* LINUX_PCI_H */
_

Patches currently in -mm which might be from hancockr@shaw.ca are

sata_nv-allow-changing-queue-depth.patch
libata-add-human-readable-error-value-decoding.patch
pci-disable-decode-of-io-memory-during-bar-sizing.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
