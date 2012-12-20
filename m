From: akpm@linux-foundation.org
Subject: + drivers-rtc-use-of_match_ptr-macro.patch added to -mm tree
Date: Thu, 20 Dec 2012 12:21:40 -0800
Message-ID: <20121220202140.9045E100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44780 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2LTUVl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 15:21:41 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so404998vcd.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 12:21:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sachin.kamat@linaro.org, a.zummo@towertech.it


The patch titled
     Subject: drivers/rtc: use of_match_ptr() macro
has been added to the -mm tree.  Its filename is
     drivers-rtc-use-of_match_ptr-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: drivers/rtc: use of_match_ptr() macro

This eliminates having an #ifdef returning NULL for the case when OF is
disabled.  Maintains consistency in cases where OF is always selected.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mpc5121.c  |    5 ++++-
 drivers/rtc/rtc-sa1100.c   |    4 +++-
 drivers/rtc/rtc-snvs.c     |    2 +-
 drivers/rtc/rtc-stmp3xxx.c |    3 ++-
 4 files changed, 10 insertions(+), 4 deletions(-)

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
@@ -403,17 +404,19 @@ static int __devexit mpc5121_rtc_remove(
 	return 0;
 }
 
+#ifdef CONFIG_OF
 static struct of_device_id mpc5121_rtc_match[] __devinitdata = {
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
 	.remove = __devexit_p(mpc5121_rtc_remove),
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
 	.remove		= __devexit_p(snvs_rtc_remove),
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
 
_

Patches currently in -mm which might be from sachin.kamat@linaro.org are

origin.patch
linux-next.patch
backlight-add-lms501kf03-lcd-driver.patch
drivers-rtc-use-of_match_ptr-macro.patch
drivers-rtc-rtc-cmosc-use-of_match_ptr.patch

