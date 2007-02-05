From: akpm@linux-foundation.org
Subject: - mmc-au1xmmc-implement-proper-ro-switch-detection.patch removed from -mm tree
Date: Mon, 05 Feb 2007 12:41:26 -0800
Message-ID: <200702052041.l15KfQEZ030573@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60775 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933444AbXBEUlk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 15:41:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mano@roarinelk.homelinux.net, mm-commits@vger.kernel.org


The patch titled
     mmc: au1xmmc: implement proper ro switch detection
has been removed from the -mm tree.  Its filename was
     mmc-au1xmmc-implement-proper-ro-switch-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mmc: au1xmmc: implement proper ro switch detection
From: Manuel Lauss <mano@roarinelk.homelinux.net>

au1xmmc: implement proper R/O switch detection.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/au1xmmc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/au1xmmc.c~mmc-au1xmmc-implement-proper-ro-switch-detection drivers/mmc/au1xmmc.c
--- a/drivers/mmc/au1xmmc.c~mmc-au1xmmc-implement-proper-ro-switch-detection
+++ a/drivers/mmc/au1xmmc.c
@@ -152,8 +152,9 @@ static inline int au1xmmc_card_inserted(
 		? 1 : 0;
 }
 
-static inline int au1xmmc_card_readonly(struct au1xmmc_host *host)
+static int au1xmmc_card_readonly(struct mmc_host *mmc)
 {
+	struct au1xmmc_host *host = mmc_priv(mmc);
 	return (bcsr->status & au1xmmc_card_table[host->id].wpstatus)
 		? 1 : 0;
 }
@@ -884,6 +885,7 @@ static void au1xmmc_init_dma(struct au1x
 static const struct mmc_host_ops au1xmmc_ops = {
 	.request	= au1xmmc_request,
 	.set_ios	= au1xmmc_set_ios,
+	.get_ro		= au1xmmc_card_readonly,
 };
 
 static int __devinit au1xmmc_probe(struct platform_device *pdev)
_

Patches currently in -mm which might be from mano@roarinelk.homelinux.net are

git-mmc.patch
git-sh.patch
