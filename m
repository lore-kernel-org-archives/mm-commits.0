From: akpm@linux-foundation.org
Subject: [merged] pci-dma-ia64-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:47 -0400
Message-ID: <201003150703.o2F73KUK016936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935902Ab0COHDX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     pci-dma: ia64: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-ia64-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: ia64: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig           |    3 +++
 arch/ia64/include/asm/pci.h |   14 +-------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff -puN arch/ia64/Kconfig~pci-dma-ia64-use-include-linux-pci-dmah arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~pci-dma-ia64-use-include-linux-pci-dmah
+++ a/arch/ia64/Kconfig
@@ -53,6 +53,9 @@ config MMU
 	bool
 	default y
 
+config NEED_DMA_MAP_STATE
+	def_bool y
+
 config SWIOTLB
        bool
 
diff -puN arch/ia64/include/asm/pci.h~pci-dma-ia64-use-include-linux-pci-dmah arch/ia64/include/asm/pci.h
--- a/arch/ia64/include/asm/pci.h~pci-dma-ia64-use-include-linux-pci-dmah
+++ a/arch/ia64/include/asm/pci.h
@@ -56,19 +56,7 @@ pcibios_penalize_isa_irq (int irq, int a
 
 #include <asm-generic/pci-dma-compat.h>
 
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

