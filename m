From: akpm@linux-foundation.org
Subject: + sdhci-support-mmc_cap_mmc_highspeed.patch added to -mm tree
Date: Mon, 23 Aug 2010 13:09:21 -0700
Message-ID: <201008232009.o7NK9LIf012151__33194.0703829334$1282594203$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab0HWUJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Aug 2010 16:09:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zhangfei.gao@gmail.com, linux-mmc@vger.kernel.org, matt@console-pimps.org, zgao6@marvell.com


The patch titled
     sdhci: support MMC_CAP_MMC_HIGHSPEED
has been added to the -mm tree.  Its filename is
     sdhci-support-mmc_cap_mmc_highspeed.patch

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
Subject: sdhci: support MMC_CAP_MMC_HIGHSPEED
From: zhangfei gao <zhangfei.gao@gmail.com>

With MMC_CAP_MMC_HIGHSPEED, mmc & emmc could negotiate up to 50M,
otherwise only 25M could be reached.

Signed-off-by: Zhangfei Gao <zgao6@marvell.com>
Acked-by: Matt Fleming <matt@console-pimps.org> 
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/sdhci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/sdhci.c~sdhci-support-mmc_cap_mmc_highspeed drivers/mmc/host/sdhci.c
--- a/drivers/mmc/host/sdhci.c~sdhci-support-mmc_cap_mmc_highspeed
+++ a/drivers/mmc/host/sdhci.c
@@ -1824,7 +1824,7 @@ int sdhci_add_host(struct sdhci_host *ho
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
 	if (caps & SDHCI_CAN_DO_HISPD)
-		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
+		mmc->caps |= MMC_CAP_SD_HIGHSPEED | MMC_CAP_MMC_HIGHSPEED;
 
 	if (host->quirks & SDHCI_QUIRK_BROKEN_CARD_DETECTION)
 		mmc->caps |= MMC_CAP_NEEDS_POLL;
_

Patches currently in -mm which might be from zhangfei.gao@gmail.com are

sdhci-support-mmc_cap_mmc_highspeed.patch

