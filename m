From: akpm@linux-foundation.org
Subject: - mmc-omap-add-back-cover-switch-support.patch removed from -mm tree
Date: Wed, 26 Mar 2008 20:17:41 -0700
Message-ID: <200803270317.m2R3Hfav015168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38649 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754420AbYC0DR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 23:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: juha.yrjola@solidboot.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx, jarkko.lavinen@nokia.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: add back cover switch support
has been removed from the -mm tree.  Its filename was
     mmc-omap-add-back-cover-switch-support.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: add back cover switch support
From: Juha Yrjola <juha.yrjola@solidboot.com>

This patch adds back MMC cover switch support in a way that supports multiple
slots.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   92 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 3 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-add-back-cover-switch-support drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-add-back-cover-switch-support
+++ a/drivers/mmc/host/omap.c
@@ -106,6 +106,10 @@ struct mmc_omap_slot {
 	unsigned int		fclk_freq;
 	unsigned		powered:1;
 
+	struct work_struct      switch_work;
+	struct timer_list       switch_timer;
+	unsigned		cover_open;
+
 	struct mmc_request      *mrq;
 	struct mmc_omap_host    *host;
 	struct mmc_host		*mmc;
@@ -226,6 +230,25 @@ static void mmc_omap_release_slot(struct
 	spin_unlock_irqrestore(&host->slot_lock, flags);
 }
 
+static inline
+int mmc_omap_cover_is_open(struct mmc_omap_slot *slot)
+{
+	return slot->pdata->get_cover_state(mmc_dev(slot->mmc), slot->id);
+}
+
+static ssize_t
+mmc_omap_show_cover_switch(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct mmc_host *mmc = container_of(dev, struct mmc_host, class_dev);
+	struct mmc_omap_slot *slot = mmc_priv(mmc);
+
+	return sprintf(buf, "%s\n", mmc_omap_cover_is_open(slot) ? "open" :
+		       "closed");
+}
+
+static DEVICE_ATTR(cover_switch, S_IRUGO, mmc_omap_show_cover_switch, NULL);
+
 static ssize_t
 mmc_omap_show_slot_name(struct device *dev, struct device_attribute *attr,
 			char *buf)
@@ -544,9 +567,10 @@ static irqreturn_t mmc_omap_irq(int irq,
 			if (host->cmd) {
 				struct mmc_omap_slot *slot =
 					host->current_slot;
-				dev_err(mmc_dev(host->mmc),
-					"command timeout, CMD %d\n",
-					host->cmd->opcode);
+				if (!mmc_omap_cover_is_open(slot))
+					dev_err(mmc_dev(host->mmc),
+						"command timeout, CMD %d\n",
+						host->cmd->opcode);
 				host->cmd->error = -ETIMEDOUT;
 				end_command = 1;
 			}
@@ -592,6 +616,42 @@ static irqreturn_t mmc_omap_irq(int irq,
 	return IRQ_HANDLED;
 }
 
+void omap_mmc_notify_cover_event(struct device *dev, int slot, int is_closed)
+{
+	struct mmc_omap_host *host = dev_get_drvdata(dev);
+
+	BUG_ON(slot >= host->nr_slots);
+
+	/* Other subsystems can call in here before we're initialised. */
+	if (host->nr_slots == 0 || !host->slots[slot])
+		return;
+
+	schedule_work(&host->slots[slot]->switch_work);
+}
+
+static void mmc_omap_switch_timer(unsigned long arg)
+{
+	struct mmc_omap_slot *slot = (struct mmc_omap_slot *) arg;
+
+	schedule_work(&slot->switch_work);
+}
+
+static void mmc_omap_cover_handler(struct work_struct *work)
+{
+	struct mmc_omap_slot *slot = container_of(work, struct mmc_omap_slot,
+						  switch_work);
+	int cover_open;
+
+	cover_open = mmc_omap_cover_is_open(slot);
+	if (cover_open != slot->cover_open) {
+		sysfs_notify(&slot->mmc->class_dev.kobj, NULL, "cover_switch");
+		slot->cover_open = cover_open;
+		dev_info(mmc_dev(slot->mmc), "cover is now %s\n",
+			 cover_open ? "open" : "closed");
+	}
+	mmc_detect_change(slot->mmc, slot->id);
+}
+
 /* Prepare to transfer the next segment of a scatterlist */
 static void
 mmc_omap_prepare_dma(struct mmc_omap_host *host, struct mmc_data *data)
@@ -1072,13 +1132,34 @@ static int __init mmc_omap_new_slot(stru
 			goto err_remove_host;
 	}
 
+	if (slot->pdata->get_cover_state != NULL) {
+		r = device_create_file(&mmc->class_dev,
+					&dev_attr_cover_switch);
+		if (r < 0)
+			goto err_remove_slot_name;
+
+		INIT_WORK(&slot->switch_work, mmc_omap_cover_handler);
+		init_timer(&slot->switch_timer);
+		slot->switch_timer.function = mmc_omap_switch_timer;
+		slot->switch_timer.data = (unsigned long) slot;
+		schedule_work(&slot->switch_work);
+	}
+
 	if (slot->pdata->get_ro != NULL) {
 		r = device_create_file(&mmc->class_dev,
 					&dev_attr_ro);
+		if (r < 0)
+			goto err_remove_cover_attr;
 	}
 
 	return 0;
 
+err_remove_cover_attr:
+	if (slot->pdata->get_cover_state != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_cover_switch);
+err_remove_slot_name:
+	if (slot->pdata->name != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_ro);
 err_remove_host:
 	mmc_remove_host(mmc);
 	mmc_free_host(mmc);
@@ -1091,9 +1172,14 @@ static void mmc_omap_remove_slot(struct 
 
 	if (slot->pdata->name != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_slot_name);
+	if (slot->pdata->get_cover_state != NULL)
+		device_remove_file(&mmc->class_dev, &dev_attr_cover_switch);
 	if (slot->pdata->get_ro != NULL)
 		device_remove_file(&mmc->class_dev, &dev_attr_ro);
 
+	del_timer_sync(&slot->switch_timer);
+	flush_scheduled_work();
+
 	mmc_remove_host(mmc);
 	mmc_free_host(mmc);
 }
_

Patches currently in -mm which might be from juha.yrjola@solidboot.com are

mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch

