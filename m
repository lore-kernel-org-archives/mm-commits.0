From: akpm@linux-foundation.org
Subject: [folded] backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:34:41 -0700
Message-ID: <20120323213441.D7E44A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:44067 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2CWVem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:34:42 -0400
Received: by ggnd2 with SMTP id d2so566214ggn.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:34:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight/lp855x_bl.c: check platform data in lp855x_probe()
has been removed from the -mm tree.  Its filename was
     backlight-lp855x_blc-check-platform-data-in-lp855x_probe.patch

This patch was dropped because it was folded into backlight-new-backlight-driver-for-lp855x-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight/lp855x_bl.c: check platform data in lp855x_probe()

The reset of the code assumes pdata is not NULL.  Add checking for pdata
in lp855x_probe(), this prevents NULL dereference if pdata is NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: "Milo(Woogyom) Kim" <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-lp855x_blc-check-platform-data-in-lp855x_probe drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-lp855x_blc-check-platform-data-in-lp855x_probe
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -231,9 +231,14 @@ static int lp855x_probe(struct i2c_clien
 {
 	struct lp855x *lp;
 	struct lp855x_platform_data *pdata = cl->dev.platform_data;
-	enum lp855x_brightness_ctrl_mode mode = pdata->mode;
+	enum lp855x_brightness_ctrl_mode mode;
 	int ret;
 
+	if (!pdata) {
+		dev_err(&cl->dev, "no platform data supplied\n");
+		return -EINVAL;
+	}
+
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
@@ -241,6 +246,7 @@ static int lp855x_probe(struct i2c_clien
 	if (!lp)
 		return -ENOMEM;
 
+	mode = pdata->mode;
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices.patch
backlight-lp855x_blc-small-cleanups.patch
lp855x-bl-remove-unnecessary-platform-data.patch
lp855x-bl-remove-unnecessary-headers.patch
backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-pltfm-with-pdata.patch
drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

