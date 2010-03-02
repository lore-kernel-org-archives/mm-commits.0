From: akpm@linux-foundation.org
Subject: + mmc-at91_mci-fix-timeout-errors.patch added to -mm tree
Date: Tue, 02 Mar 2010 13:34:59 -0800
Message-ID: <201003022134.o22LYxr3030820__33338.1481621929$1267565829$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984Ab0CBVfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Mar 2010 16:35:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wolfgang.mues@auerswald.de, avictor.za@gmail.com, linux-mmc@vger.kernel.org, nicolas.ferre@atmel.com


The patch titled
     mmc: at91_mci: fix timeout errors
has been added to the -mm tree.  Its filename is
     mmc-at91_mci-fix-timeout-errors.patch

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

mmc-at91_mci-fix-pointer-errors.patch
mmc-at91_mci-fix-timeout-errors.patch
mmc-at91_mci-use-one-coherent-dma-buffer.patch
mmc-at91_mci-use-dma-buffer-for-read.patch
mmc-at91_mci-enable-large-data-blocks.patch
mmc-at91_mci-enable-mmc_cap_sdio_irq-only-when-it-actually-works.patch
mmc-at91_mci-introduce-per-mci-revision-conditional-code.patch

