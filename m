From: akpm@linux-foundation.org
Subject: + leds-convert-led-i2c-drivers-to-module_i2c_driver.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:27:37 -0800
Message-ID: <201111282327.pASNRcuS005773@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:33020 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab1K1X1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:27:40 -0500
Received: by ywb26 with SMTP id 26so514992ywb.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:27:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com, g.liakhovetski@gmx.de, hennerich@blackfin.uclinux.org, hzhuang1@marvell.com, mike@compulab.co.il, rpurdie@rpsys.net


The patch titled
     Subject: leds: convert led i2c drivers to module_i2c_driver
has been added to the -mm tree.  Its filename is
     leds-convert-led-i2c-drivers-to-module_i2c_driver.patch

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
Subject: leds: convert led i2c drivers to module_i2c_driver

Factor out some boilerplate code for i2c driver registration
into module_i2c_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Haojian Zhuang <hzhuang1@marvell.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-bd2802.c  |   12 +-----------
 drivers/leds/leds-lm3530.c  |   13 +------------
 drivers/leds/leds-lp3944.c  |   13 +------------
 drivers/leds/leds-lp5521.c  |   20 +-------------------
 drivers/leds/leds-lp5523.c  |   20 +-------------------
 drivers/leds/leds-pca9532.c |   14 +-------------
 drivers/leds/leds-pca955x.c |   13 +------------
 7 files changed, 7 insertions(+), 98 deletions(-)

diff -puN drivers/leds/leds-bd2802.c~leds-convert-led-i2c-drivers-to-module_i2c_driver drivers/leds/leds-bd2802.c
--- a/drivers/leds/leds-bd2802.c~leds-convert-led-i2c-drivers-to-module_i2c_driver
+++ a/drivers/leds/leds-bd2802.c
@@ -813,17 +813,7 @@ static struct i2c_driver bd2802_i2c_driv
 	.id_table	= bd2802_id,
 };
 
-static int __init bd2802_init(void)
-{
-	return i2c_add_driver(&bd2802_i2c_driver);
-}
-module_init(bd2802_init);
-
-static void __exit bd2802_exit(void)
-{
-	i2c_del_driver(&bd2802_i2c_driver);
-}
-module_exit(bd2802_exit);
+module_i2c_driver(bd2802_i2c_driver);
 
 MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
 MODULE_DESCRIPTION("BD2802 LED driver");
diff -puN drivers/leds/leds-lm3530.c~leds-convert-led-i2c-drivers-to-module_i2c_driver drivers/leds/leds-lm3530.c
--- a/drivers/leds/leds-lm3530.c~leds-convert-led-i2c-drivers-to-module_i2c_driver
+++ a/drivers/leds/leds-lm3530.c
@@ -457,18 +457,7 @@ static struct i2c_driver lm3530_i2c_driv
 	},
 };
 
-static int __init lm3530_init(void)
-{
-	return i2c_add_driver(&lm3530_i2c_driver);
-}
-
-static void __exit lm3530_exit(void)
-{
-	i2c_del_driver(&lm3530_i2c_driver);
-}
-
-module_init(lm3530_init);
-module_exit(lm3530_exit);
+module_i2c_driver(lm3530_i2c_driver);
 
 MODULE_DESCRIPTION("Back Light driver for LM3530");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/leds/leds-lp3944.c~leds-convert-led-i2c-drivers-to-module_i2c_driver drivers/leds/leds-lp3944.c
--- a/drivers/leds/leds-lp3944.c~leds-convert-led-i2c-drivers-to-module_i2c_driver
+++ a/drivers/leds/leds-lp3944.c
@@ -453,18 +453,7 @@ static struct i2c_driver lp3944_driver =
 	.id_table = lp3944_id,
 };
 
-static int __init lp3944_module_init(void)
-{
-	return i2c_add_driver(&lp3944_driver);
-}
-
-static void __exit lp3944_module_exit(void)
-{
-	i2c_del_driver(&lp3944_driver);
-}
-
-module_init(lp3944_module_init);
-module_exit(lp3944_module_exit);
+module_i2c_driver(lp3944_driver);
 
 MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("LP3944 Fun Light Chip");
diff -puN drivers/leds/leds-lp5521.c~leds-convert-led-i2c-drivers-to-module_i2c_driver drivers/leds/leds-lp5521.c
--- a/drivers/leds/leds-lp5521.c~leds-convert-led-i2c-drivers-to-module_i2c_driver
+++ a/drivers/leds/leds-lp5521.c
@@ -797,25 +797,7 @@ static struct i2c_driver lp5521_driver =
 	.id_table	= lp5521_id,
 };
 
-static int __init lp5521_init(void)
-{
-	int ret;
-
-	ret = i2c_add_driver(&lp5521_driver);
-
-	if (ret < 0)
-		printk(KERN_ALERT "Adding lp5521 driver failed\n");
-
-	return ret;
-}
-
-static void __exit lp5521_exit(void)
-{
-	i2c_del_driver(&lp5521_driver);
-}
-
-module_init(lp5521_init);
-module_exit(lp5521_exit);
+module_i2c_driver(lp5521_driver);
 
 MODULE_AUTHOR("Mathias Nyman, Yuri Zaporozhets, Samu Onkalo");
 MODULE_DESCRIPTION("LP5521 LED engine");
diff -puN drivers/leds/leds-lp5523.c~leds-convert-led-i2c-drivers-to-module_i2c_driver drivers/leds/leds-lp5523.c
--- a/drivers/leds/leds-lp5523.c~leds-convert-led-i2c-drivers-to-module_i2c_driver
+++ a/drivers/leds/leds-lp5523.c
@@ -1021,25 +1021,7 @@ static struct i2c_driver lp5523_driver =
 	.id_table	= lp5523_id,
 };
 
-static int __init lp5523_init(void)
-{
-	int ret;
-
-	ret = i2c_add_driver(&lp5523_driver);
-
-	if (ret < 0)
-		printk(KERN_ALERT "Adding lp5523 driver failed\n");
-
-	return ret;
-}
-
-static void __exit lp5523_exit(void)
-{
-	i2c_del_driver(&lp5523_driver);
-}
-
-module_init(lp5523_init);
-module_exit(lp5523_exit);
+module_i2c_driver(lp5523_driver);
 
 MODULE_AUTHOR("Mathias Nyman <mathias.nyman@nokia.com>");
 MODULE_DESCRIPTION("LP5523 LED engine");
diff -puN drivers/leds/leds-pca9532.c~leds-convert-led-i2c-drivers-to-module_i2c_driver drivers/leds/leds-pca9532.c
--- a/drivers/leds/leds-pca9532.c~leds-convert-led-i2c-drivers-to-module_i2c_driver
+++ a/drivers/leds/leds-pca9532.c
@@ -489,20 +489,8 @@ static int pca9532_remove(struct i2c_cli
 	return 0;
 }
 
-static int __init pca9532_init(void)
-{
-	return i2c_add_driver(&pca9532_driver);
-}
-
-static void __exit pca9532_exit(void)
-{
-	i2c_del_driver(&pca9532_driver);
-}
+module_i2c_driver(pca9532_driver);
 
 MODULE_AUTHOR("Riku Voipio");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCA 9532 LED dimmer");
-
-module_init(pca9532_init);
-module_exit(pca9532_exit);
-
diff -puN drivers/leds/leds-pca955x.c~leds-convert-led-i2c-drivers-to-module_i2c_driver drivers/leds/leds-pca955x.c
--- a/drivers/leds/leds-pca955x.c~leds-convert-led-i2c-drivers-to-module_i2c_driver
+++ a/drivers/leds/leds-pca955x.c
@@ -371,18 +371,7 @@ static struct i2c_driver pca955x_driver 
 	.id_table = pca955x_id,
 };
 
-static int __init pca955x_leds_init(void)
-{
-	return i2c_add_driver(&pca955x_driver);
-}
-
-static void __exit pca955x_leds_exit(void)
-{
-	i2c_del_driver(&pca955x_driver);
-}
