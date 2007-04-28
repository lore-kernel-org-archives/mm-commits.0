From: akpm@linux-foundation.org
Subject: + support-pci-mcfg-space-on-intel-i915-bridges.patch added to -mm tree
Date: Fri, 27 Apr 2007 17:10:57 -0700
Message-ID: <200704280010.l3S0Avpb011253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757945AbXD1ALG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 20:11:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesse.barnes@intel.com, ak@suse.de, galibert@pobox.com, greg@kroah.com


The patch titled
     i386: support PCI MCFG space on Intel i915 bridges
has been added to the -mm tree.  Its filename is
     support-pci-mcfg-space-on-intel-i915-bridges.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: support PCI MCFG space on Intel i915 bridges
From: Jesse Barnes <jesse.barnes@intel.com>

Add support for Intel 915 bridge chips to the new PCI MMConfig detection
code.  Tested and works on my sole 915 based platform (a Toshiba laptop). 
I added register masking per Oliver's suggestion, and moved the __init
qualifier to after the 'static const char' to match Ogawa-san's recent
cleanup patches.

Signed-off-by: Jesse Barnes <jesse.barnes@intel.com>
Cc: Olivier Galibert <galibert@pobox.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/pci/mmconfig-shared.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+)

diff -puN arch/i386/pci/mmconfig-shared.c~support-pci-mcfg-space-on-intel-i915-bridges arch/i386/pci/mmconfig-shared.c
--- a/arch/i386/pci/mmconfig-shared.c~support-pci-mcfg-space-on-intel-i915-bridges
+++ a/arch/i386/pci/mmconfig-shared.c
@@ -72,6 +72,26 @@ static const char __init *pci_mmcfg_e752
 	return "Intel Corporation E7520 Memory Controller Hub";
 }
 
+static const char __init *pci_mmcfg_intel_915(void)
+{
+       u32 pciexbar, len = 0;
+
+       pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+
+       /* No enable bit or size field, so assume 256M range is enabled. */
+       len = 0x10000000U;
+       pci_mmcfg_config_num = 1;
+       pciexbar &= 0xe0000000; /* mask out potentially bogus bits */
+
+       pci_mmcfg_config = kzalloc(sizeof(pci_mmcfg_config[0]), GFP_KERNEL);
+       pci_mmcfg_config[0].address = pciexbar;
+       pci_mmcfg_config[0].pci_segment = 0;
+       pci_mmcfg_config[0].start_bus_number = 0;
+       pci_mmcfg_config[0].end_bus_number = (len >> 20) - 1;
+
+       return "Intel Corporation 915PM/GM/GMS Express Memory Controller Hub";
+}
+
 static const char __init *pci_mmcfg_intel_945(void)
 {
 	u32 pciexbar, mask = 0, len = 0;
@@ -129,6 +149,7 @@ struct pci_mmcfg_hostbridge_probe {
 
 static struct pci_mmcfg_hostbridge_probe pci_mmcfg_probes[] __initdata = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_E7520_MCH, pci_mmcfg_e7520 },
+	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82915GM_HB, pci_mmcfg_intel_915 },
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82945G_HB, pci_mmcfg_intel_945 },
 };
 
_

Patches currently in -mm which might be from jesse.barnes@intel.com are

remove-pci_dac_dma_-apis.patch
support-pci-mcfg-space-on-intel-i915-bridges.patch
