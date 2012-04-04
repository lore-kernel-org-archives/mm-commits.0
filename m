From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-ep93xxc-convert-to-use-module_platform_driver.patch added to -mm tree
Date: Wed, 04 Apr 2012 15:18:33 -0700
Message-ID: <20120404221833.4D619A042C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:43021 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556Ab2DDWSf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Apr 2012 18:18:35 -0400
Received: by eekc41 with SMTP id c41so39632eek.1
        for <mm-commits@vger.kernel.org>; Wed, 04 Apr 2012 15:18:34 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, a.zummo@towertech.it, hsweeten@visionengravers.com


The patch titled
     Subject: drivers/rtc/rtc-ep93xx.c: convert to use module_platform_driver()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-ep93xxc-convert-to-use-module_platform_driver.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: drivers/rtc/rtc-ep93xx.c: convert to use module_platform_driver()

Use module_platform_driver() to remove the boilerplate code.

Also, change the probe and remove functions to __devinit/__devexit.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ep93xx.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-ep93xx.c~drivers-rtc-rtc-ep93xxc-convert-to-use-module_platform_driver drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~drivers-rtc-rtc-ep93xxc-convert-to-use-module_platform_driver
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -127,7 +127,7 @@ static const struct attribute_group ep93
 	.attrs	= ep93xx_rtc_attrs,
 };
 
-static int __init ep93xx_rtc_probe(struct platform_device *pdev)
+static int __devinit ep93xx_rtc_probe(struct platform_device *pdev)
 {
 	struct ep93xx_rtc *ep93xx_rtc;
 	struct resource *res;
@@ -174,7 +174,7 @@ exit:
 	return err;
 }
 
-static int __exit ep93xx_rtc_remove(struct platform_device *pdev)
+static int __devexit ep93xx_rtc_remove(struct platform_device *pdev)
 {
 	struct ep93xx_rtc *ep93xx_rtc = platform_get_drvdata(pdev);
 
@@ -186,31 +186,19 @@ static int __exit ep93xx_rtc_remove(stru
 	return 0;
 }
 
-/* work with hotplug and coldplug */
-MODULE_ALIAS("platform:ep93xx-rtc");
-
 static struct platform_driver ep93xx_rtc_driver = {
 	.driver		= {
 		.name	= "ep93xx-rtc",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(ep93xx_rtc_remove),
+	.probe		= ep93xx_rtc_probe,
+	.remove		= __devexit_p(ep93xx_rtc_remove),
 };
 
-static int __init ep93xx_rtc_init(void)
-{
-        return platform_driver_probe(&ep93xx_rtc_driver, ep93xx_rtc_probe);
-}
-
-static void __exit ep93xx_rtc_exit(void)
-{
-	platform_driver_unregister(&ep93xx_rtc_driver);
-}
+module_platform_driver(ep93xx_rtc_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("EP93XX RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
