From: akpm@linux-foundation.org
Subject: - spi-atmel_spi-driver.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:40 -0800
Message-ID: <200702150847.l1F8leS7024998@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39943 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965366AbXBOIrw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     SPI: atmel_spi driver
has been removed from the -mm tree.  Its filename was
     spi-atmel_spi-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPI: atmel_spi driver
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Driver for the Atmel on-chip SPI master controller.

Tested primarily on AVR32/AT32AP7000/ATSTK1000 using mtd_dataflash and the
jffs2 filesystem.  Should also work fine on various AT91 ARM-based chips
like AT91SAM926x and AT91RM9200.

Hardware documentation can be found in the AT32AP7000 data sheet, or its
AT91 siblings, which can be downloaded from

http://www.atmel.com/dyn/products/datasheets.asp?family_id=682

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS             |    5 
 drivers/spi/Kconfig     |    7 
 drivers/spi/Makefile    |    1 
 drivers/spi/atmel_spi.c |  678 ++++++++++++++++++++++++++++++++++++++
 drivers/spi/atmel_spi.h |  167 +++++++++
 5 files changed, 858 insertions(+)

diff -puN MAINTAINERS~spi-atmel_spi-driver MAINTAINERS
--- a/MAINTAINERS~spi-atmel_spi-driver
+++ a/MAINTAINERS
@@ -620,6 +620,11 @@ P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
 S:	Supported
 
+ATMEL SPI DRIVER
+P:	Haavard Skinnemoen
+M:	hskinnemoen@atmel.com
+S:	Supported
+
 ATMEL WIRELESS DRIVER
 P:	Simon Kelley
 M:	simon@thekelleys.org.uk
diff -puN drivers/spi/Kconfig~spi-atmel_spi-driver drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-atmel_spi-driver
+++ a/drivers/spi/Kconfig
@@ -51,6 +51,13 @@ config SPI_MASTER
 comment "SPI Master Controller Drivers"
 	depends on SPI_MASTER
 
+config SPI_ATMEL
+	tristate "Atmel SPI Controller"
+	depends on (ARCH_AT91 || AVR32) && SPI_MASTER
+	help
+	  This selects a driver for the Atmel SPI Controller, present on
+	  many AT32 (AVR32) and AT91 (ARM) chips.
+
 config SPI_BITBANG
 	tristate "Bitbanging SPI master"
 	depends on SPI_MASTER && EXPERIMENTAL
diff -puN drivers/spi/Makefile~spi-atmel_spi-driver drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-atmel_spi-driver
+++ a/drivers/spi/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_SPI_MASTER)		+= spi.o
 
 # SPI master controller drivers (bus)
 obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
+obj-$(CONFIG_SPI_ATMEL)			+= atmel_spi.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butterfly.o
 obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
 obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
diff -puN /dev/null drivers/spi/atmel_spi.c
--- /dev/null
+++ a/drivers/spi/atmel_spi.c
@@ -0,0 +1,678 @@
+/*
+ * Driver for Atmel AT32 and AT91 SPI Controllers
+ *
+ * Copyright (C) 2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <linux/spi/spi.h>
+
+#include <asm/io.h>
+#include <asm/arch/board.h>
+#include <asm/arch/gpio.h>
+
+#include "atmel_spi.h"
+
+/*
+ * The core SPI transfer engine just talks to a register bank to set up
+ * DMA transfers; transfer queue progress is driven by IRQs.  The clock
+ * framework provides the base clock, subdivided for each spi_device.
+ *
+ * Newer controllers, marked with "new_1" flag, have:
+ *  - CR.LASTXFER
+ *  - SPI_MR.DIV32 may become FDIV or must-be-zero (here: always zero)
+ *  - SPI_SR.TXEMPTY, SPI_SR.NSSR (and corresponding irqs)
+ *  - SPI_CSRx.CSAAT
+ *  - SPI_CSRx.SBCR allows faster clocking
+ */
+struct atmel_spi {
+	spinlock_t		lock;
+
+	void __iomem		*regs;
+	int			irq;
+	struct clk		*clk;
+	struct platform_device	*pdev;
+	unsigned		new_1:1;
+
+	u8			stopping;
+	struct list_head	queue;
+	struct spi_transfer	*current_transfer;
+	unsigned long		remaining_bytes;
+
+	void			*buffer;
+	dma_addr_t		buffer_dma;
+};
+
+#define BUFFER_SIZE		PAGE_SIZE
+#define INVALID_DMA_ADDRESS	0xffffffff
+
+/*
+ * Earlier SPI controllers (e.g. on at91rm9200) have a design bug whereby
+ * they assume that spi slave device state will not change on deselect, so
+ * that automagic deselection is OK.  Not so!  Workaround uses nCSx pins
+ * as GPIOs; or newer controllers have CSAAT and friends.
+ *
+ * Since the CSAAT functionality is a bit weird on newer controllers
+ * as well, we use GPIO to control nCSx pins on all controllers.
+ */
+
+static inline void cs_activate(struct spi_device *spi)
+{
+	unsigned gpio = (unsigned) spi->controller_data;
+	unsigned active = spi->mode & SPI_CS_HIGH;
+
+	dev_dbg(&spi->dev, "activate %u%s\n", gpio, active ? " (high)" : "");
+	gpio_set_value(gpio, active);
+}
+
+static inline void cs_deactivate(struct spi_device *spi)
+{
+	unsigned gpio = (unsigned) spi->controller_data;
+	unsigned active = spi->mode & SPI_CS_HIGH;
+
+	dev_dbg(&spi->dev, "DEactivate %u%s\n", gpio, active ? " (low)" : "");
+	gpio_set_value(gpio, !active);
+}
+
+/*
+ * Submit next transfer for DMA.
+ * lock is held, spi irq is blocked
+ */
+static void atmel_spi_next_xfer(struct spi_master *master,
+				struct spi_message *msg)
+{
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+	struct spi_transfer	*xfer;
+	u32			len;
+	dma_addr_t		tx_dma, rx_dma;
+
+	xfer = as->current_transfer;
+	if (!xfer || as->remaining_bytes == 0) {
+		if (xfer)
+			xfer = list_entry(xfer->transfer_list.next,
+					struct spi_transfer, transfer_list);
+		else
+			xfer = list_entry(msg->transfers.next,
+					struct spi_transfer, transfer_list);
+		as->remaining_bytes = xfer->len;
+		as->current_transfer = xfer;
+	}
+
+	len = as->remaining_bytes;
+
+	tx_dma = xfer->tx_dma;
+	rx_dma = xfer->rx_dma;
+
+	/* use scratch buffer only when rx or tx data is unspecified */
+	if (rx_dma == INVALID_DMA_ADDRESS) {
+		rx_dma = as->buffer_dma;
+		if (len > BUFFER_SIZE)
+			len = BUFFER_SIZE;
+	}
+	if (tx_dma == INVALID_DMA_ADDRESS) {
+		tx_dma = as->buffer_dma;
+		if (len > BUFFER_SIZE)
+			len = BUFFER_SIZE;
+		memset(as->buffer, 0, len);
+		dma_sync_single_for_device(&as->pdev->dev,
+				as->buffer_dma, len, DMA_TO_DEVICE);
+	}
+
+	spi_writel(as, RPR, rx_dma);
+	spi_writel(as, TPR, tx_dma);
+
+	as->remaining_bytes -= len;
+	if (msg->spi->bits_per_word > 8)
+		len >>= 1;
+
+	/* REVISIT: when xfer->delay_usecs == 0, the PDC "next transfer"
+	 * mechanism might help avoid the IRQ latency between transfers
+	 *
+	 * We're also waiting for ENDRX before we start the next
+	 * transfer because we need to handle some difficult timing
+	 * issues otherwise. If we wait for ENDTX in one transfer and
+	 * then starts waiting for ENDRX in the next, it's difficult
+	 * to tell the difference between the ENDRX interrupt we're
+	 * actually waiting for and the ENDRX interrupt of the
+	 * previous transfer.
+	 *
+	 * It should be doable, though. Just not now...
+	 */
+	spi_writel(as, TNCR, 0);
+	spi_writel(as, RNCR, 0);
+	spi_writel(as, IER, SPI_BIT(ENDRX) | SPI_BIT(OVRES));
+
+	dev_dbg(&msg->spi->dev,
+		"  start xfer %p: len %u tx %p/%08x rx %p/%08x imr %03x\n",
+		xfer, xfer->len, xfer->tx_buf, xfer->tx_dma,
+		xfer->rx_buf, xfer->rx_dma, spi_readl(as, IMR));
+
+	spi_writel(as, TCR, len);
+	spi_writel(as, RCR, len);
+	spi_writel(as, PTCR, SPI_BIT(TXTEN) | SPI_BIT(RXTEN));
+}
+
+static void atmel_spi_next_message(struct spi_master *master)
+{
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+	struct spi_message	*msg;
+	u32			mr;
+
+	BUG_ON(as->current_transfer);
+
+	msg = list_entry(as->queue.next, struct spi_message, queue);
+
+	/* Select the chip */
+	mr = spi_readl(as, MR);
+	mr = SPI_BFINS(PCS, ~(1 << msg->spi->chip_select), mr);
+	spi_writel(as, MR, mr);
+	cs_activate(msg->spi);
+
+	atmel_spi_next_xfer(master, msg);
+}
+
+static void
+atmel_spi_dma_map_xfer(struct atmel_spi *as, struct spi_transfer *xfer)
+{
+	xfer->tx_dma = xfer->rx_dma = INVALID_DMA_ADDRESS;
+	if (xfer->tx_buf)
+		xfer->tx_dma = dma_map_single(&as->pdev->dev,
+				(void *) xfer->tx_buf, xfer->len,
+				DMA_TO_DEVICE);
+	if (xfer->rx_buf)
+		xfer->rx_dma = dma_map_single(&as->pdev->dev,
+				xfer->rx_buf, xfer->len,
+				DMA_FROM_DEVICE);
+}
+
+static void atmel_spi_dma_unmap_xfer(struct spi_master *master,
+				     struct spi_transfer *xfer)
+{
+	if (xfer->tx_dma != INVALID_DMA_ADDRESS)
+		dma_unmap_single(master->cdev.dev, xfer->tx_dma,
+				 xfer->len, DMA_TO_DEVICE);
+	if (xfer->rx_dma != INVALID_DMA_ADDRESS)
+		dma_unmap_single(master->cdev.dev, xfer->rx_dma,
+				 xfer->len, DMA_FROM_DEVICE);
+}
+
+static void
+atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
+		   struct spi_message *msg, int status)
+{
+	cs_deactivate(msg->spi);
+	list_del(&msg->queue);
+	msg->status = status;
+
+	dev_dbg(master->cdev.dev,
+		"xfer complete: %u bytes transferred\n",
+		msg->actual_length);
+
+	spin_unlock(&as->lock);
+	msg->complete(msg->context);
+	spin_lock(&as->lock);
+
+	as->current_transfer = NULL;
+
+	/* continue if needed */
+	if (list_empty(&as->queue) || as->stopping)
+		spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
+	else
+		atmel_spi_next_message(master);
+}
+
+static irqreturn_t
+atmel_spi_interrupt(int irq, void *dev_id)
+{
+	struct spi_master	*master = dev_id;
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+	struct spi_message	*msg;
+	struct spi_transfer	*xfer;
+	u32			status, pending, imr;
+	int			ret = IRQ_NONE;
+
+	spin_lock(&as->lock);
+
+	xfer = as->current_transfer;
+	msg = list_entry(as->queue.next, struct spi_message, queue);
+
+	imr = spi_readl(as, IMR);
+	status = spi_readl(as, SR);
+	pending = status & imr;
+
+	if (pending & SPI_BIT(OVRES)) {
+		int timeout;
+
+		ret = IRQ_HANDLED;
+
+		spi_writel(as, IDR, (SPI_BIT(ENDTX) | SPI_BIT(ENDRX)
+				     | SPI_BIT(OVRES)));
+
+		/*
+		 * When we get an overrun, we disregard the current
+		 * transfer. Data will not be copied back from any
+		 * bounce buffer and msg->actual_len will not be
+		 * updated with the last xfer.
+		 *
+		 * We will also not process any remaning transfers in
+		 * the message.
+		 *
+		 * First, stop the transfer and unmap the DMA buffers.
+		 */
+		spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
+		if (!msg->is_dma_mapped)
+			atmel_spi_dma_unmap_xfer(master, xfer);
+
+		/* REVISIT: udelay in irq is unfriendly */
+		if (xfer->delay_usecs)
+			udelay(xfer->delay_usecs);
+
+		dev_warn(master->cdev.dev, "fifo overrun (%u/%u remaining)\n",
+			 spi_readl(as, TCR), spi_readl(as, RCR));
+
+		/*
+		 * Clean up DMA registers and make sure the data
+		 * registers are empty.
+		 */
+		spi_writel(as, RNCR, 0);
+		spi_writel(as, TNCR, 0);
+		spi_writel(as, RCR, 0);
+		spi_writel(as, TCR, 0);
+		for (timeout = 1000; timeout; timeout--)
+			if (spi_readl(as, SR) & SPI_BIT(TXEMPTY))
+				break;
+		if (!timeout)
+			dev_warn(master->cdev.dev,
+				 "timeout waiting for TXEMPTY");
+		while (spi_readl(as, SR) & SPI_BIT(RDRF))
+			spi_readl(as, RDR);
+
+		/* Clear any overrun happening while cleaning up */
+		spi_readl(as, SR);
+
+		atmel_spi_msg_done(master, as, msg, -EIO);
+	} else if (pending & SPI_BIT(ENDRX)) {
+		ret = IRQ_HANDLED;
+
+		spi_writel(as, IDR, pending);
+
+		if (as->remaining_bytes == 0) {
+			msg->actual_length += xfer->len;
+
+			if (!msg->is_dma_mapped)
+				atmel_spi_dma_unmap_xfer(master, xfer);
+
+			/* REVISIT: udelay in irq is unfriendly */
+			if (xfer->delay_usecs)
+				udelay(xfer->delay_usecs);
+
+			if (msg->transfers.prev == &xfer->transfer_list) {
+				/* report completed message */
+				atmel_spi_msg_done(master, as, msg, 0);
+			} else {
+				if (xfer->cs_change) {
+					cs_deactivate(msg->spi);
+					udelay(1);
+					cs_activate(msg->spi);
+				}
+
+				/*
+				 * Not done yet. Submit the next transfer.
+				 *
+				 * FIXME handle protocol options for xfer
+				 */
+				atmel_spi_next_xfer(master, msg);
+			}
+		} else {
+			/*
+			 * Keep going, we still have data to send in
+			 * the current transfer.
+			 */
+			atmel_spi_next_xfer(master, msg);
+		}
+	}
+
+	spin_unlock(&as->lock);
+
+	return ret;
+}
+
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
+
+static int atmel_spi_setup(struct spi_device *spi)
+{
+	struct atmel_spi	*as;
+	u32			scbr, csr;
+	unsigned int		bits = spi->bits_per_word;
+	unsigned long		bus_hz, sck_hz;
+	unsigned int		npcs_pin;
+	int			ret;
+
+	as = spi_master_get_devdata(spi->master);
+
+	if (as->stopping)
+		return -ESHUTDOWN;
+
+	if (spi->chip_select > spi->master->num_chipselect) {
+		dev_dbg(&spi->dev,
+				"setup: invalid chipselect %u (%u defined)\n",
+				spi->chip_select, spi->master->num_chipselect);
+		return -EINVAL;
+	}
+
+	if (bits == 0)
+		bits = 8;
+	if (bits < 8 || bits > 16) {
+		dev_dbg(&spi->dev,
+				"setup: invalid bits_per_word %u (8 to 16)\n",
+				bits);
+		return -EINVAL;
+	}
+
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
+	/* speed zero convention is used by some upper layers */
+	bus_hz = clk_get_rate(as->clk);
+	if (spi->max_speed_hz) {
+		/* assume div32/fdiv/mbz == 0 */
+		if (!as->new_1)
+			bus_hz /= 2;
+		scbr = ((bus_hz + spi->max_speed_hz - 1)
+			/ spi->max_speed_hz);
+		if (scbr >= (1 << SPI_SCBR_SIZE)) {
+			dev_dbg(&spi->dev, "setup: %d Hz too slow, scbr %u\n",
+					spi->max_speed_hz, scbr);
+			return -EINVAL;
+		}
+	} else
+		scbr = 0xff;
+	sck_hz = bus_hz / scbr;
+
+	csr = SPI_BF(SCBR, scbr) | SPI_BF(BITS, bits - 8);
+	if (spi->mode & SPI_CPOL)
+		csr |= SPI_BIT(CPOL);
+	if (!(spi->mode & SPI_CPHA))
+		csr |= SPI_BIT(NCPHA);
+
+	/* TODO: DLYBS and DLYBCT */
+	csr |= SPI_BF(DLYBS, 10);
+	csr |= SPI_BF(DLYBCT, 10);
+
+	/* chipselect must have been muxed as GPIO (e.g. in board setup) */
+	npcs_pin = (unsigned int)spi->controller_data;
+	if (!spi->controller_state) {
+		ret = gpio_request(npcs_pin, "spi_npcs");
+		if (ret)
+			return ret;
+		spi->controller_state = (void *)npcs_pin;
+		gpio_direction_output(npcs_pin);
+	}
+
+	dev_dbg(&spi->dev,
+		"setup: %lu Hz bpw %u mode 0x%x -> csr%d %08x\n",
+		sck_hz, bits, spi->mode, spi->chip_select, csr);
+
+	spi_writel(as, CSR0 + 4 * spi->chip_select, csr);
+
+	return 0;
+}
+
+static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
+{
+	struct atmel_spi	*as;
+	struct spi_transfer	*xfer;
+	unsigned long		flags;
+	struct device		*controller = spi->master->cdev.dev;
+
+	as = spi_master_get_devdata(spi->master);
+
+	dev_dbg(controller, "new message %p submitted for %s\n",
+			msg, spi->dev.bus_id);
+
+	if (unlikely(list_empty(&msg->transfers)
+			|| !spi->max_speed_hz))
+		return -EINVAL;
+
+	if (as->stopping)
+		return -ESHUTDOWN;
+
+	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
+		if (!(xfer->tx_buf || xfer->rx_buf)) {
+			dev_dbg(&spi->dev, "missing rx or tx buf\n");
+			return -EINVAL;
+		}
+
+		/* FIXME implement these protocol options!! */
+		if (xfer->bits_per_word || xfer->speed_hz) {
+			dev_dbg(&spi->dev, "no protocol options yet\n");
+			return -ENOPROTOOPT;
+		}
+	}
+
+	/* scrub dcache "early" */
+	if (!msg->is_dma_mapped) {
+		list_for_each_entry(xfer, &msg->transfers, transfer_list)
+			atmel_spi_dma_map_xfer(as, xfer);
+	}
+
+	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
+		dev_dbg(controller,
+			"  xfer %p: len %u tx %p/%08x rx %p/%08x\n",
+			xfer, xfer->len,
+			xfer->tx_buf, xfer->tx_dma,
+			xfer->rx_buf, xfer->rx_dma);
+	}
+
+	msg->status = -EINPROGRESS;
+	msg->actual_length = 0;
+
+	spin_lock_irqsave(&as->lock, flags);
+	list_add_tail(&msg->queue, &as->queue);
+	if (!as->current_transfer)
+		atmel_spi_next_message(spi->master);
+	spin_unlock_irqrestore(&as->lock, flags);
+
+	return 0;
+}
+
+static void atmel_spi_cleanup(const struct spi_device *spi)
+{
+	if (spi->controller_state)
+		gpio_free((unsigned int)spi->controller_data);
+}
+
+/*-------------------------------------------------------------------------*/
+
+static int __init atmel_spi_probe(struct platform_device *pdev)
+{
+	struct resource		*regs;
+	int			irq;
+	struct clk		*clk;
+	int			ret;
+	struct spi_master	*master;
+	struct atmel_spi	*as;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	clk = clk_get(&pdev->dev, "spi_clk");
+	if (IS_ERR(clk))
+		return PTR_ERR(clk);
+
+	/* setup spi core then atmel-specific driver state */
+	ret = -ENOMEM;
+	master = spi_alloc_master(&pdev->dev, sizeof *as);
+	if (!master)
+		goto out_free;
+
+	master->bus_num = pdev->id;
+	master->num_chipselect = 4;
+	master->setup = atmel_spi_setup;
+	master->transfer = atmel_spi_transfer;
+	master->cleanup = atmel_spi_cleanup;
+	platform_set_drvdata(pdev, master);
+
+	as = spi_master_get_devdata(master);
+
+	as->buffer = dma_alloc_coherent(&pdev->dev, BUFFER_SIZE,
+					&as->buffer_dma, GFP_KERNEL);
+	if (!as->buffer)
+		goto out_free;
+
+	spin_lock_init(&as->lock);
+	INIT_LIST_HEAD(&as->queue);
+	as->pdev = pdev;
+	as->regs = ioremap(regs->start, (regs->end - regs->start) + 1);
+	if (!as->regs)
+		goto out_free_buffer;
+	as->irq = irq;
+	as->clk = clk;
+#ifdef CONFIG_ARCH_AT91
+	if (!cpu_is_at91rm9200())
+		as->new_1 = 1;
+#endif
+
+	ret = request_irq(irq, atmel_spi_interrupt, 0,
+			pdev->dev.bus_id, master);
+	if (ret)
+		goto out_unmap_regs;
+
+	/* Initialize the hardware */
+	clk_enable(clk);
+	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_writel(as, MR, SPI_BIT(MSTR) | SPI_BIT(MODFDIS));
+	spi_writel(as, PTCR, SPI_BIT(RXTDIS) | SPI_BIT(TXTDIS));
+	spi_writel(as, CR, SPI_BIT(SPIEN));
+
+	/* go! */
+	dev_info(&pdev->dev, "Atmel SPI Controller at 0x%08lx (irq %d)\n",
+			(unsigned long)regs->start, irq);
+
+	ret = spi_register_master(master);
+	if (ret)
+		goto out_reset_hw;
+
+	return 0;
+
+out_reset_hw:
+	spi_writel(as, CR, SPI_BIT(SWRST));
+	clk_disable(clk);
+	free_irq(irq, master);
+out_unmap_regs:
+	iounmap(as->regs);
+out_free_buffer:
+	dma_free_coherent(&pdev->dev, BUFFER_SIZE, as->buffer,
+			as->buffer_dma);
+out_free:
+	clk_put(clk);
+	spi_master_put(master);
+	return ret;
+}
+
+static int __exit atmel_spi_remove(struct platform_device *pdev)
+{
+	struct spi_master	*master = platform_get_drvdata(pdev);
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+	struct spi_message	*msg;
+
+	/* reset the hardware and block queue progress */
+	spin_lock_irq(&as->lock);
+	as->stopping = 1;
+	spi_writel(as, CR, SPI_BIT(SWRST));
+	spi_readl(as, SR);
+	spin_unlock_irq(&as->lock);
+
+	/* Terminate remaining queued transfers */
+	list_for_each_entry(msg, &as->queue, queue) {
+		/* REVISIT unmapping the dma is a NOP on ARM and AVR32
+		 * but we shouldn't depend on that...
+		 */
+		msg->status = -ESHUTDOWN;
+		msg->complete(msg->context);
+	}
+
+	dma_free_coherent(&pdev->dev, BUFFER_SIZE, as->buffer,
+			as->buffer_dma);
+
+	clk_disable(as->clk);
+	clk_put(as->clk);
+	free_irq(as->irq, master);
+	iounmap(as->regs);
+
+	spi_unregister_master(master);
+
+	return 0;
+}
+
+#ifdef	CONFIG_PM
+
+static int atmel_spi_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct spi_master	*master = platform_get_drvdata(pdev);
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+
+	clk_disable(as->clk);
+	return 0;
+}
+
+static int atmel_spi_resume(struct platform_device *pdev)
+{
+	struct spi_master	*master = platform_get_drvdata(pdev);
+	struct atmel_spi	*as = spi_master_get_devdata(master);
+
+	clk_enable(as->clk);
+	return 0;
+}
+
+#else
+#define	atmel_spi_suspend	NULL
+#define	atmel_spi_resume	NULL
+#endif
+
+
+static struct platform_driver atmel_spi_driver = {
+	.driver		= {
+		.name	= "atmel_spi",
+		.owner	= THIS_MODULE,
+	},
+	.suspend	= atmel_spi_suspend,
+	.resume		= atmel_spi_resume,
+	.remove		= __exit_p(atmel_spi_remove),
+};
+
+static int __init atmel_spi_init(void)
+{
+	return platform_driver_probe(&atmel_spi_driver, atmel_spi_probe);
+}
+module_init(atmel_spi_init);
+
+static void __exit atmel_spi_exit(void)
+{
+	platform_driver_unregister(&atmel_spi_driver);
+}
+module_exit(atmel_spi_exit);
+
+MODULE_DESCRIPTION("Atmel AT32/AT91 SPI Controller driver");
+MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/spi/atmel_spi.h
--- /dev/null
+++ a/drivers/spi/atmel_spi.h
@@ -0,0 +1,167 @@
+/*
+ * Register definitions for Atmel Serial Peripheral Interface (SPI)
+ *
+ * Copyright (C) 2006 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __ATMEL_SPI_H__
+#define __ATMEL_SPI_H__
+
+/* SPI register offsets */
+#define SPI_CR					0x0000
+#define SPI_MR					0x0004
+#define SPI_RDR					0x0008
+#define SPI_TDR					0x000c
+#define SPI_SR					0x0010
+#define SPI_IER					0x0014
+#define SPI_IDR					0x0018
+#define SPI_IMR					0x001c
+#define SPI_CSR0				0x0030
+#define SPI_CSR1				0x0034
+#define SPI_CSR2				0x0038
+#define SPI_CSR3				0x003c
+#define SPI_RPR					0x0100
+#define SPI_RCR					0x0104
+#define SPI_TPR					0x0108
+#define SPI_TCR					0x010c
+#define SPI_RNPR				0x0110
+#define SPI_RNCR				0x0114
+#define SPI_TNPR				0x0118
+#define SPI_TNCR				0x011c
+#define SPI_PTCR				0x0120
+#define SPI_PTSR				0x0124
+
+/* Bitfields in CR */
+#define SPI_SPIEN_OFFSET			0
+#define SPI_SPIEN_SIZE				1
+#define SPI_SPIDIS_OFFSET			1
+#define SPI_SPIDIS_SIZE				1
+#define SPI_SWRST_OFFSET			7
+#define SPI_SWRST_SIZE				1
+#define SPI_LASTXFER_OFFSET			24
+#define SPI_LASTXFER_SIZE			1
+
+/* Bitfields in MR */
+#define SPI_MSTR_OFFSET				0
+#define SPI_MSTR_SIZE				1
+#define SPI_PS_OFFSET				1
+#define SPI_PS_SIZE				1
+#define SPI_PCSDEC_OFFSET			2
+#define SPI_PCSDEC_SIZE				1
+#define SPI_FDIV_OFFSET				3
+#define SPI_FDIV_SIZE				1
+#define SPI_MODFDIS_OFFSET			4
+#define SPI_MODFDIS_SIZE			1
+#define SPI_LLB_OFFSET				7
+#define SPI_LLB_SIZE				1
+#define SPI_PCS_OFFSET				16
+#define SPI_PCS_SIZE				4
+#define SPI_DLYBCS_OFFSET			24
+#define SPI_DLYBCS_SIZE				8
+
+/* Bitfields in RDR */
+#define SPI_RD_OFFSET				0
+#define SPI_RD_SIZE				16
+
+/* Bitfields in TDR */
+#define SPI_TD_OFFSET				0
+#define SPI_TD_SIZE				16
+
+/* Bitfields in SR */
+#define SPI_RDRF_OFFSET				0
+#define SPI_RDRF_SIZE				1
+#define SPI_TDRE_OFFSET				1
+#define SPI_TDRE_SIZE				1
+#define SPI_MODF_OFFSET				2
+#define SPI_MODF_SIZE				1
+#define SPI_OVRES_OFFSET			3
+#define SPI_OVRES_SIZE				1
+#define SPI_ENDRX_OFFSET			4
+#define SPI_ENDRX_SIZE				1
+#define SPI_ENDTX_OFFSET			5
+#define SPI_ENDTX_SIZE				1
+#define SPI_RXBUFF_OFFSET			6
+#define SPI_RXBUFF_SIZE				1
+#define SPI_TXBUFE_OFFSET			7
+#define SPI_TXBUFE_SIZE				1
+#define SPI_NSSR_OFFSET				8
+#define SPI_NSSR_SIZE				1
+#define SPI_TXEMPTY_OFFSET			9
+#define SPI_TXEMPTY_SIZE			1
+#define SPI_SPIENS_OFFSET			16
+#define SPI_SPIENS_SIZE				1
+
+/* Bitfields in CSR0 */
+#define SPI_CPOL_OFFSET				0
+#define SPI_CPOL_SIZE				1
+#define SPI_NCPHA_OFFSET			1
+#define SPI_NCPHA_SIZE				1
+#define SPI_CSAAT_OFFSET			3
+#define SPI_CSAAT_SIZE				1
+#define SPI_BITS_OFFSET				4
+#define SPI_BITS_SIZE				4
+#define SPI_SCBR_OFFSET				8
+#define SPI_SCBR_SIZE				8
+#define SPI_DLYBS_OFFSET			16
+#define SPI_DLYBS_SIZE				8
+#define SPI_DLYBCT_OFFSET			24
+#define SPI_DLYBCT_SIZE				8
+
+/* Bitfields in RCR */
+#define SPI_RXCTR_OFFSET			0
+#define SPI_RXCTR_SIZE				16
+
+/* Bitfields in TCR */
+#define SPI_TXCTR_OFFSET			0
+#define SPI_TXCTR_SIZE				16
+
+/* Bitfields in RNCR */
+#define SPI_RXNCR_OFFSET			0
+#define SPI_RXNCR_SIZE				16
+
+/* Bitfields in TNCR */
+#define SPI_TXNCR_OFFSET			0
+#define SPI_TXNCR_SIZE				16
+
+/* Bitfields in PTCR */
+#define SPI_RXTEN_OFFSET			0
+#define SPI_RXTEN_SIZE				1
+#define SPI_RXTDIS_OFFSET			1
+#define SPI_RXTDIS_SIZE				1
+#define SPI_TXTEN_OFFSET			8
+#define SPI_TXTEN_SIZE				1
+#define SPI_TXTDIS_OFFSET			9
+#define SPI_TXTDIS_SIZE				1
+
+/* Constants for BITS */
+#define SPI_BITS_8_BPT				0
+#define SPI_BITS_9_BPT				1
+#define SPI_BITS_10_BPT				2
+#define SPI_BITS_11_BPT				3
+#define SPI_BITS_12_BPT				4
+#define SPI_BITS_13_BPT				5
+#define SPI_BITS_14_BPT				6
+#define SPI_BITS_15_BPT				7
+#define SPI_BITS_16_BPT				8
+
+/* Bit manipulation macros */
+#define SPI_BIT(name) \
+	(1 << SPI_##name##_OFFSET)
+#define SPI_BF(name,value) \
+	(((value) & ((1 << SPI_##name##_SIZE) - 1)) << SPI_##name##_OFFSET)
+#define SPI_BFEXT(name,value) \
+	(((value) >> SPI_##name##_OFFSET) & ((1 << SPI_##name##_SIZE) - 1))
+#define SPI_BFINS(name,value,old) \
+	( ((old) & ~(((1 << SPI_##name##_SIZE) - 1) << SPI_##name##_OFFSET)) \
+	  | SPI_BF(name,value))
+
+/* Register access macros */
+#define spi_readl(port,reg) \
+	__raw_readl((port)->regs + SPI_##reg)
+#define spi_writel(port,reg,value) \
+	__raw_writel((value), (port)->regs + SPI_##reg)
+
+#endif /* __ATMEL_SPI_H__ */
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
git-arm.patch
git-avr32.patch
git-mtd.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
