From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-use-of_match_ptr-macro.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:43:23 -0800
Message-ID: <20130222204323.A622E5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:45263 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470Ab3BVUnY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:43:24 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so119288qah.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:43:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sachin.kamat@linaro.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc: use of_match_ptr() macro
has been removed from the -mm tree.  Its filename was
     drivers-rtc-use-of_match_ptr-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc: use of_match_ptr() macro

This eliminates having an #ifdef returning NULL for the case when OF is
disabled.  Maintains consistency in cases where OF is always selected.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c     |    3 +--
 drivers/rtc/rtc-mpc5121.c  |    5 ++++-
 drivers/rtc/rtc-sa1100.c   |    4 +++-
 drivers/rtc/rtc-snvs.c     |    2 +-
 drivers/rtc/rtc-stmp3xxx.c |    3 ++-
 drivers/rtc/rtc-twl.c      |    6 +++++-
 6 files changed, 16 insertions(+), 7 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-use-of_match_ptr-macro drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-use-of_match_ptr-macro
+++ a/drivers/rtc/rtc-cmos.c
@@ -1098,7 +1098,6 @@ static __init void cmos_of_init(struct p
 }
 #else
 static inline void cmos_of_init(struct platform_device *pdev) {}
-#define of_cmos_match NULL
 #endif
 /*----------------------------------------------------------------*/
 
@@ -1140,7 +1139,7 @@ static struct platform_driver cmos_platf
 #ifdef CONFIG_PM
 		.pm		= &cmos_pm_ops,
 #endif
-		.of_match_table = of_cmos_match,
+		.of_match_table = of_match_ptr(of_cmos_match),
 	}
 };
 
diff -puN drivers/rtc/rtc-mpc5121.c~drivers-rtc-use-of_match_ptr-macro drivers/rtc/rtc-mpc5121.c
--- a/drivers/rtc/rtc-mpc5121.c~drivers-rtc-use-of_match_ptr-macro
+++ a/drivers/rtc/rtc-mpc5121.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
+#include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/of_platform.h>
 #include <linux/io.h>
@@ -403,17 +404,19 @@ static int mpc5121_rtc_remove(struct pla
 	return 0;
 }
 
+#ifdef CONFIG_OF
 static struct of_device_id mpc5121_rtc_match[] = {
 	{ .compatible = "fsl,mpc5121-rtc", },
 	{ .compatible = "fsl,mpc5200-rtc", },
 	{},
 };
+#endif
 
 static struct platform_driver mpc5121_rtc_driver = {
 	.driver = {
 		.name = "mpc5121-rtc",
 		.owner = THIS_MODULE,
-		.of_match_table = mpc5121_rtc_match,
+		.of_match_table = of_match_ptr(mpc5121_rtc_match),
 	},
 	.probe = mpc5121_rtc_probe,
 	.remove = mpc5121_rtc_remove,
diff -puN drivers/rtc/rtc-sa1100.c~drivers-rtc-use-of_match_ptr-macro drivers/rtc/rtc-sa1100.c
--- a/drivers/rtc/rtc-sa1100.c~drivers-rtc-use-of_match_ptr-macro
+++ a/drivers/rtc/rtc-sa1100.c
@@ -349,12 +349,14 @@ static const struct dev_pm_ops sa1100_rt
 };
 #endif
 
+#ifdef CONFIG_OF
 static struct of_device_id sa1100_rtc_dt_ids[] = {
 	{ .compatible = "mrvl,sa1100-rtc", },
 	{ .compatible = "mrvl,mmp-rtc", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, sa1100_rtc_dt_ids);
+#endif
 
 static struct platform_driver sa1100_rtc_driver = {
 	.probe		= sa1100_rtc_probe,
@@ -364,7 +366,7 @@ static struct platform_driver sa1100_rtc
 #ifdef CONFIG_PM
 		.pm	= &sa1100_rtc_pm_ops,
 #endif
-		.of_match_table = sa1100_rtc_dt_ids,
+		.of_match_table = of_match_ptr(sa1100_rtc_dt_ids),
 	},
 };
 
diff -puN drivers/rtc/rtc-snvs.c~drivers-rtc-use-of_match_ptr-macro drivers/rtc/rtc-snvs.c
--- a/drivers/rtc/rtc-snvs.c~drivers-rtc-use-of_match_ptr-macro
+++ a/drivers/rtc/rtc-snvs.c
@@ -338,7 +338,7 @@ static struct platform_driver snvs_rtc_d
 		.name	= "snvs_rtc",
 		.owner	= THIS_MODULE,
 		.pm	= &snvs_rtc_pm_ops,
-		.of_match_table = snvs_dt_ids,
+		.of_match_table = of_match_ptr(snvs_dt_ids),
 	},
 	.probe		= snvs_rtc_probe,
 	.remove		= snvs_rtc_remove,
diff -puN drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-use-of_match_ptr-macro drivers/rtc/rtc-stmp3xxx.c
--- a/drivers/rtc/rtc-stmp3xxx.c~drivers-rtc-use-of_match_ptr-macro
+++ a/drivers/rtc/rtc-stmp3xxx.c
@@ -26,6 +26,7 @@
 #include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/of_device.h>
+#include <linux/of.h>
 
 #include <mach/common.h>
 
@@ -280,7 +281,7 @@ static struct platform_driver stmp3xxx_r
 	.driver		= {
 		.name	= "stmp3xxx-rtc",
 		.owner	= THIS_MODULE,
-		.of_match_table = rtc_dt_ids,
+		.of_match_table = of_match_ptr(rtc_dt_ids),
 	},
 };
 
diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-use-of_match_ptr-macro drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-use-of_match_ptr-macro
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
linux-next.patch

