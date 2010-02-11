From: akpm@linux-foundation.org
Subject: + pci-dma-alpha-use-include-linux-pci-dmah.patch added to -mm tree
Date: Thu, 11 Feb 2010 12:40:06 -0800
Message-ID: <201002112040.o1BKe6ju027265@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756977Ab0BKUkR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Feb 2010 15:40:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org, mattst88@gmail.com, rth@twiddle.net


The patch titled
     pci-dma: alpha: use include/linux/pci-dma.h
has been added to the -mm tree.  Its filename is
     pci-dma-alpha-use-include-linux-pci-dmah.patch

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
Subject: pci-dma: alpha: use include/linux/pci-dma.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Acked-by: Matt Turner <mattst88@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig           |    3 +++
 arch/alpha/include/asm/pci.h |   14 +-------------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff -puN arch/alpha/Kconfig~pci-dma-alpha-use-include-linux-pci-dmah arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~pci-dma-alpha-use-include-linux-pci-dmah
+++ a/arch/alpha/Kconfig
@@ -58,6 +58,9 @@ config ZONE_DMA
 	bool
 	default y
 
+config NEED_DMA_MAP_STATE
+       def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
diff -puN arch/alpha/include/asm/pci.h~pci-dma-alpha-use-include-linux-pci-dmah arch/alpha/include/asm/pci.h
--- a/arch/alpha/include/asm/pci.h~pci-dma-alpha-use-include-linux-pci-dmah
+++ a/arch/alpha/include/asm/pci.h
@@ -119,19 +119,7 @@ pci_dma_mapping_error(struct pci_dev *pd
 extern void pci_unmap_single(struct pci_dev *, dma_addr_t, size_t, int);
 extern void pci_unmap_page(struct pci_dev *, dma_addr_t, size_t, int);
 
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
 
 /* Map a set of buffers described by scatterlist in streaming mode for
    PCI DMA.  This is the scatter-gather version of the above
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

