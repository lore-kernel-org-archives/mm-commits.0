From: akpm@linux-foundation.org
Subject: + sdhci-use-jiffies-instead-of-a-timeout-counter.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:16 -0700
Message-ID: <201007212114.o6LLEG4u015624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754932Ab0GUVPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: use jiffies instead of a timeout counter
has been added to the -mm tree.  Its filename is
     sdhci-use-jiffies-instead-of-a-timeout-counter.patch

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
Subject: sdhci: use jiffies instead of a timeout counter
From: Anton Vorontsov <avorontsov@mvista.com>

Just a cosmetic change, should not affect functionality.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-use-jiffies-instead-of-a-timeout-counter drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-use-jiffies-instead-of-a-timeout-counter
+++ a/drivers/mmc/host/sdhci.c
@@ -22,6 +22,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/scatterlist.h>
+#include <linux/jiffies.h>
 
 #include <linux/leds.h>
 
@@ -160,17 +161,16 @@ static void sdhci_reset(struct sdhci_hos
 		host->clock = 0;
 
 	/* Wait max 100 ms */
-	timeout = 100;
+	timeout = jiffies + msecs_to_jiffies(100);
 
 	/* hw clears the bit when it's done */
 	while (sdhci_readb(host, SDHCI_SOFTWARE_RESET) & mask) {
-		if (timeout == 0) {
+		if (time_after(jiffies, timeout)) {
 			printk(KERN_ERR "%s: Reset 0x%x never completed.\n",
 				mmc_hostname(host->mmc), (int)mask);
 			sdhci_dumpregs(host);
 			return;
 		}
-		timeout--;
 		msleep(1);
 	}
 
@@ -884,7 +884,7 @@ static void sdhci_send_command(struct sd
 	WARN_ON(host->cmd);
 
 	/* Wait max 10 ms */
-	timeout = 10;
+	timeout = jiffies + msecs_to_jiffies(10);
 
 	mask = SDHCI_CMD_INHIBIT;
 	if ((cmd->data != NULL) || (cmd->flags & MMC_RSP_BUSY))
@@ -896,7 +896,7 @@ static void sdhci_send_command(struct sd
 		mask &= ~SDHCI_DATA_INHIBIT;
 
 	while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
-		if (timeout == 0) {
+		if (time_after(jiffies, timeout)) {
 			printk(KERN_ERR "%s: Controller never released "
 				"inhibit bit(s).\n", mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
@@ -904,7 +904,6 @@ static void sdhci_send_command(struct sd
 			schedule_work(&host->finish_work);
 			return;
 		}
-		timeout--;
 		mdelay(1);
 	}
 
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

