From: akpm@linux-foundation.org
Subject: + mmc-fix-omap-compile-by-replacing-dev_name-with-dma_dev_name.patch added to -mm tree
Date: Wed, 07 May 2008 14:49:59 -0700
Message-ID: <200805072149.m47LnxYA018213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756487AbYEGVuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 17:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tony@atomide.com, drzeus-list@drzeus.cx, paul@pwsan.com


The patch titled
     mmc: fix omap compile by replacing dev_name with dma_dev_name
has been added to the -mm tree.  Its filename is
     mmc-fix-omap-compile-by-replacing-dev_name-with-dma_dev_name.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: fix omap compile by replacing dev_name with dma_dev_name
From: Tony Lindgren <tony@atomide.com>

Fix the error:

drivers/mmc/host/omap.c: In function 'mmc_omap_get_dma_channel':
drivers/mmc/host/omap.c:1038: error: called object 'dev_name' is not a function

Commit 06916639e2fed9ee475efef2747a1b7429f8fe76 adds a function called
dev_name.  This will cause a name conflict as dev_dbg calls
dev_name(((host->mmc)->parent)).

This same issue should not affect other drivers as they don't seem to use
dev_name with dev_dbg.

Thanks to Paul Walmsley <paul@pwsan.com> for figuring this one out.

Cc: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-fix-omap-compile-by-replacing-dev_name-with-dma_dev_name drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-fix-omap-compile-by-replacing-dev_name-with-dma_dev_name
+++ a/drivers/mmc/host/omap.c
@@ -1003,7 +1003,7 @@ static void mmc_omap_dma_cb(int lch, u16
 
 static int mmc_omap_get_dma_channel(struct mmc_omap_host *host, struct mmc_data *data)
 {
-	const char *dev_name;
+	const char *dma_dev_name;
 	int sync_dev, dma_ch, is_read, r;
 
 	is_read = !(data->flags & MMC_DATA_WRITE);
@@ -1018,21 +1018,21 @@ static int mmc_omap_get_dma_channel(stru
 	if (is_read) {
 		if (host->id == 1) {
 			sync_dev = OMAP_DMA_MMC_RX;
-			dev_name = "MMC1 read";
+			dma_dev_name = "MMC1 read";
 		} else {
 			sync_dev = OMAP_DMA_MMC2_RX;
-			dev_name = "MMC2 read";
+			dma_dev_name = "MMC2 read";
 		}
 	} else {
 		if (host->id == 1) {
 			sync_dev = OMAP_DMA_MMC_TX;
-			dev_name = "MMC1 write";
+			dma_dev_name = "MMC1 write";
 		} else {
 			sync_dev = OMAP_DMA_MMC2_TX;
-			dev_name = "MMC2 write";
+			dma_dev_name = "MMC2 write";
 		}
 	}
-	r = omap_request_dma(sync_dev, dev_name, mmc_omap_dma_cb,
+	r = omap_request_dma(sync_dev, dma_dev_name, mmc_omap_dma_cb,
 			     host, &dma_ch);
 	if (r != 0) {
 		dev_dbg(mmc_dev(host->mmc), "omap_request_dma() failed with %d\n", r);
_

Patches currently in -mm which might be from tony@atomide.com are

arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
mmc-fix-omap-compile-by-replacing-dev_name-with-dma_dev_name.patch

