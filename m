From: akpm@linux-foundation.org
Subject: + video-exynos_dp-add-missing-of_node_put.patch added to -mm tree
Date: Tue, 19 Feb 2013 14:41:24 -0800
Message-ID: <20130219224125.29EC45A43B8@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64265 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933211Ab3BSWl0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 17:41:26 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so444315ggi.3
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 14:41:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com, FlorianSchandinat@gmx.de, ajaykumar.rs@samsung.com


The patch titled
     Subject: video: exynos_dp: add missing of_node_put()
has been added to the -mm tree.  Its filename is
     video-exynos_dp-add-missing-of_node_put.patch

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
Subject: video: exynos_dp: add missing of_node_put()

of_find_node_by_name() returns a node pointer with refcount incremented,
use of_node_put() on it when done.

of_find_node_by_name() will call of_node_put() against the node pass to
from parameter, thus we also need to call of_node_get(from) before calling
of_find_node_by_name().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Ajay Kumar <ajaykumar.rs@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/exynos/exynos_dp_core.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff -puN drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-add-missing-of_node_put drivers/video/exynos/exynos_dp_core.c
--- a/drivers/video/exynos/exynos_dp_core.c~video-exynos_dp-add-missing-of_node_put
+++ a/drivers/video/exynos/exynos_dp_core.c
@@ -965,10 +965,11 @@ static struct exynos_dp_platdata *exynos
 
 static int exynos_dp_dt_parse_phydata(struct exynos_dp_device *dp)
 {
-	struct device_node *dp_phy_node;
+	struct device_node *dp_phy_node = of_node_get(dp->dev->of_node);
 	u32 phy_base;
+	int ret = 0;
 
-	dp_phy_node = of_find_node_by_name(dp->dev->of_node, "dptx-phy");
+	dp_phy_node = of_find_node_by_name(dp_phy_node, "dptx-phy");
 	if (!dp_phy_node) {
 		dev_err(dp->dev, "could not find dptx-phy node\n");
 		return -ENODEV;
@@ -976,22 +977,28 @@ static int exynos_dp_dt_parse_phydata(st
 
 	if (of_property_read_u32(dp_phy_node, "reg", &phy_base)) {
 		dev_err(dp->dev, "faild to get reg for dptx-phy\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	if (of_property_read_u32(dp_phy_node, "samsung,enable-mask",
 				&dp->enable_mask)) {
 		dev_err(dp->dev, "faild to get enable-mask for dptx-phy\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
 
 	dp->phy_addr = ioremap(phy_base, SZ_4);
 	if (!dp->phy_addr) {
 		dev_err(dp->dev, "failed to ioremap dp-phy\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err;
 	}
 
-	return 0;
+err:
+	of_node_put(dp_phy_node);
+
+	return ret;
 }
 
 static void exynos_dp_phy_init(struct exynos_dp_device *dp)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
video-s3c-fb-use-arch_-dependancy.patch
video-s3c-fb-remove-duplicated-s3c_fb_max_win.patch
video-s3c-fb-remove-unnecessary-brackets.patch
video-s3c-fb-add-the-bit-definitions-for-csc-eq709-and-eq601.patch
video-s3c-fb-fix-typo-in-definition-of-vidcon1_vstatus_frontporch-value.patch
video-exynos_dp-add-missing-of_node_put.patch
video-exynos_dp-move-disable_irq-to-exynos_dp_suspend.patch
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

