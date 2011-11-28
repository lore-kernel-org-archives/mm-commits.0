From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-s3cc-fix-driver-clock-enable-disable-balance-issues.patch added to -mm tree
Date: Mon, 28 Nov 2011 14:59:12 -0800
Message-ID: <201111282259.pASMxCji010131@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:65429 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab1K1W7Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2011 17:59:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jhbird.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance issues
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-s3cc-fix-driver-clock-enable-disable-balance-issues.patch

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
From: Jonghwan Choi <jhbird.choi@samsung.com>
Subject: drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance issues

If an error occurs after the clock is enabled, the enable/disable state
can become unbalanced.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-driver-clock-enable-disable-balance-issues drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-fix-driver-clock-enable-disable-balance-issues
+++ a/drivers/rtc/rtc-s3c.c
@@ -203,7 +203,6 @@ static int s3c_rtc_settime(struct device
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	clk_enable(rtc_clk);
 	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -215,6 +214,7 @@ static int s3c_rtc_settime(struct device
 		return -EINVAL;
 	}
 
+	clk_enable(rtc_clk);
 	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
 	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);
_
Subject: Subject: drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance issues

Patches currently in -mm which might be from jhbird.choi@samsung.com are

linux-next.patch
drivers-rtc-rtc-s3cc-fix-driver-clock-enable-disable-balance-issues.patch

