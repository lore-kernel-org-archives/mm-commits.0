From: akpm@linux-foundation.org
Subject: [merged] pci-dma-sh-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:59 -0400
Message-ID: <201003150703.o2F73WRe016949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37188 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935930Ab0COHDj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     pci-dma: sh: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-sh-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: sh: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/Kconfig           |    3 +++
 arch/sh/include/asm/pci.h |   19 +------------------
 2 files changed, 4 insertions(+), 18 deletions(-)

diff -puN arch/sh/Kconfig~pci-dma-sh-use-include-linux-pci-dmah arch/sh/Kconfig
--- a/arch/sh/Kconfig~pci-dma-sh-use-include-linux-pci-dmah
+++ a/arch/sh/Kconfig
@@ -183,6 +183,9 @@ config DMA_COHERENT
 config DMA_NONCOHERENT
 	def_bool !DMA_COHERENT
 
+config NEED_DMA_MAP_STATE
+	def_bool DMA_NONCOHERENT
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/sh/include/asm/pci.h~pci-dma-sh-use-include-linux-pci-dmah arch/sh/include/asm/pci.h
--- a/arch/sh/include/asm/pci.h~pci-dma-sh-use-include-linux-pci-dmah
+++ a/arch/sh/include/asm/pci.h
@@ -83,24 +83,7 @@ static inline void pcibios_penalize_isa_
  */
 #define PCI_DMA_BUS_IS_PHYS	(dma_ops->is_phys)
 
-/* pci_unmap_{single,page} being a nop depends upon the
- * configuration.
- */
-#ifdef CONFIG_DMA_NONCOHERENT
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)		__u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)		((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	(((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)		((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	(((PTR)->LEN_NAME) = (VAL))
-#else
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
-#endif
+#include <linux/pci-dma.h>
 
 #ifdef CONFIG_PCI
 /*
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

