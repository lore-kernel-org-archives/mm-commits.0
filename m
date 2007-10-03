From: akpm@linux-foundation.org
Subject: + intel-iommu-fix-for-iommu-early-crash.patch added to -mm tree
Date: Wed, 03 Oct 2007 15:11:17 -0700
Message-ID: <200710032211.l93MBHsD011230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58292 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817AbXJCWLZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 18:11:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, greg@kroah.com, jeff@garzik.org


The patch titled
     intel-iommu: fix for IOMMU early crash
has been added to the -mm tree.  Its filename is
     intel-iommu-fix-for-iommu-early-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel-iommu: fix for IOMMU early crash
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

pci_dev's->sysdata is highly overloaded and currently IOMMU is broken due
to IOMMU code depending on this field.

This patch introduces new field in pci_dev's struct to hold IOMMU specific
per device IOMMU private data.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pci/intel-iommu.c~intel-iommu-fix-for-iommu-early-crash drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-fix-for-iommu-early-crash
+++ a/drivers/pci/intel-iommu.c
@@ -1348,7 +1348,7 @@ static void domain_remove_dev_info(struc
 		list_del(&info->link);
 		list_del(&info->global);
 		if (info->dev)
-			info->dev->sysdata = NULL;
+			info->dev->iommu_private = NULL;
 		spin_unlock_irqrestore(&device_domain_lock, flags);
 
 		detach_domain_for_dev(info->domain, info->bus, info->devfn);
@@ -1361,7 +1361,7 @@ static void domain_remove_dev_info(struc
 
 /*
  * find_domain
- * Note: we use struct pci_dev->sysdata stores the info
+ * Note: we use struct pci_dev->iommu_private stores the info
  */
 struct dmar_domain *
 find_domain(struct pci_dev *pdev)
@@ -1369,7 +1369,7 @@ find_domain(struct pci_dev *pdev)
 	struct device_domain_info *info;
 
 	/* No lock here, assumes no domain exit in normal case */
-	info = pdev->sysdata;
+	info = pdev->iommu_private;
 	if (info)
 		return info->domain;
 	return NULL;
@@ -1519,7 +1519,7 @@ found_domain:
 	}
 	list_add(&info->link, &domain->devices);
 	list_add(&info->global, &device_domain_list);
-	pdev->sysdata = info;
+	pdev->iommu_private = info;
 	spin_unlock_irqrestore(&device_domain_lock, flags);
 	return domain;
 error:
@@ -1579,7 +1579,7 @@ error:
 static inline int iommu_prepare_rmrr_dev(struct dmar_rmrr_unit *rmrr,
 	struct pci_dev *pdev)
 {
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return 0;
 	return iommu_prepare_identity_map(pdev, rmrr->base_address,
 		rmrr->end_address + 1);
@@ -1595,7 +1595,7 @@ static void __init iommu_prepare_gfx_map
 	int ret;
 
 	for_each_pci_dev(pdev) {
-		if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO ||
+		if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO ||
 				!IS_GFX_DEVICE(pdev))
 			continue;
 		printk(KERN_INFO "IOMMU: gfx device %s 1-1 mapping\n",
@@ -1836,7 +1836,7 @@ static dma_addr_t intel_map_single(struc
 	int prot = 0;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return virt_to_bus(addr);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -1900,7 +1900,7 @@ static void intel_unmap_single(struct de
 	unsigned long start_addr;
 	struct iova *iova;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 	domain = find_domain(pdev);
 	BUG_ON(!domain);
@@ -1974,7 +1974,7 @@ static void intel_unmap_sg(struct device
 	size_t size = 0;
 	void *addr;
 
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return;
 
 	domain = find_domain(pdev);
@@ -2032,7 +2032,7 @@ static int intel_map_sg(struct device *h
 	unsigned long start_addr;
 
 	BUG_ON(dir == DMA_NONE);
-	if (pdev->sysdata == DUMMY_DEVICE_DOMAIN_INFO)
+	if (pdev->iommu_private == DUMMY_DEVICE_DOMAIN_INFO)
 		return intel_nontranslate_map_sg(hwdev, sg, nelems, dir);
 
 	domain = get_valid_domain_for_dev(pdev);
@@ -2234,7 +2234,7 @@ static void __init init_no_remapping_dev
 		for (i = 0; i < drhd->devices_cnt; i++) {
 			if (!drhd->devices[i])
 				continue;
-			drhd->devices[i]->sysdata = DUMMY_DEVICE_DOMAIN_INFO;
+			drhd->devices[i]->iommu_private = DUMMY_DEVICE_DOMAIN_INFO;
 		}
 	}
 }
diff -puN include/linux/pci.h~intel-iommu-fix-for-iommu-early-crash include/linux/pci.h
--- a/include/linux/pci.h~intel-iommu-fix-for-iommu-early-crash
+++ a/include/linux/pci.h
@@ -195,6 +195,7 @@ struct pci_dev {
 #ifdef CONFIG_PCI_MSI
 	struct list_head msi_list;
 #endif
+	void		*iommu_private;	/* hook for IOMMU specific extension */
 };
 
 extern struct pci_dev *alloc_pci_dev(void);
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
kprobes-support-kretprobe-blacklist.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
intel-iommu-optimize-sg-map-unmap-calls.patch
intel-iommu-fix-for-iommu-early-crash.patch
intel-iommu-sg-chaining-support.patch
