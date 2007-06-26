From: akpm@linux-foundation.org
Subject: + intel-iommu-iommu-gfx-workaround.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:43:07 -0700
Message-ID: <200706260643.l5Q6h75S020245@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891AbXFZGn0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: Iommu Gfx workaround
has been added to the -mm tree.  Its filename is
     intel-iommu-iommu-gfx-workaround.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel IOMMU: Iommu Gfx workaround
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

When we fix all the opensource gfx drivers to use the DMA api's, at that time
we can yank this config options out.

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Intel-IOMMU.txt |    5 ++++
 arch/x86_64/Kconfig           |   11 ++++++++++
 arch/x86_64/kernel/e820.c     |   19 ++++++++++++++++++
 drivers/pci/intel-iommu.c     |   33 ++++++++++++++++++++++++++++++++
 drivers/pci/intel-iommu.h     |    7 ++++++
 5 files changed, 75 insertions(+)

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
diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-gfx-workaround arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-gfx-workaround
+++ a/arch/x86_64/Kconfig
@@ -759,6 +759,17 @@ config DMAR
 	  and includes pci device scope covered by these DMA
 	  remapping device.
 
+config DMAR_GFX_WA
+	bool "Support for Graphics workaround"
+	depends on DMAR
+	default y
+	help
+	 Current Graphics drivers tend to use physical address
+	 for DMA and avoid using DMA api's. Setting this config
+	 option permits the IOMMU driver to set a unity map for
+	 all the OS visible memory. Hence the driver can continue
+	 to use physical addresses for DMA.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff -puN arch/x86_64/kernel/e820.c~intel-iommu-iommu-gfx-workaround arch/x86_64/kernel/e820.c
--- a/arch/x86_64/kernel/e820.c~intel-iommu-iommu-gfx-workaround
+++ a/arch/x86_64/kernel/e820.c
@@ -723,3 +723,22 @@ __init void e820_setup_gap(void)
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
diff -puN drivers/pci/intel-iommu.c~intel-iommu-iommu-gfx-workaround drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-iommu-gfx-workaround
+++ a/drivers/pci/intel-iommu.c
@@ -1601,6 +1601,36 @@ static inline int iommu_prepare_rmrr_dev
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
@@ -1664,6 +1694,8 @@ int __init init_dmars(void)
 		}
 	}
 
+	iommu_prepare_gfx_mapping();
+
 	/*
 	 * for each drhd
 	 *   enable fault log
@@ -2175,3 +2207,4 @@ int __init intel_iommu_init(void)
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

jprobes-make-struct-jprobeentry-a-void.patch
jprobes-remove-jprobe_entry.patch
jprobes-make-jprobes-a-little-safer-for-users.patch
jprobes-make-jprobes-a-little-safer-for-users-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
