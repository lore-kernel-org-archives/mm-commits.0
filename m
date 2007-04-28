From: akpm@linux-foundation.org
Subject: + mpc52xx-psc-spi-master-driver.patch added to -mm tree
Date: Sat, 28 Apr 2007 00:31:37 -0700
Message-ID: <200704280731.l3S7VbIJ017253@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161561AbXD1Hbx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 03:31:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dragos.carp@toptica.com, dbrownell@users.sourceforge.net


The patch titled
     MPC52xx PSC SPI master driver
has been added to the -mm tree.  Its filename is
     mpc52xx-psc-spi-master-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MPC52xx PSC SPI master driver
From: Dragos Carp <dragos.carp@toptica.com>

SPI master driver for MPC52xx using its Programmable Serial Controller.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Kconfig           |    7 
 drivers/spi/Makefile          |    1 
 drivers/spi/mpc52xx_psc_spi.c |  542 ++++++++++++++++++++++++++++++++
 3 files changed, 550 insertions(+)

diff -puN drivers/spi/Kconfig~mpc52xx-psc-spi-master-driver drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~mpc52xx-psc-spi-master-driver
+++ a/drivers/spi/Kconfig
@@ -89,6 +89,13 @@ config SPI_IMX
 	  This enables using the Freescale iMX SPI controller in master
 	  mode.
 
+config SPI_MPC52xx_PSC
+	tristate "Freescale MPC52xx PSC SPI controller"
+	depends on SPI_MASTER && PPC_MPC52xx && EXPERIMENTAL
+	help
+	  This enables using the Freescale MPC52xx Programmable Serial
+	  Controller in master SPI mode.
+
 config SPI_MPC83xx
 	tristate "Freescale MPC83xx SPI controller"
 	depends on SPI_MASTER && PPC_83xx && EXPERIMENTAL
diff -puN drivers/spi/Makefile~mpc52xx-psc-spi-master-driver drivers/spi/Makefile
--- a/drivers/spi/Makefile~mpc52xx-psc-spi-master-driver
+++ a/drivers/spi/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butt
 obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
 obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
 obj-$(CONFIG_SPI_OMAP_UWIRE)		+= omap_uwire.o
+obj-$(CONFIG_SPI_MPC52xx_PSC)		+= mpc52xx_psc_spi.o
 obj-$(CONFIG_SPI_MPC83xx)		+= spi_mpc83xx.o
 obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
 obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx.o
diff -puN /dev/null drivers/spi/mpc52xx_psc_spi.c
--- /dev/null
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -0,0 +1,542 @@
+/*
+ * MPC52xx SPC in SPI mode driver.
+ *
+ * Maintainer: Dragos Carp
+ *
+ * Copyright (C) 2006 TOPTICA Photonics AG.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/workqueue.h>
+#include <linux/completion.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/spi/spi.h>
+#include <linux/fsl_devices.h>
+
+#include <asm/mpc52xx.h>
+#include <asm/mpc52xx_psc.h>
+
+#define MCLK 20000000 /* PSC port MClk in hz */
+
+struct mpc52xx_psc_spi {
+	/* fsl_spi_platform data */
+	void (*activate_cs)(u8, u8);
+	void (*deactivate_cs)(u8, u8);
+	u32 sysclk;
+
+	/* driver internal data */
+	struct mpc52xx_psc __iomem *psc;
+	u8 bits_per_word;
+	u8 busy;
+
+	struct workqueue_struct *workqueue;
+	struct work_struct work;
+
+	struct list_head queue;
+	spinlock_t lock;
+
+	struct completion done;
+};
+
+/* controller state */
+struct mpc52xx_psc_spi_cs {
+	int bits_per_word;
+	int speed_hz;
+};
+
+/* set clock freq, clock ramp, bits per work
+ * if t is NULL then reset the values to the default values
+ */
+static int mpc52xx_psc_spi_transfer_setup(struct spi_device *spi,
+		struct spi_transfer *t)
+{
+	struct mpc52xx_psc_spi_cs *cs = spi->controller_state;
+
+	cs->speed_hz = (t && t->speed_hz)
+			? t->speed_hz : spi->max_speed_hz;
+	cs->bits_per_word = (t && t->bits_per_word)
+			? t->bits_per_word : spi->bits_per_word;
+	cs->bits_per_word = ((cs->bits_per_word + 7) / 8) * 8;
+	return 0;
+}
+
+static inline void mpc52xx_psc_spi_activate_cs(struct spi_device *spi)
+{
+	struct mpc52xx_psc_spi_cs *cs = spi->controller_state;
+	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
+	struct mpc52xx_psc __iomem *psc = mps->psc;
+	u32 sicr;
+	u16 ccr;
+
+	sicr = in_be32(&psc->sicr);
+
+	/* Set clock phase and polarity */
+	if (spi->mode & SPI_CPHA)
+		sicr |= 0x00001000;
+	else
+		sicr &= ~0x00001000;
+	if (spi->mode & SPI_CPOL)
+		sicr |= 0x00002000;
+	else
+		sicr &= ~0x00002000;
+
+	if (spi->mode & SPI_LSB_FIRST)
+		sicr |= 0x10000000;
+	else
+		sicr &= ~0x10000000;
+	out_be32(&psc->sicr, sicr);
+
+	/* Set clock frequency and bits per word
+	 * Because psc->ccr is defined as 16bit register instead of 32bit
+	 * just set the lower byte of BitClkDiv
+	 */
+	ccr = in_be16(&psc->ccr);
+	ccr &= 0xFF00;
+	if (cs->speed_hz)
+		ccr |= (MCLK / cs->speed_hz - 1) & 0xFF;
+	else /* by default SPI Clk 1MHz */
+		ccr |= (MCLK / 1000000 - 1) & 0xFF;
+	out_be16(&psc->ccr, ccr);
+	mps->bits_per_word = cs->bits_per_word;
+
+	if (mps->activate_cs)
+		mps->activate_cs(spi->chip_select,
+				(spi->mode & SPI_CS_HIGH) ? 1 : 0);
+}
+
+static inline void mpc52xx_psc_spi_deactivate_cs(struct spi_device *spi)
+{
+	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
+
+	if (mps->deactivate_cs)
+		mps->deactivate_cs(spi->chip_select,
+				(spi->mode & SPI_CS_HIGH) ? 1 : 0);
+}
+
+#define MPC52xx_PSC_BUFSIZE (MPC52xx_PSC_RFNUM_MASK + 1)
+/* wake up when 80% fifo full */
+#define MPC52xx_PSC_RFALARM (MPC52xx_PSC_BUFSIZE * 20 / 100)
+
+static inline int mpc52xx_psc_spi_transfer_rxtx(struct spi_device *spi,
+						struct spi_transfer *t)
+{
+	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
+	struct mpc52xx_psc __iomem *psc = mps->psc;
+	unsigned rb = 0;	/* number of bytes receieved */
+	unsigned sb = 0;	/* number of bytes sent */
+	unsigned char *rx_buf = (unsigned char *)t->rx_buf;
+	unsigned char *tx_buf = (unsigned char *)t->tx_buf;
+	unsigned rfalarm;
+	unsigned send_at_once = MPC52xx_PSC_BUFSIZE;
+	unsigned recv_at_once;
+	unsigned bpw = mps->bits_per_word / 8;
+
+	if (!t->tx_buf && !t->rx_buf && t->len)
+		return -EINVAL;
+
+	/* enable transmiter/receiver */
+	out_8(&psc->command, MPC52xx_PSC_TX_ENABLE | MPC52xx_PSC_RX_ENABLE);
+	while (rb < t->len) {
+		if (t->len - rb > MPC52xx_PSC_BUFSIZE) {
+			rfalarm = MPC52xx_PSC_RFALARM;
+		} else {
+			send_at_once = t->len - sb;
+			rfalarm = MPC52xx_PSC_BUFSIZE - (t->len - rb);
+		}
+
+		dev_dbg(&spi->dev, "send %d bytes...\n", send_at_once);
+		if (tx_buf) {
+			for (; send_at_once; sb++, send_at_once--) {
+				/* set EOF flag */
+				if (mps->bits_per_word
+						&& (sb + 1) % bpw == 0)
+					out_8(&psc->ircr2, 0x01);
+				out_8(&psc->mpc52xx_psc_buffer_8, tx_buf[sb]);
+			}
+		} else {
+			for (; send_at_once; sb++, send_at_once--) {
+				/* set EOF flag */
+				if (mps->bits_per_word
+						&& ((sb + 1) % bpw) == 0)
+					out_8(&psc->ircr2, 0x01);
+				out_8(&psc->mpc52xx_psc_buffer_8, 0);
+			}
+		}
+
+
+		/* enable interupts and wait for wake up
+		 * if just one byte is expected the Rx FIFO genererates no
+		 * FFULL interrupt, so activate the RxRDY interrupt
+		 */
+		out_8(&psc->command, MPC52xx_PSC_SEL_MODE_REG_1);
+		if (t->len - rb == 1) {
+			out_8(&psc->mode, 0);
+		} else {
+			out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
+			out_be16(&psc->rfalarm, rfalarm);
+		}
+		out_be16(&psc->mpc52xx_psc_imr, MPC52xx_PSC_IMR_RXRDY);
+		wait_for_completion(&mps->done);
+		recv_at_once = in_be16(&psc->rfnum);
+		dev_dbg(&spi->dev, "%d bytes received\n", recv_at_once);
+
+		send_at_once = recv_at_once;
+		if (rx_buf) {
+			for (; recv_at_once; rb++, recv_at_once--)
+				rx_buf[rb] = in_8(&psc->mpc52xx_psc_buffer_8);
+		} else {
+			for (; recv_at_once; rb++, recv_at_once--)
+				in_8(&psc->mpc52xx_psc_buffer_8);
+		}
+	}
+	/* disable transmiter/receiver */
+	out_8(&psc->command, MPC52xx_PSC_TX_DISABLE | MPC52xx_PSC_RX_DISABLE);
+
+	return 0;
+}
+
+static void mpc52xx_psc_spi_work(struct work_struct *work)
+{
+	struct mpc52xx_psc_spi *mps =
+		container_of(work, struct mpc52xx_psc_spi, work);
+
+	spin_lock_irq(&mps->lock);
+	mps->busy = 1;
+	while (!list_empty(&mps->queue)) {
+		struct spi_message *m;
+		struct spi_device *spi;
+		struct spi_transfer *t = NULL;
+		unsigned cs_change;
+		int status;
+
+		m = container_of(mps->queue.next, struct spi_message, queue);
+		list_del_init(&m->queue);
+		spin_unlock_irq(&mps->lock);
+
+		spi = m->spi;
+		cs_change = 1;
+		status = 0;
+		list_for_each_entry (t, &m->transfers, transfer_list) {
+			if (t->bits_per_word || t->speed_hz) {
+				status = mpc52xx_psc_spi_transfer_setup(spi, t);
+				if (status < 0)
+					break;
+			}
+
+			if (cs_change)
+				mpc52xx_psc_spi_activate_cs(spi);
+			cs_change = t->cs_change;
+
+			status = mpc52xx_psc_spi_transfer_rxtx(spi, t);
+			if (status)
+				break;
+			m->actual_length += t->len;
+
+			if (t->delay_usecs)
+				udelay(t->delay_usecs);
+
+			if (cs_change)
+				mpc52xx_psc_spi_deactivate_cs(spi);
+		}
+
+		m->status = status;
+		m->complete(m->context);
+
+		if (status || !cs_change)
+			mpc52xx_psc_spi_deactivate_cs(spi);
+
+		mpc52xx_psc_spi_transfer_setup(spi, NULL);
+
+		spin_lock_irq(&mps->lock);
+	}
+	mps->busy = 0;
+	spin_unlock_irq(&mps->lock);
+}
+
+static int mpc52xx_psc_spi_setup(struct spi_device *spi)
+{
+	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
+	struct mpc52xx_psc_spi_cs *cs = spi->controller_state;
+	unsigned long flags;
+
+	if (spi->bits_per_word%8)
+		return -EINVAL;
+
+	if (!cs) {
+		cs = kzalloc(sizeof *cs, GFP_KERNEL);
+		if (!cs)
+			return -ENOMEM;
+		spi->controller_state = cs;
+	}
+
+	cs->bits_per_word = spi->bits_per_word;
+	cs->speed_hz = spi->max_speed_hz;
+
+	spin_lock_irqsave(&mps->lock, flags);
+	if (!mps->busy)
+		mpc52xx_psc_spi_deactivate_cs(spi);
+	spin_unlock_irqrestore(&mps->lock, flags);
+
+	return 0;
+}
+
+static int mpc52xx_psc_spi_transfer(struct spi_device *spi,
+		struct spi_message *m)
+{
+	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
+	unsigned long flags;
+
+	m->actual_length = 0;
+	m->status = -EINPROGRESS;
+
+	spin_lock_irqsave(&mps->lock, flags);
+	list_add_tail(&m->queue, &mps->queue);
+	queue_work(mps->workqueue, &mps->work);
+	spin_unlock_irqrestore(&mps->lock, flags);
+
+	return 0;
+}
+
+static void mpc52xx_psc_spi_cleanup(struct spi_device *spi)
+{
+	if (spi->controller_state)
+		kfree(spi->controller_state);
+}
+
+static int mpc52xx_psc_spi_port_config(int psc_id, struct mpc52xx_psc_spi *mps)
+{
+	struct mpc52xx_cdm __iomem *cdm;
+	struct mpc52xx_gpio __iomem *gpio;
+	struct mpc52xx_psc __iomem *psc;
+	u32 ul;
+	u32 mclken_div;
+	int ret = 0;
+
+	cdm = ioremap(MPC52xx_PA(MPC52xx_CDM_OFFSET), MPC52xx_CDM_SIZE);
+	gpio = ioremap(MPC52xx_PA(MPC52xx_GPIO_OFFSET), MPC52xx_GPIO_SIZE);
+	if (!cdm || !gpio) {
+		printk(KERN_ERR "Error mapping CDM/GPIO\n");
+		ret = -EFAULT;
+		goto unmap_regs;
+	}
+
+	/* default sysclk is 512MHz */
+	mclken_div = 0x8000 |
+		(((mps->sysclk ? mps->sysclk : 512000000) / MCLK) & 0x1FF);
+
+	switch (psc_id) {
+	case 1:
+		ul = in_be32(&gpio->port_config);
+		ul &= 0xFFFFFFF8;
+		ul |= 0x00000006;
+		out_be32(&gpio->port_config, ul);
+		out_be16(&cdm->mclken_div_psc1, mclken_div);
+		ul = in_be32(&cdm->clk_enables);
+		ul |= 0x00000020;
+		out_be32(&cdm->clk_enables, ul);
+		break;
+	case 2:
+		ul = in_be32(&gpio->port_config);
+		ul &= 0xFFFFFF8F;
+		ul |= 0x00000060;
+		out_be32(&gpio->port_config, ul);
+		out_be16(&cdm->mclken_div_psc2, mclken_div);
+		ul = in_be32(&cdm->clk_enables);
+		ul |= 0x00000040;
+		out_be32(&cdm->clk_enables, ul);
+		break;
+	case 3:
+		ul = in_be32(&gpio->port_config);
+		ul &= 0xFFFFF0FF;
+		ul |= 0x00000600;
+		out_be32(&gpio->port_config, ul);
+		out_be16(&cdm->mclken_div_psc3, mclken_div);
+		ul = in_be32(&cdm->clk_enables);
+		ul |= 0x00000080;
+		out_be32(&cdm->clk_enables, ul);
+		break;
+	case 6:
+		ul = in_be32(&gpio->port_config);
+		ul &= 0xFF8FFFFF;
+		ul |= 0x00700000;
+		out_be32(&gpio->port_config, ul);
+		out_be16(&cdm->mclken_div_psc6, mclken_div);
+		ul = in_be32(&cdm->clk_enables);
+		ul |= 0x00000010;
+		out_be32(&cdm->clk_enables, ul);
+		break;
+	default:
+		ret = -EINVAL;
+		goto unmap_regs;
+	}
+	psc = ioremap(MPC52xx_PA(MPC52xx_PSCx_OFFSET(psc_id)),
+			MPC52xx_PSC_SIZE);
+	if (!psc) {
+		printk(KERN_ERR "Error mapping PSC%d\n", psc_id);
+		ret = -EFAULT;
+		goto unmap_regs;
+	}
+	mps->psc = psc;
+
+	/* Reset the PSC into a known state */
+	out_8(&psc->command, MPC52xx_PSC_RST_RX);
+	out_8(&psc->command, MPC52xx_PSC_RST_TX);
+	out_8(&psc->command, MPC52xx_PSC_TX_DISABLE | MPC52xx_PSC_RX_DISABLE);
+
+	/* Disable interrupts, interrupts are based on alarm level */
+	out_be16(&psc->mpc52xx_psc_imr, 0);
+	out_8(&psc->command, MPC52xx_PSC_SEL_MODE_REG_1);
+	out_8(&psc->rfcntl, 0);
+	out_8(&psc->mode, MPC52xx_PSC_MODE_FFULL);
+
+	/* Configure 8bit codec mode as an SPI master and use EOF flags */
+	/* SICR_SIM_CODEC8|SICR_GENCLK|SICR_SPI|SICR_MSTR|SICR_USEEOF */
+	out_be32(&psc->sicr, 0x0180C800);
+	out_be16(&psc->ccr, 0x070F); /* by default SPI Clk 1MHz */
+
+	/* Set 2ms DTL delay */
+	out_8(&psc->ctur, 0x00);
+	out_8(&psc->ctlr, 0x84);
+
+	mps->bits_per_word = 8;
+
+unmap_regs:
+	if (cdm)  iounmap(cdm);
+	if (gpio) iounmap(gpio);
+
+	return ret;
+}
+
+static irqreturn_t mpc52xx_psc_spi_isr(int irq, void *dev_id)
+{
+	struct mpc52xx_psc_spi *mps = (struct mpc52xx_psc_spi *)dev_id;
+	struct mpc52xx_psc __iomem *psc = mps->psc;
+
+	/* disable interrupt and wake up the work queue */
+	if (in_be16(&psc->mpc52xx_psc_isr) & MPC52xx_PSC_IMR_RXRDY) {
+		out_be16(&psc->mpc52xx_psc_imr, 0);
+		complete(&mps->done);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
+static int __init mpc52xx_psc_spi_probe(struct platform_device *dev)
+{
+	struct fsl_spi_platform_data *pdata = dev->dev.platform_data;
+	struct mpc52xx_psc_spi *mps;
+	struct spi_master *master;
+	unsigned int irq = platform_get_irq(dev, 0);
+	int ret;
+
+	if (pdata == NULL)
+		return -ENODEV;
+
+	master = spi_alloc_master(&dev->dev, sizeof *mps);
+	if (master == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(dev, master);
+
+	mps = spi_master_get_devdata(master);
+	mps->activate_cs = pdata->activate_cs;
+	mps->deactivate_cs = pdata->deactivate_cs;
+	mps->sysclk = pdata->sysclk;
+
+	master->bus_num = dev->id = pdata->bus_num;
+	master->num_chipselect = pdata->max_chipselect;
+	master->setup = mpc52xx_psc_spi_setup;
+	master->transfer = mpc52xx_psc_spi_transfer;
+	master->cleanup = mpc52xx_psc_spi_cleanup;
+
+	ret = mpc52xx_psc_spi_port_config(dev->id, mps);
+	if (ret < 0)
+		goto free_master;
+
+	ret = request_irq(irq, mpc52xx_psc_spi_isr, 0, "mpc52xx_psc_spi", mps);
+	if (ret)
+		goto free_master;
+
+	spin_lock_init(&mps->lock);
+	init_completion(&mps->done);
+	INIT_WORK(&mps->work, mpc52xx_psc_spi_work);
+	INIT_LIST_HEAD(&mps->queue);
+
+	mps->workqueue = create_singlethread_workqueue(
+		master->cdev.dev->bus_id);
+	if (mps->workqueue == NULL) {
+		ret = -EBUSY;
+		goto err_workq;
+	}
+
+	ret = spi_register_master(master);
+	if (ret < 0)
+		goto unreg_master;
+
+	return ret;
+
+unreg_master:
+	destroy_workqueue(mps->workqueue);
+err_workq:
+	free_irq(irq, mps);
+free_master:
+	if (mps->psc)  iounmap(mps->psc);
+	spi_master_put(master);
+
+	return ret;
+}
+
+static int __exit mpc52xx_psc_spi_remove(struct platform_device *dev)
+{
+	struct spi_master *master = platform_get_drvdata(dev);
+	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(master);
+	unsigned int irq = platform_get_irq(dev, 0);
+
+	flush_workqueue(mps->workqueue);
+	destroy_workqueue(mps->workqueue);
+	spi_unregister_master(master);
+	free_irq(irq, mps);
+	if (mps->psc)  iounmap(mps->psc);
+
+	return 0;
+}
+
+static struct platform_driver mpc52xx_psc_spi_platform_driver = {
+	.remove = __exit_p(mpc52xx_psc_spi_remove),
+	.driver = {
+		.name = "mpc52xx_psc_spi",
+		.owner = THIS_MODULE,
+	},
+};
+
+
+/* ======================================================================== */
+/* Module                                                                   */
+/* ======================================================================== */
+
+static int __init mpc52xx_psc_spi_init(void)
+{
+	return platform_driver_probe(&mpc52xx_psc_spi_platform_driver,
+			mpc52xx_psc_spi_probe);
+}
+module_init(mpc52xx_psc_spi_init);
+
+static void __exit mpc52xx_psc_spi_exit(void)
+{
+	platform_driver_unregister(&mpc52xx_psc_spi_platform_driver);
+}
+module_exit(mpc52xx_psc_spi_exit);
+
+MODULE_AUTHOR("Dragos Carp");
+MODULE_DESCRIPTION("MPC52xx PSC SPI Driver");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from dragos.carp@toptica.com are

mpc52xx-psc-spi-master-driver.patch
mpc52xx-psc-spi-master-driver-update.patch
