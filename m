From: akpm@osdl.org
Subject: - mmconfig-fix-x86_64-ioremap-base_address.patch removed from -mm tree
Date: Thu, 04 Jan 2007 15:14:42 -0800
Message-ID: <200701042314.l04NEgUc002140@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35105 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030260AbXADXOt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 4 Jan 2007 18:14:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hogawa@miraclelinux.com, ak@suse.de, arjan@linux.intel.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     MMCONFIG: Fix x86_64 ioremap base_address
has been removed from the -mm tree.  Its filename was
     mmconfig-fix-x86_64-ioremap-base_address.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: MMCONFIG: Fix x86_64 ioremap base_address
From: OGAWA Hirofumi <hogawa@miraclelinux.com>

Current mmconfig has some problems of remapped range.

a) In the case of broken MCFG tables on Asus etc., we need to remap 256M
   range, but currently only remap 1M.

b) The base address always corresponds to bus number 0, but currently we
   are assuming it corresponds to start bus number.

This patch fixes the above problems.

(akpm: Arjan suggests that if the MCFG table is broken we just shouldn't use
it, rather than try to work around things).

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/pci/mmconfig.c |   48 +++++++++++++++++++++++++----------
 1 files changed, 35 insertions(+), 13 deletions(-)

diff -puN arch/x86_64/pci/mmconfig.c~mmconfig-fix-x86_64-ioremap-base_address arch/x86_64/pci/mmconfig.c
--- a/arch/x86_64/pci/mmconfig.c~mmconfig-fix-x86_64-ioremap-base_address
+++ a/arch/x86_64/pci/mmconfig.c
@@ -24,6 +24,39 @@ struct mmcfg_virt {
 };
 static struct mmcfg_virt *pci_mmcfg_virt;
 
+static inline int mcfg_broken(void)
+{
+	struct acpi_table_mcfg_config *cfg = &pci_mmcfg_config[0];
+
+	/* Handle more broken MCFG tables on Asus etc.
+	   They only contain a single entry for bus 0-0. Assume
+ 	   this applies to all busses. */
+	if (pci_mmcfg_config_num == 1 &&
+	    cfg->pci_segment_group_number == 0 &&
+	    (cfg->start_bus_number | cfg->end_bus_number) == 0)
+		return 1;
+	return 0;
+}
+
+static void __iomem *mcfg_ioremap(struct acpi_table_mcfg_config *cfg)
+{
+	void __iomem *addr;
+	u32 size;
+
+	if (mcfg_broken())
+		size = 256 << 20;
+	else
+		size = (cfg->end_bus_number + 1) << 20;
+
+	addr = ioremap_nocache(cfg->base_address, size);
+	if (addr) {
+		printk(KERN_INFO "PCI: Using MMCONFIG at %x - %x\n",
+		       cfg->base_address,
+		       cfg->base_address + size - 1);
+	}
+	return addr;
+}
+
 static char __iomem *get_virt(unsigned int seg, unsigned bus)
 {
 	int cfg_num = -1;
@@ -41,13 +74,7 @@ static char __iomem *get_virt(unsigned i
 			return pci_mmcfg_virt[cfg_num].virt;
 	}
 
-	/* Handle more broken MCFG tables on Asus etc.
-	   They only contain a single entry for bus 0-0. Assume
- 	   this applies to all busses. */
-	cfg = &pci_mmcfg_config[0];
-	if (pci_mmcfg_config_num == 1 &&
-		cfg->pci_segment_group_number == 0 &&
-		(cfg->start_bus_number | cfg->end_bus_number) == 0)
+	if (mcfg_broken())
 		return pci_mmcfg_virt[0].virt;
 
 	/* Fall back to type 0 */
@@ -139,19 +166,14 @@ int __init pci_mmcfg_arch_init(void)
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

Patches currently in -mm which might be from hogawa@miraclelinux.com are

mmconfig-fix-x86_64-ioremap-base_address.patch
