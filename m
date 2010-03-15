From: akpm@linux-foundation.org
Subject: [merged] pci-dma-sparc-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:03:02 -0400
Message-ID: <201003150703.o2F73ZJM016953@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935923Ab0COHDi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci-dma: sparc: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-sparc-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: sparc: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig              |    3 +++
 arch/sparc/include/asm/pci.h    |    2 ++
 arch/sparc/include/asm/pci_32.h |   14 --------------
 arch/sparc/include/asm/pci_64.h |   14 --------------
 4 files changed, 5 insertions(+), 28 deletions(-)

diff -puN arch/sparc/Kconfig~pci-dma-sparc-use-include-linux-pci-dmah arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~pci-dma-sparc-use-include-linux-pci-dmah
+++ a/arch/sparc/Kconfig
@@ -127,6 +127,9 @@ config ZONE_DMA
 	bool
 	default y if SPARC32
 
+config NEED_DMA_MAP_STATE
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y if SPARC32
diff -puN arch/sparc/include/asm/pci.h~pci-dma-sparc-use-include-linux-pci-dmah arch/sparc/include/asm/pci.h
--- a/arch/sparc/include/asm/pci.h~pci-dma-sparc-use-include-linux-pci-dmah
+++ a/arch/sparc/include/asm/pci.h
@@ -6,6 +6,8 @@
 #include <asm/pci_32.h>
 #endif
 
+#include <linux/pci-dma.h>
+
 #include <asm-generic/pci-dma-compat.h>
 
 #endif
diff -puN arch/sparc/include/asm/pci_32.h~pci-dma-sparc-use-include-linux-pci-dmah arch/sparc/include/asm/pci_32.h
--- a/arch/sparc/include/asm/pci_32.h~pci-dma-sparc-use-include-linux-pci-dmah
+++ a/arch/sparc/include/asm/pci_32.h
@@ -32,20 +32,6 @@ static inline void pcibios_penalize_isa_
 
 struct pci_dev;
 
-/* pci_unmap_{single,page} is not a nop, thus... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
-	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
-	__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)			\
-	((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)		\
-	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)			\
-	((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
-	(((PTR)->LEN_NAME) = (VAL))
-
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 					enum pci_dma_burst_strategy *strat,
diff -puN arch/sparc/include/asm/pci_64.h~pci-dma-sparc-use-include-linux-pci-dmah arch/sparc/include/asm/pci_64.h
--- a/arch/sparc/include/asm/pci_64.h~pci-dma-sparc-use-include-linux-pci-dmah
+++ a/arch/sparc/include/asm/pci_64.h
@@ -32,20 +32,6 @@ static inline void pcibios_penalize_isa_
  */
 #define PCI_DMA_BUS_IS_PHYS	(0)
 
-/* pci_unmap_{single,page} is not a nop, thus... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	\
-	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		\
-	__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)			\
-	((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)		\
-	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)			\
-	((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)		\
-	(((PTR)->LEN_NAME) = (VAL))
