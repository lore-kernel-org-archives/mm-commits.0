From: akpm@osdl.org
Subject: - sparc64-dma-remove-extra-brackets.patch removed from -mm tree
Date: Tue, 12 Dec 2006 22:56:18 -0800
Message-ID: <200612130656.kBD6uITb030713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965048AbWLMG4Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 01:56:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: m.kozlowski@tuxland.pl, mm-commits@vger.kernel.org


The patch titled
     sparc64: dma remove extra brackets
has been removed from the -mm tree.  Its filename was
     sparc64-dma-remove-extra-brackets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sparc64: dma remove extra brackets
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-sparc64/dma.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/asm-sparc64/dma.h~sparc64-dma-remove-extra-brackets include/asm-sparc64/dma.h
--- a/include/asm-sparc64/dma.h~sparc64-dma-remove-extra-brackets
+++ a/include/asm-sparc64/dma.h
@@ -152,9 +152,9 @@ extern void dvma_init(struct sbus_bus *)
 #define DMA_MAXEND(addr) (0x01000000UL-(((unsigned long)(addr))&0x00ffffffUL))
 
 /* Yes, I hack a lot of elisp in my spare time... */
-#define DMA_ERROR_P(regs)  (((sbus_readl((regs) + DMA_CSR) & DMA_HNDL_ERROR))
-#define DMA_IRQ_P(regs)    (((sbus_readl((regs) + DMA_CSR)) & (DMA_HNDL_INTR | DMA_HNDL_ERROR)))
-#define DMA_WRITE_P(regs)  (((sbus_readl((regs) + DMA_CSR) & DMA_ST_WRITE))
+#define DMA_ERROR_P(regs)  ((sbus_readl((regs) + DMA_CSR) & DMA_HNDL_ERROR))
+#define DMA_IRQ_P(regs)    ((sbus_readl((regs) + DMA_CSR)) & (DMA_HNDL_INTR | DMA_HNDL_ERROR))
+#define DMA_WRITE_P(regs)  ((sbus_readl((regs) + DMA_CSR) & DMA_ST_WRITE))
 #define DMA_OFF(__regs)		\
 do {	u32 tmp = sbus_readl((__regs) + DMA_CSR); \
 	tmp &= ~DMA_ENABLE; \
_

Patches currently in -mm which might be from m.kozlowski@tuxland.pl are

origin.patch
ppc-cs4218_tdm-remove-extra-brace.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
scsi-sic7xxx-stray-bracket-fix.patch
scsi-53c7xx-brackets-fix.patch

