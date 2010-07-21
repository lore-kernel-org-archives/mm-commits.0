From: akpm@linux-foundation.org
Subject: + sdhci-get-rid-of-card-detect-work.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:12 -0700
Message-ID: <201007212114.o6LLECHQ015617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059Ab0GUVPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: get rid of card detect work
has been added to the -mm tree.  Its filename is
     sdhci-get-rid-of-card-detect-work.patch

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
Subject: sdhci: get rid of card detect work
From: Anton Vorontsov <avorontsov@mvista.com>

Nowadays we can just call the card detection handler directly, no need for
the separate work struct.

We still need host->finish_work as sdhci_finish_work() calls
mmc_request_done(), which tries to re-enter the driver.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   14 ++------------
 drivers/mmc/host/sdhci.h |    1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-get-rid-of-card-detect-work drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-get-rid-of-card-detect-work
+++ a/drivers/mmc/host/sdhci.c
@@ -1245,14 +1245,8 @@ static const struct mmc_host_ops sdhci_o
  *                                                                           *
 \*****************************************************************************/
 
-static void sdhci_card_detect_work(struct work_struct *wk)
+static void sdhci_card_detect(struct sdhci_host *host)
 {
-	struct sdhci_host *host;
-
-	host = container_of(wk, struct sdhci_host, card_detect_work);
-
-	mutex_lock(&host->lock);
-
 	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
 		if (host->mrq) {
 			printk(KERN_ERR "%s: Card removed during transfer!\n",
@@ -1268,8 +1262,6 @@ static void sdhci_card_detect_work(struc
 		}
 	}
 
-	mutex_unlock(&host->lock);
-
 	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
 }
 
@@ -1517,7 +1509,7 @@ static irqreturn_t sdhci_irq_thread(int 
 	sdhci_writel(host, intmask, SDHCI_INT_STATUS);
 
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE))
-		schedule_work(&host->card_detect_work);
+		sdhci_card_detect(host);
 
 	intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
 
@@ -1872,7 +1864,6 @@ int sdhci_add_host(struct sdhci_host *ho
 	/*
 	 * Init work structs.
 	 */
-	INIT_WORK(&host->card_detect_work, sdhci_card_detect_work);
 	INIT_WORK(&host->finish_work, sdhci_finish_work);
 
 	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
@@ -1957,7 +1948,6 @@ void sdhci_remove_host(struct sdhci_host
 
 	flush_delayed_work(&host->timeout_work);
 
-	flush_work(&host->card_detect_work);
 	flush_work(&host->finish_work);
 
 	kfree(host->adma_desc);
diff -puN drivers/mmc/host/sdhci.h~sdhci-get-rid-of-card-detect-work drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-get-rid-of-card-detect-work
+++ a/drivers/mmc/host/sdhci.h
@@ -296,7 +296,6 @@ struct sdhci_host {
 	dma_addr_t		adma_addr;	/* Mapped ADMA descr. table */
 	dma_addr_t		align_addr;	/* Mapped bounce buffer */
 
-	struct work_struct	card_detect_work;
 	struct work_struct	finish_work;
 
 	struct delayed_work	timeout_work;	/* Work for timeouts */
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

