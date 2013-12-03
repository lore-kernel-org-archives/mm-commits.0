From: akpm@linux-foundation.org
Subject: + backlight-jornada720-use-devm_lcd_device_register.patch added
 to -mm tree
Date: Mon, 02 Dec 2013 17:00:36 -0800
Message-ID: <529d2d34.wh2ejjzj1q8uPsgb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3LCBAh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 20:00:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: + backlight-jornada720-use-devm_lcd_device_register.patch added to -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 17:00:36 -0800


The patch titled
     Subject: backlight: jornada720: use devm_lcd_device_register()
has been added to the -mm tree.  Its filename is
     backlight-jornada720-use-devm_lcd_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-jornada720-use-devm_lcd_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-jornada720-use-devm_lcd_device_register.patch

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
Subject: backlight: jornada720: use devm_lcd_device_register()

Use devm_lcd_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/jornada720_lcd.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-use-devm_lcd_device_register drivers/video/backlight/jornada720_lcd.c
--- a/drivers/video/backlight/jornada720_lcd.c~backlight-jornada720-use-devm_lcd_device_register
+++ a/drivers/video/backlight/jornada720_lcd.c
@@ -100,7 +100,8 @@ static int jornada_lcd_probe(struct plat
 	struct lcd_device *lcd_device;
 	int ret;
 
-	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_lcd_props);
+	lcd_device = devm_lcd_device_register(&pdev->dev, S1D_DEVICENAME,
+					&pdev->dev, NULL, &jornada_lcd_props);
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
@@ -119,18 +120,8 @@ static int jornada_lcd_probe(struct plat
 	return 0;
 }
 
-static int jornada_lcd_remove(struct platform_device *pdev)
-{
-	struct lcd_device *lcd_device = platform_get_drvdata(pdev);
-
-	lcd_device_unregister(lcd_device);
-
-	return 0;
-}
