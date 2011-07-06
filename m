From: akpm@linux-foundation.org
Subject: + backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch added to -mm tree
Date: Wed, 06 Jul 2011 14:01:13 -0700
Message-ID: <201107062101.p66L1Dk0031328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756350Ab1GFVB4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 17:01:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, dh09.lee@samsung.com, inki.dae@samsung.com, jg1.han@samsung.com, mjg@redhat.com, rpurdie@rpsys.net


The patch titled
     backlight: set backlight type and max_brightness before backlights are registered
has been added to the -mm tree.  Its filename is
     backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: set backlight type and max_brightness before backlights are registered
From: Axel Lin <axel.lin@gmail.com>

Since commit a19a6ee "backlight: Allow properties to be passed at
registration" and commit bb7ca74 "backlight: add backlight type", we can
set backlight type and max_brightness before backlights are registered. 
Some newly added drivers did not set it properly, let's fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    9 ++++++---
 drivers/video/backlight/ld9040.c     |    8 ++++++--
 drivers/video/backlight/s6e63m0.c    |    9 ++++++---
 3 files changed, 18 insertions(+), 8 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered
+++ a/drivers/video/backlight/ams369fg06.c
@@ -479,6 +479,7 @@ static int __devinit ams369fg06_probe(st
 	struct ams369fg06 *lcd = NULL;
 	struct lcd_device *ld = NULL;
 	struct backlight_device *bd = NULL;
+	struct backlight_properties props;
 
 	lcd = kzalloc(sizeof(struct ams369fg06), GFP_KERNEL);
 	if (!lcd)
@@ -511,16 +512,18 @@ static int __devinit ams369fg06_probe(st
 
 	lcd->ld = ld;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = MAX_BRIGHTNESS;
+
 	bd = backlight_device_register("ams369fg06-bl", &spi->dev, lcd,
-		&ams369fg06_backlight_ops, NULL);
+		&ams369fg06_backlight_ops, &props);
 	if (IS_ERR(bd)) {
 		ret =  PTR_ERR(bd);
 		goto out_lcd_unregister;
 	}
 
-	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = DEFAULT_BRIGHTNESS;
-	bd->props.type = BACKLIGHT_RAW;
 	lcd->bd = bd;
 
 	if (!lcd->lcd_pd->lcd_enabled) {
diff -puN drivers/video/backlight/ld9040.c~backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered
+++ a/drivers/video/backlight/ld9040.c
@@ -668,6 +668,7 @@ static int ld9040_probe(struct spi_devic
 	struct ld9040 *lcd = NULL;
 	struct lcd_device *ld = NULL;
 	struct backlight_device *bd = NULL;
+	struct backlight_properties props;
 
 	lcd = kzalloc(sizeof(struct ld9040), GFP_KERNEL);
 	if (!lcd)
@@ -699,14 +700,17 @@ static int ld9040_probe(struct spi_devic
 
 	lcd->ld = ld;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = MAX_BRIGHTNESS;
+
 	bd = backlight_device_register("ld9040-bl", &spi->dev,
-		lcd, &ld9040_backlight_ops, NULL);
+		lcd, &ld9040_backlight_ops, &props);
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
 		goto out_unregister_lcd;
 	}
 
-	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = MAX_BRIGHTNESS;
 	lcd->bd = bd;
 
diff -puN drivers/video/backlight/s6e63m0.c~backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered
+++ a/drivers/video/backlight/s6e63m0.c
@@ -738,6 +738,7 @@ static int __devinit s6e63m0_probe(struc
 	struct s6e63m0 *lcd = NULL;
 	struct lcd_device *ld = NULL;
 	struct backlight_device *bd = NULL;
+	struct backlight_properties props;
 
 	lcd = kzalloc(sizeof(struct s6e63m0), GFP_KERNEL);
 	if (!lcd)
@@ -769,16 +770,18 @@ static int __devinit s6e63m0_probe(struc
 
 	lcd->ld = ld;
 
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_RAW;
+	props.max_brightness = MAX_BRIGHTNESS;
+
 	bd = backlight_device_register("s6e63m0bl-bl", &spi->dev, lcd,
-		&s6e63m0_backlight_ops, NULL);
+		&s6e63m0_backlight_ops, &props);
 	if (IS_ERR(bd)) {
 		ret =  PTR_ERR(bd);
 		goto out_lcd_unregister;
 	}
 
-	bd->props.max_brightness = MAX_BRIGHTNESS;
 	bd->props.brightness = MAX_BRIGHTNESS;
-	bd->props.type = BACKLIGHT_RAW;
 	lcd->bd = bd;
 
 	/*
_

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
backlight-set-backlight-type-and-max_brightness-before-backlights-are-registered.patch
linux-next.patch
drivers-video-backlight-ld9040c-small-fixes.patch
backlight-add-ams369fg06-amoled-driver-unregister-backlight-device-when-unload-the-module.patch
drivers-leds-leds-sunfirec-fix-sunfire_led_generic_probe-error-handling.patch

