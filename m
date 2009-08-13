From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-fix-clock-rate-calculation.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:28:04 -0700
Message-ID: <200908132128.n7DLS5Ih008587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756369AbZHMV2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, david-b@pacbell.net


The patch titled
     spi_s3c24xx: fix clock rate calculation
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-fix-clock-rate-calculation.patch

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
Subject: spi_s3c24xx: fix clock rate calculation
From: Ben Dooks <ben@simtec.co.uk>

Currently the clock rate calculation may round as pleased, which means
that it is possible that we will round down and end up with a faster clock
rate than intended.

Change the calculation to use DIV_ROUND_UP() to ensure that we end up with
a clock rate either the same as or lower than the user requested one.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-fix-clock-rate-calculation drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-fix-clock-rate-calculation
+++ a/drivers/spi/spi_s3c24xx.c
@@ -111,6 +111,7 @@ static int s3c24xx_spi_setupxfer(struct 
 	unsigned int bpw;
 	unsigned int hz;
 	unsigned int div;
+	unsigned long clk;
 
 	bpw = t ? t->bits_per_word : spi->bits_per_word;
 	hz  = t ? t->speed_hz : spi->max_speed_hz;
@@ -120,20 +121,16 @@ static int s3c24xx_spi_setupxfer(struct 
 		return -EINVAL;
 	}
 
-	div = clk_get_rate(hw->clk) / hz;
-
-	/* is clk = pclk / (2 * (pre+1)), or is it
-	 *    clk = (pclk * 2) / ( pre + 1) */
-
-	div /= 2;
-
-	if (div > 0)
-		div -= 1;
+	clk = clk_get_rate(hw->clk);
+	div = DIV_ROUND_UP(clk, hz * 2) - 1;
 
 	if (div > 255)
 		div = 255;
 
-	dev_dbg(&spi->dev, "setting pre-scaler to %d (hz %d)\n", div, hz);
+	dev_dbg(&spi->dev, "setting pre-scaler to %d (wanted %d, got %ld)\n",
+		div, hz, clk / (2 * (div + 1)));
+
+
 	writeb(div, hw->regs + S3C2410_SPPRE);
 
 	spin_lock(&hw->bitbang.lock);
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

