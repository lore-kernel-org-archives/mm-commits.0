From: akpm@linux-foundation.org
Subject: [merged] dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:49 -0400
Message-ID: <201003150704.o2F74MKe017010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38637 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935979Ab0COHEe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:04:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     dma-mapping: arm: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
has been removed from the -mm tree.  Its filename was
     dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-mapping: arm: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This converts arm to the generic pci_set_dma_mask and
pci_set_consistent_dma_mask (removes HAVE_ARCH_PCI_SET_DMA_MASK for
dmabounce).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Looked-over-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/common/it8152.c                     |   27 -----------------
 arch/arm/include/asm/dma-mapping.h           |    8 +++++
 arch/arm/mach-ixp4xx/common-pci.c            |   26 ----------------
 arch/arm/mach-ixp4xx/include/mach/hardware.h |    5 ---
 arch/arm/mach-pxa/include/mach/hardware.h    |    1 
 5 files changed, 8 insertions(+), 59 deletions(-)

diff -puN arch/arm/common/it8152.c~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/arm/common/it8152.c
--- a/arch/arm/common/it8152.c~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/arm/common/it8152.c
@@ -272,33 +272,6 @@ int dma_needs_bounce(struct device *dev,
 		((dma_addr + size - PHYS_OFFSET) >= SZ_64M);
 }
 
-/*
- * We override these so we properly do dmabounce otherwise drivers
- * are able to set the dma_mask to 0xffffffff and we can no longer
- * trap bounces. :(
- *
- * We just return true on everyhing except for < 64MB in which case
- * we will fail miseralby and die since we can't handle that case.
- */
-int pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	dev_dbg(&dev->dev, "%s: %llx\n", __func__, mask);
-	if (mask >= PHYS_OFFSET + SZ_64M - 1)
-		return 0;
-
-	return -EIO;
-}
-
-int
-pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	dev_dbg(&dev->dev, "%s: %llx\n", __func__, mask);
-	if (mask >= PHYS_OFFSET + SZ_64M - 1)
-		return 0;
-
-	return -EIO;
-}
-
 int __init it8152_pci_setup(int nr, struct pci_sys_data *sys)
 {
 	it8152_io.start = IT8152_IO_BASE + 0x12000;
diff -puN arch/arm/include/asm/dma-mapping.h~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/arm/include/asm/dma-mapping.h
--- a/arch/arm/include/asm/dma-mapping.h~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/arm/include/asm/dma-mapping.h
@@ -128,6 +128,14 @@ static inline int dma_supported(struct d
 
 static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
+#ifdef CONFIG_DMABOUNCE
+	if (dev->archdata.dmabounce) {
+		if (dma_mask >= ISA_DMA_THRESHOLD)
+			return 0;
+		else
+			return -EIO;
+	}
+#endif
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
 		return -EIO;
 
diff -puN arch/arm/mach-ixp4xx/common-pci.c~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/arm/mach-ixp4xx/common-pci.c
--- a/arch/arm/mach-ixp4xx/common-pci.c~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/arm/mach-ixp4xx/common-pci.c
@@ -502,32 +502,6 @@ struct pci_bus * __devinit ixp4xx_scan_b
 	return pci_scan_bus(sys->busnr, &ixp4xx_ops, sys);
 }
 
-/*
- * We override these so we properly do dmabounce otherwise drivers
- * are able to set the dma_mask to 0xffffffff and we can no longer
- * trap bounces. :(
- *
- * We just return true on everyhing except for < 64MB in which case 
- * we will fail miseralby and die since we can't handle that case.
- */
-int
-pci_set_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	if (mask >= SZ_64M - 1 )
-		return 0;
-
-	return -EIO;
-}
-    
-int
-pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
-{
-	if (mask >= SZ_64M - 1 )
-		return 0;
-
-	return -EIO;
-}
-
 EXPORT_SYMBOL(ixp4xx_pci_read);
 EXPORT_SYMBOL(ixp4xx_pci_write);
 
diff -puN arch/arm/mach-ixp4xx/include/mach/hardware.h~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/arm/mach-ixp4xx/include/mach/hardware.h
--- a/arch/arm/mach-ixp4xx/include/mach/hardware.h~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/arm/mach-ixp4xx/include/mach/hardware.h
@@ -26,11 +26,6 @@
 #define PCIBIOS_MAX_MEM		0x4BFFFFFF
 #endif
 
-/*
- * We override the standard dma-mask routines for bouncing.
- */
-#define	HAVE_ARCH_PCI_SET_DMA_MASK
-
 #define pcibios_assign_all_busses()	1
 
 /* Register locations and bits */
diff -puN arch/arm/mach-pxa/include/mach/hardware.h~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask arch/arm/mach-pxa/include/mach/hardware.h
--- a/arch/arm/mach-pxa/include/mach/hardware.h~dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask
+++ a/arch/arm/mach-pxa/include/mach/hardware.h
@@ -314,7 +314,6 @@ extern unsigned long get_clock_tick_rate
 #define PCIBIOS_MIN_IO		0
 #define PCIBIOS_MIN_MEM		0
 #define pcibios_assign_all_busses()	1
-#define HAVE_ARCH_PCI_SET_DMA_MASK	1
 #endif
 
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

origin.patch
linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch

