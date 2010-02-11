From: akpm@linux-foundation.org
Subject: + pci-dma-sh-use-include-linux-pci-dmah.patch added to -mm tree
Date: Thu, 11 Feb 2010 12:40:20 -0800
Message-ID: <201002112040.o1BKeKW6027311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055Ab0BKUkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 15:40:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, jbarnes@virtuousgeek.org, lethal@linux-sh.org


The patch titled
     pci-dma: sh: use include/linux/pci-dma.h
has been added to the -mm tree.  Its filename is
     pci-dma-sh-use-include-linux-pci-dmah.patch

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

