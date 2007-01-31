From: akpm@osdl.org
Subject: + spi-freescale-imx-spi-controller-driver-v5.patch added to -mm tree
Date: Tue, 30 Jan 2007 16:28:42 -0800
Message-ID: <200701310028.l0V0Sg6e002356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58571 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbXAaA2x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 19:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.paterniani@swapp-eng.it, david-b@pacbell.net


The patch titled
     spi: freescale iMX SPI controller driver (v5)
has been added to the -mm tree.  Its filename is
     spi-freescale-imx-spi-controller-driver-v5.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: freescale iMX SPI controller driver (v5)
From: "Andrea Paterniani" <a.paterniani@swapp-eng.it>

- Dummy char for read-only transfer is now 0 (as suggested by D. Brownell).

- Solved a pio mode read only transfer bug.

- Added 2 new fields inside struct spi_imx_chip to manage bit clock wait
  and /SS pulse between spi burst.

Signed-off-by: Andrea Paterniani <a.paterniani@swapp-eng.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/spi/Kconfig                |   12 +++---
 drivers/spi/spi_imx.c              |   53 ++++++++++++++++++++-------
 include/asm-arm/arch-imx/spi_imx.h |    7 +--
 3 files changed, 51 insertions(+), 21 deletions(-)

diff -puN drivers/spi/Kconfig~spi-freescale-imx-spi-controller-driver-v5 drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-freescale-imx-spi-controller-driver-v5
+++ a/drivers/spi/Kconfig
@@ -75,6 +75,13 @@ config SPI_BUTTERFLY
 	  inexpensive battery powered microcontroller evaluation board.
 	  This same cable can be used to flash new firmware.
 
+config SPI_IMX
+	tristate "Freescale iMX SPI controller"
+	depends on SPI_MASTER && ARCH_IMX && EXPERIMENTAL
+	help
+	  This enables using the Freescale iMX SPI controller in master
+	  mode.
+
 config SPI_MPC83xx
 	tristate "Freescale MPC83xx SPI controller"
 	depends on SPI_MASTER && PPC_83xx && EXPERIMENTAL
@@ -94,11 +101,6 @@ config SPI_OMAP_UWIRE
 	help
 	  This hooks up to the MicroWire controller on OMAP1 chips.
 
-config SPI_IMX
-	tristate "iMX SPI controller driver"
-	depends on SPI_MASTER && ARCH_IMX && EXPERIMENTAL
-	help
-	  This is the iMX SPI controller driver.
 
 config SPI_PXA2XX
 	tristate "PXA2xx SSP SPI master"
diff -puN drivers/spi/spi_imx.c~spi-freescale-imx-spi-controller-driver-v5 drivers/spi/spi_imx.c
--- a/drivers/spi/spi_imx.c~spi-freescale-imx-spi-controller-driver-v5
+++ a/drivers/spi/spi_imx.c
@@ -140,13 +140,14 @@
 	SPI_CONTROL_POL_ACT_HIGH |	\
 	SPI_CONTROL_PHA_0 |		\
 	SPI_CONTROL_SPIEN |		\
-	SPI_CONTROL_SSCTL_0 |		\
+	SPI_CONTROL_SSCTL_1 |		\
 	SPI_CONTROL_MODE_MASTER |	\
 	SPI_CONTROL_DRCTL_0 |		\
 	SPI_CONTROL_DATARATE_MIN	\
 )
 #define SPI_DEFAULT_ENABLE_LOOPBACK	(0)
 #define SPI_DEFAULT_ENABLE_DMA		(0)
+#define SPI_DEFAULT_PERIOD_WAIT		(8)
 /*-------------------------------------------------------------------------*/
 
 
@@ -254,6 +255,7 @@ struct driver_data {
 /* Runtime state */
 struct chip_data {
 	u32 control;
+	u32 period;
 	u32 test;
 
 	u8 enable_dma:1;
@@ -296,7 +298,7 @@ static void restore_state(struct driver_
 		chip->test,
 		chip->control);
 	writel(chip->test, regs + SPI_TEST);
-	writel(0, regs + SPI_PERIOD);
+	writel(chip->period, regs + SPI_PERIOD);
 	writel(0, regs + SPI_INT_STATUS);
 	writel(chip->control, regs + SPI_CONTROL);
 }
@@ -348,9 +350,9 @@ static int write(struct driver_data *drv
 	if (n > 0) {
 		/* Fill SPI TXFIFO */
 		if (drv_data->rd_only) {
+			tx += n * n_bytes;
 			while (n--)
 				writel(SPI_DUMMY_u16, regs + SPI_TXDATA);
-			tx += n * n_bytes;
 		} else {
 			if (n_bytes == 1) {
 				while (n--) {
@@ -1203,20 +1205,43 @@ static int setup(struct spi_device *spi)
 			chip_info->enable_loopback =
 						SPI_DEFAULT_ENABLE_LOOPBACK;
 			chip_info->enable_dma = SPI_DEFAULT_ENABLE_DMA;
+			chip_info->ins_ss_pulse = 1;
+			chip_info->bclk_wait = SPI_DEFAULT_PERIOD_WAIT;
 			chip_info->cs_control = null_cs_control;
 		}
 	}
 
 	/* Now set controller state based on controller data */
 
-	/* SPI loopback */
-	if (chip_info->enable_loopback)
-		chip->test = SPI_TEST_LBC;
-	else
-		chip->test = 0;
+	if (first_setup) {
+		/* SPI loopback */
+		if (chip_info->enable_loopback)
+			chip->test = SPI_TEST_LBC;
+		else
+			chip->test = 0;
 
-	/* SPI dma driven */
-	chip->enable_dma = chip_info->enable_dma;
+		/* SPI dma driven */
+		chip->enable_dma = chip_info->enable_dma;
+
+		/* SPI /SS pulse between spi burst */
+		if (chip_info->ins_ss_pulse)
+			u32_EDIT(chip->control,
+				SPI_CONTROL_SSCTL, SPI_CONTROL_SSCTL_1);
+		else
+			u32_EDIT(chip->control,
+				SPI_CONTROL_SSCTL, SPI_CONTROL_SSCTL_0);
+
+		/* SPI bclk waits between each bits_per_word spi burst */
+		if (chip_info->bclk_wait > SPI_PERIOD_MAX_WAIT) {
+			dev_err(&spi->dev,
+				"setup - "
+				"bclk_wait exceeds max allowed (%d)\n",
+				SPI_PERIOD_MAX_WAIT);
+			goto err_first_setup;
+		}
+		chip->period = SPI_PERIOD_CSRC_BCLK |
+				(chip_info->bclk_wait & SPI_PERIOD_WAIT);
+	}
 
 	/* SPI mode */
 	tmp = spi->mode;
@@ -1316,17 +1341,20 @@ static int setup(struct spi_device *spi)
 		"setup succeded\n"
 		"    loopback enable   = %s\n"
 		"    dma enable        = %s\n"
+		"    insert /ss pulse  = %s\n"
+		"    period wait       = %d\n"
 		"    mode              = %d\n"
 		"    bits per word     = %d\n"
 		"    min speed         = %d Hz\n"
 		"    rounded max speed = %d Hz\n",
 		chip->test & SPI_TEST_LBC ? "Yes" : "No",
 		chip->enable_dma ? "Yes" : "No",
+		chip->control & SPI_CONTROL_SSCTL ? "Yes" : "No",
+		chip->period & SPI_PERIOD_WAIT,
 		spi->mode,
 		spi->bits_per_word,
 		spi_speed_hz(SPI_CONTROL_DATARATE_MIN),
 		spi->max_speed_hz);
-	return status;
 
 err_first_setup:
 	kfree(chip);
@@ -1416,7 +1444,8 @@ static int destroy_queue(struct driver_d
 	if (status != 0)
 		return status;
 
-	destroy_workqueue(drv_data->workqueue);
+	if (drv_data->workqueue)
+		destroy_workqueue(drv_data->workqueue);
 
 	return 0;
 }
diff -puN include/asm-arm/arch-imx/spi_imx.h~spi-freescale-imx-spi-controller-driver-v5 include/asm-arm/arch-imx/spi_imx.h
--- a/include/asm-arm/arch-imx/spi_imx.h~spi-freescale-imx-spi-controller-driver-v5
+++ a/include/asm-arm/arch-imx/spi_imx.h
@@ -50,17 +50,16 @@ struct spi_imx_master {
  *	sections.
  * @enable_dma : enables dma transfer (provided that controller driver has
  *	dma enabled too).
- * @mode : defines clock phase and polarity (SPI_MODE_0..SPI_MODE_3).
- * @bits_per_word : data transfer word size (1..16).
  * @ins_ss_pulse : enable /SS pulse insertion between SPI burst.
- * @period_bclk : used to define wait time (number of bit clock) between data
- *	transactions (0..32767).
+ * @bclk_wait : number of bclk waits between each bits_per_word SPI burst.
  * @cs_control : function pointer to board-specific function to assert/deassert
  *	I/O port to control HW generation of devices chip-select.
 */
 struct spi_imx_chip {
 	u8	enable_loopback:1;
 	u8	enable_dma:1;
+	u8	ins_ss_pulse:1;
+	u16	bclk_wait:15;
 	void (*cs_control)(u32 control);
 };
 
_

Patches currently in -mm which might be from a.paterniani@swapp-eng.it are

spi-freescale-imx-spi-controller-driver-bis.patch
spi-freescale-imx-spi-controller-driver-v5.patch
