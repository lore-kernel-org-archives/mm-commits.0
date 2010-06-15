From: akpm@linux-foundation.org
Subject: + sdhci-dont-assign-mmc-caps-at-sdhci-directly.patch added to -mm tree
Date: Tue, 15 Jun 2010 13:17:51 -0700
Message-ID: <201006152017.o5FKHp5I028489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59026 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932251Ab0FOUSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jun 2010 16:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-mmc@vger.kernel.org


The patch titled
     sdhci: don't assign mmc->caps at SDHCI directly
has been added to the -mm tree.  Its filename is
     sdhci-dont-assign-mmc-caps-at-sdhci-directly.patch

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
Subject: sdhci: don't assign mmc->caps at SDHCI directly
From: Kyungmin Park <kyungmin.park@samsung.com>

Some host controllers can set mmc->caps before sdhci_add_host().

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-dont-assign-mmc-caps-at-sdhci-directly drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-dont-assign-mmc-caps-at-sdhci-directly
+++ a/drivers/mmc/host/sdhci.c
@@ -1792,7 +1792,7 @@ int sdhci_add_host(struct sdhci_host *ho
 	else
 		mmc->f_min = host->max_clk / 256;
 	mmc->f_max = host->max_clk;
-	mmc->caps = MMC_CAP_SDIO_IRQ;
+	mmc->caps |= MMC_CAP_SDIO_IRQ;
 
 	if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
_

Patches currently in -mm which might be from kyungmin.park@samsung.com are

mmc-recognize-csd-structure.patch
mmc-recognize-csd-structure-fix.patch
s5pc110-sdhci-s3c-can-override-host-capabilities.patch
s5pc110-sdhci-s3c-support-on-s5pc110.patch
sdhci-add-no-hi-speed-bit-quirk-support.patch
sdhci-remove-useless-set_clock-check.patch
sdhci-dont-assign-mmc-caps-at-sdhci-directly.patch
sdhci-8-bit-data-transfer-width-support.patch

