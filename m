From: akpm@linux-foundation.org
Subject: + mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver.patch added to -mm tree
Date: Fri, 20 Nov 2009 16:10:51 -0800
Message-ID: <200911210010.nAL0AqHE005969__29791.7342315943$1258762269$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718AbZKUAKw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 19:10:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, haavard.skinnemoen@atmel.com, linux-mmc@vger.kernel.org


The patch titled
     mmc: atmel-mci: new MCI2 module support in atmel-mci driver
has been added to the -mm tree.  Its filename is
     mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver.patch

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
Subject: mmc: atmel-mci: new MCI2 module support in atmel-mci driver
From: Nicolas Ferre <nicolas.ferre@atmel.com>

This new revision of the IP adds some improvements to the MCI already
present in several Atmel SOC.

Some new registers are added and a particular way of handling DMA
interaction lead to a new sequence in function call which is backward
compatible: On MCI2, we must set the DMAEN bit to enable the DMA
handshaking interface.  This must happen before the data transfer command
is sent.

A new function is able to differentiate MCI2 code and is based on
knowledge of processor id (cpu_is_xxx()).

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/atmel-mci.c |   85 +++++++++++++++++++++++++++++----
 1 file changed, 75 insertions(+), 10 deletions(-)

diff -puN drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver drivers/mmc/host/atmel-mci.c
--- a/drivers/mmc/host/atmel-mci.c~mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver
+++ a/drivers/mmc/host/atmel-mci.c
@@ -94,6 +94,7 @@ struct atmel_mci_dma {
  * @need_clock_update: Update the clock rate before the next request.
  * @need_reset: Reset controller before next request.
  * @mode_reg: Value of the MR register.
+ * @cfg_reg: Value of the CFG register.
  * @bus_hz: The rate of @mck in Hz. This forms the basis for MMC bus
  *	rate and timeout calculations.
  * @mapbase: Physical address of the MMIO registers.
@@ -157,6 +158,7 @@ struct atmel_mci {
 	bool			need_clock_update;
 	bool			need_reset;
 	u32			mode_reg;
+	u32			cfg_reg;
 	unsigned long		bus_hz;
 	unsigned long		mapbase;
 	struct clk		*mck;
@@ -225,6 +227,19 @@ static bool mci_has_rwproof(void)
 }
 
 /*
+ * The new MCI2 module isn't 100% compatible with the old MCI module,
+ * and it has a few nice features which we want to use...
+ */
+static inline bool atmci_is_mci2(void)
+{
+	if (cpu_is_at91sam9g45())
+		return true;
+
+	return false;
+}
+
+
+/*
  * The debugfs stuff below is mostly optimized away when
  * CONFIG_DEBUG_FS is not set.
  */
@@ -359,12 +374,33 @@ static int atmci_regs_show(struct seq_fi
 			buf[MCI_BLKR / 4],
 			buf[MCI_BLKR / 4] & 0xffff,
 			(buf[MCI_BLKR / 4] >> 16) & 0xffff);
+	if (atmci_is_mci2())
+		seq_printf(s, "CSTOR:\t0x%08x\n", buf[MCI_CSTOR / 4]);
 
 	/* Don't read RSPR and RDR; it will consume the data there */
 
 	atmci_show_status_reg(s, "SR", buf[MCI_SR / 4]);
 	atmci_show_status_reg(s, "IMR", buf[MCI_IMR / 4]);
 
+	if (atmci_is_mci2()) {
+		u32 val;
+
+		val = buf[MCI_DMA / 4];
+		seq_printf(s, "DMA:\t0x%08x OFFSET=%u CHKSIZE=%u%s\n",
+				val, val & 3,
+				((val >> 4) & 3) ?
+					1 << (((val >> 4) & 3) + 1) : 1,
+				val & MCI_DMAEN ? " DMAEN" : "");
+
+		val = buf[MCI_CFG / 4];
+		seq_printf(s, "CFG:\t0x%08x%s%s%s%s\n",
+				val,
+				val & MCI_CFG_FIFOMODE_1DATA ? " FIFOMODE_ONE_DATA" : "",
+				val & MCI_CFG_FERRCTRL_COR ? " FERRCTRL_CLEAR_ON_READ" : "",
+				val & MCI_CFG_HSMODE ? " HSMODE" : "",
+				val & MCI_CFG_LSYNC ? " LSYNC" : "");
+	}
+
 	kfree(buf);
 
 	return 0;
@@ -559,6 +595,10 @@ static void atmci_dma_complete(void *arg
 
 	dev_vdbg(&host->pdev->dev, "DMA complete\n");
 
+	if (atmci_is_mci2())
+		/* Disable DMA hardware handshaking on MCI */
+		mci_writel(host, DMA, mci_readl(host, DMA) & ~MCI_DMAEN);
+
 	atmci_dma_cleanup(host);
 
 	/*
@@ -594,7 +634,7 @@ static void atmci_dma_complete(void *arg
 }
 
 static int
-atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
+atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
 {
 	struct dma_chan			*chan;
 	struct dma_async_tx_descriptor	*desc;
@@ -626,6 +666,9 @@ atmci_submit_data_dma(struct atmel_mci *
 	if (!chan)
 		return -ENODEV;
 
+	if (atmci_is_mci2())
+		mci_writel(host, DMA, MCI_DMA_CHKSIZE(3) | MCI_DMAEN);
+
 	if (data->flags & MMC_DATA_READ)
 		direction = DMA_FROM_DEVICE;
 	else
@@ -643,10 +686,6 @@ atmci_submit_data_dma(struct atmel_mci *
 	host->dma.data_desc = desc;
 	desc->callback = atmci_dma_complete;
 	desc->callback_param = host;
-	desc->tx_submit(desc);
-
-	/* Go! */
-	chan->device->device_issue_pending(chan);
 
 	return 0;
 unmap_exit:
@@ -654,13 +693,26 @@ unmap_exit:
 	return -ENOMEM;
 }
 
+static void atmci_submit_data(struct atmel_mci *host)
+{
+	struct dma_chan			*chan = host->data_chan;
+	struct dma_async_tx_descriptor	*desc = host->dma.data_desc;
+
+	if (chan) {
+		desc->tx_submit(desc);
+		chan->device->device_issue_pending(chan);
+	}
+}
+
 #else /* CONFIG_MMC_ATMELMCI_DMA */
 
-static int atmci_submit_data_dma(struct atmel_mci *host, struct mmc_data *data)
+static int atmci_prepare_data_dma(struct atmel_mci *host, struct mmc_data *data)
 {
 	return -ENOSYS;
 }
 
+static void atmci_submit_data(struct atmel_mci *host) {}
+
 static void atmci_stop_dma(struct atmel_mci *host)
 {
 	/* Data transfer was stopped by the interrupt handler */
@@ -674,7 +726,7 @@ static void atmci_stop_dma(struct atmel_
  * Returns a mask of interrupt flags to be enabled after the whole
  * request has been prepared.
  */
-static u32 atmci_submit_data(struct atmel_mci *host, struct mmc_data *data)
+static u32 atmci_prepare_data(struct atmel_mci *host, struct mmc_data *data)
 {
 	u32 iflags;
 
@@ -685,7 +737,7 @@ static u32 atmci_submit_data(struct atme
 	host->data = data;
 
 	iflags = ATMCI_DATA_ERROR_FLAGS;
-	if (atmci_submit_data_dma(host, data)) {
+	if (atmci_prepare_data_dma(host, data)) {
 		host->data_chan = NULL;
 
 		/*
@@ -731,6 +783,8 @@ static void atmci_start_request(struct a
 		mci_writel(host, CR, MCI_CR_SWRST);
 		mci_writel(host, CR, MCI_CR_MCIEN);
 		mci_writel(host, MR, host->mode_reg);
+		if (atmci_is_mci2())
+			mci_writel(host, CFG, host->cfg_reg);
 		host->need_reset = false;
 	}
 	mci_writel(host, SDCR, slot->sdc_reg);
@@ -746,6 +800,7 @@ static void atmci_start_request(struct a
 		while (!(mci_readl(host, SR) & MCI_CMDRDY))
 			cpu_relax();
 	}
+	iflags = 0;
 	data = mrq->data;
 	if (data) {
 		atmci_set_timeout(host, slot, data);
@@ -755,15 +810,17 @@ static void atmci_start_request(struct a
 				| MCI_BLKLEN(data->blksz));
 		dev_vdbg(&slot->mmc->class_dev, "BLKR=0x%08x\n",
 			MCI_BCNT(data->blocks) | MCI_BLKLEN(data->blksz));
+
+		iflags |= atmci_prepare_data(host, data);
 	}
 
-	iflags = MCI_CMDRDY;
+	iflags |= MCI_CMDRDY;
 	cmd = mrq->cmd;
 	cmdflags = atmci_prepare_command(slot->mmc, cmd);
 	atmci_start_command(host, cmd, cmdflags);
 
 	if (data)
-		iflags |= atmci_submit_data(host, data);
+		atmci_submit_data(host);
 
 	if (mrq->stop) {
 		host->stop_cmdr = atmci_prepare_command(slot->mmc, mrq->stop);
@@ -859,6 +916,8 @@ static void atmci_set_ios(struct mmc_hos
 			clk_enable(host->mck);
 			mci_writel(host, CR, MCI_CR_SWRST);
 			mci_writel(host, CR, MCI_CR_MCIEN);
+			if (atmci_is_mci2())
+				mci_writel(host, CFG, host->cfg_reg);
 		}
 
 		/*
@@ -1097,6 +1156,8 @@ static void atmci_detect_change(unsigned
 				mci_writel(host, CR, MCI_CR_SWRST);
 				mci_writel(host, CR, MCI_CR_MCIEN);
 				mci_writel(host, MR, host->mode_reg);
+				if (atmci_is_mci2())
+					mci_writel(host, CFG, host->cfg_reg);
 
 				host->data = NULL;
 				host->cmd = NULL;
@@ -1620,6 +1681,10 @@ static void atmci_configure_dma(struct a
 	}
 	if (!host->dma.chan)
 		dev_notice(&host->pdev->dev, "DMA not available, using PIO\n");
+	else
+		dev_info(&host->pdev->dev,
+					"Using %s for DMA transfers\n",
+					dma_chan_name(host->dma.chan));
 }
 #else
 static void atmci_configure_dma(struct atmel_mci *host) {}
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
atmel-mci-change-use-of-dma-slave-interface.patch
mmc-atmel-mci-new-mci2-module-support-in-atmel-mci-driver.patch

