From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch added to -mm tree
Date: Tue, 24 Sep 2013 16:55:14 -0700
Message-ID: <52422662.RM4EkQqCtmf4xcua%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab3IXXzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Sep 2013 19:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Tue, 24 Sep 2013 16:55:14 -0700


The patch titled
     Subject: drivers/rtc/rtc-m48t59.c: use dev_get_platdata()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch

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
Subject: drivers/rtc/rtc-m48t59.c: use dev_get_platdata()

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly.  This is a cosmetic change to make
the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~drivers-rtc-rtc-m48t59c-use-dev_get_platdata drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~drivers-rtc-rtc-m48t59c-use-dev_get_platdata
+++ a/drivers/rtc/rtc-m48t59.c
@@ -68,7 +68,7 @@ m48t59_mem_readb(struct device *dev, u32
 static int m48t59_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val;
@@ -111,7 +111,7 @@ static int m48t59_rtc_read_time(struct d
 static int m48t59_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val = 0;
@@ -158,7 +158,7 @@ static int m48t59_rtc_set_time(struct de
 static int m48t59_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	unsigned long flags;
@@ -205,7 +205,7 @@ static int m48t59_rtc_readalarm(struct d
 static int m48t59_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	struct rtc_time *tm = &alrm->time;
 	u8 mday, hour, min, sec;
@@ -266,7 +266,7 @@ static int m48t59_rtc_setalarm(struct de
 static int m48t59_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 
@@ -283,7 +283,7 @@ static int m48t59_rtc_alarm_irq_enable(s
 static int m48t59_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	unsigned long flags;
 	u8 val;
@@ -304,7 +304,7 @@ static irqreturn_t m48t59_rtc_interrupt(
 {
 	struct device *dev = (struct device *)dev_id;
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	u8 event;
 
@@ -340,7 +340,7 @@ static ssize_t m48t59_nvram_read(struct
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	ssize_t cnt = 0;
 	unsigned long flags;
@@ -360,7 +360,7 @@ static ssize_t m48t59_nvram_write(struct
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
 	ssize_t cnt = 0;
 	unsigned long flags;
@@ -385,7 +385,7 @@ static struct bin_attribute m48t59_nvram
 
 static int m48t59_rtc_probe(struct platform_device *pdev)
 {
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
+	struct m48t59_plat_data *pdata = dev_get_platdata(&pdev->dev);
 	struct m48t59_private *m48t59 = NULL;
 	struct resource *res;
 	int ret = -ENOMEM;
_

Patches currently in -mm which might be from jg1.han@samsung.com are

drivers-iommu-omap-iopgtableh-remove-unneeded-cast-of-void.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
backlight-88pm860x_bl-use-devm_backlight_device_register.patch
backlight-aat2870-use-devm_backlight_device_register.patch
backlight-adp5520-use-devm_backlight_device_register.patch
backlight-adp8860-use-devm_backlight_device_register.patch
backlight-adp8870-use-devm_backlight_device_register.patch
backlight-as3711_bl-use-devm_backlight_device_register.patch
backlight-atmel-pwm-bl-use-devm_backlight_device_register.patch
backlight-bd6107-use-devm_backlight_device_register.patch
backlight-da903x_bl-use-devm_backlight_device_register.patch
backlight-da9052_bl-use-devm_backlight_device_register.patch
backlight-ep93xx-use-devm_backlight_device_register.patch
backlight-generic_bl-use-devm_backlight_device_register.patch
backlight-gpio_backlight-use-devm_backlight_device_register.patch
backlight-kb3886_bl-use-devm_backlight_device_register.patch
backlight-lm3533_bl-use-devm_backlight_device_register.patch
backlight-lp855x-use-devm_backlight_device_register.patch
backlight-lv5207lp-use-devm_backlight_device_register.patch
backlight-max8925_bl-use-devm_backlight_device_register.patch
backlight-pandora_bl-use-devm_backlight_device_register.patch
backlight-pcf50633-use-devm_backlight_device_register.patch
backlight-tps65217_bl-use-devm_backlight_device_register.patch
backlight-wm831x_bl-use-devm_backlight_device_register.patch
backlight-hx8357-use-devm_lcd_device_register.patch
backlight-ili922x-use-devm_lcd_device_register.patch
backlight-ili9320-use-devm_lcd_device_register.patch
backlight-lms283gf05-use-devm_lcd_device_register.patch
backlight-lms501kf03-use-devm_lcd_device_register.patch
backlight-ltv350qv-use-devm_lcd_device_register.patch
backlight-platform_lcd-use-devm_lcd_device_register.patch
backlight-tdo24m-use-devm_lcd_device_register.patch
backlight-ams369fg06-use-devm_backlightlcd_device_register.patch
backlight-ld9040-use-devm_backlightlcd_device_register.patch
backlight-corgi_lcd-use-devm_backlightlcd_device_register.patch
backlight-cr_bllcd-use-devm_backlightlcd_device_register.patch
backlight-s6e63m0-use-devm_backlightlcd_device_register.patch
drivers-rtc-rtc-ds1307c-release-irq-on-error.patch
drivers-rtc-rtc-isl1208c-remove-redundant-checks.patch
drivers-rtc-rtc-max6900c-remove-redundant-checks.patch
drivers-rtc-rtc-vt8500c-fix-return-value.patch
drivers-rtc-rtc-at91rm9200c-use-devm_-apis.patch
drivers-rtc-rtc-isl1208c-use-devm_-apis.patch
drivers-rtc-rtc-sirfsocc-use-devm_rtc_device_register.patch
drivers-rtc-rtc-cmosc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-mrstc-remove-redundant-dev_set_drvdata.patch
drivers-rtc-rtc-vr41xxc-fix-checkpatch-warnings.patch
drivers-rtc-rtc-sirfsocc-remove-unneeded-casts-of-void.patch
drivers-rtc-rtc-88pm80xc-use-dev_get_platdata.patch
drivers-rtc-rtc-88pm860xc-use-dev_get_platdata.patch
drivers-rtc-rtc-cmosc-use-dev_get_platdata.patch
drivers-rtc-rtc-da9055c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1305c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds1307c-use-dev_get_platdata.patch
drivers-rtc-rtc-ds2404c-use-dev_get_platdata.patch
drivers-rtc-rtc-ep93xxc-use-dev_get_platdata.patch
drivers-rtc-rtc-hid-sensor-timec-use-dev_get_platdata.patch
drivers-rtc-rtc-m48t59c-use-dev_get_platdata.patch
drivers-rtc-rtc-m48t86c-use-dev_get_platdata.patch
drivers-rtc-rtc-pcf2123c-use-dev_get_platdata.patch
drivers-rtc-rtc-rs5c348c-use-dev_get_platdata.patch
drivers-rtc-rtc-shc-use-dev_get_platdata.patch
drivers-rtc-rtc-v3020c-use-dev_get_platdata.patch
drivers-char-xilinx_hwicap-xilinx_hwicapc-remove-unneeded-cast-of-void.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch
linux-next.patch

