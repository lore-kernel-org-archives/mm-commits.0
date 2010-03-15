From: akpm@linux-foundation.org
Subject: [merged] mxcmmc-fixed-max_seg_size-value-on-initialization.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:04:54 -0400
Message-ID: <201003150705.o2F75RZ7017089__12226.8650834032$1268636788$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50311 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759741Ab0COHFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vzapolskiy@gmail.com, linux-mmc@vger.kernel.org, pierre@ossman.eu, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     mxcmmc: fixed max_seg_size value on initialization
has been removed from the -mm tree.  Its filename was
     mxcmmc-fixed-max_seg_size-value-on-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mxcmmc: fixed max_seg_size value on initialization
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>

This unpleasant typo appeared while porting the driver from Freescale
original sources, where anyone can easily find the correct version.

Current incorrect version potentially can influence segment and merge
handling in block subsystem via MMC request queue settings.

Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/mxcmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/mxcmmc.c~mxcmmc-fixed-max_seg_size-value-on-initialization drivers/mmc/host/mxcmmc.c
--- a/drivers/mmc/host/mxcmmc.c~mxcmmc-fixed-max_seg_size-value-on-initialization
+++ a/drivers/mmc/host/mxcmmc.c
@@ -708,7 +708,7 @@ static int mxcmci_probe(struct platform_
 	mmc->max_blk_size = 2048;
 	mmc->max_blk_count = 65535;
 	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
-	mmc->max_seg_size = mmc->max_seg_size;
+	mmc->max_seg_size = mmc->max_req_size;
 
 	host = mmc_priv(mmc);
 	host->base = ioremap(r->start, resource_size(r));
_

Patches currently in -mm which might be from vzapolskiy@gmail.com are

origin.patch

