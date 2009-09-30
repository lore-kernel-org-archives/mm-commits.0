From: akpm@linux-foundation.org
Subject: + spi-imx-rename-source-file-to-spi_imxc.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:53:04 -0700
Message-ID: <200909302353.n8UNr4A3010817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755131AbZI3Xxj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:53:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, dbrownell@users.sourceforge.net, g.liakhovetski@gmx.de, s.hauer@pengutronix.de


The patch titled
     spi-imx: rename source file to spi_imx.c
has been added to the -mm tree.  Its filename is
     spi-imx-rename-source-file-to-spi_imxc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: spi-imx: rename source file to spi_imx.c
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

This makes the filename match the Kconfig symbol and the driver name.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/Makefile  |    2=20
 drivers/spi/mxc_spi.c |  685 ----------------------------------------
 drivers/spi/spi_imx.c |  685 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 686 insertions(+), 686 deletions(-)

diff -puN drivers/spi/Makefile~spi-imx-rename-source-file-to-spi_imxc d=
rivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-imx-rename-source-file-to-spi_imxc
+++ a/drivers/spi/Makefile
@@ -17,7 +17,7 @@ obj-$(CONFIG_SPI_BITBANG)		+=3D spi_bitban
 obj-$(CONFIG_SPI_AU1550)		+=3D au1550_spi.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+=3D spi_butterfly.o
 obj-$(CONFIG_SPI_GPIO)			+=3D spi_gpio.o
-obj-$(CONFIG_SPI_IMX)			+=3D mxc_spi.o
+obj-$(CONFIG_SPI_IMX)			+=3D spi_imx.o
 obj-$(CONFIG_SPI_LM70_LLP)		+=3D spi_lm70llp.o
 obj-$(CONFIG_SPI_PXA2XX)		+=3D pxa2xx_spi.o
 obj-$(CONFIG_SPI_OMAP_UWIRE)		+=3D omap_uwire.o
diff -puN drivers/spi/mxc_spi.c~spi-imx-rename-source-file-to-spi_imxc =
/dev/null
--- a/drivers/spi/mxc_spi.c
+++ /dev/null
@@ -1,685 +0,0 @@
-/*
- * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserv=
ed.
- * Copyright (C) 2008 Juergen Beisert
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version 2
- * of the License, or (at your option) any later version.
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the
- * Free Software Foundation
- * 51 Franklin Street, Fifth Floor
- * Boston, MA  02110-1301, USA.
- */
-
-#include <linux/clk.h>
-#include <linux/completion.h>
-#include <linux/delay.h>
-#include <linux/err.h>
-#include <linux/gpio.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/io.h>
-#include <linux/irq.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/spi/spi.h>
-#include <linux/spi/spi_bitbang.h>
-#include <linux/types.h>
-
-#include <mach/spi.h>
-
-#define DRIVER_NAME "spi_imx"
-
-#define MXC_CSPIRXDATA		0x00
-#define MXC_CSPITXDATA		0x04
-#define MXC_CSPICTRL		0x08
-#define MXC_CSPIINT		0x0c
-#define MXC_RESET		0x1c
-
-/* generic defines to abstract from the different register layouts */
-#define MXC_INT_RR	(1 << 0) /* Receive data ready interrupt */
-#define MXC_INT_TE	(1 << 1) /* Transmit FIFO empty interrupt */
-
-struct mxc_spi_config {
-	unsigned int speed_hz;
-	unsigned int bpw;
-	unsigned int mode;
-	int cs;
-};
-
-struct mxc_spi_data {
-	struct spi_bitbang bitbang;
-
-	struct completion xfer_done;
-	void *base;
-	int irq;
-	struct clk *clk;
-	unsigned long spi_clk;
-	int *chipselect;
-
-	unsigned int count;
-	void (*tx)(struct mxc_spi_data *);
-	void (*rx)(struct mxc_spi_data *);
-	void *rx_buf;
-	const void *tx_buf;
-	unsigned int txfifo; /* number of words pushed in tx FIFO */
-
-	/* SoC specific functions */
-	void (*intctrl)(struct mxc_spi_data *, int);
-	int (*config)(struct mxc_spi_data *, struct mxc_spi_config *);
-	void (*trigger)(struct mxc_spi_data *);
-	int (*rx_available)(struct mxc_spi_data *);
-};
-
-#define MXC_SPI_BUF_RX(type)						\
-static void mxc_spi_buf_rx_##type(struct mxc_spi_data *mxc_spi)		\
-{									\
-	unsigned int val =3D readl(mxc_spi->base + MXC_CSPIRXDATA);	\
-									\
-	if (mxc_spi->rx_buf) {						\
-		*(type *)mxc_spi->rx_buf =3D val;				\
-		mxc_spi->rx_buf +=3D sizeof(type);			\
-	}								\
-}
-
-#define MXC_SPI_BUF_TX(type)						\
-static void mxc_spi_buf_tx_##type(struct mxc_spi_data *mxc_spi)		\
-{									\
-	type val =3D 0;							\
-									\
-	if (mxc_spi->tx_buf) {						\
-		val =3D *(type *)mxc_spi->tx_buf;				\
-		mxc_spi->tx_buf +=3D sizeof(type);			\
-	}								\
-									\
-	mxc_spi->count -=3D sizeof(type);					\
-									\
-	writel(val, mxc_spi->base + MXC_CSPITXDATA);			\
-}
-
-MXC_SPI_BUF_RX(u8)
-MXC_SPI_BUF_TX(u8)
-MXC_SPI_BUF_RX(u16)
-MXC_SPI_BUF_TX(u16)
-MXC_SPI_BUF_RX(u32)
-MXC_SPI_BUF_TX(u32)
-
-/* First entry is reserved, second entry is valid only if SDHC_SPIEN i=
s set
- * (which is currently not the case in this driver)
- */
-static int mxc_clkdivs[] =3D {0, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 9=
6, 128, 192,
-	256, 384, 512, 768, 1024};
-
-/* MX21, MX27 */
-static unsigned int mxc_spi_clkdiv_1(unsigned int fin,
-		unsigned int fspi)
-{
-	int i, max;
-
-	if (cpu_is_mx21())
-		max =3D 18;
-	else
-		max =3D 16;
-
-	for (i =3D 2; i < max; i++)
-		if (fspi * mxc_clkdivs[i] >=3D fin)
-			return i;
-
-	return max;
-}
-
-/* MX1, MX31, MX35 */
-static unsigned int mxc_spi_clkdiv_2(unsigned int fin,
-		unsigned int fspi)
-{
-	int i, div =3D 4;
-
-	for (i =3D 0; i < 7; i++) {
-		if (fspi * div >=3D fin)
-			return i;
-		div <<=3D 1;
-	}
-
-	return 7;
-}
-
-#define MX31_INTREG_TEEN	(1 << 0)
-#define MX31_INTREG_RREN	(1 << 3)
-
-#define MX31_CSPICTRL_ENABLE	(1 << 0)
-#define MX31_CSPICTRL_MASTER	(1 << 1)
-#define MX31_CSPICTRL_XCH	(1 << 2)
-#define MX31_CSPICTRL_POL	(1 << 4)
-#define MX31_CSPICTRL_PHA	(1 << 5)
-#define MX31_CSPICTRL_SSCTL	(1 << 6)
-#define MX31_CSPICTRL_SSPOL	(1 << 7)
-#define MX31_CSPICTRL_BC_SHIFT	8
-#define MX35_CSPICTRL_BL_SHIFT	20
-#define MX31_CSPICTRL_CS_SHIFT	24
-#define MX35_CSPICTRL_CS_SHIFT	12
-#define MX31_CSPICTRL_DR_SHIFT	16
-
-#define MX31_CSPISTATUS		0x14
-#define MX31_STATUS_RR		(1 << 3)
-
-/* These functions also work for the i.MX35, but be aware that
- * the i.MX35 has a slightly different register layout for bits
- * we do not use here.
- */
-static void mx31_intctrl(struct mxc_spi_data *mxc_spi, int enable)
-{
-	unsigned int val =3D 0;
-
-	if (enable & MXC_INT_TE)
-		val |=3D MX31_INTREG_TEEN;
-	if (enable & MXC_INT_RR)
-		val |=3D MX31_INTREG_RREN;
-
-	writel(val, mxc_spi->base + MXC_CSPIINT);
-}
-
-static void mx31_trigger(struct mxc_spi_data *mxc_spi)
-{
-	unsigned int reg;
-
-	reg =3D readl(mxc_spi->base + MXC_CSPICTRL);
-	reg |=3D MX31_CSPICTRL_XCH;
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
-}
-
-static int mx31_config(struct mxc_spi_data *mxc_spi,
-		struct mxc_spi_config *config)
-{
-	unsigned int reg =3D MX31_CSPICTRL_ENABLE | MX31_CSPICTRL_MASTER;
-
-	reg |=3D mxc_spi_clkdiv_2(mxc_spi->spi_clk, config->speed_hz) <<
-		MX31_CSPICTRL_DR_SHIFT;
-
-	if (cpu_is_mx31())
-		reg |=3D (config->bpw - 1) << MX31_CSPICTRL_BC_SHIFT;
-	else if (cpu_is_mx35()) {
-		reg |=3D (config->bpw - 1) << MX35_CSPICTRL_BL_SHIFT;
-		reg |=3D MX31_CSPICTRL_SSCTL;
-	}
-
-	if (config->mode & SPI_CPHA)
-		reg |=3D MX31_CSPICTRL_PHA;
-	if (config->mode & SPI_CPOL)
-		reg |=3D MX31_CSPICTRL_POL;
-	if (config->mode & SPI_CS_HIGH)
-		reg |=3D MX31_CSPICTRL_SSPOL;
-	if (config->cs < 0) {
-		if (cpu_is_mx31())
-			reg |=3D (config->cs + 32) << MX31_CSPICTRL_CS_SHIFT;
-		else if (cpu_is_mx35())
-			reg |=3D (config->cs + 32) << MX35_CSPICTRL_CS_SHIFT;
-	}
-
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
-
-	return 0;
-}
-
-static int mx31_rx_available(struct mxc_spi_data *mxc_spi)
-{
-	return readl(mxc_spi->base + MX31_CSPISTATUS) & MX31_STATUS_RR;
-}
-
-#define MX27_INTREG_RR		(1 << 4)
-#define MX27_INTREG_TEEN	(1 << 9)
-#define MX27_INTREG_RREN	(1 << 13)
-
-#define MX27_CSPICTRL_POL	(1 << 5)
-#define MX27_CSPICTRL_PHA	(1 << 6)
-#define MX27_CSPICTRL_SSPOL	(1 << 8)
-#define MX27_CSPICTRL_XCH	(1 << 9)
-#define MX27_CSPICTRL_ENABLE	(1 << 10)
-#define MX27_CSPICTRL_MASTER	(1 << 11)
-#define MX27_CSPICTRL_DR_SHIFT	14
-#define MX27_CSPICTRL_CS_SHIFT	19
-
-static void mx27_intctrl(struct mxc_spi_data *mxc_spi, int enable)
-{
-	unsigned int val =3D 0;
-
-	if (enable & MXC_INT_TE)
-		val |=3D MX27_INTREG_TEEN;
-	if (enable & MXC_INT_RR)
-		val |=3D MX27_INTREG_RREN;
-
-	writel(val, mxc_spi->base + MXC_CSPIINT);
-}
-
-static void mx27_trigger(struct mxc_spi_data *mxc_spi)
-{
-	unsigned int reg;
-
-	reg =3D readl(mxc_spi->base + MXC_CSPICTRL);
-	reg |=3D MX27_CSPICTRL_XCH;
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
-}
-
-static int mx27_config(struct mxc_spi_data *mxc_spi,
-		struct mxc_spi_config *config)
-{
-	unsigned int reg =3D MX27_CSPICTRL_ENABLE | MX27_CSPICTRL_MASTER;
-
-	reg |=3D mxc_spi_clkdiv_1(mxc_spi->spi_clk, config->speed_hz) <<
-		MX27_CSPICTRL_DR_SHIFT;
-	reg |=3D config->bpw - 1;
-
-	if (config->mode & SPI_CPHA)
-		reg |=3D MX27_CSPICTRL_PHA;
-	if (config->mode & SPI_CPOL)
-		reg |=3D MX27_CSPICTRL_POL;
-	if (config->mode & SPI_CS_HIGH)
-		reg |=3D MX27_CSPICTRL_SSPOL;
-	if (config->cs < 0)
-		reg |=3D (config->cs + 32) << MX27_CSPICTRL_CS_SHIFT;
-
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
-
-	return 0;
-}
-
-static int mx27_rx_available(struct mxc_spi_data *mxc_spi)
-{
-	return readl(mxc_spi->base + MXC_CSPIINT) & MX27_INTREG_RR;
-}
-
-#define MX1_INTREG_RR		(1 << 3)
-#define MX1_INTREG_TEEN		(1 << 8)
-#define MX1_INTREG_RREN		(1 << 11)
-
-#define MX1_CSPICTRL_POL	(1 << 4)
-#define MX1_CSPICTRL_PHA	(1 << 5)
-#define MX1_CSPICTRL_XCH	(1 << 8)
-#define MX1_CSPICTRL_ENABLE	(1 << 9)
-#define MX1_CSPICTRL_MASTER	(1 << 10)
-#define MX1_CSPICTRL_DR_SHIFT	13
-
-static void mx1_intctrl(struct mxc_spi_data *mxc_spi, int enable)
-{
-	unsigned int val =3D 0;
-
-	if (enable & MXC_INT_TE)
-		val |=3D MX1_INTREG_TEEN;
-	if (enable & MXC_INT_RR)
-		val |=3D MX1_INTREG_RREN;
-
-	writel(val, mxc_spi->base + MXC_CSPIINT);
-}
-
-static void mx1_trigger(struct mxc_spi_data *mxc_spi)
-{
-	unsigned int reg;
-
-	reg =3D readl(mxc_spi->base + MXC_CSPICTRL);
-	reg |=3D MX1_CSPICTRL_XCH;
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
-}
-
-static int mx1_config(struct mxc_spi_data *mxc_spi,
-		struct mxc_spi_config *config)
-{
-	unsigned int reg =3D MX1_CSPICTRL_ENABLE | MX1_CSPICTRL_MASTER;
-
-	reg |=3D mxc_spi_clkdiv_2(mxc_spi->spi_clk, config->speed_hz) <<
-		MX1_CSPICTRL_DR_SHIFT;
-	reg |=3D config->bpw - 1;
-
-	if (config->mode & SPI_CPHA)
-		reg |=3D MX1_CSPICTRL_PHA;
-	if (config->mode & SPI_CPOL)
-		reg |=3D MX1_CSPICTRL_POL;
-
-	writel(reg, mxc_spi->base + MXC_CSPICTRL);
-
-	return 0;
-}
-
-static int mx1_rx_available(struct mxc_spi_data *mxc_spi)
-{
-	return readl(mxc_spi->base + MXC_CSPIINT) & MX1_INTREG_RR;
-}
-
-static void mxc_spi_chipselect(struct spi_device *spi, int is_active)
-{
-	struct mxc_spi_data *mxc_spi =3D spi_master_get_devdata(spi->master);
-	unsigned int cs =3D 0;
-	int gpio =3D mxc_spi->chipselect[spi->chip_select];
-	struct mxc_spi_config config;
-
-	if (spi->mode & SPI_CS_HIGH)
-		cs =3D 1;
-
-	if (is_active =3D=3D BITBANG_CS_INACTIVE) {
-		if (gpio >=3D 0)
-			gpio_set_value(gpio, !cs);
-		return;
-	}
-
-	config.bpw =3D spi->bits_per_word;
-	config.speed_hz =3D spi->max_speed_hz;
-	config.mode =3D spi->mode;
-	config.cs =3D mxc_spi->chipselect[spi->chip_select];
-
-	mxc_spi->config(mxc_spi, &config);
-
-	/* Initialize the functions for transfer */
-	if (config.bpw <=3D 8) {
-		mxc_spi->rx =3D mxc_spi_buf_rx_u8;
-		mxc_spi->tx =3D mxc_spi_buf_tx_u8;
-	} else if (config.bpw <=3D 16) {
-		mxc_spi->rx =3D mxc_spi_buf_rx_u16;
-		mxc_spi->tx =3D mxc_spi_buf_tx_u16;
-	} else if (config.bpw <=3D 32) {
-		mxc_spi->rx =3D mxc_spi_buf_rx_u32;
-		mxc_spi->tx =3D mxc_spi_buf_tx_u32;
-	} else
-		BUG();
-
-	if (gpio >=3D 0)
-		gpio_set_value(gpio, cs);
-
-	return;
-}
-
-static void mxc_spi_push(struct mxc_spi_data *mxc_spi)
-{
-	while (mxc_spi->txfifo < 8) {
-		if (!mxc_spi->count)
-			break;
-		mxc_spi->tx(mxc_spi);
-		mxc_spi->txfifo++;
-	}
-
-	mxc_spi->trigger(mxc_spi);
-}
-
-static irqreturn_t mxc_spi_isr(int irq, void *dev_id)
-{
-	struct mxc_spi_data *mxc_spi =3D dev_id;
-
-	while (mxc_spi->rx_available(mxc_spi)) {
-		mxc_spi->rx(mxc_spi);
-		mxc_spi->txfifo--;
-	}
-
-	if (mxc_spi->count) {
-		mxc_spi_push(mxc_spi);
-		return IRQ_HANDLED;
-	}
-
-	if (mxc_spi->txfifo) {
-		/* No data left to push, but still waiting for rx data,
-		 * enable receive data available interrupt.
-		 */
-		mxc_spi->intctrl(mxc_spi, MXC_INT_RR);
-		return IRQ_HANDLED;
-	}
-
-	mxc_spi->intctrl(mxc_spi, 0);
-	complete(&mxc_spi->xfer_done);
-
-	return IRQ_HANDLED;
-}
-
-static int mxc_spi_setupxfer(struct spi_device *spi,
-				 struct spi_transfer *t)
-{
-	struct mxc_spi_data *mxc_spi =3D spi_master_get_devdata(spi->master);
-	struct mxc_spi_config config;
-
-	config.bpw =3D t ? t->bits_per_word : spi->bits_per_word;
-	config.speed_hz  =3D t ? t->speed_hz : spi->max_speed_hz;
-	config.mode =3D spi->mode;
-
-	mxc_spi->config(mxc_spi, &config);
-
-	return 0;
-}
-
-static int mxc_spi_transfer(struct spi_device *spi,
-				struct spi_transfer *transfer)
-{
-	struct mxc_spi_data *mxc_spi =3D spi_master_get_devdata(spi->master);
-
-	mxc_spi->tx_buf =3D transfer->tx_buf;
-	mxc_spi->rx_buf =3D transfer->rx_buf;
-	mxc_spi->count =3D transfer->len;
-	mxc_spi->txfifo =3D 0;
-
-	init_completion(&mxc_spi->xfer_done);
-
-	mxc_spi_push(mxc_spi);
-
-	mxc_spi->intctrl(mxc_spi, MXC_INT_TE);
-
-	wait_for_completion(&mxc_spi->xfer_done);
-
-	return transfer->len;
-}
-
-static int mxc_spi_setup(struct spi_device *spi)
-{
-	if (!spi->bits_per_word)
-		spi->bits_per_word =3D 8;
-
-	pr_debug("%s: mode %d, %u bpw, %d hz\n", __func__,
-		 spi->mode, spi->bits_per_word, spi->max_speed_hz);
-
-	mxc_spi_chipselect(spi, BITBANG_CS_INACTIVE);
-
-	return 0;
-}
-
-static void mxc_spi_cleanup(struct spi_device *spi)
-{
-}
-
-static int __init mxc_spi_probe(struct platform_device *pdev)
-{
-	struct spi_imx_master *mxc_platform_info;
-	struct spi_master *master;
-	struct mxc_spi_data *mxc_spi;
-	struct resource *res;
-	int i, ret;
-
-	mxc_platform_info =3D (struct spi_imx_master *)pdev->dev.platform_dat=
a;
-	if (!mxc_platform_info) {
-		dev_err(&pdev->dev, "can't get the platform data\n");
-		return -EINVAL;
-	}
-
-	master =3D spi_alloc_master(&pdev->dev, sizeof(struct mxc_spi_data));
-	if (!master)
-		return -ENOMEM;
-
-	platform_set_drvdata(pdev, master);
-
-	master->bus_num =3D pdev->id;
-	master->num_chipselect =3D mxc_platform_info->num_chipselect;
-
-	mxc_spi =3D spi_master_get_devdata(master);
-	mxc_spi->bitbang.master =3D spi_master_get(master);
-	mxc_spi->chipselect =3D mxc_platform_info->chipselect;
-
-	for (i =3D 0; i < master->num_chipselect; i++) {
-		if (mxc_spi->chipselect[i] < 0)
-			continue;
-		ret =3D gpio_request(mxc_spi->chipselect[i], DRIVER_NAME);
-		if (ret) {
-			i--;
-			while (i > 0)
-				if (mxc_spi->chipselect[i] >=3D 0)
-					gpio_free(mxc_spi->chipselect[i--]);
-			dev_err(&pdev->dev, "can't get cs gpios");
-			goto out_master_put;
-		}
-		gpio_direction_output(mxc_spi->chipselect[i], 1);
-	}
-
-	mxc_spi->bitbang.chipselect =3D mxc_spi_chipselect;
-	mxc_spi->bitbang.setup_transfer =3D mxc_spi_setupxfer;
-	mxc_spi->bitbang.txrx_bufs =3D mxc_spi_transfer;
-	mxc_spi->bitbang.master->setup =3D mxc_spi_setup;
-	mxc_spi->bitbang.master->cleanup =3D mxc_spi_cleanup;
-
-	init_completion(&mxc_spi->xfer_done);
-
-	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "can't get platform resource\n");
-		ret =3D -ENOMEM;
-		goto out_gpio_free;
-	}
-
-	if (!request_mem_region(res->start, resource_size(res), pdev->name)) =
{
-		dev_err(&pdev->dev, "request_mem_region failed\n");
-		ret =3D -EBUSY;
-		goto out_gpio_free;
-	}
-
-	mxc_spi->base =3D ioremap(res->start, resource_size(res));
-	if (!mxc_spi->base) {
-		ret =3D -EINVAL;
-		goto out_release_mem;
-	}
-
-	mxc_spi->irq =3D platform_get_irq(pdev, 0);
-	if (!mxc_spi->irq) {
-		ret =3D -EINVAL;
-		goto out_iounmap;
-	}
-
-	ret =3D request_irq(mxc_spi->irq, mxc_spi_isr, 0, DRIVER_NAME, mxc_sp=
i);
-	if (ret) {
-		dev_err(&pdev->dev, "can't get irq%d: %d\n", mxc_spi->irq, ret);
-		goto out_iounmap;
-	}
-
-	if (cpu_is_mx31() || cpu_is_mx35()) {
-		mxc_spi->intctrl =3D mx31_intctrl;
-		mxc_spi->config =3D mx31_config;
-		mxc_spi->trigger =3D mx31_trigger;
-		mxc_spi->rx_available =3D mx31_rx_available;
-	} else  if (cpu_is_mx27() || cpu_is_mx21()) {
-		mxc_spi->intctrl =3D mx27_intctrl;
-		mxc_spi->config =3D mx27_config;
-		mxc_spi->trigger =3D mx27_trigger;
-		mxc_spi->rx_available =3D mx27_rx_available;
-	} else if (cpu_is_mx1()) {
-		mxc_spi->intctrl =3D mx1_intctrl;
-		mxc_spi->config =3D mx1_config;
-		mxc_spi->trigger =3D mx1_trigger;
-		mxc_spi->rx_available =3D mx1_rx_available;
-	} else
-		BUG();
-
-	mxc_spi->clk =3D clk_get(&pdev->dev, NULL);
-	if (IS_ERR(mxc_spi->clk)) {
-		dev_err(&pdev->dev, "unable to get clock\n");
-		ret =3D PTR_ERR(mxc_spi->clk);
-		goto out_free_irq;
-	}
-
-	clk_enable(mxc_spi->clk);
-	mxc_spi->spi_clk =3D clk_get_rate(mxc_spi->clk);
-
-	if (!cpu_is_mx31() || !cpu_is_mx35())
-		writel(1, mxc_spi->base + MXC_RESET);
-
-	mxc_spi->intctrl(mxc_spi, 0);
-
-	ret =3D spi_bitbang_start(&mxc_spi->bitbang);
-	if (ret) {
-		dev_err(&pdev->dev, "bitbang start failed with %d\n", ret);
-		goto out_clk_put;
-	}
-
-	dev_info(&pdev->dev, "probed\n");
-
-	return ret;
-
-out_clk_put:
-	clk_disable(mxc_spi->clk);
-	clk_put(mxc_spi->clk);
-out_free_irq:
-	free_irq(mxc_spi->irq, mxc_spi);
-out_iounmap:
-	iounmap(mxc_spi->base);
-out_release_mem:
-	release_mem_region(res->start, resource_size(res));
-out_gpio_free:
-	for (i =3D 0; i < master->num_chipselect; i++)
-		if (mxc_spi->chipselect[i] >=3D 0)
-			gpio_free(mxc_spi->chipselect[i]);
-out_master_put:
-	spi_master_put(master);
-	kfree(master);
-	platform_set_drvdata(pdev, NULL);
-	return ret;
-}
-
-static int __exit mxc_spi_remove(struct platform_device *pdev)
-{
-	struct spi_master *master =3D platform_get_drvdata(pdev);
-	struct resource *res =3D platform_get_resource(pdev, IORESOURCE_MEM, =
0);
-	struct mxc_spi_data *mxc_spi =3D spi_master_get_devdata(master);
-	int i;
-
-	spi_bitbang_stop(&mxc_spi->bitbang);
-
-	writel(0, mxc_spi->base + MXC_CSPICTRL);
-	clk_disable(mxc_spi->clk);
-	clk_put(mxc_spi->clk);
-	free_irq(mxc_spi->irq, mxc_spi);
-	iounmap(mxc_spi->base);
-
-	for (i =3D 0; i < master->num_chipselect; i++)
-		if (mxc_spi->chipselect[i] >=3D 0)
-			gpio_free(mxc_spi->chipselect[i]);
-
-	spi_master_put(master);
-
-	release_mem_region(res->start, resource_size(res));
-
-	platform_set_drvdata(pdev, NULL);
-
-	return 0;
-}
-
-static struct platform_driver mxc_spi_driver =3D {
-	.driver =3D {
-		   .name =3D DRIVER_NAME,
-		   .owner =3D THIS_MODULE,
-		   },
-	.probe =3D mxc_spi_probe,
-	.remove =3D __exit_p(mxc_spi_remove),
-};
-
-static int __init mxc_spi_init(void)
-{
-	return platform_driver_register(&mxc_spi_driver);
-}
-
-static void __exit mxc_spi_exit(void)
-{
-	platform_driver_unregister(&mxc_spi_driver);
-}
-
-module_init(mxc_spi_init);
-module_exit(mxc_spi_exit);
-
-MODULE_DESCRIPTION("SPI Master Controller driver");
-MODULE_AUTHOR("Sascha Hauer, Pengutronix");
-MODULE_LICENSE("GPL");
diff -puN /dev/null drivers/spi/spi_imx.c
--- /dev/null
+++ a/drivers/spi/spi_imx.c
@@ -0,0 +1,685 @@
+/*
+ * Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserv=
ed.
+ * Copyright (C) 2008 Juergen Beisert
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the
+ * Free Software Foundation
+ * 51 Franklin Street, Fifth Floor
+ * Boston, MA  02110-1301, USA.
+ */
+
+#include <linux/clk.h>
+#include <linux/completion.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/types.h>
+
+#include <mach/spi.h>
+
+#define DRIVER_NAME "spi_imx"
+
+#define MXC_CSPIRXDATA		0x00
+#define MXC_CSPITXDATA		0x04
+#define MXC_CSPICTRL		0x08
+#define MXC_CSPIINT		0x0c
+#define MXC_RESET		0x1c
+
+/* generic defines to abstract from the different register layouts */
+#define MXC_INT_RR	(1 << 0) /* Receive data ready interrupt */
+#define MXC_INT_TE	(1 << 1) /* Transmit FIFO empty interrupt */
+
+struct spi_imx_config {
+	unsigned int speed_hz;
+	unsigned int bpw;
+	unsigned int mode;
+	int cs;
+};
+
+struct spi_imx_data {
+	struct spi_bitbang bitbang;
+
+	struct completion xfer_done;
+	void *base;
+	int irq;
+	struct clk *clk;
+	unsigned long spi_clk;
+	int *chipselect;
+
+	unsigned int count;
+	void (*tx)(struct spi_imx_data *);
+	void (*rx)(struct spi_imx_data *);
+	void *rx_buf;
+	const void *tx_buf;
+	unsigned int txfifo; /* number of words pushed in tx FIFO */
+
+	/* SoC specific functions */
+	void (*intctrl)(struct spi_imx_data *, int);
+	int (*config)(struct spi_imx_data *, struct spi_imx_config *);
+	void (*trigger)(struct spi_imx_data *);
+	int (*rx_available)(struct spi_imx_data *);
+};
+
+#define MXC_SPI_BUF_RX(type)						\
+static void spi_imx_buf_rx_##type(struct spi_imx_data *spi_imx)		\
+{									\
+	unsigned int val =3D readl(spi_imx->base + MXC_CSPIRXDATA);	\
+									\
+	if (spi_imx->rx_buf) {						\
+		*(type *)spi_imx->rx_buf =3D val;				\
+		spi_imx->rx_buf +=3D sizeof(type);			\
+	}								\
+}
+
+#define MXC_SPI_BUF_TX(type)						\
+static void spi_imx_buf_tx_##type(struct spi_imx_data *spi_imx)		\
+{									\
+	type val =3D 0;							\
+									\
+	if (spi_imx->tx_buf) {						\
+		val =3D *(type *)spi_imx->tx_buf;				\
+		spi_imx->tx_buf +=3D sizeof(type);			\
+	}								\
+									\
+	spi_imx->count -=3D sizeof(type);					\
+									\
+	writel(val, spi_imx->base + MXC_CSPITXDATA);			\
+}
+
+MXC_SPI_BUF_RX(u8)
+MXC_SPI_BUF_TX(u8)
+MXC_SPI_BUF_RX(u16)
+MXC_SPI_BUF_TX(u16)
+MXC_SPI_BUF_RX(u32)
+MXC_SPI_BUF_TX(u32)
+
+/* First entry is reserved, second entry is valid only if SDHC_SPIEN i=
s set
+ * (which is currently not the case in this driver)
+ */
+static int mxc_clkdivs[] =3D {0, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 9=
6, 128, 192,
+	256, 384, 512, 768, 1024};
+
+/* MX21, MX27 */
+static unsigned int spi_imx_clkdiv_1(unsigned int fin,
+		unsigned int fspi)
+{
+	int i, max;
+
+	if (cpu_is_mx21())
+		max =3D 18;
+	else
+		max =3D 16;
+
+	for (i =3D 2; i < max; i++)
+		if (fspi * mxc_clkdivs[i] >=3D fin)
+			return i;
+
+	return max;
+}
+
+/* MX1, MX31, MX35 */
+static unsigned int spi_imx_clkdiv_2(unsigned int fin,
+		unsigned int fspi)
+{
+	int i, div =3D 4;
+
+	for (i =3D 0; i < 7; i++) {
+		if (fspi * div >=3D fin)
+			return i;
+		div <<=3D 1;
+	}
+
+	return 7;
+}
+
+#define MX31_INTREG_TEEN	(1 << 0)
+#define MX31_INTREG_RREN	(1 << 3)
+
+#define MX31_CSPICTRL_ENABLE	(1 << 0)
+#define MX31_CSPICTRL_MASTER	(1 << 1)
+#define MX31_CSPICTRL_XCH	(1 << 2)
+#define MX31_CSPICTRL_POL	(1 << 4)
+#define MX31_CSPICTRL_PHA	(1 << 5)
+#define MX31_CSPICTRL_SSCTL	(1 << 6)
+#define MX31_CSPICTRL_SSPOL	(1 << 7)
+#define MX31_CSPICTRL_BC_SHIFT	8
+#define MX35_CSPICTRL_BL_SHIFT	20
+#define MX31_CSPICTRL_CS_SHIFT	24
+#define MX35_CSPICTRL_CS_SHIFT	12
+#define MX31_CSPICTRL_DR_SHIFT	16
+
+#define MX31_CSPISTATUS		0x14
+#define MX31_STATUS_RR		(1 << 3)
+
+/* These functions also work for the i.MX35, but be aware that
+ * the i.MX35 has a slightly different register layout for bits
+ * we do not use here.
+ */
+static void mx31_intctrl(struct spi_imx_data *spi_imx, int enable)
+{
+	unsigned int val =3D 0;
+
+	if (enable & MXC_INT_TE)
+		val |=3D MX31_INTREG_TEEN;
+	if (enable & MXC_INT_RR)
+		val |=3D MX31_INTREG_RREN;
+
+	writel(val, spi_imx->base + MXC_CSPIINT);
+}
+
+static void mx31_trigger(struct spi_imx_data *spi_imx)
+{
+	unsigned int reg;
+
+	reg =3D readl(spi_imx->base + MXC_CSPICTRL);
+	reg |=3D MX31_CSPICTRL_XCH;
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
+}
+
+static int mx31_config(struct spi_imx_data *spi_imx,
+		struct spi_imx_config *config)
+{
+	unsigned int reg =3D MX31_CSPICTRL_ENABLE | MX31_CSPICTRL_MASTER;
+
+	reg |=3D spi_imx_clkdiv_2(spi_imx->spi_clk, config->speed_hz) <<
+		MX31_CSPICTRL_DR_SHIFT;
+
+	if (cpu_is_mx31())
+		reg |=3D (config->bpw - 1) << MX31_CSPICTRL_BC_SHIFT;
+	else if (cpu_is_mx35()) {
+		reg |=3D (config->bpw - 1) << MX35_CSPICTRL_BL_SHIFT;
+		reg |=3D MX31_CSPICTRL_SSCTL;
+	}
+
+	if (config->mode & SPI_CPHA)
+		reg |=3D MX31_CSPICTRL_PHA;
+	if (config->mode & SPI_CPOL)
+		reg |=3D MX31_CSPICTRL_POL;
+	if (config->mode & SPI_CS_HIGH)
+		reg |=3D MX31_CSPICTRL_SSPOL;
+	if (config->cs < 0) {
+		if (cpu_is_mx31())
+			reg |=3D (config->cs + 32) << MX31_CSPICTRL_CS_SHIFT;
+		else if (cpu_is_mx35())
+			reg |=3D (config->cs + 32) << MX35_CSPICTRL_CS_SHIFT;
+	}
+
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
+
+	return 0;
+}
+
+static int mx31_rx_available(struct spi_imx_data *spi_imx)
+{
+	return readl(spi_imx->base + MX31_CSPISTATUS) & MX31_STATUS_RR;
+}
+
+#define MX27_INTREG_RR		(1 << 4)
+#define MX27_INTREG_TEEN	(1 << 9)
+#define MX27_INTREG_RREN	(1 << 13)
+
+#define MX27_CSPICTRL_POL	(1 << 5)
+#define MX27_CSPICTRL_PHA	(1 << 6)
+#define MX27_CSPICTRL_SSPOL	(1 << 8)
+#define MX27_CSPICTRL_XCH	(1 << 9)
+#define MX27_CSPICTRL_ENABLE	(1 << 10)
+#define MX27_CSPICTRL_MASTER	(1 << 11)
+#define MX27_CSPICTRL_DR_SHIFT	14
+#define MX27_CSPICTRL_CS_SHIFT	19
+
+static void mx27_intctrl(struct spi_imx_data *spi_imx, int enable)
+{
+	unsigned int val =3D 0;
+
+	if (enable & MXC_INT_TE)
+		val |=3D MX27_INTREG_TEEN;
+	if (enable & MXC_INT_RR)
+		val |=3D MX27_INTREG_RREN;
+
+	writel(val, spi_imx->base + MXC_CSPIINT);
+}
+
+static void mx27_trigger(struct spi_imx_data *spi_imx)
+{
+	unsigned int reg;
+
+	reg =3D readl(spi_imx->base + MXC_CSPICTRL);
+	reg |=3D MX27_CSPICTRL_XCH;
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
+}
+
+static int mx27_config(struct spi_imx_data *spi_imx,
+		struct spi_imx_config *config)
+{
+	unsigned int reg =3D MX27_CSPICTRL_ENABLE | MX27_CSPICTRL_MASTER;
+
+	reg |=3D spi_imx_clkdiv_1(spi_imx->spi_clk, config->speed_hz) <<
+		MX27_CSPICTRL_DR_SHIFT;
+	reg |=3D config->bpw - 1;
+
+	if (config->mode & SPI_CPHA)
+		reg |=3D MX27_CSPICTRL_PHA;
+	if (config->mode & SPI_CPOL)
+		reg |=3D MX27_CSPICTRL_POL;
+	if (config->mode & SPI_CS_HIGH)
+		reg |=3D MX27_CSPICTRL_SSPOL;
+	if (config->cs < 0)
+		reg |=3D (config->cs + 32) << MX27_CSPICTRL_CS_SHIFT;
+
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
+
+	return 0;
+}
+
+static int mx27_rx_available(struct spi_imx_data *spi_imx)
+{
+	return readl(spi_imx->base + MXC_CSPIINT) & MX27_INTREG_RR;
+}
+
+#define MX1_INTREG_RR		(1 << 3)
+#define MX1_INTREG_TEEN		(1 << 8)
+#define MX1_INTREG_RREN		(1 << 11)
+
+#define MX1_CSPICTRL_POL	(1 << 4)
+#define MX1_CSPICTRL_PHA	(1 << 5)
+#define MX1_CSPICTRL_XCH	(1 << 8)
+#define MX1_CSPICTRL_ENABLE	(1 << 9)
+#define MX1_CSPICTRL_MASTER	(1 << 10)
+#define MX1_CSPICTRL_DR_SHIFT	13
+
+static void mx1_intctrl(struct spi_imx_data *spi_imx, int enable)
+{
+	unsigned int val =3D 0;
+
+	if (enable & MXC_INT_TE)
+		val |=3D MX1_INTREG_TEEN;
+	if (enable & MXC_INT_RR)
+		val |=3D MX1_INTREG_RREN;
+
+	writel(val, spi_imx->base + MXC_CSPIINT);
+}
+
+static void mx1_trigger(struct spi_imx_data *spi_imx)
+{
+	unsigned int reg;
+
+	reg =3D readl(spi_imx->base + MXC_CSPICTRL);
+	reg |=3D MX1_CSPICTRL_XCH;
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
+}
+
+static int mx1_config(struct spi_imx_data *spi_imx,
+		struct spi_imx_config *config)
+{
+	unsigned int reg =3D MX1_CSPICTRL_ENABLE | MX1_CSPICTRL_MASTER;
+
+	reg |=3D spi_imx_clkdiv_2(spi_imx->spi_clk, config->speed_hz) <<
+		MX1_CSPICTRL_DR_SHIFT;
+	reg |=3D config->bpw - 1;
+
+	if (config->mode & SPI_CPHA)
+		reg |=3D MX1_CSPICTRL_PHA;
+	if (config->mode & SPI_CPOL)
+		reg |=3D MX1_CSPICTRL_POL;
+
+	writel(reg, spi_imx->base + MXC_CSPICTRL);
+
+	return 0;
+}
+
+static int mx1_rx_available(struct spi_imx_data *spi_imx)
+{
+	return readl(spi_imx->base + MXC_CSPIINT) & MX1_INTREG_RR;
+}
+
+static void spi_imx_chipselect(struct spi_device *spi, int is_active)
+{
+	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
+	unsigned int cs =3D 0;
+	int gpio =3D spi_imx->chipselect[spi->chip_select];
+	struct spi_imx_config config;
+
+	if (spi->mode & SPI_CS_HIGH)
+		cs =3D 1;
+
+	if (is_active =3D=3D BITBANG_CS_INACTIVE) {
+		if (gpio >=3D 0)
+			gpio_set_value(gpio, !cs);
+		return;
+	}
+
+	config.bpw =3D spi->bits_per_word;
+	config.speed_hz =3D spi->max_speed_hz;
+	config.mode =3D spi->mode;
+	config.cs =3D spi_imx->chipselect[spi->chip_select];
+
+	spi_imx->config(spi_imx, &config);
+
+	/* Initialize the functions for transfer */
+	if (config.bpw <=3D 8) {
+		spi_imx->rx =3D spi_imx_buf_rx_u8;
+		spi_imx->tx =3D spi_imx_buf_tx_u8;
+	} else if (config.bpw <=3D 16) {
+		spi_imx->rx =3D spi_imx_buf_rx_u16;
+		spi_imx->tx =3D spi_imx_buf_tx_u16;
+	} else if (config.bpw <=3D 32) {
+		spi_imx->rx =3D spi_imx_buf_rx_u32;
+		spi_imx->tx =3D spi_imx_buf_tx_u32;
+	} else
+		BUG();
+
+	if (gpio >=3D 0)
+		gpio_set_value(gpio, cs);
+
+	return;
+}
+
+static void spi_imx_push(struct spi_imx_data *spi_imx)
+{
+	while (spi_imx->txfifo < 8) {
+		if (!spi_imx->count)
+			break;
+		spi_imx->tx(spi_imx);
+		spi_imx->txfifo++;
+	}
+
+	spi_imx->trigger(spi_imx);
+}
+
+static irqreturn_t spi_imx_isr(int irq, void *dev_id)
+{
+	struct spi_imx_data *spi_imx =3D dev_id;
+
+	while (spi_imx->rx_available(spi_imx)) {
+		spi_imx->rx(spi_imx);
+		spi_imx->txfifo--;
+	}
+
+	if (spi_imx->count) {
+		spi_imx_push(spi_imx);
+		return IRQ_HANDLED;
+	}
+
+	if (spi_imx->txfifo) {
+		/* No data left to push, but still waiting for rx data,
+		 * enable receive data available interrupt.
+		 */
+		spi_imx->intctrl(spi_imx, MXC_INT_RR);
+		return IRQ_HANDLED;
+	}
+
+	spi_imx->intctrl(spi_imx, 0);
+	complete(&spi_imx->xfer_done);
+
+	return IRQ_HANDLED;
+}
+
+static int spi_imx_setupxfer(struct spi_device *spi,
+				 struct spi_transfer *t)
+{
+	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
+	struct spi_imx_config config;
+
+	config.bpw =3D t ? t->bits_per_word : spi->bits_per_word;
+	config.speed_hz  =3D t ? t->speed_hz : spi->max_speed_hz;
+	config.mode =3D spi->mode;
+
+	spi_imx->config(spi_imx, &config);
+
+	return 0;
+}
+
+static int spi_imx_transfer(struct spi_device *spi,
+				struct spi_transfer *transfer)
+{
+	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(spi->master);
+
+	spi_imx->tx_buf =3D transfer->tx_buf;
+	spi_imx->rx_buf =3D transfer->rx_buf;
+	spi_imx->count =3D transfer->len;
+	spi_imx->txfifo =3D 0;
+
+	init_completion(&spi_imx->xfer_done);
+
+	spi_imx_push(spi_imx);
+
+	spi_imx->intctrl(spi_imx, MXC_INT_TE);
+
+	wait_for_completion(&spi_imx->xfer_done);
+
+	return transfer->len;
+}
+
+static int spi_imx_setup(struct spi_device *spi)
+{
+	if (!spi->bits_per_word)
+		spi->bits_per_word =3D 8;
+
+	pr_debug("%s: mode %d, %u bpw, %d hz\n", __func__,
+		 spi->mode, spi->bits_per_word, spi->max_speed_hz);
+
+	spi_imx_chipselect(spi, BITBANG_CS_INACTIVE);
+
+	return 0;
+}
+
+static void spi_imx_cleanup(struct spi_device *spi)
+{
+}
+
+static int __init spi_imx_probe(struct platform_device *pdev)
+{
+	struct spi_imx_master *mxc_platform_info;
+	struct spi_master *master;
+	struct spi_imx_data *spi_imx;
+	struct resource *res;
+	int i, ret;
+
+	mxc_platform_info =3D (struct spi_imx_master *)pdev->dev.platform_dat=
a;
+	if (!mxc_platform_info) {
+		dev_err(&pdev->dev, "can't get the platform data\n");
+		return -EINVAL;
+	}
+
+	master =3D spi_alloc_master(&pdev->dev, sizeof(struct spi_imx_data));
+	if (!master)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, master);
+
+	master->bus_num =3D pdev->id;
+	master->num_chipselect =3D mxc_platform_info->num_chipselect;
+
+	spi_imx =3D spi_master_get_devdata(master);
+	spi_imx->bitbang.master =3D spi_master_get(master);
+	spi_imx->chipselect =3D mxc_platform_info->chipselect;
+
+	for (i =3D 0; i < master->num_chipselect; i++) {
+		if (spi_imx->chipselect[i] < 0)
+			continue;
+		ret =3D gpio_request(spi_imx->chipselect[i], DRIVER_NAME);
+		if (ret) {
+			i--;
+			while (i > 0)
+				if (spi_imx->chipselect[i] >=3D 0)
+					gpio_free(spi_imx->chipselect[i--]);
+			dev_err(&pdev->dev, "can't get cs gpios");
+			goto out_master_put;
+		}
+		gpio_direction_output(spi_imx->chipselect[i], 1);
+	}
+
+	spi_imx->bitbang.chipselect =3D spi_imx_chipselect;
+	spi_imx->bitbang.setup_transfer =3D spi_imx_setupxfer;
+	spi_imx->bitbang.txrx_bufs =3D spi_imx_transfer;
+	spi_imx->bitbang.master->setup =3D spi_imx_setup;
+	spi_imx->bitbang.master->cleanup =3D spi_imx_cleanup;
+
+	init_completion(&spi_imx->xfer_done);
+
+	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(&pdev->dev, "can't get platform resource\n");
+		ret =3D -ENOMEM;
+		goto out_gpio_free;
+	}
+
+	if (!request_mem_region(res->start, resource_size(res), pdev->name)) =
{
+		dev_err(&pdev->dev, "request_mem_region failed\n");
+		ret =3D -EBUSY;
+		goto out_gpio_free;
+	}
+
+	spi_imx->base =3D ioremap(res->start, resource_size(res));
+	if (!spi_imx->base) {
+		ret =3D -EINVAL;
+		goto out_release_mem;
+	}
+
+	spi_imx->irq =3D platform_get_irq(pdev, 0);
+	if (!spi_imx->irq) {
+		ret =3D -EINVAL;
+		goto out_iounmap;
+	}
+
+	ret =3D request_irq(spi_imx->irq, spi_imx_isr, 0, DRIVER_NAME, spi_im=
x);
+	if (ret) {
+		dev_err(&pdev->dev, "can't get irq%d: %d\n", spi_imx->irq, ret);
+		goto out_iounmap;
+	}
+
+	if (cpu_is_mx31() || cpu_is_mx35()) {
+		spi_imx->intctrl =3D mx31_intctrl;
+		spi_imx->config =3D mx31_config;
+		spi_imx->trigger =3D mx31_trigger;
+		spi_imx->rx_available =3D mx31_rx_available;
+	} else  if (cpu_is_mx27() || cpu_is_mx21()) {
+		spi_imx->intctrl =3D mx27_intctrl;
+		spi_imx->config =3D mx27_config;
+		spi_imx->trigger =3D mx27_trigger;
+		spi_imx->rx_available =3D mx27_rx_available;
+	} else if (cpu_is_mx1()) {
+		spi_imx->intctrl =3D mx1_intctrl;
+		spi_imx->config =3D mx1_config;
+		spi_imx->trigger =3D mx1_trigger;
+		spi_imx->rx_available =3D mx1_rx_available;
+	} else
+		BUG();
+
+	spi_imx->clk =3D clk_get(&pdev->dev, NULL);
+	if (IS_ERR(spi_imx->clk)) {
+		dev_err(&pdev->dev, "unable to get clock\n");
+		ret =3D PTR_ERR(spi_imx->clk);
+		goto out_free_irq;
+	}
+
+	clk_enable(spi_imx->clk);
+	spi_imx->spi_clk =3D clk_get_rate(spi_imx->clk);
+
+	if (!cpu_is_mx31() || !cpu_is_mx35())
+		writel(1, spi_imx->base + MXC_RESET);
+
+	spi_imx->intctrl(spi_imx, 0);
+
+	ret =3D spi_bitbang_start(&spi_imx->bitbang);
+	if (ret) {
+		dev_err(&pdev->dev, "bitbang start failed with %d\n", ret);
+		goto out_clk_put;
+	}
+
+	dev_info(&pdev->dev, "probed\n");
+
+	return ret;
+
+out_clk_put:
+	clk_disable(spi_imx->clk);
+	clk_put(spi_imx->clk);
+out_free_irq:
+	free_irq(spi_imx->irq, spi_imx);
+out_iounmap:
+	iounmap(spi_imx->base);
+out_release_mem:
+	release_mem_region(res->start, resource_size(res));
+out_gpio_free:
+	for (i =3D 0; i < master->num_chipselect; i++)
+		if (spi_imx->chipselect[i] >=3D 0)
+			gpio_free(spi_imx->chipselect[i]);
+out_master_put:
+	spi_master_put(master);
+	kfree(master);
+	platform_set_drvdata(pdev, NULL);
+	return ret;
+}
+
+static int __exit spi_imx_remove(struct platform_device *pdev)
+{
+	struct spi_master *master =3D platform_get_drvdata(pdev);
+	struct resource *res =3D platform_get_resource(pdev, IORESOURCE_MEM, =
0);
+	struct spi_imx_data *spi_imx =3D spi_master_get_devdata(master);
+	int i;
+
+	spi_bitbang_stop(&spi_imx->bitbang);
+
+	writel(0, spi_imx->base + MXC_CSPICTRL);
+	clk_disable(spi_imx->clk);
+	clk_put(spi_imx->clk);
+	free_irq(spi_imx->irq, spi_imx);
+	iounmap(spi_imx->base);
+
+	for (i =3D 0; i < master->num_chipselect; i++)
+		if (spi_imx->chipselect[i] >=3D 0)
+			gpio_free(spi_imx->chipselect[i]);
+
+	spi_master_put(master);
+
+	release_mem_region(res->start, resource_size(res));
+
+	platform_set_drvdata(pdev, NULL);
+
+	return 0;
+}
+
+static struct platform_driver spi_imx_driver =3D {
+	.driver =3D {
+		   .name =3D DRIVER_NAME,
+		   .owner =3D THIS_MODULE,
+		   },
+	.probe =3D spi_imx_probe,
+	.remove =3D __exit_p(spi_imx_remove),
+};
+
+static int __init spi_imx_init(void)
+{
+	return platform_driver_register(&spi_imx_driver);
+}
+
+static void __exit spi_imx_exit(void)
+{
+	platform_driver_unregister(&spi_imx_driver);
+}
+
+module_init(spi_imx_init);
+module_exit(spi_imx_exit);
+
+MODULE_DESCRIPTION("SPI Master Controller driver");
+MODULE_AUTHOR("Sascha Hauer, Pengutronix");
+MODULE_LICENSE("GPL");
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
spi-imx-rename-source-file-to-spi_imxc.patch
spi-imx-update-state-correctly.patch
spi-imx-fix-initial-chipselect-settings.patch
spi-imx-setup-mode_bits-we-can-handle.patch
spi-imx-no-need-to-assert-bits_per_word-being-initialized.patch
spi-imx-initialize-complete-config-struct.patch
spi-imx-strip-down-chipselect-function-to-only-drive-the-chipselect.pat=
ch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
