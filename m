From: akpm@linux-foundation.org
Subject: - intel-iommu-iommu-gfx-workaround.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:02 -0700
Message-ID: <200710230647.l9N6l24E004257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbXJWGrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, jengelh@gmx.demu


The patch titled
     Intel IOMMU: Iommu Gfx workaround
has been removed from the -mm tree.  Its filename was
     intel-iommu-iommu-gfx-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Intel IOMMU: Iommu Gfx workaround
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

When we fix all the opensource gfx drivers to use the DMA api's, at that time
we can yank this config options out.

[jengelh@computergmbh.de: Kconfig fixes]
Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Intel-IOMMU.txt |    5 ++++
 arch/x86/kernel/e820_64.c     |   19 ++++++++++++++++++
 arch/x86_64/Kconfig           |   19 ++++++++++++++----
 drivers/pci/intel-iommu.c     |   33 ++++++++++++++++++++++++++++++++
 drivers/pci/intel-iommu.h     |    7 ++++++
 5 files changed, 79 insertions(+), 4 deletions(-)

diff -puN Documentation/Intel-IOMMU.txt~intel-iommu-iommu-gfx-workaround Documentation/Intel-IOMMU.txt
--- a/Documentation/Intel-IOMMU.txt~intel-iommu-iommu-gfx-workaround
+++ a/Documentation/Intel-IOMMU.txt
@@ -57,6 +57,11 @@ Graphics Problems?
 If you encounter issues with graphics devices, you can try adding
 option intel_iommu=igfx_off to turn off the integrated graphics engine.
 
+If it happens to be a PCI device included in the INCLUDE_ALL Engine,
+then try enabling CONFIG_DMAR_GFX_WA to setup a 1-1 map. We hear
+graphics drivers may be in process of using DMA api's in the near
+future and at that time this option can be yanked out.
+
 Some exceptions to IOVA
 -----------------------
 Interrupt ranges are not address translated, (0xfee00000 - 0xfeefffff).
diff -puN arch/x86/kernel/e820_64.c~intel-iommu-iommu-gfx-workaround arch/x86/kernel/e820_64.c
--- a/arch/x86/kernel/e820_64.c~intel-iommu-iommu-gfx-workaround
+++ a/arch/x86/kernel/e820_64.c
@@ -729,3 +729,22 @@ __init void e820_setup_gap(void)
 	printk(KERN_INFO "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
 		pci_mem_start, gapstart, gapsize);
 }
+
+int __init arch_get_ram_range(int slot, u64 *addr, u64 *size)
+{
+	int i;
+
+	if (slot < 0 || slot >= e820.nr_map)
+		return -1;
+	for (i = slot; i < e820.nr_map; i++) {
+		if (e820.map[i].type != E820_RAM)
+			continue;
+		break;
+	}
+	if (i == e820.nr_map || e820.map[i].addr > (max_pfn << PAGE_SHIFT))
+		return -1;
+	*addr = e820.map[i].addr;
+	*size = min_t(u64, e820.map[i].size + e820.map[i].addr,
+		max_pfn << PAGE_SHIFT) - *addr;
+	return i + 1;
+}
diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-gfx-workaround arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-gfx-workaround
+++ a/arch/x86_64/Kconfig
@@ -755,11 +755,22 @@ config DMAR
 	depends on PCI_MSI && ACPI && EXPERIMENTAL
 	default y
 	help
-	  DMA remapping(DMAR) devices support enables independent address
-	  translations for Direct Memory Access(DMA) from Devices.
+	  DMA remapping (DMAR) devices support enables independent address
+	  translations for Direct Memory Access (DMA) from devices.
 	  These DMA remapping devices are reported via ACPI tables
-	  and includes pci device scope covered by these DMA
-	  remapping device.
+	  and include PCI device scope covered by these DMA
+	  remapping devices.
+
+config DMAR_GFX_WA
+	bool "Support for Graphics workaround"
+	depends on DMAR
+	default y
+	help
+	 Current Graphics drivers tend to use physical address
+	 for DMA and avoid using DMA APIs. Setting this config
+	 option permits the IOMMU driver to set a unity map for
+	 all the OS-visible memory. Hence the driver can continue
+	 to use physical addresses for DMA.
 
 source "drivers/pci/pcie/Kconfig"
 
diff -puN drivers/pci/intel-iommu.c~intel-iommu-iommu-gfx-workaround drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-iommu-gfx-workaround
+++ a/drivers/pci/intel-iommu.c
@@ -1602,6 +1602,36 @@ static inline int iommu_prepare_rmrr_dev
 		rmrr->end_address + 1);
 }
 
+#ifdef CONFIG_DMAR_GFX_WA
+extern int arch_get_ram_range(int slot, u64 *addr, u64 *size);
+static void __init iommu_prepare_gfx_mapping(void)
+{
+	struct pci_dev *pdev = NULL;
+	u64 base, size;
+	int slot;
+	int ret;
+
+	for_each_pci_dev(pdev) {
+		if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO ||
+				!IS_GFX_DEVICE(pdev))
+			continue;
+		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
+			pci_name(pdev));
+		slot = arch_get_ram_range(0, &base, &size);
+		while (slot >= 0) {
+			ret = iommu_prepare_identity_map(pdev,
+					base, base + size);
+			if (ret)
+				goto error;
+			slot = arch_get_ram_range(slot, &base, &size);
+		}
+		continue;
+error:
+		printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
+	}
+}
+#endif
+
 int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1665,6 +1695,8 @@ int __init init_dmars(void)
 		}
 	}
 
+	iommu_prepare_gfx_mapping();
+
 	/*
 	 * for each drhd
 	 *   enable fault log
@@ -2176,3 +2208,4 @@ int __init intel_iommu_init(void)
 	dma_ops = &intel_dma_ops;
 	return 0;
 }
+
diff -puN drivers/pci/intel-iommu.h~intel-iommu-iommu-gfx-workaround drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~intel-iommu-iommu-gfx-workaround
+++ a/drivers/pci/intel-iommu.h
@@ -315,4 +315,11 @@ struct intel_iommu {
 	struct sys_device sysdev;
 };
 
+#ifndef CONFIG_DMAR_GFX_WA
+static inline void iommu_prepare_gfx_mapping(void)
+{
+	return;
+}
+#endif /* !CONFIG_DMAR_GFX_WA */
+
 #endif
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

origin.patch
