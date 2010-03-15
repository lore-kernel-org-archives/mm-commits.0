From: akpm@linux-foundation.org
Subject: [merged] pci-dma-x86-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:35 -0400
Message-ID: <201003150703.o2F7388e016905@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935902Ab0COHD3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     pci-dma: x86: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-x86-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: x86: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig           |    3 +++
 arch/x86/include/asm/pci.h |   30 ++----------------------------
 2 files changed, 5 insertions(+), 28 deletions(-)

diff -puN arch/x86/Kconfig~pci-dma-x86-use-include-linux-pci-dmah arch/x86/Kconfig
--- a/arch/x86/Kconfig~pci-dma-x86-use-include-linux-pci-dmah
+++ a/arch/x86/Kconfig
@@ -102,6 +102,9 @@ config ZONE_DMA
 config SBUS
 	bool
 
+config NEED_DMA_MAP_STATE
+       def_bool (X86_64 || DMAR || DMA_API_DEBUG)
+
 config GENERIC_ISA_DMA
 	def_bool y
 
diff -puN arch/x86/include/asm/pci.h~pci-dma-x86-use-include-linux-pci-dmah arch/x86/include/asm/pci.h
--- a/arch/x86/include/asm/pci.h~pci-dma-x86-use-include-linux-pci-dmah
+++ a/arch/x86/include/asm/pci.h
@@ -97,34 +97,6 @@ extern void pci_iommu_alloc(void);
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
-#if defined(CONFIG_X86_64) || defined(CONFIG_DMAR) || defined(CONFIG_DMA_API_DEBUG)
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       \
-	        dma_addr_t ADDR_NAME;
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)         \
-	        __u32 LEN_NAME;
-#define pci_unmap_addr(PTR, ADDR_NAME)                  \
-	        ((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)         \
-	        (((PTR)->ADDR_NAME) = (VAL))
-#define pci_unmap_len(PTR, LEN_NAME)                    \
-	        ((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)           \
-	        (((PTR)->LEN_NAME) = (VAL))
-
-#else
-
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)       dma_addr_t ADDR_NAME[0];
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME) unsigned LEN_NAME[0];
-#define pci_unmap_addr(PTR, ADDR_NAME)  sizeof((PTR)->ADDR_NAME)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
-	        do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
-#define pci_unmap_len(PTR, LEN_NAME)            sizeof((PTR)->LEN_NAME)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
-	        do { break; } while (pci_unmap_len(PTR, LEN_NAME))
-
-#endif
-
 #endif  /* __KERNEL__ */
 
 #ifdef CONFIG_X86_64
@@ -136,6 +108,8 @@ void dma32_reserve_bootmem(void);
 /* implement the pci_ DMA API in terms of the generic device dma_ one */
 #include <asm-generic/pci-dma-compat.h>
 
+#include <linux/pci-dma.h>
+
 /* generic pci stuff */
 #include <asm-generic/pci.h>
 #define PCIBIOS_MAX_MEM_32 0xffffffff
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

