From: akpm@linux-foundation.org
Subject: [merged] leds-lm3530-replace-i2c_client-with-led_classdev.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:29:48 -0700
Message-ID: <20120326192948.600C6A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:40916 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2CZT3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:29:50 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so288108lbb.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:29:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: leds-lm3530: replace i2c_client with led_classdev
has been removed from the -mm tree.  Its filename was
     leds-lm3530-replace-i2c_client-with-led_classdev.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: leds-lm3530: replace i2c_client with led_classdev

To get members of lm3530_data, use 'struct led_classdev' rather than
'struct i2c_client'.

[akpm@linux-foundation.org: fix 80-column fixes more nicely]
Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-lm3530.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN drivers/leds/leds-lm3530.c~leds-lm3530-replace-i2c_client-with-led_classdev drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-lm3530-replace-i2c_client-with-led_classdev
+++ a/drivers/leds/leds-lm3530.c
@@ -297,11 +297,11 @@ static void lm3530_brightness_set(struct
 static ssize_t lm3530_mode_get(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = container_of(
-					dev->parent, struct i2c_client, dev);
-	struct lm3530_data *drvdata = i2c_get_clientdata(client);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata;
 	int i, len = 0;
 
+	drvdata = container_of(led_cdev, struct lm3530_data, led_dev);
 	for (i = 0; i < ARRAY_SIZE(mode_map); i++)
 		if (drvdata->mode == mode_map[i].mode_val)
 			len += sprintf(buf + len, "[%s] ", mode_map[i].mode);
@@ -316,12 +316,11 @@ static ssize_t lm3530_mode_get(struct de
 static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 				   *attr, const char *buf, size_t size)
 {
-	int err;
-	struct i2c_client *client = container_of(
-					dev->parent, struct i2c_client, dev);
-	struct lm3530_data *drvdata = i2c_get_clientdata(client);
-	int mode;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata;
+	int mode, err;
 
+	drvdata = container_of(led_cdev, struct lm3530_data, led_dev);
 	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
 		dev_err(dev, "Invalid mode\n");
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

origin.patch

