From: akpm@linux-foundation.org
Subject: [merged] rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled.patch removed from -mm tree
Date: Thu, 12 Jul 2012 12:36:46 -0700
Message-ID: <20120712193646.B425B100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:52764 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab2GLTgs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 15:36:48 -0400
Received: by qcqs25 with SMTP id s25so267881qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 12:36:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lee.jones@linaro.org, a.zummo@towertech.it, linus.walleij@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-ab8500.c: ensure correct probing of the AB8500 RTC when Device Tree is enabled
has been removed from the -mm tree.  Its filename was
     rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lee Jones <lee.jones@linaro.org>
Subject: drivers/rtc/rtc-ab8500.c: ensure correct probing of the AB8500 RTC when Device Tree is enabled

Without this patch, if Device Tree is enabled the AB8500 RTC wouldn't get
probed at all, as there is no reference to it from platform code.  This
patch ensures the driver is probed during normal DT start-up.

[akpm@linux-foundation.org: checkpatch fixes]
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ab8500.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ab8500.c~rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled drivers/rtc/rtc-ab8500.c
--- a/drivers/rtc/rtc-ab8500.c~rtc-ensure-correct-probing-of-the-ab8500-rtc-when-device-tree-is-enabled
+++ a/drivers/rtc/rtc-ab8500.c
@@ -17,6 +17,7 @@
 #include <linux/mfd/abx500.h>
 #include <linux/mfd/abx500/ab8500.h>
 #include <linux/delay.h>
+#include <linux/of.h>
 
 #define AB8500_RTC_SOFF_STAT_REG	0x00
 #define AB8500_RTC_CC_CONF_REG		0x01
@@ -430,7 +431,6 @@ static int __devinit ab8500_rtc_probe(st
 
 	platform_set_drvdata(pdev, rtc);
 
-
 	err = ab8500_sysfs_rtc_register(&pdev->dev);
 	if (err) {
 		dev_err(&pdev->dev, "sysfs RTC failed to register\n");
@@ -454,10 +454,16 @@ static int __devexit ab8500_rtc_remove(s
 	return 0;
 }
 
+static const struct of_device_id ab8500_rtc_match[] = {
+	{ .compatible = "stericsson,ab8500-rtc", },
+	{}
+};
+
 static struct platform_driver ab8500_rtc_driver = {
 	.driver = {
 		.name = "ab8500-rtc",
 		.owner = THIS_MODULE,
+		.of_match_table = ab8500_rtc_match,
 	},
 	.probe	= ab8500_rtc_probe,
 	.remove = __devexit_p(ab8500_rtc_remove),
_

Patches currently in -mm which might be from lee.jones@linaro.org are

origin.patch
linux-next.patch

