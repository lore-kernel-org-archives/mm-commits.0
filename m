From: akpm@linux-foundation.org
Subject: [merged] pci-dma-powerpc-use-include-linux-pci-dmah.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:02:56 -0400
Message-ID: <201003150703.o2F73TdJ016946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935923Ab0COHDd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:03:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org, jbarnes@virtuousgeek.org, mm-commits@vger.kernel.org


The patch titled
     pci-dma: powerpc: use include/linux/pci-dma.h
has been removed from the -mm tree.  Its filename was
     pci-dma-powerpc-use-include-linux-pci-dmah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci-dma: powerpc: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig           |    3 ++
 arch/powerpc/include/asm/pci.h |   32 -------------------------------
 2 files changed, 4 insertions(+), 31 deletions(-)

diff -puN arch/powerpc/Kconfig~pci-dma-powerpc-use-include-linux-pci-dmah arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~pci-dma-powerpc-use-include-linux-pci-dmah
+++ a/arch/powerpc/Kconfig
@@ -672,6 +672,9 @@ config ZONE_DMA
 	bool
 	default y
 
+config NEED_DMA_MAP_STATE
+	def_bool (PPC64 || NOT_COHERENT_CACHE)
+
 config GENERIC_ISA_DMA
 	bool
 	depends on PPC64 || POWER4 || 6xx && !CPM2
diff -puN arch/powerpc/include/asm/pci.h~pci-dma-powerpc-use-include-linux-pci-dmah arch/powerpc/include/asm/pci.h
--- a/arch/powerpc/include/asm/pci.h~pci-dma-powerpc-use-include-linux-pci-dmah
+++ a/arch/powerpc/include/asm/pci.h
@@ -141,37 +141,7 @@ extern int pci_mmap_legacy_page_range(st
 
 #define HAVE_PCI_LEGACY	1
 
-#if defined(CONFIG_PPC64) || defined(CONFIG_NOT_COHERENT_CACHE)
-/*
- * For 64-bit kernels, pci_unmap_{single,page} is not a nop.
- * For 32-bit non-coherent kernels, pci_dma_sync_single_for_cpu() and
- * so on are not nops.
- * and thus...
- */
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
-#else /* 32-bit && coherent */
-
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
