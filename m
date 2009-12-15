From: akpm@linux-foundation.org
Subject: [merged] s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:46 -0800
Message-ID: <200912152158.nBFLwkW3015842__3227.95650358803$1260914395$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933806AbZLOV7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:59:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, linux-mmc@vger.kernel.org, linux@simtec.co.uk, mm-commits@vger.kernel.org


The patch titled
     s3cmci: convert missed s3c2410_gpio calls to gpiolib calls
has been removed from the -mm tree.  Its filename was
     s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: s3cmci: convert missed s3c2410_gpio calls to gpiolib calls
From: Ben Dooks <ben@simtec.co.uk>

Convert two missed s3c2410 specific gpio calls to gpiolib calls.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Signed-off-by: Simtec Linux Team <linux@simtec.co.uk>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/s3cmci.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/mmc/host/s3cmci.c~s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls drivers/mmc/host/s3cmci.c
--- a/drivers/mmc/host/s3cmci.c~s3cmci-convert-missed-s3c2410_gpio-calls-to-gpiolib-calls
+++ a/drivers/mmc/host/s3cmci.c
@@ -1303,10 +1303,8 @@ static int s3cmci_get_ro(struct mmc_host
 	if (pdata->no_wprotect)
 		return 0;
 
-	ret = s3c2410_gpio_getpin(pdata->gpio_wprotect);
-
-	if (pdata->wprotect_invert)
-		ret = !ret;
+	ret = gpio_get_value(pdata->gpio_wprotect) ? 1 : 0;
+	ret ^= pdata->wprotect_invert;
 
 	return ret;
 }
@@ -1655,7 +1653,7 @@ static int __devinit s3cmci_probe(struct
 			goto probe_free_irq;
 		}
 
-		host->irq_cd = s3c2410_gpio_getirq(host->pdata->gpio_detect);
+		host->irq_cd = gpio_to_irq(host->pdata->gpio_detect);
 
 		if (host->irq_cd >= 0) {
 			if (request_irq(host->irq_cd, s3cmci_irq_cd,
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
spi_s3c24xx-add-fiq-pseudo-dma-support.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
sm501-fix-missing-uses-of-resource_size.patch
sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch
sm501-implement-acceleration-features.patch

