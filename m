From: akpm@linux-foundation.org
Subject: + pci-dma-sparc-use-include-linux-pci-dmah.patch added to -mm tree
Date: Thu, 11 Feb 2010 12:40:22 -0800
Message-ID: <201002112040.o1BKeMRq027317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49786 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757057Ab0BKUk0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 15:40:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, davem@davemloft.net, jbarnes@virtuousgeek.org


The patch titled
     pci-dma: sparc: use include/linux/pci-dma.h
has been added to the -mm tree.  Its filename is
     pci-dma-sparc-use-include-linux-pci-dmah.patch

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
-
 /* PCI IOMMU mapping bypass support. */
 
 /* PCI 64-bit addressing works for all slots on all controller
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
x86-agp-fix-agp_amd64_init-module-initialization-regression.patch
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

