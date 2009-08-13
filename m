From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-use-resource_size-to-get-resource-size.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:28:10 -0700
Message-ID: <200908132128.n7DLSAPU008733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33575 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756371AbZHMV2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, david-b@pacbell.net


The patch titled
     spi_s3c24xx: use resource_size() to get resource size
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-use-resource_size-to-get-resource-size.patch

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
Subject: spi_s3c24xx: use resource_size() to get resource size
From: Ben Dooks <ben@simtec.co.uk>

Change the use of (res->end - res->start) to use resource_size() to
get the size of the resource.

Signed-off-by; Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-use-resource_size-to-get-resource-size drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-use-resource_size-to-get-resource-size
+++ a/drivers/spi/spi_s3c24xx.c
@@ -299,7 +299,7 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_iores;
 	}
 
-	hw->ioarea = request_mem_region(res->start, (res->end - res->start)+1,
+	hw->ioarea = request_mem_region(res->start, resource_size(res),
 					pdev->name);
 
 	if (hw->ioarea == NULL) {
@@ -308,7 +308,7 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_iores;
 	}
 
-	hw->regs = ioremap(res->start, (res->end - res->start)+1);
+	hw->regs = ioremap(res->start, resource_size(res));
 	if (hw->regs == NULL) {
 		dev_err(&pdev->dev, "Cannot map IO\n");
 		err = -ENXIO;
_

Patches currently in -mm which might be from ben@simtec.co.uk are

linux-next.patch
spi-fix-spelling-of-automatically-in-documentation.patch
spi_s3c24xx-fix-clock-rate-calculation.patch
spi_s3c24xx-fix-transfer-setup-code.patch
spi_s3c24xx-fix-header-includes.patch
spi_s3c24xx-use-resource_size-to-get-resource-size.patch
spi_s3c24xx-use-dev_pm_ops.patch
spi_s3c24xx-cache-device-setup-data.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes.patch
gpiolib-add-names-file-in-gpio-chip-sysfs-checkpatch-fixes-fix.patch

