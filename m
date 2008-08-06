From: akpm@linux-foundation.org
Subject: - s3c24xx-reset-register-status-on-resume.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:55:36 -0700
Message-ID: <200808062055.m76KtaND014587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35443 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697AbYHFU4r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 16:56:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: S3C24XX: reset register status on resume.
has been removed from the -mm tree.  Its filename was
     s3c24xx-reset-register-status-on-resume.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: S3C24XX: reset register status on resume.
From: Ben Dooks <ben-linux@fluff.org>

Fix a bug in the spi_s3c24xx driver where it does not reset the registers
of the hardware when resuming from suspend (this block has been reset over
suspend).

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~s3c24xx-reset-register-status-on-resume drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~s3c24xx-reset-register-status-on-resume
+++ a/drivers/spi/spi_s3c24xx.c
@@ -236,6 +236,19 @@ static irqreturn_t s3c24xx_spi_irq(int i
 	return IRQ_HANDLED;
 }
 
+static void s3c24xx_spi_initialsetup(struct s3c24xx_spi *hw)
+{
+	/* for the moment, permanently enable the clock */
+
+	clk_enable(hw->clk);
+
+	/* program defaults into the registers */
+
+	writeb(0xff, hw->regs + S3C2410_SPPRE);
+	writeb(SPPIN_DEFAULT, hw->regs + S3C2410_SPPIN);
+	writeb(SPCON_DEFAULT, hw->regs + S3C2410_SPCON);
+}
+
 static int __init s3c24xx_spi_probe(struct platform_device *pdev)
 {
 	struct s3c2410_spi_info *pdata;
@@ -327,15 +340,7 @@ static int __init s3c24xx_spi_probe(stru
 		goto err_no_clk;
 	}
 
-	/* for the moment, permanently enable the clock */
-
-	clk_enable(hw->clk);
-
-	/* program defaults into the registers */
-
-	writeb(0xff, hw->regs + S3C2410_SPPRE);
-	writeb(SPPIN_DEFAULT, hw->regs + S3C2410_SPPIN);
-	writeb(SPCON_DEFAULT, hw->regs + S3C2410_SPCON);
+	s3c24xx_spi_initialsetup(hw);
 
 	/* setup any gpio we can */
 
@@ -415,7 +420,7 @@ static int s3c24xx_spi_resume(struct pla
 {
 	struct s3c24xx_spi *hw = platform_get_drvdata(pdev);
 
-	clk_enable(hw->clk);
+	s3c24xx_spi_initialsetup(hw);
 	return 0;
 }
 
_

Patches currently in -mm which might be from ben-linux@fluff.org are

sm501-update-debugging-low-information-messages.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

