From: akpm@linux-foundation.org
Subject: + sdhci-s3c-add-sdhci_quirk_data_timeout_uses_sdclk-quirk.patch added to -mm tree
Date: Mon, 26 Jul 2010 16:40:45 -0700
Message-ID: <201007262340.o6QNejQs016666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689Ab0GZXle (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jul 2010 19:41:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hyuk1.lee@samsung.com, ben-linux@fluff.org, kgene.kim@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci-s3c: add SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK quirk
has been added to the -mm tree.  Its filename is
     sdhci-s3c-add-sdhci_quirk_data_timeout_uses_sdclk-quirk.patch

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
Subject: sdhci-s3c: add SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK quirk
From: Hyuk Lee <hyuk1.lee@samsung.com>

On Samsung's SDMMC hosts the timeout clock is derivied from the SD Clock
which is set dynamically.  So checked SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK
quirk and removed 'sdhci_s3c_get_timeout_clk' callback which doesn't need
any more.

Signed-off-by: Hyuk Lee <hyuk1.lee@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci-s3c.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-sdhci_quirk_data_timeout_uses_sdclk-quirk drivers/mmc/host/sdhci-s3c.c
--- a/drivers/mmc/host/sdhci-s3c.c~sdhci-s3c-add-sdhci_quirk_data_timeout_uses_sdclk-quirk
+++ a/drivers/mmc/host/sdhci-s3c.c
@@ -110,11 +110,6 @@ static unsigned int sdhci_s3c_get_max_cl
 	return max;
 }
 
-static unsigned int sdhci_s3c_get_timeout_clk(struct sdhci_host *host)
-{
-	return sdhci_s3c_get_max_clk(host) / 1000000;
-}
-
 /**
  * sdhci_s3c_consider_clock - consider one the bus clocks for current setting
  * @ourhost: Our SDHCI instance.
@@ -188,7 +183,6 @@ static void sdhci_s3c_set_clock(struct s
 
 		ourhost->cur_clk = best_src;
 		host->max_clk = clk_get_rate(clk);
-		host->timeout_clk = sdhci_s3c_get_timeout_clk(host);
 
 		ctrl = readl(host->ioaddr + S3C_SDHCI_CONTROL2);
 		ctrl &= ~S3C_SDHCI_CTRL2_SELBASECLK_MASK;
@@ -211,7 +205,6 @@ static void sdhci_s3c_set_clock(struct s
 
 static struct sdhci_ops sdhci_s3c_ops = {
 	.get_max_clock		= sdhci_s3c_get_max_clk,
-	.get_timeout_clock	= sdhci_s3c_get_timeout_clk,
 	.set_clock		= sdhci_s3c_set_clock,
 };
 
@@ -335,6 +328,9 @@ static int __devinit sdhci_s3c_probe(str
 	host->quirks |= (SDHCI_QUIRK_32BIT_DMA_ADDR |
 			 SDHCI_QUIRK_32BIT_DMA_SIZE);
 
+	/* HSMMC on Samsung SoCs uses SDCLK as timeout clock */
+	host->quirks |= SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK;
+
 	ret = sdhci_add_host(host);
 	if (ret) {
 		dev_err(dev, "sdhci_add_host() failed\n");
_

Patches currently in -mm which might be from hyuk1.lee@samsung.com are

linux-next.patch
sdhci-s3c-add-sdhci_quirk_data_timeout_uses_sdclk-quirk.patch

