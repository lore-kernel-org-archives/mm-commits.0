From: akpm@linux-foundation.org
Subject: [merged] replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch removed from -mm tree
Date: Tue, 07 Apr 2009 12:07:53 -0700
Message-ID: <200904071907.n37J7r5m011520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51700 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548AbZDGTJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 15:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yanghy@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: replace all DMA_40BIT_MASK macro with DMA_BIT_MASK(40)
has been removed from the -mm tree.  Its filename was
     replace-all-dma_40bit_mask-macro-with-dma_bit_mask40.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: replace all DMA_40BIT_MASK macro with DMA_BIT_MASK(40)
From: Yang Hongyang <yanghy@cn.fujitsu.com>

Replace all DMA_40BIT_MASK macro with DMA_BIT_MASK(40)

Signed-off-by: Yang Hongyang<yanghy@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/pci-dma.c          |    2 +-
 arch/x86/kernel/pci-dma.c           |    2 +-
 drivers/net/bnx2.c                  |    2 +-
 drivers/net/enic/enic_main.c        |    4 ++--
 drivers/net/ipg.c                   |    2 +-
 drivers/net/tg3.c                   |    6 +++---
 drivers/scsi/sym53c8xx_2/sym_hipd.h |    2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/ia64/kernel/pci-dma.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40 arch/ia64/kernel/pci-dma.c
--- a/arch/ia64/kernel/pci-dma.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40
+++ a/arch/ia64/kernel/pci-dma.c
@@ -90,7 +90,7 @@ int iommu_dma_supported(struct device *d
 	   SAC for these.  Assume all masks <= 40 bits are of this
 	   type. Normally this doesn't make any difference, but gives
 	   more gentle handling of IOMMU overflow. */
-	if (iommu_sac_force && (mask >= DMA_40BIT_MASK)) {
+	if (iommu_sac_force && (mask >= DMA_BIT_MASK(40))) {
 		dev_info(dev, "Force SAC with mask %lx\n", mask);
 		return 0;
 	}
diff -puN arch/x86/kernel/pci-dma.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40 arch/x86/kernel/pci-dma.c
--- a/arch/x86/kernel/pci-dma.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40
+++ a/arch/x86/kernel/pci-dma.c
@@ -258,7 +258,7 @@ int dma_supported(struct device *dev, u6
 	   SAC for these.  Assume all masks <= 40 bits are of this
 	   type. Normally this doesn't make any difference, but gives
 	   more gentle handling of IOMMU overflow. */
-	if (iommu_sac_force && (mask >= DMA_40BIT_MASK)) {
+	if (iommu_sac_force && (mask >= DMA_BIT_MASK(40))) {
 		dev_info(dev, "Force SAC with mask %Lx\n", mask);
 		return 0;
 	}
diff -puN drivers/net/bnx2.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40 drivers/net/bnx2.c
--- a/drivers/net/bnx2.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40
+++ a/drivers/net/bnx2.c
@@ -7473,7 +7473,7 @@ bnx2_init_board(struct pci_dev *pdev, st
 
 	/* 5708 cannot support DMA addresses > 40-bit.  */
 	if (CHIP_NUM(bp) == CHIP_NUM_5708)
-		persist_dma_mask = dma_mask = DMA_40BIT_MASK;
+		persist_dma_mask = dma_mask = DMA_BIT_MASK(40);
 	else
 		persist_dma_mask = dma_mask = DMA_BIT_MASK(64);
 
diff -puN drivers/net/enic/enic_main.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40 drivers/net/enic/enic_main.c
--- a/drivers/net/enic/enic_main.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40
+++ a/drivers/net/enic/enic_main.c
@@ -1685,7 +1685,7 @@ static int __devinit enic_probe(struct p
 	 * fail to 32-bit.
 	 */
 
-	err = pci_set_dma_mask(pdev, DMA_40BIT_MASK);
+	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(40));
 	if (err) {
 		err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (err) {
@@ -1701,7 +1701,7 @@ static int __devinit enic_probe(struct p
 			goto err_out_release_regions;
 		}
 	} else {
-		err = pci_set_consistent_dma_mask(pdev, DMA_40BIT_MASK);
+		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(40));
 		if (err) {
 			printk(KERN_ERR PFX
 				"Unable to obtain 40-bit DMA "
diff -puN drivers/net/ipg.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40 drivers/net/ipg.c
--- a/drivers/net/ipg.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40
+++ a/drivers/net/ipg.c
@@ -2240,7 +2240,7 @@ static int __devinit ipg_probe(struct pc
 
 	pci_set_master(pdev);
 
-	rc = pci_set_dma_mask(pdev, DMA_40BIT_MASK);
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(40));
 	if (rc < 0) {
 		rc = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
 		if (rc < 0) {
diff -puN drivers/net/tg3.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40 drivers/net/tg3.c
--- a/drivers/net/tg3.c~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40
+++ a/drivers/net/tg3.c
@@ -4975,7 +4975,7 @@ static inline int tg3_40bit_overflow_tes
 {
 #if defined(CONFIG_HIGHMEM) && (BITS_PER_LONG == 64)
 	if (tp->tg3_flags & TG3_FLAG_40BIT_DMA_BUG)
-		return (((u64) mapping + len) > DMA_40BIT_MASK);
+		return (((u64) mapping + len) > DMA_BIT_MASK(40));
 	return 0;
 #else
 	return 0;
@@ -13230,7 +13230,7 @@ static int __devinit tg3_init_one(struct
 	if (tp->tg3_flags2 & TG3_FLG2_IS_5788)
 		persist_dma_mask = dma_mask = DMA_32BIT_MASK;
 	else if (tp->tg3_flags & TG3_FLAG_40BIT_DMA_BUG) {
-		persist_dma_mask = dma_mask = DMA_40BIT_MASK;
+		persist_dma_mask = dma_mask = DMA_BIT_MASK(40);
 #ifdef CONFIG_HIGHMEM
 		dma_mask = DMA_BIT_MASK(64);
 #endif
@@ -13394,7 +13394,7 @@ static int __devinit tg3_init_one(struct
 	printk(KERN_INFO "%s: dma_rwctrl[%08x] dma_mask[%d-bit]\n",
 	       dev->name, tp->dma_rwctrl,
 	       (pdev->dma_mask == DMA_32BIT_MASK) ? 32 :
-	        (((u64) pdev->dma_mask == DMA_40BIT_MASK) ? 40 : 64));
+	        (((u64) pdev->dma_mask == DMA_BIT_MASK(40)) ? 40 : 64));
 
 	return 0;
 
diff -puN drivers/scsi/sym53c8xx_2/sym_hipd.h~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40 drivers/scsi/sym53c8xx_2/sym_hipd.h
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h~replace-all-dma_40bit_mask-macro-with-dma_bit_mask40
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1087,7 +1087,7 @@ do {						\
 	(data)->size = cpu_to_scr(len);		\
 } while (0)
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 1
-#define DMA_DAC_MASK	DMA_40BIT_MASK
+#define DMA_DAC_MASK	DMA_BIT_MASK(40)
 #define sym_build_sge(np, data, badd, len)				\
 do {									\
 	(data)->addr = cpu_to_scr(badd);				\
_

Patches currently in -mm which might be from yanghy@cn.fujitsu.com are

origin.patch

