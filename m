From: akpm@linux-foundation.org
Subject: + sdhci-turn-timeout-timer-into-delayed-work.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:03 -0700
Message-ID: <201007212114.o6LLE3DG015592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758103Ab0GUVPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: turn timeout timer into delayed work
has been added to the -mm tree.  Its filename is
     sdhci-turn-timeout-timer-into-delayed-work.patch

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
Subject: sdhci: turn timeout timer into delayed work
From: Anton Vorontsov <avorontsov@mvista.com>

Currently the sdhci driver does everything in the atomic context.  And
what is worse, PIO transfers are made from the IRQ handler.

This causes huge latencies (up to 120 ms).  On some P2020 SOCs, DMA and
card detection is broken, which means that kernel polls for the card via
PIO transfers every second.  Needless to say that this is quite bad.

So, this patchset reworks sdhci code to avoid atomic context, almost
completely.  We only do two device memory operations in the atomic
context, and all the rest is threaded.

I noticed no throughput drop neither with PIO transfers nor with DMA
(tested on MPC8569E CPU), while latencies should be greatly improved.


This patch:

There is no need for the timeout handler to run in the atomic context, so
this patch turns the timeout timer into a delayed work.

Note that the timeout handler still grabs an irqsave spinlock, we'll deal
with it in a separate patch.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   14 ++++++++------
 drivers/mmc/host/sdhci.h |    3 ++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-turn-timeout-timer-into-delayed-work drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-turn-timeout-timer-into-delayed-work
+++ a/drivers/mmc/host/sdhci.c
@@ -13,6 +13,8 @@
  *     - JMicron (hardware and technical support)
  */
 
+#include <linux/kernel.h>
+#include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
@@ -906,7 +908,7 @@ static void sdhci_send_command(struct sd
 		mdelay(1);
 	}
 
-	mod_timer(&host->timer, jiffies + 10 * HZ);
+	schedule_delayed_work(&host->timeout_work, 10 * HZ);
 
 	host->cmd = cmd;
 
@@ -1286,7 +1288,7 @@ static void sdhci_tasklet_finish(unsigne
 
 	spin_lock_irqsave(&host->lock, flags);
 
-	del_timer(&host->timer);
+	__cancel_delayed_work(&host->timeout_work);
 
 	mrq = host->mrq;
 
@@ -1330,12 +1332,12 @@ static void sdhci_tasklet_finish(unsigne
 	mmc_request_done(host->mmc, mrq);
 }
 
-static void sdhci_timeout_timer(unsigned long data)
+static void sdhci_timeout_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
 
-	host = (struct sdhci_host*)data;
+	host = container_of(wk, struct sdhci_host, timeout_work.work);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1884,7 +1886,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	tasklet_init(&host->finish_tasklet,
 		sdhci_tasklet_finish, (unsigned long)host);
 
-	setup_timer(&host->timer, sdhci_timeout_timer, (unsigned long)host);
+	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
 
 	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
 		mmc_hostname(mmc), host);
@@ -1970,7 +1972,7 @@ void sdhci_remove_host(struct sdhci_host
 
 	free_irq(host->irq, host);
 
-	del_timer_sync(&host->timer);
+	flush_delayed_work(&host->timeout_work);
 
 	tasklet_kill(&host->card_tasklet);
 	tasklet_kill(&host->finish_tasklet);
diff -puN drivers/mmc/host/sdhci.h~sdhci-turn-timeout-timer-into-delayed-work drivers/mmc/host/sdhci.h
--- a/drivers/mmc/host/sdhci.h~sdhci-turn-timeout-timer-into-delayed-work
+++ a/drivers/mmc/host/sdhci.h
@@ -12,6 +12,7 @@
 #define __SDHCI_H
 
 #include <linux/scatterlist.h>
+#include <linux/workqueue.h>
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/io.h>
@@ -297,7 +298,7 @@ struct sdhci_host {
 	struct tasklet_struct	card_tasklet;	/* Tasklet structures */
 	struct tasklet_struct	finish_tasklet;
 
-	struct timer_list	timer;		/* Timer for timeouts */
+	struct delayed_work	timeout_work;	/* Work for timeouts */
 
 	unsigned int		caps;		/* Alternative capabilities */
 
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

