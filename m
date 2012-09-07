From: akpm@linux-foundation.org
Subject: + rtc-rtc-mxc-convert-to-module_platform_driver.patch added to -mm tree
Date: Fri, 07 Sep 2012 14:58:10 -0700
Message-ID: <20120907215811.7F5AD5C00E9@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:61123 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab2IGV6O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 17:58:14 -0400
Received: by lbbge1 with SMTP id ge1so8207lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 14:58:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fabio.estevam@freescale.com, a.zummo@towertech.it, s.hauer@pengutronix.de


The patch titled
     Subject: rtc: rtc-mxc: convert to module_platform_driver
has been added to the -mm tree.  Its filename is
     rtc-rtc-mxc-convert-to-module_platform_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
