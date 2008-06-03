From: akpm@linux-foundation.org
Subject: + smc911x-fix-16-bit-i-o-operations.patch added to -mm tree
Date: Tue, 03 Jun 2008 15:46:51 -0700
Message-ID: <200806032246.m53Mkpe7023817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751673AbYFCWrI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:47:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magnus.damm@gmail.com, damm@igel.co.jp, jeff@garzik.org, lethal@linux-sh.org


The patch titled
     smc911x: fix 16-bit I/O operations
has been added to the -mm tree.  Its filename is
     smc911x-fix-16-bit-i-o-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: smc911x: fix 16-bit I/O operations
From: Magnus Damm <magnus.damm@gmail.com>

This patch fixes the following issues related to 16-bit support:
 - Remove unused 16-bit PXA DMA implementation.
 - Remove unused SMC_inw() and SMC_outw() functions.
 - Fix 16-bit SMC_outl to use writew() instead of writel().

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smc911x.h |   66 +---------------------------------------
 1 file changed, 3 insertions(+), 63 deletions(-)

diff -puN drivers/net/smc911x.h~smc911x-fix-16-bit-i-o-operations drivers/net/smc911x.h
--- a/drivers/net/smc911x.h~smc911x-fix-16-bit-i-o-operations
+++ a/drivers/net/smc911x.h
@@ -50,19 +50,16 @@
  */
 
 #if	SMC_USE_16BIT
-#define SMC_inw(a, r)			 readw((a) + (r))
-#define SMC_inl(a, r)			 ((SMC_inw(a, r) & 0xFFFF)+(SMC_inw(a+2, r)<<16))
-#define SMC_outw(v, a, r)		 writew(v, (a) + (r))
+#define SMC_inl(a, r)		 (readw((a) + (r)) & 0xFFFF) + (readw((a) + (r) + 2) << 16))
 #define SMC_outl(v, a, r) 			 \
 	do{					 \
-		 writel(v & 0xFFFF, (a) + (r));	 \
-		 writel(v >> 16, (a) + (r) + 2); \
+		 writew(v & 0xFFFF, (a) + (r));	 \
+		 writew(v >> 16, (a) + (r) + 2); \
 	 } while (0)
 #define SMC_insl(a, r, p, l)	 readsw((short*)((a) + (r)), p, l*2)
 #define SMC_outsl(a, r, p, l)	 writesw((short*)((a) + (r)), p, l*2)
 
 #elif	SMC_USE_32BIT
-#define SMC_inw(a, r)		 readw((a) + (r))
 #define SMC_inl(a, r)		 readl((a) + (r))
 #define SMC_outl(v, a, r)	 writel(v, (a) + (r))
 #define SMC_insl(a, r, p, l)	 readsl((int*)((a) + (r)), p, l)
@@ -132,34 +129,6 @@ smc_pxa_dma_insl(struct device *dev, u_l
 }
 #endif
 
-#ifdef SMC_insw
-#undef SMC_insw
-#define SMC_insw(a, r, p, l) \
-	smc_pxa_dma_insw(lp->dev, a, lp->physaddr, r, lp->rxdma, p, l)
-
-static inline void
-smc_pxa_dma_insw(struct device *dev, u_long ioaddr, u_long physaddr,
-		int reg, int dma, u_char *buf, int len)
-{
-	/* 64 bit alignment is required for memory to memory DMA */
-	while ((long)buf & 6) {
-		*((u16 *)buf) = SMC_inw(ioaddr, reg);
-		buf += 2;
-		len--;
-	}
-
-	len *= 2;
-	rx_dmabuf = dma_map_single(dev, buf, len, DMA_FROM_DEVICE);
-	rx_dmalen = len;
-	DCSR(dma) = DCSR_NODESC;
-	DTADR(dma) = rx_dmabuf;
-	DSADR(dma) = physaddr + reg;
-	DCMD(dma) = (DCMD_INCTRGADDR | DCMD_BURST32 |
-		DCMD_WIDTH2 | DCMD_ENDIRQEN | (DCMD_LENGTH & rx_dmalen));
-	DCSR(dma) = DCSR_NODESC | DCSR_RUN;
-}
-#endif
-
 #ifdef SMC_outsl
 #undef SMC_outsl
 #define SMC_outsl(a, r, p, l) \
@@ -187,35 +156,6 @@ smc_pxa_dma_outsl(struct device *dev, u_
 	DCSR(dma) = DCSR_NODESC | DCSR_RUN;
 }
 #endif
-
-#ifdef SMC_outsw
-#undef SMC_outsw
-#define SMC_outsw(a, r, p, l) \
-	smc_pxa_dma_outsw(lp->dev, a, lp->physaddr, r, lp->txdma, p, l)
-
-static inline void
-smc_pxa_dma_outsw(struct device *dev, u_long ioaddr, u_long physaddr,
-		  int reg, int dma, u_char *buf, int len)
-{
-	/* 64 bit alignment is required for memory to memory DMA */
-	while ((long)buf & 6) {
-		SMC_outw(*((u16 *)buf), ioaddr, reg);
-		buf += 2;
-		len--;
-	}
-
-	len *= 2;
-	tx_dmabuf = dma_map_single(dev, buf, len, DMA_TO_DEVICE);
-	tx_dmalen = len;
-	DCSR(dma) = DCSR_NODESC;
-	DSADR(dma) = tx_dmabuf;
-	DTADR(dma) = physaddr + reg;
-	DCMD(dma) = (DCMD_INCSRCADDR | DCMD_BURST32 |
-		DCMD_WIDTH2 | DCMD_ENDIRQEN | (DCMD_LENGTH & tx_dmalen));
-	DCSR(dma) = DCSR_NODESC | DCSR_RUN;
-}
-#endif
