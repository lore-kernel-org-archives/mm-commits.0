From: akpm@linux-foundation.org
Subject: [merged] spi_s3c24xx-use-resource_size-to-get-resource-size.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:58:20 -0700
Message-ID: <200909231958.n8NJwKMD008701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbZIWT6u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:58:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx: use resource_size() to get resource size
has been removed from the -mm tree.  Its filename was
     spi_s3c24xx-use-resource_size-to-get-resource-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

