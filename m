From: akpm@linux-foundation.org
Subject: - gpiolib-i2c-spi-drivers-handle-rmmod-better.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:57:03 -0700
Message-ID: <200804282157.m3SLv3RR018366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965040AbYD1V5X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:57:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@pengutronix.de, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: i2c/spi drivers: handle rmmod better
has been removed from the -mm tree.  Its filename was
     gpiolib-i2c-spi-drivers-handle-rmmod-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: i2c/spi drivers: handle rmmod better
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>

Use the newly introduced owner field in struct gpio_chip to protect the
current (small) set of non-SOC GPIO drivers from being unloaded while any of
their GPIOs are in use.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
[ add mcp23s08 and pcf857x ]
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/mcp23s08.c |    1 +
 drivers/gpio/pca953x.c  |    1 +
 drivers/gpio/pcf857x.c  |    1 +
 3 files changed, 3 insertions(+)

diff -puN drivers/gpio/mcp23s08.c~gpiolib-i2c-spi-drivers-handle-rmmod-better drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~gpiolib-i2c-spi-drivers-handle-rmmod-better
+++ a/drivers/gpio/mcp23s08.c
@@ -239,6 +239,7 @@ static int mcp23s08_probe(struct spi_dev
 	mcp->chip.base = pdata->base;
 	mcp->chip.ngpio = 8;
 	mcp->chip.can_sleep = 1;
+	mcp->chip.owner = THIS_MODULE;
 
 	spi_set_drvdata(spi, mcp);
 
diff -puN drivers/gpio/pca953x.c~gpiolib-i2c-spi-drivers-handle-rmmod-better drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpiolib-i2c-spi-drivers-handle-rmmod-better
+++ a/drivers/gpio/pca953x.c
@@ -189,6 +189,7 @@ static void pca953x_setup_gpio(struct pc
 	gc->base = chip->gpio_start;
 	gc->ngpio = gpios;
 	gc->label = chip->client->name;
+	gc->owner = THIS_MODULE;
 }
 
 static int __devinit pca953x_probe(struct i2c_client *client)
diff -puN drivers/gpio/pcf857x.c~gpiolib-i2c-spi-drivers-handle-rmmod-better drivers/gpio/pcf857x.c
--- a/drivers/gpio/pcf857x.c~gpiolib-i2c-spi-drivers-handle-rmmod-better
+++ a/drivers/gpio/pcf857x.c
@@ -159,6 +159,7 @@ static int pcf857x_probe(struct i2c_clie
 
 	gpio->chip.base = pdata->gpio_base;
 	gpio->chip.can_sleep = 1;
+	gpio->chip.owner = THIS_MODULE;
 
 	/* NOTE:  the OnSemi jlc1562b is also largely compatible with
 	 * these parts, notably for output.  It has a low-resolution
_

Patches currently in -mm which might be from g.liakhovetski@pengutronix.de are

origin.patch

