From: akpm@linux-foundation.org
Subject: - x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:23 -0700
Message-ID: <200707192009.l6JK9NJO020575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756784AbXGSUPa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: muli@il.ibm.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86-64: Calgary: reserve TCEs with the same address as MEM regions
has been removed from the -mm tree.  Its filename was
     x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86-64: Calgary: reserve TCEs with the same address as MEM regions
From: Muli Ben-Yehuda <muli@il.ibm.com>

This works around a bug where DMAs that have the same addresses as
some MEM regions do not go through. Not clear yet if this is due to a
mis-configuration or something deeper.

[akpm@linux-foundation.org: coding style fixlet]
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/pci-calgary.c |   67 +++++++++++++++++++++++++++++
 1 files changed, 67 insertions(+)

diff -puN arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions arch/x86_64/kernel/pci-calgary.c
--- a/arch/x86_64/kernel/pci-calgary.c~x86-64-calgary-reserve-tces-with-the-same-address-as-mem-regions
+++ a/arch/x86_64/kernel/pci-calgary.c
@@ -1536,3 +1536,70 @@ static int __init calgary_parse_options(
 	return 1;
 }
 __setup("calgary=", calgary_parse_options);
+
+static void __init calgary_fixup_one_tce_space(struct pci_dev *dev)
+{
+	struct iommu_table *tbl;
+	unsigned int npages;
+	int i;
+
+	tbl = dev->sysdata;
+
+	for (i = 0; i < 4; i++) {
+		struct resource *r = &dev->resource[PCI_BRIDGE_RESOURCES + i];
+
+		/* Don't give out TCEs that map MEM resources */
+		if (!(r->flags & IORESOURCE_MEM))
+			continue;
+
+		/* 0-based? we reserve the whole 1st MB anyway */
+		if (!r->start)
+			continue;
+
+		/* cover the whole region */
+		npages = (r->end - r->start) >> PAGE_SHIFT;
+		npages++;
+
+		printk(KERN_DEBUG "Calg: dev %p [%x] tbl %p reserving "
+		       "0x%Lx-0x%Lx [0x%x pages]\n", dev, dev->bus->number,
+		       tbl, r->start, r->end, npages);
+
+		iommu_range_reserve(tbl, r->start, npages);
+	}
+}
+
+static int __init calgary_fixup_tce_spaces(void)
+{
+	struct pci_dev *dev = NULL;
+	void *tce_space;
+
+	if (no_iommu || swiotlb || !calgary_detected)
+		return -ENODEV;
+
+	printk(KERN_DEBUG "Calgary: fixing tce spaces\n");
+
+	do {
+		dev = pci_get_device(PCI_VENDOR_ID_IBM, PCI_ANY_ID, dev);
+		if (!dev)
+			break;
+		if (!is_cal_pci_dev(dev->device))
+			continue;
+		if (!translate_phb(dev))
+			continue;
+
+		tce_space = bus_info[dev->bus->number].tce_space;
+		if (!tce_space)
+			continue;
+
+		calgary_fixup_one_tce_space(dev);
+
+	} while (1);
+
+	return 0;
+}
+
+/*
+ * We need to be call after pcibios_assign_resources (fs_initcall level)
+ * and before device_initcall.
+ */
+rootfs_initcall(calgary_fixup_tce_spaces);
_

Patches currently in -mm which might be from muli@il.ibm.com are

origin.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
