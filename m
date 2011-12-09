From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-fix-driver-clock-enable-disable-balance-issues.patch removed from -mm tree
Date: Fri, 09 Dec 2011 12:08:00 -0800
Message-ID: <201112092008.pB9K80lA027256@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:42673 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab1LIUIK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Dec 2011 15:08:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jhbird.choi@samsung.com, a.zummo@towertech.it, kgene.kim@samsung.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix driver clock enable/disable balance issues
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-fix-driver-clock-enable-disable-balance-issues.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -202,7 +202,6 @@ static int s3c_rtc_settime(struct device
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	clk_enable(rtc_clk);
 	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -214,6 +213,7 @@ static int s3c_rtc_settime(struct device
 		return -EINVAL;
 	}
 
+	clk_enable(rtc_clk);
 	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
 	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);
_

Patches currently in -mm which might be from jhbird.choi@samsung.com are

origin.patch
linux-next.patch

