From: akpm@linux-foundation.org
Subject: [merged] pci-dma-mips-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:50 -0400
Message-ID: <201003150703.o2F73Nwt016940@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43255 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935902Ab0COHDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     pci-dma: mips: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-mips-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: mips: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/Kconfig           |    4 ++--
 arch/mips/include/asm/pci.h |   22 +---------------------
 2 files changed, 3 insertions(+), 23 deletions(-)

diff -puN arch/mips/Kconfig~pci-dma-mips-use-include-linux-pci-dmah arch/mips/Kconfig
--- a/arch/mips/Kconfig~pci-dma-mips-use-include-linux-pci-dmah
+++ a/arch/mips/Kconfig
@@ -812,9 +812,9 @@ config DMA_COHERENT
 
 config DMA_NONCOHERENT
 	bool
-	select DMA_NEED_PCI_MAP_STATE
+	select NEED_DMA_MAP_STATE
 
-config DMA_NEED_PCI_MAP_STATE
+config NEED_DMA_MAP_STATE
 	bool
 
 config SYS_HAS_EARLY_PRINTK
diff -puN arch/mips/include/asm/pci.h~pci-dma-mips-use-include-linux-pci-dmah arch/mips/include/asm/pci.h
--- a/arch/mips/include/asm/pci.h~pci-dma-mips-use-include-linux-pci-dmah
+++ a/arch/mips/include/asm/pci.h
@@ -102,27 +102,7 @@ struct pci_dev;
  */
 extern unsigned int PCI_DMA_BUS_IS_PHYS;
 
-#ifdef CONFIG_DMA_NEED_PCI_MAP_STATE
-
-/* pci_unmap_{single,page} is not a nop, thus... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
-
-#else /* CONFIG_DMA_NEED_PCI_MAP_STATE  */
-
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
