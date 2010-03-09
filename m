From: akpm@linux-foundation.org
Subject: [merged] mmc-at91_mci-fix-timeout-errors.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:08:34 -0800
Message-ID: <201003091908.o29J8YpL031450__2672.01993051476$1268162562$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756023Ab0CITWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wolfgang.mues@auerswald.de, avictor.za@gmail.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com, mm-commits@vger.kernel.org


The patch titled
     mmc: at91_mci: fix timeout errors
has been removed from the -mm tree.  Its filename was
     mmc-at91_mci-fix-timeout-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: at91_mci: fix timeout errors
From: Wolfgang Muees <wolfgang.mues@auerswald.de>

Fix two timeout errors, one for slow SDHC cards and one for slow users
while inserting SD cards.

Signed-off-by: Wolfgang Muees <wolfgang.mues@auerswald.de>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <avictor.za@gmail.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/at91_mci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/at91_mci.c~mmc-at91_mci-fix-timeout-errors drivers/mmc/host/at91_mci.c
--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-fix-timeout-errors
+++ a/drivers/mmc/host/at91_mci.c
@@ -756,7 +756,8 @@ static void at91_mci_request(struct mmc_
 	host->request = mrq;
 	host->flags = 0;
 
-	mod_timer(&host->timer, jiffies +  HZ);
+	/* more than 1s timeout needed with slow SD cards */
+	mod_timer(&host->timer, jiffies +  msecs_to_jiffies(2000));
 
 	at91_mci_process_next(host);
 }
@@ -944,7 +945,8 @@ static irqreturn_t at91_mmc_det_irq(int 
 			pr_debug("****** Resetting SD-card bus width ******\n");
 			at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) & ~AT91_MCI_SDCBUS);
 		}
-		mmc_detect_change(host->mmc, msecs_to_jiffies(100));
+		/* 0.5s needed because of early card detect switch firing */
+		mmc_detect_change(host->mmc, msecs_to_jiffies(500));
 	}
 	return IRQ_HANDLED;
 }
_

Patches currently in -mm which might be from wolfgang.mues@auerswald.de are


