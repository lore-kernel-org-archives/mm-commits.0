From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-cache-device-setup-data.patch added to -mm tree
Date: Thu, 13 Aug 2009 14:28:14 -0700
Message-ID: <200908132128.n7DLSFmJ008893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752590AbZHMV20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Aug 2009 17:28:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, david-b@pacbell.net


The patch titled
     spi_s3c24xx: cache device setup data
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-cache-device-setup-data.patch

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
Subject: spi_s3c24xx: cache device setup data
From: Ben Dooks <ben@simtec.co.uk>

With the update to the spi_bitbang driver, the transfer setup code is
being called more often, and thus is often re-doing calculations that have
been done before.  The SPI layer allows our driver to add its own data to
each device so add a result cache to each device.

This should also remove the problem where we where directly setting up
registers in the setup call which meant we might overwrite the state of an
extant transfer.,

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c |  126 +++++++++++++++++++++++++-----------
 1 file changed, 89 insertions(+), 37 deletions(-)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-cache-device-setup-data drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-cache-device-setup-data
+++ a/drivers/spi/spi_s3c24xx.c
@@ -28,6 +28,20 @@
 #include <plat/regs-spi.h>
 #include <mach/spi.h>
 
+/**
+ * s3c24xx_spi_devstate - per device data
+ * @hz: Last frequency calculated for @sppre field.
+ * @mode: Last mode setting for the @spcon field.
+ * @spcon: Value to write to the SPCON register.
+ * @sppre: Value to write to the SPPRE register.
+ */
+struct s3c24xx_spi_devstate {
+	unsigned int	hz;
+	unsigned int	mode;
+	u8		spcon;
+	u8		sppre;
+};
+
 struct s3c24xx_spi {
 	/* bitbang has to be first */
 	struct spi_bitbang	 bitbang;
@@ -68,43 +82,31 @@ static void s3c24xx_spi_gpiocs(struct s3
 
 static void s3c24xx_spi_chipsel(struct spi_device *spi, int value)
 {
+	struct s3c24xx_spi_devstate *cs = spi->controller_state;
 	struct s3c24xx_spi *hw = to_hw(spi);
 	unsigned int cspol = spi->mode & SPI_CS_HIGH ? 1 : 0;
-	unsigned int spcon;
+
+	/* change the chipselect state and the state of the spi engine clock */
 
 	switch (value) {
 	case BITBANG_CS_INACTIVE:
 		hw->set_cs(hw->pdata, spi->chip_select, cspol^1);
+		writeb(cs->spcon, hw->regs + S3C2410_SPCON);
 		break;
 
 	case BITBANG_CS_ACTIVE:
-		spcon = readb(hw->regs + S3C2410_SPCON);
-
-		if (spi->mode & SPI_CPHA)
-			spcon |= S3C2410_SPCON_CPHA_FMTB;
-		else
-			spcon &= ~S3C2410_SPCON_CPHA_FMTB;
-
-		if (spi->mode & SPI_CPOL)
-			spcon |= S3C2410_SPCON_CPOL_HIGH;
-		else
-			spcon &= ~S3C2410_SPCON_CPOL_HIGH;
-
-		spcon |= S3C2410_SPCON_ENSCK;
-
-		/* write new configration */
-
-		writeb(spcon, hw->regs + S3C2410_SPCON);
+		writeb(cs->spcon | S3C2410_SPCON_ENSCK,
+		       hw->regs + S3C2410_SPCON);
 		hw->set_cs(hw->pdata, spi->chip_select, cspol);
-
 		break;
 	}
 }
 
-static int s3c24xx_spi_setupxfer(struct spi_device *spi,
-				 struct spi_transfer *t)
+static int s3c24xx_spi_update_state(struct spi_device *spi,
+				    struct spi_transfer *t)
 {
 	struct s3c24xx_spi *hw = to_hw(spi);
+	struct s3c24xx_spi_devstate *cs = spi->controller_state;
 	unsigned int bpw;
 	unsigned int hz;
 	unsigned int div;
@@ -124,41 +126,89 @@ static int s3c24xx_spi_setupxfer(struct 
 		return -EINVAL;
 	}
 
-	clk = clk_get_rate(hw->clk);
-	div = DIV_ROUND_UP(clk, hz * 2) - 1;
+	if (spi->mode != cs->mode) {
+		u8 spcon = SPCON_DEFAULT;
 
-	if (div > 255)
-		div = 255;
+		if (spi->mode & SPI_CPHA)
+			spcon |= S3C2410_SPCON_CPHA_FMTB;
 
-	dev_dbg(&spi->dev, "setting pre-scaler to %d (wanted %d, got %ld)\n",
-		div, hz, clk / (2 * (div + 1)));
+		if (spi->mode & SPI_CPOL)
+			spcon |= S3C2410_SPCON_CPOL_HIGH;
 
+		cs->mode = spi->mode;
+		cs->spcon = spcon;
+	}
 
-	writeb(div, hw->regs + S3C2410_SPPRE);
+	if (cs->hz != hz) {
+		clk = clk_get_rate(hw->clk);
+		div = DIV_ROUND_UP(clk, hz * 2) - 1;
 
-	spin_lock(&hw->bitbang.lock);
-	if (!hw->bitbang.busy) {
-		hw->bitbang.chipselect(spi, BITBANG_CS_INACTIVE);
-		/* need to ndelay for 0.5 clocktick ? */
+		if (div > 255)
+			div = 255;
+
+		dev_dbg(&spi->dev, "pre-scaler=%d (wanted %d, got %ld)\n",
+			div, hz, clk / (2 * (div + 1)));
+
+		cs->hz = hz;
+		cs->sppre = div;
 	}
-	spin_unlock(&hw->bitbang.lock);
 
 	return 0;
 }
 
+static int s3c24xx_spi_setupxfer(struct spi_device *spi,
+				 struct spi_transfer *t)
+{
+	struct s3c24xx_spi_devstate *cs = spi->controller_state;
+	struct s3c24xx_spi *hw = to_hw(spi);
+	int ret;
+
+	ret = s3c24xx_spi_update_state(spi, t);
+	if (!ret)
+		writeb(cs->sppre, hw->regs + S3C2410_SPPRE);
+
+	return ret;
+}
+
 static int s3c24xx_spi_setup(struct spi_device *spi)
 {
+	struct s3c24xx_spi_devstate *cs = spi->controller_state;
+	struct s3c24xx_spi *hw = to_hw(spi);
 	int ret;
 
-	ret = s3c24xx_spi_setupxfer(spi, NULL);
-	if (ret < 0) {
-		dev_err(&spi->dev, "setupxfer returned %d\n", ret);
+	/* allocate settings on the first call */
+	if (!cs) {
+		cs = kzalloc(sizeof(struct s3c24xx_spi_devstate), GFP_KERNEL);
+		if (!cs) {
+			dev_err(&spi->dev, "no memory for controller state\n");
+			return -ENOMEM;
+		}
+
+		cs->spcon = SPCON_DEFAULT;
+		cs->hz = -1;
+		spi->controller_state = cs;
+	}
+
+	/* initialise the state from the device */
+	ret = s3c24xx_spi_update_state(spi, NULL);
+	if (ret)
 		return ret;
+
+	spin_lock(&hw->bitbang.lock);
+	if (!hw->bitbang.busy) {
+		hw->bitbang.chipselect(spi, BITBANG_CS_INACTIVE);
+		/* need to ndelay for 0.5 clocktick ? */
 	}
+	spin_unlock(&hw->bitbang.lock);
 
 	return 0;
 }
 
+static void s3c24xx_spi_cleanup(struct spi_device *spi)
+{
+	kfree(spi->controller_state);
+}
+
 static inline unsigned int hw_txbyte(struct s3c24xx_spi *hw, int count)
 {
 	return hw->tx ? hw->tx[count] : 0;
@@ -286,7 +336,9 @@ static int __init s3c24xx_spi_probe(stru
 	hw->bitbang.setup_transfer = s3c24xx_spi_setupxfer;
 	hw->bitbang.chipselect     = s3c24xx_spi_chipsel;
 	hw->bitbang.txrx_bufs      = s3c24xx_spi_txrx;
-	hw->bitbang.master->setup  = s3c24xx_spi_setup;
+
+	hw->master->setup  = s3c24xx_spi_setup;
+	hw->master->cleanup = s3c24xx_spi_cleanup;
 
 	dev_dbg(hw->dev, "bitbang at %p\n", &hw->bitbang);
 
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

