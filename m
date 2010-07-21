From: akpm@linux-foundation.org
Subject: + sdhci-clear-interrupt-status-register-just-once.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:14:06 -0700
Message-ID: <201007212114.o6LLE6ak015603@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758237Ab0GUVPL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:15:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, albert_herranz@yahoo.es, ben-linux@fluff.org, matt@console-pimps.org, pierre@ossman.eu, w.sang@pengutronix.de


The patch titled
     sdhci: clear interrupt status register just once
has been added to the -mm tree.  Its filename is
     sdhci-clear-interrupt-status-register-just-once.patch

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
Subject: sdhci: clear interrupt status register just once
From: Anton Vorontsov <avorontsov@mvista.com>

There's no need to clear the interrupt status register bit-by-bit, we can
just clear it once.  This simplifies irq handler.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Albert Herranz <albert_herranz@yahoo.es>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-clear-interrupt-status-register-just-once drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-clear-interrupt-status-register-just-once
+++ a/drivers/mmc/host/sdhci.c
@@ -1528,38 +1528,29 @@ static irqreturn_t sdhci_irq(int irq, vo
 		goto out;
 	}
 
+	sdhci_writel(host, intmask, SDHCI_INT_STATUS);
+
 	DBG("*** %s got interrupt: 0x%08x\n",
 		mmc_hostname(host->mmc), intmask);
 
-	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE)) {
-		sdhci_writel(host, intmask & (SDHCI_INT_CARD_INSERT |
-			SDHCI_INT_CARD_REMOVE), SDHCI_INT_STATUS);
+	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE))
 		schedule_work(&host->card_detect_work);
-	}
 
 	intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
 
-	if (intmask & SDHCI_INT_CMD_MASK) {
-		sdhci_writel(host, intmask & SDHCI_INT_CMD_MASK,
-			SDHCI_INT_STATUS);
+	if (intmask & SDHCI_INT_CMD_MASK)
 		sdhci_cmd_irq(host, intmask & SDHCI_INT_CMD_MASK);
-	}
 
-	if (intmask & SDHCI_INT_DATA_MASK) {
-		sdhci_writel(host, intmask & SDHCI_INT_DATA_MASK,
-			SDHCI_INT_STATUS);
+	if (intmask & SDHCI_INT_DATA_MASK)
 		sdhci_data_irq(host, intmask & SDHCI_INT_DATA_MASK);
-	}
 
 	intmask &= ~(SDHCI_INT_CMD_MASK | SDHCI_INT_DATA_MASK);
 
 	intmask &= ~SDHCI_INT_ERROR;
 
-	if (intmask & SDHCI_INT_BUS_POWER) {
+	if (intmask & SDHCI_INT_BUS_POWER)
 		printk(KERN_ERR "%s: Card is consuming too much power!\n",
 			mmc_hostname(host->mmc));
-		sdhci_writel(host, SDHCI_INT_BUS_POWER, SDHCI_INT_STATUS);
-	}
 
 	intmask &= ~SDHCI_INT_BUS_POWER;
 
@@ -1572,8 +1563,6 @@ static irqreturn_t sdhci_irq(int irq, vo
 		printk(KERN_ERR "%s: Unexpected interrupt 0x%08x.\n",
 			mmc_hostname(host->mmc), intmask);
 		sdhci_dumpregs(host);
