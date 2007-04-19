From: akpm@linux-foundation.org
Subject: - spi-fix-use-of-set_cs-in-spi_s3c24xx-driver.patch removed from -mm tree
Date: Thu, 19 Apr 2007 13:01:56 -0700
Message-ID: <200704192001.l3JK1uPJ029327@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33501 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766993AbXDSUCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Apr 2007 16:02:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux-arm@fluff.org, Ling.Alex@iac.com.tw, ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: fix use of set_cs in spi_s3c24xx driver
has been removed from the -mm tree.  Its filename was
     spi-fix-use-of-set_cs-in-spi_s3c24xx-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 2 insertions(+), 2 deletions(-)

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

origin.patch
