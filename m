From: akpm@linux-foundation.org
Subject: + spi-controller-drivers-check-for-unsupported-modes.patch added to -mm tree
Date: Tue, 22 May 2007 12:52:21 -0700
Message-ID: <200705221952.l4MJqLlG008591@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57105 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757039AbXEVTy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 May 2007 15:54:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI controller drivers: check for unsupported modes
has been added to the -mm tree.  Its filename is
     spi-controller-drivers-check-for-unsupported-modes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI controller drivers: check for unsupported modes
From: David Brownell <david-b@pacbell.net>

Minor SPI controller driver updates: make the setup() methods reject
spi->mode bits they don't support, by masking aginst the inverse of bits
they *do* support.  This insures against misbehavior later when new mode
bits get added.

Most controllers can't support SPI_LSB_FIRST; more handle SPI_CS_HIGH. 
Support for all four SPI clock/transfer modes is routine.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c       |    1 +
 drivers/spi/au1550_spi.c      |    9 +++++++++
 drivers/spi/mpc52xx_psc_spi.c |    9 +++++++++
 drivers/spi/omap_uwire.c      |    9 +++++++++
 drivers/spi/pxa2xx_spi.c      |    9 +++++++++
 drivers/spi/spi_bitbang.c     |    6 +++++-
 drivers/spi/spi_imx.c         |   24 +++++++++---------------
 drivers/spi/spi_mpc83xx.c     |    9 +++++++++
 drivers/spi/spi_s3c24xx.c     |    8 +++++++-
 9 files changed, 67 insertions(+), 17 deletions(-)

diff -puN drivers/spi/atmel_spi.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/atmel_spi.c
@@ -350,6 +350,7 @@ atmel_spi_interrupt(int irq, void *dev_i
 	return ret;
 }
 
+/* the spi->mode bits understood by this driver: */
 #define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
 
 static int atmel_spi_setup(struct spi_device *spi)
diff -puN drivers/spi/au1550_spi.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/au1550_spi.c
@@ -280,6 +280,9 @@ static int au1550_spi_setupxfer(struct s
 	return 0;
 }
 
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST)
+
 static int au1550_spi_setup(struct spi_device *spi)
 {
 	struct au1550_spi *hw = spi_master_get_devdata(spi->master);
@@ -292,6 +295,12 @@ static int au1550_spi_setup(struct spi_d
 		return -EINVAL;
 	}
 
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
 	if (spi->max_speed_hz == 0)
 		spi->max_speed_hz = hw->freq_max;
 	if (spi->max_speed_hz > hw->freq_max
diff -puN drivers/spi/mpc52xx_psc_spi.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -270,6 +270,9 @@ static void mpc52xx_psc_spi_work(struct 
 	spin_unlock_irq(&mps->lock);
 }
 
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST)
+
 static int mpc52xx_psc_spi_setup(struct spi_device *spi)
 {
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
@@ -279,6 +282,12 @@ static int mpc52xx_psc_spi_setup(struct 
 	if (spi->bits_per_word%8)
 		return -EINVAL;
 
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
 	if (!cs) {
 		cs = kzalloc(sizeof *cs, GFP_KERNEL);
 		if (!cs)
diff -puN drivers/spi/omap_uwire.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/omap_uwire.c
@@ -445,10 +445,19 @@ done:
 	return status;
 }
 
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
+
 static int uwire_setup(struct spi_device *spi)
 {
 	struct uwire_state *ust = spi->controller_state;
 
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
 	if (ust == NULL) {
 		ust = kzalloc(sizeof(*ust), GFP_KERNEL);
 		if (ust == NULL)
diff -puN drivers/spi/pxa2xx_spi.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1067,6 +1067,9 @@ static int transfer(struct spi_device *s
 	return 0;
 }
 
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA)
+
 static int setup(struct spi_device *spi)
 {
 	struct pxa2xx_spi_chip *chip_info = NULL;
@@ -1093,6 +1096,12 @@ static int setup(struct spi_device *spi)
 		return -EINVAL;
 	}
 
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
 	/* Only alloc on first setup */
 	chip = spi_get_ctldata(spi);
 	if (!chip) {
diff -puN drivers/spi/spi_bitbang.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/spi_bitbang.c
@@ -191,8 +191,12 @@ int spi_bitbang_setup(struct spi_device 
 	 * bit encodings on the wire.  In pure software that would be trivial,
 	 * just bitbang_txrx_le_cphaX() routines shifting the other way, and
 	 * some hardware controllers also have this support.
+	 *
+	 * REVISIT: we should accept SPI_CS_HIGH in some cases; it's
+	 * easy to implement that with GPIOs, but we don't know if the
+	 * underlying chipselect() method support that...
 	 */
-	if ((spi->mode & SPI_LSB_FIRST) != 0)
+	if ((spi->mode & ~(SPI_CPOL|SPI_CPHA)) != 0)
 		return -EINVAL;
 
 	if (!cs) {
diff -puN drivers/spi/spi_imx.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/spi_imx.c
@@ -1163,6 +1163,9 @@ msg_rejected:
 	return -EINVAL;
 }
 
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
+
 /* On first setup bad values must free chip_data memory since will cause
    spi_new_device to fail. Bad value setup from protocol driver are simply not
    applied and notified to the calling driver. */
@@ -1174,6 +1177,12 @@ static int setup(struct spi_device *spi)
 	u32 tmp;
 	int status = 0;
 
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
 	/* Get controller data */
 	chip_info = spi->controller_data;
 
@@ -1245,21 +1254,6 @@ static int setup(struct spi_device *spi)
 
 	/* SPI mode */
 	tmp = spi->mode;
-	if (tmp & SPI_LSB_FIRST) {
-		status = -EINVAL;
-		if (first_setup) {
-			dev_err(&spi->dev,
-				"setup - "
-				"HW doesn't support LSB first transfer\n");
-			goto err_first_setup;
-		} else {
-			dev_err(&spi->dev,
-				"setup - "
-				"HW doesn't support LSB first transfer, "
-				"default to MSB first\n");
-			spi->mode &= ~SPI_LSB_FIRST;
-		}
-	}
 	if (tmp & SPI_CS_HIGH) {
 		u32_EDIT(chip->control,
 				SPI_CONTROL_SSPOL, SPI_CONTROL_SSPOL_ACT_HIGH);
diff -puN drivers/spi/spi_mpc83xx.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/spi_mpc83xx.c
@@ -232,12 +232,21 @@ int mpc83xx_spi_setup_transfer(struct sp
 	return 0;
 }
 
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
+
 static int mpc83xx_spi_setup(struct spi_device *spi)
 {
 	struct spi_bitbang *bitbang;
 	struct mpc83xx_spi *mpc83xx_spi;
 	int retval;
 
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
+		return -EINVAL;
+	}
+
 	if (!spi->max_speed_hz)
 		return -EINVAL;
 
diff -puN drivers/spi/spi_s3c24xx.c~spi-controller-drivers-check-for-unsupported-modes drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-controller-drivers-check-for-unsupported-modes
+++ a/drivers/spi/spi_s3c24xx.c
@@ -146,6 +146,9 @@ static int s3c24xx_spi_setupxfer(struct 
 	return 0;
 }
 
+/* the spi->mode bits understood by this driver: */
+#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
+
 static int s3c24xx_spi_setup(struct spi_device *spi)
 {
 	int ret;
@@ -153,8 +156,11 @@ static int s3c24xx_spi_setup(struct spi_
 	if (!spi->bits_per_word)
 		spi->bits_per_word = 8;
 
-	if ((spi->mode & SPI_LSB_FIRST) != 0)
+	if (spi->mode & ~MODEBITS) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			spi->mode & ~MODEBITS);
 		return -EINVAL;
+	}
 
 	ret = s3c24xx_spi_setupxfer(spi, NULL);
 	if (ret < 0) {
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-doc-update-describe-clock-mode-bits.patch
git-leds.patch
git-mmc.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
fix-usb-ohci-subvendor-for-toshiba-portege-4000.patch
ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory.patch
spi-controller-drivers-check-for-unsupported-modes.patch
rtc-ds1307-cleanups.patch
