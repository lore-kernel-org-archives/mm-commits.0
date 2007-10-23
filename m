From: akpm@linux-foundation.org
Subject: - intel-iommu-fix-for-iommu-early-crash-2.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:11 -0700
Message-ID: <200710230647.l9N6lBRc004266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35804 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751627AbXJWHBr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 03:01:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, benh@kernel.crashing.org, greg@kroah.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     intel-iommu: fix for IOMMU early crash
has been removed from the -mm tree.  Its filename was
     intel-iommu-fix-for-iommu-early-crash-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: intel-iommu: fix for IOMMU early crash
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

pci_dev's->sysdata is highly overloaded and currently IOMMU is broken due
to IOMMU code depending on this field.

This patch introduces new field in pci_dev's dev.archdata struct to hold
IOMMU specific per device IOMMU private data.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   22 +++++++++++-----------
 include/asm-x86/device.h  |    3 +++
 2 files changed, 14 insertions(+), 11 deletions(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-fix-for-iommu-early-crash-2 drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-fix-for-iommu-early-crash-2
+++ a/drivers/pci/intel-iommu.c
@@ -1348,7 +1348,7 @@ static void domain_remove_dev_info(struc
 		list_del(&info->link);
 		list_del(&info->global);
 		if (info->dev)
-			info->dev->sysdata = NULL;
+			info->dev->dev.archdata.iommu = NULL;
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 
 		detach_domain_for_dev(info->domain, info->bus, info->devfn);
@@ -1361,7 +1361,7 @@ static void domain_remove_dev_info(struc
 
 /*
  * find_domain
- * Note: we use struct pci_dev->sysdata stores the info
+ * Note: we use struct pci_dev->dev.archdata.iommu stores the info
  */
 struct dmar_domain *
 find_domain(struct pci_dev *pdev)
@@ -1369,7 +1369,7 @@ find_domain(struct pci_dev *pdev)
 	struct device_domain_info *info;
 
 	/* No lock here, assumes no domain exit in normal case */
-	info = pdev->sysdata;
+	info = pdev->dev.archdata.iommu;
 	if (info)
 		return info->domain;
 	return NULL;
@@ -1519,7 +1519,7 @@ found_domain:
 	}
 	list_add(&info->link, &domain->devices);
 	list_add(&info->global, &device_domain_list);
-	pdev->sysdata = info;
+	pdev->dev.archdata.iommu = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 	return domain;
 error:
@@ -1579,7 +1579,7 @@ error:
 static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
 	struct pci_dev *pdev)
 {
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return 0;
 	return iommu_prepare_identity_map(pdev, rmrr->base_address,
 		rmrr->end_address + 1);
@@ -1595,7 +1595,7 @@ static void __init iommu_prepare_gfx_map
 	int ret;
 
 	for_each_pci_dev(pdev) {
-		if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO ||
+		if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO ||
 				!IS_GFX_DEVICE(pdev))
 			continue;
 		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
@@ -1836,7 +1836,7 @@ static dma_addr_t intel_map_single(struc
 	int prot = 0;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return virt_to_bus(addr);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -1900,7 +1900,7 @@ static void intel_unmap_single(struct de
 	unsigned long start_addr;
 	struct iova *iova;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
@@ -1974,7 +1974,7 @@ static void intel_unmap_sg(struct device
 	size_t size = 0;
 	void *addr;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
@@ -2032,7 +2032,7 @@ static int intel_map_sg(struct device *h
 	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->dev.archdata.iommu == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -2234,7 +2234,7 @@ static void __init init_no_remapping_dev
 		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (!drhd->devices[i])
 				continue;
-			drhd->devices[i]->sysdata = DUMMY_DEVICE_DOMAIN_INFO;
+			drhd->devices[i]->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
 }
diff -puN include/asm-x86/device.h~intel-iommu-fix-for-iommu-early-crash-2 include/asm-x86/device.h
--- a/include/asm-x86/device.h~intel-iommu-fix-for-iommu-early-crash-2
+++ a/include/asm-x86/device.h
@@ -5,6 +5,9 @@ struct dev_archdata {
 #ifdef CONFIG_ACPI
 	void	*acpi_handle;
 #endif
+#ifdef CONFIG_DMAR
+	void *iommu; /* hook for IOMMU specific extension */
+#endif
 };
 
 #endif /* _ASM_X86_DEVICE_H */
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

origin.patch
