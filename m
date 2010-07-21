From: akpm@linux-foundation.org
Subject: + sdhci-use-threaded-irq-handler.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:08 -0700
Message-ID: <201007212114.o6LLE8WY015606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758385Ab0GUVPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: use threaded IRQ handler
has been added to the -mm tree.  Its filename is
     sdhci-use-threaded-irq-handler.patch

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
Subject: sdhci: use threaded IRQ handler
From: Anton Vorontsov <avorontsov@mvista.com>

We only need atomic context to disable SDHCI interrupts, after that we can
run in a kernel thread.

Note that irq handler still grabs an irqsave spinlock, we'll deal with it
in a subsequent patch.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   47 ++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 19 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-use-threaded-irq-handler drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-use-threaded-irq-handler
+++ a/drivers/mmc/host/sdhci.c
@@ -1512,9 +1512,8 @@ static void sdhci_data_irq(struct sdhci_
 	}
 }
 
-static irqreturn_t sdhci_irq(int irq, void *dev_id)
+static irqreturn_t sdhci_irq_thread(int irq, void *dev_id)
 {
-	irqreturn_t result;
 	struct sdhci_host* host = dev_id;
 	u32 intmask;
 	int cardint = 0;
@@ -1522,17 +1521,8 @@ static irqreturn_t sdhci_irq(int irq, vo
 	spin_lock(&host->lock);
 
 	intmask = sdhci_readl(host, SDHCI_INT_STATUS);
-
-	if (!intmask || intmask == 0xffffffff) {
-		result = IRQ_NONE;
-		goto out;
-	}
-
 	sdhci_writel(host, intmask, SDHCI_INT_STATUS);
 
-	DBG("*** %s got interrupt: 0x%08x\n",
-		mmc_hostname(host->mmc), intmask);
-
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE))
 		schedule_work(&host->card_detect_work);
 
@@ -1565,10 +1555,8 @@ static irqreturn_t sdhci_irq(int irq, vo
 		sdhci_dumpregs(host);
 	}
 
-	result = IRQ_HANDLED;
-
 	mmiowb();
-out:
+
 	spin_unlock(&host->lock);
 
 	/*
@@ -1577,7 +1565,28 @@ out:
 	if (cardint)
 		mmc_signal_sdio_irq(host->mmc);
 
-	return result;
+	/* Restore interrupts */
+	intmask = sdhci_readl(host, SDHCI_INT_ENABLE);
+	sdhci_writel(host, intmask, SDHCI_SIGNAL_ENABLE);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t sdhci_irq(int irq, void *dev_id)
+{
+	struct sdhci_host *host = dev_id;
+	u32 intmask = sdhci_readl(host, SDHCI_INT_STATUS);
+
+	if (!intmask || intmask == 0xffffffff)
+		return IRQ_NONE;
+
+	/* Disable interrupts */
+	sdhci_writel(host, 0, SDHCI_SIGNAL_ENABLE);
+
+	DBG("*** %s got interrupt: 0x%08x\n",
+		mmc_hostname(host->mmc), intmask);
+
+	return IRQ_WAKE_THREAD;
 }
 
 /*****************************************************************************\
@@ -1614,8 +1623,8 @@ int sdhci_resume_host(struct sdhci_host 
 			host->ops->enable_dma(host);
 	}
 
-	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
-			  mmc_hostname(host->mmc), host);
+	ret = request_threaded_irq(host->irq, sdhci_irq, sdhci_irq_thread,
+			  IRQF_SHARED, mmc_hostname(host->mmc), host);
 	if (ret)
 		return ret;
 
@@ -1875,8 +1884,8 @@ int sdhci_add_host(struct sdhci_host *ho
 
 	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
 
-	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
-		mmc_hostname(mmc), host);
+	ret = request_threaded_irq(host->irq, sdhci_irq, sdhci_irq_thread,
+			  IRQF_SHARED, mmc_hostname(host->mmc), host);
 	if (ret)
 		return ret;
 
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

