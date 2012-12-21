From: akpm@linux-foundation.org
Subject: + backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata.patch added to -mm tree
Date: Fri, 21 Dec 2012 14:54:55 -0800
Message-ID: <20121221225456.8292920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:64550 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2LUWy6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 17:54:58 -0500
Received: by mail-we0-f202.google.com with SMTP id t57so276896wey.3
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 14:54:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: backlight: omap1: use bl_get_data instead of dev_get_drvdata
has been added to the -mm tree.  Its filename is
     backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata.patch

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
Subject: backlight: omap1: use bl_get_data instead of dev_get_drvdata

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev, so we can
directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/omap1_bl.c~backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-omap1-use-bl_get_data-instead-of-dev_get_drvdata
+++ a/drivers/video/backlight/omap1_bl.c
@@ -77,7 +77,7 @@ static void omapbl_blank(struct omap_bac
 static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, FB_BLANK_POWERDOWN);
 	return 0;
@@ -86,7 +86,7 @@ static int omapbl_suspend(struct platfor
 static int omapbl_resume(struct platform_device *pdev)
 {
 	struct backlight_device *dev = platform_get_drvdata(pdev);
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, bl->powermode);
 	return 0;
@@ -98,7 +98,7 @@ static int omapbl_resume(struct platform
 
 static int omapbl_set_power(struct backlight_device *dev, int state)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	omapbl_blank(bl, state);
 	bl->powermode = state;
@@ -108,7 +108,7 @@ static int omapbl_set_power(struct backl
 
 static int omapbl_update_status(struct backlight_device *dev)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 
 	if (bl->current_intensity != dev->props.brightness) {
 		if (bl->powermode == FB_BLANK_UNBLANK)
@@ -124,7 +124,7 @@ static int omapbl_update_status(struct b
 
 static int omapbl_get_intensity(struct backlight_device *dev)
 {
-	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	struct omap_backlight *bl = bl_get_data(dev);
 	return bl->current_intensity;
 }
 
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

