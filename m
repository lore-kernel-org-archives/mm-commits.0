From: akpm@linux-foundation.org
Subject: + intel-iommu-pmen-support.patch added to -mm tree
Date: Mon, 19 Nov 2007 16:38:08 -0800
Message-ID: <200711200038.lAK0c8jS004793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40136 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755336AbXKTAir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Nov 2007 19:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgross@linux.intel.com, mgross@intel.com, muli@il.ibm.com


The patch titled
     intel-iommu: PMEN support
has been added to the -mm tree.  Its filename is
     intel-iommu-pmen-support.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: intel-iommu: PMEN support
From: mark gross <mgross@linux.intel.com>

Add support for protected memory enable bits by clearing them if they are
set at startup time.  Some future boot loaders or firmware could have this
bit set after it loads the kernel, and it needs to be cleared if DMA's are
going to happen effectively.

Signed-off-by: mark gross <mgross@intel.com>
Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/intel-iommu.c |   21 ++++++++++++++++++++-
 drivers/pci/intel-iommu.h |    4 ++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff -puN drivers/pci/intel-iommu.c~intel-iommu-pmen-support drivers/pci/intel-iommu.c
--- a/drivers/pci/intel-iommu.c~intel-iommu-pmen-support
+++ a/drivers/pci/intel-iommu.c
@@ -692,6 +692,23 @@ static int iommu_flush_iotlb_psi(struct 
 		DMA_TLB_PSI_FLUSH, non_present_entry_flush);
 }
 
+static void iommu_disable_protect_mem_regions(struct intel_iommu *iommu)
+{
+	u32 pmen;
+	unsigned long flags;
+
+	spin_lock_irqsave(&iommu->register_lock, flags);
+	pmen = readl(iommu->reg + DMAR_PMEN_REG);
+	pmen &= ~DMA_PMEN_EPM;
+	writel(pmen, iommu->reg + DMAR_PMEN_REG);
+
+	/* wait for the protected region status bit to clear */
+	IOMMU_WAIT_OP(iommu, DMAR_PMEN_REG,
+		readl, (pmen & DMA_PMEN_PRS), pmen);
+
+	spin_unlock_irqrestore(&iommu->register_lock, flags);
+}
+
 static int iommu_enable_translation(struct intel_iommu *iommu)
 {
 	u32 sts;
@@ -745,7 +762,7 @@ static char *fault_reason_strings[] =
 	"non-zero reserved fields in PTE",
 	"Unknown"
 };
-#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1
+#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)
 
 char *dmar_get_fault_reason(u8 fault_reason)
 {
@@ -1730,6 +1747,8 @@ int __init init_dmars(void)
 		iommu_flush_context_global(iommu, 0);
 		iommu_flush_iotlb_global(iommu, 0);
 
+		iommu_disable_protect_mem_regions(iommu);
+
 		ret = iommu_enable_translation(iommu);
 		if (ret)
 			goto error;
diff -puN drivers/pci/intel-iommu.h~intel-iommu-pmen-support drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~intel-iommu-pmen-support
+++ a/drivers/pci/intel-iommu.h
@@ -139,6 +139,10 @@ static inline void dmar_writeq(void __io
 #define DMA_TLB_IH_NONLEAF (((u64)1) << 6)
 #define DMA_TLB_MAX_SIZE (0x3f)
 
+/* PMEN_REG */
+#define DMA_PMEN_EPM (((u32)1)<<31)
+#define DMA_PMEN_PRS (((u32)1)<<0)
+
 /* GCMD_REG */
 #define DMA_GCMD_TE (((u32)1) << 31)
 #define DMA_GCMD_SRTP (((u32)1) << 30)
_

Patches currently in -mm which might be from mgross@linux.intel.com are

pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
pm-qos-remove-locks-around-blocking-notifier.patch
latencyc-use-qos-infrastructure.patch
intel-iommu-pmen-support.patch
