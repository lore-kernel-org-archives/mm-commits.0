From: akpm@linux-foundation.org
Subject: + omap_hsmmc-improve-interrupt-synchronisation.patch added to -mm tree
Date: Wed, 12 May 2010 12:52:17 -0700
Message-ID: <201005121952.o4CJqHeH016847__46745.4760488637$1273693979$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57949 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932176Ab0ELTwu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 May 2010 15:52:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adrian.hunter@nokia.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, svenkatr@ti.com, tony@atomide.com


The patch titled
     omap_hsmmc: improve interrupt synchronisation
has been added to the -mm tree.  Its filename is
     omap_hsmmc-improve-interrupt-synchronisation.patch

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
Subject: omap_hsmmc: improve interrupt synchronisation
From: Adrian Hunter <adrian.hunter@nokia.com>

The following changes were needed:
	- do not use in_interrupt() because it will not work
	with threaded interrupts

In addition, the following improvements were made:
	- ensure DMA is unmapped only after the final DMA interrupt
	- ensure a request is completed only after the final DMA interrupt
	- disable controller interrupts when a request is not in progress
	- remove the spin-lock protecting the start of a new request from
	an unexpected interrupt because the locking was complicated and
	a 'req_in_progress' flag suffices (since the spin-lock only defers
	the unexpected interrupts anyway)
	- instead use the spin-lock to protect the MMC interrupt handler
	from the DMA interrupt handler
	- remove the semaphore preventing DMA from being started while
	the previous DMA is still in progress - the other changes make that
	impossible, so it is now a BUG_ON condition
	- ensure the controller interrupt status is clear before exiting
	the interrrupt handler

In general, these changes make the code safer but do not fix any specific
bugs so backporting is not necessary.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Tested-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |  260 ++++++++++++++++----------------
 1 file changed, 133 insertions(+), 127 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-improve-interrupt-synchronisation drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap_hsmmc-improve-interrupt-synchronisation
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -157,12 +157,10 @@ struct omap_hsmmc_host {
 	 */
 	struct	regulator	*vcc;
 	struct	regulator	*vcc_aux;
-	struct	semaphore	sem;
 	struct	work_struct	mmc_carddetect_work;
 	void	__iomem		*base;
 	resource_size_t		mapbase;
 	spinlock_t		irq_lock; /* Prevent races with irq handler */
-	unsigned long		flags;
 	unsigned int		id;
 	unsigned int		dma_len;
 	unsigned int		dma_sg_idx;
@@ -183,6 +181,7 @@ struct omap_hsmmc_host {
 	int			protect_card;
 	int			reqs_blocked;
 	int			use_reg;
+	int			req_in_progress;
 
 	struct	omap_mmc_platform_data	*pdata;
 };
@@ -524,6 +523,27 @@ static void omap_hsmmc_stop_clock(struct
 		dev_dbg(mmc_dev(host->mmc), "MMC Clock is not stoped\n");
 }
 
+static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host)
+{
+	unsigned int irq_mask;
+
+	if (host->use_dma)
+		irq_mask = INT_EN_MASK & ~(BRR_ENABLE | BWR_ENABLE);
+	else
+		irq_mask = INT_EN_MASK;
+
+	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
+	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
+	OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
+}
+
+static void omap_hsmmc_disable_irq(struct omap_hsmmc_host *host)
+{
+	OMAP_HSMMC_WRITE(host->base, ISE, 0);
+	OMAP_HSMMC_WRITE(host->base, IE, 0);
+	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
+}
+
 #ifdef CONFIG_PM
 
 /*
@@ -592,9 +612,7 @@ static int omap_hsmmc_context_restore(st
 		&& time_before(jiffies, timeout))
 		;
 
-	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
-	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
-	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
+	omap_hsmmc_disable_irq(host);
 
 	/* Do not initialize card-specific things if the power is off */
 	if (host->power_mode == MMC_POWER_OFF)
@@ -697,6 +715,8 @@ static void send_init_stream(struct omap
 		return;
 
 	disable_irq(host->irq);
+
+	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
 	OMAP_HSMMC_WRITE(host->base, CON,
 		OMAP_HSMMC_READ(host->base, CON) | INIT_STREAM);
 	OMAP_HSMMC_WRITE(host->base, CMD, INIT_STREAM_CMD);
@@ -762,17 +782,7 @@ omap_hsmmc_start_command(struct omap_hsm
 		mmc_hostname(host->mmc), cmd->opcode, cmd->arg);
 	host->cmd = cmd;
 
-	/*
-	 * Clear status bits and enable interrupts
-	 */
-	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
-	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
-
-	if (host->use_dma)
-		OMAP_HSMMC_WRITE(host->base, IE,
-				 INT_EN_MASK & ~(BRR_ENABLE | BWR_ENABLE));
-	else
-		OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
+	omap_hsmmc_enable_irq(host);
 
 	host->response_busy = 0;
 	if (cmd->flags & MMC_RSP_PRESENT) {
@@ -806,13 +816,7 @@ omap_hsmmc_start_command(struct omap_hsm
 	if (host->use_dma)
 		cmdreg |= DMA_EN;
 
-	/*
-	 * In an interrupt context (i.e. STOP command), the spinlock is unlocked
-	 * by the interrupt handler, otherwise (i.e. for a new request) it is
-	 * unlocked here.
-	 */
-	if (!in_interrupt())
-		spin_unlock_irqrestore(&host->irq_lock, host->flags);
+	host->req_in_progress = 1;
 
 	OMAP_HSMMC_WRITE(host->base, ARG, cmd->arg);
 	OMAP_HSMMC_WRITE(host->base, CMD, cmdreg);
@@ -827,6 +831,23 @@ omap_hsmmc_get_dma_dir(struct omap_hsmmc
 		return DMA_FROM_DEVICE;
 }
 
+static void omap_hsmmc_request_done(struct omap_hsmmc_host *host, struct mmc_request *mrq)
+{
+	int dma_ch;
+
+	spin_lock(&host->irq_lock);
+	host->req_in_progress = 0;
+	dma_ch = host->dma_ch;
+	spin_unlock(&host->irq_lock);
+
+	omap_hsmmc_disable_irq(host);
+	/* Do not complete the request if DMA is still in progress */
+	if (mrq->data && host->use_dma && dma_ch != -1)
+		return;
+	host->mrq = NULL;
+	mmc_request_done(host->mmc, mrq);
+}
+
 /*
  * Notify the transfer complete to MMC core
  */
@@ -843,25 +864,19 @@ omap_hsmmc_xfer_done(struct omap_hsmmc_h
 			return;
 		}
 
-		host->mrq = NULL;
-		mmc_request_done(host->mmc, mrq);
+		omap_hsmmc_request_done(host, mrq);
 		return;
 	}
 
 	host->data = NULL;
 
-	if (host->use_dma && host->dma_ch != -1)
-		dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->dma_len,
-			omap_hsmmc_get_dma_dir(host, data));
-
 	if (!data->error)
 		data->bytes_xfered += data->blocks * (data->blksz);
 	else
 		data->bytes_xfered = 0;
 
 	if (!data->stop) {
-		host->mrq = NULL;
-		mmc_request_done(host->mmc, data->mrq);
+		omap_hsmmc_request_done(host, data->mrq);
 		return;
 	}
 	omap_hsmmc_start_command(host, data->stop, NULL);
@@ -887,10 +902,8 @@ omap_hsmmc_cmd_done(struct omap_hsmmc_ho
 			cmd->resp[0] = OMAP_HSMMC_READ(host->base, RSP10);
 		}
 	}
-	if ((host->data == NULL && !host->response_busy) || cmd->error) {
-		host->mrq = NULL;
-		mmc_request_done(host->mmc, cmd->mrq);
-	}
+	if ((host->data == NULL && !host->response_busy) || cmd->error)
+		omap_hsmmc_request_done(host, cmd->mrq);
 }
 
 /*
@@ -898,14 +911,19 @@ omap_hsmmc_cmd_done(struct omap_hsmmc_ho
  */
 static void omap_hsmmc_dma_cleanup(struct omap_hsmmc_host *host, int errno)
 {
+	int dma_ch;
+
 	host->data->error = errno;
 
-	if (host->use_dma && host->dma_ch != -1) {
+	spin_lock(&host->irq_lock);
+	dma_ch = host->dma_ch;
+	host->dma_ch = -1;
+	spin_unlock(&host->irq_lock);
+
+	if (host->use_dma && dma_ch != -1) {
 		dma_unmap_sg(mmc_dev(host->mmc), host->data->sg, host->dma_len,
 			omap_hsmmc_get_dma_dir(host, host->data));
-		omap_free_dma(host->dma_ch);
-		host->dma_ch = -1;
-		up(&host->sem);
+		omap_free_dma(dma_ch);
 	}
 	host->data = NULL;
 }
@@ -967,28 +985,21 @@ static inline void omap_hsmmc_reset_cont
 			__func__);
 }
 
-/*
- * MMC controller IRQ handler
- */
-static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
+static void omap_hsmmc_do_irq(struct omap_hsmmc_host *host, int status)
 {
-	struct omap_hsmmc_host *host = dev_id;
 	struct mmc_data *data;
-	int end_cmd = 0, end_trans = 0, status;
-
-	spin_lock(&host->irq_lock);
+	int end_cmd = 0, end_trans = 0;
 
-	if (host->mrq == NULL) {
-		OMAP_HSMMC_WRITE(host->base, STAT,
-			OMAP_HSMMC_READ(host->base, STAT));
-		/* Flush posted write */
-		OMAP_HSMMC_READ(host->base, STAT);
-		spin_unlock(&host->irq_lock);
-		return IRQ_HANDLED;
+	if (!host->req_in_progress) {
+		do {
+			OMAP_HSMMC_WRITE(host->base, STAT, status);
+			/* Flush posted write */
+			status = OMAP_HSMMC_READ(host->base, STAT);
+		} while (status & INT_EN_MASK);
+		return;
 	}
 
 	data = host->data;
-	status = OMAP_HSMMC_READ(host->base, STAT);
 	dev_dbg(mmc_dev(host->mmc), "IRQ Status is %x\n", status);
 
 	if (status & ERR) {
@@ -1041,15 +1052,27 @@ static irqreturn_t omap_hsmmc_irq(int ir
 	}
 
 	OMAP_HSMMC_WRITE(host->base, STAT, status);
-	/* Flush posted write */
-	OMAP_HSMMC_READ(host->base, STAT);
 
 	if (end_cmd || ((status & CC) && host->cmd))
 		omap_hsmmc_cmd_done(host, host->cmd);
 	if ((end_trans || (status & TC)) && host->mrq)
 		omap_hsmmc_xfer_done(host, data);
+}
 
-	spin_unlock(&host->irq_lock);
+/*
+ * MMC controller IRQ handler
+ */
+static irqreturn_t omap_hsmmc_irq(int irq, void *dev_id)
+{
+	struct omap_hsmmc_host *host = dev_id;
+	int status;
+
+	status = OMAP_HSMMC_READ(host->base, STAT);
+	do {
+		omap_hsmmc_do_irq(host, status);
+		/* Flush posted write */
+		status = OMAP_HSMMC_READ(host->base, STAT);
+	} while (status & INT_EN_MASK);
 
 	return IRQ_HANDLED;
 }
@@ -1244,31 +1267,47 @@ static void omap_hsmmc_config_dma_params
 /*
  * DMA call back function
  */
-static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *data)
+static void omap_hsmmc_dma_cb(int lch, u16 ch_status, void *cb_data)
 {
-	struct omap_hsmmc_host *host = data;
+	struct omap_hsmmc_host *host = cb_data;
+	struct mmc_data *data = host->mrq->data;
+	int dma_ch, req_in_progress;
 
 	if (ch_status & OMAP2_DMA_MISALIGNED_ERR_IRQ)
 		dev_dbg(mmc_dev(host->mmc), "MISALIGNED_ADRS_ERR\n");
 
-	if (host->dma_ch < 0)
+	spin_lock(&host->irq_lock);
+	if (host->dma_ch < 0) {
+		spin_unlock(&host->irq_lock);
 		return;
+	}
 
 	host->dma_sg_idx++;
 	if (host->dma_sg_idx < host->dma_len) {
 		/* Fire up the next transfer. */
-		omap_hsmmc_config_dma_params(host, host->data,
-					   host->data->sg + host->dma_sg_idx);
+		omap_hsmmc_config_dma_params(host, data,
+					   data->sg + host->dma_sg_idx);
+		spin_unlock(&host->irq_lock);
 		return;
 	}
 
-	omap_free_dma(host->dma_ch);
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg, host->dma_len,
+		omap_hsmmc_get_dma_dir(host, data));
+
+	req_in_progress = host->req_in_progress;
+	dma_ch = host->dma_ch;
 	host->dma_ch = -1;
-	/*
-	 * DMA Callback: run in interrupt context.
-	 * mutex_unlock will throw a kernel warning if used.
-	 */
-	up(&host->sem);
+	spin_unlock(&host->irq_lock);
+
+	omap_free_dma(dma_ch);
+
+	/* If DMA has finished after TC, complete the request */
+	if (!req_in_progress) {
+		struct mmc_request *mrq = host->mrq;
+
+		host->mrq = NULL;
+		mmc_request_done(host->mmc, mrq);
+	}
 }
 
 /*
@@ -1277,7 +1316,7 @@ static void omap_hsmmc_dma_cb(int lch, u
 static int omap_hsmmc_start_dma_transfer(struct omap_hsmmc_host *host,
 					struct mmc_request *req)
 {
-	int dma_ch = 0, ret = 0, err = 1, i;
+	int dma_ch = 0, ret = 0, i;
 	struct mmc_data *data = req->data;
 
 	/* Sanity check: all the SG entries must be aligned by block size. */
@@ -1294,23 +1333,7 @@ static int omap_hsmmc_start_dma_transfer
 		 */
 		return -EINVAL;
 
-	/*
-	 * If for some reason the DMA transfer is still active,
-	 * we wait for timeout period and free the dma
-	 */
-	if (host->dma_ch != -1) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(100);
-		if (down_trylock(&host->sem)) {
-			omap_free_dma(host->dma_ch);
-			host->dma_ch = -1;
-			up(&host->sem);
-			return err;
-		}
-	} else {
-		if (down_trylock(&host->sem))
-			return err;
-	}
+	BUG_ON(host->dma_ch != -1);
 
 	ret = omap_request_dma(omap_hsmmc_get_dma_sync_dev(host, data),
 			       "MMC/SD", omap_hsmmc_dma_cb, host, &dma_ch);
@@ -1410,37 +1433,27 @@ static void omap_hsmmc_request(struct mm
 	struct omap_hsmmc_host *host = mmc_priv(mmc);
 	int err;
 
-	/*
-	 * Prevent races with the interrupt handler because of unexpected
-	 * interrupts, but not if we are already in interrupt context i.e.
-	 * retries.
-	 */
-	if (!in_interrupt()) {
-		spin_lock_irqsave(&host->irq_lock, host->flags);
-		/*
-		 * Protect the card from I/O if there is a possibility
-		 * it can be removed.
-		 */
-		if (host->protect_card) {
-			if (host->reqs_blocked < 3) {
-				/*
-				 * Ensure the controller is left in a consistent
-				 * state by resetting the command and data state
-				 * machines.
-				 */
-				omap_hsmmc_reset_controller_fsm(host, SRD);
-				omap_hsmmc_reset_controller_fsm(host, SRC);
-				host->reqs_blocked += 1;
-			}
-			req->cmd->error = -EBADF;
-			if (req->data)
-				req->data->error = -EBADF;
-			spin_unlock_irqrestore(&host->irq_lock, host->flags);
-			mmc_request_done(mmc, req);
-			return;
-		} else if (host->reqs_blocked)
-			host->reqs_blocked = 0;
-	}
+	BUG_ON(host->req_in_progress);
+	BUG_ON(host->dma_ch != -1);
+	if (host->protect_card) {
+		if (host->reqs_blocked < 3) {
+			/*
+			 * Ensure the controller is left in a consistent
+			 * state by resetting the command and data state
+			 * machines.
+			 */
+			omap_hsmmc_reset_controller_fsm(host, SRD);
+			omap_hsmmc_reset_controller_fsm(host, SRC);
+			host->reqs_blocked += 1;
+		}
+		req->cmd->error = -EBADF;
+		if (req->data)
+			req->data->error = -EBADF;
+		req->cmd->retries = 0;
+		mmc_request_done(mmc, req);
+		return;
+	} else if (host->reqs_blocked)
+		host->reqs_blocked = 0;
 	WARN_ON(host->mrq != NULL);
 	host->mrq = req;
 	err = omap_hsmmc_prepare_data(host, req);
@@ -1449,8 +1462,6 @@ static void omap_hsmmc_request(struct mm
 		if (req->data)
 			req->data->error = err;
 		host->mrq = NULL;
-		if (!in_interrupt())
-			spin_unlock_irqrestore(&host->irq_lock, host->flags);
 		mmc_request_done(mmc, req);
 		return;
 	}
@@ -2019,7 +2030,6 @@ static int __init omap_hsmmc_probe(struc
 	mmc->f_min	= 400000;
 	mmc->f_max	= 52000000;
 
-	sema_init(&host->sem, 1);
 	spin_lock_init(&host->irq_lock);
 
 	host->iclk = clk_get(&pdev->dev, "ick");
@@ -2162,8 +2172,7 @@ static int __init omap_hsmmc_probe(struc
 		}
 	}
 
-	OMAP_HSMMC_WRITE(host->base, ISE, INT_EN_MASK);
-	OMAP_HSMMC_WRITE(host->base, IE, INT_EN_MASK);
+	omap_hsmmc_disable_irq(host);
 
 	mmc_host_lazy_disable(host->mmc);
 
@@ -2283,10 +2292,7 @@ static int omap_hsmmc_suspend(struct pla
 		mmc_host_enable(host->mmc);
 		ret = mmc_suspend_host(host->mmc, state);
 		if (ret == 0) {
-			OMAP_HSMMC_WRITE(host->base, ISE, 0);
-			OMAP_HSMMC_WRITE(host->base, IE, 0);
-
