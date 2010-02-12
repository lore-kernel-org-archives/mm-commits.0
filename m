From: akpm@linux-foundation.org
Subject: + dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch added to -mm tree
Date: Fri, 12 Feb 2010 12:08:09 -0800
Message-ID: <201002122008.o1CK8AXS024067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757475Ab0BLUIt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 15:08:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, greg@kroah.com, jbarnes@virtuousgeek.org, kay.sievers@vrfy.org, rmk+kernel@arm.linux.org.uk


The patch titled
     dma-mapping: arm: use generic pci_set_dma_mask and pci_set_consistent_dma_mask
has been added to the -mm tree.  Its filename is
     dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
frv-remove-pci_dma_sync_single-and-pci_dma_sync_sg.patch
documentation-dma-apitxt-remove-deprecated-function-descriptions.patch
dma-apitxt-add-dma_sync_single-sg-api-description.patch
dma-apitxt-remove-dma_sync_single_range-description.patch
alpha-remove-dma_sync_single_range.patch
um-remove-dma_sync_single_range.patch
pci-dma-add-include-linux-pci-dmah.patch
pci-dma-x86-use-include-linux-pci-dmah.patch
pci-dma-alpha-use-include-linux-pci-dmah.patch
pci-dma-arm-use-include-linux-pci-dmah.patch
pci-dma-frv-use-include-linux-pci-dmah.patch
pci-dma-ia64-use-include-linux-pci-dmah.patch
pci-dma-mips-use-include-linux-pci-dmah.patch
pci-dma-parisc-use-include-linux-pci-dmah.patch
pci-dma-powerpc-use-include-linux-pci-dmah.patch
pci-dma-sh-use-include-linux-pci-dmah.patch
pci-dma-sparc-use-include-linux-pci-dmah.patch
pci-dma-xtensa-use-include-linux-pci-dmah.patch
pci-dma-cris-use-include-linux-pci-dmah.patch
pci-dma-add-linux-pci-dmah-to-linux-pcih.patch
dma-mappingh-add-the-dma_unmap-state-api.patch
frv-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
blackfin-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments.patch
dma-mapping-sparc-unify-32bit-and-64bit-dma_set_mask.patch
dma-mapping-alpha-use-include-linux-pci-dma-compath.patch
dma-mapping-pci-convert-pci_set_dma_mask-to-call-dma_set_mask.patch
dma-mapping-dma-mappingh-add-dma_set_coherent_mask.patch
dma-mapping-powerpc-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-arm-use-generic-pci_set_dma_mask-and-pci_set_consistent_dma_mask.patch
dma-mapping-pci-move-pci_set_dma_mask-and-pci_set_consistent_dma_mask-to-pci-dma-compath.patch

