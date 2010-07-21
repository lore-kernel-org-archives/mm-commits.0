From: akpm@linux-foundation.org
Subject: + sdhci-use-work-structs-instead-of-tasklets.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:04 -0700
Message-ID: <201007212114.o6LLE4m8015595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758234Ab0GUVPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: use work structs instead of tasklets
has been added to the -mm tree.  Its filename is
     sdhci-use-work-structs-instead-of-tasklets.patch

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
Subject: sdhci: use work structs instead of tasklets
From: Anton Vorontsov <avorontsov@mvista.com>

The driver can happily live without an atomic context and tasklets, so
turn the tasklets into work structs.

Tasklet handlers still grab irqsave spinlocks, but we'll deal with it in
a separate patch.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   48 ++++++++++++++++---------------------
 drivers/mmc/host/sdhci.h |    4 +--
 2 files changed, 23 insertions(+), 29 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-use-work-structs-instead-of-tasklets drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-use-work-structs-instead-of-tasklets
+++ a/drivers/mmc/host/sdhci.c
@@ -872,7 +872,7 @@ static void sdhci_finish_data(struct sdh
 
 		sdhci_send_command(host, data->stop);
 	} else
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 }
 
 static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
@@ -901,7 +901,7 @@ static void sdhci_send_command(struct sd
 				"inhibit bit(s).\n", mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
 			cmd->error = -EIO;
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 			return;
 		}
 		timeout--;
@@ -922,7 +922,7 @@ static void sdhci_send_command(struct sd
 		printk(KERN_ERR "%s: Unsupported response type!\n",
 			mmc_hostname(host->mmc));
 		cmd->error = -EINVAL;
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 		return;
 	}
 
@@ -973,7 +973,7 @@ static void sdhci_finish_command(struct 
 		sdhci_finish_data(host);
 
 	if (!host->cmd->data)
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 
 	host->cmd = NULL;
 }
@@ -1122,7 +1122,7 @@ static void sdhci_request(struct mmc_hos
 
 	if (!present || host->flags & SDHCI_DEVICE_DEAD) {
 		host->mrq->cmd->error = -ENOMEDIUM;
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 	} else
 		sdhci_send_command(host, mrq->cmd);
 
@@ -1245,16 +1245,16 @@ static const struct mmc_host_ops sdhci_o
 
 /*****************************************************************************\
  *                                                                           *
- * Tasklets                                                                  *
+ * Work handlers                                                             *
  *                                                                           *
 \*****************************************************************************/
 
-static void sdhci_tasklet_card(unsigned long param)
+static void sdhci_card_detect_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
 
-	host = (struct sdhci_host*)param;
+	host = container_of(wk, struct sdhci_host, card_detect_work);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1269,7 +1269,7 @@ static void sdhci_tasklet_card(unsigned 
 			sdhci_reset(host, SDHCI_RESET_DATA);
 
 			host->mrq->cmd->error = -ENOMEDIUM;
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 		}
 	}
 
@@ -1278,13 +1278,13 @@ static void sdhci_tasklet_card(unsigned 
 	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
 }
 
-static void sdhci_tasklet_finish(unsigned long param)
+static void sdhci_finish_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
 	struct mmc_request *mrq;
 
-	host = (struct sdhci_host*)param;
+	host = container_of(wk, struct sdhci_host, finish_work);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1355,7 +1355,7 @@ static void sdhci_timeout_work(struct wo
 			else
 				host->mrq->cmd->error = -ETIMEDOUT;
 
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 		}
 	}
 
@@ -1388,7 +1388,7 @@ static void sdhci_cmd_irq(struct sdhci_h
 		host->cmd->error = -EILSEQ;
 
 	if (host->cmd->error) {
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 		return;
 	}
 
@@ -1534,7 +1534,7 @@ static irqreturn_t sdhci_irq(int irq, vo
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE)) {
 		sdhci_writel(host, intmask & (SDHCI_INT_CARD_INSERT |
 			SDHCI_INT_CARD_REMOVE), SDHCI_INT_STATUS);
-		tasklet_schedule(&host->card_tasklet);
+		schedule_work(&host->card_detect_work);
 	}
 
 	intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
@@ -1879,19 +1879,17 @@ int sdhci_add_host(struct sdhci_host *ho
 	mmc->max_blk_count = (host->quirks & SDHCI_QUIRK_NO_MULTIBLOCK) ? 1 : 65535;
 
 	/*
-	 * Init tasklets.
+	 * Init work structs.
 	 */
-	tasklet_init(&host->card_tasklet,
-		sdhci_tasklet_card, (unsigned long)host);
-	tasklet_init(&host->finish_tasklet,
-		sdhci_tasklet_finish, (unsigned long)host);
+	INIT_WORK(&host->card_detect_work, sdhci_card_detect_work);
+	INIT_WORK(&host->finish_work, sdhci_finish_work);
 
 	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
 
 	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
 		mmc_hostname(mmc), host);
 	if (ret)
-		goto untasklet;
+		return ret;
 
 	sdhci_init(host, 0);
 
@@ -1930,10 +1928,6 @@ reset:
 	sdhci_reset(host, SDHCI_RESET_ALL);
 	free_irq(host->irq, host);
 #endif
-untasklet:
-	tasklet_kill(&host->card_tasklet);
-	tasklet_kill(&host->finish_tasklet);
-
 	return ret;
 }
 
@@ -1953,7 +1947,7 @@ void sdhci_remove_host(struct sdhci_host
 				" transfer!\n", mmc_hostname(host->mmc));
 
 			host->mrq->cmd->error = -ENOMEDIUM;
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 		}
 
 		spin_unlock_irqrestore(&host->lock, flags);
@@ -1974,8 +1968,8 @@ void sdhci_remove_host(struct sdhci_host
 
 	flush_delayed_work(&host->timeout_work);
 
-	tasklet_kill(&host->card_tasklet);
-	tasklet_kill(&host->finish_tasklet);
+	flush_work(&host->card_detect_work);
+	flush_work(&host->finish_work);
 
 	kfree(host->adma_desc);
 	kfree(host->align_buffer);
diff -puN drivers/mmc/host/sdhci.h~sdhci-use-work-structs-instead-of-tasklets drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-use-work-structs-instead-of-tasklets
+++ a/drivers/mmc/host/sdhci.h
@@ -295,8 +295,8 @@ struct sdhci_host {
 	dma_addr_t		adma_addr;	/* Mapped ADMA descr. table */
 	dma_addr_t		align_addr;	/* Mapped bounce buffer */
 
-	struct tasklet_struct	card_tasklet;	/* Tasklet structures */
-	struct tasklet_struct	finish_tasklet;
+	struct work_struct	card_detect_work;
+	struct work_struct	finish_work;
 
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

