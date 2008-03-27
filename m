From: akpm@linux-foundation.org
Subject: - mmc-omap-move-failing-command-abortion-to-workqueue.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:18:00 -0700
Message-ID: <200803270318.m2R3I0vW015195@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859AbYC0DSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: move failing command abortion to workqueue
has been removed from the -mm tree.  Its filename was
     mmc-omap-move-failing-command-abortion-to-workqueue.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: move failing command abortion to workqueue
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Abort failed command from workqueue rather than from an interrupt, allowing
longer delays in abortion.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   82 ++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 33 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-move-failing-command-abortion-to-workqueue drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-move-failing-command-abortion-to-workqueue
+++ a/drivers/mmc/host/omap.c
@@ -134,8 +134,9 @@ struct mmc_omap_host {
 	unsigned char		bus_mode;
 	unsigned char		hw_bus_mode;
 
-	struct work_struct	cmd_abort;
-	struct timer_list	cmd_timer;
+	struct work_struct	cmd_abort_work;
+	unsigned		abort:1;
+	struct timer_list	cmd_abort_timer;
 
 	unsigned int		sg_len;
 	int			sg_idx;
@@ -320,7 +321,7 @@ mmc_omap_start_command(struct mmc_omap_h
 	if (host->data && !(host->data->flags & MMC_DATA_WRITE))
 		cmdreg |= 1 << 15;
 
-	mod_timer(&host->cmd_timer, jiffies + HZ/2);
+	mod_timer(&host->cmd_abort_timer, jiffies + HZ/2);
 
 	OMAP_MMC_WRITE(host, CTO, 200);
 	OMAP_MMC_WRITE(host, ARGL, cmd->arg & 0xffff);
@@ -381,7 +382,7 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 }
 
 static void
-mmc_omap_send_abort(struct mmc_omap_host *host)
+mmc_omap_send_abort(struct mmc_omap_host *host, int maxloops)
 {
 	struct mmc_omap_slot *slot = host->current_slot;
 	unsigned int restarts, passes, timeout;
@@ -390,7 +391,7 @@ mmc_omap_send_abort(struct mmc_omap_host
 	/* Sending abort takes 80 clocks. Have some extra and round up */
 	timeout = (120*1000000 + slot->fclk_freq - 1)/slot->fclk_freq;
 	restarts = 0;
-	while (restarts < 10000) {
+	while (restarts < maxloops) {
 		OMAP_MMC_WRITE(host, STAT, 0xFFFF);
 		OMAP_MMC_WRITE(host, CMD, (3 << 12) | (1 << 7));
 
@@ -412,18 +413,13 @@ out:
 static void
 mmc_omap_abort_xfer(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	u16 ie;
-
 	if (host->dma_in_use)
 		mmc_omap_release_dma(host, data, 1);
 
 	host->data = NULL;
 	host->sg_len = 0;
 
-	ie = OMAP_MMC_READ(host, IE);
-	OMAP_MMC_WRITE(host, IE, 0);
-	OMAP_MMC_WRITE(host, IE, ie);
-	mmc_omap_send_abort(host);
+	mmc_omap_send_abort(host, 10000);
 }
 
 static void
@@ -479,7 +475,7 @@ mmc_omap_cmd_done(struct mmc_omap_host *
 {
 	host->cmd = NULL;
 
-	del_timer(&host->cmd_timer);
+	del_timer(&host->cmd_abort_timer);
 
 	if (cmd->flags & MMC_RSP_PRESENT) {
 		if (cmd->flags & MMC_RSP_136) {
@@ -523,38 +519,48 @@ mmc_omap_cmd_done(struct mmc_omap_host *
 static void mmc_omap_abort_command(struct work_struct *work)
 {
 	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
-						  cmd_abort);
-	u16 ie;
-
-	ie = OMAP_MMC_READ(host, IE);
-	OMAP_MMC_WRITE(host, IE, 0);
-
-	if (!host->cmd) {
-		OMAP_MMC_WRITE(host, IE, ie);
-		return;
-	}
+						  cmd_abort_work);
+	BUG_ON(!host->cmd);
 
 	dev_dbg(mmc_dev(host->mmc), "Aborting stuck command CMD%d\n",
 		host->cmd->opcode);
 
-	if (host->data && host->dma_in_use)
-		mmc_omap_release_dma(host, host->data, 1);
+	if (host->cmd->error == 0)
+		host->cmd->error = -ETIMEDOUT;
 
-	host->data = NULL;
-	host->sg_len = 0;
+	if (host->data == NULL) {
+		struct mmc_command *cmd;
+		struct mmc_host    *mmc;
+
+		cmd = host->cmd;
+		host->cmd = NULL;
+		mmc_omap_send_abort(host, 10000);
 
-	mmc_omap_send_abort(host);
-	host->cmd->error = -ETIMEDOUT;
-	mmc_omap_cmd_done(host, host->cmd);
-	OMAP_MMC_WRITE(host, IE, ie);
+		host->mrq = NULL;
+		mmc = host->mmc;
+		mmc_omap_release_slot(host->current_slot);
+		mmc_request_done(mmc, cmd->mrq);
+	} else
+		mmc_omap_cmd_done(host, host->cmd);
+
+	host->abort = 0;
+	enable_irq(host->irq);
 }
 
 static void
 mmc_omap_cmd_timer(unsigned long data)
 {
 	struct mmc_omap_host *host = (struct mmc_omap_host *) data;
+	unsigned long flags;
 
-	schedule_work(&host->cmd_abort);
+	spin_lock_irqsave(&host->slot_lock, flags);
+	if (host->cmd != NULL && !host->abort) {
+		OMAP_MMC_WRITE(host, IE, 0);
+		disable_irq(host->irq);
+		host->abort = 1;
+		schedule_work(&host->cmd_abort_work);
+	}
+	spin_unlock_irqrestore(&host->slot_lock, flags);
 }
 
 /* PIO only */
@@ -728,6 +734,15 @@ static irqreturn_t mmc_omap_irq(int irq,
 		}
 	}
 
+	if (cmd_error && host->data) {
+		del_timer(&host->cmd_abort_timer);
+		host->abort = 1;
+		OMAP_MMC_WRITE(host, IE, 0);
+		disable_irq(host->irq);
+		schedule_work(&host->cmd_abort_work);
+		return IRQ_HANDLED;
+	}
+
 	if (end_command)
 		mmc_omap_cmd_done(host, host->cmd);
 	if (host->data != NULL) {
@@ -1338,8 +1353,9 @@ static int __init mmc_omap_probe(struct 
 		goto err_free_mem_region;
 	}
 
-	INIT_WORK(&host->cmd_abort, mmc_omap_abort_command);
-	setup_timer(&host->cmd_timer, mmc_omap_cmd_timer, (unsigned long) host);
+	INIT_WORK(&host->cmd_abort_work, mmc_omap_abort_command);
+	setup_timer(&host->cmd_abort_timer, mmc_omap_cmd_timer,
+		    (unsigned long) host);
 
 	spin_lock_init(&host->dma_lock);
 	setup_timer(&host->dma_timer, mmc_omap_dma_timer, (unsigned long) host);
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mmc-omap-move-failing-command-abortion-to-workqueue.patch
mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

