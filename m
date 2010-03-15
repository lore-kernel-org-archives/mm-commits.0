From: akpm@linux-foundation.org
Subject: [merged] pci-dma-arm-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:41 -0400
Message-ID: <201003150703.o2F73EWG016921@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935902Ab0COHDV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pci-dma: arm: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-arm-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: arm: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig           |    3 +++
 arch/arm/include/asm/pci.h |   11 +----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff -puN arch/arm/Kconfig~pci-dma-arm-use-include-linux-pci-dmah arch/arm/Kconfig
--- a/arch/arm/Kconfig~pci-dma-arm-use-include-linux-pci-dmah
+++ a/arch/arm/Kconfig
@@ -155,6 +155,9 @@ config ARCH_MAY_HAVE_PC_FDC
 config ZONE_DMA
 	bool
 
+config NEED_DMA_MAP_STATE
+       def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 
diff -puN arch/arm/include/asm/pci.h~pci-dma-arm-use-include-linux-pci-dmah arch/arm/include/asm/pci.h
--- a/arch/arm/include/asm/pci.h~pci-dma-arm-use-include-linux-pci-dmah
+++ a/arch/arm/include/asm/pci.h
@@ -30,16 +30,7 @@ static inline void pcibios_penalize_isa_
  */
 #define PCI_DMA_BUS_IS_PHYS     (1)
 
-/*
- * Whether pci_unmap_{single,page} is a nop depends upon the
- * configuration.
- */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
+#include <linux/pci-dma.h>
 
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
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

