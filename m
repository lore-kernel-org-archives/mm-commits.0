From: akpm@linux-foundation.org
Subject: + rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:18:51 -0800
Message-ID: <20130215231852.2F9E35A4233@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:53027 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3BOXSx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:18:53 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so115437ghb.4
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:18:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: rtc: rtc-at91rm9200: use dev_dbg()/dev_err() instead of printk()/pr_debug()
has been added to the -mm tree.  Its filename is
     rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug.patch

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
Subject: rtc: rtc-at91rm9200: use dev_dbg()/dev_err() instead of printk()/pr_debug()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -86,7 +86,7 @@ static int at91_rtc_readtime(struct devi
 	tm->tm_yday = rtc_year_days(tm->tm_mday, tm->tm_mon, tm->tm_year);
 	tm->tm_year = tm->tm_year - 1900;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -100,7 +100,7 @@ static int at91_rtc_settime(struct devic
 {
 	unsigned long cr;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -145,7 +145,7 @@ static int at91_rtc_readalarm(struct dev
 	alrm->enabled = (at91_rtc_read(AT91_RTC_IMR) & AT91_RTC_ALARM)
 			? 1 : 0;
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -183,7 +183,7 @@ static int at91_rtc_setalarm(struct devi
 		at91_rtc_write(AT91_RTC_IER, AT91_RTC_ALARM);
 	}
 
-	pr_debug("%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
+	dev_dbg(dev, "%s(): %4d-%02d-%02d %02d:%02d:%02d\n", __func__,
 		at91_alarm_year, tm.tm_mon, tm.tm_mday, tm.tm_hour,
 		tm.tm_min, tm.tm_sec);
 
@@ -192,7 +192,7 @@ static int at91_rtc_setalarm(struct devi
 
 static int at91_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
-	pr_debug("%s(): cmd=%08x\n", __func__, enabled);
+	dev_dbg(dev, "%s(): cmd=%08x\n", __func__, enabled);
 
 	if (enabled) {
 		at91_rtc_write(AT91_RTC_SCCR, AT91_RTC_ALARM);
@@ -240,7 +240,7 @@ static irqreturn_t at91_rtc_interrupt(in
 
 		rtc_update_irq(rtc, 1, events);
 
-		pr_debug("%s(): num=%ld, events=0x%02lx\n", __func__,
+		dev_dbg(&pdev->dev, "%s(): num=%ld, events=0x%02lx\n", __func__,
 			events >> 8, events & 0x000000FF);
 
 		return IRQ_HANDLED;
@@ -296,8 +296,7 @@ static int __init at91_rtc_probe(struct 
 				IRQF_SHARED,
 				"at91_rtc", pdev);
 	if (ret) {
-		printk(KERN_ERR "at91_rtc: IRQ %d already in use.\n",
-				irq);
+		dev_err(&pdev->dev, "IRQ %d already in use.\n", irq);
 		return ret;
 	}
 
@@ -315,7 +314,7 @@ static int __init at91_rtc_probe(struct 
 	}
 	platform_set_drvdata(pdev, rtc);
 
-	printk(KERN_INFO "AT91 Real Time Clock driver.\n");
+	dev_info(&pdev->dev, "AT91 Real Time Clock driver.\n");
 	return 0;
 }
 
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
fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch
drivers-video-backlight-makefile-cleanup.patch
backlight-add-an-as3711-pmic-backlight-driver.patch
backlight-88pm860x_bl-add-missing-of_node_put.patch
backlight-s6e63m0-report-gamma_table_count-correctly.patch
drivers-video-backlight-lm3630_blc-remove-ret-=-eio-of-lm3630_backlight_register.patch
rtc-max77686-add-missing-variable-initialization.patch
rtc-max77686-add-missing-variable-initialization-fix.patch
drivers-rtc-rtc-s3cc-use-dev_dbg-instaed-of-pr_debug.patch
rtc-use-dev_warn-dev_dbg-pr_err-instead-of-printk.patch
rtc-max77686-use-dev_info-instead-of-printk.patch
rtc-rtc-efi-use-dev_err-dev_warn-pr_err-instead-of-printk.patch
rtc-rtc-ds2404-use-dev_err-instead-of-printk.patch
rtc-rtc-rs5c372-use-dev_dbg-dev_warn-instead-of-printk-pr_debug.patch
rtc-rtc-at91rm9200-use-dev_dbg-dev_err-instead-of-printk-pr_debug.patch
rtc-rtc-rs5c313-use-pr_err-instead-of-printk.patch
rtc-rtc-vr41xx-use-dev_info-instead-of-printk.patch
rtc-rtc-sun4v-use-pr_warn-instead-of-printk.patch
rtc-rtc-pcf8583-use-dev_warn-instead-of-printk.patch
rtc-rtc-cmos-use-dev_warn-dev_dbg-instead-of-printk-pr_debug.patch

