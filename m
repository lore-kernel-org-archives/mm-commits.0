From: akpm@osdl.org
Subject: + mmc-au1xmmc-implement-proper-ro-switch-detection.patch added to -mm tree
Date: Fri, 26 Jan 2007 12:02:54 -0800
Message-ID: <200701262002.l0QK2sR9025207@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52873 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbXAZUD7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 15:03:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mano@roarinelk.homelinux.net


The patch titled
     mmc: au1xmmc: implement proper ro switch detection
has been added to the -mm tree.  Its filename is
     mmc-au1xmmc-implement-proper-ro-switch-detection.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mmc-au1xmmc-return-errors-for-unknown-response-types.patch
mmc-au1xmmc-implement-proper-ro-switch-detection.patch
git-sh.patch
