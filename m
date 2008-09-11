From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-pin-configuration-updates.patch added to -mm tree
Date: Thu, 11 Sep 2008 12:46:16 -0700
Message-ID: <200809111946.m8BJkUsh013124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbYIKTrn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Sep 2008 15:47:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi_s3c24xx: pin configuration updates
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-pin-configuration-updates.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_s3c24xx: pin configuration updates
From: Ben Dooks <ben-linux@fluff.org>

Add a pin configuration callback for the s3c24xx SPI driver, as there are
several options depending on the channel and the chip in use.

This is needed as the controller may not have been setup by the initial
bootloader and the fact that the SPI controller gets reset over
suspend/resume into slave mode but the GPIO function registers do not.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-s3c2410/include/mach/spi.h |    1 +
 drivers/spi/spi_s3c24xx.c                |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN arch/arm/mach-s3c2410/include/mach/spi.h~spi_s3c24xx-pin-configuration-updates arch/arm/mach-s3c2410/include/mach/spi.h
--- a/arch/arm/mach-s3c2410/include/mach/spi.h~spi_s3c24xx-pin-configuration-updates
+++ a/arch/arm/mach-s3c2410/include/mach/spi.h
@@ -18,6 +18,7 @@ struct s3c2410_spi_info {
 	unsigned int		 num_cs;	/* total chipselects */
 	int			 bus_num;       /* bus number to use. */
 
+	void (*gpio_setup)(struct s3c2410_spi_info *spi, int enable);
 	void (*set_cs)(struct s3c2410_spi_info *spi, int cs, int pol);
 };
 
diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-pin-configuration-updates drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-pin-configuration-updates
+++ a/drivers/spi/spi_s3c24xx.c
@@ -247,6 +247,9 @@ static void s3c24xx_spi_initialsetup(str
 	writeb(0xff, hw->regs + S3C2410_SPPRE);
 	writeb(SPPIN_DEFAULT, hw->regs + S3C2410_SPPIN);
 	writeb(SPCON_DEFAULT, hw->regs + S3C2410_SPCON);
+
+	if (hw->pdata && hw->pdata->gpio_setup)
+		hw->pdata->gpio_setup(hw->pdata, 1);
 }
 
 static int __init s3c24xx_spi_probe(struct platform_device *pdev)
@@ -412,6 +415,9 @@ static int s3c24xx_spi_suspend(struct pl
 {
 	struct s3c24xx_spi *hw = platform_get_drvdata(pdev);
 
+	if (hw->pdata && hw->pdata->gpio_setup)
+		hw->pdata->gpio_setup(hw->pdata, 0);
+
 	clk_disable(hw->clk);
 	return 0;
 }
_

Patches currently in -mm which might be from ben-linux@fluff.org are

linux-next.patch
spi_s3c24xx-pin-configuration-updates.patch
resource-add-resource_type-and-ioresource_type_bits.patch

