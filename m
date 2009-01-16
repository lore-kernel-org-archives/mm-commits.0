From: akpm@linux-foundation.org
Subject: [merged] gpio-fix-probe-error-return-in-gpio-driver-probes.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:16:18 -0800
Message-ID: <200901161916.n0GJGIve024777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936615AbZAPTRS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:17:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     gpio: fix probe() error return in gpio driver probes
has been removed from the -mm tree.  Its filename was
     gpio-fix-probe-error-return-in-gpio-driver-probes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: fix probe() error return in gpio driver probes
From: Ben Dooks <ben-linux@fluff.org>

A number of drivers in drivers/gpio return -ENODEV when confronted with
missing setup parameters such as the platform data.  However, returning
-ENODEV causes the driver layer to silently ignore the driver as it
assumes the probe did not find anything and was only speculative.

To make life easier to discern why a driver is not being attached, change
to returning -EINVAL, which is a better description of the fact that the
driver data was not valid.

Also add a set of dev_dbg() statements to the error paths to provide an
better explanation of the error as there may be more that one point in the
driver.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/max7301.c  |    6 ++++--
 drivers/gpio/max732x.c  |    6 ++++--
 drivers/gpio/mcp23s08.c |    6 ++++--
 drivers/gpio/pca953x.c  |    6 ++++--
 drivers/gpio/pcf857x.c  |   12 ++++++++----
 5 files changed, 24 insertions(+), 12 deletions(-)

diff -puN drivers/gpio/max7301.c~gpio-fix-probe-error-return-in-gpio-driver-probes drivers/gpio/max7301.c
--- a/drivers/gpio/max7301.c~gpio-fix-probe-error-return-in-gpio-driver-probes
+++ a/drivers/gpio/max7301.c
@@ -217,8 +217,10 @@ static int __devinit max7301_probe(struc
 	int i, ret;
 
 	pdata = spi->dev.platform_data;
-	if (!pdata || !pdata->base)
-		return -ENODEV;
+	if (!pdata || !pdata->base) {
+		dev_dbg(&spi->dev, "incorrect or missing platform data\n");
+		return -EINVAL;
+	}
 
 	/*
 	 * bits_per_word cannot be configured in platform data
diff -puN drivers/gpio/max732x.c~gpio-fix-probe-error-return-in-gpio-driver-probes drivers/gpio/max732x.c
--- a/drivers/gpio/max732x.c~gpio-fix-probe-error-return-in-gpio-driver-probes
+++ a/drivers/gpio/max732x.c
@@ -267,8 +267,10 @@ static int __devinit max732x_probe(struc
 	int ret, nr_port;
 
 	pdata = client->dev.platform_data;
-	if (pdata == NULL)
-		return -ENODEV;
+	if (pdata == NULL) {
+		dev_dbg(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
 
 	chip = kzalloc(sizeof(struct max732x_chip), GFP_KERNEL);
 	if (chip == NULL)
diff -puN drivers/gpio/mcp23s08.c~gpio-fix-probe-error-return-in-gpio-driver-probes drivers/gpio/mcp23s08.c
--- a/drivers/gpio/mcp23s08.c~gpio-fix-probe-error-return-in-gpio-driver-probes
+++ a/drivers/gpio/mcp23s08.c
@@ -310,8 +310,10 @@ static int mcp23s08_probe(struct spi_dev
 	unsigned			base;
 
 	pdata = spi->dev.platform_data;
-	if (!pdata || !gpio_is_valid(pdata->base))
-		return -ENODEV;
+	if (!pdata || !gpio_is_valid(pdata->base)) {
+		dev_dbg(&spi->dev, "invalid or missing platform data\n");
+		return -EINVAL;
+	}
 
 	for (addr = 0; addr < 4; addr++) {
 		if (!pdata->chip[addr].is_present)
diff -puN drivers/gpio/pca953x.c~gpio-fix-probe-error-return-in-gpio-driver-probes drivers/gpio/pca953x.c
--- a/drivers/gpio/pca953x.c~gpio-fix-probe-error-return-in-gpio-driver-probes
+++ a/drivers/gpio/pca953x.c
@@ -202,8 +202,10 @@ static int __devinit pca953x_probe(struc
 	int ret;
 
 	pdata = client->dev.platform_data;
-	if (pdata == NULL)
-		return -ENODEV;
+	if (pdata == NULL) {
+		dev_dbg(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
 
 	chip = kzalloc(sizeof(struct pca953x_chip), GFP_KERNEL);
 	if (chip == NULL)
diff -puN drivers/gpio/pcf857x.c~gpio-fix-probe-error-return-in-gpio-driver-probes drivers/gpio/pcf857x.c
--- a/drivers/gpio/pcf857x.c~gpio-fix-probe-error-return-in-gpio-driver-probes
+++ a/drivers/gpio/pcf857x.c
@@ -188,8 +188,10 @@ static int pcf857x_probe(struct i2c_clie
 	int				status;
 
 	pdata = client->dev.platform_data;
-	if (!pdata)
-		return -ENODEV;
+	if (!pdata) {
+		dev_dbg(&client->dev, "no platform data\n");
+		return -EINVAL;
+	}
 
 	/* Allocate, initialize, and register this gpio_chip. */
 	gpio = kzalloc(sizeof *gpio, GFP_KERNEL);
@@ -248,8 +250,10 @@ static int pcf857x_probe(struct i2c_clie
 		else
 			status = i2c_read_le16(client);
 
-	} else
-		status = -ENODEV;
+	} else {
+		dev_dbg(&client->dev, "unsupported number of gpios\n");
+		status = -EINVAL;
+	}
 
 	if (status < 0)
 		goto fail;
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
i2c-incremental-i2c-mpc-driver-fix-for-multi-master-i2c-busses.patch
sm501-fix-section-mismatches.patch
mmc-s3cmci-fix-hangup-in-do_pio_write.patch

