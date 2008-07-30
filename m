From: akpm@linux-foundation.org
Subject: - backlight-give-platform_lcd-the-same-name-as-the-platform-device.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:13:40 -0700
Message-ID: <200807301913.m6UJDeqr010777@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789AbYG3TPD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:15:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: give platform_lcd the same name as the platform device.
has been removed from the -mm tree.  Its filename was
     backlight-give-platform_lcd-the-same-name-as-the-platform-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: give platform_lcd the same name as the platform device.
From: Ben Dooks <ben-linux@fluff.org>

When registering an platform_lcd, use the name of the platform device
specified in case there are more than one platform_lcd backlights
registered.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/platform_lcd.c~backlight-give-platform_lcd-the-same-name-as-the-platform-device drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-give-platform_lcd-the-same-name-as-the-platform-device
+++ a/drivers/video/backlight/platform_lcd.c
@@ -92,7 +92,7 @@ static int __devinit platform_lcd_probe(
 
 	plcd->us = dev;
 	plcd->pdata = pdata;
-	plcd->lcd = lcd_device_register("platform-lcd", dev,
+	plcd->lcd = lcd_device_register(dev_name(dev), dev,
 					plcd, &platform_lcd_ops);
 	if (IS_ERR(plcd->lcd)) {
 		dev_err(dev, "cannot register lcd device\n");
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
linux-next.patch
backlight-add-more-information-output-to-pwm_backlight.patch
backlight-add-module_alias-to-pwm_backlight-driver.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

