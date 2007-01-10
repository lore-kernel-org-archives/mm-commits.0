From: akpm@osdl.org
Subject: - pci-mmconfig-only-map-whats-necessary.patch removed from -mm tree
Date: Wed, 10 Jan 2007 15:02:31 -0800
Message-ID: <200701102302.l0AN2Vep010744@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33311 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965245AbXAJXDR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 18:03:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: galibert@pobox.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     PCI MMConfig: Only map what's necessary.
has been removed from the -mm tree.  Its filename was
     pci-mmconfig-only-map-whats-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: PCI MMConfig: Only map what's necessary.
From: Olivier Galibert <galibert@pobox.com>

The x86-64 mmconfig code always map a range of MMCONFIG_APER_MAX bytes, i.e. 
256MB, whatever the number of accessible busses is.  Fix it, and add the end
of the zone in the printk while we're at it.

Signed-off-by: Olivier Galibert <galibert@pobox.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/pci/mmconfig.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/pci/mmconfig.c~pci-mmconfig-only-map-whats-necessary arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~pci-mmconfig-only-map-whats-necessary
+++ a/arch/x86_64/pci/mmconfig.c
@@ -13,10 +13,6 @@
 
 #include "pci.h"
 
-/* aperture is up to 256MB but BIOS may reserve less */
-#define MMCONFIG_APER_MIN	(2 * 1024*1024)
-#define MMCONFIG_APER_MAX	(256 * 1024*1024)
-
 /* Verify the first 16 busses. We assume that systems with more busses
    get MCFG right. */
 #define PCI_MMCFG_MAX_CHECK_BUS 16
@@ -143,17 +139,19 @@ int __init pci_mmcfg_arch_init(void)
 	}
 
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
+		u32 size = (pci_mmcfg_config[0].end_bus_number - pci_mmcfg_config[0].start_bus_number + 1) << 20;
 		pci_mmcfg_virt[i].cfg = &pci_mmcfg_config[i];
 		pci_mmcfg_virt[i].virt = ioremap_nocache(pci_mmcfg_config[i].base_address,
-							 MMCONFIG_APER_MAX);
+							 size);
 		if (!pci_mmcfg_virt[i].virt) {
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 			       pci_mmcfg_config[i].pci_segment_group_number);
 			return 0;
 		}
-		printk(KERN_INFO "PCI: Using MMCONFIG at %x\n",
-		       pci_mmcfg_config[i].base_address);
+		printk(KERN_INFO "PCI: Using MMCONFIG at %x-%x\n",
+		       pci_mmcfg_config[i].base_address,
+		       pci_mmcfg_config[i].base_address + size - 1);
 	}
 
 	raw_pci_ops = &pci_mmcfg;
_

Patches currently in -mm which might be from galibert@pobox.com are
