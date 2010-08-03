From: akpm@linux-foundation.org
Subject: + sdhci-use-work-structs-instead-of-tasklets-fix.patch added to -mm tree
Date: Tue, 03 Aug 2010 13:21:39 -0700
Message-ID: <201008032021.o73KLdY6009190@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757621Ab0HCUXX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 16:23:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cbouatmailru@gmail.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci-use-work-structs-instead-of-tasklets-fix
has been added to the -mm tree.  Its filename is
     sdhci-use-work-structs-instead-of-tasklets-fix.patch

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
Subject: sdhci-use-work-structs-instead-of-tasklets-fix
From: Anton Vorontsov <cbouatmailru@gmail.com>

On Mon, Aug 02, 2010 at 07:15:50PM +0200, Albert Herranz wrote:
> On 08/02/2010 06:49 PM, Anton Vorontsov wrote:
> > I don't see any abba deadlocks, so maybe there's some thread
> > looping for some register change?
> >
> > The only difference in IRQ handling I see is mmiowb() calls
> > after IRQ handlers.
> >
> > Maybe this patch will help?
> >
> > diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> > index 7965b70..449dcb7 100644
> > --- a/drivers/net/wireless/b43/main.c
> > +++ b/drivers/net/wireless/b43/main.c
> > @@ -1952,8 +1952,11 @@ static void b43_sdio_interrupt_handler(struct b43_wldev *dev)
> >  	mutex_lock(&wl->mutex);
> >
> >  	ret = b43_do_interrupt(dev);
> > -	if (ret == IRQ_WAKE_THREAD)
> > +	mmiowb();
> > +	if (ret == IRQ_WAKE_THREAD) {
> >  		b43_do_interrupt_thread(dev);
> > +		mmiowb();
> > +	}
> >
> >  	mutex_unlock(&wl->mutex);
> >  }
> >
>
> Nope, that didn't help.
>
> I see that the sdio irq thread is waiting for a
> MMC command to finish, which never finishes.
> Maybe the problem is that the work struct associated
> to that MMC command for some reason can't run now (but did run when a tasklet was used), and that causes the locking on the MMC subsystem and on the wireless stack (because the irq thread holds &wl->mutex).

Ah! I think I know what is happening. Something in a
kernel-global workqueue is waiting for other thing
that is also in a kernel-global workqueue?

For such cases we have to make our own workqueues.

Albert, totally untested patch, but I believe it
will solve the issue.

Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   26 +++++++++++++++-----------
 drivers/mmc/host/sdhci.h |    1 +
 2 files changed, 16 insertions(+), 11 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-use-work-structs-instead-of-tasklets-fix drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-use-work-structs-instead-of-tasklets-fix
+++ a/drivers/mmc/host/sdhci.c
@@ -872,7 +872,7 @@ static void sdhci_finish_data(struct sdh
 
 		sdhci_send_command(host, data->stop);
 	} else
-		schedule_work(&host->finish_work);
+		queue_work(host->wq, &host->finish_work);
 }
 
 static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
@@ -901,14 +901,14 @@ static void sdhci_send_command(struct sd
 				"inhibit bit(s).\n", mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
 			cmd->error = -EIO;
-			schedule_work(&host->finish_work);
+			queue_work(host->wq, &host->finish_work);
 			return;
 		}
 		timeout--;
 		mdelay(1);
 	}
 
-	schedule_delayed_work(&host->timeout_work, 10 * HZ);
+	queue_delayed_work(host->wq, &host->timeout_work, 10 * HZ);
 
 	host->cmd = cmd;
 
@@ -922,7 +922,7 @@ static void sdhci_send_command(struct sd
 		printk(KERN_ERR "%s: Unsupported response type!\n",
 			mmc_hostname(host->mmc));
 		cmd->error = -EINVAL;
-		schedule_work(&host->finish_work);
+		queue_work(host->wq, &host->finish_work);
 		return;
 	}
 
@@ -973,7 +973,7 @@ static void sdhci_finish_command(struct 
 		sdhci_finish_data(host);
 
 	if (!host->cmd->data)
-		schedule_work(&host->finish_work);
+		queue_work(host->wq, &host->finish_work);
 
 	host->cmd = NULL;
 }
@@ -1122,7 +1122,7 @@ static void sdhci_request(struct mmc_hos
 
 	if (!present || host->flags & SDHCI_DEVICE_DEAD) {
 		host->mrq->cmd->error = -ENOMEDIUM;
-		schedule_work(&host->finish_work);
+		queue_work(host->wq, &host->finish_work);
 	} else
 		sdhci_send_command(host, mrq->cmd);
 
@@ -1269,7 +1269,7 @@ static void sdhci_card_detect_work(struc
 			sdhci_reset(host, SDHCI_RESET_DATA);
 
 			host->mrq->cmd->error = -ENOMEDIUM;
-			schedule_work(&host->finish_work);
+			queue_work(host->wq, &host->finish_work);
 		}
 	}
 
@@ -1355,7 +1355,7 @@ static void sdhci_timeout_work(struct wo
 			else
 				host->mrq->cmd->error = -ETIMEDOUT;
 
-			schedule_work(&host->finish_work);
+			queue_work(host->wq, &host->finish_work);
 		}
 	}
 
@@ -1388,7 +1388,7 @@ static void sdhci_cmd_irq(struct sdhci_h
 		host->cmd->error = -EILSEQ;
 
 	if (host->cmd->error) {
-		schedule_work(&host->finish_work);
+		queue_work(host->wq, &host->finish_work);
 		return;
 	}
 
@@ -1534,7 +1534,7 @@ static irqreturn_t sdhci_irq(int irq, vo
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE)) {
 		sdhci_writel(host, intmask & (SDHCI_INT_CARD_INSERT |
 			SDHCI_INT_CARD_REMOVE), SDHCI_INT_STATUS);
-		schedule_work(&host->card_detect_work);
+		queue_work(host->wq, &host->card_detect_work);
 	}
 
 	intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
@@ -1878,6 +1878,8 @@ int sdhci_add_host(struct sdhci_host *ho
 	 */
 	mmc->max_blk_count = (host->quirks & SDHCI_QUIRK_NO_MULTIBLOCK) ? 1 : 65535;
 
+	host->wq = create_workqueue(mmc_hostname(mmc));
+
 	/*
 	 * Init work structs.
 	 */
@@ -1947,7 +1949,7 @@ void sdhci_remove_host(struct sdhci_host
 				" transfer!\n", mmc_hostname(host->mmc));
 
 			host->mrq->cmd->error = -ENOMEDIUM;
-			schedule_work(&host->finish_work);
+			queue_work(host->wq, &host->finish_work);
 		}
 
 		spin_unlock_irqrestore(&host->lock, flags);
@@ -1971,6 +1973,8 @@ void sdhci_remove_host(struct sdhci_host
 	flush_work(&host->card_detect_work);
 	flush_work(&host->finish_work);
 
+	destroy_workqueue(host->wq);
+
 	kfree(host->adma_desc);
 	kfree(host->align_buffer);
 
diff -puN drivers/mmc/host/sdhci.h~sdhci-use-work-structs-instead-of-tasklets-fix drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-use-work-structs-instead-of-tasklets-fix
+++ a/drivers/mmc/host/sdhci.h
@@ -293,6 +293,7 @@ struct sdhci_host {
 	dma_addr_t		adma_addr;	/* Mapped ADMA descr. table */
 	dma_addr_t		align_addr;	/* Mapped bounce buffer */
 
+	struct workqueue_struct	*wq;
 	struct work_struct	card_detect_work;
 	struct work_struct	finish_work;
 
_

Patches currently in -mm which might be from cbouatmailru@gmail.com are

linux-next.patch
drivers-power-ds2782_batteryc-fix-ds2782-battery-driver-units.patch
mtdpart-memory-accessor-interface-for-mtd-layer.patch
sdhci-use-work-structs-instead-of-tasklets-fix.patch
edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers-fix.patch

