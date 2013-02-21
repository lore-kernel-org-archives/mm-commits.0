From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-rtc-use-of_match_ptr-macro-fix.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:28:34 -0800
Message-ID: <20130221232834.D925731C016@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:49641 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab3BUX2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:28:36 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so11308vch.2
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:28:35 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-twl: use of_match_ptr() macro
has been removed from the -mm tree.  Its filename was
     drivers-rtc-use-of_match_ptr-macro-fix.patch

This patch was dropped because it was folded into drivers-rtc-use-of_match_ptr-macro.patch

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc/rtc-twl: use of_match_ptr() macro

Used of_match_ptr() macro with CONFIG_OF defined.
This maintains code consistency with the rest of the drivers.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-use-of_match_ptr-macro-fix drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-use-of_match_ptr-macro-fix
+++ a/drivers/rtc/rtc-twl.c
@@ -27,6 +27,7 @@
 #include <linux/bcd.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
+#include <linux/of.h>
 
 #include <linux/i2c/twl.h>
 
@@ -588,11 +589,14 @@ static int twl_rtc_resume(struct platfor
 #define twl_rtc_resume  NULL
 #endif
 
+#ifdef CONFIG_OF
 static const struct of_device_id twl_rtc_of_match[] = {
 	{.compatible = "ti,twl4030-rtc", },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, twl_rtc_of_match);
+#endif
+
 MODULE_ALIAS("platform:twl_rtc");
 
 static struct platform_driver twl4030rtc_driver = {
@@ -604,7 +608,7 @@ static struct platform_driver twl4030rtc
 	.driver		= {
 		.owner		= THIS_MODULE,
 		.name		= "twl_rtc",
-		.of_match_table = twl_rtc_of_match,
+		.of_match_table = of_match_ptr(twl_rtc_of_match),
 	},
 };
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
drivers-video-exynos-s6e8ax0c-use-devm_-apis-in-s6e8ax0c.patch
drivers-video-exynos-exynos_mipi_dsic-fix-an-error-check-condition.patch
drivers-video-exynos-exynos_mipi_dsic-use-devm_-apis.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-video-backlight-ld9040c-use-devm_regulator_bulk_get-api.patch
drivers-rtc-use-of_match_ptr-macro.patch

