From: akpm@linux-foundation.org
Subject: [merged] backlight-ld9040c-regulator-control-in-the-driver.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:29:53 -0800
Message-ID: <20120111212954.037A120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:38500 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2AKV3z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:29:55 -0500
Received: by mail-ee0-f74.google.com with SMTP id d41so44287eek.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:29:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dh09.lee@samsung.com, FlorianSchandinat@gmx.de, inki.dae@samsung.com, kyungmin.park@samsung.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight/ld9040.c: regulator control in the driver
has been removed from the -mm tree.  Its filename was
     backlight-ld9040c-regulator-control-in-the-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Donghwa Lee <dh09.lee@samsung.com>
Subject: backlight/ld9040.c: regulator control in the driver

This patch supports regulator power control in the driver.  Current ld9040
driver was controlled power on/off sequence by callback function in the
board file.  But, by doing this, there's no need to register lcd power
on/off callback function in the board file.

Signed-off-by: Donghwa Lee <dh09.lee@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ld9040.c |   71 ++++++++++++++++++++++++-----
 1 file changed, 59 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/ld9040.c~backlight-ld9040c-regulator-control-in-the-driver drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-ld9040c-regulator-control-in-the-driver
+++ a/drivers/video/backlight/ld9040.c
@@ -31,6 +31,7 @@
 #include <linux/lcd.h>
 #include <linux/backlight.h>
 #include <linux/module.h>
+#include <linux/regulator/consumer.h>
 
 #include "ld9040_gamma.h"
 
@@ -53,8 +54,51 @@ struct ld9040 {
 	struct lcd_device		*ld;
 	struct backlight_device		*bd;
 	struct lcd_platform_data	*lcd_pd;
+
+	struct mutex			lock;
+	bool  enabled;
+};
+
+static struct regulator_bulk_data supplies[] = {
+	{ .supply = "vdd3", },
+	{ .supply = "vci", },
 };
 
+static void ld9040_regulator_enable(struct ld9040 *lcd)
+{
+	int ret = 0;
+	struct lcd_platform_data *pd = NULL;
+
+	pd = lcd->lcd_pd;
+	mutex_lock(&lcd->lock);
+	if (!lcd->enabled) {
+		ret = regulator_bulk_enable(ARRAY_SIZE(supplies), supplies);
+		if (ret)
+			goto out;
+
+		lcd->enabled = true;
+	}
+	mdelay(pd->power_on_delay);
+out:
+	mutex_unlock(&lcd->lock);
+}
+
+static void ld9040_regulator_disable(struct ld9040 *lcd)
+{
+	int ret = 0;
+
+	mutex_lock(&lcd->lock);
+	if (lcd->enabled) {
+		ret = regulator_bulk_disable(ARRAY_SIZE(supplies), supplies);
+		if (ret)
+			goto out;
+
+		lcd->enabled = false;
+	}
+out:
+	mutex_unlock(&lcd->lock);
+}
+
 static const unsigned short seq_swreset[] = {
 	0x01, COMMAND_ONLY,
 	ENDDEF, 0x00
@@ -532,13 +576,8 @@ static int ld9040_power_on(struct ld9040
 		return -EFAULT;
 	}
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
-	} else {
-		pd->power_on(lcd->ld, 1);
-		mdelay(pd->power_on_delay);
-	}
+	/* lcd power on */
+	ld9040_regulator_enable(lcd);
 
 	if (!pd->reset) {
 		dev_err(lcd->dev, "reset is NULL.\n");
@@ -582,11 +621,8 @@ static int ld9040_power_off(struct ld904
 
 	mdelay(pd->power_off_delay);
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EFAULT;
-	} else
-		pd->power_on(lcd->ld, 0);
+	/* lcd power off */
+	ld9040_regulator_disable(lcd);
 
 	return 0;
 }
@@ -693,6 +729,14 @@ static int ld9040_probe(struct spi_devic
 		goto out_free_lcd;
 	}
 
+	mutex_init(&lcd->lock);
+
+	ret = regulator_bulk_get(lcd->dev, ARRAY_SIZE(supplies), supplies);
+	if (ret) {
+		dev_err(lcd->dev, "Failed to get regulators: %d\n", ret);
+		goto out_free_lcd;
+	}
+
 	ld = lcd_device_register("ld9040", &spi->dev, lcd, &ld9040_lcd_ops);
 	if (IS_ERR(ld)) {
 		ret = PTR_ERR(ld);
@@ -739,6 +783,8 @@ static int ld9040_probe(struct spi_devic
 out_unregister_lcd:
 	lcd_device_unregister(lcd->ld);
 out_free_lcd:
+	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
+
 	kfree(lcd);
 	return ret;
 }
@@ -750,6 +796,7 @@ static int __devexit ld9040_remove(struc
 	ld9040_power(lcd, FB_BLANK_POWERDOWN);
 	backlight_device_unregister(lcd->bd);
 	lcd_device_unregister(lcd->ld);
+	regulator_bulk_free(ARRAY_SIZE(supplies), supplies);
 	kfree(lcd);
 
 	return 0;
_

Patches currently in -mm which might be from dh09.lee@samsung.com are

origin.patch

