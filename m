From: akpm@linux-foundation.org
Subject: + rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2.patch added to -mm tree
Date: Mon, 27 Oct 2008 23:23:40 -0700
Message-ID: <200810280623.m9S6Neou022733@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbYJ1GXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 02:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, a.zummo@towertech.it, david-b@pacbell.net, linux@wolfsonmicro.com


The patch titled
     rtc-rtc-wm8350-add-support-for-wm8350-rtc update 2
has been added to the -mm tree.  Its filename is
     rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
linux-next.patch
rtc-fix-handling-of-missing-tm_year-data-when-reading-alarms.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc.patch
rtc-rtc-wm8350-add-support-for-wm8350-rtc-update-2.patch

