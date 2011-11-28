From: akpm@linux-foundation.org
Subject: + leds-convert-led-platform-drivers-to-module_platform_driver.patch added to -mm tree
Date: Mon, 28 Nov 2011 15:27:29 -0800
Message-ID: <201111282327.pASNRTJR005605@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47610 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719Ab1K1X1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 18:27:38 -0500
Received: by eaaa14 with SMTP id a14so131409eaa.1
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2011 15:27:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com, g.liakhovetski@gmx.de, hennerich@blackfin.uclinux.org, hzhuang1@marvell.com, mike@compulab.co.il, rpurdie@rpsys.net


The patch titled
     Subject: leds: convert led platform drivers to module_platform_driver
has been added to the -mm tree.  Its filename is
     leds-convert-led-platform-drivers-to-module_platform_driver.patch

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
Subject: leds: convert led platform drivers to module_platform_driver

Factor out some boilerplate code for platform driver registration into
module_platform_driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Haojian Zhuang <hzhuang1@marvell.com>		[led-88pm860x.c]
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/leds/leds-88pm860x.c      |   12 +-----------
 drivers/leds/leds-adp5520.c       |   12 +-----------
 drivers/leds/leds-ams-delta.c     |   13 +------------
 drivers/leds/leds-asic3.c         |   16 ++--------------
 drivers/leds/leds-atmel-pwm.c     |   17 +++--------------
 drivers/leds/leds-cobalt-qube.c   |   17 ++---------------
 drivers/leds/leds-da903x.c        |   12 +-----------
 drivers/leds/leds-fsg.c           |   15 +--------------
 drivers/leds/leds-gpio.c          |   16 ++--------------
 drivers/leds/leds-hp6xx.c         |   17 ++---------------
 drivers/leds/leds-lt3593.c        |   16 ++--------------
 drivers/leds/leds-mc13783.c       |   12 +-----------
 drivers/leds/leds-netxbig.c       |   15 ++-------------
 drivers/leds/leds-ns2.c           |   15 ++-------------
 drivers/leds/leds-pwm.c           |   13 +------------
 drivers/leds/leds-rb532.c         |   16 ++--------------
 drivers/leds/leds-regulator.c     |   12 +-----------
 drivers/leds/leds-renesas-tpu.c   |   13 +------------
 drivers/leds/leds-s3c24xx.c       |   13 +------------
 drivers/leds/leds-wm831x-status.c |   12 +-----------
 drivers/leds/leds-wm8350.c        |   12 +-----------
 21 files changed, 31 insertions(+), 265 deletions(-)

diff -puN drivers/leds/leds-88pm860x.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-88pm860x.c
--- a/drivers/leds/leds-88pm860x.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-88pm860x.c
@@ -238,17 +238,7 @@ static struct platform_driver pm860x_led
 	.remove	= pm860x_led_remove,
 };
 
-static int __devinit pm860x_led_init(void)
-{
-	return platform_driver_register(&pm860x_led_driver);
-}
-module_init(pm860x_led_init);
-
-static void __devexit pm860x_led_exit(void)
-{
-	platform_driver_unregister(&pm860x_led_driver);
-}
-module_exit(pm860x_led_exit);
+module_platform_driver(pm860x_led_driver);
 
 MODULE_DESCRIPTION("LED driver for Marvell PM860x");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff -puN drivers/leds/leds-adp5520.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-adp5520.c
--- a/drivers/leds/leds-adp5520.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-adp5520.c
@@ -213,17 +213,7 @@ static struct platform_driver adp5520_le
 	.remove		= __devexit_p(adp5520_led_remove),
 };
 
-static int __init adp5520_led_init(void)
-{
-	return platform_driver_register(&adp5520_led_driver);
-}
-module_init(adp5520_led_init);
-
-static void __exit adp5520_led_exit(void)
-{
-	platform_driver_unregister(&adp5520_led_driver);
-}
-module_exit(adp5520_led_exit);
+module_platform_driver(adp5520_led_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("LEDS ADP5520(01) Driver");
diff -puN drivers/leds/leds-ams-delta.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-ams-delta.c
--- a/drivers/leds/leds-ams-delta.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-ams-delta.c
@@ -118,18 +118,7 @@ static struct platform_driver ams_delta_
 	},
 };
 
-static int __init ams_delta_led_init(void)
-{
-	return platform_driver_register(&ams_delta_led_driver);
-}
-
-static void __exit ams_delta_led_exit(void)
-{
-	platform_driver_unregister(&ams_delta_led_driver);
-}
-
-module_init(ams_delta_led_init);
-module_exit(ams_delta_led_exit);
+module_platform_driver(ams_delta_led_driver);
 
 MODULE_AUTHOR("Jonathan McDowell <noodles@earth.li>");
 MODULE_DESCRIPTION("Amstrad Delta LED driver");
diff -puN drivers/leds/leds-asic3.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-asic3.c
--- a/drivers/leds/leds-asic3.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-asic3.c
@@ -179,21 +179,9 @@ static struct platform_driver asic3_led_
 	},
 };
 
-MODULE_ALIAS("platform:leds-asic3");
-
-static int __init asic3_led_init(void)
-{
-	return platform_driver_register(&asic3_led_driver);
-}
-
-static void __exit asic3_led_exit(void)
-{
-	platform_driver_unregister(&asic3_led_driver);
-}
-
-module_init(asic3_led_init);
-module_exit(asic3_led_exit);
+module_platform_driver(asic3_led_driver);
 
 MODULE_AUTHOR("Paul Parsons <lost.distance@yahoo.com>");
 MODULE_DESCRIPTION("HTC ASIC3 LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-asic3");
diff -puN drivers/leds/leds-atmel-pwm.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-atmel-pwm.c
--- a/drivers/leds/leds-atmel-pwm.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-atmel-pwm.c
@@ -134,29 +134,18 @@ static int __exit pwmled_remove(struct p
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:leds-atmel-pwm");
-
 static struct platform_driver pwmled_driver = {
 	.driver = {
 		.name =		"leds-atmel-pwm",
 		.owner =	THIS_MODULE,
 	},
 	/* REVISIT add suspend() and resume() methods */
+	.probe =	pwmled_probe,
 	.remove =	__exit_p(pwmled_remove),
 };
 
-static int __init modinit(void)
-{
-	return platform_driver_probe(&pwmled_driver, pwmled_probe);
-}
-module_init(modinit);
-
-static void __exit modexit(void)
-{
-	platform_driver_unregister(&pwmled_driver);
-}
-module_exit(modexit);
+module_platform_driver(pwmled_driver);
 
 MODULE_DESCRIPTION("Driver for LEDs with PWM-controlled brightness");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-atmel-pwm");
diff -puN drivers/leds/leds-cobalt-qube.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-cobalt-qube.c
--- a/drivers/leds/leds-cobalt-qube.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-cobalt-qube.c
@@ -75,9 +75,6 @@ static int __devexit cobalt_qube_led_rem
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:cobalt-qube-leds");
-
 static struct platform_driver cobalt_qube_led_driver = {
 	.probe	= cobalt_qube_led_probe,
 	.remove	= __devexit_p(cobalt_qube_led_remove),
@@ -87,19 +84,9 @@ static struct platform_driver cobalt_qub
 	},
 };
 
-static int __init cobalt_qube_led_init(void)
-{
-	return platform_driver_register(&cobalt_qube_led_driver);
-}
-
-static void __exit cobalt_qube_led_exit(void)
-{
-	platform_driver_unregister(&cobalt_qube_led_driver);
-}
-
-module_init(cobalt_qube_led_init);
-module_exit(cobalt_qube_led_exit);
+module_platform_driver(cobalt_qube_led_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Front LED support for Cobalt Server");
 MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_ALIAS("platform:cobalt-qube-leds");
diff -puN drivers/leds/leds-da903x.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-da903x.c
--- a/drivers/leds/leds-da903x.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-da903x.c
@@ -158,17 +158,7 @@ static struct platform_driver da903x_led
 	.remove		= __devexit_p(da903x_led_remove),
 };
 
-static int __init da903x_led_init(void)
-{
-	return platform_driver_register(&da903x_led_driver);
-}
-module_init(da903x_led_init);
-
-static void __exit da903x_led_exit(void)
-{
-	platform_driver_unregister(&da903x_led_driver);
-}
-module_exit(da903x_led_exit);
+module_platform_driver(da903x_led_driver);
 
 MODULE_DESCRIPTION("LEDs driver for Dialog Semiconductor DA9030/DA9034");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>"
diff -puN drivers/leds/leds-fsg.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-fsg.c
--- a/drivers/leds/leds-fsg.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-fsg.c
@@ -224,20 +224,7 @@ static struct platform_driver fsg_led_dr
 	},
 };
 
-
-static int __init fsg_led_init(void)
-{
-	return platform_driver_register(&fsg_led_driver);
-}
-
-static void __exit fsg_led_exit(void)
-{
-	platform_driver_unregister(&fsg_led_driver);
-}
-
-
-module_init(fsg_led_init);
-module_exit(fsg_led_exit);
+module_platform_driver(fsg_led_driver);
 
 MODULE_AUTHOR("Rod Whitby <rod@whitby.id.au>");
 MODULE_DESCRIPTION("Freecom FSG-3 LED driver");
diff -puN drivers/leds/leds-gpio.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-gpio.c
--- a/drivers/leds/leds-gpio.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-gpio.c
@@ -293,21 +293,9 @@ static struct platform_driver gpio_led_d
 	},
 };
 
-MODULE_ALIAS("platform:leds-gpio");
-
-static int __init gpio_led_init(void)
-{
-	return platform_driver_register(&gpio_led_driver);
-}
-
-static void __exit gpio_led_exit(void)
-{
-	platform_driver_unregister(&gpio_led_driver);
-}
-
-module_init(gpio_led_init);
-module_exit(gpio_led_exit);
+module_platform_driver(gpio_led_driver);
 
 MODULE_AUTHOR("Raphael Assenat <raph@8d.com>, Trent Piepho <tpiepho@freescale.com>");
 MODULE_DESCRIPTION("GPIO LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-gpio");
diff -puN drivers/leds/leds-hp6xx.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-hp6xx.c
--- a/drivers/leds/leds-hp6xx.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-hp6xx.c
@@ -79,9 +79,6 @@ static int hp6xxled_remove(struct platfo
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:hp6xx-led");
-
 static struct platform_driver hp6xxled_driver = {
 	.probe		= hp6xxled_probe,
 	.remove		= hp6xxled_remove,
@@ -91,19 +88,9 @@ static struct platform_driver hp6xxled_d
 	},
 };
 
-static int __init hp6xxled_init(void)
-{
-	return platform_driver_register(&hp6xxled_driver);
-}
-
-static void __exit hp6xxled_exit(void)
-{
-	platform_driver_unregister(&hp6xxled_driver);
-}
-
-module_init(hp6xxled_init);
-module_exit(hp6xxled_exit);
+module_platform_driver(hp6xxled_driver);
 
 MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
 MODULE_DESCRIPTION("HP Jornada 6xx LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:hp6xx-led");
diff -puN drivers/leds/leds-lt3593.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-lt3593.c
--- a/drivers/leds/leds-lt3593.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-lt3593.c
@@ -199,21 +199,9 @@ static struct platform_driver lt3593_led
 	},
 };
 
-MODULE_ALIAS("platform:leds-lt3593");
-
-static int __init lt3593_led_init(void)
-{
-	return platform_driver_register(&lt3593_led_driver);
-}
-
-static void __exit lt3593_led_exit(void)
-{
-	platform_driver_unregister(&lt3593_led_driver);
-}
-
-module_init(lt3593_led_init);
-module_exit(lt3593_led_exit);
+module_platform_driver(lt3593_led_driver);
 
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_DESCRIPTION("LED driver for LT3593 controllers");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-lt3593");
diff -puN drivers/leds/leds-mc13783.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-mc13783.c
--- a/drivers/leds/leds-mc13783.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-mc13783.c
@@ -385,17 +385,7 @@ static struct platform_driver mc13783_le
 	.remove		= __devexit_p(mc13783_led_remove),
 };
 
-static int __init mc13783_led_init(void)
-{
-	return platform_driver_register(&mc13783_led_driver);
-}
-module_init(mc13783_led_init);
-
-static void __exit mc13783_led_exit(void)
-{
-	platform_driver_unregister(&mc13783_led_driver);
-}
-module_exit(mc13783_led_exit);
+module_platform_driver(mc13783_led_driver);
 
 MODULE_DESCRIPTION("LEDs driver for Freescale MC13783 PMIC");
 MODULE_AUTHOR("Philippe Retornaz <philippe.retornaz@epfl.ch>");
diff -puN drivers/leds/leds-netxbig.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-netxbig.c
--- a/drivers/leds/leds-netxbig.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-netxbig.c
@@ -429,21 +429,10 @@ static struct platform_driver netxbig_le
 		.owner	= THIS_MODULE,
 	},
 };
-MODULE_ALIAS("platform:leds-netxbig");
-
-static int __init netxbig_led_init(void)
-{
-	return platform_driver_register(&netxbig_led_driver);
-}
 
-static void __exit netxbig_led_exit(void)
-{
-	platform_driver_unregister(&netxbig_led_driver);
-}
-
-module_init(netxbig_led_init);
-module_exit(netxbig_led_exit);
+module_platform_driver(netxbig_led_driver);
 
 MODULE_AUTHOR("Simon Guinot <sguinot@lacie.com>");
 MODULE_DESCRIPTION("LED driver for LaCie xBig Network boards");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-netxbig");
diff -puN drivers/leds/leds-ns2.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-ns2.c
--- a/drivers/leds/leds-ns2.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-ns2.c
@@ -323,21 +323,10 @@ static struct platform_driver ns2_led_dr
 		.owner	= THIS_MODULE,
 	},
 };
-MODULE_ALIAS("platform:leds-ns2");
-
-static int __init ns2_led_init(void)
-{
-	return platform_driver_register(&ns2_led_driver);
-}
 
-static void __exit ns2_led_exit(void)
-{
-	platform_driver_unregister(&ns2_led_driver);
-}
-
-module_init(ns2_led_init);
-module_exit(ns2_led_exit);
+module_platform_driver(ns2_led_driver);
 
 MODULE_AUTHOR("Simon Guinot <sguinot@lacie.com>");
 MODULE_DESCRIPTION("Network Space v2 LED driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:leds-ns2");
diff -puN drivers/leds/leds-pwm.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-pwm.c
--- a/drivers/leds/leds-pwm.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-pwm.c
@@ -135,18 +135,7 @@ static struct platform_driver led_pwm_dr
 	},
 };
 
-static int __init led_pwm_init(void)
-{
-	return platform_driver_register(&led_pwm_driver);
-}
-
-static void __exit led_pwm_exit(void)
-{
-	platform_driver_unregister(&led_pwm_driver);
-}
-
-module_init(led_pwm_init);
-module_exit(led_pwm_exit);
+module_platform_driver(led_pwm_driver);
 
 MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
 MODULE_DESCRIPTION("PWM LED driver for PXA");
diff -puN drivers/leds/leds-rb532.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-rb532.c
--- a/drivers/leds/leds-rb532.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-rb532.c
@@ -57,21 +57,9 @@ static struct platform_driver rb532_led_
 	},
 };
 
-static int __init rb532_led_init(void)
-{
-	return platform_driver_register(&rb532_led_driver);
-}
-
-static void __exit rb532_led_exit(void)
-{
-	platform_driver_unregister(&rb532_led_driver);
-}
-
-module_init(rb532_led_init);
-module_exit(rb532_led_exit);
-
-MODULE_ALIAS("platform:rb532-led");
+module_platform_driver(rb532_led_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("User LED support for Routerboard532");
 MODULE_AUTHOR("Phil Sutter <n0-1@freewrt.org>");
+MODULE_ALIAS("platform:rb532-led");
diff -puN drivers/leds/leds-regulator.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-regulator.c
--- a/drivers/leds/leds-regulator.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-regulator.c
@@ -229,17 +229,7 @@ static struct platform_driver regulator_
 	.remove = __devexit_p(regulator_led_remove),
 };
 
-static int __init regulator_led_init(void)
-{
-	return platform_driver_register(&regulator_led_driver);
-}
-module_init(regulator_led_init);
-
-static void __exit regulator_led_exit(void)
-{
-	platform_driver_unregister(&regulator_led_driver);
-}
-module_exit(regulator_led_exit);
+module_platform_driver(regulator_led_driver);
 
 MODULE_AUTHOR("Antonio Ospite <ospite@studenti.unina.it>");
 MODULE_DESCRIPTION("Regulator driven LED driver");
diff -puN drivers/leds/leds-renesas-tpu.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-renesas-tpu.c
--- a/drivers/leds/leds-renesas-tpu.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-renesas-tpu.c
@@ -339,18 +339,7 @@ static struct platform_driver r_tpu_devi
 	}
 };
 
-static int __init r_tpu_init(void)
-{
-	return platform_driver_register(&r_tpu_device_driver);
-}
-
-static void __exit r_tpu_exit(void)
-{
-	platform_driver_unregister(&r_tpu_device_driver);
-}
-
-module_init(r_tpu_init);
-module_exit(r_tpu_exit);
+module_platform_driver(r_tpu_device_driver);
 
 MODULE_AUTHOR("Magnus Damm");
 MODULE_DESCRIPTION("Renesas TPU LED Driver");
diff -puN drivers/leds/leds-s3c24xx.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-s3c24xx.c
--- a/drivers/leds/leds-s3c24xx.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-s3c24xx.c
@@ -121,18 +121,7 @@ static struct platform_driver s3c24xx_le
 	},
 };
 
-static int __init s3c24xx_led_init(void)
-{
-	return platform_driver_register(&s3c24xx_led_driver);
-}
-
-static void __exit s3c24xx_led_exit(void)
-{
-	platform_driver_unregister(&s3c24xx_led_driver);
-}
-
-module_init(s3c24xx_led_init);
-module_exit(s3c24xx_led_exit);
+module_platform_driver(s3c24xx_led_driver);
 
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("S3C24XX LED driver");
diff -puN drivers/leds/leds-wm831x-status.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-wm831x-status.c
--- a/drivers/leds/leds-wm831x-status.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-wm831x-status.c
@@ -325,17 +325,7 @@ static struct platform_driver wm831x_sta
 	.remove = wm831x_status_remove,
 };
 
-static int __devinit wm831x_status_init(void)
-{
-	return platform_driver_register(&wm831x_status_driver);
-}
-module_init(wm831x_status_init);
-
-static void wm831x_status_exit(void)
-{
-	platform_driver_unregister(&wm831x_status_driver);
-}
-module_exit(wm831x_status_exit);
+module_platform_driver(wm831x_status_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("WM831x status LED driver");
diff -puN drivers/leds/leds-wm8350.c~leds-convert-led-platform-drivers-to-module_platform_driver drivers/leds/leds-wm8350.c
--- a/drivers/leds/leds-wm8350.c~leds-convert-led-platform-drivers-to-module_platform_driver
+++ a/drivers/leds/leds-wm8350.c
@@ -295,17 +295,7 @@ static struct platform_driver wm8350_led
 	.shutdown = wm8350_led_shutdown,
 };
 
-static int __devinit wm8350_led_init(void)
-{
-	return platform_driver_register(&wm8350_led_driver);
-}
-module_init(wm8350_led_init);
