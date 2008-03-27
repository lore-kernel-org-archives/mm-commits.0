From: akpm@linux-foundation.org
Subject: - mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:18:04 -0700
Message-ID: <200803270318.m2R3I4dK015273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420AbYC0DSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: start new commands from work queue instead of irq
has been removed from the -mm tree.  Its filename was
     mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: start new commands from work queue instead of irq
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

Use work queues for starting new commands instead of starting them directly
from irq handler.  The command scheduling needs to be delayed a bit for some
cards which should not be done from an interrupt.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   48 +++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-start-new-commands-from-work-queue-instead-of-irq drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-start-new-commands-from-work-queue-instead-of-irq
+++ a/drivers/mmc/host/omap.c
@@ -138,6 +138,11 @@ struct mmc_omap_host {
 	unsigned		abort:1;
 	struct timer_list	cmd_abort_timer;
 
+	struct work_struct      slot_release_work;
+	struct mmc_omap_slot    *next_slot;
+	struct work_struct      send_stop_work;
+	struct mmc_data		*stop_data;
+
 	unsigned int		sg_len;
 	int			sg_idx;
 	u16 *			buffer;
@@ -236,6 +241,21 @@ no_claim:
 static void mmc_omap_start_request(struct mmc_omap_host *host,
 				   struct mmc_request *req);
 
+static void mmc_omap_slot_release_work(struct work_struct *work)
+{
+	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
+						  slot_release_work);
+	struct mmc_omap_slot *next_slot = host->next_slot;
+	struct mmc_request *rq;
+
+	host->next_slot = NULL;
+	mmc_omap_select_slot(next_slot, 1);
+
+	rq = next_slot->mrq;
+	next_slot->mrq = NULL;
+	mmc_omap_start_request(host, rq);
+}
+
 static void mmc_omap_release_slot(struct mmc_omap_slot *slot, int clk_enabled)
 {
 	struct mmc_omap_host *host = slot->host;
@@ -257,21 +277,19 @@ static void mmc_omap_release_slot(struct
 	/* Check for any pending requests */
 	for (i = 0; i < host->nr_slots; i++) {
 		struct mmc_omap_slot *new_slot;
-		struct mmc_request *rq;
 
 		if (host->slots[i] == NULL || host->slots[i]->mrq == NULL)
 			continue;
 
+		BUG_ON(host->next_slot != NULL);
 		new_slot = host->slots[i];
 		/* The current slot should not have a request in queue */
 		BUG_ON(new_slot == host->current_slot);
 
+		host->next_slot = new_slot;
 		host->mmc = new_slot->mmc;
 		spin_unlock_irqrestore(&host->slot_lock, flags);
-		mmc_omap_select_slot(new_slot, 1);
-		rq = new_slot->mrq;
-		new_slot->mrq = NULL;
-		mmc_omap_start_request(host, rq);
+		schedule_work(&host->slot_release_work);
 		return;
 	}
 
@@ -400,6 +418,20 @@ mmc_omap_release_dma(struct mmc_omap_hos
 		     dma_data_dir);
 }
 
+static void mmc_omap_send_stop_work(struct work_struct *work)
+{
+	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host,
+						  send_stop_work);
+	struct mmc_omap_slot *slot = host->current_slot;
+	struct mmc_data *data = host->stop_data;
+	unsigned long tick_ns;
+
+	tick_ns = (1000000000 + slot->fclk_freq - 1)/slot->fclk_freq;
+	ndelay(8*tick_ns);
+
+	mmc_omap_start_command(host, data->stop);
+}
+
 static void
 mmc_omap_xfer_done(struct mmc_omap_host *host, struct mmc_data *data)
 {
@@ -424,7 +456,8 @@ mmc_omap_xfer_done(struct mmc_omap_host 
 		return;
 	}
 
-	mmc_omap_start_command(host, data->stop);
+	host->stop_data = data;
+	schedule_work(&host->send_stop_work);
 }
 
 static void
@@ -1411,6 +1444,9 @@ static int __init mmc_omap_probe(struct 
 		goto err_free_mem_region;
 	}
 
+	INIT_WORK(&host->slot_release_work, mmc_omap_slot_release_work);
+	INIT_WORK(&host->send_stop_work, mmc_omap_send_stop_work);
+
 	INIT_WORK(&host->cmd_abort_work, mmc_omap_abort_command);
 	setup_timer(&host->cmd_abort_timer, mmc_omap_cmd_timer,
 		    (unsigned long) host);
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

