From: akpm@linux-foundation.org
Subject: + leds-lp5521-add-name-in-the-lp5521_led_config.patch added to -mm tree
Date: Tue, 31 Jan 2012 12:13:23 -0800
Message-ID: <20120131201324.42948A00B3@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51962 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab2AaUN0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2012 15:13:26 -0500
Received: by eaaf1 with SMTP id f1so19735eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2012 12:13:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, arun.murthy@stericsson.com, linus.walleij@linaro.org, milo.kim@ti.com, rpurdie@rpsys.net, srinidhi.kasagar@stericsson.com


The patch titled
     Subject: drivers/leds/leds-lp5521.c: add 'name' in the lp5521_led_config
has been added to the -mm tree.  Its filename is
     leds-lp5521-add-name-in-the-lp5521_led_config.patch

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
Subject: drivers/leds/leds-lp5521.c: add 'name' in the lp5521_led_config

The name of each led channel can be configurable.  For the compatibility,
the name is set to default value(xx:channelN) when 'name' is not defined.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/leds/leds-lp5521.txt |    6 ++++++
 drivers/leds/leds-lp5521.c         |   11 ++++++++---
 include/linux/leds-lp5521.h        |    1 +
 3 files changed, 15 insertions(+), 3 deletions(-)

diff -puN Documentation/leds/leds-lp5521.txt~leds-lp5521-add-name-in-the-lp5521_led_config Documentation/leds/leds-lp5521.txt
--- a/Documentation/leds/leds-lp5521.txt~leds-lp5521-add-name-in-the-lp5521_led_config
+++ a/Documentation/leds/leds-lp5521.txt
@@ -43,17 +43,23 @@ Format: 10x mA i.e 10 means 1.0 mA
 example platform data:
 
 Note: chan_nr can have values between 0 and 2.
+The name of each channel can be configurable.
+If the name field is not defined, the default name will be set to 'xxxx:channelN'
+(XXXX : pdata->label or i2c client name, N : channel number)
 
 static struct lp5521_led_config lp5521_led_config[] = {
         {
+		.name = "red",
                 .chan_nr        = 0,
                 .led_current    = 50,
 		.max_current    = 130,
         }, {
+		.name = "green",
                 .chan_nr        = 1,
                 .led_current    = 0,
 		.max_current    = 130,
         }, {
+		.name = "blue",
                 .chan_nr        = 2,
                 .led_current    = 0,
 		.max_current    = 130,
diff -puN drivers/leds/leds-lp5521.c~leds-lp5521-add-name-in-the-lp5521_led_config drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-lp5521-add-name-in-the-lp5521_led_config
+++ a/drivers/leds/leds-lp5521.c
@@ -620,10 +620,15 @@ static int __devinit lp5521_init_led(str
 		return -EINVAL;
 	}
 
-	snprintf(name, sizeof(name), "%s:channel%d",
-			pdata->label ?: client->name, chan);
 	led->cdev.brightness_set = lp5521_set_brightness;
-	led->cdev.name = name;
+	if (pdata->led_config[chan].name) {
+		led->cdev.name = pdata->led_config[chan].name;
+	} else {
+		snprintf(name, sizeof(name), "%s:channel%d",
+			pdata->label ?: client->name, chan);
+		led->cdev.name = name;
+	}
+
 	res = led_classdev_register(dev, &led->cdev);
 	if (res < 0) {
 		dev_err(dev, "couldn't register led on channel %d\n", chan);
diff -puN include/linux/leds-lp5521.h~leds-lp5521-add-name-in-the-lp5521_led_config include/linux/leds-lp5521.h
--- a/include/linux/leds-lp5521.h~leds-lp5521-add-name-in-the-lp5521_led_config
+++ a/include/linux/leds-lp5521.h
@@ -26,6 +26,7 @@
 /* See Documentation/leds/leds-lp5521.txt */
 
 struct lp5521_led_config {
+	char		*name;
 	u8		chan_nr;
 	u8		led_current; /* mA x10, 0 if led is not connected */
 	u8		max_current;
_
Subject: Subject: drivers/leds/leds-lp5521.c: add 'name' in the lp5521_led_config

Patches currently in -mm which might be from Milo.Kim@ti.com are

backlight-new-backlight-driver-for-lp855x-devices.patch
leds-lp5521-add-name-in-the-lp5521_led_config.patch
leds-lp5521-add-update_config-in-the-lp5521_platform_data.patch
leds-lp5521-support-led-pattern-data.patch
leds-lp5521-redefinition-of-register-bits.patch

