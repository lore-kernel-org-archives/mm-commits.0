From: akpm@linux-foundation.org
Subject: + leds-lm3530-replace-i2c_client-with-led_classdev.patch added to -mm tree
Date: Tue, 07 Feb 2012 12:53:48 -0800
Message-ID: <20120207205348.E339CA035C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:49290 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756533Ab2BGUxt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Feb 2012 15:53:49 -0500
Received: by yenm1 with SMTP id m1so150927yen.1
        for <mm-commits@vger.kernel.org>; Tue, 07 Feb 2012 12:53:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net


The patch titled
     Subject: leds-lm3530: replace i2c_client with led_classdev
has been added to the -mm tree.  Its filename is
     leds-lm3530-replace-i2c_client-with-led_classdev.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: leds-lm3530: replace i2c_client with led_classdev

To get members of lm3530_data, use 'struct led_classdev' rather than
'struct i2c_client'.

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
@@ -297,9 +297,9 @@ static void lm3530_brightness_set(struct
 static ssize_t lm3530_mode_get(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct i2c_client *client = container_of(
-					dev->parent, struct i2c_client, dev);
-	struct lm3530_data *drvdata = i2c_get_clientdata(client);
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata =
+	    container_of(led_cdev, struct lm3530_data, led_dev);
 	int i, len = 0;
 
 	for (i = 0; i < ARRAY_SIZE(mode_map); i++)
@@ -316,11 +316,10 @@ static ssize_t lm3530_mode_get(struct de
 static ssize_t lm3530_mode_set(struct device *dev, struct device_attribute
 				   *attr, const char *buf, size_t size)
 {
-	int err;
-	struct i2c_client *client = container_of(
-					dev->parent, struct i2c_client, dev);
-	struct lm3530_data *drvdata = i2c_get_clientdata(client);
-	int mode;
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct lm3530_data *drvdata =
+	    container_of(led_cdev, struct lm3530_data, led_dev);
+	int mode, err;
 
 	mode = lm3530_get_mode_from_str(buf);
 	if (mode < 0) {
_
Subject: Subject: leds-lm3530: replace i2c_client with led_classdev

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-support-led-pattern-data-checkpatch-fixes.patch
leds-lp5521-redefinition-of-register-bits.patch
leds-lm3530-set-the-max_brightness-to-127.patch
leds-lm3530-replace-i2c_client-with-led_classdev.patch
leds-lm3530-support-pwm-input-mode.patch
leds-lm3530-remove-lm3530_als_zone_reg-code.patch
leds-lm3530-replace-pltfm-with-pdata.patch

