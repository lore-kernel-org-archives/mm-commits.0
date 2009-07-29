From: akpm@linux-foundation.org
Subject: + omap_hsmmc-code-refactoring.patch added to -mm tree
Date: Wed, 29 Jul 2009 13:58:48 -0700
Message-ID: <200907292058.n6TKwmAL009893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbZG2U7J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 16:59:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ext-denis.2.karpov@nokia.com, adrian.hunter@nokia.com, ian@mnementh.co.uk, jarkko.lavinen@nokia.com, matt@console-pimps.org, philipl@overt.org, pierre@ossman.eu, roberto.foglietta@gmail.com


The patch titled
     omap_hsmmc: code refactoring
has been added to the -mm tree.  Its filename is
     omap_hsmmc-code-refactoring.patch

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
Subject: omap_hsmmc: code refactoring
From: Denis Karpov <ext-denis.2.karpov@nokia.com>

Functions', structures', variables' names are changed to start with
omap_hsmmc_ prefix.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Acked-by: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Philip Langdale <philipl@overt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |  320 ++++++++++++++++----------------
 1 file changed, 161 insertions(+), 159 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-code-refactoring drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-code-refactoring
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -135,7 +135,7 @@
 #define OMAP_HSMMC_WRITE(base, reg, val) \
 	__raw_writel((val), (base) + OMAP_HSMMC_##reg)
 
-struct mmc_omap_host {
+struct omap_hsmmc_host {
 	struct	device		*dev;
 	struct	mmc_host	*mmc;
 	struct	mmc_request	*mrq;
@@ -174,7 +174,7 @@ struct mmc_omap_host {
 /*
  * Stop clock to the card
  */
-static void omap_mmc_stop_clock(struct mmc_omap_host *host)
+static void omap_hsmmc_stop_clock(struct omap_hsmmc_host *host)
 {
 	OMAP_HSMMC_WRITE(host->base, SYSCTL,
 		OMAP_HSMMC_READ(host->base, SYSCTL) & ~CEN);
@@ -188,7 +188,7 @@ static void omap_mmc_stop_clock(struct m
  * Restore the MMC host context, if it was lost as result of a
  * power state change.
  */
-static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
+static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 {
 	struct mmc_ios *ios = &host->mmc->ios;
 	struct omap_mmc_platform_data *pdata = host->pdata;
@@ -316,7 +316,7 @@ out:
 /*
  * Save the MMC host context (store the number of power state changes so far).
  */
-static void omap_mmc_save_ctx(struct mmc_omap_host *host)
+static void omap_hsmmc_context_save(struct omap_hsmmc_host *host)
 {
 	struct omap_mmc_platform_data *pdata = host->pdata;
 	int context_loss;
@@ -331,12 +331,12 @@ static void omap_mmc_save_ctx(struct mmc
 
 #else
 
-static int omap_mmc_restore_ctx(struct mmc_omap_host *host)
+static int omap_hsmmc_context_restore(struct omap_hsmmc_host *host)
 {
 	return 0;
 }
 
-static void omap_mmc_save_ctx(struct mmc_omap_host *host)
+static void omap_hsmmc_context_save(struct omap_hsmmc_host *host)
 {
 }
 
@@ -346,7 +346,7 @@ static void omap_mmc_save_ctx(struct mmc
  * Send init stream sequence to card
  * before sending IDLE command
  */
-static void send_init_stream(struct mmc_omap_host *host)
+static void send_init_stream(struct omap_hsmmc_host *host)
 {
 	int reg = 0;
 	unsigned long timeout;
@@ -370,7 +370,7 @@ static void send_init_stream(struct mmc_
 }
 
 static inline
-int mmc_omap_cover_is_closed(struct mmc_omap_host *host)
+int omap_hsmmc_cover_is_closed(struct omap_hsmmc_host *host)
 {
 	int r = 1;
 
@@ -380,35 +380,35 @@ int mmc_omap_cover_is_closed(struct mmc_
 }
 
 static ssize_t
-mmc_omap_show_cover_switch(struct device *dev, struct device_attribute *attr,
+omap_hsmmc_show_cover_switch(struct device *dev, struct device_attribute *attr,
 			   char *buf)
 {
 	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
-	return sprintf(buf, "%s\n", mmc_omap_cover_is_closed(host) ? "closed" :
-		       "open");
+	return sprintf(buf, "%s\n",
+			omap_hsmmc_cover_is_closed(host) ? "closed" : "open");
 }
 
-static DEVICE_ATTR(cover_switch, S_IRUGO, mmc_omap_show_cover_switch, NULL);
+static DEVICE_ATTR(cover_switch, S_IRUGO, omap_hsmmc_show_cover_switch, NULL);
 
 static ssize_t
-mmc_omap_show_slot_name(struct device *dev, struct device_attribute *attr,
+omap_hsmmc_show_slot_name(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
 	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	return sprintf(buf, "%s\n", mmc_slot(host).name);
 }
 
-static DEVICE_ATTR(slot_name, S_IRUGO, mmc_omap_show_slot_name, NULL);
+static DEVICE_ATTR(slot_name, S_IRUGO, omap_hsmmc_show_slot_name, NULL);
 
 /*
  * Configure the response type and send the cmd.
  */
 static void
-mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd,
+omap_hsmmc_start_command(struct omap_hsmmc_host *host, struct mmc_command *cmd,
 	struct mmc_data *data)
 {
 	int cmdreg = 0, resptype = 0, cmdtype = 0;
@@ -474,7 +474,7 @@ mmc_omap_start_command(struct mmc_omap_h
 }
 
 static int
-mmc_omap_get_dma_dir(struct mmc_omap_host *host, struct mmc_data *data)
+omap_hsmmc_get_dma_dir(struct omap_hsmmc_host *host, struct mmc_data *data)
 {
 	if (data->flags & MMC_DATA_WRITE)
 		return DMA_TO_DEVICE;
@@ -486,7 +486,7 @@ mmc_omap_get_dma_dir(struct mmc_omap_hos
  * Notify the transfer complete to MMC core
  */
 static void
-mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
+omap_hsmmc_xfer_done(struct omap_hsmmc_host *host, struct mmc_data *data)
 {
 	if (!data) {
 		struct mmc_request *mrq = host->mrq;
@@ -507,7 +507,7 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 
 	if (host->use_dma && host->dma_ch != -1)
 		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->dma_len,
-			mmc_omap_get_dma_dir(host, data));
+			omap_hsmmc_get_dma_dir(host, data));
 
 	if (!data->error)
 		data->bytes_xfered += data->blocks * (data->blksz);
@@ -519,14 +519,14 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 		mmc_request_done(host->mmc, data->mrq);
 		return;
 	}
-	mmc_omap_start_command(host, data->stop, NULL);
+	omap_hsmmc_start_command(host, data->stop, NULL);
 }
 
 /*
  * Notify the core about command completion
  */
 static void
-mmc_omap_cmd_done(struct mmc_omap_host *host, struct mmc_command *cmd)
+omap_hsmmc_cmd_done(struct omap_hsmmc_host *host, struct mmc_command *cmd)
 {
 	host->cmd = NULL;
 
@@ -551,13 +551,13 @@ mmc_omap_cmd_done(struct mmc_omap_host *
 /*
  * DMA clean up for command errors
  */
-static void mmc_dma_cleanup(struct mmc_omap_host *host, int errno)
+static void omap_hsmmc_dma_cleanup(struct omap_hsmmc_host *host, int errno)
 {
 	host->data->error = errno;
 
 	if (host->use_dma && host->dma_ch != -1) {
 		dma_unmap_sg(mmc_dev(host->mmc), host->data->sg, host->dma_len,
-			mmc_omap_get_dma_dir(host, host->data));
+			omap_hsmmc_get_dma_dir(host, host->data));
 		omap_free_dma(host->dma_ch);
 		host->dma_ch = -1;
 		up(&host->sem);
@@ -569,10 +569,10 @@ static void mmc_dma_cleanup(struct mmc_o
  * Readable error output
  */
 #ifdef CONFIG_MMC_DEBUG
-static void mmc_omap_report_irq(struct mmc_omap_host *host, u32 status)
+static void omap_hsmmc_report_irq(struct omap_hsmmc_host *host, u32 status)
 {
 	/* --- means reserved bit without definition at documentation */
-	static const char *mmc_omap_status_bits[] = {
+	static const char *omap_hsmmc_status_bits[] = {
 		"CC", "TC", "BGE", "---", "BWR", "BRR", "---", "---", "CIRQ",
 		"OBI", "---", "---", "---", "---", "---", "ERRI", "CTO", "CCRC",
 		"CEB", "CIE", "DTO", "DCRC", "DEB", "---", "ACE", "---",
@@ -585,9 +585,9 @@ static void mmc_omap_report_irq(struct m
 	len = sprintf(buf, "MMC IRQ 0x%x :", status);
 	buf += len;
 
-	for (i = 0; i < ARRAY_SIZE(mmc_omap_status_bits); i++)
+	for (i = 0; i < ARRAY_SIZE(omap_hsmmc_status_bits); i++)
 		if (status & (1 << i)) {
-			len = sprintf(buf, " %s", mmc_omap_status_bits[i]);
+			len = sprintf(buf, " %s", omap_hsmmc_status_bits[i]);
 			buf += len;
 		}
 
@@ -602,8 +602,8 @@ static void mmc_omap_report_irq(struct m
  *  SRC or SRD bit of SYSCTL register
  * Can be called from interrupt context
  */
-static inline void mmc_omap_reset_controller_fsm(struct mmc_omap_host *host,
-		unsigned long bit)
+static inline void omap_hsmmc_reset_controller_fsm(struct omap_hsmmc_host *host,
+						   unsigned long bit)
 {
 	unsigned long i = 0;
 	unsigned long limit = (loops_per_jiffy *
@@ -625,9 +625,9 @@ static inline void mmc_omap_reset_contro
 /*
  * MMC controller IRQ handler
  */
-static irqreturn_t mmc_omap_irq(int irq, void *dev_id)
+static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
 {
-	struct mmc_omap_host *host = dev_id;
+	struct omap_hsmmc_host *host = dev_id;
 	struct mmc_data *data;
 	int end_cmd = 0, end_trans = 0, status;
 
@@ -648,14 +648,14 @@ static irqreturn_t mmc_omap_irq(int irq,
 
 	if (status & ERR) {
 #ifdef CONFIG_MMC_DEBUG
-		mmc_omap_report_irq(host, status);
+		omap_hsmmc_report_irq(host, status);
 #endif
 		if ((status & CMD_TIMEOUT) ||
 			(status & CMD_CRC)) {
 			if (host->cmd) {
 				if (status & CMD_TIMEOUT) {
-					mmc_omap_reset_controller_fsm(host,
-								      SRC);
+					omap_hsmmc_reset_controller_fsm(host,
+									SRC);
 					host->cmd->error = -ETIMEDOUT;
 				} else {
 					host->cmd->error = -EILSEQ;
@@ -664,9 +664,10 @@ static irqreturn_t mmc_omap_irq(int irq,
 			}
 			if (host->data || host->response_busy) {
 				if (host->data)
-					mmc_dma_cleanup(host, -ETIMEDOUT);
+					omap_hsmmc_dma_cleanup(host,
+								-ETIMEDOUT);
 				host->response_busy = 0;
-				mmc_omap_reset_controller_fsm(host, SRD);
+				omap_hsmmc_reset_controller_fsm(host, SRD);
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
@@ -676,11 +677,11 @@ static irqreturn_t mmc_omap_irq(int irq,
 						-ETIMEDOUT : -EILSEQ;
 
 				if (host->data)
-					mmc_dma_cleanup(host, err);
+					omap_hsmmc_dma_cleanup(host, err);
 				else
 					host->mrq->cmd->error = err;
 				host->response_busy = 0;
-				mmc_omap_reset_controller_fsm(host, SRD);
+				omap_hsmmc_reset_controller_fsm(host, SRD);
 				end_trans = 1;
 			}
 		}
@@ -699,16 +700,16 @@ static irqreturn_t mmc_omap_irq(int irq,
 	OMAP_HSMMC_READ(host->base, STAT);
 
 	if (end_cmd || ((status & CC) && host->cmd))
-		mmc_omap_cmd_done(host, host->cmd);
+		omap_hsmmc_cmd_done(host, host->cmd);
 	if ((end_trans || (status & TC)) && host->mrq)
-		mmc_omap_xfer_done(host, data);
+		omap_hsmmc_xfer_done(host, data);
 
 	spin_unlock(&host->irq_lock);
 
 	return IRQ_HANDLED;
 }
 
-static void set_sd_bus_power(struct mmc_omap_host *host)
+static void set_sd_bus_power(struct omap_hsmmc_host *host)
 {
 	unsigned long i;
 
@@ -728,7 +729,7 @@ static void set_sd_bus_power(struct mmc_
  * The MMC2 transceiver controls are used instead of DAT4..DAT7.
  * Some chips, like eMMC ones, use internal transceivers.
  */
-static int omap_mmc_switch_opcond(struct mmc_omap_host *host, int vdd)
+static int omap_hsmmc_switch_opcond(struct omap_hsmmc_host *host, int vdd)
 {
 	u32 reg_val = 0;
 	int ret;
@@ -759,7 +760,7 @@ static int omap_mmc_switch_opcond(struct
 	/*
 	 * If a MMC dual voltage card is detected, the set_ios fn calls
 	 * this fn with VDD bit set for 1.8V. Upon card removal from the
-	 * slot, omap_mmc_set_ios sets the VDD back to 3V on MMC_POWER_OFF.
+	 * slot, omap_hsmmc_set_ios sets the VDD back to 3V on MMC_POWER_OFF.
 	 *
 	 * Cope with a bit of slop in the range ... per data sheets:
 	 *  - "1.8V" for vdds_mmc1/vdds_mmc1a can be up to 2.45V max,
@@ -788,10 +789,10 @@ err:
 /*
  * Work Item to notify the core about card insertion/removal
  */
-static void mmc_omap_detect(struct work_struct *work)
+static void omap_hsmmc_detect(struct work_struct *work)
 {
-	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
-						mmc_carddetect_work);
+	struct omap_hsmmc_host *host =
+		container_of(work, struct omap_hsmmc_host, mmc_carddetect_work);
 	struct omap_mmc_slot_data *slot = &mmc_slot(host);
 	int carddetect;
 
@@ -809,8 +810,9 @@ static void mmc_omap_detect(struct work_
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
 		mmc_host_enable(host->mmc);
-		mmc_omap_reset_controller_fsm(host, SRD);
+		omap_hsmmc_reset_controller_fsm(host, SRD);
 		mmc_host_lazy_disable(host->mmc);
+
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 	}
 }
@@ -818,9 +820,9 @@ static void mmc_omap_detect(struct work_
 /*
  * ISR for handling card insertion and removal
  */
-static irqreturn_t omap_mmc_cd_handler(int irq, void *dev_id)
+static irqreturn_t omap_hsmmc_cd_handler(int irq, void *dev_id)
 {
-	struct mmc_omap_host *host = (struct mmc_omap_host *)dev_id;
+	struct omap_hsmmc_host *host = (struct omap_hsmmc_host *)dev_id;
 
 	if (host->suspended)
 		return IRQ_HANDLED;
@@ -829,7 +831,7 @@ static irqreturn_t omap_mmc_cd_handler(i
 	return IRQ_HANDLED;
 }
 
-static int mmc_omap_get_dma_sync_dev(struct mmc_omap_host *host,
+static int omap_hsmmc_get_dma_sync_dev(struct omap_hsmmc_host *host,
 				     struct mmc_data *data)
 {
 	int sync_dev;
@@ -841,7 +843,7 @@ static int mmc_omap_get_dma_sync_dev(str
 	return sync_dev;
 }
 
-static void mmc_omap_config_dma_params(struct mmc_omap_host *host,
+static void omap_hsmmc_config_dma_params(struct omap_hsmmc_host *host,
 				       struct mmc_data *data,
 				       struct scatterlist *sgl)
 {
@@ -865,7 +867,7 @@ static void mmc_omap_config_dma_params(s
 
 	omap_set_dma_transfer_params(dma_ch, OMAP_DMA_DATA_TYPE_S32,
 			blksz / 4, nblk, OMAP_DMA_SYNC_FRAME,
-			mmc_omap_get_dma_sync_dev(host, data),
+			omap_hsmmc_get_dma_sync_dev(host, data),
 			!(data->flags & MMC_DATA_WRITE));
 
 	omap_start_dma(dma_ch);
@@ -874,9 +876,9 @@ static void mmc_omap_config_dma_params(s
 /*
  * DMA call back function
  */
-static void mmc_omap_dma_cb(int lch, u16 ch_status, void *data)
+static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *data)
 {
-	struct mmc_omap_host *host = data;
+	struct omap_hsmmc_host *host = data;
 
 	if (ch_status & OMAP2_DMA_MISALIGNED_ERR_IRQ)
 		dev_dbg(mmc_dev(host->mmc), "MISALIGNED_ADRS_ERR\n");
@@ -887,7 +889,7 @@ static void mmc_omap_dma_cb(int lch, u16
 	host->dma_sg_idx++;
 	if (host->dma_sg_idx < host->dma_len) {
 		/* Fire up the next transfer. */
-		mmc_omap_config_dma_params(host, host->data,
+		omap_hsmmc_config_dma_params(host, host->data,
 					   host->data->sg + host->dma_sg_idx);
 		return;
 	}
@@ -904,8 +906,8 @@ static void mmc_omap_dma_cb(int lch, u16
 /*
  * Routine to configure and start DMA for the MMC card
  */
-static int
-mmc_omap_start_dma_transfer(struct mmc_omap_host *host, struct mmc_request *req)
+static int omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host,
+					struct mmc_request *req)
 {
 	int dma_ch = 0, ret = 0, err = 1, i;
 	struct mmc_data *data = req->data;
@@ -942,8 +944,8 @@ mmc_omap_start_dma_transfer(struct mmc_o
 			return err;
 	}
 
-	ret = omap_request_dma(mmc_omap_get_dma_sync_dev(host, data), "MMC/SD",
-			       mmc_omap_dma_cb, host, &dma_ch);
+	ret = omap_request_dma(omap_hsmmc_get_dma_sync_dev(host, data),
+			       "MMC/SD", omap_hsmmc_dma_cb, host, &dma_ch);
 	if (ret != 0) {
 		dev_err(mmc_dev(host->mmc),
 			"%s: omap_request_dma() failed with %d\n",
@@ -952,16 +954,16 @@ mmc_omap_start_dma_transfer(struct mmc_o
 	}
 
 	host->dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg,
-			data->sg_len, mmc_omap_get_dma_dir(host, data));
+			data->sg_len, omap_hsmmc_get_dma_dir(host, data));
 	host->dma_ch = dma_ch;
 	host->dma_sg_idx = 0;
 
-	mmc_omap_config_dma_params(host, data, data->sg);
+	omap_hsmmc_config_dma_params(host, data, data->sg);
 
 	return 0;
 }
 
-static void set_data_timeout(struct mmc_omap_host *host,
+static void set_data_timeout(struct omap_hsmmc_host *host,
 			     struct mmc_request *req)
 {
 	unsigned int timeout, cycle_ns;
@@ -1001,7 +1003,7 @@ static void set_data_timeout(struct mmc_
  * Configure block length for MMC/SD cards and initiate the transfer.
  */
 static int
-mmc_omap_prepare_data(struct mmc_omap_host *host, struct mmc_request *req)
+omap_hsmmc_prepare_data(struct omap_hsmmc_host *host, struct mmc_request *req)
 {
 	int ret;
 	host->data = req->data;
@@ -1016,7 +1018,7 @@ mmc_omap_prepare_data(struct mmc_omap_ho
 	set_data_timeout(host, req);
 
 	if (host->use_dma) {
-		ret = mmc_omap_start_dma_transfer(host, req);
+		ret = omap_hsmmc_start_dma_transfer(host, req);
 		if (ret != 0) {
 			dev_dbg(mmc_dev(host->mmc), "MMC start dma failure\n");
 			return ret;
@@ -1028,9 +1030,9 @@ mmc_omap_prepare_data(struct mmc_omap_ho
 /*
  * Request function. for read/write operation
  */
-static void omap_mmc_request(struct mmc_host *mmc, struct mmc_request *req)
+static void omap_hsmmc_request(struct mmc_host *mmc, struct mmc_request *req)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int err;
 
 	/*
@@ -1042,7 +1044,7 @@ static void omap_mmc_request(struct mmc_
 		spin_lock_irqsave(&host->irq_lock, host->flags);
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
-	err = mmc_omap_prepare_data(host, req);
+	err = omap_hsmmc_prepare_data(host, req);
 	if (err) {
 		req->cmd->error = err;
 		if (req->data)
@@ -1054,14 +1056,13 @@ static void omap_mmc_request(struct mmc_
 		return;
 	}
 
-	mmc_omap_start_command(host, req->cmd, req->data);
+	omap_hsmmc_start_command(host, req->cmd, req->data);
 }
 
-
 /* Routine to configure clock values. Exposed API to core */
-static void omap_mmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+static void omap_hsmmc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	u16 dsor = 0;
 	unsigned long regval;
 	unsigned long timeout;
@@ -1120,8 +1121,8 @@ static void omap_mmc_set_ios(struct mmc_
 				 * MMC_POWER_UP upon recalculating the voltage.
 				 * vdd 1.8v.
 				 */
-				if (omap_mmc_switch_opcond(host, ios->vdd) != 0)
-					dev_dbg(mmc_dev(host->mmc),
+			if (omap_hsmmc_switch_opcond(host, ios->vdd) != 0)
+				dev_dbg(mmc_dev(host->mmc),
 						"Switch operation failed\n");
 		}
 	}
@@ -1137,7 +1138,7 @@ static void omap_mmc_set_ios(struct mmc_
 		if (dsor > 250)
 			dsor = 250;
 	}
-	omap_mmc_stop_clock(host);
+	omap_hsmmc_stop_clock(host);
 	regval = OMAP_HSMMC_READ(host->base, SYSCTL);
 	regval = regval & ~(CLKD_MASK);
 	regval = regval | (dsor << 6) | (DTO << 16);
@@ -1171,7 +1172,7 @@ static void omap_mmc_set_ios(struct mmc_
 
 static int omap_hsmmc_get_cd(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	if (!mmc_slot(host).card_detect)
 		return -ENOSYS;
@@ -1180,14 +1181,14 @@ static int omap_hsmmc_get_cd(struct mmc_
 
 static int omap_hsmmc_get_ro(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	if (!mmc_slot(host).get_ro)
 		return -ENOSYS;
 	return mmc_slot(host).get_ro(host->dev, 0);
 }
 
-static void omap_hsmmc_init(struct mmc_omap_host *host)
+static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
 {
 	u32 hctl, capa, value;
 
@@ -1233,9 +1234,9 @@ static void omap_hsmmc_init(struct mmc_o
 enum {ENABLED = 0, DISABLED, CARDSLEEP, REGSLEEP, OFF};
 
 /* Handler for [ENABLED -> DISABLED] transition */
-static int omap_mmc_enabled_to_disabled(struct mmc_omap_host *host)
+static int omap_hsmmc_enabled_to_disabled(struct omap_hsmmc_host *host)
 {
-	omap_mmc_save_ctx(host);
+	omap_hsmmc_context_save(host);
 	clk_disable(host->fclk);
 	host->dpm_state = DISABLED;
 
@@ -1248,7 +1249,7 @@ static int omap_mmc_enabled_to_disabled(
 }
 
 /* Handler for [DISABLED -> REGSLEEP / CARDSLEEP] transition */
-static int omap_mmc_disabled_to_sleep(struct mmc_omap_host *host)
+static int omap_hsmmc_disabled_to_sleep(struct omap_hsmmc_host *host)
 {
 	int err, new_state;
 
@@ -1256,7 +1257,7 @@ static int omap_mmc_disabled_to_sleep(st
 		return 0;
 
 	clk_enable(host->fclk);
-	omap_mmc_restore_ctx(host);
+	omap_hsmmc_context_restore(host);
 	if (mmc_card_can_sleep(host->mmc)) {
 		err = mmc_card_sleep(host->mmc);
 		if (err < 0) {
@@ -1265,8 +1266,9 @@ static int omap_mmc_disabled_to_sleep(st
 			return err;
 		}
 		new_state = CARDSLEEP;
-	} else
+	} else {
 		new_state = REGSLEEP;
+	}
 	if (mmc_slot(host).set_sleep)
 		mmc_slot(host).set_sleep(host->dev, host->slot_id, 1, 0,
 					 new_state == CARDSLEEP);
@@ -1289,7 +1291,7 @@ static int omap_mmc_disabled_to_sleep(st
 }
 
 /* Handler for [REGSLEEP / CARDSLEEP -> OFF] transition */
-static int omap_mmc_sleep_to_off(struct mmc_omap_host *host)
+static int omap_hsmmc_sleep_to_off(struct omap_hsmmc_host *host)
 {
 	if (!mmc_try_claim_host(host->mmc))
 		return 0;
@@ -1317,7 +1319,7 @@ static int omap_mmc_sleep_to_off(struct 
 }
 
 /* Handler for [DISABLED -> ENABLED] transition */
-static int omap_mmc_disabled_to_enabled(struct mmc_omap_host *host)
+static int omap_hsmmc_disabled_to_enabled(struct omap_hsmmc_host *host)
 {
 	int err;
 
@@ -1325,8 +1327,7 @@ static int omap_mmc_disabled_to_enabled(
 	if (err < 0)
 		return err;
 
-	omap_mmc_restore_ctx(host);
-
+	omap_hsmmc_context_restore(host);
 	host->dpm_state = ENABLED;
 
 	dev_dbg(mmc_dev(host->mmc), "DISABLED -> ENABLED\n");
@@ -1335,13 +1336,13 @@ static int omap_mmc_disabled_to_enabled(
 }
 
 /* Handler for [SLEEP -> ENABLED] transition */
-static int omap_mmc_sleep_to_enabled(struct mmc_omap_host *host)
+static int omap_hsmmc_sleep_to_enabled(struct omap_hsmmc_host *host)
 {
 	if (!mmc_try_claim_host(host->mmc))
 		return 0;
 
 	clk_enable(host->fclk);
-	omap_mmc_restore_ctx(host);
+	omap_hsmmc_context_restore(host);
 	if (mmc_slot(host).set_sleep)
 		mmc_slot(host).set_sleep(host->dev, host->slot_id, 0,
 			 host->vdd, host->dpm_state == CARDSLEEP);
@@ -1359,12 +1360,12 @@ static int omap_mmc_sleep_to_enabled(str
 }
 
 /* Handler for [OFF -> ENABLED] transition */
-static int omap_mmc_off_to_enabled(struct mmc_omap_host *host)
+static int omap_hsmmc_off_to_enabled(struct omap_hsmmc_host *host)
 {
 	clk_enable(host->fclk);
 
-	omap_mmc_restore_ctx(host);
-	omap_hsmmc_init(host);
+	omap_hsmmc_context_restore(host);
+	omap_hsmmc_conf_bus_power(host);
 	mmc_power_restore_host(host->mmc);
 
 	host->dpm_state = ENABLED;
@@ -1377,18 +1378,18 @@ static int omap_mmc_off_to_enabled(struc
 /*
  * Bring MMC host to ENABLED from any other PM state.
  */
-static int omap_mmc_enable(struct mmc_host *mmc)
+static int omap_hsmmc_enable(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	switch (host->dpm_state) {
 	case DISABLED:
-		return omap_mmc_disabled_to_enabled(host);
+		return omap_hsmmc_disabled_to_enabled(host);
 	case CARDSLEEP:
 	case REGSLEEP:
-		return omap_mmc_sleep_to_enabled(host);
+		return omap_hsmmc_sleep_to_enabled(host);
 	case OFF:
-		return omap_mmc_off_to_enabled(host);
+		return omap_hsmmc_off_to_enabled(host);
 	default:
 		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
 		return -EINVAL;
@@ -1398,68 +1399,68 @@ static int omap_mmc_enable(struct mmc_ho
 /*
  * Bring MMC host in PM state (one level deeper).
  */
-static int omap_mmc_disable(struct mmc_host *mmc, int lazy)
+static int omap_hsmmc_disable(struct mmc_host *mmc, int lazy)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
 	switch (host->dpm_state) {
 	case ENABLED: {
 		int delay;
 
-		delay = omap_mmc_enabled_to_disabled(host);
+		delay = omap_hsmmc_enabled_to_disabled(host);
 		if (lazy || delay < 0)
 			return delay;
 		return 0;
 	}
 	case DISABLED:
-		return omap_mmc_disabled_to_sleep(host);
+		return omap_hsmmc_disabled_to_sleep(host);
 	case CARDSLEEP:
 	case REGSLEEP:
-		return omap_mmc_sleep_to_off(host);
+		return omap_hsmmc_sleep_to_off(host);
 	default:
 		dev_dbg(mmc_dev(host->mmc), "UNKNOWN state\n");
 		return -EINVAL;
 	}
 }
 
-static int omap_mmc_enable_fclk(struct mmc_host *mmc)
+static int omap_hsmmc_enable_fclk(struct mmc_host *mmc)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int err;
 
 	err = clk_enable(host->fclk);
 	if (err)
 		return err;
 	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: enabled\n");
-	omap_mmc_restore_ctx(host);
+	omap_hsmmc_context_restore(host);
 	return 0;
 }
 
-static int omap_mmc_disable_fclk(struct mmc_host *mmc, int lazy)
+static int omap_hsmmc_disable_fclk(struct mmc_host *mmc, int lazy)
 {
-	struct mmc_omap_host *host = mmc_priv(mmc);
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 
-	omap_mmc_save_ctx(host);
+	omap_hsmmc_context_save(host);
 	clk_disable(host->fclk);
 	dev_dbg(mmc_dev(host->mmc), "mmc_fclk: disabled\n");
 	return 0;
 }
 
-static const struct mmc_host_ops mmc_omap_ops = {
-	.enable = omap_mmc_enable_fclk,
-	.disable = omap_mmc_disable_fclk,
-	.request = omap_mmc_request,
-	.set_ios = omap_mmc_set_ios,
+static const struct mmc_host_ops omap_hsmmc_ops = {
+	.enable = omap_hsmmc_enable_fclk,
+	.disable = omap_hsmmc_disable_fclk,
+	.request = omap_hsmmc_request,
+	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
 	.get_ro = omap_hsmmc_get_ro,
 	/* NYET -- enable_sdio_irq */
 };
 
-static const struct mmc_host_ops mmc_omap_ps_ops = {
-	.enable = omap_mmc_enable,
-	.disable = omap_mmc_disable,
-	.request = omap_mmc_request,
-	.set_ios = omap_mmc_set_ios,
+static const struct mmc_host_ops omap_hsmmc_ps_ops = {
+	.enable = omap_hsmmc_enable,
+	.disable = omap_hsmmc_disable,
+	.request = omap_hsmmc_request,
+	.set_ios = omap_hsmmc_set_ios,
 	.get_cd = omap_hsmmc_get_cd,
 	.get_ro = omap_hsmmc_get_ro,
 	/* NYET -- enable_sdio_irq */
@@ -1467,15 +1468,14 @@ static const struct mmc_host_ops mmc_oma
 
 #ifdef CONFIG_DEBUG_FS
 
-static int mmc_regs_show(struct seq_file *s, void *data)
+static int omap_hsmmc_regs_show(struct seq_file *s, void *data)
 {
 	struct mmc_host *mmc = s->private;
-	struct mmc_omap_host *host = mmc_priv(mmc);
-	struct omap_mmc_platform_data *pdata = host->pdata;
+	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int context_loss = 0;
 
-	if (pdata->get_context_loss_count)
-		context_loss = pdata->get_context_loss_count(host->dev);
+	if (host->pdata->get_context_loss_count)
+		context_loss = host->pdata->get_context_loss_count(host->dev);
 
 	seq_printf(s, "mmc%d:\n"
 			" enabled:\t%d\n"
@@ -1517,19 +1517,19 @@ static int mmc_regs_show(struct seq_file
 	return 0;
 }
 
-static int mmc_regs_open(struct inode *inode, struct file *file)
+static int omap_hsmmc_regs_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, mmc_regs_show, inode->i_private);
+	return single_open(file, omap_hsmmc_regs_show, inode->i_private);
 }
 
 static const struct file_operations mmc_regs_fops = {
-	.open           = mmc_regs_open,
+	.open           = omap_hsmmc_regs_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
 	.release        = single_release,
 };
 
-static void omap_mmc_debugfs(struct mmc_host *mmc)
+static void omap_hsmmc_debugfs(struct mmc_host *mmc)
 {
 	if (mmc->debugfs_root)
 		debugfs_create_file("regs", S_IRUSR, mmc->debugfs_root,
@@ -1538,17 +1538,17 @@ static void omap_mmc_debugfs(struct mmc_
 
 #else
 
-static void omap_mmc_debugfs(struct mmc_host *mmc)
+static void omap_hsmmc_debugfs(struct mmc_host *mmc)
 {
 }
 
 #endif
 
-static int __init omap_mmc_probe(struct platform_device *pdev)
+static int __init omap_hsmmc_probe(struct platform_device *pdev)
 {
 	struct omap_mmc_platform_data *pdata = pdev->dev.platform_data;
 	struct mmc_host *mmc;
-	struct mmc_omap_host *host = NULL;
+	struct omap_hsmmc_host *host = NULL;
 	struct resource *res;
 	int ret = 0, irq;
 
@@ -1572,7 +1572,7 @@ static int __init omap_mmc_probe(struct 
 	if (res == NULL)
 		return -EBUSY;
 
-	mmc = mmc_alloc_host(sizeof(struct mmc_omap_host), &pdev->dev);
+	mmc = mmc_alloc_host(sizeof(struct omap_hsmmc_host), &pdev->dev);
 	if (!mmc) {
 		ret = -ENOMEM;
 		goto err;
@@ -1593,12 +1593,12 @@ static int __init omap_mmc_probe(struct 
 	host->power_mode = -1;
 
 	platform_set_drvdata(pdev, host);
-	INIT_WORK(&host->mmc_carddetect_work, mmc_omap_detect);
+	INIT_WORK(&host->mmc_carddetect_work, omap_hsmmc_detect);
 
 	if (mmc_slot(host).power_saving)
-		mmc->ops	= &mmc_omap_ps_ops;
+		mmc->ops	= &omap_hsmmc_ps_ops;
 	else
-		mmc->ops	= &mmc_omap_ops;
+		mmc->ops	= &omap_hsmmc_ops;
 
 	mmc->f_min	= 400000;
 	mmc->f_max	= 52000000;
@@ -1620,7 +1620,7 @@ static int __init omap_mmc_probe(struct 
 		goto err1;
 	}
 
-	omap_mmc_save_ctx(host);
+	omap_hsmmc_context_save(host);
 
 	mmc->caps |= MMC_CAP_DISABLE;
 	mmc_set_disable_delay(mmc, OMAP_MMC_DISABLED_TIMEOUT);
@@ -1677,7 +1677,7 @@ static int __init omap_mmc_probe(struct 
 	if (!(mmc->caps & (MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC)))
 		mmc->caps |= MMC_CAP_SDIO | MMC_CAP_SD | MMC_CAP_MMC;
 
-	omap_hsmmc_init(host);
+	omap_hsmmc_conf_bus_power(host);
 
 	/* Select DMA lines */
 	switch (host->id) {
@@ -1699,7 +1699,7 @@ static int __init omap_mmc_probe(struct 
 	}
 
 	/* Request IRQ for MMC operations */
-	ret = request_irq(host->irq, mmc_omap_irq, IRQF_DISABLED,
+	ret = request_irq(host->irq, omap_hsmmc_irq, IRQF_DISABLED,
 			mmc_hostname(mmc), host);
 	if (ret) {
 		dev_dbg(mmc_dev(host->mmc), "Unable to grab HSMMC IRQ\n");
@@ -1709,7 +1709,8 @@ static int __init omap_mmc_probe(struct 
 	/* initialize power supplies, gpios, etc */
 	if (pdata->init != NULL) {
 		if (pdata->init(&pdev->dev) != 0) {
-			dev_dbg(mmc_dev(host->mmc), "late init error\n");
+			dev_dbg(mmc_dev(host->mmc),
+				"Unable to configure MMC IRQs\n");
 			goto err_irq_cd_init;
 		}
 	}
@@ -1718,7 +1719,7 @@ static int __init omap_mmc_probe(struct 
 	/* Request IRQ for card detect */
 	if ((mmc_slot(host).card_detect_irq)) {
 		ret = request_irq(mmc_slot(host).card_detect_irq,
-				  omap_mmc_cd_handler,
+				  omap_hsmmc_cd_handler,
 				  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING
 					  | IRQF_DISABLED,
 				  mmc_hostname(mmc), host);
@@ -1748,7 +1749,7 @@ static int __init omap_mmc_probe(struct 
 			goto err_cover_switch;
 	}
 
-	omap_mmc_debugfs(mmc);
+	omap_hsmmc_debugfs(mmc);
 
 	return 0;
 
@@ -1780,9 +1781,9 @@ err:
 	return ret;
 }
 
-static int omap_mmc_remove(struct platform_device *pdev)
+static int omap_hsmmc_remove(struct platform_device *pdev)
 {
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 	struct resource *res;
 
 	if (host) {
@@ -1817,10 +1818,10 @@ static int omap_mmc_remove(struct platfo
 }
 
 #ifdef CONFIG_PM
-static int omap_mmc_suspend(struct platform_device *pdev, pm_message_t state)
+static int omap_hsmmc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	int ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 
 	if (host && host->suspended)
 		return 0;
@@ -1868,10 +1869,10 @@ static int omap_mmc_suspend(struct platf
 }
 
 /* Routine to resume the MMC device */
-static int omap_mmc_resume(struct platform_device *pdev)
+static int omap_hsmmc_resume(struct platform_device *pdev)
 {
 	int ret = 0;
-	struct mmc_omap_host *host = platform_get_drvdata(pdev);
+	struct omap_hsmmc_host *host = platform_get_drvdata(pdev);
 
 	if (host && !host->suspended)
 		return 0;
@@ -1890,7 +1891,7 @@ static int omap_mmc_resume(struct platfo
 			goto clk_en_err;
 		}
 
-		omap_hsmmc_init(host);
+		omap_hsmmc_conf_bus_power(host);
 
 		if (host->pdata->resume) {
 			ret = host->pdata->resume(&pdev->dev, host->slot_id);
@@ -1903,6 +1904,7 @@ static int omap_mmc_resume(struct platfo
 		ret = mmc_resume_host(host->mmc);
 		if (ret == 0)
 			host->suspended = 0;
+
 		mmc_host_lazy_disable(host->mmc);
 	}
 
@@ -1915,34 +1917,34 @@ clk_en_err:
 }
 
 #else
-#define omap_mmc_suspend	NULL
-#define omap_mmc_resume		NULL
+#define omap_hsmmc_suspend	NULL
+#define omap_hsmmc_resume		NULL
 #endif
 
-static struct platform_driver omap_mmc_driver = {
-	.remove		= omap_mmc_remove,
-	.suspend	= omap_mmc_suspend,
-	.resume		= omap_mmc_resume,
+static struct platform_driver omap_hsmmc_driver = {
+	.remove		= omap_hsmmc_remove,
+	.suspend	= omap_hsmmc_suspend,
+	.resume		= omap_hsmmc_resume,
 	.driver		= {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
 	},
 };
 
-static int __init omap_mmc_init(void)
+static int __init omap_hsmmc_init(void)
 {
 	/* Register the MMC driver */
-	return platform_driver_probe(&omap_mmc_driver, omap_mmc_probe);
+	return platform_driver_register(&omap_hsmmc_driver);
 }
 
-static void __exit omap_mmc_cleanup(void)
+static void __exit omap_hsmmc_cleanup(void)
 {
 	/* Unregister MMC driver */
-	platform_driver_unregister(&omap_mmc_driver);
+	platform_driver_unregister(&omap_hsmmc_driver);
 }
 
-module_init(omap_mmc_init);
-module_exit(omap_mmc_cleanup);
+module_init(omap_hsmmc_init);
+module_exit(omap_hsmmc_cleanup);
 
 MODULE_DESCRIPTION("OMAP High Speed Multimedia Card driver");
 MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from ext-denis.2.karpov@nokia.com are

mmc-add-enable-and-disable-methods-to-mmc-host.patch
mmc-allow-host-claim-release-nesting.patch
mmc-add-mmc_cap_nonremovable-host-capability.patch
mmc-add-ability-to-save-power-by-powering-off-cards.patch
mmc-add-mmc-card-sleep-and-awake-support.patch
mmc-power-off-once-at-removal.patch
mmc-add-host-capabilities-for-sd-only-and-mmc-only.patch
mmc-check-status-after-mmc-switch-command.patch
omap_hsmmc-add-debugfs-entry-host-registers.patch
omap_hsmmc-make-use-of-new-enable-disable-interface.patch
arm-omap-mmc-twl4030-add-context-loss-counter-support.patch
omap_hsmmc-keep-track-of-power-mode.patch
omap_hsmmc-context-save-restore-support.patch
omap_hsmmc-set-open-drain-bit-correctly.patch
omap_hsmmc-ensure-workqueues-are-empty-before-suspend.patch
omap_hsmmc-fix-scatter-gather-list-sanity-checking.patch
omap_hsmmc-make-use-of-new-mmc_cap_nonremovable-host-capability.patch
omap_hsmmc-support-for-deeper-power-saving-states.patch
arm-omap-mmc-twl4030-add-regulator-sleep-wake-function.patch
omap_hsmmc-put-mmc-regulator-to-sleep.patch
omap_hsmmc-add-mmc-card-sleep-and-awake-support.patch
omap_hsmmc-fix-null-pointer-dereference.patch
omap_hsmmc-cleanup-macro-usage.patch
omap_hsmmc-clear-interrupt-status-after-init-sequence.patch
omap_hsmmc-cater-for-weird-cmd6-behaviour.patch
omap_hsmmc-prevent-races-with-irq-handler.patch
omap_hsmmc-pass-host-capabilities-for-sd-only-and-mmc-only.patch
omap_hsmmc-code-refactoring.patch
omap_hsmmc-protect-the-card-when-the-cover-is-open.patch
omap_hsmmc-ensure-all-clock-enables-and-disables-are-paired.patch
omap_hsmmc-set-a-large-data-timeout-for-commands-with-busy-signal.patch
arm-omap-rx51-set-mmc-capabilities-and-power-saving-flag.patch

