From: akpm@linux-foundation.org
Subject: - rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2.patch removed from -mm tree
Date: Thu, 06 Nov 2008 17:31:11 -0800
Message-ID: <200811070131.mA71VBVl011496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbYKGBb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Nov 2008 20:31:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, david-b@pacbell.net, linux@wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     rtc-rtc-wm8350-add-support-for-wm8350-rtc update 2
has been removed from the -mm tree.  Its filename was
     rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2.patch

This patch was dropped because it was folded into rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-rtc-wm8350-add-support-for-wm8350-rtc update 2
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

 - Marks remove() with __devexit_p()
 - Fixes grammar in MODULE_DESCRIPTION()

which should address all the feedback from Alessandro.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <linux@wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-wm8350.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2 drivers/rtc/rtc-wm8350.c
--- a/drivers/rtc/rtc-wm8350.c~rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2
+++ a/drivers/rtc/rtc-wm8350.c
@@ -488,7 +488,7 @@ static int __devexit wm8350_rtc_remove(s
 
 static struct platform_driver wm8350_rtc_driver = {
 	.probe = wm8350_rtc_probe,
-	.remove = wm8350_rtc_remove,
+	.remove = __devexit_p(wm8350_rtc_remove),
 	.suspend = wm8350_rtc_suspend,
 	.resume = wm8350_rtc_resume,
 	.driver = {
@@ -509,6 +509,6 @@ static void __exit wm8350_rtc_exit(void)
 module_exit(wm8350_rtc_exit);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
-MODULE_DESCRIPTION("RTC driver WM8350");
+MODULE_DESCRIPTION("RTC driver for the WM8350");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:wm8350-rtc");
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch
linux-next.patch
watchdog-add-support-for-the-wm8350-watchdog.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2.patch

