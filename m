From: akpm@linux-foundation.org
Subject: - spi-pxa2xx_spi-clock-polarity-fix.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:46 -0800
Message-ID: <200802250044.m1P0ikRl006135@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:50692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754997AbYBYAtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:49:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nforrester@whoi.edu, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     spi: pxa2xx_spi clock polarity fix
has been removed from the -mm tree.  Its filename was
     spi-pxa2xx_spi-clock-polarity-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: pxa2xx_spi clock polarity fix
From: Ned Forrester <nforrester@whoi.edu>

Fixes a sequencing bug in spi driver pxa2xx_spi.c in which the chip select
for a transfer may be asserted before the clock polarity is set on the
interface.  As a result of this bug, the clock signal may have the wrong
polarity at transfer start, so it may need to make an extra half transition
before the intended clock/data signals begin.  (This probably means all
transfers are one bit out of sequence.)

This only occurs on the first transfer following a change in clock polarity
in systems using more than one more than one such polarity.  The fix
assures that the clock mode is properly set before asserting chip select.

This bug was introduced in a patch merged on 2006/12/10, kernel 2.6.20. 
The patch defines an additional bit in: include/asm-arm/arch-pxa/regs-ssp.h
for 2.6.25 and newer kernels but this addition must be made in:
include/asm-arm/arch-pxa/pxa-regs.h for kernels between 2.6.20 and 2.6.24,
inclusive

Signed-off-by: Ned Forrester <nforrester@whoi.edu>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/pxa2xx_spi.c            |   41 +++++++++++++++++---------
 include/asm-arm/arch-pxa/regs-ssp.h |    1 
 2 files changed, 28 insertions(+), 14 deletions(-)

diff -puN drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-clock-polarity-fix drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-pxa2xx_spi-clock-polarity-fix
+++ a/drivers/spi/pxa2xx_spi.c
@@ -51,13 +51,19 @@ MODULE_LICENSE("GPL");
 #define RESET_DMA_CHANNEL (DCSR_NODESC | DMA_INT_MASK)
 #define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
 
-/* for testing SSCR1 changes that require SSP restart, basically
- * everything except the service and interrupt enables */
-#define SSCR1_CHANGE_MASK (SSCR1_TTELP | SSCR1_TTE | SSCR1_EBCEI | SSCR1_SCFR \
+/*
+ * for testing SSCR1 changes that require SSP restart, basically
+ * everything except the service and interrupt enables, the pxa270 developer
+ * manual says only SSCR1_SCFR, SSCR1_SPH, SSCR1_SPO need to be in this
+ * list, but the PXA255 dev man says all bits without really meaning the
+ * service and interrupt enables
+ */
+#define SSCR1_CHANGE_MASK (SSCR1_TTELP | SSCR1_TTE | SSCR1_SCFR \
 				| SSCR1_ECRA | SSCR1_ECRB | SSCR1_SCLKDIR \
-				| SSCR1_RWOT | SSCR1_TRAIL | SSCR1_PINTE \
-				| SSCR1_STRF | SSCR1_EFWR |SSCR1_RFT \
-				| SSCR1_TFT | SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
+				| SSCR1_SFRMDIR | SSCR1_RWOT | SSCR1_TRAIL \
+				| SSCR1_IFS | SSCR1_STRF | SSCR1_EFWR \
+				| SSCR1_RFT | SSCR1_TFT | SSCR1_MWDS \
+				| SSCR1_SPH | SSCR1_SPO | SSCR1_LBM)
 
 #define DEFINE_SSP_REG(reg, off) \
 static inline u32 read_##reg(void *p) { return __raw_readl(p + (off)); } \
@@ -973,9 +979,6 @@ static void pump_transfers(unsigned long
 		if (drv_data->ssp_type == PXA25x_SSP)
 			DCMD(drv_data->tx_channel) |= DCMD_ENDIRQEN;
 
-		/* Fix me, need to handle cs polarity */
-		drv_data->cs_control(PXA2XX_CS_ASSERT);
-
 		/* Clear status and start DMA engine */
 		cr1 = chip->cr1 | dma_thresh | drv_data->dma_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
@@ -985,9 +988,6 @@ static void pump_transfers(unsigned long
 		/* Ensure we have the correct interrupt handler	*/
 		drv_data->transfer_handler = interrupt_transfer;
 
-		/* Fix me, need to handle cs polarity */
-		drv_data->cs_control(PXA2XX_CS_ASSERT);
-
 		/* Clear status  */
 		cr1 = chip->cr1 | chip->threshold | drv_data->int_cr1;
 		write_SSSR(drv_data->clear_sr, reg);
@@ -998,16 +998,29 @@ static void pump_transfers(unsigned long
 		|| (read_SSCR1(reg) & SSCR1_CHANGE_MASK) !=
 			(cr1 & SSCR1_CHANGE_MASK)) {
 
+		/* stop the SSP, and update the other bits */
 		write_SSCR0(cr0 & ~SSCR0_SSE, reg);
 		if (drv_data->ssp_type != PXA25x_SSP)
 			write_SSTO(chip->timeout, reg);
-		write_SSCR1(cr1, reg);
+		/* first set CR1 without interrupt and service enables */
+		write_SSCR1(cr1 & SSCR1_CHANGE_MASK, reg);
+		/* restart the SSP */
 		write_SSCR0(cr0, reg);
+
 	} else {
 		if (drv_data->ssp_type != PXA25x_SSP)
 			write_SSTO(chip->timeout, reg);
-		write_SSCR1(cr1, reg);
 	}
+
+	/* FIXME, need to handle cs polarity,
+	 * this driver uses struct pxa2xx_spi_chip.cs_control to
+	 * specify a CS handling function, and it ignores most
+	 * struct spi_device.mode[s], including SPI_CS_HIGH */
+	drv_data->cs_control(PXA2XX_CS_ASSERT);
+
+	/* after chip select, release the data by enabling service
+	 * requests and interrupts, without changing any mode bits */
+	write_SSCR1(cr1, reg);
 }
 
 static void pump_messages(struct work_struct *work)
diff -puN include/asm-arm/arch-pxa/regs-ssp.h~spi-pxa2xx_spi-clock-polarity-fix include/asm-arm/arch-pxa/regs-ssp.h
--- a/include/asm-arm/arch-pxa/regs-ssp.h~spi-pxa2xx_spi-clock-polarity-fix
+++ a/include/asm-arm/arch-pxa/regs-ssp.h
@@ -85,6 +85,7 @@
 #define SSCR1_RSRE		(1 << 20)	/* Receive Service Request Enable */
 #define SSCR1_TINTE		(1 << 19)	/* Receiver Time-out Interrupt enable */
 #define SSCR1_PINTE		(1 << 18)	/* Peripheral Trailing Byte Interupt Enable */
+#define SSCR1_IFS		(1 << 16)	/* Invert Frame Signal */
 #define SSCR1_STRF		(1 << 15)	/* Select FIFO or EFWR */
 #define SSCR1_EFWR		(1 << 14)	/* Enable FIFO Write/Read */
 
_

Patches currently in -mm which might be from nforrester@whoi.edu are

spi-pxa2xx_spi-sparse-fixes.patch
