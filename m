From: akpm@linux-foundation.org
Subject: + spi-controller-driver-for-designware-spi-core.patch added to -mm tree
Date: Mon, 12 Oct 2009 15:26:15 -0700
Message-ID: <200910122226.n9CMQFcl003396@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933493AbZJLW07 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Oct 2009 18:26:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: feng.tang@intel.com, david-b@pacbell.net


The patch titled
     spi: controller driver for Designware SPI core
has been added to the -mm tree.  Its filename is
     spi-controller-driver-for-designware-spi-core.patch

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
Subject: spi: controller driver for Designware SPI core
From: Feng Tang <feng.tang@intel.com>

Driver for the Designware SPI core, it supports multipul interfaces like
PCI/APB etc.  User can use "dw_apb_ssi_db.pdf" from Synopsys as HW
datasheet.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/spi/Kconfig~spi-controller-driver-for-designware-spi-core drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-controller-driver-for-designware-spi-core
+++ a/drivers/spi/Kconfig
@@ -259,6 +259,12 @@ config SPI_XILINX_PLTFM
 	  This is the platform driver for the SPI controller IP
 	  from the Xilinx EDK.
 
+config SPI_DESIGNWARE
+	bool "DesignWare SPI controller core support"
+	depends on SPI_MASTER
+	help
+	  general driver for SPI controller core from DesignWare
+
 #
 # Add new SPI master controllers in alphabetical order above this line
 #
diff -puN drivers/spi/Makefile~spi-controller-driver-for-designware-spi-core drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-controller-driver-for-designware-spi-core
+++ a/drivers/spi/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_SPI_XILINX_OF)		+= xilinx_s
 obj-$(CONFIG_SPI_XILINX_PLTFM)		+= xilinx_spi_pltfm.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
 obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
+obj-$(CONFIG_SPI_DESIGNWARE)		+= dw_spi.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff -puN /dev/null drivers/spi/dw_spi.c
--- /dev/null
+++ a/drivers/spi/dw_spi.c
@@ -0,0 +1,941 @@
+/*
+ * dw_spi.c - Designware SPI core controller driver (refer pxa2xx_spi.c)
+ *
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/highmem.h>
+#include <linux/delay.h>
+
+#include <linux/spi/dw_spi.h>
+#include <linux/spi/spi.h>
+
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+#endif
+
+#define START_STATE	((void *)0)
+#define RUNNING_STATE	((void *)1)
+#define DONE_STATE	((void *)2)
+#define ERROR_STATE	((void *)-1)
+
+#define QUEUE_RUNNING	0
+#define QUEUE_STOPPED	1
+
+#define MRST_SPI_DEASSERT	0
+#define MRST_SPI_ASSERT		1
+
+/* Slave spi_dev related */
+struct chip_data {
+	u16 cr0;
+	u8 cs;			/* chip select pin */
+	u8 n_bytes;		/* current is a 1/2/4 byte op */
+	u8 tmode;		/* TR/TO/RO/EEPROM */
+	u8 type;		/* SPI/SSP/MicroWire */
+
+	u8 poll_mode;		/* 1 means use poll mode */
+
+	u32 dma_width;
+	u32 rx_threshold;
+	u32 tx_threshold;
+	u8 enable_dma;
+	u8 bits_per_word;
+	u16 clk_div;		/* baud rate divider */
+	u32 speed_hz;		/* baud rate */
+	int (*write)(struct dw_spi *dws);
+	int (*read)(struct dw_spi *dws);
+	void (*cs_control)(u32 command);
+};
+
+#ifdef CONFIG_DEBUG_FS
+static int spi_show_regs_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+#define SPI_REGS_BUFSIZE	1024
+static ssize_t  spi_show_regs(struct file *file, char __user *user_buf,
+				size_t count, loff_t *ppos)
+{
+	struct dw_spi *dws;
+	char *buf;
+	u32 len = 0;
+	ssize_t ret;
+
+	dws = file->private_data;
+
+	buf = kzalloc(SPI_REGS_BUFSIZE, GFP_KERNEL);
+	if (!buf)
+		return 0;
+
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"MRST SPI0 registers:\n");
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"=================================\n");
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"CTRL0: \t\t0x%08x\n", dw_readl(dws, ctrl0));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"CTRL1: \t\t0x%08x\n", dw_readl(dws, ctrl1));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"SSIENR: \t0x%08x\n", dw_readl(dws, ssienr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"SER: \t\t0x%08x\n", dw_readl(dws, ser));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"BAUDR: \t\t0x%08x\n", dw_readl(dws, baudr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"TXFTLR: \t0x%08x\n", dw_readl(dws, txfltr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"RXFTLR: \t0x%08x\n", dw_readl(dws, rxfltr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"TXFLR: \t\t0x%08x\n", dw_readl(dws, txflr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"RXFLR: \t\t0x%08x\n", dw_readl(dws, rxflr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"SR: \t\t0x%08x\n", dw_readl(dws, sr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"IMR: \t\t0x%08x\n", dw_readl(dws, imr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"ISR: \t\t0x%08x\n", dw_readl(dws, isr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"DMACR: \t\t0x%08x\n", dw_readl(dws, dmacr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"DMATDLR: \t0x%08x\n", dw_readl(dws, dmatdlr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"DMARDLR: \t0x%08x\n", dw_readl(dws, dmardlr));
+	len += snprintf(buf + len, SPI_REGS_BUFSIZE - len,
+			"=================================\n");
+
+	ret =  simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	kfree(buf);
+	return ret;
+}
+
+static const struct file_operations mrst_spi_regs_ops = {
+	.owner		= THIS_MODULE,
+	.open		= spi_show_regs_open,
+	.read		= spi_show_regs,
+};
+
+static int mrst_spi_debugfs_init(struct dw_spi *dws)
+{
+	dws->debugfs = debugfs_create_dir("mrst_spi", NULL);
+	if (!dws->debugfs)
+		return -ENOMEM;
+
+	debugfs_create_file("registers", S_IFREG | S_IRUGO,
+		dws->debugfs, (void *)dws, &mrst_spi_regs_ops);
+	return 0;
+}
+
+static void mrst_spi_debugfs_remove(struct dw_spi *dws)
+{
+	if (dws->debugfs)
+		debugfs_remove_recursive(dws->debugfs);
+}
+
+#else
+static inline int mrst_spi_debugfs_init(struct dw_spi *dws)
+{
+}
+
+static inline void mrst_spi_debugfs_remove(struct dw_spi *dws)
+{
+}
+#endif /* CONFIG_DEBUG_FS */
+
+static void wait_till_not_busy(struct dw_spi *dws)
+{
+	unsigned long end = jiffies + usecs_to_jiffies(1000);
+
+	while (time_before(jiffies, end)) {
+		if (!(dw_readw(dws, sr) & SR_BUSY))
+			return;
+	}
+	dev_err(&dws->master->dev,
+		"DW SPI: Stutus keeps busy for 1000us after a read/write!\n");
+}
+
+static void flush(struct dw_spi *dws)
+{
+	while (dw_readw(dws, sr) & SR_RF_NOT_EMPT)
+		dw_readw(dws, dr);
+
+	wait_till_not_busy(dws);
+}
+
+static void null_cs_control(u32 command)
+{
+}
+
+static int null_writer(struct dw_spi *dws)
+{
+	u8 n_bytes = dws->n_bytes;
+
+	if (!(dw_readw(dws, sr) & SR_TF_NOT_FULL)
+		|| (dws->tx == dws->tx_end))
+		return 0;
+	dw_writew(dws, dr, 0);
+	dws->tx += n_bytes;
+
+	wait_till_not_busy(dws);
+	return 1;
+}
+
+static int null_reader(struct dw_spi *dws)
+{
+	u8 n_bytes = dws->n_bytes;
+
+	while ((dw_readw(dws, sr) & SR_RF_NOT_EMPT)
+		&& (dws->rx < dws->rx_end)) {
+		dw_readw(dws, dr);
+		dws->rx += n_bytes;
+	}
+	wait_till_not_busy(dws);
+	return dws->rx == dws->rx_end;
+}
+
+static int u8_writer(struct dw_spi *dws)
+{
+	if (!(dw_readw(dws, sr) & SR_TF_NOT_FULL)
+		|| (dws->tx == dws->tx_end))
+		return 0;
+
+	dw_writew(dws, dr, *(u8 *)(dws->tx));
+	++dws->tx;
+
+	wait_till_not_busy(dws);
+	return 1;
+}
+
+static int u8_reader(struct dw_spi *dws)
+{
+	while ((dw_readw(dws, sr) & SR_RF_NOT_EMPT)
+		&& (dws->rx < dws->rx_end)) {
+		*(u8 *)(dws->rx) = dw_readw(dws, dr);
+		++dws->rx;
+	}
+
+	wait_till_not_busy(dws);
+	return dws->rx == dws->rx_end;
+}
+
+static int u16_writer(struct dw_spi *dws)
+{
+	if (!(dw_readw(dws, sr) & SR_TF_NOT_FULL)
+		|| (dws->tx == dws->tx_end))
+		return 0;
+
+	dw_writew(dws, dr, *(u16 *)(dws->tx));
+	dws->tx += 2;
+
+	wait_till_not_busy(dws);
+	return 1;
+}
+
+static int u16_reader(struct dw_spi *dws)
+{
+	u16 temp;
+
+	while ((dw_readw(dws, sr) & SR_RF_NOT_EMPT)
+		&& (dws->rx < dws->rx_end)) {
+		temp = dw_readw(dws, dr);
+		*(u16 *)(dws->rx) = temp;
+		dws->rx += 2;
+	}
+
+	wait_till_not_busy(dws);
+	return dws->rx == dws->rx_end;
+}
+
+static void *next_transfer(struct dw_spi *dws)
+{
+	struct spi_message *msg = dws->cur_msg;
+	struct spi_transfer *trans = dws->cur_transfer;
+
+	/* Move to next transfer */
+	if (trans->transfer_list.next != &msg->transfers) {
+		dws->cur_transfer =
+			list_entry(trans->transfer_list.next,
+					struct spi_transfer,
+					transfer_list);
+		return RUNNING_STATE;
+	} else
+		return DONE_STATE;
+}
+
+/*
+ * Note: first step is the protocol driver prepares
+ * a dma-capable memory, and this func just need translate
+ * the virt addr to physical
+ */
+static int map_dma_buffers(struct dw_spi *dws)
+{
+	if (!dws->cur_msg->is_dma_mapped || !dws->dma_inited
+		|| !dws->cur_chip->enable_dma)
+		return 0;
+
+	if (dws->cur_transfer->tx_dma)
+		dws->tx_dma = dws->cur_transfer->tx_dma;
+
+	if (dws->cur_transfer->rx_dma)
+		dws->rx_dma = dws->cur_transfer->rx_dma;
+
+	return 1;
+}
+
+/* Caller already set message->status; dma and pio irqs are blocked */
+static void giveback(struct dw_spi *dws)
+{
+	struct spi_transfer *last_transfer;
+	unsigned long flags;
+	struct spi_message *msg;
+
+	spin_lock_irqsave(&dws->lock, flags);
+	msg = dws->cur_msg;
+	dws->cur_msg = NULL;
+	dws->cur_transfer = NULL;
+	dws->prev_chip = dws->cur_chip;
+	dws->cur_chip = NULL;
+	dws->dma_mapped = 0;
+	queue_work(dws->workqueue, &dws->pump_messages);
+	spin_unlock_irqrestore(&dws->lock, flags);
+
+	last_transfer = list_entry(msg->transfers.prev,
+					struct spi_transfer,
+					transfer_list);
+
+	if (!last_transfer->cs_change)
+		dws->cs_control(MRST_SPI_DEASSERT);
+
+	msg->state = NULL;
+	if (msg->complete)
+		msg->complete(msg->context);
+}
+
+static void int_error_stop(struct dw_spi *dws, const char *msg)
+{
+	/* Stop and reset hw */
+	flush(dws);
+	spi_enable_chip(dws, 0);
+
+	dev_err(&dws->master->dev, "%s\n", msg);
+	dws->cur_msg->state = ERROR_STATE;
+	tasklet_schedule(&dws->pump_transfers);
+}
+
+static void transfer_complete(struct dw_spi *dws)
+{
+	/* Update total byte transfered return count actual bytes read */
+	dws->cur_msg->actual_length += dws->len;
+
+	/* Move to next transfer */
+	dws->cur_msg->state = next_transfer(dws);
+
+	/* Handle end of message */
+	if (dws->cur_msg->state == DONE_STATE) {
+		dws->cur_msg->status = 0;
+		giveback(dws);
+	} else
+		tasklet_schedule(&dws->pump_transfers);
+}
+
+static irqreturn_t interrupt_transfer(struct dw_spi *dws)
+{
+	u16 irq_status, irq_mask = 0x3f;
+
+	irq_status = dw_readw(dws, isr) & irq_mask;
+	/* Error handling */
+	if (irq_status & (SPI_INT_TXOI | SPI_INT_RXOI | SPI_INT_RXUI)) {
+		dw_readw(dws, txoicr);
+		dw_readw(dws, rxoicr);
+		dw_readw(dws, rxuicr);
+		int_error_stop(dws, "interrupt_transfer: fifo overrun");
+		return IRQ_HANDLED;
+	}
+
+	/* INT comes from tx */
+	if (dws->tx && (irq_status & SPI_INT_TXEI)) {
+		while (dws->tx < dws->tx_end)
+			dws->write(dws);
+
+		if (dws->tx == dws->tx_end) {
+			spi_mask_intr(dws, SPI_INT_TXEI);
+			transfer_complete(dws);
+		}
+	}
+
+	/* INT comes from rx */
+	if (dws->rx && (irq_status & SPI_INT_RXFI)) {
+		if (dws->read(dws))
+			transfer_complete(dws);
+	}
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t dw_spi_irq(int irq, void *dev_id)
+{
+	struct dw_spi *dws = dev_id;
+
+	if (!dws->cur_msg) {
+		spi_mask_intr(dws, SPI_INT_TXEI);
+		/* Never fail */
+		return IRQ_HANDLED;
+	}
+
+	return dws->transfer_handler(dws);
+}
+
+/* Must be called inside pump_transfers() */
+static void poll_transfer(struct dw_spi *dws)
+{
+	if (dws->tx) {
+		while (dws->write(dws))
+			dws->read(dws);
+	}
+
+	dws->read(dws);
+	transfer_complete(dws);
+}
+
+static void dma_transfer(struct dw_spi *dws, int cs_change)
+{
+}
+
+static void pump_transfers(unsigned long data)
+{
+	struct dw_spi *dws = (struct dw_spi *)data;
+	struct spi_message *message = NULL;
+	struct spi_transfer *transfer = NULL;
+	struct spi_transfer *previous = NULL;
+	struct spi_device *spi = NULL;
+	struct chip_data *chip = NULL;
+	u8 bits = 0;
+	u8 imask = 0;
+	u8 cs_change = 0;
+	u16 clk_div = 0;
+	u32 speed = 0;
+	u32 cr0 = 0;
+
+	/* Get current state information */
+	message = dws->cur_msg;
+	transfer = dws->cur_transfer;
+	chip = dws->cur_chip;
+	spi = message->spi;
+
+	if (message->state == ERROR_STATE) {
+		message->status = -EIO;
+		goto early_exit;
+	}
+
+	/* Handle end of message */
+	if (message->state == DONE_STATE) {
+		message->status = 0;
+		goto early_exit;
+	}
+
+	/* Delay if requested at end of transfer*/
+	if (message->state == RUNNING_STATE) {
+		previous = list_entry(transfer->transfer_list.prev,
+					struct spi_transfer,
+					transfer_list);
+		if (previous->delay_usecs)
+			udelay(previous->delay_usecs);
+	}
+
+	dws->n_bytes = chip->n_bytes;
+	dws->dma_width = chip->dma_width;
+	dws->cs_control = chip->cs_control;
+
+	dws->rx_dma = transfer->rx_dma;
+	dws->tx_dma = transfer->tx_dma;
+	dws->tx = (void *)transfer->tx_buf;
+	dws->tx_end = dws->tx + transfer->len;
+	dws->rx = transfer->rx_buf;
+	dws->rx_end = dws->rx + transfer->len;
+	dws->write = dws->tx ? chip->write : null_writer;
+	dws->read = dws->rx ? chip->read : null_reader;
+	dws->cs_change = transfer->cs_change;
+	dws->len = dws->cur_transfer->len;
+	if (chip != dws->prev_chip)
+		cs_change = 1;
+
+	cr0 = chip->cr0;
+
+	/* Handle per transfer options for bpw and speed */
+	if (transfer->speed_hz) {
+		speed = chip->speed_hz;
+
+		if (transfer->speed_hz != speed) {
+			speed = transfer->speed_hz;
+			if (speed > dws->max_freq) {
+				printk(KERN_ERR "MRST SPI0: unsupported"
+					"freq: %dHz\n", speed);
+				message->status = -EIO;
+				goto early_exit;
+			}
+
+			/* clk_div doesn't support odd number */
+			clk_div = dws->max_freq / speed;
+			clk_div = (clk_div >> 1) << 1;
+
+			chip->speed_hz = speed;
+			chip->clk_div = clk_div;
+		}
+	}
+	if (transfer->bits_per_word) {
+		bits = transfer->bits_per_word;
+
+		switch (bits) {
+		case 8:
+			dws->n_bytes = 1;
+			dws->dma_width = 1;
+			dws->read = (dws->read != null_reader) ?
+					u8_reader : null_reader;
+			dws->write = (dws->write != null_writer) ?
+					u8_writer : null_writer;
+			break;
+		case 16:
+			dws->n_bytes = 2;
+			dws->dma_width = 2;
+			dws->read = (dws->read != null_reader) ?
+					u16_reader : null_reader;
+			dws->write = (dws->write != null_writer) ?
+					u16_writer : null_writer;
+			break;
+		default:
+			printk(KERN_ERR "MRST SPI0: unsupported bits:"
+				"%db\n", bits);
+			message->status = -EIO;
+			goto early_exit;
+		}
+
+		cr0 = (bits - 1)
+			| (chip->type << SPI_FRF_OFFSET)
+			| (spi->mode << SPI_MODE_OFFSET)
+			| (chip->tmode << SPI_TMOD_OFFSET);
+	}
+	message->state = RUNNING_STATE;
+
+	/* Check if current transfer is a DMA transaction */
+	dws->dma_mapped = map_dma_buffers(dws);
+
+	if (!dws->dma_mapped && !chip->poll_mode) {
+		if (dws->rx)
+			imask |= SPI_INT_RXFI;
+		if (dws->tx)
+			imask |= SPI_INT_TXEI;
+		dws->transfer_handler = interrupt_transfer;
+	}
+
+	/*
+	 * Reprogram registers only if
+	 *	1. chip select changes
+	 *	2. clk_div is changed
+	 *	3. control value changes
+	 */
+	if (dw_readw(dws, ctrl0) != cr0 || cs_change || clk_div) {
+		spi_enable_chip(dws, 0);
+
+		if (dw_readw(dws, ctrl0) != cr0)
+			dw_writew(dws, ctrl0, cr0);
+
+		/* Set the interrupt mask, for poll mode just diable all int */
+		spi_mask_intr(dws, 0xff);
+		if (!chip->poll_mode)
+			spi_umask_intr(dws, imask);
+
+		spi_set_clk(dws, clk_div ? clk_div : chip->clk_div);
+		spi_chip_sel(dws, spi->chip_select);
+		spi_enable_chip(dws, 1);
+
+		if (cs_change)
+			dws->prev_chip = chip;
+	}
+
+	if (dws->dma_mapped)
+		dma_transfer(dws, cs_change);
+
+	if (chip->poll_mode)
+		poll_transfer(dws);
+
+	return;
+
+early_exit:
+	giveback(dws);
+	return;
+}
+
+static void pump_messages(struct work_struct *work)
+{
+	struct dw_spi *dws =
+		container_of(work, struct dw_spi, pump_messages);
+	unsigned long flags;
+
+	/* Lock queue and check for queue work */
+	spin_lock_irqsave(&dws->lock, flags);
+	if (list_empty(&dws->queue) || dws->run == QUEUE_STOPPED) {
+		dws->busy = 0;
+		spin_unlock_irqrestore(&dws->lock, flags);
+		return;
+	}
+
+	/* Make sure we are not already running a message */
+	if (dws->cur_msg) {
+		spin_unlock_irqrestore(&dws->lock, flags);
+		return;
+	}
+
+	/* Extract head of queue */
+	dws->cur_msg = list_entry(dws->queue.next, struct spi_message, queue);
+	list_del_init(&dws->cur_msg->queue);
+
+	/* Initial message state*/
+	dws->cur_msg->state = START_STATE;
+	dws->cur_transfer = list_entry(dws->cur_msg->transfers.next,
+						struct spi_transfer,
+						transfer_list);
+	dws->cur_chip = spi_get_ctldata(dws->cur_msg->spi);
+
+	/* Mark as busy and launch transfers */
+	tasklet_schedule(&dws->pump_transfers);
+
+	dws->busy = 1;
+	spin_unlock_irqrestore(&dws->lock, flags);
+}
+
+/* spi_device use this to queue in their spi_msg */
+static int dw_spi_transfer(struct spi_device *spi, struct spi_message *msg)
+{
+	struct dw_spi *dws = spi_master_get_devdata(spi->master);
+	unsigned long flags;
+
+	spin_lock_irqsave(&dws->lock, flags);
+
+	if (dws->run == QUEUE_STOPPED) {
+		spin_unlock_irqrestore(&dws->lock, flags);
+		return -ESHUTDOWN;
+	}
+
+	msg->actual_length = 0;
+	msg->status = -EINPROGRESS;
+	msg->state = START_STATE;
+
+	list_add_tail(&msg->queue, &dws->queue);
+
+	if (dws->run == QUEUE_RUNNING && !dws->busy) {
+
+		if (dws->cur_transfer || dws->cur_msg)
+			queue_work(dws->workqueue,
+					&dws->pump_messages);
+		else {
+			/* If no other data transaction in air, just go */
+			spin_unlock_irqrestore(&dws->lock, flags);
+			pump_messages(&dws->pump_messages);
+			return 0;
+		}
+	}
+
+	spin_unlock_irqrestore(&dws->lock, flags);
+	return 0;
+}
+
+/* This may be called twice for each spi dev */
+static int dw_spi_setup(struct spi_device *spi)
+{
+	struct dw_spi_chip *chip_info = NULL;
+	struct chip_data *chip;
+
+	if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
+		return -EINVAL;
+
+	/* Only alloc on first setup */
+	chip = spi_get_ctldata(spi);
+	if (!chip) {
+		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
+		if (!chip)
+			return -ENOMEM;
+
+		chip->cs_control = null_cs_control;
+		chip->enable_dma = 0;
+	}
+
+	/*
+	 * Protocol drivers may change the chip settings, so...
+	 * if chip_info exists, use it
+	 */
+	chip_info = spi->controller_data;
+
+	/* chip_info doesn't always exist */
+	if (chip_info) {
+		if (chip_info->cs_control)
+			chip->cs_control = chip_info->cs_control;
+
+		chip->poll_mode = chip_info->poll_mode;
+		chip->type = chip_info->type;
+
+		chip->rx_threshold = 0;
+		chip->tx_threshold = 0;
+
+		chip->enable_dma = chip_info->enable_dma;
+	}
+
+	if (spi->bits_per_word <= 8) {
+		chip->n_bytes = 1;
+		chip->dma_width = 1;
+		chip->read = u8_reader;
+		chip->write = u8_writer;
+	} else if (spi->bits_per_word <= 16) {
+		chip->n_bytes = 2;
+		chip->dma_width = 2;
+		chip->read = u16_reader;
+		chip->write = u16_writer;
+	} else {
+		/* Never take >16b case for MRST SPIC */
+		dev_err(&spi->dev, "invalid wordsize\n");
+		return -EINVAL;
+	}
+	chip->bits_per_word = spi->bits_per_word;
+
+	chip->speed_hz = spi->max_speed_hz;
+	if (chip->speed_hz)
+		chip->clk_div = 25000000 / chip->speed_hz;
+	else
+		chip->clk_div = 8;	/* default value */
+
+	chip->tmode = 0; /* Tx & Rx */
+	/* Default SPI mode is SCPOL = 0, SCPH = 0 */
+	chip->cr0 = (chip->bits_per_word - 1)
+			| (chip->type << SPI_FRF_OFFSET)
+			| (spi->mode  << SPI_MODE_OFFSET)
+			| (chip->tmode << SPI_TMOD_OFFSET);
+
+	spi_set_ctldata(spi, chip);
+	return 0;
+}
+
+static void dw_spi_cleanup(struct spi_device *spi)
+{
+	struct chip_data *chip = spi_get_ctldata(spi);
+	kfree(chip);
+}
+
+static int __init init_queue(struct dw_spi *dws)
+{
+	INIT_LIST_HEAD(&dws->queue);
+	spin_lock_init(&dws->lock);
+
+	dws->run = QUEUE_STOPPED;
+	dws->busy = 0;
+
+	tasklet_init(&dws->pump_transfers,
+			pump_transfers,	(unsigned long)dws);
+
+	INIT_WORK(&dws->pump_messages, pump_messages);
+	dws->workqueue = create_singlethread_workqueue(
+					dev_name(dws->master->dev.parent));
+	if (dws->workqueue == NULL)
+		return -EBUSY;
+
+	return 0;
+}
+
+static int start_queue(struct dw_spi *dws)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dws->lock, flags);
+
+	if (dws->run == QUEUE_RUNNING || dws->busy) {
+		spin_unlock_irqrestore(&dws->lock, flags);
+		return -EBUSY;
+	}
+
+	dws->run = QUEUE_RUNNING;
+	dws->cur_msg = NULL;
+	dws->cur_transfer = NULL;
+	dws->cur_chip = NULL;
+	dws->prev_chip = NULL;
+	spin_unlock_irqrestore(&dws->lock, flags);
+
+	queue_work(dws->workqueue, &dws->pump_messages);
+
+	return 0;
+}
+
+static int stop_queue(struct dw_spi *dws)
+{
+	unsigned long flags;
+	unsigned limit = 50;
+	int status = 0;
+
+	spin_lock_irqsave(&dws->lock, flags);
+	dws->run = QUEUE_STOPPED;
+	while (!list_empty(&dws->queue) && dws->busy && limit--) {
+		spin_unlock_irqrestore(&dws->lock, flags);
+		msleep(10);
+		spin_lock_irqsave(&dws->lock, flags);
+	}
+
+	if (!list_empty(&dws->queue) || dws->busy)
+		status = -EBUSY;
+	spin_unlock_irqrestore(&dws->lock, flags);
+
+	return status;
+}
+
+static int destroy_queue(struct dw_spi *dws)
+{
+	int status;
+
+	status = stop_queue(dws);
+	if (status != 0)
+		return status;
+	destroy_workqueue(dws->workqueue);
+	return 0;
+}
+
+/* Restart the controller, disable all interrupts, clean rx fifo */
+static void spi_hw_init(struct dw_spi *dws)
+{
+	spi_enable_chip(dws, 0);
+	spi_mask_intr(dws, 0xff);
+	spi_enable_chip(dws, 1);
+	flush(dws);
+}
+
+int __devinit dw_spi_add_host(struct dw_spi *dws)
+{
+	struct spi_master *master;
+	int ret;
+
+	BUG_ON(dws == NULL);
+
+	master = spi_alloc_master(dws->parent_dev, 0);
+	if (!master) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	dws->master = master;
+	dws->type = SSI_MOTO_SPI;
+	dws->prev_chip = NULL;
+	dws->dma_inited = 0;
+	dws->dma_addr = (dma_addr_t)(dws->paddr + 0x60);
+
+	ret = request_irq(dws->irq, dw_spi_irq, 0,
+			"dw_spi", dws);
+	if (ret < 0) {
+		dev_err(&master->dev, "can not get IRQ\n");
+		goto err_free_master;
+	}
+
+	master->mode_bits = SPI_CPOL | SPI_CPHA;
+	master->bus_num = dws->bus_num;
+	master->num_chipselect = dws->num_cs;
+	master->cleanup = dw_spi_cleanup;
+	master->setup = dw_spi_setup;
+	master->transfer = dw_spi_transfer;
+
+	dws->dma_inited = 0;
+
+	/* Basic HW init */
+	spi_hw_init(dws);
+
+	/* Initial and start queue */
+	ret = init_queue(dws);
+	if (ret) {
+		dev_err(&master->dev, "problem initializing queue\n");
+		goto err_diable_hw;
+	}
+	ret = start_queue(dws);
+	if (ret) {
+		dev_err(&master->dev, "problem starting queue\n");
+		goto err_diable_hw;
+	}
+
+	spi_master_set_devdata(master, dws);
+	ret = spi_register_master(master);
+	if (ret) {
+		dev_err(&master->dev, "problem registering spi master\n");
+		goto err_queue_alloc;
+	}
+
+	mrst_spi_debugfs_init(dws);
+	return 0;
+
+err_queue_alloc:
+	destroy_queue(dws);
+err_diable_hw:
+	spi_enable_chip(dws, 0);
+	free_irq(dws->irq, dws);
+err_free_master:
+	spi_master_put(master);
+exit:
+	return ret;
+}
+
+void __devexit dw_spi_remove_host(struct dw_spi *dws)
+{
+	int status = 0;
+
+	if (!dws)
+		return;
+	mrst_spi_debugfs_remove(dws);
+
+	/* Remove the queue */
+	status = destroy_queue(dws);
+	if (status != 0)
+		dev_err(&dws->master->dev, "dw_spi_remove: workqueue will not "
+			"complete, message memory not freed\n");
+
+	spi_enable_chip(dws, 0);
+	/* Disable clk */
+	spi_set_clk(dws, 0);
+	free_irq(dws->irq, dws);
+
+	/* Disconnect from the SPI framework */
+	spi_unregister_master(dws->master);
+}
+
+int dw_spi_suspend_host(struct dw_spi *dws)
+{
+	int ret = 0;
+
+	ret = stop_queue(dws);
+	if (ret)
+		return ret;
+	spi_enable_chip(dws, 0);
+	spi_set_clk(dws, 0);
+	return ret;
+}
+
+int dw_spi_resume_host(struct dw_spi *dws)
+{
+	int ret;
+
+	spi_hw_init(dws);
+	ret = start_queue(dws);
+	if (ret)
+		dev_err(&dws->master->dev, "fail to start queue (%d)\n", ret);
+	return ret;
+}
+
+MODULE_AUTHOR("Feng Tang <feng.tang@intel.com>");
+MODULE_DESCRIPTION("Driver for DesignWare SPI controller core");
+MODULE_LICENSE("GPL v2");
diff -puN /dev/null include/linux/spi/dw_spi.h
--- /dev/null
+++ a/include/linux/spi/dw_spi.h
@@ -0,0 +1,212 @@
+#ifndef DW_SPI_HEADER_H
+#define DW_SPI_HEADER_H
+#include <linux/io.h>
+
+/* Bit fields in CTRLR0 */
+#define SPI_DFS_OFFSET			0
+
+#define SPI_FRF_OFFSET			4
+#define SPI_FRF_SPI			0x0
+#define SPI_FRF_SSP			0x1
+#define SPI_FRF_MICROWIRE		0x2
+#define SPI_FRF_RESV			0x3
+
+#define SPI_MODE_OFFSET			6
+#define SPI_SCPH_OFFSET			6
+#define SPI_SCOL_OFFSET			7
+#define SPI_TMOD_OFFSET			8
+#define	SPI_TMOD_TR			0x0		/* xmit & recv */
+#define SPI_TMOD_TO			0x1		/* xmit only */
+#define SPI_TMOD_RO			0x2		/* recv only */
+#define SPI_TMOD_EPROMREAD		0x3		/* eeprom read mode */
+
+#define SPI_SLVOE_OFFSET		10
+#define SPI_SRL_OFFSET			11
+#define SPI_CFS_OFFSET			12
+
+/* Bit fields in SR, 7 bits */
+#define SR_MASK				0x7f		/* cover 7 bits */
+#define SR_BUSY				(1 << 0)
+#define SR_TF_NOT_FULL			(1 << 1)
+#define SR_TF_EMPT			(1 << 2)
+#define SR_RF_NOT_EMPT			(1 << 3)
+#define SR_RF_FULL			(1 << 4)
+#define SR_TX_ERR			(1 << 5)
+#define SR_DCOL				(1 << 6)
+
+/* Bit fields in ISR, IMR, RISR, 7 bits */
+#define SPI_INT_TXEI			(1 << 0)
+#define SPI_INT_TXOI			(1 << 1)
+#define SPI_INT_RXUI			(1 << 2)
+#define SPI_INT_RXOI			(1 << 3)
+#define SPI_INT_RXFI			(1 << 4)
+#define SPI_INT_MSTI			(1 << 5)
+
+/* TX RX interrupt level threshhold, max can be 256 */
+#define SPI_INT_THRESHOLD		32
+
+enum dw_ssi_type {
+	SSI_MOTO_SPI = 0,
+	SSI_TI_SSP,
+	SSI_NS_MICROWIRE,
+};
+
+struct dw_spi_reg {
+	u32	ctrl0;
+	u32	ctrl1;
+	u32	ssienr;
+	u32	mwcr;
+	u32	ser;
+	u32	baudr;
+	u32	txfltr;
+	u32	rxfltr;
+	u32	txflr;
+	u32	rxflr;
+	u32	sr;
+	u32	imr;
+	u32	isr;
+	u32	risr;
+	u32	txoicr;
+	u32	rxoicr;
+	u32	rxuicr;
+	u32	msticr;
+	u32	icr;
+	u32	dmacr;
+	u32	dmatdlr;
+	u32	dmardlr;
+	u32	idr;
+	u32	version;
+	u32	dr;		/* Currently oper as 32 bits,
+				though only low 16 bits matters */
+} __packed;
+
+struct dw_spi {
+	struct spi_master	*master;
+	struct spi_device	*cur_dev;
+	struct device		*parent_dev;
+	enum dw_ssi_type	type;
+
+	void __iomem		*regs;
+	unsigned long		paddr;
+	u32			iolen;
+	int			irq;
+	u32			max_freq;	/* max bus freq supported */
+
+	u16			bus_num;
+	u16			num_cs;		/* supported slave numbers */
+
+	/* Driver message queue */
+	struct workqueue_struct	*workqueue;
+	struct work_struct	pump_messages;
+	spinlock_t		lock;
+	struct list_head	queue;
+	int			busy;
+	int			run;
+
+	/* Message Transfer pump */
+	struct tasklet_struct	pump_transfers;
+
+	/* Current message transfer state info */
+	struct spi_message	*cur_msg;
+	struct spi_transfer	*cur_transfer;
+	struct chip_data	*cur_chip;
+	struct chip_data	*prev_chip;
+	size_t			len;
+	void			*tx;
+	void			*tx_end;
+	void			*rx;
+	void			*rx_end;
+	int			dma_mapped;
+	dma_addr_t		rx_dma;
+	dma_addr_t		tx_dma;
+	size_t			rx_map_len;
+	size_t			tx_map_len;
+	u8			n_bytes;	/* current is a 1/2 bytes op */
+	u8			max_bits_per_word;	/* maxim is 16b */
+	u32			dma_width;
+	int			cs_change;
+	int			(*write)(struct dw_spi *dws);
+	int			(*read)(struct dw_spi *dws);
+	irqreturn_t		(*transfer_handler)(struct dw_spi *dws);
+	void			(*cs_control)(u32 command);
+
+	/* Dma info */
+	int			dma_inited;
+	struct dma_chan		*txchan;
+	struct dma_chan		*rxchan;
+	int			txdma_done;
+	int			rxdma_done;
+	u64			tx_param;
+	u64			rx_param;
+	struct device		*dma_dev;
+	dma_addr_t		dma_addr;
+
+	/* Bus interface info */
+	void			*priv;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfs;
+#endif
+};
+
+#define dw_readl(dw, name) \
+	__raw_readl(&(((struct dw_spi_reg *)dw->regs)->name))
+#define dw_writel(dw, name, val) \
+	__raw_writel((val), &(((struct dw_spi_reg *)dw->regs)->name))
+#define dw_readw(dw, name) \
+	__raw_readw(&(((struct dw_spi_reg *)dw->regs)->name))
+#define dw_writew(dw, name, val) \
+	__raw_writew((val), &(((struct dw_spi_reg *)dw->regs)->name))
+
+static inline void spi_enable_chip(struct dw_spi *dws, int enable)
+{
+	dw_writel(dws, ssienr, (enable ? 1 : 0));
+}
+
+static inline void spi_set_clk(struct dw_spi *dws, u16 div)
+{
+	dw_writel(dws, baudr, div);
+}
+
+static inline void spi_chip_sel(struct dw_spi *dws, u16 cs)
+{
+	if (cs > dws->num_cs)
+		return;
+	dw_writel(dws, ser, 1 << cs);
+}
+
+/* Disable IRQ bits */
+static inline void spi_mask_intr(struct dw_spi *dws, u32 mask)
+{
+	u32 new_mask;
+
+	new_mask = dw_readl(dws, imr) & ~mask;
+	dw_writel(dws, imr, new_mask);
+}
+
+/* Enable IRQ bits */
+static inline void spi_umask_intr(struct dw_spi *dws, u32 mask)
+{
+	u32 new_mask;
+
+	new_mask = dw_readl(dws, imr) | mask;
+	dw_writel(dws, imr, new_mask);
+}
+
+/*
+ * Each SPI slave device to work with dw_api controller should
+ * has such a structure claiming its working mode (PIO/DMA etc),
+ * which can be save in the "controller_data" member of the
+ * struct spi_device
+ */
+struct dw_spi_chip {
+	u8 poll_mode;	/* 0 for contoller polling mode */
+	u8 type;	/* SPI/SSP/Micrwire */
+	u8 enable_dma;
+	void (*cs_control)(u32 command);
+};
+
+extern int dw_spi_add_host(struct dw_spi *dws);
+extern void dw_spi_remove_host(struct dw_spi *dws);
+extern int dw_spi_suspend_host(struct dw_spi *dws);
+extern int dw_spi_resume_host(struct dw_spi *dws);
+#endif /* DW_SPI_HEADER_H */
_

Patches currently in -mm which might be from feng.tang@intel.com are

hrtimers-remove-the-timer_stats_active-check-when-setting-the-start-info.patch
spi-controller-driver-for-designware-spi-core.patch
spi-add-pci-interface-driver-for-designware-spi-core.patch
spi-dma-support-for-designware-core-on-moorestown-platform.patch

