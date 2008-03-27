From: akpm@linux-foundation.org
Subject: - mmc-omap-lazy-clock-shutdown.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:18:02 -0700
Message-ID: <200803270318.m2R3I2NN015270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbYC0DSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: lazy clock shutdown
has been removed from the -mm tree.  Its filename was
     mmc-omap-lazy-clock-shutdown.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: lazy clock shutdown
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

MMCA spec says the mmc clock should be kept running for at least 8 cycles
after the last RW request.  Ensure this with lazy clock disable after a
request, or with an explicit delay before switching a slot.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   89 ++++++++++++++++++++++++++++++++------
 1 file changed, 75 insertions(+), 14 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-lazy-clock-shutdown drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-lazy-clock-shutdown
+++ a/drivers/mmc/host/omap.c
@@ -161,9 +161,38 @@ struct mmc_omap_host {
 	wait_queue_head_t       slot_wq;
 	int                     nr_slots;
 
+	struct timer_list       clk_timer;
+	spinlock_t		clk_lock;     /* for changing enabled state */
+	unsigned int            fclk_enabled:1;
+
 	struct omap_mmc_platform_data *pdata;
 };
 
+void mmc_omap_fclk_offdelay(struct mmc_omap_slot *slot)
+{
+	unsigned long tick_ns;
+
+	if (slot != NULL && slot->host->fclk_enabled && slot->fclk_freq > 0) {
+		tick_ns = (1000000000 + slot->fclk_freq - 1) / slot->fclk_freq;
+		ndelay(8 * tick_ns);
+	}
+}
+
+void mmc_omap_fclk_enable(struct mmc_omap_host *host, unsigned int enable)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->clk_lock, flags);
+	if (host->fclk_enabled != enable) {
+		host->fclk_enabled = enable;
+		if (enable)
+			clk_enable(host->fclk);
+		else
+			clk_disable(host->fclk);
+	}
+	spin_unlock_irqrestore(&host->clk_lock, flags);
+}
+
 static void mmc_omap_select_slot(struct mmc_omap_slot *slot, int claimed)
 {
 	struct mmc_omap_host *host = slot->host;
@@ -180,32 +209,49 @@ static void mmc_omap_select_slot(struct 
 	host->mmc = slot->mmc;
 	spin_unlock_irqrestore(&host->slot_lock, flags);
 no_claim:
-	clk_enable(host->fclk);
+	del_timer(&host->clk_timer);
+	if (host->current_slot != slot || !claimed)
+		mmc_omap_fclk_offdelay(host->current_slot);
+
 	if (host->current_slot != slot) {
+		OMAP_MMC_WRITE(host, CON, slot->saved_con & 0xFC00);
 		if (host->pdata->switch_slot != NULL)
 			host->pdata->switch_slot(mmc_dev(slot->mmc), slot->id);
 		host->current_slot = slot;
 	}
 
-	/* Doing the dummy read here seems to work around some bug
-	 * at least in OMAP24xx silicon where the command would not
-	 * start after writing the CMD register. Sigh. */
-	OMAP_MMC_READ(host, CON);
+	if (claimed) {
+		mmc_omap_fclk_enable(host, 1);
+
+		/* Doing the dummy read here seems to work around some bug
+		 * at least in OMAP24xx silicon where the command would not
+		 * start after writing the CMD register. Sigh. */
+		OMAP_MMC_READ(host, CON);
 
-	OMAP_MMC_WRITE(host, CON, slot->saved_con);
+		OMAP_MMC_WRITE(host, CON, slot->saved_con);
+	} else
+		mmc_omap_fclk_enable(host, 0);
 }
 
 static void mmc_omap_start_request(struct mmc_omap_host *host,
 				   struct mmc_request *req);
 
-static void mmc_omap_release_slot(struct mmc_omap_slot *slot)
+static void mmc_omap_release_slot(struct mmc_omap_slot *slot, int clk_enabled)
 {
 	struct mmc_omap_host *host = slot->host;
 	unsigned long flags;
 	int i;
 
 	BUG_ON(slot == NULL || host->mmc == NULL);
-	clk_disable(host->fclk);
+
+	if (clk_enabled)
+		/* Keeps clock running for at least 8 cycles on valid freq */
+		mod_timer(&host->clk_timer, jiffies  + HZ/10);
+	else {
+		del_timer(&host->clk_timer);
+		mmc_omap_fclk_offdelay(slot);
+		mmc_omap_fclk_enable(host, 0);
+	}
 
 	spin_lock_irqsave(&host->slot_lock, flags);
 	/* Check for any pending requests */
@@ -373,7 +419,7 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 
 		host->mrq = NULL;
 		mmc = host->mmc;
-		mmc_omap_release_slot(host->current_slot);
+		mmc_omap_release_slot(host->current_slot, 1);
 		mmc_request_done(mmc, data->mrq);
 		return;
 	}
@@ -507,7 +553,7 @@ mmc_omap_cmd_done(struct mmc_omap_host *
 			mmc_omap_abort_xfer(host, host->data);
 		host->mrq = NULL;
 		mmc = host->mmc;
-		mmc_omap_release_slot(host->current_slot);
+		mmc_omap_release_slot(host->current_slot, 1);
 		mmc_request_done(mmc, cmd->mrq);
 	}
 }
@@ -538,7 +584,7 @@ static void mmc_omap_abort_command(struc
 
 		host->mrq = NULL;
 		mmc = host->mmc;
-		mmc_omap_release_slot(host->current_slot);
+		mmc_omap_release_slot(host->current_slot, 1);
 		mmc_request_done(mmc, cmd->mrq);
 	} else
 		mmc_omap_cmd_done(host, host->cmd);
@@ -576,6 +622,14 @@ mmc_omap_sg_to_buf(struct mmc_omap_host 
 		host->buffer_bytes_left = host->total_bytes_left;
 }
 
+static void
+mmc_omap_clk_timer(unsigned long data)
+{
+	struct mmc_omap_host *host = (struct mmc_omap_host *) data;
+
+	mmc_omap_fclk_enable(host, 0);
+}
+
 /* PIO only */
 static void
 mmc_omap_xfer_data(struct mmc_omap_host *host, int write)
@@ -1149,14 +1203,16 @@ static void mmc_omap_set_ios(struct mmc_
 	struct mmc_omap_slot *slot = mmc_priv(mmc);
 	struct mmc_omap_host *host = slot->host;
 	int i, dsor;
-
-	dsor = mmc_omap_calc_divisor(mmc, ios);
+	int clk_enabled;
 
 	mmc_omap_select_slot(slot, 0);
 
+	dsor = mmc_omap_calc_divisor(mmc, ios);
+
 	if (ios->vdd != slot->vdd)
 		slot->vdd = ios->vdd;
 
+	clk_enabled = 0;
 	switch (ios->power_mode) {
 	case MMC_POWER_OFF:
 		mmc_omap_set_power(slot, 0, ios->vdd);
@@ -1166,6 +1222,8 @@ static void mmc_omap_set_ios(struct mmc_
 		mmc_omap_set_power(slot, 1, ios->vdd);
 		goto exit;
 	case MMC_POWER_ON:
+		mmc_omap_fclk_enable(host, 1);
+		clk_enabled = 1;
 		dsor |= 1 << 11;
 		break;
 	}
@@ -1194,7 +1252,7 @@ static void mmc_omap_set_ios(struct mmc_
 	}
 
 exit:
-	mmc_omap_release_slot(slot);
+	mmc_omap_release_slot(slot, clk_enabled);
 }
 
 static int mmc_omap_get_ro(struct mmc_host *mmc)
@@ -1357,6 +1415,9 @@ static int __init mmc_omap_probe(struct 
 	setup_timer(&host->cmd_abort_timer, mmc_omap_cmd_timer,
 		    (unsigned long) host);
 
+	spin_lock_init(&host->clk_lock);
+	setup_timer(&host->clk_timer, mmc_omap_clk_timer, (unsigned long) host);
+
 	spin_lock_init(&host->dma_lock);
 	setup_timer(&host->dma_timer, mmc_omap_dma_timer, (unsigned long) host);
 	spin_lock_init(&host->slot_lock);
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

