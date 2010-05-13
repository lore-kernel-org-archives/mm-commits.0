From: akpm@linux-foundation.org
Subject: [to-be-updated] mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch removed from -mm tree
Date: Thu, 13 May 2010 15:03:04 -0700
Message-ID: <201005132203.o4DM34Ut023104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab0EMWEH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 May 2010 18:04:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, dan.j.williams@intel.com, ian@mnementh.co.uk, lethal@linux-sh.org, magnus.damm@gmail.com, rmk@arm.linux.org.uk, sameo@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     mmc: add DMA support to tmio_mmc driver, when used on SuperH
has been removed from the -mm tree.  Its filename was
     mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: add DMA support to tmio_mmc driver, when used on SuperH
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

SDHI controllers on SuperH, served by the tmio_mmc driver, can use slave
DMA for data transfer.  This patch adds support for the dmaengine API to
the tmio_mmc driver.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |  341 ++++++++++++++++++++++++++++++----
 drivers/mmc/host/tmio_mmc.h |   11 +
 2 files changed, 320 insertions(+), 32 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.c~mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -29,12 +29,21 @@
 #include <linux/irq.h>
 #include <linux/device.h>
 #include <linux/delay.h>
+#include <linux/dmaengine.h>
 #include <linux/mmc/host.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tmio.h>
 
 #include "tmio_mmc.h"
 
+static void tmio_mmc_enable_dma(struct tmio_mmc_host *host, bool enable)
+{
+#if defined(CONFIG_SUPERH) || defined(CONFIG_ARCH_SHMOBILE)
+	/* Switch DMA mode on or off - SuperH specific? */
+	sd_ctrl_write16(host, 0xd8, enable ? 2 : 0);
+#endif
+}
+
 static void tmio_mmc_set_clock(struct tmio_mmc_host *host, int new_clock)
 {
 	u32 clk = 0, clock;
@@ -131,8 +140,8 @@ tmio_mmc_start_command(struct tmio_mmc_h
 
 	host->cmd = cmd;
 
-/* FIXME - this seems to be ok comented out but the spec suggest this bit should
- *         be set when issuing app commands.
+/* FIXME - this seems to be ok commented out but the spec suggest this bit
+ *         should be set when issuing app commands.
  *	if(cmd->flags & MMC_FLAG_ACMD)
  *		c |= APP_CMD;
  */
@@ -155,12 +164,12 @@ tmio_mmc_start_command(struct tmio_mmc_h
 	return 0;
 }
 
-/* This chip always returns (at least?) as much data as you ask for.
+/*
+ * This chip always returns (at least?) as much data as you ask for.
  * I'm unsure what happens if you ask for less than a block. This should be
  * looked into to ensure that a funny length read doesnt hose the controller.
- *
  */
-static inline void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
+static void tmio_mmc_pio_irq(struct tmio_mmc_host *host)
 {
 	struct mmc_data *data = host->data;
 	unsigned short *buf;
@@ -180,7 +189,7 @@ static inline void tmio_mmc_pio_irq(stru
 		count = data->blksz;
 
 	pr_debug("count: %08x offset: %08x flags %08x\n",
-	    count, host->sg_off, data->flags);
+		 count, host->sg_off, data->flags);
 
 	/* Transfer the data */
 	if (data->flags & MMC_DATA_READ)
@@ -198,15 +207,13 @@ static inline void tmio_mmc_pio_irq(stru
 	return;
 }
 
-static inline void tmio_mmc_data_irq(struct tmio_mmc_host *host)
+static void tmio_mmc_data_irq(struct tmio_mmc_host *host)
 {
 	struct mmc_data *data = host->data;
 	struct mmc_command *stop;
 
-	host->data = NULL;
-
 	if (!data) {
-		pr_debug("Spurious data end IRQ\n");
+		dev_warn(&host->pdev->dev, "Spurious data end IRQ\n");
 		return;
 	}
 	stop = data->stop;
@@ -227,10 +234,17 @@ static inline void tmio_mmc_data_irq(str
 	 *        upper layers expect. For now, we do what works.
 	 */
 
-	if (data->flags & MMC_DATA_READ)
-		disable_mmc_irqs(host, TMIO_MASK_READOP);
-	else
-		disable_mmc_irqs(host, TMIO_MASK_WRITEOP);
+	if (data->flags & MMC_DATA_READ) {
+		if (!host->chan_rx)
+			disable_mmc_irqs(host, TMIO_MASK_READOP);
+		dev_dbg(&host->pdev->dev, "Complete Rx cookie %d, request %p\n",
+			host->cookie, host->mrq);
+	} else {
+		if (!host->chan_tx)
+			disable_mmc_irqs(host, TMIO_MASK_WRITEOP);
+		dev_dbg(&host->pdev->dev, "Complete Tx cookie %d, request %p\n",
+			host->cookie, host->mrq);
+	}
 
 	if (stop) {
 		if (stop->opcode == 12 && !stop->arg)
@@ -242,7 +256,35 @@ static inline void tmio_mmc_data_irq(str
 	tmio_mmc_finish_request(host);
 }
 
-static inline void tmio_mmc_cmd_irq(struct tmio_mmc_host *host,
+static void tmio_mmc_isr_data_irq(struct tmio_mmc_host *host)
+{
+	struct mmc_data *data = host->data;
+
+	if (!data)
+		return;
+
+	if ((data->flags & MMC_DATA_WRITE) && host->chan_tx) {
+		/*
+		 * Has all data been written out yet? Testing on SuperH showed,
+		 * that in most cases the first interrupt comes already with the
+		 * BUSY status bit clear, but on some operations, like mount or
+		 * in the beginning of a write / sync / umount, there is one
+		 * DATAEND interrupt with the BUSY bit set, in this cases
+		 * waiting for one more interrupt fixes the problem.
+		 */
+		if (!(sd_ctrl_read32(host, CTL_STATUS) & TMIO_STAT_CMD_BUSY)) {
+			disable_mmc_irqs(host, TMIO_STAT_DATAEND);
+			tasklet_schedule(&host->dma_complete);
+		}
+	} else if ((data->flags & MMC_DATA_READ) && host->chan_rx) {
+		disable_mmc_irqs(host, TMIO_STAT_DATAEND);
+		tasklet_schedule(&host->dma_complete);
+	} else {
+		tmio_mmc_data_irq(host);
+	}
+}
+
+static void tmio_mmc_cmd_irq(struct tmio_mmc_host *host,
 	unsigned int stat)
 {
 	struct mmc_command *cmd = host->cmd;
@@ -282,10 +324,16 @@ static inline void tmio_mmc_cmd_irq(stru
 	 * If theres no data or we encountered an error, finish now.
 	 */
 	if (host->data && !cmd->error) {
-		if (host->data->flags & MMC_DATA_READ)
-			enable_mmc_irqs(host, TMIO_MASK_READOP);
-		else
-			enable_mmc_irqs(host, TMIO_MASK_WRITEOP);
+		if (host->data->flags & MMC_DATA_READ) {
+			if (!host->chan_rx)
+				enable_mmc_irqs(host, TMIO_MASK_READOP);
+		} else {
+			struct dma_chan *chan = host->chan_tx;
+			if (!chan)
+				enable_mmc_irqs(host, TMIO_MASK_WRITEOP);
+			else
+				tasklet_schedule(&host->dma_issue);
+		}
 	} else {
 		tmio_mmc_finish_request(host);
 	}
@@ -293,7 +341,6 @@ static inline void tmio_mmc_cmd_irq(stru
 	return;
 }
 
-
 static irqreturn_t tmio_mmc_irq(int irq, void *devid)
 {
 	struct tmio_mmc_host *host = devid;
@@ -311,7 +358,7 @@ static irqreturn_t tmio_mmc_irq(int irq,
 	if (!ireg) {
 		disable_mmc_irqs(host, status & ~irq_mask);
 
-		pr_debug("tmio_mmc: Spurious irq, disabling! "
+		pr_warning("tmio_mmc: Spurious irq, disabling! "
 			"0x%08x 0x%08x 0x%08x\n", status, irq_mask, ireg);
 		pr_debug_status(status);
 
@@ -346,7 +393,7 @@ static irqreturn_t tmio_mmc_irq(int irq,
 		/* Data transfer completion */
 		if (ireg & TMIO_STAT_DATAEND) {
 			ack_mmc_irqs(host, TMIO_STAT_DATAEND);
-			tmio_mmc_data_irq(host);
+			tmio_mmc_isr_data_irq(host);
 		}
 
 		/* Check status - keep going until we've handled it all */
@@ -363,16 +410,152 @@ out:
 	return IRQ_HANDLED;
 }
 
+static void tmio_dma_complete(void *arg)
+{
+	struct tmio_mmc_host *host = arg;
+
+	dev_dbg(&host->pdev->dev, "Command completed\n");
+
+	if (!host->data)
+		dev_warn(&host->pdev->dev, "NULL data in DMA completion!\n");
+	else
+		enable_mmc_irqs(host, TMIO_STAT_DATAEND);
+}
+
+static int tmio_mmc_start_dma_rx(struct tmio_mmc_host *host)
+{
+	struct scatterlist *sg = host->sg_ptr;
+	struct dma_async_tx_descriptor *desc = NULL;
+	struct dma_chan *chan = host->chan_rx;
+	int ret;
+
+	ret = dma_map_sg(&host->pdev->dev, sg, host->sg_len, DMA_FROM_DEVICE);
+	if (ret > 0) {
+		host->dma_sglen = ret;
+		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
+			DMA_FROM_DEVICE, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	}
+
+	if (desc) {
+		host->desc = desc;
+		desc->callback = tmio_dma_complete;
+		desc->callback_param = host;
+		host->cookie = desc->tx_submit(desc);
+		if (host->cookie < 0) {
+			host->desc = NULL;
+			ret = host->cookie;
+		} else {
+			chan->device->device_issue_pending(chan);
+		}
+	}
+	dev_dbg(&host->pdev->dev, "%s(): mapped %d -> %d, cookie %d, rq %p\n",
+		__func__, host->sg_len, ret, host->cookie, host->mrq);
+
+	if (!host->desc) {
+		/* DMA failed, fall back to PIO */
+		if (ret >= 0)
+			ret = -EIO;
+		host->chan_rx = NULL;
+		dma_release_channel(chan);
+		/* Free the Tx channel too */
+		chan = host->chan_tx;
+		if (chan) {
+			host->chan_tx = NULL;
+			dma_release_channel(chan);
+		}
+		dev_warn(&host->pdev->dev,
+			 "DMA failed: %d, falling back to PIO\n", ret);
+		tmio_mmc_enable_dma(host, false);
+		reset(host);
+		/* Fail this request, let above layers recover */
+		host->mrq->cmd->error = ret;
+		tmio_mmc_finish_request(host);
+	}
+
+	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d, sg[%d]\n", __func__,
+		desc, host->cookie, host->sg_len);
+
+	return ret > 0 ? 0 : ret;
+}
+
+static int tmio_mmc_start_dma_tx(struct tmio_mmc_host *host)
+{
+	struct scatterlist *sg = host->sg_ptr;
+	struct dma_async_tx_descriptor *desc = NULL;
+	struct dma_chan *chan = host->chan_tx;
+	int ret;
+
+	ret = dma_map_sg(&host->pdev->dev, sg, host->sg_len, DMA_TO_DEVICE);
+	if (ret > 0) {
+		host->dma_sglen = ret;
+		desc = chan->device->device_prep_slave_sg(chan, sg, ret,
+			DMA_TO_DEVICE, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+	}
+
+	if (desc) {
+		host->desc = desc;
+		desc->callback = tmio_dma_complete;
+		desc->callback_param = host;
+		host->cookie = desc->tx_submit(desc);
+		if (host->cookie < 0) {
+			host->desc = NULL;
+			ret = host->cookie;
+		}
+	}
+	dev_dbg(&host->pdev->dev, "%s(): mapped %d -> %d, cookie %d, rq %p\n",
+		__func__, host->sg_len, ret, host->cookie, host->mrq);
+
+	if (!host->desc) {
+		/* DMA failed, fall back to PIO */
+		if (ret >= 0)
+			ret = -EIO;
+		host->chan_tx = NULL;
+		dma_release_channel(chan);
+		/* Free the Rx channel too */
+		chan = host->chan_rx;
+		if (chan) {
+			host->chan_rx = NULL;
+			dma_release_channel(chan);
+		}
+		dev_warn(&host->pdev->dev,
+			 "DMA failed: %d, falling back to PIO\n", ret);
+		tmio_mmc_enable_dma(host, false);
+		reset(host);
+		/* Fail this request, let above layers recover */
+		host->mrq->cmd->error = ret;
+		tmio_mmc_finish_request(host);
+	}
+
+	dev_dbg(&host->pdev->dev, "%s(): desc %p, cookie %d\n", __func__,
+		desc, host->cookie);
+
+	return ret > 0 ? 0 : ret;
+}
+
+static int tmio_mmc_start_dma(struct tmio_mmc_host *host,
+			       struct mmc_data *data)
+{
+	if (data->flags & MMC_DATA_READ) {
+		if (host->chan_rx)
+			return tmio_mmc_start_dma_rx(host);
+	} else {
+		if (host->chan_tx)
+			return tmio_mmc_start_dma_tx(host);
+	}
+
+	return 0;
+}
+
 static int tmio_mmc_start_data(struct tmio_mmc_host *host,
 	struct mmc_data *data)
 {
 	pr_debug("setup data transfer: blocksize %08x  nr_blocks %d\n",
-	    data->blksz, data->blocks);
+		 data->blksz, data->blocks);
 
 	/* Hardware cannot perform 1 and 2 byte requests in 4 bit mode */
 	if (data->blksz < 4 && host->mmc->ios.bus_width == MMC_BUS_WIDTH_4) {
-		printk(KERN_ERR "%s: %d byte block unsupported in 4 bit mode\n",
-			mmc_hostname(host->mmc), data->blksz);
+		pr_err("%s: %d byte block unsupported in 4 bit mode\n",
+		       mmc_hostname(host->mmc), data->blksz);
 		return -EINVAL;
 	}
 
@@ -383,7 +566,7 @@ static int tmio_mmc_start_data(struct tm
 	sd_ctrl_write16(host, CTL_SD_XFER_LEN, data->blksz);
 	sd_ctrl_write16(host, CTL_XFER_BLK_COUNT, data->blocks);
 
-	return 0;
+	return tmio_mmc_start_dma(host, data);
 }
 
 /* Process requests from the MMC layer */
@@ -404,7 +587,6 @@ static void tmio_mmc_request(struct mmc_
 	}
 
 	ret = tmio_mmc_start_command(host, mrq->cmd);
-
 	if (!ret)
 		return;
 
@@ -459,10 +641,10 @@ static int tmio_mmc_get_ro(struct mmc_ho
 {
 	struct tmio_mmc_host *host = mmc_priv(mmc);
 
-	return (sd_ctrl_read16(host, CTL_STATUS) & TMIO_STAT_WRPROTECT) ? 0 : 1;
+	return (sd_ctrl_read32(host, CTL_STATUS) & TMIO_STAT_WRPROTECT) ? 0 : 1;
 }
 
-static struct mmc_host_ops tmio_mmc_ops = {
+static const struct mmc_host_ops tmio_mmc_ops = {
 	.request	= tmio_mmc_request,
 	.set_ios	= tmio_mmc_set_ios,
 	.get_ro         = tmio_mmc_get_ro,
@@ -507,6 +689,92 @@ out:
 #define tmio_mmc_resume NULL
 #endif
 
+static void tmio_issue_tasklet_fn(unsigned long priv)
+{
+	struct tmio_mmc_host *host = (struct tmio_mmc_host *)priv;
+	struct dma_chan *chan = host->chan_tx;
+
+	chan->device->device_issue_pending(chan);
+}
+
+static void tmio_tasklet_fn(unsigned long arg)
+{
+	struct tmio_mmc_host *host = (struct tmio_mmc_host *)arg;
+
+	if (host->data->flags & MMC_DATA_READ)
+		dma_unmap_sg(&host->pdev->dev, host->sg_ptr, host->dma_sglen,
+			     DMA_FROM_DEVICE);
+	else
+		dma_unmap_sg(&host->pdev->dev, host->sg_ptr, host->dma_sglen,
+			     DMA_TO_DEVICE);
+
+	tmio_mmc_data_irq(host);
+}
+
+/* It might be necessary to make filter MFD specific */
+static bool filter(struct dma_chan *chan, void *arg)
+{
+	dev_dbg(chan->device->dev, "%s: slave data %p\n", __func__, arg);
+	chan->private = arg;
+	return true;
+}
+
+static void tmio_mmc_request_dma(struct tmio_mmc_host *host,
+				 struct tmio_mmc_data *pdata)
+{
+	host->cookie = -EINVAL;
+	host->desc = NULL;
+
+	/* We can only either use DMA for both Tx and Rx or not use it at all */
+	if (pdata->dma) {
+		dma_cap_mask_t mask;
+
+		dma_cap_zero(mask);
+		dma_cap_set(DMA_SLAVE, mask);
+
+		host->chan_tx = dma_request_channel(mask, filter,
+						    pdata->dma->chan_priv_tx);
+		dev_dbg(&host->pdev->dev, "%s: TX: got channel %p\n", __func__,
+			host->chan_tx);
+
+		if (!host->chan_tx)
+			return;
+
+		host->chan_rx = dma_request_channel(mask, filter,
+						    pdata->dma->chan_priv_rx);
+		dev_dbg(&host->pdev->dev, "%s: RX: got channel %p\n", __func__,
+			host->chan_rx);
+
+		if (!host->chan_rx) {
+			dma_release_channel(host->chan_tx);
+			host->chan_tx = NULL;
+			return;
+		}
+
+		tasklet_init(&host->dma_complete, tmio_tasklet_fn, (unsigned long)host);
+		tasklet_init(&host->dma_issue, tmio_issue_tasklet_fn, (unsigned long)host);
+
+		tmio_mmc_enable_dma(host, true);
+	}
+}
+
+static void tmio_mmc_release_dma(struct tmio_mmc_host *host)
+{
+	if (host->chan_tx) {
+		struct dma_chan *chan = host->chan_tx;
+		host->chan_tx = NULL;
+		dma_release_channel(chan);
+	}
+	if (host->chan_rx) {
+		struct dma_chan *chan = host->chan_rx;
+		host->chan_rx = NULL;
+		dma_release_channel(chan);
+	}
+
+	host->cookie = -EINVAL;
+	host->desc = NULL;
+}
+
 static int __devinit tmio_mmc_probe(struct platform_device *dev)
 {
 	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
@@ -515,6 +783,7 @@ static int __devinit tmio_mmc_probe(stru
 	struct tmio_mmc_host *host;
 	struct mmc_host *mmc;
 	int ret = -EINVAL;
+	u32 irq_mask = TMIO_MASK_CMD;
 
 	if (dev->num_resources != 2)
 		goto out;
@@ -578,13 +847,20 @@ static int __devinit tmio_mmc_probe(stru
 	if (ret)
 		goto cell_disable;
 
+	/* See if we also get DMA */
+	tmio_mmc_request_dma(host, pdata);
+
 	mmc_add_host(mmc);
 
-	printk(KERN_INFO "%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
-	       (unsigned long)host->ctl, host->irq);
+	pr_info("%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
+		(unsigned long)host->ctl, host->irq);
 
 	/* Unmask the IRQs we want to know about */
-	enable_mmc_irqs(host, TMIO_MASK_IRQ);
+	if (!host->chan_rx)
+		irq_mask |= TMIO_MASK_READOP;
+	if (!host->chan_tx)
+		irq_mask |= TMIO_MASK_WRITEOP;
+	enable_mmc_irqs(host, irq_mask);
 
 	return 0;
 
@@ -609,6 +885,7 @@ static int __devexit tmio_mmc_remove(str
 	if (mmc) {
 		struct tmio_mmc_host *host = mmc_priv(mmc);
 		mmc_remove_host(mmc);
+		tmio_mmc_release_dma(host);
 		free_irq(host->irq, host);
 		if (cell->disable)
 			cell->disable(dev);
diff -puN drivers/mmc/host/tmio_mmc.h~mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh drivers/mmc/host/tmio_mmc.h
--- a/drivers/mmc/host/tmio_mmc.h~mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh
+++ a/drivers/mmc/host/tmio_mmc.h
@@ -10,6 +10,8 @@
  */
 
 #include <linux/highmem.h>
+#include <linux/interrupt.h>
+#include <linux/dmaengine.h>
 
 #define CTL_SD_CMD 0x00
 #define CTL_ARG_REG 0x04
@@ -106,6 +108,15 @@ struct tmio_mmc_host {
 	unsigned int            sg_off;
 
 	struct platform_device *pdev;
+
+	/* DMA support */
+	struct dma_chan		*chan_rx;
+	struct dma_chan		*chan_tx;
+	struct dma_async_tx_descriptor *desc;
+	unsigned int            dma_sglen;
+	struct tasklet_struct	dma_complete;
+	struct tasklet_struct	dma_issue;
+	dma_cookie_t		cookie;
 };
 
 #include <linux/io.h>
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
sh-define-dma-slaves-per-cpu-type-remove-now-redundant-header.patch
sh-add-dma-slaves-for-two-sdhi-controllers-to-sh7722.patch
sh-add-dma-slave-definitions-to-sh7724.patch
mmc-prepare-tmio_mmc-for-passing-of-dma-configuration-from-the-mfd-cell.patch
mmc-add-dma-support-to-tmio_mmc-driver-when-used-on-superh.patch
sh-add-sdhi-dma-support-to-ecovec.patch
sh-add-sdhi-dma-support-to-ms7724se.patch
sh-add-sdhi-dma-support-to-kfr2r09.patch
sh-add-sdhi-dma-support-to-migor.patch
arm-add-dma-support-to-sh7372-enable-dma-for-sdhi.patch
sh-prepare-the-sdhi-mfd-driver-to-pass-dma-configuration-to-tmio_mmcc.patch

