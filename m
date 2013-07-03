From: akpm@linux-foundation.org
Subject: [folded-merged]
 backlight-convert-from-legacy-pm-ops-to-dev_pm_ops-fix.patch removed from
 -mm tree
Date: Wed, 03 Jul 2013 14:39:29 -0700
Message-ID: <51d49a11.RIjtGLWlHojRWLqk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3GCVja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shuahkhan@gmail.com, arnd@arndb.de, jg1.han@samsung.com

Subject: [folded-merged] backlight-convert-from-legacy-pm-ops-to-dev_pm_ops-fix.patch removed from -mm tree
To: jg1.han@samsung.com,arnd@arndb.de,shuahkhan@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:39:29 -0700


The patch titled
     Subject: backlight: add CONFIG_PM_SLEEP to suspend/resume functions
has been removed from the -mm tree.  Its filename was
     backlight-convert-from-legacy-pm-ops-to-dev_pm_ops-fix.patch

This patch was dropped because it was folded into backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: add CONFIG_PM_SLEEP to suspend/resume functions

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following build
warning when CONFIG_PM_SLEEP is not selected.  This is because sleep PM
callbacks defined by SIMPLE_DEV_PM_OPS are only used when the
CONFIG_PM_SLEEP is enabled.

drivers/video/backlight/backlight.c:211:12: warning: 'backlight_suspend' defined but not used [-Wunused-function]
drivers/video/backlight/backlight.c:225:12: warning: 'backlight_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/backlight.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/backlight.c~backlight-convert-from-legacy-pm-ops-to-dev_pm_ops-fix drivers/video/backlight/backlight.c
--- a/drivers/video/backlight/backlight.c~backlight-convert-from-legacy-pm-ops-to-dev_pm_ops-fix
+++ a/drivers/video/backlight/backlight.c
@@ -208,6 +208,7 @@ static ssize_t backlight_show_actual_bri
 
 static struct class *backlight_class;
 
+#ifdef CONFIG_PM_SLEEP
 static int backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
@@ -235,6 +236,7 @@ static int backlight_resume(struct devic
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
 			 backlight_resume);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
backlight-atmel-pwm-bl-remove-unnecessary-platform_set_drvdata.patch
backlight-ep93xx-remove-unnecessary-platform_set_drvdata.patch
backlight-lp8788-remove-unnecessary-platform_set_drvdata.patch
backlight-pcf50633-remove-unnecessary-platform_set_drvdata.patch
backlight-add-devm_backlight_device_registerunregister.patch
lcd-add-devm_lcd_device_registerunregister.patch
maintainers-add-backlight-subsystem-co-maintainer.patch
backlight-convert-from-legacy-pm-ops-to-dev_pm_ops.patch
rtc-rtc-88pm80x-remove-unnecessary-platform_set_drvdata.patch
drivers-rtc-rtc-v3020c-remove-redundant-goto.patch
drivers-rtc-interfacec-fix-checkpatch-errors.patch
drivers-rtc-rtc-at32ap700xc-fix-checkpatch-error.patch
drivers-rtc-rtc-at91rm9200c-include-linux-uaccessh.patch
drivers-rtc-rtc-cmosc-fix-whitespace-related-errors.patch
drivers-rtc-rtc-davincic-fix-whitespace-warning.patch
drivers-rtc-rtc-ds1305c-add-missing-braces-around-sizeof.patch
drivers-rtc-rtc-ds1374c-fix-spacing-related-issues.patch
drivers-rtc-rtc-ds1511c-fix-issues-related-to-spaces-and-braces.patch
drivers-rtc-rtc-ds3234c-fix-whitespace-issue.patch
drivers-rtc-rtc-fm3130c-fix-whitespace-related-issue.patch
drivers-rtc-rtc-m41t80c-fix-spacing-related-issue.patch
drivers-rtc-rtc-max6902c-remove-unwanted-spaces.patch
drivers-rtc-rtc-max77686c-remove-space-before-semicolon.patch
drivers-rtc-rtc-max8997c-remove-space-before-semicolon.patch
drivers-rtc-rtc-mpc5121c-remove-space-before-tab.patch
drivers-rtc-rtc-msm6242c-use-pr_warn.patch
drivers-rtc-rtc-mxcc-fix-checkpatch-error.patch
drivers-rtc-rtc-omapc-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-pcf2123c-remove-space-before-tabs.patch
drivers-rtc-rtc-pcf8583c-move-assignment-outside-if-condition.patch
drivers-rtc-rtc-rs5c313c-include-linux-ioh-instead-of-asm-ioh.patch
drivers-rtc-rtc-rs5c313c-fix-spacing-related-issues.patch
drivers-rtc-rtc-v3020c-fix-spacing-issues.patch
drivers-rtc-rtc-vr41xxc-fix-spacing-issues.patch
drivers-rtc-rtc-x1205c-fix-checkpatch-issues.patch
rtc-rtc-88pm860x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab3100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ab8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at32ap700x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91rm9200-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-at91sam9-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-au1xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bfin-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-bq4802-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-coh901331-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9052-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-da9055-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-davinci-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-dm355evm-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ds1302-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ep93xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-jz4740-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lp8788-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-lpc32xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-ls1x-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t59-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8925-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-max8998-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mc13xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-msm6242-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-mxc-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-nuc900-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pcap-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-pm8xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-s3c-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sa1100-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-sh-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-spear-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-stmp3xxx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-twl-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vr41xx-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-vt8500-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-m48t86-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-puv3-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-rp5c01-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-tile-remove-unnecessary-platform_set_drvdata.patch
rtc-rtc-hid-sensor-time-allow-full-years-16bit-in-hid-reports.patch
rtc-rtc-hid-sensor-time-allow-16-and-32-bit-values-for-all-attributes.patch
rtc-rtc-ds1307-use-devm_-functions.patch
rtc-rtc-jz4740-use-devm_-functions.patch
rtc-rtc-mpc5121-use-devm_-functions.patch
rtc-rtc-m48t59-use-devm_-functions.patch
rtc-rtc-pm8xxx-use-devm_-functions.patch
rtc-rtc-pxa-use-devm_-functions.patch
rtc-rtc-rx8025-use-devm_-functions.patch
rtc-rtc-sh-use-devm_-functions.patch
rtc-rtc-coh901331-use-platform_getset_drvdata.patch
rtc-rtc-rc5t583-use-platform_getset_drvdata.patch
drivers-rtc-rtc-ds1302c-handle-write-protection.patch
drivers-rtc-rtc-mpc5121c-use-platform_getset_drvdata.patch
drivers-rtc-rtc-cmosc-work-around-bios-clearing-rtc-control.patch
drivers-rtc-rtc-pcf2123c-replace-strict_strtoul-with-kstrtoul.patch
drivers-rtc-class-convert-from-legacy-pm-ops-to-dev_pm_ops.patch
rtc-add-nxp-pcf2127-support-i2c.patch
rtc-add-nxp-pcf2127-support-i2c-fix.patch
rtc-rtc-ds1216-use-module_platform_driver_probe.patch
drivers-rtc-rtc-sirfsocc-add-rtc-drivers-for-csr-sirfprimaii-and-sirfatlasvi.patch

