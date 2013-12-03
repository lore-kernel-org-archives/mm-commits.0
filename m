From: akpm@linux-foundation.org
Subject: + backlight-omap1-use-devm_backlight_device_register.patch added
 to -mm tree
Date: Mon, 02 Dec 2013 17:00:33 -0800
Message-ID: <529d2d31.ETcMW7WgdN/bi3Eb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab3LCBAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 20:00:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tomi.valkeinen@ti.com, jg1.han@samsung.com

Subject: + backlight-omap1-use-devm_backlight_device_register.patch added to -mm tree
To: jg1.han@samsung.com,tomi.valkeinen@ti.com
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 17:00:33 -0800


The patch titled
     Subject: backlight: omap1: use devm_backlight_device_register()
has been added to the -mm tree.  Its filename is
     backlight-omap1-use-devm_backlight_device_register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-omap1-use-devm_backlight_device_register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-omap1-use-devm_backlight_device_register.patch

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
Subject: backlight: omap1: use devm_backlight_device_register()

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/omap1_bl.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff -puN drivers/video/backlight/omap1_bl.c~backlight-omap1-use-devm_backlight_device_register drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-omap1-use-devm_backlight_device_register
+++ a/drivers/video/backlight/omap1_bl.c
@@ -146,8 +146,8 @@ static int omapbl_probe(struct platform_
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = OMAPBL_MAX_INTENSITY;
-	dev = backlight_device_register("omap-bl", &pdev->dev, bl, &omapbl_ops,
-					&props);
+	dev = devm_backlight_device_register(&pdev->dev, "omap-bl", &pdev->dev,
+					bl, &omapbl_ops, &props);
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
@@ -170,20 +170,10 @@ static int omapbl_probe(struct platform_
 	return 0;
 }
 
-static int omapbl_remove(struct platform_device *pdev)
-{
-	struct backlight_device *dev = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(dev);
-
-	return 0;
-}
-
 static SIMPLE_DEV_PM_OPS(omapbl_pm_ops, omapbl_suspend, omapbl_resume);
 
 static struct platform_driver omapbl_driver = {
 	.probe		= omapbl_probe,
-	.remove		= omapbl_remove,
 	.driver		= {
 		.name	= "omap-bl",
 		.pm	= &omapbl_pm_ops,
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-block-sx8c-use-module_pci_driver.patch
drivers-block-sx8c-remove-unnecessary-pci_set_drvdata.patch
backlight-jornada720-use-devm_backlight_device_register.patch
backlight-hp680_bl-use-devm_backlight_device_register.patch
backlight-omap1-use-devm_backlight_device_register.patch
backlight-ot200_bl-use-devm_backlight_device_register.patch
backlight-tosa-use-devm_backlight_device_register.patch
backlight-jornada720-use-devm_lcd_device_register.patch
backlight-l4f00242t03-use-devm_lcd_device_register.patch
backlight-tosa-use-devm_lcd_device_register.patch
drivers-rtc-rtc-as3722-use-devm-for-rtc-and-irq-registration.patch
rtc-ds1305-remove-unnecessary-spi_set_drvdata.patch
linux-next.patch

