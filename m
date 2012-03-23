From: akpm@linux-foundation.org
Subject: [folded] backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:35:09 -0700
Message-ID: <20120323213509.CA895A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vx0-f202.google.com ([209.85.220.202]:52983 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab2CWVfM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:35:12 -0400
Received: by vcbfk26 with SMTP id fk26so566909vcb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:35:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: use id->driver_data to differentiate lp855x chips
has been removed from the -mm tree.  Its filename was
     backlight-use-id-driver_data-to-differentiate-lp855x-chips.patch

This patch was dropped because it was folded into backlight-new-backlight-driver-for-lp855x-devices.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight: use id->driver_data to differentiate lp855x chips

Current code has corresponding driver_data settings for different chip types.
Use the driver_data to differentiate lp855x chips.

Also make lp855x_is_valid_rom_area() return bool instead of int.

[akpm@linux-foundation.org: simplify boolean return expression]
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Milo (Woogyom) Kim <milo.kim@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |   28 +++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~backlight-use-id-driver_data-to-differentiate-lp855x-chips drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~backlight-use-id-driver_data-to-differentiate-lp855x-chips
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -25,7 +25,8 @@
 #define MAX_BRIGHTNESS		255
 
 struct lp855x {
-	const char *chipid;
+	const char *chipname;
+	enum lp855x_chip_id chip_id;
 	struct i2c_client *client;
 	struct backlight_device *bl;
 	struct device *dev;
@@ -61,23 +62,27 @@ static int lp855x_write_byte(struct lp85
 	return ret;
 }
 
-static int lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
+static bool lp855x_is_valid_rom_area(struct lp855x *lp, u8 addr)
 {
-	const char *id = lp->chipid;
 	u8 start, end;
 
-	if (strstr(id, "lp8550") || strstr(id, "lp8551")
-	    || strstr(id, "lp8552") || strstr(id, "lp8553")) {
+	switch (lp->chip_id) {
+	case LP8550:
+	case LP8551:
+	case LP8552:
+	case LP8553:
 		start = EEPROM_START;
 		end = EEPROM_END;
-	} else if (strstr(id, "lp8556")) {
+		break;
+	case LP8556:
 		start = EPROM_START;
 		end = EPROM_END;
-	} else {
-		return 0;
+		break;
+	default:
+		return false;
 	}
 
-	return (addr >= start && addr <= end) ? 1 : 0;
+	return (addr >= start && addr <= end);
 }
 
 static int lp855x_init_registers(struct lp855x *lp)
@@ -199,7 +204,7 @@ static ssize_t lp855x_get_chip_id(struct
 				struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
-	return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipid);
+	return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipname);
 }
 
 static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
@@ -253,7 +258,8 @@ static int lp855x_probe(struct i2c_clien
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
-	lp->chipid = id->name;
+	lp->chipname = id->name;
+	lp->chip_id = id->driver_data;
 	i2c_set_clientdata(cl, lp);
 
 	mutex_init(&lp->xfer_lock);
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
backlight-convert-backlight-i2c-drivers-to-module_i2c_driver.patch
backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch
backlight-new-backlight-driver-for-lp855x-devices.patch
drivers-leds-add-driver-for-pca9663-i2c-chip.patch
leds-lm3530-replace-pltfm-with-pdata.patch
drivers-leds-leds-pca9633c-remove-unused-adapter-variable.patch
drivers-leds-leds-lm3530c-move-the-code-setting-gen_config-to-one-place.patch
rtc-convert-rtc-spi-drivers-to-module_spi_driver.patch
rtc-convert-rtc-i2c-drivers-to-module_i2c_driver.patch

