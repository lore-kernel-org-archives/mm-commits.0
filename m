From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug.patch added to -mm tree
Date: Tue, 29 Jan 2013 16:28:57 -0800
Message-ID: <20130130002857.91DC131C201@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:56918 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3A3A26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jan 2013 19:28:58 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so103635ggi.1
        for <mm-commits@vger.kernel.org>; Tue, 29 Jan 2013 16:28:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: use dev_dbg() instaed of pr_debug()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug.patch

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
Subject: drivers/rtc/rtc-s3c.c: use dev_dbg() instaed of pr_debug()

Use dev_dbg() instaed of pr_debug() to be consistent.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-use-dev_dbg-instaed-of-pr_debug drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-use-dev_dbg-instaed-of-pr_debug
+++ a/drivers/rtc/rtc-s3c.c
@@ -115,7 +115,7 @@ static int s3c_rtc_setaie(struct device 
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __func__, enabled);
+	dev_dbg(dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(rtc_clk);
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
@@ -203,7 +203,7 @@ static int s3c_rtc_gettime(struct device
 
 	rtc_tm->tm_year += 100;
 
-	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "read time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
 		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
 
@@ -218,7 +218,7 @@ static int s3c_rtc_settime(struct device
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -259,7 +259,7 @@ static int s3c_rtc_getalarm(struct devic
 
 	alrm->enabled = (alm_en & S3C2410_RTCALM_ALMEN) ? 1 : 0;
 
-	pr_debug("read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alm_en,
 		 1900 + alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
 		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
@@ -310,7 +310,7 @@ static int s3c_rtc_setalarm(struct devic
 	unsigned int alrm_en;
 
 	clk_enable(rtc_clk);
-	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -333,7 +333,7 @@ static int s3c_rtc_setalarm(struct devic
 		writeb(bin2bcd(tm->tm_hour), base + S3C2410_ALMHOUR);
 	}
 
-	pr_debug("setting S3C2410_RTCALM to %08x\n", alrm_en);
+	dev_dbg(dev, "setting S3C2410_RTCALM to %08x\n", alrm_en);
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
@@ -459,7 +459,7 @@ static int s3c_rtc_probe(struct platform
 	int ret;
 	int tmp;
 
-	pr_debug("%s: probe=%p\n", __func__, pdev);
+	dev_dbg(&pdev->dev, "%s: probe=%p\n", __func__, pdev);
 
 	/* find the IRQs */
 
@@ -475,7 +475,7 @@ static int s3c_rtc_probe(struct platform
 		return s3c_rtc_alarmno;
 	}
 
-	pr_debug("s3c2410_rtc: tick irq %d, alarm irq %d\n",
+	dev_dbg(&pdev->dev, "s3c2410_rtc: tick irq %d, alarm irq %d\n",
 		 s3c_rtc_tickno, s3c_rtc_alarmno);
 
 	/* get the memory region */
@@ -504,7 +504,7 @@ static int s3c_rtc_probe(struct platform
 
 	s3c_rtc_enable(pdev, 1);
 
-	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
+	dev_dbg(&pdev->dev, "s3c2410_rtc: RTCCON=%02x\n",
 		 readw(s3c_rtc_base + S3C2410_RTCCON));
 
 	device_init_wakeup(&pdev->dev, 1);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-add-lms501kf03-lcd-driver.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
backlight-add-lms501kf03-lcd-driver-fix-fix.patch
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
backlight-lm3649_backlight-remove-ret-=-eio-at-error-paths-of-probe.patch
drivers-video-backlight-l4f00242t03c-convert-to-devm_regulator_get.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch
drivers-video-backlight-makefile-cleanup.patch
backlight-add-an-as3711-pmic-backlight-driver.patch
backlight-88pm860x_bl-add-missing-of_node_put.patch
drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug.patch

