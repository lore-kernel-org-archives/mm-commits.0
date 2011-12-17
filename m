From: akpm@linux-foundation.org
Subject: + rtc-convert-drivers-rtc-to-use-module_platform_driver.patch added to -mm tree
Date: Fri, 16 Dec 2011 16:08:29 -0800
Message-ID: <20111217000829.E090510004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:59518 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1LQAIb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 19:08:31 -0500
Received: by ghrr15 with SMTP id r15so179296ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 16:08:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: axel.lin@gmail.com, a.zummo@towertech.it, ben@simtec.co.uk, broonie@opensource.wolfsonmicro.com, gxt@mprc.pku.edu.cn, haojian.zhuang@gmail.com, john.stultz@linaro.org, lars@metafoo.de, linus.walleij@linaro.org, linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com, vapier.adi@gmail.com, vapier@gentoo.org


The patch titled
     Subject: rtc: convert drivers/rtc/* to use module_platform_driver()
has been added to the -mm tree.  Its filename is
     rtc-convert-drivers-rtc-to-use-module_platform_driver.patch

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
Subject: rtc: convert drivers/rtc/* to use module_platform_driver()

This patch converts the drivers in drivers/rtc/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-88pm860x.c |   12 +-----------
 drivers/rtc/rtc-ab8500.c   |   12 +-----------
 drivers/rtc/rtc-bfin.c     |   13 +------------
 drivers/rtc/rtc-bq4802.c   |   13 +------------
 drivers/rtc/rtc-dm355evm.c |   12 +-----------
 drivers/rtc/rtc-ds1286.c   |   13 +------------
 drivers/rtc/rtc-ds1511.c   |   15 +--------------
 drivers/rtc/rtc-ds1553.c   |   13 +------------
 drivers/rtc/rtc-ds1742.c   |   13 +------------
 drivers/rtc/rtc-jz4740.c   |   12 +-----------
 drivers/rtc/rtc-lpc32xx.c  |   12 +-----------
 drivers/rtc/rtc-m48t35.c   |   13 +------------
 drivers/rtc/rtc-m48t59.c   |   13 +------------
 drivers/rtc/rtc-m48t86.c   |   13 +------------
 drivers/rtc/rtc-max8925.c  |   12 +-----------
 drivers/rtc/rtc-max8998.c  |   12 +-----------
 drivers/rtc/rtc-mpc5121.c  |   12 +-----------
 drivers/rtc/rtc-mrst.c     |   13 +------------
 drivers/rtc/rtc-pcf50633.c |   12 +-----------
 drivers/rtc/rtc-pm8xxx.c   |   12 +-----------
 drivers/rtc/rtc-puv3.c     |   16 +---------------
 drivers/rtc/rtc-s3c.c      |   16 +---------------
 drivers/rtc/rtc-sa1100.c   |   13 +------------
 drivers/rtc/rtc-spear.c    |   12 +-----------
 drivers/rtc/rtc-stk17ta8.c |   13 +------------
 drivers/rtc/rtc-stmp3xxx.c |   13 +------------
 drivers/rtc/rtc-v3020.c    |   13 +------------
 drivers/rtc/rtc-vr41xx.c   |   13 +------------
 drivers/rtc/rtc-vt8500.c   |   12 +-----------
 drivers/rtc/rtc-wm831x.c   |   12 +-----------
 drivers/rtc/rtc-wm8350.c   |   12 +-----------
 31 files changed, 31 insertions(+), 366 deletions(-)

diff -puN drivers/rtc/rtc-88pm860x.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-88pm860x.c
--- a/drivers/rtc/rtc-88pm860x.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-88pm860x.c
@@ -410,17 +410,7 @@ static struct platform_driver pm860x_rtc
 	.remove		= __devexit_p(pm860x_rtc_remove),
 };
 
-static int __init pm860x_rtc_init(void)
-{
-	return platform_driver_register(&pm860x_rtc_driver);
-}
-module_init(pm860x_rtc_init);
-
-static void __exit pm860x_rtc_exit(void)
-{
-	platform_driver_unregister(&pm860x_rtc_driver);
-}
-module_exit(pm860x_rtc_exit);
+module_platform_driver(pm860x_rtc_driver);
 
 MODULE_DESCRIPTION("Marvell 88PM860x RTC driver");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff -puN drivers/rtc/rtc-ab8500.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-ab8500.c
@@ -463,18 +463,8 @@ static struct platform_driver ab8500_rtc
 	.remove = __devexit_p(ab8500_rtc_remove),
 };
 
-static int __init ab8500_rtc_init(void)
-{
-	return platform_driver_register(&ab8500_rtc_driver);
-}
+module_platform_driver(ab8500_rtc_driver);
 
-static void __exit ab8500_rtc_exit(void)
-{
-	platform_driver_unregister(&ab8500_rtc_driver);
-}
-
-module_init(ab8500_rtc_init);
-module_exit(ab8500_rtc_exit);
 MODULE_AUTHOR("Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>");
 MODULE_DESCRIPTION("AB8500 RTC Driver");
 MODULE_LICENSE("GPL v2");
diff -puN drivers/rtc/rtc-bfin.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-bfin.c
--- a/drivers/rtc/rtc-bfin.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-bfin.c
@@ -456,18 +456,7 @@ static struct platform_driver bfin_rtc_d
 	.resume		= bfin_rtc_resume,
 };
 
-static int __init bfin_rtc_init(void)
-{
-	return platform_driver_register(&bfin_rtc_driver);
-}
-
-static void __exit bfin_rtc_exit(void)
-{
-	platform_driver_unregister(&bfin_rtc_driver);
-}
-
-module_init(bfin_rtc_init);
-module_exit(bfin_rtc_exit);
+module_platform_driver(bfin_rtc_driver);
 
 MODULE_DESCRIPTION("Blackfin On-Chip Real Time Clock Driver");
 MODULE_AUTHOR("Mike Frysinger <vapier@gentoo.org>");
diff -puN drivers/rtc/rtc-bq4802.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-bq4802.c
--- a/drivers/rtc/rtc-bq4802.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-bq4802.c
@@ -218,15 +218,4 @@ static struct platform_driver bq4802_dri
 	.remove		= __devexit_p(bq4802_remove),
 };
 
-static int __init bq4802_init(void)
-{
-	return platform_driver_register(&bq4802_driver);
-}
-
-static void __exit bq4802_exit(void)
-{
-	platform_driver_unregister(&bq4802_driver);
-}
-
-module_init(bq4802_init);
-module_exit(bq4802_exit);
+module_platform_driver(bq4802_driver);
diff -puN drivers/rtc/rtc-dm355evm.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-dm355evm.c
--- a/drivers/rtc/rtc-dm355evm.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-dm355evm.c
@@ -161,16 +161,6 @@ static struct platform_driver rtc_dm355e
 	},
 };
 
-static int __init dm355evm_rtc_init(void)
-{
-	return platform_driver_register(&rtc_dm355evm_driver);
-}
-module_init(dm355evm_rtc_init);
-
-static void __exit dm355evm_rtc_exit(void)
-{
-	platform_driver_unregister(&rtc_dm355evm_driver);
-}
-module_exit(dm355evm_rtc_exit);
+module_platform_driver(rtc_dm355evm_driver);
 
 MODULE_LICENSE("GPL");
diff -puN drivers/rtc/rtc-ds1286.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-ds1286.c
--- a/drivers/rtc/rtc-ds1286.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-ds1286.c
@@ -396,21 +396,10 @@ static struct platform_driver ds1286_pla
 	.remove		= __devexit_p(ds1286_remove),
 };
 
-static int __init ds1286_init(void)
-{
-	return platform_driver_register(&ds1286_platform_driver);
-}
-
-static void __exit ds1286_exit(void)
-{
-	platform_driver_unregister(&ds1286_platform_driver);
-}
+module_platform_driver(ds1286_platform_driver);
 
 MODULE_AUTHOR("Thomas Bogendoerfer <tsbogend@alpha.franken.de>");
 MODULE_DESCRIPTION("DS1286 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:rtc-ds1286");
-
-module_init(ds1286_init);
-module_exit(ds1286_exit);
diff -puN drivers/rtc/rtc-ds1511.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-ds1511.c
--- a/drivers/rtc/rtc-ds1511.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-ds1511.c
@@ -580,20 +580,7 @@ static struct platform_driver ds1511_rtc
 	},
 };
 
- static int __init
-ds1511_rtc_init(void)
-{
-	return platform_driver_register(&ds1511_rtc_driver);
-}
-
- static void __exit
-ds1511_rtc_exit(void)
-{
-	platform_driver_unregister(&ds1511_rtc_driver);
-}
-
-module_init(ds1511_rtc_init);
-module_exit(ds1511_rtc_exit);
+module_platform_driver(ds1511_rtc_driver);
 
 MODULE_AUTHOR("Andrew Sharp <andy.sharp@lsi.com>");
 MODULE_DESCRIPTION("Dallas DS1511 RTC driver");
diff -puN drivers/rtc/rtc-ds1553.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-ds1553.c
@@ -361,18 +361,7 @@ static struct platform_driver ds1553_rtc
 	},
 };
 
-static __init int ds1553_init(void)
-{
-	return platform_driver_register(&ds1553_rtc_driver);
-}
-
-static __exit void ds1553_exit(void)
-{
-	platform_driver_unregister(&ds1553_rtc_driver);
-}
-
-module_init(ds1553_init);
-module_exit(ds1553_exit);
+module_platform_driver(ds1553_rtc_driver);
 
 MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1553 RTC driver");
diff -puN drivers/rtc/rtc-ds1742.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-ds1742.c
@@ -240,18 +240,7 @@ static struct platform_driver ds1742_rtc
 	},
 };
 
-static __init int ds1742_init(void)
-{
-	return platform_driver_register(&ds1742_rtc_driver);
-}
-
-static __exit void ds1742_exit(void)
-{
-	platform_driver_unregister(&ds1742_rtc_driver);
-}
-
-module_init(ds1742_init);
-module_exit(ds1742_exit);
+module_platform_driver(ds1742_rtc_driver);
 
 MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1742 RTC driver");
diff -puN drivers/rtc/rtc-jz4740.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-jz4740.c
@@ -355,17 +355,7 @@ struct platform_driver jz4740_rtc_driver
 	},
 };
 
-static int __init jz4740_rtc_init(void)
-{
-	return platform_driver_register(&jz4740_rtc_driver);
-}
-module_init(jz4740_rtc_init);
-
-static void __exit jz4740_rtc_exit(void)
-{
-	platform_driver_unregister(&jz4740_rtc_driver);
-}
-module_exit(jz4740_rtc_exit);
+module_platform_driver(jz4740_rtc_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_LICENSE("GPL");
diff -puN drivers/rtc/rtc-lpc32xx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-lpc32xx.c
--- a/drivers/rtc/rtc-lpc32xx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-lpc32xx.c
@@ -396,17 +396,7 @@ static struct platform_driver lpc32xx_rt
 	},
 };
 
-static int __init lpc32xx_rtc_init(void)
-{
-	return platform_driver_register(&lpc32xx_rtc_driver);
-}
-module_init(lpc32xx_rtc_init);
-
-static void __exit lpc32xx_rtc_exit(void)
-{
-	platform_driver_unregister(&lpc32xx_rtc_driver);
-}
-module_exit(lpc32xx_rtc_exit);
+module_platform_driver(lpc32xx_rtc_driver);
 
 MODULE_AUTHOR("Kevin Wells <wellsk40@gmail.com");
 MODULE_DESCRIPTION("RTC driver for the LPC32xx SoC");
diff -puN drivers/rtc/rtc-m48t35.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-m48t35.c
--- a/drivers/rtc/rtc-m48t35.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-m48t35.c
@@ -216,21 +216,10 @@ static struct platform_driver m48t35_pla
 	.remove		= __devexit_p(m48t35_remove),
 };
 
-static int __init m48t35_init(void)
-{
-	return platform_driver_register(&m48t35_platform_driver);
-}
-
-static void __exit m48t35_exit(void)
-{
-	platform_driver_unregister(&m48t35_platform_driver);
-}
+module_platform_driver(m48t35_platform_driver);
 
 MODULE_AUTHOR("Thomas Bogendoerfer <tsbogend@alpha.franken.de>");
 MODULE_DESCRIPTION("M48T35 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:rtc-m48t35");
-
-module_init(m48t35_init);
-module_exit(m48t35_exit);
diff -puN drivers/rtc/rtc-m48t59.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-m48t59.c
@@ -530,18 +530,7 @@ static struct platform_driver m48t59_rtc
 	.remove		= __devexit_p(m48t59_rtc_remove),
 };
 
-static int __init m48t59_rtc_init(void)
-{
-	return platform_driver_register(&m48t59_rtc_driver);
-}
-
-static void __exit m48t59_rtc_exit(void)
-{
-	platform_driver_unregister(&m48t59_rtc_driver);
-}
-
-module_init(m48t59_rtc_init);
-module_exit(m48t59_rtc_exit);
+module_platform_driver(m48t59_rtc_driver);
 
 MODULE_AUTHOR("Mark Zhan <rongkai.zhan@windriver.com>");
 MODULE_DESCRIPTION("M48T59/M48T02/M48T08 RTC driver");
diff -puN drivers/rtc/rtc-m48t86.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-m48t86.c
--- a/drivers/rtc/rtc-m48t86.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-m48t86.c
@@ -185,21 +185,10 @@ static struct platform_driver m48t86_rtc
 	.remove		= __devexit_p(m48t86_rtc_remove),
 };
 
-static int __init m48t86_rtc_init(void)
-{
-	return platform_driver_register(&m48t86_rtc_platform_driver);
-}
-
-static void __exit m48t86_rtc_exit(void)
-{
-	platform_driver_unregister(&m48t86_rtc_platform_driver);
-}
+module_platform_driver(m48t86_rtc_platform_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("M48T86 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:rtc-m48t86");
-
-module_init(m48t86_rtc_init);
-module_exit(m48t86_rtc_exit);
diff -puN drivers/rtc/rtc-max8925.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-max8925.c
--- a/drivers/rtc/rtc-max8925.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-max8925.c
@@ -299,17 +299,7 @@ static struct platform_driver max8925_rt
 	.remove		= __devexit_p(max8925_rtc_remove),
 };
 
-static int __init max8925_rtc_init(void)
-{
-	return platform_driver_register(&max8925_rtc_driver);
-}
-module_init(max8925_rtc_init);
-
-static void __exit max8925_rtc_exit(void)
-{
-	platform_driver_unregister(&max8925_rtc_driver);
-}
-module_exit(max8925_rtc_exit);
+module_platform_driver(max8925_rtc_driver);
 
 MODULE_DESCRIPTION("Maxim MAX8925 RTC driver");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff -puN drivers/rtc/rtc-max8998.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-max8998.c
--- a/drivers/rtc/rtc-max8998.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-max8998.c
@@ -327,17 +327,7 @@ static struct platform_driver max8998_rt
 	.id_table	= max8998_rtc_id,
 };
 
-static int __init max8998_rtc_init(void)
-{
-	return platform_driver_register(&max8998_rtc_driver);
-}
-module_init(max8998_rtc_init);
-
-static void __exit max8998_rtc_exit(void)
-{
-	platform_driver_unregister(&max8998_rtc_driver);
-}
-module_exit(max8998_rtc_exit);
+module_platform_driver(max8998_rtc_driver);
 
 MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
diff -puN drivers/rtc/rtc-mpc5121.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -418,17 +418,7 @@ static struct platform_driver mpc5121_rt
 	.remove = __devexit_p(mpc5121_rtc_remove),
 };
 
-static int __init mpc5121_rtc_init(void)
-{
-	return platform_driver_register(&mpc5121_rtc_driver);
-}
-module_init(mpc5121_rtc_init);
-
-static void __exit mpc5121_rtc_exit(void)
-{
-	platform_driver_unregister(&mpc5121_rtc_driver);
-}
-module_exit(mpc5121_rtc_exit);
+module_platform_driver(mpc5121_rtc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("John Rigby <jcrigby@gmail.com>");
diff -puN drivers/rtc/rtc-mrst.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-mrst.c
--- a/drivers/rtc/rtc-mrst.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-mrst.c
@@ -537,18 +537,7 @@ static struct platform_driver vrtc_mrst_
 	}
 };
 
-static int __init vrtc_mrst_init(void)
-{
-	return platform_driver_register(&vrtc_mrst_platform_driver);
-}
-
-static void __exit vrtc_mrst_exit(void)
-{
-	platform_driver_unregister(&vrtc_mrst_platform_driver);
-}
-
-module_init(vrtc_mrst_init);
-module_exit(vrtc_mrst_exit);
+module_platform_driver(vrtc_mrst_platform_driver);
 
 MODULE_AUTHOR("Jacob Pan; Feng Tang");
 MODULE_DESCRIPTION("Driver for Moorestown virtual RTC");
diff -puN drivers/rtc/rtc-pcf50633.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-pcf50633.c
--- a/drivers/rtc/rtc-pcf50633.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-pcf50633.c
@@ -294,17 +294,7 @@ static struct platform_driver pcf50633_r
 	.remove = __devexit_p(pcf50633_rtc_remove),
 };
 
-static int __init pcf50633_rtc_init(void)
-{
-	return platform_driver_register(&pcf50633_rtc_driver);
-}
-module_init(pcf50633_rtc_init);
-
-static void __exit pcf50633_rtc_exit(void)
-{
-	platform_driver_unregister(&pcf50633_rtc_driver);
-}
-module_exit(pcf50633_rtc_exit);
+module_platform_driver(pcf50633_rtc_driver);
 
 MODULE_DESCRIPTION("PCF50633 RTC driver");
 MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
diff -puN drivers/rtc/rtc-pm8xxx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-pm8xxx.c
--- a/drivers/rtc/rtc-pm8xxx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-pm8xxx.c
@@ -532,17 +532,7 @@ static struct platform_driver pm8xxx_rtc
 	},
 };
 
-static int __init pm8xxx_rtc_init(void)
-{
-	return platform_driver_register(&pm8xxx_rtc_driver);
-}
-module_init(pm8xxx_rtc_init);
-
-static void __exit pm8xxx_rtc_exit(void)
-{
-	platform_driver_unregister(&pm8xxx_rtc_driver);
-}
-module_exit(pm8xxx_rtc_exit);
+module_platform_driver(pm8xxx_rtc_driver);
 
 MODULE_ALIAS("platform:rtc-pm8xxx");
 MODULE_DESCRIPTION("PMIC8xxx RTC driver");
diff -puN drivers/rtc/rtc-puv3.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-puv3.c
--- a/drivers/rtc/rtc-puv3.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-puv3.c
@@ -337,21 +337,7 @@ static struct platform_driver puv3_rtcdr
 	}
 };
 
-static char __initdata banner[] = "PKUnity-v3 RTC, (c) 2009 PKUnity Co.\n";
-
-static int __init puv3_rtc_init(void)
-{
-	printk(banner);
-	return platform_driver_register(&puv3_rtcdrv);
-}
-
-static void __exit puv3_rtc_exit(void)
-{
-	platform_driver_unregister(&puv3_rtcdrv);
-}
-
-module_init(puv3_rtc_init);
-module_exit(puv3_rtc_exit);
+module_platform_driver(puv3_rtcdrv);
 
 MODULE_DESCRIPTION("RTC Driver for the PKUnity v3 chip");
 MODULE_AUTHOR("Hu Dongliang");
diff -puN drivers/rtc/rtc-s3c.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-s3c.c
@@ -673,21 +673,7 @@ static struct platform_driver s3c_rtc_dr
 	},
 };
 
-static char __initdata banner[] = "S3C24XX RTC, (c) 2004,2006 Simtec Electronics\n";
-
-static int __init s3c_rtc_init(void)
-{
-	printk(banner);
-	return platform_driver_register(&s3c_rtc_driver);
-}
-
-static void __exit s3c_rtc_exit(void)
-{
-	platform_driver_unregister(&s3c_rtc_driver);
-}
-
-module_init(s3c_rtc_init);
-module_exit(s3c_rtc_exit);
+module_platform_driver(s3c_rtc_driver);
 
 MODULE_DESCRIPTION("Samsung S3C RTC Driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
diff -puN drivers/rtc/rtc-sa1100.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-sa1100.c
@@ -369,18 +369,7 @@ static struct platform_driver sa1100_rtc
 	},
 };
 
-static int __init sa1100_rtc_init(void)
-{
-	return platform_driver_register(&sa1100_rtc_driver);
-}
-
-static void __exit sa1100_rtc_exit(void)
-{
-	platform_driver_unregister(&sa1100_rtc_driver);
-}
-
-module_init(sa1100_rtc_init);
-module_exit(sa1100_rtc_exit);
+module_platform_driver(sa1100_rtc_driver);
 
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("SA11x0/PXA2xx Realtime Clock Driver (RTC)");
diff -puN drivers/rtc/rtc-spear.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-spear.c
--- a/drivers/rtc/rtc-spear.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-spear.c
@@ -516,17 +516,7 @@ static struct platform_driver spear_rtc_
 	},
 };
 
-static int __init rtc_init(void)
-{
-	return platform_driver_register(&spear_rtc_driver);
-}
-module_init(rtc_init);
-
-static void __exit rtc_exit(void)
-{
-	platform_driver_unregister(&spear_rtc_driver);
-}
-module_exit(rtc_exit);
+module_platform_driver(spear_rtc_driver);
 
 MODULE_ALIAS("platform:rtc-spear");
 MODULE_AUTHOR("Rajeev Kumar <rajeev-dlh.kumar@st.com>");
diff -puN drivers/rtc/rtc-stk17ta8.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -370,18 +370,7 @@ static struct platform_driver stk17ta8_r
 	},
 };
 
-static __init int stk17ta8_init(void)
-{
-	return platform_driver_register(&stk17ta8_rtc_driver);
-}
-
-static __exit void stk17ta8_exit(void)
-{
-	platform_driver_unregister(&stk17ta8_rtc_driver);
-}
-
-module_init(stk17ta8_init);
-module_exit(stk17ta8_exit);
+module_platform_driver(stk17ta8_rtc_driver);
 
 MODULE_AUTHOR("Thomas Hommel <thomas.hommel@ge.com>");
 MODULE_DESCRIPTION("Simtek STK17TA8 RTC driver");
diff -puN drivers/rtc/rtc-stmp3xxx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -276,18 +276,7 @@ static struct platform_driver stmp3xxx_r
 	},
 };
 
-static int __init stmp3xxx_rtc_init(void)
-{
-	return platform_driver_register(&stmp3xxx_rtcdrv);
-}
-
-static void __exit stmp3xxx_rtc_exit(void)
-{
-	platform_driver_unregister(&stmp3xxx_rtcdrv);
-}
-
-module_init(stmp3xxx_rtc_init);
-module_exit(stmp3xxx_rtc_exit);
+module_platform_driver(stmp3xxx_rtcdrv);
 
 MODULE_DESCRIPTION("STMP3xxx RTC Driver");
 MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com> and "
diff -puN drivers/rtc/rtc-v3020.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-v3020.c
--- a/drivers/rtc/rtc-v3020.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-v3020.c
@@ -393,18 +393,7 @@ static struct platform_driver rtc_device
 	},
 };
 
-static __init int v3020_init(void)
-{
-	return platform_driver_register(&rtc_device_driver);
-}
-
-static __exit void v3020_exit(void)
-{
-	platform_driver_unregister(&rtc_device_driver);
-}
-
-module_init(v3020_init);
-module_exit(v3020_exit);
+module_platform_driver(rtc_device_driver);
 
 MODULE_DESCRIPTION("V3020 RTC");
 MODULE_AUTHOR("Raphael Assenat");
diff -puN drivers/rtc/rtc-vr41xx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -405,15 +405,4 @@ static struct platform_driver rtc_platfo
 	},
 };
 
-static int __init vr41xx_rtc_init(void)
-{
-	return platform_driver_register(&rtc_platform_driver);
-}
-
-static void __exit vr41xx_rtc_exit(void)
-{
-	platform_driver_unregister(&rtc_platform_driver);
-}
-
-module_init(vr41xx_rtc_init);
-module_exit(vr41xx_rtc_exit);
+module_platform_driver(rtc_platform_driver);
diff -puN drivers/rtc/rtc-vt8500.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-vt8500.c
@@ -311,17 +311,7 @@ static struct platform_driver vt8500_rtc
 	},
 };
 
-static int __init vt8500_rtc_init(void)
-{
-	return platform_driver_register(&vt8500_rtc_driver);
-}
-module_init(vt8500_rtc_init);
-
-static void __exit vt8500_rtc_exit(void)
-{
-	platform_driver_unregister(&vt8500_rtc_driver);
-}
-module_exit(vt8500_rtc_exit);
+module_platform_driver(vt8500_rtc_driver);
 
 MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
 MODULE_DESCRIPTION("VIA VT8500 SoC Realtime Clock Driver (RTC)");
diff -puN drivers/rtc/rtc-wm831x.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-wm831x.c
--- a/drivers/rtc/rtc-wm831x.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-wm831x.c
@@ -468,17 +468,7 @@ static struct platform_driver wm831x_rtc
 	},
 };
 
-static int __init wm831x_rtc_init(void)
-{
-	return platform_driver_register(&wm831x_rtc_driver);
-}
-module_init(wm831x_rtc_init);
-
-static void __exit wm831x_rtc_exit(void)
-{
-	platform_driver_unregister(&wm831x_rtc_driver);
-}
-module_exit(wm831x_rtc_exit);
+module_platform_driver(wm831x_rtc_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("RTC driver for the WM831x series PMICs");
diff -puN drivers/rtc/rtc-wm8350.c~rtc-convert-drivers-rtc-to-use-module_platform_driver drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-convert-drivers-rtc-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-wm8350.c
@@ -486,17 +486,7 @@ static struct platform_driver wm8350_rtc
 	},
 };
 
-static int __init wm8350_rtc_init(void)
-{
-	return platform_driver_register(&wm8350_rtc_driver);
-}
-module_init(wm8350_rtc_init);
-
-static void __exit wm8350_rtc_exit(void)
-{
-	platform_driver_unregister(&wm8350_rtc_driver);
-}
-module_exit(wm8350_rtc_exit);
+module_platform_driver(wm8350_rtc_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("RTC driver for the WM8350");
_
Subject: Subject: rtc: convert drivers/rtc/* to use module_platform_driver()

Patches currently in -mm which might be from axel.lin@gmail.com are

origin.patch
linux-next.patch
backlight-convert-drivers-video-backlight-to-use-module_platform_driver.patch
leds-convert-led-platform-drivers-to-module_platform_driver.patch
leds-convert-led-i2c-drivers-to-module_i2c_driver.patch
leds-convert-leds-dac124s085-to-module_spi_driver.patch
drivers-leds-leds-lp5523c-remove-unneeded-forward-declaration.patch
leds-bd2802-use-gpio_request_one.patch
leds-netxbig-use-gpio_request_one.patch
drivers-leds-leds-mc13783c-fix-off-by-one-for-checking-num_leds.patch
rtc-convert-drivers-rtc-to-use-module_platform_driver.patch

