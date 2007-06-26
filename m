From: akpm@linux-foundation.org
Subject: + intel-iommu-iommu-floppy-workaround.patch added to -mm tree
Date: Mon, 25 Jun 2007 23:43:09 -0700
Message-ID: <200706260643.l5Q6h9BY020250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbXFZGng (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 02:43:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, muli@il.ibm.com, suresh.b.siddha@intel.com


The patch titled
     Intel IOMMU: Iommu floppy workaround
has been added to the -mm tree.  Its filename is
     intel-iommu-iommu-floppy-workaround.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Intel IOMMU: Iommu floppy workaround
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

This config option (DMAR_FLPY_WA) sets up 1:1 mapping for the floppy device so
that the floppy device which does not use DMA api's will continue to work.

Once the floppy driver starts using DMA api's this config option can be turn
off or this patch can be yanked out of kernel at that time.

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

 arch/x86_64/Kconfig       |   10 ++++++++++
 drivers/pci/intel-iommu.c |   22 ++++++++++++++++++++++
 drivers/pci/intel-iommu.h |    7 +++++++
 3 files changed, 39 insertions(+)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround
+++ a/arch/x86_64/Kconfig
@@ -770,6 +770,16 @@ config DMAR_GFX_WA
 	 all the OS visible memory. Hence the driver can continue
 	 to use physical addresses for DMA.
 
+config DMAR_FLPY_WA
+	bool "Support for Floppy disk workaround"
+	depends on DMAR
+	default y
+	help
+	 Floppy disk drivers are know to by pass dma api calls
+	 their by failing to work when IOMMU is enabled. This
+	 work around will setup a 1 to 1 mappings for the first
+	 16M to make floppy(isa device) work.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff -puN drivers/pci/intel-iommu.c~intel-iommu-iommu-floppy-workaround drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-iommu-floppy-workaround
+++ a/drivers/pci/intel-iommu.c
@@ -1631,6 +1631,26 @@ error:
 }
 #endif
 
+#ifdef CONFIG_DMAR_FLPY_WA
+static inline void iommu_prepare_isa(void)
+{
+	struct pci_dev *pdev = NULL;
+	int ret;
+
+	pdev = pci_get_class (PCI_CLASS_BRIDGE_ISA << 8, NULL);
+	if (!pdev)
+		return;
+
+	printk (KERN_INFO "IOMMU: Prepare 0-16M unity mapping for LPC\n");
+	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
+
+	if (ret)
+		printk ("IOMMU: Failed to create 0-64M identity map, \
+			Floppy might not work\n");
+
+}
+#endif
+
 int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1696,6 +1716,8 @@ int __init init_dmars(void)
 
 	iommu_prepare_gfx_mapping();
 
+	iommu_prepare_isa();
+
 	/*
 	 * for each drhd
 	 *   enable fault log
diff -puN drivers/pci/intel-iommu.h~intel-iommu-iommu-floppy-workaround drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~intel-iommu-iommu-floppy-workaround
+++ a/drivers/pci/intel-iommu.h
@@ -322,4 +322,11 @@ static inline void iommu_prepare_gfx_map
 }
 #endif /* !CONFIG_DMAR_GFX_WA */
 
+#ifndef CONFIG_DMAR_FLPY_WA
+static inline void iommu_prepare_isa(void)
+{
+	return;
+}
+#endif /* !CONFIG_DMAR_FLPY_WA */
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
