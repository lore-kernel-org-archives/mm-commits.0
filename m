From: akpm@osdl.org
Subject: - pci-mmconfig-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:33 -0800
Message-ID: <200701102302.l0AN2Xsr010747@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33136 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965171AbXAJXCl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:02:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galibert@pobox.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     PCI MMConfig: Detect and support the E7520 and the 945G/GZ/P/PL
has been removed from the -mm tree.  Its filename was
     pci-mmconfig-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI MMConfig: Detect and support the E7520 and the 945G/GZ/P/PL
From: Olivier Galibert <galibert@pobox.com>

It seems that the only way to reliably support mmconfig in the presence of
funky biosen is to detect the hostbridge and read where the window is mapped
from its registers.  Do that for the E7520 and the 945G/GZ/P/PL for a start.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |  116 +++++++++++++++++++++++++++++-
 1 files changed, 113 insertions(+), 3 deletions(-)

diff -puN arch/i386/pci/mmconfig-shared.c~pci-mmconfig-detect-and-support-the-e7520-and-the-945g-gz-p-pl arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~pci-mmconfig-detect-and-support-the-e7520-and-the-945g-gz-p-pl
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -3,6 +3,7 @@
  *                     MMCONFIG - common code between i386 and x86-64.
  *
  * This code does:
+ * - known chipset handling
  * - ACPI decoding and validation
  *
  * Per-architecture code takes care of the mappings and accesses
@@ -55,12 +56,121 @@ static __init void unreachable_devices(v
 	}
 }
 
+static __init const char *pci_mmcfg_e7520(void)
+{
+	u32 win;
+	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
+
+	pci_mmcfg_config_num = 1;
+	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+	pci_mmcfg_config[0].base_address = (win & 0xf000) << 16;
+	pci_mmcfg_config[0].pci_segment_group_number = 0;
+	pci_mmcfg_config[0].start_bus_number = 0;
+	pci_mmcfg_config[0].end_bus_number = 255;
+
+	return "Intel Corporation E7520 Memory Controller Hub";
+}
+
+static __init const char *pci_mmcfg_intel_945(void)
+{
+	u32 pciexbar, mask = 0, len = 0;
+
+	pci_mmcfg_config_num = 1;
+
+	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+
+	/* Enable bit */
+	if (!(pciexbar & 1))
+		pci_mmcfg_config_num = 0;
+
+	/* Size bits */
+	switch ((pciexbar >> 1) & 3) {
+	case 0:
+		mask = 0xf0000000U;
+		len  = 0x10000000U;
+		break;
+	case 1:
+		mask = 0xf8000000U;
+		len  = 0x08000000U;
+		break;
+	case 2:
+		mask = 0xfc000000U;
+		len  = 0x04000000U;
+		break;
+	default:
+		pci_mmcfg_config_num = 0;
+	}
+
+	/* Errata #2, things break when not aligned on a 256Mb boundary */
+	/* Can only happen in 64M/128M mode */
+
+	if ((pciexbar & mask) & 0x0fffffffU)
+		pci_mmcfg_config_num = 0;
+
+	if (pci_mmcfg_config_num) {
+		pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+		pci_mmcfg_config[0].base_address = pciexbar & mask;
+		pci_mmcfg_config[0].pci_segment_group_number = 0;
+		pci_mmcfg_config[0].start_bus_number = 0;
+		pci_mmcfg_config[0].end_bus_number = (len >> 20) - 1;
+	}
+
+	return "Intel Corporation 945G/GZ/P/PL Express Memory Controller Hub";
+}
+
+struct pci_mmcfg_hostbridge_probe {
+	u32 vendor;
+	u32 device;
+	const char *(*probe)(void);
+};
+
+static __initdata struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] = {
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
+};
+
+static int __init pci_mmcfg_check_hostbridge(void)
+{
+	u32 l;
+	u16 vendor, device;
+	int i;
+	const char *name;
+
+	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
+	vendor = l & 0xffff;
+	device = (l >> 16) & 0xffff;
+
+	pci_mmcfg_config_num = 0;
+	pci_mmcfg_config = NULL;
+	name = NULL;
+
+	for (i = 0; !name && i < sizeof(pci_mmcfg_probes) / sizeof(pci_mmcfg_probes[0]); i++)
+		if ((pci_mmcfg_probes[i].vendor == PCI_ANY_ID || pci_mmcfg_probes[i].vendor == vendor) &&
+		    (pci_mmcfg_probes[i].device == PCI_ANY_ID || pci_mmcfg_probes[i].device == device))
+			name = pci_mmcfg_probes[i].probe();
+
+	if (name) {
+		if (pci_mmcfg_config_num)
+			printk(KERN_INFO "PCI: Found %s with MMCONFIG support.\n", name);
+		else
+			printk(KERN_INFO "PCI: Found %s without MMCONFIG support.\n", name);
+	}
+
+	return name != NULL;
+}
+
 void __init pci_mmcfg_init(int type)
 {
+	int known_bridge = 0;
+
 	if ((pci_probe & PCI_PROBE_MMCONF) == 0)
 		return;
 
-	acpi_table_parse(ACPI_MCFG, acpi_parse_mcfg);
+	if (type == 1 && pci_mmcfg_check_hostbridge())
+		known_bridge = 1;
+
+	if (!known_bridge)
+		acpi_table_parse(ACPI_MCFG, acpi_parse_mcfg);
 
 	if ((pci_mmcfg_config_num == 0) ||
 	    (pci_mmcfg_config == NULL) ||
@@ -68,8 +178,8 @@ void __init pci_mmcfg_init(int type)
 		return;
 
 	/* Only do this check when type 1 works. If it doesn't work
-           assume we run on a Mac and always use MCFG */
-	if (type == 1 &&
+	   assume we run on a Mac and always use MCFG */
+	if (type == 1 && !known_bridge &&
 	    !e820_all_mapped(pci_mmcfg_config[0].base_address,
 			     pci_mmcfg_config[0].base_address + MMCONFIG_APER_MIN,
 			     E820_RESERVED)) {
_

Patches currently in -mm which might be from galibert@pobox.com are
