From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-add-fiq-pseudo-dma-support.patch added to -mm tree
Date: Thu, 19 Nov 2009 16:03:43 -0800
Message-ID: <200911200003.nAK03hWb024390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194AbZKTADy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Nov 2009 19:03:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, david-b@pacbell.net, linux@simtec.co.uk


The patch titled
     spi_s3c24xx: add FIQ pseudo-DMA support
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-add-fiq-pseudo-dma-support.patch

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
Subject: spi_s3c24xx: add FIQ pseudo-DMA support
From: Ben Dooks <ben@simtec.co.uk>

Add pseudo-DMA by FIQ to the S3C24XX SPI driver.  This allows the driver
to get DMA-like performance where there are either no free DMA channels or
when doing transfers that required both TX and RX data paths.

Since this patch requires the addition of an assembly file to hold the FIQ
code, we rename the module (instead of adding a rename of the .c file to
this patch).  We expect most users are loading this via udev and thus
there should be no change to the userland configuration.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/include/mach/spi.h |    2 
 drivers/spi/Kconfig                      |   11 
 drivers/spi/Makefile                     |    7 
 drivers/spi/spi_s3c24xx.c                |  244 +++++++++++++++++++--
 drivers/spi/spi_s3c24xx_fiq.S            |  116 +++++++++
 drivers/spi/spi_s3c24xx_fiq.h            |   26 ++
 6 files changed, 392 insertions(+), 14 deletions(-)

diff -puN arch/arm/mach-s3c2410/include/mach/spi.h~spi_s3c24xx-add-fiq-pseudo-dma-support arch/arm/mach-s3c2410/include/mach/spi.h
--- a/arch/arm/mach-s3c2410/include/mach/spi.h~spi_s3c24xx-add-fiq-pseudo-dma-support
+++ a/arch/arm/mach-s3c2410/include/mach/spi.h
@@ -18,6 +18,8 @@ struct s3c2410_spi_info {
 	unsigned int		 num_cs;	/* total chipselects */
 	int			 bus_num;       /* bus number to use. */
 
+	unsigned int		 use_fiq:1;	/* use fiq */
+
 	void (*gpio_setup)(struct s3c2410_spi_info *spi, int enable);
 	void (*set_cs)(struct s3c2410_spi_info *spi, int cs, int pol);
 };
diff -puN drivers/spi/Kconfig~spi_s3c24xx-add-fiq-pseudo-dma-support drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi_s3c24xx-add-fiq-pseudo-dma-support
+++ a/drivers/spi/Kconfig
@@ -210,6 +210,17 @@ config SPI_S3C24XX
 	help
 	  SPI driver for Samsung S3C24XX series ARM SoCs
 
+config SPI_S3C24XX_FIQ
+	bool "S3C24XX driver with FIQ pseudo-DMA"
+	depends on SPI_S3C24XX
+	select FIQ
+	help
+	  Enable FIQ support for the S3C24XX SPI driver to provide pseudo
+	  DMA by using the fast-interrupt request framework, This allows
+	  the driver to get DMA-like performance when there are either
+	  no free DMA channels, or when doing transfers that required both
+	  TX and RX data paths.
+
 config SPI_S3C24XX_GPIO
 	tristate "Samsung S3C24XX series SPI by GPIO"
 	depends on ARCH_S3C2410 && EXPERIMENTAL
diff -puN drivers/spi/Makefile~spi_s3c24xx-add-fiq-pseudo-dma-support drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi_s3c24xx-add-fiq-pseudo-dma-support
+++ a/drivers/spi/Makefile
@@ -29,13 +29,18 @@ obj-$(CONFIG_SPI_MPC52xx)		+= mpc52xx_sp
 obj-$(CONFIG_SPI_MPC8xxx)		+= spi_mpc8xxx.o
 obj-$(CONFIG_SPI_PPC4xx)		+= spi_ppc4xx.o
 obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
-obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx.o
+obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx_hw.o
 obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
 obj-$(CONFIG_SPI_DESIGNWARE)		+= dw_spi.o
 obj-$(CONFIG_SPI_DW_PCI)		+= dw_spi_pci.o
+
+# special build for s3c24xx spi driver with fiq support
+spi_s3c24xx_hw-y			:= spi_s3c24xx.o
+spi_s3c24xx_hw-$(CONFIG_SPI_S3C24XX_FIQ) += spi_s3c24xx_fiq.o
+
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-add-fiq-pseudo-dma-support drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-add-fiq-pseudo-dma-support
+++ a/drivers/spi/spi_s3c24xx.c
@@ -1,7 +1,7 @@
 /* linux/drivers/spi/spi_s3c24xx.c
  *
  * Copyright (c) 2006 Ben Dooks
- * Copyright (c) 2006 Simtec Electronics
+ * Copyright 2006-2009 Simtec Electronics
  *	Ben Dooks <ben@simtec.co.uk>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -28,6 +28,11 @@
 #include <plat/regs-spi.h>
 #include <mach/spi.h>
 
+#include <plat/fiq.h>
+#include <asm/fiq.h>
+
+#include "spi_s3c24xx_fiq.h"
+
 /**
  * s3c24xx_spi_devstate - per device data
  * @hz: Last frequency calculated for @sppre field.
@@ -42,6 +47,13 @@ struct s3c24xx_spi_devstate {
 	u8		sppre;
 };
 
+enum spi_fiq_mode {
+	FIQ_MODE_NONE	= 0,
+	FIQ_MODE_TX	= 1,
+	FIQ_MODE_RX	= 2,
+	FIQ_MODE_TXRX	= 3,
+};
+
 struct s3c24xx_spi {
 	/* bitbang has to be first */
 	struct spi_bitbang	 bitbang;
@@ -52,6 +64,11 @@ struct s3c24xx_spi {
 	int			 len;
 	int			 count;
 
+	struct fiq_handler	 fiq_handler;
+	enum spi_fiq_mode	 fiq_mode;
+	unsigned char		 fiq_inuse;
+	unsigned char		 fiq_claimed;
+
 	void			(*set_cs)(struct s3c2410_spi_info *spi,
 					  int cs, int pol);
 
@@ -67,6 +84,7 @@ struct s3c24xx_spi {
 	struct s3c2410_spi_info *pdata;
 };
 
+
 #define SPCON_DEFAULT (S3C2410_SPCON_MSTR | S3C2410_SPCON_SMOD_INT)
 #define SPPIN_DEFAULT (S3C2410_SPPIN_KEEP)
 
@@ -127,7 +145,7 @@ static int s3c24xx_spi_update_state(stru
 	}
 
 	if (spi->mode != cs->mode) {
-		u8 spcon = SPCON_DEFAULT;
+		u8 spcon = SPCON_DEFAULT | S3C2410_SPCON_ENSCK;
 
 		if (spi->mode & SPI_CPHA)
 			spcon |= S3C2410_SPCON_CPHA_FMTB;
@@ -214,13 +232,196 @@ static inline unsigned int hw_txbyte(str
 	return hw->tx ? hw->tx[count] : 0;
 }
 
+#ifdef CONFIG_SPI_S3C24XX_FIQ
+/* Support for FIQ based pseudo-DMA to improve the transfer speed.
+ *
+ * This code uses the assembly helper in spi_s3c24xx_spi.S which is
+ * used by the FIQ core to move data between main memory and the peripheral
+ * block. Since this is code running on the processor, there is no problem
+ * with cache coherency of the buffers, so we can use any buffer we like.
+ */
+
+/**
+ * struct spi_fiq_code - FIQ code and header
+ * @length: The length of the code fragment, excluding this header.
+ * @ack_offset: The offset from @data to the word to place the IRQ ACK bit at.
+ * @data: The code itself to install as a FIQ handler.
+ */
+struct spi_fiq_code {
+	u32	length;
+	u32	ack_offset;
+	u8	data[0];
+};
+
+extern struct spi_fiq_code s3c24xx_spi_fiq_txrx;
+extern struct spi_fiq_code s3c24xx_spi_fiq_tx;
+extern struct spi_fiq_code s3c24xx_spi_fiq_rx;
+
+/**
+ * ack_bit - turn IRQ into IRQ acknowledgement bit
+ * @irq: The interrupt number
+ *
+ * Returns the bit to write to the interrupt acknowledge register.
+ */
+static inline u32 ack_bit(unsigned int irq)
+{
+	return 1 << (irq - IRQ_EINT0);
+}
+
+/**
+ * s3c24xx_spi_tryfiq - attempt to claim and setup FIQ for transfer
+ * @hw: The hardware state.
+ *
+ * Claim the FIQ handler (only one can be active at any one time) and
+ * then setup the correct transfer code for this transfer.
+ *
+ * This call updates all the necessary state information if sucessful,
+ * so the caller does not need to do anything more than start the transfer
+ * as normal, since the IRQ will have been re-routed to the FIQ handler.
+*/
+void s3c24xx_spi_tryfiq(struct s3c24xx_spi *hw)
+{
+	struct pt_regs regs;
+	enum spi_fiq_mode mode;
+	struct spi_fiq_code *code;
+	int ret;
+
+	if (!hw->fiq_claimed) {
+		/* try and claim fiq if we haven't got it, and if not
+		 * then return and simply use another transfer method */
+
+		ret = claim_fiq(&hw->fiq_handler);
+		if (ret)
+			return;
+	}
+
+	if (hw->tx && !hw->rx)
+		mode = FIQ_MODE_TX;
+	else if (hw->rx && !hw->tx)
+		mode = FIQ_MODE_RX;
+	else
+		mode = FIQ_MODE_TXRX;
+
+	regs.uregs[fiq_rspi] = (long)hw->regs;
+	regs.uregs[fiq_rrx]  = (long)hw->rx;
+	regs.uregs[fiq_rtx]  = (long)hw->tx + 1;
+	regs.uregs[fiq_rcount] = hw->len - 1;
+	regs.uregs[fiq_rirq] = (long)S3C24XX_VA_IRQ;
+
+	set_fiq_regs(&regs);
+
+	if (hw->fiq_mode != mode) {
+		u32 *ack_ptr;
+
+		hw->fiq_mode = mode;
+
+		switch (mode) {
+		case FIQ_MODE_TX:
+			code = &s3c24xx_spi_fiq_tx;
+			break;
+		case FIQ_MODE_RX:
+			code = &s3c24xx_spi_fiq_rx;
+			break;
+		case FIQ_MODE_TXRX:
+			code = &s3c24xx_spi_fiq_txrx;
+			break;
+		default:
+			code = NULL;
+		}
+
+		BUG_ON(!code);
+
+		ack_ptr = (u32 *)&code->data[code->ack_offset];
+		*ack_ptr = ack_bit(hw->irq);
+
+		set_fiq_handler(&code->data, code->length);
+	}
+
+	s3c24xx_set_fiq(hw->irq, true);
+
+	hw->fiq_mode = mode;
+	hw->fiq_inuse = 1;
+}
+
+/**
+ * s3c24xx_spi_fiqop - FIQ core code callback
+ * @pw: Data registered with the handler
+ * @release: Whether this is a release or a return.
+ *
+ * Called by the FIQ code when another module wants to use the FIQ, so
+ * return whether we are currently using this or not and then update our
+ * internal state.
+ */
+static int s3c24xx_spi_fiqop(void *pw, int release)
+{
+	struct s3c24xx_spi *hw = pw;
+	int ret = 0;
+
+	if (release) {
+		if (hw->fiq_inuse)
+			ret = -EBUSY;
+
+		/* note, we do not need to unroute the FIQ, as the FIQ
+		 * vector code de-routes it to signal the end of transfer */
+
+		hw->fiq_mode = FIQ_MODE_NONE;
+		hw->fiq_claimed = 0;
+	} else {
+		hw->fiq_claimed = 1;
+	}
+
+	return ret;
+}
+
+/**
+ * s3c24xx_spi_initfiq - setup the information for the FIQ core
+ * @hw: The hardware state.
+ *
+ * Setup the fiq_handler block to pass to the FIQ core.
+ */
+static inline void s3c24xx_spi_initfiq(struct s3c24xx_spi *hw)
+{
+	hw->fiq_handler.dev_id = hw;
+	hw->fiq_handler.name = dev_name(hw->dev);
+	hw->fiq_handler.fiq_op = s3c24xx_spi_fiqop;
+}
+
+/**
+ * s3c24xx_spi_usefiq - return if we should be using FIQ.
+ * @hw: The hardware state.
+ *
+ * Return true if the platform data specifies whether this channel is
+ * allowed to use the FIQ.
+ */
+static inline bool s3c24xx_spi_usefiq(struct s3c24xx_spi *hw)
+{
+	return hw->pdata->use_fiq;
+}
+
+/**
+ * s3c24xx_spi_usingfiq - return if channel is using FIQ
+ * @spi: The hardware state.
+ *
+ * Return whether the channel is currently using the FIQ (separate from
+ * whether the FIQ is claimed).
+ */
+static inline bool s3c24xx_spi_usingfiq(struct s3c24xx_spi *spi)
+{
+	return spi->fiq_inuse;
+}
+#else
+
+static inline void s3c24xx_spi_initfiq(struct s3c24xx_spi *s) { }
+static inline void s3c24xx_spi_tryfiq(struct s3c24xx_spi *s) { }
+static inline bool s3c24xx_spi_usefiq(struct s3c24xx_spi *s) { return false; }
+static inline bool s3c24xx_spi_usingfiq(struct s3c24xx_spi *s) { return false; }
+
+#endif /* CONFIG_SPI_S3C24XX_FIQ */
+
 static int s3c24xx_spi_txrx(struct spi_device *spi, struct spi_transfer *t)
 {
 	struct s3c24xx_spi *hw = to_hw(spi);
 
-	dev_dbg(&spi->dev, "txrx: tx %p, rx %p, len %d\n",
-		t->tx_buf, t->rx_buf, t->len);
-
 	hw->tx = t->tx_buf;
 	hw->rx = t->rx_buf;
 	hw->len = t->len;
@@ -228,11 +429,14 @@ static int s3c24xx_spi_txrx(struct spi_d
 
 	init_completion(&hw->done);
 
+	hw->fiq_inuse = 0;
+	if (s3c24xx_spi_usefiq(hw) && t->len >= 3)
+		s3c24xx_spi_tryfiq(hw);
+
 	/* send the first byte */
 	writeb(hw_txbyte(hw, 0), hw->regs + S3C2410_SPTDAT);
 
 	wait_for_completion(&hw->done);
-
 	return hw->count;
 }
 
@@ -254,17 +458,27 @@ static irqreturn_t s3c24xx_spi_irq(int i
 		goto irq_done;
 	}
 
-	hw->count++;
+	if (!s3c24xx_spi_usingfiq(hw)) {
+		hw->count++;
 
-	if (hw->rx)
-		hw->rx[count] = readb(hw->regs + S3C2410_SPRDAT);
+		if (hw->rx)
+			hw->rx[count] = readb(hw->regs + S3C2410_SPRDAT);
 
-	count++;
+		count++;
+
+		if (count < hw->len)
+			writeb(hw_txbyte(hw, count), hw->regs + S3C2410_SPTDAT);
+		else
+			complete(&hw->done);
+	} else {
+		hw->count = hw->len;
+		hw->fiq_inuse = 0;
+
+		if (hw->rx)
+			hw->rx[hw->len-1] = readb(hw->regs + S3C2410_SPRDAT);
 
-	if (count < hw->len)
-		writeb(hw_txbyte(hw, count), hw->regs + S3C2410_SPTDAT);
-	else
 		complete(&hw->done);
+	}
 
  irq_done:
 	return IRQ_HANDLED;
@@ -322,6 +536,10 @@ static int __init s3c24xx_spi_probe(stru
 	platform_set_drvdata(pdev, hw);
 	init_completion(&hw->done);
 
+	/* initialise fiq handler */
+
+	s3c24xx_spi_initfiq(hw);
+
 	/* setup the master state. */
 
 	/* the spi->mode bits understood by this driver: */
diff -puN /dev/null drivers/spi/spi_s3c24xx_fiq.S
--- /dev/null
+++ a/drivers/spi/spi_s3c24xx_fiq.S
@@ -0,0 +1,116 @@
+/* linux/drivers/spi/spi_s3c24xx_fiq.S
+ *
+ * Copyright 2009 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * S3C24XX SPI - FIQ pseudo-DMA transfer code
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+#include <mach/map.h>
+#include <mach/regs-irq.h>
+#include <plat/regs-spi.h>
+
+#include "spi_s3c24xx_fiq.h"
+
+	.text
+
+	@ entry to these routines is as follows, with the register names
+	@ defined in fiq.h so that they can be shared with the C files which
+	@ setup the calling registers.
+	@
+	@ fiq_rirq	The base of the IRQ registers to find S3C2410_SRCPND
+	@ fiq_rtmp	Temporary register to hold tx/rx data
+	@ fiq_rspi	The base of the SPI register block
+	@ fiq_rtx	The tx buffer pointer
+	@ fiq_rrx	The rx buffer pointer
+	@ fiq_rcount	The number of bytes to move
+
+	@ each entry starts with a word entry of how long it is
+	@ and an offset to the irq acknowledgment word
+
+ENTRY(s3c24xx_spi_fiq_rx)
+s3c24xx_spi_fix_rx:
+	.word	fiq_rx_end - fiq_rx_start
+	.word	fiq_rx_irq_ack - fiq_rx_start
+fiq_rx_start:
+	ldr	fiq_rtmp, fiq_rx_irq_ack
+	str	fiq_rtmp, [ fiq_rirq, # S3C2410_SRCPND - S3C24XX_VA_IRQ ]
+
+	ldrb	fiq_rtmp, [ fiq_rspi, #  S3C2410_SPRDAT ]
+	strb	fiq_rtmp, [ fiq_rrx ], #1
+
+	mov	fiq_rtmp, #0xff
+	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
+
+	subs	fiq_rcount, fiq_rcount, #1
+	subnes	pc, lr, #4		@@ return, still have work to do
+
+	@@ set IRQ controller so that next op will trigger IRQ
+	mov	fiq_rtmp, #0
+	str	fiq_rtmp, [ fiq_rirq, # S3C2410_INTMOD  - S3C24XX_VA_IRQ ]
+	subs	pc, lr, #4
+
+fiq_rx_irq_ack:
+	.word	0
+fiq_rx_end:
+
+ENTRY(s3c24xx_spi_fiq_txrx)
+s3c24xx_spi_fiq_txrx:
+	.word	fiq_txrx_end - fiq_txrx_start
+	.word	fiq_txrx_irq_ack - fiq_txrx_start
+fiq_txrx_start:
+
+	ldrb	fiq_rtmp, [ fiq_rspi, #  S3C2410_SPRDAT ]
+	strb	fiq_rtmp, [ fiq_rrx ], #1
+
+	ldr	fiq_rtmp, fiq_txrx_irq_ack
+	str	fiq_rtmp, [ fiq_rirq, # S3C2410_SRCPND - S3C24XX_VA_IRQ ]
+
+	ldrb	fiq_rtmp, [ fiq_rtx ], #1
+	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
+
+	subs	fiq_rcount, fiq_rcount, #1
+	subnes	pc, lr, #4		@@ return, still have work to do
+
+	mov	fiq_rtmp, #0
+	str	fiq_rtmp, [ fiq_rirq, # S3C2410_INTMOD  - S3C24XX_VA_IRQ ]
+	subs	pc, lr, #4
+
+fiq_txrx_irq_ack:
+	.word	0
+
+fiq_txrx_end:
+
+ENTRY(s3c24xx_spi_fiq_tx)
+s3c24xx_spi_fix_tx:
+	.word	fiq_tx_end - fiq_tx_start
+	.word	fiq_tx_irq_ack - fiq_tx_start
+fiq_tx_start:
+	ldrb	fiq_rtmp, [ fiq_rspi, #  S3C2410_SPRDAT ]
+
+	ldr	fiq_rtmp, fiq_tx_irq_ack
+	str	fiq_rtmp, [ fiq_rirq, # S3C2410_SRCPND - S3C24XX_VA_IRQ ]
+
+	ldrb	fiq_rtmp, [ fiq_rtx ], #1
+	strb	fiq_rtmp, [ fiq_rspi, # S3C2410_SPTDAT ]
+
+	subs	fiq_rcount, fiq_rcount, #1
+	subnes	pc, lr, #4		@@ return, still have work to do
+
+	mov	fiq_rtmp, #0
+	str	fiq_rtmp, [ fiq_rirq, # S3C2410_INTMOD  - S3C24XX_VA_IRQ ]
+	subs	pc, lr, #4
+
+fiq_tx_irq_ack:
+	.word	0
+
+fiq_tx_end:
+
+	.end
diff -puN /dev/null drivers/spi/spi_s3c24xx_fiq.h
--- /dev/null
+++ a/drivers/spi/spi_s3c24xx_fiq.h
@@ -0,0 +1,26 @@
+/* linux/drivers/spi/spi_s3c24xx_fiq.h
+ *
+ * Copyright 2009 Simtec Electronics
+ *	Ben Dooks <ben@simtec.co.uk>
+ *
+ * S3C24XX SPI - FIQ pseudo-DMA transfer support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/* We have R8 through R13 to play with */
+
+#ifdef __ASSEMBLY__
+#define __REG_NR(x)     r##x
+#else
+#define __REG_NR(x)     (x)
+#endif
+
+#define fiq_rspi	__REG_NR(8)
+#define fiq_rtmp	__REG_NR(9)
+#define fiq_rrx		__REG_NR(10)
+#define fiq_rtx		__REG_NR(11)
+#define fiq_rcount	__REG_NR(12)
+#define fiq_rirq	__REG_NR(13)
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls.patch
spi_s3c24xx-add-fiq-pseudo-dma-support.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

