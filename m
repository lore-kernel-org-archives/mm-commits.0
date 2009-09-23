From: akpm@linux-foundation.org
Subject: [merged] spi-freescale-stmp-driver.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:30 -0700
Message-ID: <200909231958.n8NJwUVU009035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753797AbZIWT7I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:59:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dpervushin@embeddedalley.com, dbrownell@users.sourceforge.net, galak@gate.crashing.org, timur@freescale.com, mm-commits@vger.kernel.org


The patch titled
     spi: Freescale STMP driver
has been removed from the -mm tree.  Its filename was
     spi-freescale-stmp-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: Freescale STMP driver
From: dmitry pervushin <dpervushin@embeddedalley.com>

Add SPI driver for Freescale STMP 3xxx-based boards

[dbrownell@users.sourceforge.net: cleanup sequence, spi_unregister_master]
Signed-off-by: dmitry pervushin <dpervushin@embeddedalley.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Timur Tabi <timur@freescale.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig    |    6 
 drivers/spi/Makefile   |    1 
 drivers/spi/spi_stmp.c |  679 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 686 insertions(+)

diff -puN drivers/spi/Kconfig~spi-freescale-stmp-driver drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-freescale-stmp-driver
+++ a/drivers/spi/Kconfig
@@ -222,6 +222,12 @@ config SPI_SH_SCI
 	help
 	  SPI driver for SuperH SCI blocks.
 
+config SPI_STMP3XXX
+	tristate "Freescale STMP37xx/378x SPI/SSP controller"
+	depends on ARCH_STMP3XXX && SPI_MASTER
+	help
+	  SPI driver for Freescale STMP37xx/378x SoC SSP interface
+
 config SPI_TXX9
 	tristate "Toshiba TXx9 SPI controller"
 	depends on GENERIC_GPIO && CPU_TX49XX
diff -puN drivers/spi/Makefile~spi-freescale-stmp-driver drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-freescale-stmp-driver
+++ a/drivers/spi/Makefile
@@ -32,6 +32,7 @@ obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24x
 obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
 obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
 obj-$(CONFIG_SPI_SH_SCI)		+= spi_sh_sci.o
+obj-$(CONFIG_SPI_STMP3XXX)		+= spi_stmp.o
 # 	... add above this line ...
 
 # SPI protocol drivers (device/link on bus)
diff -puN /dev/null drivers/spi/spi_stmp.c
--- /dev/null
+++ a/drivers/spi/spi_stmp.c
@@ -0,0 +1,679 @@
+/*
+ * Freescale STMP378X SPI master driver
+ *
+ * Author: dmitry pervushin <dimka@embeddedalley.com>
+ *
+ * Copyright 2008 Freescale Semiconductor, Inc. All Rights Reserved.
+ * Copyright 2008 Embedded Alley Solutions, Inc All Rights Reserved.
+ */
+
+/*
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/err.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+
+#include <mach/platform.h>
+#include <mach/stmp3xxx.h>
+#include <mach/dma.h>
+#include <mach/regs-ssp.h>
+#include <mach/regs-apbh.h>
+
+
+/* 0 means DMA mode(recommended, default), !0 - PIO mode */
+static int pio;
+static int clock;
+
+/* default timeout for busy waits is 2 seconds */
+#define STMP_SPI_TIMEOUT	(2 * HZ)
+
+struct stmp_spi {
+	int		id;
+
+	void *  __iomem regs;	/* vaddr of the control registers */
+
+	int		irq, err_irq;
+	u32		dma;
+	struct stmp3xxx_dma_descriptor d;
+
+	u32		speed_khz;
+	u32		saved_timings;
+	u32		divider;
+
+	struct clk	*clk;
+	struct device	*master_dev;
+
+	struct work_struct work;
+	struct workqueue_struct *workqueue;
+
+	/* lock protects queue access */
+	spinlock_t lock;
+	struct list_head queue;
+
+	struct completion done;
+};
+
+#define busy_wait(cond)							\
+	({								\
+	unsigned long end_jiffies = jiffies + STMP_SPI_TIMEOUT;		\
+	bool succeeded = false;						\
+	do {								\
+		if (cond) {						\
+			succeeded = true;				\
+			break;						\
+		}							\
+		cpu_relax();						\
+	} while (time_before(end_jiffies, jiffies));			\
+	succeeded;							\
+	})
+
+/**
+ * stmp_spi_init_hw
+ * Initialize the SSP port
+ */
+static int stmp_spi_init_hw(struct stmp_spi *ss)
+{
+	int err = 0;
+	void *pins = ss->master_dev->platform_data;
+
+	err = stmp3xxx_request_pin_group(pins, dev_name(ss->master_dev));
+	if (err)
+		goto out;
+
+	ss->clk = clk_get(NULL, "ssp");
+	if (IS_ERR(ss->clk)) {
+		err = PTR_ERR(ss->clk);
+		goto out_free_pins;
+	}
+	clk_enable(ss->clk);
+
+	stmp3xxx_reset_block(ss->regs, false);
+	stmp3xxx_dma_reset_channel(ss->dma);
+
+	return 0;
+
+out_free_pins:
+	stmp3xxx_release_pin_group(pins, dev_name(ss->master_dev));
+out:
+	return err;
+}
+
+static void stmp_spi_release_hw(struct stmp_spi *ss)
+{
+	void *pins = ss->master_dev->platform_data;
+
+	if (ss->clk && !IS_ERR(ss->clk)) {
+		clk_disable(ss->clk);
+		clk_put(ss->clk);
+	}
+	stmp3xxx_release_pin_group(pins, dev_name(ss->master_dev));
+}
+
+static int stmp_spi_setup_transfer(struct spi_device *spi,
+		struct spi_transfer *t)
+{
+	u8 bits_per_word;
+	u32 hz;
+	struct stmp_spi *ss = spi_master_get_devdata(spi->master);
+	u16 rate;
+
+	bits_per_word = spi->bits_per_word;
+	if (t && t->bits_per_word)
+		bits_per_word = t->bits_per_word;
+
+	/*
+	 * Calculate speed:
+	 *	- by default, use maximum speed from ssp clk
+	 *	- if device overrides it, use it
+	 *	- if transfer specifies other speed, use transfer's one
+	 */
+	hz = 1000 * ss->speed_khz / ss->divider;
+	if (spi->max_speed_hz)
+		hz = min(hz, spi->max_speed_hz);
+	if (t && t->speed_hz)
+		hz = min(hz, t->speed_hz);
+
+	if (hz == 0) {
+		dev_err(&spi->dev, "Cannot continue with zero clock\n");
+		return -EINVAL;
+	}
+
+	if (bits_per_word != 8) {
+		dev_err(&spi->dev, "%s, unsupported bits_per_word=%d\n",
+			__func__, bits_per_word);
+		return -EINVAL;
+	}
+
+	dev_dbg(&spi->dev, "Requested clk rate = %uHz, max = %uHz/%d = %uHz\n",
+		hz, ss->speed_khz, ss->divider,
+		ss->speed_khz * 1000 / ss->divider);
+
+	if (ss->speed_khz * 1000 / ss->divider < hz) {
+		dev_err(&spi->dev, "%s, unsupported clock rate %uHz\n",
+			__func__, hz);
+		return -EINVAL;
+	}
+
+	rate = 1000 * ss->speed_khz/ss->divider/hz;
+
+	writel(BF(ss->divider, SSP_TIMING_CLOCK_DIVIDE)		|
+	       BF(rate - 1, SSP_TIMING_CLOCK_RATE),
+	       HW_SSP_TIMING + ss->regs);
+
+	writel(BF(1 /* mode SPI */, SSP_CTRL1_SSP_MODE)		|
+	       BF(4 /* 8 bits   */, SSP_CTRL1_WORD_LENGTH)	|
+	       ((spi->mode & SPI_CPOL) ? BM_SSP_CTRL1_POLARITY : 0) |
+	       ((spi->mode & SPI_CPHA) ? BM_SSP_CTRL1_PHASE : 0) |
+	       (pio ? 0 : BM_SSP_CTRL1_DMA_ENABLE),
+	       ss->regs + HW_SSP_CTRL1);
+
+	return 0;
+}
+
+static int stmp_spi_setup(struct spi_device *spi)
+{
+	/* spi_setup() does basic checks,
+	 * stmp_spi_setup_transfer() does more later
+	 */
+	if (spi->bits_per_word != 8) {
+		dev_err(&spi->dev, "%s, unsupported bits_per_word=%d\n",
+			__func__, spi->bits_per_word);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static inline u32 stmp_spi_cs(unsigned cs)
+{
+	return  ((cs & 1) ? BM_SSP_CTRL0_WAIT_FOR_CMD : 0) |
+		((cs & 2) ? BM_SSP_CTRL0_WAIT_FOR_IRQ : 0);
+}
+
+static int stmp_spi_txrx_dma(struct stmp_spi *ss, int cs,
+		unsigned char *buf, dma_addr_t dma_buf, int len,
+		int first, int last, bool write)
+{
+	u32 c0 = 0;
+	dma_addr_t spi_buf_dma = dma_buf;
+	int status = 0;
+	enum dma_data_direction dir = write ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+
+	c0 |= (first ? BM_SSP_CTRL0_LOCK_CS : 0);
+	c0 |= (last ? BM_SSP_CTRL0_IGNORE_CRC : 0);
+	c0 |= (write ? 0 : BM_SSP_CTRL0_READ);
+	c0 |= BM_SSP_CTRL0_DATA_XFER;
+
+	c0 |= stmp_spi_cs(cs);
+
+	c0 |= BF(len, SSP_CTRL0_XFER_COUNT);
+
+	if (!dma_buf)
+		spi_buf_dma = dma_map_single(ss->master_dev, buf, len, dir);
+
+	ss->d.command->cmd =
+		BF(len, APBH_CHn_CMD_XFER_COUNT)	|
+		BF(1, APBH_CHn_CMD_CMDWORDS)		|
+		BM_APBH_CHn_CMD_WAIT4ENDCMD		|
+		BM_APBH_CHn_CMD_IRQONCMPLT		|
+		BF(write ? BV_APBH_CHn_CMD_COMMAND__DMA_READ :
+			   BV_APBH_CHn_CMD_COMMAND__DMA_WRITE,
+		   APBH_CHn_CMD_COMMAND);
+	ss->d.command->pio_words[0] = c0;
+	ss->d.command->buf_ptr = spi_buf_dma;
+
+	stmp3xxx_dma_reset_channel(ss->dma);
+	stmp3xxx_dma_clear_interrupt(ss->dma);
+	stmp3xxx_dma_enable_interrupt(ss->dma);
+	init_completion(&ss->done);
+	stmp3xxx_dma_go(ss->dma, &ss->d, 1);
+	wait_for_completion(&ss->done);
+
+	if (!busy_wait(readl(ss->regs + HW_SSP_CTRL0) & BM_SSP_CTRL0_RUN))
+		status = ETIMEDOUT;
+
+	if (!dma_buf)
+		dma_unmap_single(ss->master_dev, spi_buf_dma, len, dir);
+
+	return status;
+}
+
+static inline void stmp_spi_enable(struct stmp_spi *ss)
+{
+	stmp3xxx_setl(BM_SSP_CTRL0_LOCK_CS, ss->regs + HW_SSP_CTRL0);
+	stmp3xxx_clearl(BM_SSP_CTRL0_IGNORE_CRC, ss->regs + HW_SSP_CTRL0);
+}
+
+static inline void stmp_spi_disable(struct stmp_spi *ss)
+{
+	stmp3xxx_clearl(BM_SSP_CTRL0_LOCK_CS, ss->regs + HW_SSP_CTRL0);
+	stmp3xxx_setl(BM_SSP_CTRL0_IGNORE_CRC, ss->regs + HW_SSP_CTRL0);
+}
+
+static int stmp_spi_txrx_pio(struct stmp_spi *ss, int cs,
+		unsigned char *buf, int len,
+		bool first, bool last, bool write)
+{
+	if (first)
+		stmp_spi_enable(ss);
+
+	stmp3xxx_setl(stmp_spi_cs(cs), ss->regs + HW_SSP_CTRL0);
+
+	while (len--) {
+		if (last && len <= 0)
+			stmp_spi_disable(ss);
+
+		stmp3xxx_clearl(BM_SSP_CTRL0_XFER_COUNT,
+				ss->regs + HW_SSP_CTRL0);
+		stmp3xxx_setl(1, ss->regs + HW_SSP_CTRL0);
+
+		if (write)
+			stmp3xxx_clearl(BM_SSP_CTRL0_READ,
+					ss->regs + HW_SSP_CTRL0);
+		else
+			stmp3xxx_setl(BM_SSP_CTRL0_READ,
+					ss->regs + HW_SSP_CTRL0);
+
+		/* Run! */
+		stmp3xxx_setl(BM_SSP_CTRL0_RUN, ss->regs + HW_SSP_CTRL0);
+
+		if (!busy_wait(readl(ss->regs + HW_SSP_CTRL0) &
+				BM_SSP_CTRL0_RUN))
+			break;
+
+		if (write)
+			writel(*buf, ss->regs + HW_SSP_DATA);
+
+		/* Set TRANSFER */
+		stmp3xxx_setl(BM_SSP_CTRL0_DATA_XFER, ss->regs + HW_SSP_CTRL0);
+
+		if (!write) {
+			if (busy_wait((readl(ss->regs + HW_SSP_STATUS) &
+					BM_SSP_STATUS_FIFO_EMPTY)))
+				break;
+			*buf = readl(ss->regs + HW_SSP_DATA) & 0xFF;
+		}
+
+		if (!busy_wait(readl(ss->regs + HW_SSP_CTRL0) &
+					BM_SSP_CTRL0_RUN))
+			break;
+
+		/* advance to the next byte */
+		buf++;
+	}
+
+	return len < 0 ? 0 : -ETIMEDOUT;
+}
+
+static int stmp_spi_handle_message(struct stmp_spi *ss, struct spi_message *m)
+{
+	bool first, last;
+	struct spi_transfer *t, *tmp_t;
+	int status = 0;
+	int cs;
+
+	cs = m->spi->chip_select;
+
+	list_for_each_entry_safe(t, tmp_t, &m->transfers, transfer_list) {
+
+		first = (&t->transfer_list == m->transfers.next);
+		last = (&t->transfer_list == m->transfers.prev);
+
+		if (first || t->speed_hz || t->bits_per_word)
+			stmp_spi_setup_transfer(m->spi, t);
+
+		/* reject "not last" transfers which request to change cs */
+		if (t->cs_change && !last) {
+			dev_err(&m->spi->dev,
+				"Message with t->cs_change has been skipped\n");
+			continue;
+		}
+
+		if (t->tx_buf) {
+			status = pio ?
+			   stmp_spi_txrx_pio(ss, cs, (void *)t->tx_buf,
+				   t->len, first, last, true) :
+			   stmp_spi_txrx_dma(ss, cs, (void *)t->tx_buf,
+				   t->tx_dma, t->len, first, last, true);
+#ifdef DEBUG
+			if (t->len < 0x10)
+				print_hex_dump_bytes("Tx ",
+					DUMP_PREFIX_OFFSET,
+					t->tx_buf, t->len);
+			else
+				pr_debug("Tx: %d bytes\n", t->len);
+#endif
+		}
+		if (t->rx_buf) {
+			status = pio ?
+			   stmp_spi_txrx_pio(ss, cs, t->rx_buf,
+				   t->len, first, last, false) :
+			   stmp_spi_txrx_dma(ss, cs, t->rx_buf,
+				   t->rx_dma, t->len, first, last, false);
+#ifdef DEBUG
+			if (t->len < 0x10)
+				print_hex_dump_bytes("Rx ",
+					DUMP_PREFIX_OFFSET,
+					t->rx_buf, t->len);
+			else
+				pr_debug("Rx: %d bytes\n", t->len);
+#endif
+		}
+
+		if (t->delay_usecs)
+			udelay(t->delay_usecs);
+
+		if (status)
+			break;
+
+	}
+	return status;
+}
+
+/**
+ * stmp_spi_handle - handle messages from the queue
+ */
+static void stmp_spi_handle(struct work_struct *w)
+{
+	struct stmp_spi *ss = container_of(w, struct stmp_spi, work);
+	unsigned long flags;
+	struct spi_message *m;
+
+	spin_lock_irqsave(&ss->lock, flags);
+	while (!list_empty(&ss->queue)) {
+		m = list_entry(ss->queue.next, struct spi_message, queue);
+		list_del_init(&m->queue);
+		spin_unlock_irqrestore(&ss->lock, flags);
+
+		m->status = stmp_spi_handle_message(ss, m);
+		m->complete(m->context);
+
+		spin_lock_irqsave(&ss->lock, flags);
+	}
+	spin_unlock_irqrestore(&ss->lock, flags);
+
+	return;
+}
+
+/**
+ * stmp_spi_transfer - perform message transfer.
+ * Called indirectly from spi_async, queues all the messages to
+ * spi_handle_message.
+ * @spi: spi device
+ * @m: message to be queued
+ */
+static int stmp_spi_transfer(struct spi_device *spi, struct spi_message *m)
+{
+	struct stmp_spi *ss = spi_master_get_devdata(spi->master);
+	unsigned long flags;
+
+	m->status = -EINPROGRESS;
+	spin_lock_irqsave(&ss->lock, flags);
+	list_add_tail(&m->queue, &ss->queue);
+	queue_work(ss->workqueue, &ss->work);
+	spin_unlock_irqrestore(&ss->lock, flags);
+	return 0;
+}
+
+static irqreturn_t stmp_spi_irq(int irq, void *dev_id)
+{
+	struct stmp_spi *ss = dev_id;
+
+	stmp3xxx_dma_clear_interrupt(ss->dma);
+	complete(&ss->done);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t stmp_spi_irq_err(int irq, void *dev_id)
+{
+	struct stmp_spi *ss = dev_id;
+	u32 c1, st;
+
+	c1 = readl(ss->regs + HW_SSP_CTRL1);
+	st = readl(ss->regs + HW_SSP_STATUS);
+	dev_err(ss->master_dev, "%s: status = 0x%08X, c1 = 0x%08X\n",
+		__func__, st, c1);
+	stmp3xxx_clearl(c1 & 0xCCCC0000, ss->regs + HW_SSP_CTRL1);
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit stmp_spi_probe(struct platform_device *dev)
+{
+	int err = 0;
+	struct spi_master *master;
+	struct stmp_spi *ss;
+	struct resource *r;
+
+	master = spi_alloc_master(&dev->dev, sizeof(struct stmp_spi));
+	if (master == NULL) {
+		err = -ENOMEM;
+		goto out0;
+	}
+	master->flags = SPI_MASTER_HALF_DUPLEX;
+
+	ss = spi_master_get_devdata(master);
+	platform_set_drvdata(dev, master);
+
+	/* Get resources(memory, IRQ) associated with the device */
+	r = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (r == NULL) {
+		err = -ENODEV;
+		goto out_put_master;
+	}
+	ss->regs = ioremap(r->start, resource_size(r));
+	if (!ss->regs) {
+		err = -EINVAL;
+		goto out_put_master;
+	}
+
+	ss->master_dev = &dev->dev;
+	ss->id = dev->id;
+
+	INIT_WORK(&ss->work, stmp_spi_handle);
+	INIT_LIST_HEAD(&ss->queue);
+	spin_lock_init(&ss->lock);
+
+	ss->workqueue = create_singlethread_workqueue(dev_name(&dev->dev));
+	if (!ss->workqueue) {
+		err = -ENXIO;
+		goto out_put_master;
+	}
+	master->transfer = stmp_spi_transfer;
+	master->setup = stmp_spi_setup;
+
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA;
+
+	ss->irq = platform_get_irq(dev, 0);
+	if (ss->irq < 0) {
+		err = ss->irq;
+		goto out_put_master;
+	}
+	ss->err_irq = platform_get_irq(dev, 1);
+	if (ss->err_irq < 0) {
+		err = ss->err_irq;
+		goto out_put_master;
+	}
+
+	r = platform_get_resource(dev, IORESOURCE_DMA, 0);
+	if (r == NULL) {
+		err = -ENODEV;
+		goto out_put_master;
+	}
+
+	ss->dma = r->start;
+	err = stmp3xxx_dma_request(ss->dma, &dev->dev, dev_name(&dev->dev));
+	if (err)
+		goto out_put_master;
+
+	err = stmp3xxx_dma_allocate_command(ss->dma, &ss->d);
+	if (err)
+		goto out_free_dma;
+
+	master->bus_num = dev->id;
+	master->num_chipselect = 1;
+
+	/* SPI controller initializations */
+	err = stmp_spi_init_hw(ss);
+	if (err) {
+		dev_dbg(&dev->dev, "cannot initialize hardware\n");
+		goto out_free_dma_desc;
+	}
+
+	if (clock) {
+		dev_info(&dev->dev, "clock rate forced to %d\n", clock);
+		clk_set_rate(ss->clk, clock);
+	}
+	ss->speed_khz = clk_get_rate(ss->clk);
+	ss->divider = 2;
+	dev_info(&dev->dev, "max possible speed %d = %ld/%d kHz\n",
+		ss->speed_khz, clk_get_rate(ss->clk), ss->divider);
+
+	/* Register for SPI interrupt */
+	err = request_irq(ss->irq, stmp_spi_irq, 0,
+			  dev_name(&dev->dev), ss);
+	if (err) {
+		dev_dbg(&dev->dev, "request_irq failed, %d\n", err);
+		goto out_release_hw;
+	}
+
+	/* ..and shared interrupt for all SSP controllers */
+	err = request_irq(ss->err_irq, stmp_spi_irq_err, IRQF_SHARED,
+			  dev_name(&dev->dev), ss);
+	if (err) {
+		dev_dbg(&dev->dev, "request_irq(error) failed, %d\n", err);
+		goto out_free_irq;
+	}
+
+	err = spi_register_master(master);
+	if (err) {
+		dev_dbg(&dev->dev, "cannot register spi master, %d\n", err);
+		goto out_free_irq_2;
+	}
+	dev_info(&dev->dev, "at (mapped) 0x%08X, irq=%d, bus %d, %s mode\n",
+			(u32)ss->regs, ss->irq, master->bus_num,
+			pio ? "PIO" : "DMA");
+	return 0;
+
+out_free_irq_2:
+	free_irq(ss->err_irq, ss);
+out_free_irq:
+	free_irq(ss->irq, ss);
+out_free_dma_desc:
+	stmp3xxx_dma_free_command(ss->dma, &ss->d);
+out_free_dma:
+	stmp3xxx_dma_release(ss->dma);
+out_release_hw:
+	stmp_spi_release_hw(ss);
+out_put_master:
+	if (ss->workqueue)
+		destroy_workqueue(ss->workqueue);
+	if (ss->regs)
+		iounmap(ss->regs);
+	platform_set_drvdata(dev, NULL);
+	spi_master_put(master);
+out0:
+	return err;
+}
+
+static int __devexit stmp_spi_remove(struct platform_device *dev)
+{
+	struct stmp_spi *ss;
+	struct spi_master *master;
+
+	master = platform_get_drvdata(dev);
+	if (master == NULL)
+		goto out0;
+	ss = spi_master_get_devdata(master);
+
+	spi_unregister_master(master);
+
+	free_irq(ss->err_irq, ss);
+	free_irq(ss->irq, ss);
+	stmp3xxx_dma_free_command(ss->dma, &ss->d);
+	stmp3xxx_dma_release(ss->dma);
+	stmp_spi_release_hw(ss);
+	destroy_workqueue(ss->workqueue);
+	iounmap(ss->regs);
+	spi_master_put(master);
+	platform_set_drvdata(dev, NULL);
+out0:
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int stmp_spi_suspend(struct platform_device *pdev, pm_message_t pmsg)
+{
+	struct stmp_spi *ss;
+	struct spi_master *master;
+
+	master = platform_get_drvdata(pdev);
+	ss = spi_master_get_devdata(master);
+
+	ss->saved_timings = readl(HW_SSP_TIMING + ss->regs);
+	clk_disable(ss->clk);
+
+	return 0;
+}
+
+static int stmp_spi_resume(struct platform_device *pdev)
+{
+	struct stmp_spi *ss;
+	struct spi_master *master;
+
+	master = platform_get_drvdata(pdev);
+	ss = spi_master_get_devdata(master);
+
+	clk_enable(ss->clk);
+	stmp3xxx_reset_block(ss->regs, false);
+	writel(ss->saved_timings, ss->regs + HW_SSP_TIMING);
+
+	return 0;
+}
+
+#else
+#define stmp_spi_suspend NULL
+#define stmp_spi_resume  NULL
+#endif
+
+static struct platform_driver stmp_spi_driver = {
+	.probe	= stmp_spi_probe,
+	.remove	= __devexit_p(stmp_spi_remove),
+	.driver = {
+		.name = "stmp3xxx_ssp",
+		.owner = THIS_MODULE,
+	},
+	.suspend = stmp_spi_suspend,
+	.resume  = stmp_spi_resume,
+};
+
+static int __init stmp_spi_init(void)
+{
+	return platform_driver_register(&stmp_spi_driver);
+}
+
+static void __exit stmp_spi_exit(void)
+{
+	platform_driver_unregister(&stmp_spi_driver);
+}
+
+module_init(stmp_spi_init);
+module_exit(stmp_spi_exit);
+module_param(pio, int, S_IRUGO);
+module_param(clock, int, S_IRUGO);
+MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com>");
+MODULE_DESCRIPTION("STMP3xxx SPI/SSP driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dpervushin@embeddedalley.com are

origin.patch
linux-next.patch

