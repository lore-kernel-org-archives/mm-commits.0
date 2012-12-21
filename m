From: akpm@linux-foundation.org
Subject: + pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:54:46 -0800
Message-ID: <20121221225447.21E3C100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:60184 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LUWys (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:54:48 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so531062vbi.1
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:54:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, thierry.reding@avionic-design.de


The patch titled
     Subject: pwm_backlight: use bl_get_data instead of dev_get_drvdata
has been added to the -mm tree.  Its filename is
     pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: pwm_backlight: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pwm_bl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/pwm_bl.c~pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/pwm_bl.c
@@ -37,7 +37,7 @@ struct pwm_bl_data {
 
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 	int brightness = bl->props.brightness;
 	int max = bl->props.max_brightness;
 
@@ -83,7 +83,7 @@ static int pwm_backlight_get_brightness(
 static int pwm_backlight_check_fb(struct backlight_device *bl,
 				  struct fb_info *info)
 {
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	return !pb->check_fb || pb->check_fb(pb->dev, info);
 }
@@ -264,7 +264,7 @@ err_alloc:
 static int pwm_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
 	pwm_config(pb->pwm, 0, pb->period);
@@ -278,7 +278,7 @@ static int pwm_backlight_remove(struct p
 static int pwm_backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bl = dev_get_drvdata(dev);
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-ld9040-use-sleep-instead-of-delay.patch
backlight-ld9040-remove-unnecessary-null-deference-check.patch
backlight-ld9040-replace-efault-with-einval.patch
backlight-ld9040-remove-redundant-return-variables.patch
backlight-ld9040-reorder-inclusions-of-linux-xxxh.patch
backlight-s6e63m0-use-lowercase-names-of-structs.patch
backlight-s6e63m0-use-sleep-instead-of-delay.patch
backlight-s6e63m0-remove-unnecessary-null-deference-check.patch
backlight-s6e63m0-replace-efault-with-einval.patch
backlight-s6e63m0-remove-redundant-variable-before_power.patch
backlight-s6e63m0-reorder-inclusions-of-linux-xxxh.patch
backlight-ams369fg06-use-sleep-instead-of-delay.patch
backlight-ams369fg06-remove-unnecessary-null-deference-check.patch
backlight-ams369fg06-replace-efault-with-einval.patch
backlight-ams369fg06-remove-redundant-variable-before_power.patch
backlight-ams369fg06-reorder-inclusions-of-linux-xxxh.patch
backlight-l4f00242t03-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ld9040-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-s6e63m0-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ltv350qv-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-tdo24m-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-lms283gf05-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-ams369fg06-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-vgg2432a4-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-tosa-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-corgi_lcd-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-lms501kf03-use-spi_get_drvdata-and-spi_set_drvdata.patch
backlight-aat2870-use-bl_get_data-instead-of-dev_get_drvdata.patch
pwm_backlight-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-ams369fg06-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-corgi_lcd-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-tosa-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata.patch
backlight-corgi_lcd-use-lcd_get_data-instead-of-dev_get_drvdata.patch

