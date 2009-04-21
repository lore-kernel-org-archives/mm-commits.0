From: akpm@linux-foundation.org
Subject: + spi-move-more-spi_setup-functionality-into-core.patch added to -mm tree
Date: Tue, 21 Apr 2009 13:48:33 -0700
Message-ID: <200904212048.n3LKmXQV026507@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144AbZDUUut (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 16:50:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net


The patch titled
     spi: move more spi_setup() functionality into core
has been added to the -mm tree.  Its filename is
     spi-move-more-spi_setup-functionality-into-core.patch

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
Subject: spi: move more spi_setup() functionality into core
From: David Brownell <dbrownell@users.sourceforge.net>

Move some common spi_setup() error checks into the SPI framework from the
spi_master controller drivers:

 - Add a new "mode_bits" field to spi_master

 - Use that in spi_setup to validate the spi->mode value being
   requested.  Setting this new field is now mandatory for any
   controller supporting more than vanilla SPI_MODE_0.

 - Update all spi_master drivers to:

     * Initialize that field
     * Remove current spi_setup() checks using that value.

This is a net minor code shrink.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/atmel_spi.c       |   12 +++---------
 drivers/spi/au1550_spi.c      |   12 +++---------
 drivers/spi/mpc52xx_psc_spi.c |   12 +++---------
 drivers/spi/omap2_mcspi.c     |   12 +++---------
 drivers/spi/omap_uwire.c      |   12 +++---------
 drivers/spi/orion_spi.c       |    9 +++------
 drivers/spi/pxa2xx_spi.c      |   12 +++---------
 drivers/spi/spi.c             |   11 +++++++++++
 drivers/spi/spi_bfin5xx.c     |    9 +++------
 drivers/spi/spi_bitbang.c     |    9 +++------
 drivers/spi/spi_imx.c         |   12 +++---------
 drivers/spi/spi_mpc83xx.c     |   14 ++++----------
 drivers/spi/spi_s3c24xx.c     |   12 +++---------
 drivers/spi/spi_txx9.c        |    9 +++------
 drivers/spi/xilinx_spi.c      |   12 +++---------
 include/linux/spi/spi.h       |    3 +++
 16 files changed, 57 insertions(+), 115 deletions(-)

diff -puN drivers/spi/atmel_spi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/atmel_spi.c
--- a/drivers/spi/atmel_spi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/atmel_spi.c
@@ -530,9 +530,6 @@ atmel_spi_interrupt(int irq, void *dev_i
 	return ret;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
-
 static int atmel_spi_setup(struct spi_device *spi)
 {
 	struct atmel_spi	*as;
@@ -562,12 +559,6 @@ static int atmel_spi_setup(struct spi_de
 		return -EINVAL;
 	}
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	/* see notes above re chipselect */
 	if (!atmel_spi_is_v2()
 			&& spi->chip_select == 0
@@ -773,6 +764,9 @@ static int __init atmel_spi_probe(struct
 	if (!master)
 		goto out_free;
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+
 	master->bus_num = pdev->id;
 	master->num_chipselect = 4;
 	master->setup = atmel_spi_setup;
diff -puN drivers/spi/au1550_spi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/au1550_spi.c
--- a/drivers/spi/au1550_spi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/au1550_spi.c
@@ -284,9 +284,6 @@ static int au1550_spi_setupxfer(struct s
 	return 0;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST)
-
 static int au1550_spi_setup(struct spi_device *spi)
 {
 	struct au1550_spi *hw = spi_master_get_devdata(spi->master);
@@ -297,12 +294,6 @@ static int au1550_spi_setup(struct spi_d
 		return -EINVAL;
 	}
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	if (spi->max_speed_hz == 0)
 		spi->max_speed_hz = hw->freq_max;
 	if (spi->max_speed_hz > hw->freq_max
@@ -779,6 +770,9 @@ static int __init au1550_spi_probe(struc
 		goto err_nomem;
 	}
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST;
+
 	hw = spi_master_get_devdata(master);
 
 	hw->master = spi_master_get(master);
diff -puN drivers/spi/mpc52xx_psc_spi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -261,9 +261,6 @@ static void mpc52xx_psc_spi_work(struct 
 	spin_unlock_irq(&mps->lock);
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST)
-
 static int mpc52xx_psc_spi_setup(struct spi_device *spi)
 {
 	struct mpc52xx_psc_spi *mps = spi_master_get_devdata(spi->master);
@@ -273,12 +270,6 @@ static int mpc52xx_psc_spi_setup(struct 
 	if (spi->bits_per_word%8)
 		return -EINVAL;
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	if (!cs) {
 		cs = kzalloc(sizeof *cs, GFP_KERNEL);
 		if (!cs)
@@ -385,6 +376,9 @@ static int __init mpc52xx_psc_spi_do_pro
 	dev_set_drvdata(dev, master);
 	mps = spi_master_get_devdata(master);
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH | SPI_LSB_FIRST;
+
 	mps->irq = irq;
 	if (pdata == NULL) {
 		dev_warn(dev, "probe called without platform data, no "
diff -puN drivers/spi/omap2_mcspi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/omap2_mcspi.c
--- a/drivers/spi/omap2_mcspi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/omap2_mcspi.c
@@ -603,9 +603,6 @@ static int omap2_mcspi_request_dma(struc
 	return 0;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
-
 static int omap2_mcspi_setup(struct spi_device *spi)
 {
 	int			ret;
@@ -613,12 +610,6 @@ static int omap2_mcspi_setup(struct spi_
 	struct omap2_mcspi_dma	*mcspi_dma;
 	struct omap2_mcspi_cs	*cs = spi->controller_state;
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	if (spi->bits_per_word < 4 || spi->bits_per_word > 32) {
 		dev_dbg(&spi->dev, "setup: unsupported %d bit words\n",
 			spi->bits_per_word);
@@ -982,6 +973,9 @@ static int __init omap2_mcspi_probe(stru
 		return -ENOMEM;
 	}
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+
 	if (pdev->id != -1)
 		master->bus_num = pdev->id;
 
diff -puN drivers/spi/omap_uwire.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/omap_uwire.c
--- a/drivers/spi/omap_uwire.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/omap_uwire.c
@@ -447,19 +447,10 @@ done:
 	return status;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
-
 static int uwire_setup(struct spi_device *spi)
 {
 	struct uwire_state *ust = spi->controller_state;
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	if (ust == NULL) {
 		ust = kzalloc(sizeof(*ust), GFP_KERNEL);
 		if (ust == NULL)
@@ -520,6 +511,9 @@ static int __init uwire_probe(struct pla
 
 	uwire_write_reg(UWIRE_SR3, 1);
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+
 	master->bus_num = 2;	/* "official" */
 	master->num_chipselect = 4;
 	master->setup = uwire_setup;
diff -puN drivers/spi/orion_spi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/orion_spi.c
--- a/drivers/spi/orion_spi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/orion_spi.c
@@ -358,12 +358,6 @@ static int orion_spi_setup(struct spi_de
 
 	orion_spi = spi_master_get_devdata(spi->master);
 
-	if (spi->mode) {
-		dev_err(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode);
-		return -EINVAL;
-	}
-
 	/* Fix ac timing if required.   */
 	if (orion_spi->spi_info->enable_clock_fix)
 		orion_spi_setbits(orion_spi, ORION_SPI_IF_CONFIG_REG,
@@ -473,6 +467,9 @@ static int __init orion_spi_probe(struct
 	if (pdev->id != -1)
 		master->bus_num = pdev->id;
 
+	/* we support only mode 0, and no options */
+	master->mode_bits = 0;
+
 	master->setup = orion_spi_setup;
 	master->transfer = orion_spi_transfer;
 	master->num_chipselect = ORION_NUM_CHIPSELECTS;
diff -puN drivers/spi/pxa2xx_spi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/pxa2xx_spi.c
--- a/drivers/spi/pxa2xx_spi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/pxa2xx_spi.c
@@ -1185,9 +1185,6 @@ static int transfer(struct spi_device *s
 	return 0;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA)
-
 static int setup_cs(struct spi_device *spi, struct chip_data *chip,
 		    struct pxa2xx_spi_chip *chip_info)
 {
@@ -1252,12 +1249,6 @@ static int setup(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	/* Only alloc on first setup */
 	chip = spi_get_ctldata(spi);
 	if (!chip) {
@@ -1490,6 +1481,9 @@ static int __init pxa2xx_spi_probe(struc
 	drv_data->pdev = pdev;
 	drv_data->ssp = ssp;
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA;
+
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
 	master->dma_alignment = DMA_ALIGNMENT;
diff -puN drivers/spi/spi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/spi.c
--- a/drivers/spi/spi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/spi.c
@@ -607,8 +607,19 @@ EXPORT_SYMBOL_GPL(spi_busnum_to_master);
  */
 int spi_setup(struct spi_device *spi)
 {
+	unsigned	bad_bits;
 	int		status;
 
+	/* help drivers fail *cleanly* when they need options
+	 * that aren't supported with their current master
+	 */
+	bad_bits = spi->mode & ~spi->master->mode_bits;
+	if (bad_bits) {
+		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
+			bad_bits);
+		return -EINVAL;
+	}
+
 	if (!spi->bits_per_word)
 		spi->bits_per_word = 8;
 
diff -puN drivers/spi/spi_bfin5xx.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/spi_bfin5xx.c
@@ -1010,12 +1010,6 @@ static int bfin_spi_setup(struct spi_dev
 	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
 	int ret;
 
-	/* Abort device setup if requested features are not supported */
-	if (spi->mode & ~(SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST)) {
-		dev_err(&spi->dev, "requested mode not fully supported\n");
-		return -EINVAL;
-	}
-
 	if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
 		return -EINVAL;
 
@@ -1283,6 +1277,9 @@ static int __init bfin_spi_probe(struct 
 	drv_data->pdev = pdev;
 	drv_data->pin_req = platform_info->pin_req;
 
+	/* the spi->mode bits supported by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_LSB_FIRST;
+
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
 	master->cleanup = bfin_spi_cleanup;
diff -puN drivers/spi/spi_bitbang.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/spi_bitbang.c
--- a/drivers/spi/spi_bitbang.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/spi_bitbang.c
@@ -188,12 +188,6 @@ int spi_bitbang_setup(struct spi_device 
 
 	bitbang = spi_master_get_devdata(spi->master);
 
-	/* Bitbangers can support SPI_CS_HIGH, SPI_3WIRE, and so on;
-	 * add those to master->flags, and provide the other support.
-	 */
-	if ((spi->mode & ~(SPI_CPOL|SPI_CPHA|bitbang->flags)) != 0)
-		return -EINVAL;
-
 	if (!cs) {
 		cs = kzalloc(sizeof *cs, GFP_KERNEL);
 		if (!cs)
@@ -452,6 +446,9 @@ int spi_bitbang_start(struct spi_bitbang
 	spin_lock_init(&bitbang->lock);
 	INIT_LIST_HEAD(&bitbang->queue);
 
+	if (!bitbang->master->mode_bits)
+		bitbang->master->mode_bits = SPI_CPOL | SPI_CPHA | bitbang->flags;
+
 	if (!bitbang->master->transfer)
 		bitbang->master->transfer = spi_bitbang_transfer;
 	if (!bitbang->txrx_bufs) {
diff -puN drivers/spi/spi_imx.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/spi_imx.c
@@ -1171,9 +1171,6 @@ msg_rejected:
 	return -EINVAL;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
-
 /* On first setup bad values must free chip_data memory since will cause
    spi_new_device to fail. Bad value setup from protocol driver are simply not
    applied and notified to the calling driver. */
@@ -1186,12 +1183,6 @@ static int setup(struct spi_device *spi)
 	u32 tmp;
 	int status = 0;
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	/* Get controller data */
 	chip_info = spi->controller_data;
 
@@ -1478,6 +1469,9 @@ static int __init spi_imx_probe(struct p
 	drv_data->master_info = platform_info;
 	drv_data->pdev = pdev;
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+
 	master->bus_num = pdev->id;
 	master->num_chipselect = platform_info->num_chipselect;
 	master->dma_alignment = DMA_ALIGNMENT;
diff -puN drivers/spi/spi_mpc83xx.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/spi_mpc83xx.c
@@ -419,10 +419,6 @@ static void mpc83xx_spi_work(struct work
 	spin_unlock_irq(&mpc83xx_spi->lock);
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS	(SPI_CPOL | SPI_CPHA | SPI_CS_HIGH \
-			| SPI_LSB_FIRST | SPI_LOOP)
-
 static int mpc83xx_spi_setup(struct spi_device *spi)
 {
 	struct mpc83xx_spi *mpc83xx_spi;
@@ -430,12 +426,6 @@ static int mpc83xx_spi_setup(struct spi_
 	u32 hw_mode;
 	struct spi_mpc83xx_cs	*cs = spi->controller_state;
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	if (!spi->max_speed_hz)
 		return -EINVAL;
 
@@ -562,6 +552,10 @@ mpc83xx_spi_probe(struct device *dev, st
 
 	dev_set_drvdata(dev, master);
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH
+			| SPI_LSB_FIRST | SPI_LOOP;
+
 	master->setup = mpc83xx_spi_setup;
 	master->transfer = mpc83xx_spi_transfer;
 	master->cleanup = mpc83xx_spi_cleanup;
diff -puN drivers/spi/spi_s3c24xx.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/spi_s3c24xx.c
@@ -146,19 +146,10 @@ static int s3c24xx_spi_setupxfer(struct 
 	return 0;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA | SPI_CS_HIGH)
-
 static int s3c24xx_spi_setup(struct spi_device *spi)
 {
 	int ret;
 
-	if (spi->mode & ~MODEBITS) {
-		dev_dbg(&spi->dev, "setup: unsupported mode bits %x\n",
-			spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	ret = s3c24xx_spi_setupxfer(spi, NULL);
 	if (ret < 0) {
 		dev_err(&spi->dev, "setupxfer returned %d\n", ret);
@@ -283,6 +274,9 @@ static int __init s3c24xx_spi_probe(stru
 
 	/* setup the master state. */
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA | SPI_CS_HIGH;
+
 	master->num_chipselect = hw->pdata->num_cs;
 	master->bus_num = pdata->bus_num;
 
diff -puN drivers/spi/spi_txx9.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/spi_txx9.c
--- a/drivers/spi/spi_txx9.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/spi_txx9.c
@@ -110,17 +110,11 @@ static void txx9spi_cs_func(struct spi_d
 	ndelay(cs_delay);	/* CS Setup Time / CS Recovery Time */
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS	(SPI_CS_HIGH|SPI_CPOL|SPI_CPHA)
-
 static int txx9spi_setup(struct spi_device *spi)
 {
 	struct txx9spi *c = spi_master_get_devdata(spi->master);
 	u8 bits_per_word;
 
-	if (spi->mode & ~MODEBITS)
-		return -EINVAL;
-
 	if (!spi->max_speed_hz
 			|| spi->max_speed_hz > c->max_speed_hz
 			|| spi->max_speed_hz < c->min_speed_hz)
@@ -414,6 +408,9 @@ static int __init txx9spi_probe(struct p
 		 (unsigned long long)res->start, irq,
 		 (c->baseclk + 500000) / 1000000);
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CS_HIGH | SPI_CPOL | SPI_CPHA;
+
 	master->bus_num = dev->id;
 	master->setup = txx9spi_setup;
 	master->transfer = txx9spi_transfer;
diff -puN drivers/spi/xilinx_spi.c~spi-move-more-spi_setup-functionality-into-core drivers/spi/xilinx_spi.c
--- a/drivers/spi/xilinx_spi.c~spi-move-more-spi_setup-functionality-into-core
+++ a/drivers/spi/xilinx_spi.c
@@ -158,9 +158,6 @@ static int xilinx_spi_setup_transfer(str
 	return 0;
 }
 
-/* the spi->mode bits understood by this driver: */
-#define MODEBITS (SPI_CPOL | SPI_CPHA)
-
 static int xilinx_spi_setup(struct spi_device *spi)
 {
 	struct spi_bitbang *bitbang;
@@ -170,12 +167,6 @@ static int xilinx_spi_setup(struct spi_d
 	xspi = spi_master_get_devdata(spi->master);
 	bitbang = &xspi->bitbang;
 
-	if (spi->mode & ~MODEBITS) {
-		dev_err(&spi->dev, "%s, unsupported mode bits %x\n",
-			__func__, spi->mode & ~MODEBITS);
-		return -EINVAL;
-	}
-
 	retval = xilinx_spi_setup_transfer(spi, NULL);
 	if (retval < 0)
 		return retval;
@@ -327,6 +318,9 @@ static int __init xilinx_spi_of_probe(st
 		goto put_master;
 	}
 
+	/* the spi->mode bits understood by this driver: */
+	master->mode_bits = SPI_CPOL | SPI_CPHA;
+
 	xspi = spi_master_get_devdata(master);
 	xspi->bitbang.master = spi_master_get(master);
 	xspi->bitbang.chipselect = xilinx_spi_chipselect;
diff -puN include/linux/spi/spi.h~spi-move-more-spi_setup-functionality-into-core include/linux/spi/spi.h
--- a/include/linux/spi/spi.h~spi-move-more-spi_setup-functionality-into-core
+++ a/include/linux/spi/spi.h
@@ -245,6 +245,9 @@ struct spi_master {
 	 */
 	u16			dma_alignment;
 
+	/* spi_device.mode flags understood by this controller driver */
+	u16			mode_bits;
+
 	/* Setup mode and clock, etc (spi driver may call many times).
 	 *
 	 * IMPORTANT:  this may be called when transfers to another
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
pxa2xx_spi-restore-drcmr-on-resume.patch
spi-documentation-emphasise-spi_mastersetup-semantics.patch
linux-next.patch
spi_bfin5xx-limit-reaches-1.patch
spi-move-common-spi_setup-functionality-into-core.patch
spi-move-more-spi_setup-functionality-into-core.patch
rtc-rtc-ds1307-add-ds3231.patch

