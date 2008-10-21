From: akpm@linux-foundation.org
Subject: + rtc-s3c-fix-section-mismatch-warnings.patch added to -mm tree
Date: Tue, 21 Oct 2008 15:30:36 -0700
Message-ID: <200810212230.m9LMUaeW003055@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794AbYJUWbS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 18:31:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jekhor@gmail.com, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-s3c: fix section mismatch warnings
has been added to the -mm tree.  Its filename is
     rtc-s3c-fix-section-mismatch-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-s3c: fix section mismatch warnings
From: Yauhen Kharuzhy <jekhor@gmail.com>

Warnings was appeared when compile rtc-s3c.c because
platform_driver structure s3c2410_rtcdrv has wrong name.

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-s3c-fix-section-mismatch-warnings drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-s3c-fix-section-mismatch-warnings
+++ a/drivers/rtc/rtc-s3c.c
@@ -507,7 +507,7 @@ static int s3c_rtc_resume(struct platfor
 #define s3c_rtc_resume  NULL
 #endif
 
-static struct platform_driver s3c2410_rtcdrv = {
+static struct platform_driver s3c2410_rtc_driver = {
 	.probe		= s3c_rtc_probe,
 	.remove		= __devexit_p(s3c_rtc_remove),
 	.suspend	= s3c_rtc_suspend,
@@ -523,12 +523,12 @@ static char __initdata banner[] = "S3C24
 static int __init s3c_rtc_init(void)
 {
 	printk(banner);
-	return platform_driver_register(&s3c2410_rtcdrv);
+	return platform_driver_register(&s3c2410_rtc_driver);
 }
 
 static void __exit s3c_rtc_exit(void)
 {
-	platform_driver_unregister(&s3c2410_rtcdrv);
+	platform_driver_unregister(&s3c2410_rtc_driver);
 }
 
 module_init(s3c_rtc_init);
_

Patches currently in -mm which might be from jekhor@gmail.com are

origin.patch
rtc-s3c-fix-section-mismatch-warnings.patch
linux-next.patch

