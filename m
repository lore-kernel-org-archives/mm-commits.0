From: akpm@osdl.org
Subject: - pci-mmconfig-support-for-intel-915-bridges.patch removed from -mm tree
Date: Mon, 22 Jan 2007 12:47:25 -0800
Message-ID: <200701222047.l0MKlPe4001630@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932594AbXAVUsD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jan 2007 15:48:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbarnes@virtuousgeek.org, ak@suse.de, galibert@pobox.com, mm-commits@vger.kernel.org


The patch titled
     PCI mmconfig support for Intel 915 bridges
has been removed from the -mm tree.  Its filename was
     pci-mmconfig-support-for-intel-915-bridges.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI mmconfig support for Intel 915 bridges
From: Jesse Barnes <jbarnes@virtuousgeek.org>

Add support for Intel 915 bridge chips to the new PCI MMConfig detection
code.  Tested and works on my sole 915 based platform (a Toshiba laptop). 
I added register masking per Oliver's suggestion, and moved the __init
qualifier to after the 'static const char' to match Ogawa-san's recent
cleanup patches.

Over time we can probably associate more PCI IDs with this routine, since
i915 family contains a few other chips.  But since I didn't have platforms
to test such additions on, they're left out for now.

Signed-off-by:  Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Olivier Galibert <galibert@pobox.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/pci/mmconfig-shared.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+)

diff -puN arch/i386/pci/mmconfig-shared.c~pci-mmconfig-support-for-intel-915-bridges arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~pci-mmconfig-support-for-intel-915-bridges
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -70,6 +70,26 @@ static const char __init *pci_mmcfg_e752
 	return "Intel Corporation E7520 Memory Controller Hub";
 }
 
+static const char __init *pci_mmcfg_intel_915(void)
+{
+	u32 pciexbar, len = 0;
+
+	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+
+	/* No enable bit or size field, so assume 256M range is enabled. */
+	len = 0x10000000U;
+	pci_mmcfg_config_num = 1;
+	pciexbar &= 0xe0000000; /* mask out potentially bogus bits */
+
+	pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+	pci_mmcfg_config[0].base_address = pciexbar;
+	pci_mmcfg_config[0].pci_segment_group_number = 0;
+	pci_mmcfg_config[0].start_bus_number = 0;
+	pci_mmcfg_config[0].end_bus_number = (len >> 20) - 1;
+
+	return "Intel Corporation 915PM/GM/GMS Express Memory Controller Hub";
+}
+
 static const char __init *pci_mmcfg_intel_945(void)
 {
 	u32 pciexbar, mask = 0, len = 0;
@@ -125,6 +145,7 @@ struct pci_mmcfg_hostbridge_probe {
 
 static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82915GM_HB, pci_mmcfg_intel_915 },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
 };
 
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are
