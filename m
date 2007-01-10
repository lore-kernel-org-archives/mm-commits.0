From: akpm@osdl.org
Subject: - mmconfig-fix-x86_64-ioremap-base_address.patch removed from -mm tree
Date: Wed, 10 Jan 2007 14:46:24 -0800
Message-ID: <200701102246.l0AMkOtE010290@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60153 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965167AbXAJWqa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Jan 2007 17:46:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, ak@suse.de, arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     MMCONFIG: Fix x86_64 ioremap base_address
has been removed from the -mm tree.  Its filename was
     mmconfig-fix-x86_64-ioremap-base_address.patch

This patch was dropped because x86_64 tree changes trashed it

------------------------------------------------------
Subject: MMCONFIG: Fix x86_64 ioremap base_address
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Current mmconfig has some problems of remapped range.  The base address always
corresponds to bus number 0, but currently we are assuming it corresponds to
start bus number.

This patch fixes the above problems.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/pci/mmconfig.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/pci/mmconfig.c~mmconfig-fix-x86_64-ioremap-base_address arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~mmconfig-fix-x86_64-ioremap-base_address
+++ a/arch/x86_64/pci/mmconfig.c
@@ -118,6 +118,20 @@ int __init pci_mmcfg_arch_reachable(unsi
 	return pci_dev_base(seg, bus, devfn) != NULL;
 }
 
+static void __iomem * __init mcfg_ioremap(struct acpi_table_mcfg_config *cfg)
+{
+	void __iomem *addr;
+	u32 size;
+
+	size = (cfg->end_bus_number + 1) << 20;
+	addr = ioremap_nocache(cfg->base_address, size);
+	if (addr) {
+		printk(KERN_INFO "PCI: Using MMCONFIG at %x - %x\n",
+		       cfg->base_address, cfg->base_address + size - 1);
+	}
+	return addr;
+}
+
 int __init pci_mmcfg_arch_init(void)
 {
 	int i;
@@ -128,19 +142,14 @@ int __init pci_mmcfg_arch_init(void)
 	}
 
 	for (i = 0; i < pci_mmcfg_config_num; ++i) {
-		u32 size = (pci_mmcfg_config[0].end_bus_number - pci_mmcfg_config[0].start_bus_number + 1) << 20;
 		pci_mmcfg_virt[i].cfg = &pci_mmcfg_config[i];
-		pci_mmcfg_virt[i].virt = ioremap_nocache(pci_mmcfg_config[i].base_address,
-							 size);
+		pci_mmcfg_virt[i].virt = mcfg_ioremap(&pci_mmcfg_config[i]);
 		if (!pci_mmcfg_virt[i].virt) {
 			printk(KERN_ERR "PCI: Cannot map mmconfig aperture for "
 					"segment %d\n",
 			       pci_mmcfg_config[i].pci_segment_group_number);
 			return 0;
 		}
-		printk(KERN_INFO "PCI: Using MMCONFIG at %x-%x\n",
-		       pci_mmcfg_config[i].base_address,
-		       pci_mmcfg_config[i].base_address + size - 1);
 	}
 
 	raw_pci_ops = &pci_mmcfg;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

fix-the-reproducible-oops-in-scsi.patch
mmconfig-cleanup.patch
mmconfig-fix-unreachable_devices.patch
mmconfig-fix-x86_64-ioremap-base_address.patch
relax-check-for-aix-in-msdos-partition-table.patch
msdos-partitions-fix-logic-error-in-aix-detection.patch
