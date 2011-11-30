From: akpm@linux-foundation.org
Subject: + backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch added to -mm tree
Date: Wed, 30 Nov 2011 12:51:20 -0800
Message-ID: <201111302051.pAUKpK0Y022574@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qw0-f74.google.com ([209.85.216.74]:44348 "EHLO
	mail-qw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1K3UvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 15:51:24 -0500
Received: by qabg24 with SMTP id g24so139224qab.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 12:51:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com, haojian.zhuang@gmail.com, hsweeten@visionengravers.com, michael.hennerich@analog.com, mike@compulab.co.il, rpurdie@rpsys.net


The patch titled
     From: Axel Lin <axel.lin@gmail.com>
has been added to the -mm tree.  Its filename is
     backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch

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
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight: convert drivers/video/backlight/* to use module_platform_driver()

Convert the drivers in drivers/video/backlight/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>	[ep93xx_bl.c]
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Richard Purdie <rpurdie@rpsys.net>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/88pm860x_bl.c        |   12 +-----------
 drivers/video/backlight/adp5520_bl.c         |   12 +-----------
 drivers/video/backlight/da903x_bl.c          |   12 +-----------
 drivers/video/backlight/ep93xx_bl.c          |   12 +-----------
 drivers/video/backlight/generic_bl.c         |   13 +------------
 drivers/video/backlight/jornada720_bl.c      |   13 +------------
 drivers/video/backlight/jornada720_lcd.c     |   13 +------------
 drivers/video/backlight/max8925_bl.c         |   12 +-----------
 drivers/video/backlight/omap1_bl.c           |   13 +------------
 drivers/video/backlight/pcf50633-backlight.c |   12 +-----------
 drivers/video/backlight/platform_lcd.c       |   13 +------------
 drivers/video/backlight/pwm_bl.c             |   12 +-----------
 drivers/video/backlight/wm831x_bl.c          |   12 +-----------
 13 files changed, 13 insertions(+), 148 deletions(-)

diff -puN drivers/video/backlight/88pm860x_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/88pm860x_bl.c
--- a/drivers/video/backlight/88pm860x_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/88pm860x_bl.c
@@ -270,17 +270,7 @@ static struct platform_driver pm860x_bac
 	.remove		= pm860x_backlight_remove,
 };
 
-static int __init pm860x_backlight_init(void)
-{
-	return platform_driver_register(&pm860x_backlight_driver);
-}
-module_init(pm860x_backlight_init);
-
-static void __exit pm860x_backlight_exit(void)
-{
-	platform_driver_unregister(&pm860x_backlight_driver);
-}
-module_exit(pm860x_backlight_exit);
+module_platform_driver(pm860x_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Marvell Semiconductor 88PM8606");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff -puN drivers/video/backlight/adp5520_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -384,17 +384,7 @@ static struct platform_driver adp5520_bl
 	.resume		= adp5520_bl_resume,
 };
 
-static int __init adp5520_bl_init(void)
-{
-	return platform_driver_register(&adp5520_bl_driver);
-}
-module_init(adp5520_bl_init);
-
-static void __exit adp5520_bl_exit(void)
-{
-	platform_driver_unregister(&adp5520_bl_driver);
-}
-module_exit(adp5520_bl_exit);
+module_platform_driver(adp5520_bl_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADP5520(01) Backlight Driver");
diff -puN drivers/video/backlight/da903x_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/da903x_bl.c
--- a/drivers/video/backlight/da903x_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/da903x_bl.c
@@ -199,17 +199,7 @@ static struct platform_driver da903x_bac
 	.remove		= da903x_backlight_remove,
 };
 
-static int __init da903x_backlight_init(void)
-{
-	return platform_driver_register(&da903x_backlight_driver);
-}
-module_init(da903x_backlight_init);
-
-static void __exit da903x_backlight_exit(void)
-{
-	platform_driver_unregister(&da903x_backlight_driver);
-}
-module_exit(da903x_backlight_exit);
+module_platform_driver(da903x_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Dialog Semiconductor DA9030/DA9034");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>"
diff -puN drivers/video/backlight/ep93xx_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/ep93xx_bl.c
--- a/drivers/video/backlight/ep93xx_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/ep93xx_bl.c
@@ -144,17 +144,7 @@ static struct platform_driver ep93xxbl_d
 	.resume		= ep93xxbl_resume,
 };
 
-static int __init ep93xxbl_init(void)
-{
-	return platform_driver_register(&ep93xxbl_driver);
-}
-module_init(ep93xxbl_init);
-
-static void __exit ep93xxbl_exit(void)
-{
-	platform_driver_unregister(&ep93xxbl_driver);
-}
-module_exit(ep93xxbl_exit);
+module_platform_driver(ep93xxbl_driver);
 
 MODULE_DESCRIPTION("EP93xx Backlight Driver");
 MODULE_AUTHOR("H Hartley Sweeten <hsweeten@visionengravers.com>");
diff -puN drivers/video/backlight/generic_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/generic_bl.c
--- a/drivers/video/backlight/generic_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/generic_bl.c
@@ -132,18 +132,7 @@ static struct platform_driver genericbl_
 	},
 };
 
-static int __init genericbl_init(void)
-{
-	return platform_driver_register(&genericbl_driver);
-}
-
-static void __exit genericbl_exit(void)
-{
-	platform_driver_unregister(&genericbl_driver);
-}
-
-module_init(genericbl_init);
-module_exit(genericbl_exit);
+module_platform_driver(genericbl_driver);
 
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("Generic Backlight Driver");
diff -puN drivers/video/backlight/jornada720_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/jornada720_bl.c
--- a/drivers/video/backlight/jornada720_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/jornada720_bl.c
@@ -147,19 +147,8 @@ static struct platform_driver jornada_bl
 	},
 };
 
-static int __init jornada_bl_init(void)
-{
-	return platform_driver_register(&jornada_bl_driver);
-}
-
-static void __exit jornada_bl_exit(void)
-{
-	platform_driver_unregister(&jornada_bl_driver);
-}
+module_platform_driver(jornada_bl_driver);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson>");
 MODULE_DESCRIPTION("HP Jornada 710/720/728 Backlight driver");
 MODULE_LICENSE("GPL");
-
-module_init(jornada_bl_init);
-module_exit(jornada_bl_exit);
diff -puN drivers/video/backlight/jornada720_lcd.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/jornada720_lcd.c
--- a/drivers/video/backlight/jornada720_lcd.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/jornada720_lcd.c
@@ -135,19 +135,8 @@ static struct platform_driver jornada_lc
 	},
 };
 
-static int __init jornada_lcd_init(void)
-{
-	return platform_driver_register(&jornada_lcd_driver);
-}
-
-static void __exit jornada_lcd_exit(void)
-{
-	platform_driver_unregister(&jornada_lcd_driver);
-}
+module_platform_driver(jornada_lcd_driver);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 710/720/728 LCD driver");
 MODULE_LICENSE("GPL");
-
-module_init(jornada_lcd_init);
-module_exit(jornada_lcd_exit);
diff -puN drivers/video/backlight/max8925_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/max8925_bl.c
--- a/drivers/video/backlight/max8925_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/max8925_bl.c
@@ -188,17 +188,7 @@ static struct platform_driver max8925_ba
 	.remove		= __devexit_p(max8925_backlight_remove),
 };
 
-static int __init max8925_backlight_init(void)
-{
-	return platform_driver_register(&max8925_backlight_driver);
-}
-module_init(max8925_backlight_init);
-
-static void __exit max8925_backlight_exit(void)
-{
-	platform_driver_unregister(&max8925_backlight_driver);
-};
-module_exit(max8925_backlight_exit);
+module_platform_driver(max8925_backlight_driver);
 
 MODULE_DESCRIPTION("Backlight Driver for Maxim MAX8925");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff -puN drivers/video/backlight/omap1_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/omap1_bl.c
--- a/drivers/video/backlight/omap1_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/omap1_bl.c
@@ -195,18 +195,7 @@ static struct platform_driver omapbl_dri
 	},
 };
 
-static int __init omapbl_init(void)
-{
-	return platform_driver_register(&omapbl_driver);
-}
-
-static void __exit omapbl_exit(void)
-{
-	platform_driver_unregister(&omapbl_driver);
-}
-
-module_init(omapbl_init);
-module_exit(omapbl_exit);
+module_platform_driver(omapbl_driver);
 
 MODULE_AUTHOR("Andrzej Zaborowski <balrog@zabor.org>");
 MODULE_DESCRIPTION("OMAP LCD Backlight driver");
diff -puN drivers/video/backlight/pcf50633-backlight.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/pcf50633-backlight.c
--- a/drivers/video/backlight/pcf50633-backlight.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/pcf50633-backlight.c
@@ -173,17 +173,7 @@ static struct platform_driver pcf50633_b
 	},
 };
 
-static int __init pcf50633_bl_init(void)
-{
-	return platform_driver_register(&pcf50633_bl_driver);
-}
-module_init(pcf50633_bl_init);
-
-static void __exit pcf50633_bl_exit(void)
-{
-	platform_driver_unregister(&pcf50633_bl_driver);
-}
-module_exit(pcf50633_bl_exit);
+module_platform_driver(pcf50633_bl_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("PCF50633 backlight driver");
diff -puN drivers/video/backlight/platform_lcd.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/platform_lcd.c
@@ -157,18 +157,7 @@ static struct platform_driver platform_l
 	.resume         = platform_lcd_resume,
 };
 
-static int __init platform_lcd_init(void)
-{
-	return platform_driver_register(&platform_lcd_driver);
-}
-
-static void __exit platform_lcd_cleanup(void)
-{
-	platform_driver_unregister(&platform_lcd_driver);
-}
-
-module_init(platform_lcd_init);
-module_exit(platform_lcd_cleanup);
+module_platform_driver(platform_lcd_driver);
 
 MODULE_AUTHOR("Ben Dooks <ben-linux@fluff.org>");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/video/backlight/pwm_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/pwm_bl.c
--- a/drivers/video/backlight/pwm_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/pwm_bl.c
@@ -207,17 +207,7 @@ static struct platform_driver pwm_backli
 	.resume		= pwm_backlight_resume,
 };
 
-static int __init pwm_backlight_init(void)
-{
-	return platform_driver_register(&pwm_backlight_driver);
-}
-module_init(pwm_backlight_init);
-
-static void __exit pwm_backlight_exit(void)
-{
-	platform_driver_unregister(&pwm_backlight_driver);
-}
-module_exit(pwm_backlight_exit);
+module_platform_driver(pwm_backlight_driver);
 
 MODULE_DESCRIPTION("PWM based Backlight Driver");
 MODULE_LICENSE("GPL");
diff -puN drivers/video/backlight/wm831x_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver drivers/video/backlight/wm831x_bl.c
--- a/drivers/video/backlight/wm831x_bl.c~backlight-convert-drivers-video-backlight-to-use-module_platform_driver
+++ a/drivers/video/backlight/wm831x_bl.c
@@ -236,17 +236,7 @@ static struct platform_driver wm831x_bac
 	.remove		= wm831x_backlight_remove,
 };
 
-static int __init wm831x_backlight_init(void)
-{
-	return platform_driver_register(&wm831x_backlight_driver);
-}
-module_init(wm831x_backlight_init);
