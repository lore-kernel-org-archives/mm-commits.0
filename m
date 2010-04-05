From: akpm@linux-foundation.org
Subject: + alpha-use-asm-generic-scatterlisth.patch added to -mm tree
Date: Mon, 05 Apr 2010 13:50:48 -0700
Message-ID: <201004052050.o35KomLv008382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43301 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756396Ab0DEUu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Apr 2010 16:50:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net


The patch titled
     alpha: use asm-generic/scatterlist.h
has been added to the -mm tree.  Its filename is
     alpha-use-asm-generic-scatterlisth.patch

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
Subject: alpha: use asm-generic/scatterlist.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig                   |    3 +++
 arch/alpha/include/asm/scatterlist.h |   21 +++------------------
 2 files changed, 6 insertions(+), 18 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-use-asm-generic-scatterlisth arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-use-asm-generic-scatterlisth
+++ a/arch/alpha/Kconfig
@@ -58,6 +58,9 @@ config ZONE_DMA
 config NEED_DMA_MAP_STATE
        def_bool y
 
+config NEED_SG_DMA_LENGTH
+	def_bool y
+
 config GENERIC_ISA_DMA
 	bool
 	default y
diff -puN arch/alpha/include/asm/scatterlist.h~alpha-use-asm-generic-scatterlisth arch/alpha/include/asm/scatterlist.h
--- a/arch/alpha/include/asm/scatterlist.h~alpha-use-asm-generic-scatterlisth
+++ a/arch/alpha/include/asm/scatterlist.h
@@ -1,25 +1,10 @@
 #ifndef _ALPHA_SCATTERLIST_H
 #define _ALPHA_SCATTERLIST_H
 
-#include <asm/page.h>
-#include <asm/types.h>
-  
-struct scatterlist {
-#ifdef CONFIG_DEBUG_SG
-	unsigned long sg_magic;
-#endif
-	unsigned long page_link;
-	unsigned int offset;
-
-	unsigned int length;
-
-	dma_addr_t dma_address;
-	__u32 dma_length;
-};
+#define ISA_DMA_THRESHOLD (~0UL)
 
-#define sg_dma_address(sg)	((sg)->dma_address)
-#define sg_dma_len(sg)		((sg)->dma_length)
+#include <asm-generic/scatterlist.h>
 
-#define ISA_DMA_THRESHOLD (~0UL)
+#undef ARCH_HAS_SG_CHAIN
 
 #endif /* !(_ALPHA_SCATTERLIST_H) */
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

linux-next.patch
scsi-add-__init-__exit-macros-to-ibmvstgtc.patch
ssb-add-dma_dev-to-ssb_device-structure.patch
b43legacy-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b43-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
b44-replace-the-ssb_dma-api-with-the-generic-dma-api.patch
ssb-remove-the-ssb-dma-api.patch
asm-generic-remove-isa_dma_threshold-in-scatterlisth.patch
asm-generic-add-need_sg_dma_length-to-define-sg_dma_len.patch
powerpc-use-asm-generic-scatterlisth.patch
arm-use-asm-generic-scatterlisth.patch
alpha-use-asm-generic-scatterlisth.patch

