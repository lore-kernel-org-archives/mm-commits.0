From: akpm@linux-foundation.org
Subject: - intel-iommu-iommu-floppy-workaround.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:05 -0700
Message-ID: <200710230647.l9N6l5Yq004260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751944AbXJWGrk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:47:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, a.p.zijlstra@chello.nl, ak@suse.de, arjan@infradead.org, ashok.raj@intel.com, clameter@sgi.com, davem@davemloft.net, greg@kroah.com, jengelh@gmx.demu


The patch titled
     Intel IOMMU: Iommu floppy workaround
has been removed from the -mm tree.  Its filename was
     intel-iommu-iommu-floppy-workaround.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Intel IOMMU: Iommu floppy workaround
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

This config option (DMAR_FLPY_WA) sets up 1:1 mapping for the floppy device so
that the floppy device which does not use DMA api's will continue to work.

Once the floppy driver starts using DMA api's this config option can be turn
off or this patch can be yanked out of kernel at that time.

[akpm@linux-foundation.org: cleanups, rename things, build fix]
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

 arch/x86_64/Kconfig       |   10 ++++++++++
 drivers/pci/intel-iommu.c |   27 +++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff -puN arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~intel-iommu-iommu-floppy-workaround
+++ a/arch/x86_64/Kconfig
@@ -772,6 +772,16 @@ config DMAR_GFX_WA
 	 all the OS-visible memory. Hence the driver can continue
 	 to use physical addresses for DMA.
 
+config DMAR_FLOPPY_WA
+	bool
+	depends on DMAR
+	default y
+	help
+	 Floppy disk drivers are know to bypass DMA API calls
+	 thereby failing to work when IOMMU is enabled. This
+	 workaround will setup a 1:1 mapping for the first
+	 16M to make floppy (an ISA device) work.
+
 source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pci/Kconfig"
diff -puN drivers/pci/intel-iommu.c~intel-iommu-iommu-floppy-workaround drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-iommu-floppy-workaround
+++ a/drivers/pci/intel-iommu.c
@@ -1632,6 +1632,31 @@ error:
 }
 #endif
 
+#ifdef CONFIG_DMAR_FLOPPY_WA
+static inline void iommu_prepare_isa(void)
+{
+	struct pci_dev *pdev;
+	int ret;
+
+	pdev = pci_get_class(PCI_CLASS_BRIDGE_ISA << 8, NULL);
+	if (!pdev)
+		return;
+
+	printk(KERN_INFO "IOMMU: Prepare 0-16M unity mapping for LPC\n");
+	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
+
+	if (ret)
+		printk("IOMMU: Failed to create 0-64M identity map, "
+			"floppy might not work\n");
+
+}
+#else
+static inline void iommu_prepare_isa(void)
+{
+	return;
+}
+#endif /* !CONFIG_DMAR_FLPY_WA */
+
 int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
@@ -1697,6 +1722,8 @@ int __init init_dmars(void)
 
 	iommu_prepare_gfx_mapping();
 
+	iommu_prepare_isa();
+
 	/*
 	 * for each drhd
 	 *   enable fault log
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

origin.patch
