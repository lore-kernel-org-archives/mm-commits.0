From: akpm@linux-foundation.org
Subject: [merged] backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:52 -0700
Message-ID: <20120326192852.A15C4A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:49034 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2CZT2x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:53 -0400
Received: by ggnd2 with SMTP id d2so830499ggn.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axel.lin@gmail.com, alberto@amarulasolutions.com, ben-linux@fluff.org, dbaryshkov@gmail.com, dh09.lee@samsung.com, eric.y.miao@gmail.com, hskinnemoen@atmel.com, inki.dae@samsung.com, jg1.han@samsung.com, marek.vasut@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight: convert backlight spi drivers to module_spi_driver
has been removed from the -mm tree.  Its filename was
     backlight-convert-backlight-spi-drivers-to-module_spi_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Axel Lin <axel.lin@gmail.com>
Subject: backlight: convert backlight spi drivers to module_spi_driver

Factor out some boilerplate code for spi driver registration into
module_spi_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Acked-by: Alberto Panizzo <alberto@amarulasolutions.com>
Cc: Donghwa Lee <dh09.lee@samsung.com>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: InKi Dae <inki.dae@samsung.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c  |   13 +------------
 drivers/video/backlight/corgi_lcd.c   |   12 +-----------
 drivers/video/backlight/l4f00242t03.c |   13 +------------
 drivers/video/backlight/ld9040.c      |   13 +------------
 drivers/video/backlight/lms283gf05.c  |   13 +------------
 drivers/video/backlight/ltv350qv.c    |   12 +-----------
 drivers/video/backlight/s6e63m0.c     |   13 +------------
 drivers/video/backlight/tdo24m.c      |   12 +-----------
 drivers/video/backlight/tosa_lcd.c    |   13 +------------
 drivers/video/backlight/vgg2432a4.c   |   15 +--------------
 10 files changed, 10 insertions(+), 119 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/ams369fg06.c
@@ -629,18 +629,7 @@ static struct spi_driver ams369fg06_driv
 	.resume		= ams369fg06_resume,
 };
 
-static int __init ams369fg06_init(void)
-{
-	return spi_register_driver(&ams369fg06_driver);
-}
-
-static void __exit ams369fg06_exit(void)
-{
-	spi_unregister_driver(&ams369fg06_driver);
-}
-
-module_init(ams369fg06_init);
-module_exit(ams369fg06_exit);
+module_spi_driver(ams369fg06_driver);
 
 MODULE_AUTHOR("Jingoo Han <jg1.han@samsung.com>");
 MODULE_DESCRIPTION("ams369fg06 LCD Driver");
diff -puN drivers/video/backlight/corgi_lcd.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/corgi_lcd.c
--- a/drivers/video/backlight/corgi_lcd.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/corgi_lcd.c
@@ -629,17 +629,7 @@ static struct spi_driver corgi_lcd_drive
 	.resume		= corgi_lcd_resume,
 };
 
-static int __init corgi_lcd_init(void)
-{
-	return spi_register_driver(&corgi_lcd_driver);
-}
-module_init(corgi_lcd_init);
-
-static void __exit corgi_lcd_exit(void)
-{
-	spi_unregister_driver(&corgi_lcd_driver);
-}
-module_exit(corgi_lcd_exit);
+module_spi_driver(corgi_lcd_driver);
 
 MODULE_DESCRIPTION("LCD and backlight driver for SHARP C7x0/Cxx00");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
diff -puN drivers/video/backlight/l4f00242t03.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/l4f00242t03.c
--- a/drivers/video/backlight/l4f00242t03.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/l4f00242t03.c
@@ -274,18 +274,7 @@ static struct spi_driver l4f00242t03_dri
 	.shutdown	= l4f00242t03_shutdown,
 };
 
-static __init int l4f00242t03_init(void)
-{
-	return spi_register_driver(&l4f00242t03_driver);
-}
-
-static __exit void l4f00242t03_exit(void)
-{
-	spi_unregister_driver(&l4f00242t03_driver);
-}
-
-module_init(l4f00242t03_init);
-module_exit(l4f00242t03_exit);
+module_spi_driver(l4f00242t03_driver);
 
 MODULE_AUTHOR("Alberto Panizzo <maramaopercheseimorto@gmail.com>");
 MODULE_DESCRIPTION("EPSON L4F00242T03 LCD");
diff -puN drivers/video/backlight/ld9040.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/ld9040.c
--- a/drivers/video/backlight/ld9040.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/ld9040.c
@@ -856,18 +856,7 @@ static struct spi_driver ld9040_driver =
 	.resume		= ld9040_resume,
 };
 
-static int __init ld9040_init(void)
-{
-	return spi_register_driver(&ld9040_driver);
-}
-
-static void __exit ld9040_exit(void)
-{
-	spi_unregister_driver(&ld9040_driver);
-}
-
-module_init(ld9040_init);
-module_exit(ld9040_exit);
+module_spi_driver(ld9040_driver);
 
 MODULE_AUTHOR("Donghwa Lee <dh09.lee@samsung.com>");
 MODULE_DESCRIPTION("ld9040 LCD Driver");
diff -puN drivers/video/backlight/lms283gf05.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/lms283gf05.c
@@ -226,18 +226,7 @@ static struct spi_driver lms283gf05_driv
 	.remove		= __devexit_p(lms283gf05_remove),
 };
 
-static __init int lms283gf05_init(void)
-{
-	return spi_register_driver(&lms283gf05_driver);
-}
-
-static __exit void lms283gf05_exit(void)
-{
-	spi_unregister_driver(&lms283gf05_driver);
-}
-
-module_init(lms283gf05_init);
-module_exit(lms283gf05_exit);
+module_spi_driver(lms283gf05_driver);
 
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
 MODULE_DESCRIPTION("LCD283GF05 LCD");
diff -puN drivers/video/backlight/ltv350qv.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/ltv350qv.c
--- a/drivers/video/backlight/ltv350qv.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/ltv350qv.c
@@ -321,17 +321,7 @@ static struct spi_driver ltv350qv_driver
 	.resume		= ltv350qv_resume,
 };
 
-static int __init ltv350qv_init(void)
-{
-	return spi_register_driver(&ltv350qv_driver);
-}
-
-static void __exit ltv350qv_exit(void)
-{
-	spi_unregister_driver(&ltv350qv_driver);
-}
-module_init(ltv350qv_init);
-module_exit(ltv350qv_exit);
+module_spi_driver(ltv350qv_driver);
 
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
 MODULE_DESCRIPTION("Samsung LTV350QV LCD Driver");
diff -puN drivers/video/backlight/s6e63m0.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/s6e63m0.c
--- a/drivers/video/backlight/s6e63m0.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/s6e63m0.c
@@ -909,18 +909,7 @@ static struct spi_driver s6e63m0_driver 
 	.resume		= s6e63m0_resume,
 };
 
-static int __init s6e63m0_init(void)
-{
-	return spi_register_driver(&s6e63m0_driver);
-}
-
-static void __exit s6e63m0_exit(void)
-{
-	spi_unregister_driver(&s6e63m0_driver);
-}
-
-module_init(s6e63m0_init);
-module_exit(s6e63m0_exit);
+module_spi_driver(s6e63m0_driver);
 
 MODULE_AUTHOR("InKi Dae <inki.dae@samsung.com>");
 MODULE_DESCRIPTION("S6E63M0 LCD Driver");
diff -puN drivers/video/backlight/tdo24m.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/tdo24m.c
--- a/drivers/video/backlight/tdo24m.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/tdo24m.c
@@ -459,17 +459,7 @@ static struct spi_driver tdo24m_driver =
 	.resume		= tdo24m_resume,
 };
 
-static int __init tdo24m_init(void)
-{
-	return spi_register_driver(&tdo24m_driver);
-}
-module_init(tdo24m_init);
-
-static void __exit tdo24m_exit(void)
-{
-	spi_unregister_driver(&tdo24m_driver);
-}
-module_exit(tdo24m_exit);
+module_spi_driver(tdo24m_driver);
 
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>");
 MODULE_DESCRIPTION("Driver for Toppoly TDO24M LCD Panel");
diff -puN drivers/video/backlight/tosa_lcd.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/tosa_lcd.c
--- a/drivers/video/backlight/tosa_lcd.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/tosa_lcd.c
@@ -285,18 +285,7 @@ static struct spi_driver tosa_lcd_driver
 	.resume		= tosa_lcd_resume,
 };
 
-static int __init tosa_lcd_init(void)
-{
-	return spi_register_driver(&tosa_lcd_driver);
-}
-
-static void __exit tosa_lcd_exit(void)
-{
-	spi_unregister_driver(&tosa_lcd_driver);
-}
-
-module_init(tosa_lcd_init);
-module_exit(tosa_lcd_exit);
+module_spi_driver(tosa_lcd_driver);
 
 MODULE_AUTHOR("Dmitry Baryshkov");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/video/backlight/vgg2432a4.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver drivers/video/backlight/vgg2432a4.c
--- a/drivers/video/backlight/vgg2432a4.c~backlight-convert-backlight-spi-drivers-to-module_spi_driver
+++ a/drivers/video/backlight/vgg2432a4.c
@@ -262,20 +262,7 @@ static struct spi_driver vgg2432a4_drive
 	.resume		= vgg2432a4_resume,
 };
 
-/* Device driver initialisation */
-
-static int __init vgg2432a4_init(void)
-{
-	return spi_register_driver(&vgg2432a4_driver);
-}
-
-static void __exit vgg2432a4_exit(void)
-{
-	spi_unregister_driver(&vgg2432a4_driver);
-}
