From: akpm@linux-foundation.org
Subject: - mmconfig-cleanup.patch removed from -mm tree
Date: Fri, 09 Feb 2007 20:57:39 -0800
Message-ID: <200702100457.l1A4vepQ004050@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36193 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbXBJE5s (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 9 Feb 2007 23:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, ak@suse.de, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     MMCONFIG: cleanup
has been removed from the -mm tree.  Its filename was
     mmconfig-cleanup.patch

This patch was dropped because acpi and x86_64 tree changes wrecked it

------------------------------------------------------
Subject: MMCONFIG: cleanup
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This just cleans up.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |   50 +++++++++++++-----------------
 arch/i386/pci/mmconfig.c        |   13 ++-----
 arch/i386/pci/pci.h             |    4 +-
 arch/x86_64/pci/mmconfig.c      |   16 ++-------
 4 files changed, 33 insertions(+), 50 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~mmconfig-cleanup arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~mmconfig-cleanup
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -22,10 +22,6 @@
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
 #define MMCONFIG_APER_MAX	(256 * 1024*1024)
 
-/* Verify the first 16 busses. We assume that systems with more busses
-   get MCFG right. */
-#define PCI_MMCFG_MAX_CHECK_BUS 16
-
 DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
 
 /* K8 systems have some devices (typically in the builtin northbridge)
@@ -34,29 +30,30 @@ DECLARE_BITMAP(pci_mmcfg_fallback_slots,
    and assigning suitable _SEGs, but this isn't implemented in some BIOS.
    Instead try to discover all devices on bus 0 that are unreachable using MM
    and fallback for them. */
-static __init void unreachable_devices(void)
+static void __init unreachable_devices(void)
 {
-	int i, k;
+	int i, bus;
 	/* Use the max bus number from ACPI here? */
-	for (k = 0; k < PCI_MMCFG_MAX_CHECK_BUS; k++) {
+	for (bus = 0; bus < PCI_MMCFG_MAX_CHECK_BUS; bus++) {
 		for (i = 0; i < 32; i++) {
+			unsigned int devfn = PCI_DEVFN(i, 0);
 			u32 val1, val2;
 
-			pci_conf1_read(0, k, PCI_DEVFN(i,0), 0, 4, &val1);
+			pci_conf1_read(0, bus, devfn, 0, 4, &val1);
 			if (val1 == 0xffffffff)
 				continue;
 
-			raw_pci_ops->read(0, k, PCI_DEVFN(i, 0), 0, 4, &val2);
+			raw_pci_ops->read(0, bus, devfn, 0, 4, &val2);
 			if (val1 != val2) {
-				set_bit(i + 32*k, pci_mmcfg_fallback_slots);
+				set_bit(i + 32 * bus, pci_mmcfg_fallback_slots);
 				printk(KERN_NOTICE "PCI: No mmconfig possible"
-				       " on device %02x:%02x\n", k, i);
+				       " on device %02x:%02x\n", bus, i);
 			}
 		}
 	}
 }
 
-static __init const char *pci_mmcfg_e7520(void)
+static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
 	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
@@ -71,7 +68,7 @@ static __init const char *pci_mmcfg_e752
 	return "Intel Corporation E7520 Memory Controller Hub";
 }
 
-static __init const char *pci_mmcfg_intel_945(void)
+static const char __init *pci_mmcfg_intel_945(void)
 {
 	u32 pciexbar, mask = 0, len = 0;
 
@@ -124,7 +121,7 @@ struct pci_mmcfg_hostbridge_probe {
 	const char *(*probe)(void);
 };
 
-static __initdata struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] = {
+static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
 };
@@ -144,22 +141,20 @@ static int __init pci_mmcfg_check_hostbr
 	pci_mmcfg_config = NULL;
 	name = NULL;
 
-	for (i = 0; !name && i < sizeof(pci_mmcfg_probes) / sizeof(pci_mmcfg_probes[0]); i++)
-		if ((pci_mmcfg_probes[i].vendor == PCI_ANY_ID || pci_mmcfg_probes[i].vendor == vendor) &&
-		    (pci_mmcfg_probes[i].device == PCI_ANY_ID || pci_mmcfg_probes[i].device == device))
+	for (i = 0; !name && i < ARRAY_SIZE(pci_mmcfg_probes); i++) {
+		if (pci_mmcfg_probes[i].vendor == vendor &&
+		    pci_mmcfg_probes[i].device == device)
 			name = pci_mmcfg_probes[i].probe();
-
+	}
 	if (name) {
-		if (pci_mmcfg_config_num)
-			printk(KERN_INFO "PCI: Found %s with MMCONFIG support.\n", name);
-		else
-			printk(KERN_INFO "PCI: Found %s without MMCONFIG support.\n", name);
+		printk(KERN_INFO "PCI: Found %s %s MMCONFIG support.\n",
+		       name, pci_mmcfg_config_num ? "with" : "without");
 	}
 
 	return name != NULL;
 }
 
-static __init void pci_mmcfg_insert_resources(void)
+static void __init pci_mmcfg_insert_resources(void)
 {
 #define PCI_MMCFG_RESOURCE_NAME_LEN 19
 	int i;
@@ -169,7 +164,6 @@ static __init void pci_mmcfg_insert_reso
 
 	res = kcalloc(PCI_MMCFG_RESOURCE_NAME_LEN + sizeof(*res),
 			pci_mmcfg_config_num, GFP_KERNEL);
-
 	if (!res) {
 		printk(KERN_ERR "PCI: Unable to allocate MMCONFIG resources\n");
 		return;
@@ -177,12 +171,12 @@ static __init void pci_mmcfg_insert_reso
 
 	names = (void *)&res[pci_mmcfg_config_num];
 	for (i = 0; i < pci_mmcfg_config_num; i++, res++) {
-		num_buses = pci_mmcfg_config[i].end_bus_number -
-		    pci_mmcfg_config[i].start_bus_number + 1;
+		struct acpi_table_mcfg_config *cfg = &pci_mmcfg_config[i];
+		num_buses = cfg->end_bus_number - cfg->start_bus_number + 1;
 		res->name = names;
 		snprintf(names, PCI_MMCFG_RESOURCE_NAME_LEN, "PCI MMCONFIG %u",
-			pci_mmcfg_config[i].pci_segment_group_number);
-		res->start = pci_mmcfg_config[i].base_address;
+			 cfg->pci_segment_group_number);
+		res->start = cfg->base_address;
 		res->end = res->start + (num_buses << 20) - 1;
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 		insert_resource(&iomem_resource, res);
diff -puN arch/i386/pci/mmconfig.c~mmconfig-cleanup arch/i386/pci/mmconfig.c
--- a/arch/i386/pci/mmconfig.c~mmconfig-cleanup
+++ a/arch/i386/pci/mmconfig.c
@@ -27,22 +27,17 @@ static int mmcfg_last_accessed_cpu;
  */
 static u32 get_base_addr(unsigned int seg, int bus, unsigned devfn)
 {
-	int cfg_num = -1;
+	int cfg_num;
 	struct acpi_table_mcfg_config *cfg;
 
 	if (seg == 0 && bus < PCI_MMCFG_MAX_CHECK_BUS &&
 	    test_bit(PCI_SLOT(devfn) + 32*bus, pci_mmcfg_fallback_slots))
 		return 0;
 
-	while (1) {
-		++cfg_num;
-		if (cfg_num >= pci_mmcfg_config_num) {
-			break;
-		}
+	for (cfg_num = 0; cfg_num < pci_mmcfg_config_num; cfg_num++) {
 		cfg = &pci_mmcfg_config[cfg_num];
-		if (cfg->pci_segment_group_number != seg)
-			continue;
-		if ((cfg->start_bus_number <= bus) &&
+		if (cfg->pci_segment_group_number == seg &&
+		    (cfg->start_bus_number <= bus) &&
 		    (cfg->end_bus_number >= bus))
 			return cfg->base_address;
 	}
diff -puN arch/i386/pci/pci.h~mmconfig-cleanup arch/i386/pci/pci.h
--- a/arch/i386/pci/pci.h~mmconfig-cleanup
+++ a/arch/i386/pci/pci.h
@@ -96,7 +96,9 @@ extern void pcibios_sort(void);
 
 /* pci-mmconfig.c */
 
+/* Verify the first 16 busses. We assume that systems with more busses
+   get MCFG right. */
 #define PCI_MMCFG_MAX_CHECK_BUS 16
 extern DECLARE_BITMAP(pci_mmcfg_fallback_slots, 32*PCI_MMCFG_MAX_CHECK_BUS);
 
-extern int pci_mmcfg_arch_init(void);
+extern int __init pci_mmcfg_arch_init(void);
diff -puN arch/x86_64/pci/mmconfig.c~mmconfig-cleanup arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~mmconfig-cleanup
+++ a/arch/x86_64/pci/mmconfig.c
@@ -13,10 +13,6 @@
 
 #include "pci.h"
 
-/* Verify the first 16 busses. We assume that systems with more busses
-   get MCFG right. */
-#define PCI_MMCFG_MAX_CHECK_BUS 16
-
 /* Static virtual mapping of the MMCONFIG aperture */
 struct mmcfg_virt {
 	struct acpi_table_mcfg_config *cfg;
@@ -26,17 +22,13 @@ static struct mmcfg_virt *pci_mmcfg_virt
 
 static char __iomem *get_virt(unsigned int seg, unsigned bus)
 {
-	int cfg_num = -1;
 	struct acpi_table_mcfg_config *cfg;
+	int cfg_num;
 
-	while (1) {
-		++cfg_num;
-		if (cfg_num >= pci_mmcfg_config_num)
-			break;
+	for (cfg_num = 0; cfg_num < pci_mmcfg_config_num; cfg_num++) {
 		cfg = pci_mmcfg_virt[cfg_num].cfg;
-		if (cfg->pci_segment_group_number != seg)
-			continue;
-		if ((cfg->start_bus_number <= bus) &&
+		if (cfg->pci_segment_group_number == seg &&
+		    (cfg->start_bus_number <= bus) &&
 		    (cfg->end_bus_number >= bus))
 			return pci_mmcfg_virt[cfg_num].virt;
 	}
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fix-the-reproducible-oops-in-scsi.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
relax-check-for-aix-in-msdos-partition-table.patch
msdos-partitions-fix-logic-error-in-aix-detection.patch
