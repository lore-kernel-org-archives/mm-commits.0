From: akpm@linux-foundation.org
Subject: + sdhci-turn-host-lock-into-a-mutex.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:10 -0700
Message-ID: <201007212114.o6LLEAsh015614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758256Ab0GUVPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: turn host->lock into a mutex
has been added to the -mm tree.  Its filename is
     sdhci-turn-host-lock-into-a-mutex.patch

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
Subject: sdhci: turn host->lock into a mutex
From: Anton Vorontsov <avorontsov@mvista.com>

Finally, we can get rid of the host->lock spinlock, and turn it into a
mutex.

This patch does just this.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   53 +++++++++++++++----------------------
 drivers/mmc/host/sdhci.h |    3 +-
 2 files changed, 24 insertions(+), 32 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-turn-host-lock-into-a-mutex drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-turn-host-lock-into-a-mutex
+++ a/drivers/mmc/host/sdhci.c
@@ -20,6 +20,7 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 #include <linux/scatterlist.h>
 
 #include <linux/leds.h>
@@ -228,16 +229,15 @@ static void sdhci_led_control(struct led
 	enum led_brightness brightness)
 {
 	struct sdhci_host *host = container_of(led, struct sdhci_host, led);
-	unsigned long flags;
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (brightness == LED_OFF)
 		sdhci_deactivate_led(host);
 	else
 		sdhci_activate_led(host);
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 #endif
 
@@ -1099,11 +1099,10 @@ static void sdhci_request(struct mmc_hos
 {
 	struct sdhci_host *host;
 	bool present;
-	unsigned long flags;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	WARN_ON(host->mrq != NULL);
 
@@ -1127,18 +1126,17 @@ static void sdhci_request(struct mmc_hos
 		sdhci_send_command(host, mrq->cmd);
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 static void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 	u8 ctrl;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		goto out;
@@ -1189,25 +1187,24 @@ static void sdhci_set_ios(struct mmc_hos
 
 out:
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 static int sdhci_get_ro(struct mmc_host *mmc)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 	int present;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		present = 0;
 	else
 		present = sdhci_readl(host, SDHCI_PRESENT_STATE);
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 
 	if (host->quirks & SDHCI_QUIRK_INVERTED_WRITE_PROTECT)
 		return !!(present & SDHCI_WRITE_PROTECT);
@@ -1217,11 +1214,10 @@ static int sdhci_get_ro(struct mmc_host 
 static void sdhci_enable_sdio_irq(struct mmc_host *mmc, int enable)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 
 	host = mmc_priv(mmc);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->flags & SDHCI_DEVICE_DEAD)
 		goto out;
@@ -1233,7 +1229,7 @@ static void sdhci_enable_sdio_irq(struct
 out:
 	mmiowb();
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 static const struct mmc_host_ops sdhci_ops = {
@@ -1252,11 +1248,10 @@ static const struct mmc_host_ops sdhci_o
 static void sdhci_card_detect_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 
 	host = container_of(wk, struct sdhci_host, card_detect_work);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
 		if (host->mrq) {
@@ -1273,7 +1268,7 @@ static void sdhci_card_detect_work(struc
 		}
 	}
 
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 
 	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
 }
@@ -1281,12 +1276,11 @@ static void sdhci_card_detect_work(struc
 static void sdhci_finish_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 	struct mmc_request *mrq;
 
 	host = container_of(wk, struct sdhci_host, finish_work);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	__cancel_delayed_work(&host->timeout_work);
 
@@ -1327,7 +1321,7 @@ static void sdhci_finish_work(struct wor
 #endif
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 
 	mmc_request_done(host->mmc, mrq);
 }
@@ -1335,11 +1329,10 @@ static void sdhci_finish_work(struct wor
 static void sdhci_timeout_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
-	unsigned long flags;
 
 	host = container_of(wk, struct sdhci_host, timeout_work.work);
 
-	spin_lock_irqsave(&host->lock, flags);
+	mutex_lock(&host->lock);
 
 	if (host->mrq) {
 		printk(KERN_ERR "%s: Timeout waiting for hardware "
@@ -1360,7 +1353,7 @@ static void sdhci_timeout_work(struct wo
 	}
 
 	mmiowb();
-	spin_unlock_irqrestore(&host->lock, flags);
+	mutex_unlock(&host->lock);
 }
 
 /*****************************************************************************\
@@ -1518,7 +1511,7 @@ static irqreturn_t sdhci_irq_thread(int 
 	u32 intmask;
 	int cardint = 0;
 
-	spin_lock(&host->lock);
+	mutex_lock(&host->lock);
 
 	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
 	sdhci_writel(host, intmask, SDHCI_INT_STATUS);
@@ -1557,7 +1550,7 @@ static irqreturn_t sdhci_irq_thread(int 
 
 	mmiowb();
 
-	spin_unlock(&host->lock);
+	mutex_unlock(&host->lock);
 
 	/*
 	 * We have to delay this as it calls back into the driver.
@@ -1823,7 +1816,7 @@ int sdhci_add_host(struct sdhci_host *ho
 		return -ENODEV;
 	}
 
-	spin_lock_init(&host->lock);
+	mutex_init(&host->lock);
 
 	/*
 	 * Maximum number of segments. Depends on if the hardware
@@ -1933,10 +1926,8 @@ EXPORT_SYMBOL_GPL(sdhci_add_host);
 
 void sdhci_remove_host(struct sdhci_host *host, int dead)
 {
-	unsigned long flags;
-
 	if (dead) {
-		spin_lock_irqsave(&host->lock, flags);
+		mutex_lock(&host->lock);
 
 		host->flags |= SDHCI_DEVICE_DEAD;
 
@@ -1948,7 +1939,7 @@ void sdhci_remove_host(struct sdhci_host
 			schedule_work(&host->finish_work);
 		}
 
-		spin_unlock_irqrestore(&host->lock, flags);
+		mutex_unlock(&host->lock);
 	}
 
 	sdhci_disable_card_detection(host);
diff -puN drivers/mmc/host/sdhci.h~sdhci-turn-host-lock-into-a-mutex drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-turn-host-lock-into-a-mutex
+++ a/drivers/mmc/host/sdhci.h
@@ -15,6 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/io.h>
 
 /*
@@ -263,7 +264,7 @@ struct sdhci_host {
 	char   led_name[32];
 #endif
 
-	spinlock_t		lock;		/* Mutex */
+	struct mutex		lock;		/* Mutex */
 
 	int			flags;		/* Host attributes */
 #define SDHCI_USE_SDMA		(1<<0)		/* Host is SDMA capable */
_

Patches currently in -mm which might be from avorontsov@mvista.com are

origin.patch
linux-next.patch
sdhci-pltfm-switch-to-module-device-table-matching.patch
sdhci-pltfm-reorganize-makefile-entries-to-support-soc-devices.patch
sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-turn-timeout-timer-into-delayed-work.patch
sdhci-use-work-structs-instead-of-tasklets.patch
sdhci-clear-interrupt-status-register-just-once.patch
sdhci-use-threaded-irq-handler.patch
sdhci-turn-host-lock-into-a-mutex.patch
sdhci-get-rid-of-card-detect-work.patch
sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
sdhci-use-jiffies-instead-of-a-timeout-counter.patch

