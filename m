From: akpm@linux-foundation.org
Subject: + mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support.patch added to -mm tree
Date: Mon, 17 Mar 2008 15:27:13 -0700
Message-ID: <200803172227.m2HMRDHm001525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753074AbYCQW10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 18:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@atomide.com, carlos.aguiar@indt.org.br, drzeus-list@drzeus.cx


The patch titled
     mmc: omap: remove cover switch handling to allow adding multislot support
has been added to the -mm tree.  Its filename is
     mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: remove cover switch handling to allow adding multislot support
From: Tony Lindgren <tony@atomide.com>

This patch removes the MMC cover switch handling temporarily to make following
multislot patches cleaner.

MMC cover switch handling will be added back in later patches after adding
basic multislot support.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Carlos Eduardo Aguiar <carlos.aguiar@indt.org.br>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |  152 --------------------------------------
 1 file changed, 1 insertion(+), 151 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support
+++ a/drivers/mmc/host/omap.c
@@ -95,8 +95,6 @@
  * when the cover switch is open */
 #define OMAP_MMC_SWITCH_POLL_DELAY	500
 
-static int mmc_omap_enable_poll = 1;
-
 struct mmc_omap_host {
 	int			initialized;
 	int			suspended;
@@ -133,62 +131,11 @@ struct mmc_omap_host {
 	short			power_pin;
 	short			wp_pin;
 
-	int			switch_pin;
 	struct work_struct	switch_work;
 	struct timer_list	switch_timer;
 	int			switch_last_state;
 };
 
-static inline int
-mmc_omap_cover_is_open(struct mmc_omap_host *host)
-{
-	if (host->switch_pin < 0)
-		return 0;
-	return omap_get_gpio_datain(host->switch_pin);
-}
-
-static ssize_t
-mmc_omap_show_cover_switch(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	struct mmc_omap_host *host = dev_get_drvdata(dev);
-
-	return sprintf(buf, "%s\n", mmc_omap_cover_is_open(host) ? "open" :
-			"closed");
-}
-
-static DEVICE_ATTR(cover_switch, S_IRUGO, mmc_omap_show_cover_switch, NULL);
-
-static ssize_t
-mmc_omap_show_enable_poll(struct device *dev,
-	struct device_attribute *attr, char *buf)
-{
-	return snprintf(buf, PAGE_SIZE, "%d\n", mmc_omap_enable_poll);
-}
-
-static ssize_t
-mmc_omap_store_enable_poll(struct device *dev,
-	struct device_attribute *attr, const char *buf,
-	size_t size)
-{
-	int enable_poll;
-
-	if (sscanf(buf, "%10d", &enable_poll) != 1)
-		return -EINVAL;
-
-	if (enable_poll != mmc_omap_enable_poll) {
-		struct mmc_omap_host *host = dev_get_drvdata(dev);
-
-		mmc_omap_enable_poll = enable_poll;
-		if (enable_poll && host->switch_pin >= 0)
-			schedule_work(&host->switch_work);
-	}
-	return size;
-}
-
-static DEVICE_ATTR(enable_poll, 0664,
-		   mmc_omap_show_enable_poll, mmc_omap_store_enable_poll);
-
 static void
 mmc_omap_start_command(struct mmc_omap_host *host, struct mmc_command *cmd)
 {
@@ -495,8 +442,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 		if (status & OMAP_MMC_STAT_CMD_TOUT) {
 			/* Timeouts are routine with some commands */
 			if (host->cmd) {
-				if (!mmc_omap_cover_is_open(host))
-					dev_err(mmc_dev(host->mmc),
+				dev_err(mmc_dev(host->mmc),
 					"command timeout, CMD %d\n",
 					host->cmd->opcode);
 				host->cmd->error = -ETIMEDOUT;
@@ -544,54 +490,6 @@ static irqreturn_t mmc_omap_irq(int irq,
 	return IRQ_HANDLED;
 }
 
-static irqreturn_t mmc_omap_switch_irq(int irq, void *dev_id)
-{
-	struct mmc_omap_host *host = (struct mmc_omap_host *) dev_id;
-
-	schedule_work(&host->switch_work);
-
-	return IRQ_HANDLED;
-}
-
-static void mmc_omap_switch_timer(unsigned long arg)
-{
-	struct mmc_omap_host *host = (struct mmc_omap_host *) arg;
-
-	schedule_work(&host->switch_work);
-}
-
-static void mmc_omap_switch_handler(struct work_struct *work)
-{
-	struct mmc_omap_host *host = container_of(work, struct mmc_omap_host, switch_work);
-	struct mmc_card *card;
-	static int complained = 0;
-	int cards = 0, cover_open;
-
-	if (host->switch_pin == -1)
-		return;
-	cover_open = mmc_omap_cover_is_open(host);
-	if (cover_open != host->switch_last_state) {
-		kobject_uevent(&host->dev->kobj, KOBJ_CHANGE);
-		host->switch_last_state = cover_open;
-	}
-	mmc_detect_change(host->mmc, 0);
-	list_for_each_entry(card, &host->mmc->cards, node) {
-		if (mmc_card_present(card))
-			cards++;
-	}
-	if (mmc_omap_cover_is_open(host)) {
-		if (!complained) {
-			dev_info(mmc_dev(host->mmc), "cover is open\n");
-			complained = 1;
-		}
-		if (mmc_omap_enable_poll)
-			mod_timer(&host->switch_timer, jiffies +
-				msecs_to_jiffies(OMAP_MMC_SWITCH_POLL_DELAY));
-	} else {
-		complained = 0;
-	}
-}
-
 /* Prepare to transfer the next segment of a scatterlist */
 static void
 mmc_omap_prepare_dma(struct mmc_omap_host *host, struct mmc_data *data)
@@ -1057,7 +955,6 @@ static int __init mmc_omap_probe(struct 
 	 * the card detect sensing.
 	 */
 	host->power_pin = minfo->power_pin;
-	host->switch_pin = minfo->switch_pin;
 	host->wp_pin = minfo->wp_pin;
 	host->use_dma = 1;
 	host->dma_ch = -1;
@@ -1102,48 +999,10 @@ static int __init mmc_omap_probe(struct 
 	host->dev = &pdev->dev;
 	platform_set_drvdata(pdev, host);
 
-	if (host->switch_pin >= 0) {
-		INIT_WORK(&host->switch_work, mmc_omap_switch_handler);
-		init_timer(&host->switch_timer);
-		host->switch_timer.function = mmc_omap_switch_timer;
-		host->switch_timer.data = (unsigned long) host;
-		if (omap_request_gpio(host->switch_pin) != 0) {
-			dev_warn(mmc_dev(host->mmc), "Unable to get GPIO pin for MMC cover switch\n");
-			host->switch_pin = -1;
-			goto no_switch;
-		}
-
-		omap_set_gpio_direction(host->switch_pin, 1);
-		ret = request_irq(OMAP_GPIO_IRQ(host->switch_pin),
-				  mmc_omap_switch_irq, IRQF_TRIGGER_RISING, DRIVER_NAME, host);
-		if (ret) {
-			dev_warn(mmc_dev(host->mmc), "Unable to get IRQ for MMC cover switch\n");
-			omap_free_gpio(host->switch_pin);
-			host->switch_pin = -1;
-			goto no_switch;
-		}
-		ret = device_create_file(&pdev->dev, &dev_attr_cover_switch);
-		if (ret == 0) {
-			ret = device_create_file(&pdev->dev, &dev_attr_enable_poll);
-			if (ret != 0)
-				device_remove_file(&pdev->dev, &dev_attr_cover_switch);
-		}
-		if (ret) {
-			dev_warn(mmc_dev(host->mmc), "Unable to create sysfs attributes\n");
-			free_irq(OMAP_GPIO_IRQ(host->switch_pin), host);
-			omap_free_gpio(host->switch_pin);
-			host->switch_pin = -1;
-			goto no_switch;
-		}
-		if (mmc_omap_enable_poll && mmc_omap_cover_is_open(host))
-			schedule_work(&host->switch_work);
-	}
-
 	mmc_add_host(mmc);
 
 	return 0;
 
-no_switch:
 	/* FIXME: Free other resources too. */
 	if (host) {
 		if (host->iclk && !IS_ERR(host->iclk))
@@ -1182,15 +1041,6 @@ static int mmc_omap_remove(struct platfo
 
 	if (host->power_pin >= 0)
 		omap_free_gpio(host->power_pin);
-	if (host->switch_pin >= 0) {
-		device_remove_file(&pdev->dev, &dev_attr_enable_poll);
-		device_remove_file(&pdev->dev, &dev_attr_cover_switch);
-		free_irq(OMAP_GPIO_IRQ(host->switch_pin), host);
-		omap_free_gpio(host->switch_pin);
-		host->switch_pin = -1;
-		del_timer_sync(&host->switch_timer);
-		flush_scheduled_work();
-	}
 	if (host->iclk && !IS_ERR(host->iclk))
 		clk_put(host->iclk);
 	if (host->fclk && !IS_ERR(host->fclk))
_

Patches currently in -mm which might be from tony@atomide.com are

git-arm-master.patch
mmc-omap-remove-some-opcodes-from-host-driver.patch
mmc-omap-remove-extra-divisor-increase.patch
mmc-omap-fix-the-byteblock-capability-removal.patch
mmc-omap-remove-cover-switch-handling-to-allow-adding-multislot-support.patch
mmc-omap-introduce-new-multislot-structure-and-change-driver-to-use-it.patch
mmc-omap-add-back-cover-switch-support.patch
mmc-omap-new-release-dma-and-abort-xfer-functions.patch
mmc-omap-fix-timeout-calculation-for-mmc-multislot-support.patch
mmc-omap-power-functions-modified-to-mmc-multislot-support.patch
mmc-omap-general-cleanup-for-mmc-multislot-support.patch
mmc-omap-abort-stuck-commands.patch
mmc-omap-using-setup_timer-instead-of-init_timer.patch
mmc-omap-check-the-get_cover_state-function-pointer-if-not-set.patch
mmc-omap-use-tasklet-instead-of-workqueue-for-cover-switch-notification.patch
mmc-omap-move-failing-command-abortion-to-workqueue.patch
mmc-omap-lazy-clock-shutdown.patch
mmc-omap-start-new-commands-from-work-queue-instead-of-irq.patch
mmc-omap-do-not-busy-wait-for-end-of-command-for-ever.patch

