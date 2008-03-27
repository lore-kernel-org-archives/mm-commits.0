From: akpm@linux-foundation.org
Subject: - mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:17:58 -0700
Message-ID: <200803270317.m2R3HwRP015192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755847AbYC0DSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:18:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jarkko.lavinen@nokia.com, Hiroshi.DOYU@nokia.com, drzeus-list@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: use tasklet instead of workqueue for cover switch notification
has been removed from the -mm tree.  Its filename was
     mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: use tasklet instead of workqueue for cover switch notification
From: Jarkko Lavinen <jarkko.lavinen@nokia.com>

The cover waitqueue is occasionally scheduled twice from timer and the
interrupt and oops follows.  It would have been possible to fix this problem
with spinlocks but using tasklet was a dropin solution with no need for
locking.

This path also adds some cleanups.

Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   67 ++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 27 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification
+++ a/drivers/mmc/host/omap.c
@@ -94,7 +94,7 @@
 
 /* Specifies how often in millisecs to poll for card status changes
  * when the cover switch is open */
-#define OMAP_MMC_SWITCH_POLL_DELAY	500
+#define OMAP_MMC_COVER_POLL_DELAY	500
 
 struct mmc_omap_host;
 
@@ -106,8 +106,8 @@ struct mmc_omap_slot {
 	unsigned int		fclk_freq;
 	unsigned		powered:1;
 
-	struct work_struct      switch_work;
-	struct timer_list       switch_timer;
+	struct tasklet_struct	cover_tasklet;
+	struct timer_list       cover_timer;
 	unsigned		cover_open;
 
 	struct mmc_request      *mrq;
@@ -740,40 +740,51 @@ static irqreturn_t mmc_omap_irq(int irq,
 	return IRQ_HANDLED;
 }
 
-void omap_mmc_notify_cover_event(struct device *dev, int slot, int is_closed)
+void omap_mmc_notify_cover_event(struct device *dev, int num, int is_closed)
 {
+	int cover_open;
 	struct mmc_omap_host *host = dev_get_drvdata(dev);
+	struct mmc_omap_slot *slot = host->slots[num];
 
-	BUG_ON(slot >= host->nr_slots);
+	BUG_ON(num >= host->nr_slots);
 
 	/* Other subsystems can call in here before we're initialised. */
-	if (host->nr_slots == 0 || !host->slots[slot])
+	if (host->nr_slots == 0 || !host->slots[num])
 		return;
 
-	schedule_work(&host->slots[slot]->switch_work);
+	cover_open = mmc_omap_cover_is_open(slot);
+	if (cover_open != slot->cover_open) {
+		slot->cover_open = cover_open;
+		sysfs_notify(&slot->mmc->class_dev.kobj, NULL, "cover_switch");
+	}
+
+	tasklet_hi_schedule(&slot->cover_tasklet);
 }
 
-static void mmc_omap_switch_timer(unsigned long arg)
+static void mmc_omap_cover_timer(unsigned long arg)
 {
 	struct mmc_omap_slot *slot = (struct mmc_omap_slot *) arg;
-
-	schedule_work(&slot->switch_work);
+	tasklet_schedule(&slot->cover_tasklet);
 }
 
-static void mmc_omap_cover_handler(struct work_struct *work)
+static void mmc_omap_cover_handler(unsigned long param)
 {
-	struct mmc_omap_slot *slot = container_of(work, struct mmc_omap_slot,
-						  switch_work);
-	int cover_open;
+	struct mmc_omap_slot *slot = (struct mmc_omap_slot *)param;
+	int cover_open = mmc_omap_cover_is_open(slot);
 
-	cover_open = mmc_omap_cover_is_open(slot);
-	if (cover_open != slot->cover_open) {
-		sysfs_notify(&slot->mmc->class_dev.kobj, NULL, "cover_switch");
-		slot->cover_open = cover_open;
-		dev_info(mmc_dev(slot->mmc), "cover is now %s\n",
-			 cover_open ? "open" : "closed");
-	}
-	mmc_detect_change(slot->mmc, slot->id);
+	mmc_detect_change(slot->mmc, 0);
+	if (!cover_open)
+		return;
+
+	/*
+	 * If no card is inserted, we postpone polling until
+	 * the cover has been closed.
+	 */
+	if (slot->mmc->card == NULL || !mmc_card_present(slot->mmc->card))
+		return;
+
+	mod_timer(&slot->cover_timer,
+		  jiffies + msecs_to_jiffies(OMAP_MMC_COVER_POLL_DELAY));
 }
 
 /* Prepare to transfer the next segment of a scatterlist */
@@ -1247,10 +1258,11 @@ static int __init mmc_omap_new_slot(stru
 		if (r < 0)
 			goto err_remove_slot_name;
 
-		INIT_WORK(&slot->switch_work, mmc_omap_cover_handler);
-		setup_timer(&slot->switch_timer, mmc_omap_switch_timer,
-			    (unsigned long) slot);
-		schedule_work(&slot->switch_work);
+		setup_timer(&slot->cover_timer, mmc_omap_cover_timer,
+			    (unsigned long)slot);
+		tasklet_init(&slot->cover_tasklet, mmc_omap_cover_handler,
+			     (unsigned long)slot);
+		tasklet_schedule(&slot->cover_tasklet);
 	}
 
 	if (slot->pdata->get_ro != NULL) {
@@ -1285,7 +1297,8 @@ static void mmc_omap_remove_slot(struct 
 	if (slot->pdata->get_ro != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_ro);
 
-	del_timer_sync(&slot->switch_timer);
+	tasklet_kill(&slot->cover_tasklet);
+	del_timer_sync(&slot->cover_timer);
 	flush_scheduled_work();
 
 	mmc_remove_host(mmc);
_

Patches currently in -mm which might be from jarkko.lavinen@nokia.com are

mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch
mmc-omap-move-failing-command-abortion-to-workqueue.patch
mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

