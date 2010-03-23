From: akpm@linux-foundation.org
Subject: + s3c-rtc-driver-add-support-for-s3c64xx.patch added to -mm tree
Date: Mon, 22 Mar 2010 23:27:07 -0400
Message-ID: <201003230627.o2N6Rwk3018250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753720Ab0CWG2a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 02:28:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mcuelenaere@gmail.com, a.zummo@towertech.it, ben-linux@fluff.org, elendil@planet.nl, p_gortmaker@yahoo.com


The patch titled
     s3c rtc driver: add support for S3C64xx
has been added to the -mm tree.  Its filename is
     s3c-rtc-driver-add-support-for-s3c64xx.patch

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
Subject: s3c rtc driver: add support for S3C64xx
From: Maurus Cuelenaere <mcuelenaere@gmail.com>

Add support for the S3C64xx SoC to the generic S3C RTC driver.

Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Cc: Frans Pop <elendil@planet.nl>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/plat-samsung/include/plat/regs-rtc.h |    4 
 drivers/rtc/Kconfig                           |    2 
 drivers/rtc/rtc-s3c.c                         |  107 +++++++++++++---
 3 files changed, 92 insertions(+), 21 deletions(-)

diff -puN arch/arm/plat-samsung/include/plat/regs-rtc.h~s3c-rtc-driver-add-support-for-s3c64xx arch/arm/plat-samsung/include/plat/regs-rtc.h
--- a/arch/arm/plat-samsung/include/plat/regs-rtc.h~s3c-rtc-driver-add-support-for-s3c64xx
+++ a/arch/arm/plat-samsung/include/plat/regs-rtc.h
@@ -20,6 +20,10 @@
 #define S3C2410_RTCCON_CLKSEL (1<<1)
 #define S3C2410_RTCCON_CNTSEL (1<<2)
 #define S3C2410_RTCCON_CLKRST (1<<3)
+#define S3C64XX_RTCCON_TICEN  (1<<8)
+
+#define S3C64XX_RTCCON_TICMSK (0xF<<7)
+#define S3C64XX_RTCCON_TICSHT (7)
 
 #define S3C2410_TICNT	      S3C2410_RTCREG(0x44)
 #define S3C2410_TICNT_ENABLE  (1<<7)
diff -puN drivers/rtc/Kconfig~s3c-rtc-driver-add-support-for-s3c64xx drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~s3c-rtc-driver-add-support-for-s3c64xx
+++ a/drivers/rtc/Kconfig
@@ -640,7 +640,7 @@ config RTC_DRV_OMAP
 
 config RTC_DRV_S3C
 	tristate "Samsung S3C series SoC RTC"
-	depends on ARCH_S3C2410
+	depends on ARCH_S3C2410 || ARCH_S3C64XX
 	help
 	  RTC (Realtime Clock) driver for the clock inbuilt into the
 	  Samsung S3C24XX series of SoCs. This can provide periodic
diff -puN drivers/rtc/rtc-s3c.c~s3c-rtc-driver-add-support-for-s3c64xx drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~s3c-rtc-driver-add-support-for-s3c64xx
+++ a/drivers/rtc/rtc-s3c.c
@@ -28,6 +28,11 @@
 #include <asm/irq.h>
 #include <plat/regs-rtc.h>
 
+enum s3c_cpu_type {
+	TYPE_S3C2410,
+	TYPE_S3C64XX,
+};
+
 /* I have yet to find an S3C implementation with more than one
  * of these rtc blocks in */
 
@@ -36,6 +41,7 @@ static struct resource *s3c_rtc_mem;
 static void __iomem *s3c_rtc_base;
 static int s3c_rtc_alarmno = NO_IRQ;
 static int s3c_rtc_tickno  = NO_IRQ;
+static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
 
@@ -79,12 +85,25 @@ static int s3c_rtc_setpie(struct device 
 	pr_debug("%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&s3c_rtc_pie_lock);
-	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & ~S3C2410_TICNT_ENABLE;
 
-	if (enabled)
-		tmp |= S3C2410_TICNT_ENABLE;
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
+		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
+		tmp &= ~S3C64XX_RTCCON_TICEN;
+
+		if (enabled)
+			tmp |= S3C64XX_RTCCON_TICEN;
+
+		writeb(tmp, s3c_rtc_base + S3C2410_RTCCON);
+	} else {
+		tmp = readb(s3c_rtc_base + S3C2410_TICNT);
+		tmp &= ~S3C2410_TICNT_ENABLE;
+
+		if (enabled)
+			tmp |= S3C2410_TICNT_ENABLE;
+
+		writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
+	}
 
-	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
 
 	return 0;
@@ -92,15 +111,21 @@ static int s3c_rtc_setpie(struct device 
 
 static int s3c_rtc_setfreq(struct device *dev, int freq)
 {
-	unsigned int tmp;
+	struct platform_device *pdev = to_platform_device(dev);
+	struct rtc_device *rtc_dev = platform_get_drvdata(pdev);
+	unsigned int tmp = 0;
 
 	if (!is_power_of_2(freq))
 		return -EINVAL;
 
 	spin_lock_irq(&s3c_rtc_pie_lock);
 
-	tmp = readb(s3c_rtc_base + S3C2410_TICNT) & S3C2410_TICNT_ENABLE;
-	tmp |= (128 / freq)-1;
+	if (s3c_rtc_cpu_type == TYPE_S3C2410) {
+		tmp = readb(s3c_rtc_base + S3C2410_TICNT);
+		tmp &= S3C2410_TICNT_ENABLE;
+	}
+
+	tmp |= (rtc_dev->max_user_freq / freq)-1;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
@@ -282,10 +307,17 @@ static int s3c_rtc_setalarm(struct devic
 
 static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
-	unsigned int ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
+	unsigned int ticnt;
 
-	seq_printf(seq, "periodic_IRQ\t: %s\n",
-		     (ticnt & S3C2410_TICNT_ENABLE) ? "yes" : "no" );
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
+		ticnt = readb(s3c_rtc_base + S3C2410_RTCCON);
+		ticnt &= S3C64XX_RTCCON_TICEN;
+	} else {
+		ticnt = readb(s3c_rtc_base + S3C2410_TICNT);
+		ticnt &= S3C2410_TICNT_ENABLE;
+	}
+
+	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
 	return 0;
 }
 
@@ -352,10 +384,16 @@ static void s3c_rtc_enable(struct platfo
 
 	if (!en) {
 		tmp = readb(base + S3C2410_RTCCON);
-		writeb(tmp & ~S3C2410_RTCCON_RTCEN, base + S3C2410_RTCCON);
-
-		tmp = readb(base + S3C2410_TICNT);
-		writeb(tmp & ~S3C2410_TICNT_ENABLE, base + S3C2410_TICNT);
+		if (s3c_rtc_cpu_type == TYPE_S3C64XX)
+			tmp &= ~S3C64XX_RTCCON_TICEN;
+		tmp &= ~S3C2410_RTCCON_RTCEN;
+		writeb(tmp, base + S3C2410_RTCCON);
+
+		if (s3c_rtc_cpu_type == TYPE_S3C2410) {
+			tmp = readb(base + S3C2410_TICNT);
+			tmp &= ~S3C2410_TICNT_ENABLE;
+			writeb(tmp, base + S3C2410_TICNT);
+		}
 	} else {
 		/* re-enable the device, and check it is ok */
 
@@ -471,7 +509,12 @@ static int __devinit s3c_rtc_probe(struc
 		goto err_nortc;
 	}
 
-	rtc->max_user_freq = 128;
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
+		rtc->max_user_freq = 32768;
+	else
+		rtc->max_user_freq = 128;
+
+	s3c_rtc_cpu_type = platform_get_device_id(pdev)->driver_data;
 
 	platform_set_drvdata(pdev, rtc);
 	return 0;
@@ -491,20 +534,30 @@ static int __devinit s3c_rtc_probe(struc
 
 /* RTC Power management control */
 
-static int ticnt_save;
+static int ticnt_save, ticnt_en_save;
 
 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
+		ticnt_en_save = readb(s3c_rtc_base + S3C2410_RTCCON);
+		ticnt_en_save &= S3C64XX_RTCCON_TICEN;
+	}
 	s3c_rtc_enable(pdev, 0);
 	return 0;
 }
 
 static int s3c_rtc_resume(struct platform_device *pdev)
 {
+	unsigned int tmp;
+
 	s3c_rtc_enable(pdev, 1);
 	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
+	if (s3c_rtc_cpu_type == TYPE_S3C64XX && ticnt_en_save) {
+		tmp = readb(s3c_rtc_base + S3C2410_RTCCON);
+		writeb(tmp | ticnt_en_save, s3c_rtc_base + S3C2410_RTCCON);
+	}
 	return 0;
 }
 #else
@@ -512,13 +565,27 @@ static int s3c_rtc_resume(struct platfor
 #define s3c_rtc_resume  NULL
 #endif
 
-static struct platform_driver s3c2410_rtc_driver = {
+static struct platform_device_id s3c_rtc_driver_ids[] = {
+	{
+		.name		= "s3c2410-rtc",
+		.driver_data	= TYPE_S3C2410,
+	}, {
+		.name		= "s3c64xx-rtc",
+		.driver_data	= TYPE_S3C64XX,
+	},
+	{ }
+};
+
+MODULE_DEVICE_TABLE(platform, s3c_rtc_driver_ids);
+
+static struct platform_driver s3c_rtc_driver = {
 	.probe		= s3c_rtc_probe,
 	.remove		= __devexit_p(s3c_rtc_remove),
 	.suspend	= s3c_rtc_suspend,
 	.resume		= s3c_rtc_resume,
+	.id_table	= s3c_rtc_driver_ids,
 	.driver		= {
-		.name	= "s3c2410-rtc",
+		.name	= "s3c-rtc",
 		.owner	= THIS_MODULE,
 	},
 };
@@ -528,12 +595,12 @@ static char __initdata banner[] = "S3C24
 static int __init s3c_rtc_init(void)
 {
 	printk(banner);
-	return platform_driver_register(&s3c2410_rtc_driver);
+	return platform_driver_register(&s3c_rtc_driver);
 }
 
 static void __exit s3c_rtc_exit(void)
 {
-	platform_driver_unregister(&s3c2410_rtc_driver);
+	platform_driver_unregister(&s3c_rtc_driver);
 }
 
 module_init(s3c_rtc_init);
_

Patches currently in -mm which might be from mcuelenaere@gmail.com are

linux-next.patch
s3c-rtc-driver-add-support-for-s3c64xx.patch

