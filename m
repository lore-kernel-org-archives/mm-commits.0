From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-mxc-convert-to-module_platform_driver.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:17:17 -0700
Message-ID: <20121005201717.92B1E1E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34156 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2JEURS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:17:18 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236232ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:17:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabio.estevam@freescale.com, a.zummo@towertech.it, s.hauer@pengutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-mxc: convert to module_platform_driver
has been removed from the -mm tree.  Its filename was
     rtc-rtc-mxc-convert-to-module_platform_driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabio Estevam <fabio.estevam@freescale.com>
Subject: rtc: rtc-mxc: convert to module_platform_driver

Converting to module_platform_driver can make the code smaller and cleaner.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mxc.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff -puN drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-convert-to-module_platform_driver drivers/rtc/rtc-mxc.c
--- a/drivers/rtc/rtc-mxc.c~rtc-rtc-mxc-convert-to-module_platform_driver
+++ a/drivers/rtc/rtc-mxc.c
@@ -343,7 +343,7 @@ static struct rtc_class_ops mxc_rtc_ops 
 	.alarm_irq_enable	= mxc_rtc_alarm_irq_enable,
 };
 
-static int __init mxc_rtc_probe(struct platform_device *pdev)
+static int __devinit mxc_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct rtc_device *rtc;
@@ -433,7 +433,7 @@ exit_free_pdata:
 	return ret;
 }
 
-static int __exit mxc_rtc_remove(struct platform_device *pdev)
+static int __devexit mxc_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
@@ -480,21 +480,11 @@ static struct platform_driver mxc_rtc_dr
 #endif
 		   .owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(mxc_rtc_remove),
+	.probe = mxc_rtc_probe,
+	.remove = __devexit_p(mxc_rtc_remove),
 };
 
-static int __init mxc_rtc_init(void)
-{
-	return platform_driver_probe(&mxc_rtc_driver, mxc_rtc_probe);
-}
-
-static void __exit mxc_rtc_exit(void)
-{
-	platform_driver_unregister(&mxc_rtc_driver);
-}
