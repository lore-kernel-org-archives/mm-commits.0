From: akpm@linux-foundation.org
Subject: + rtc-rtc-s3c-fix-rtc-initialization-method.patch added to -mm tree
Date: Mon, 11 Oct 2010 15:59:36 -0700
Message-ID: <201010112259.o9BMxame023169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab0JKXAe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Oct 2010 19:00:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chaos.youn@samsung.com, a.zummo@towertech.it, ben-linux@fluff.org, kgene.kim@samsung.com, mcuos.com@gmail.com


The patch titled
     rtc: rtc-s3c: fix RTC initialization method
has been added to the -mm tree.  Its filename is
     rtc-rtc-s3c-fix-rtc-initialization-method.patch

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
Subject: rtc: rtc-s3c: fix RTC initialization method
From: Changhwan Youn <chaos.youn@samsung.com>

Change RTC initialization method in probe().  The 'rtc_valid_tm(tm)' can
check whether RTC BCD is valid or not.  And change the method of checking
because the previous method cannot validate RTC BCD registers properly.

Signed-off-by: Changhwan Youn <chaos.youn@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-rtc-initialization-method drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-rtc-initialization-method
+++ a/drivers/rtc/rtc-s3c.c
@@ -453,8 +453,8 @@ static int __devexit s3c_rtc_remove(stru
 static int __devinit s3c_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
+	struct rtc_time rtc_tm;
 	struct resource *res;
-	unsigned int tmp, i;
 	int ret;
 
 	pr_debug("%s: probe=%p\n", __func__, pdev);
@@ -535,11 +535,19 @@ static int __devinit s3c_rtc_probe(struc
 
 	/* Check RTC Time */
 
-	for (i = S3C2410_RTCSEC; i <= S3C2410_RTCYEAR; i += 0x4) {
-		tmp = readb(s3c_rtc_base + i);
+	s3c_rtc_gettime(NULL, &rtc_tm);
 
-		if ((tmp & 0xf) > 0x9 || ((tmp >> 4) & 0xf) > 0x9)
-			writeb(0, s3c_rtc_base + i);
+	if (rtc_valid_tm(&rtc_tm)) {
+		rtc_tm.tm_year	= 100;
+		rtc_tm.tm_mon	= 0;
+		rtc_tm.tm_mday	= 1;
+		rtc_tm.tm_hour	= 0;
+		rtc_tm.tm_min	= 0;
+		rtc_tm.tm_sec	= 0;
+
+		s3c_rtc_settime(NULL, &rtc_tm);
+
+		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
 	}
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
_

Patches currently in -mm which might be from chaos.youn@samsung.com are

linux-next.patch
rtc-rtc-s3c-fix-access-unit-from-byte-to-word-on-rtccon.patch
rtc-rtc-s3c-fix-setting-missing-field-of-getalarm.patch
rtc-rtc-s3c-fix-on-support-rtc-alarm.patch
rtc-rtc-s3c-fix-rtc-initialization-method.patch

