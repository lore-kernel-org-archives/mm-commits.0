From: akpm@linux-foundation.org
Subject: + powerpc-use-asm-generic-scatterlisth.patch added to -mm tree
Date: Mon, 05 Apr 2010 13:50:44 -0700
Message-ID: <201004052050.o35KoiVG008376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756367Ab0DEUut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     powerpc-use-asm-generic-scatterlisth.patch

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
Subject: powerpc: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                   |    3 ++
 arch/powerpc/include/asm/scatterlist.h |   29 -----------------------
 2 files changed, 4 insertions(+), 28 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-use-asm-generic-scatterlisth arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-use-asm-generic-scatterlisth
+++ a/arch/powerpc/Kconfig
@@ -659,6 +659,9 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
 	def_bool (PPC64 || NOT_COHERENT_CACHE)
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	depends on PPC64 || POWER4 || 6xx && !CPM2
diff -puN arch/powerpc/include/asm/scatterlist.h~powerpc-use-asm-generic-scatterlisth arch/powerpc/include/asm/scatterlist.h
--- a/arch/powerpc/include/asm/scatterlist.h~powerpc-use-asm-generic-scatterlisth
+++ a/arch/powerpc/include/asm/scatterlist.h
@@ -9,38 +9,11 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifdef __KERNEL__
-#include <linux/types.h>
 #include <asm/dma.h>
-
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-	unsigned int length;
-
-	/* For TCE or SWIOTLB support */
-	dma_addr_t dma_address;
-	u32 dma_length;
-};
-
-/*
- * These macros should be used after a dma_map_sg call has been done
- * to get bus addresses of each of the SG entries and their lengths.
- * You should only work with the number of sg entries pci_map_sg
- * returns, or alternatively stop on the first sg_dma_len(sg) which
- * is 0.
- */
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->dma_length)
+#include <asm-generic/scatterlist.h>
 
 #ifdef __powerpc64__
 #define ISA_DMA_THRESHOLD	(~0UL)
 #endif
 
-#define ARCH_HAS_SG_CHAIN
