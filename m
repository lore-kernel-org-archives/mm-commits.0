From: akpm@linux-foundation.org
Subject: + spi-fix-use-of-set_cs-in-spi_s3c24xx-driver.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:14:00 -0700
Message-ID: <200704132114.l3DLE0uB009541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52283 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030369AbXDMVOR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:14:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux-arm@fluff.org, Ling.Alex@iac.com.tw, ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi: fix use of set_cs in spi_s3c24xx driver
has been added to the -mm tree.  Its filename is
     spi-fix-use-of-set_cs-in-spi_s3c24xx-driver.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: fix use of set_cs in spi_s3c24xx driver
From: Ben Dooks <ben-linux-arm@fluff.org>

It turns out that the last patch to change set_cs to be kept in the
controller's structure instead of the platform data was an incomplete
change, and did not change the references to platfrom data in the setup
xfer code.  (This can prevent an oops.)

Reported-by: <Ling.Alex@iac.com.tw>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi-fix-use-of-set_cs-in-spi_s3c24xx-driver drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-fix-use-of-set_cs-in-spi_s3c24xx-driver
+++ a/drivers/spi/spi_s3c24xx.c
@@ -77,7 +77,7 @@ static void s3c24xx_spi_chipsel(struct s
 
 	switch (value) {
 	case BITBANG_CS_INACTIVE:
-		hw->pdata->set_cs(hw->pdata, spi->chip_select, cspol^1);
+		hw->set_cs(hw->pdata, spi->chip_select, cspol^1);
 		break;
 
 	case BITBANG_CS_ACTIVE:
@@ -98,7 +98,7 @@ static void s3c24xx_spi_chipsel(struct s
 		/* write new configration */
 
 		writeb(spcon, hw->regs + S3C2410_SPCON);
-		hw->pdata->set_cs(hw->pdata, spi->chip_select, cspol);
+		hw->set_cs(hw->pdata, spi->chip_select, cspol);
 
 		break;
 	}
_

Patches currently in -mm which might be from ben-linux-arm@fluff.org are

spi-fix-use-of-set_cs-in-spi_s3c24xx-driver.patch
