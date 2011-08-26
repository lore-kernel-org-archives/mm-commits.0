From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-s3cc-correct-debug-messages.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:07:06 -0700
Message-ID: <201108261903.p7QJ3oqk005731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610Ab1HZTE4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: myungjoo.ham@samsung.com, a.zummo@towertech.it, chaos.youn@samsung.com, kgene.kim@samsung.com, kyungmin.park@samsung.com, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-s3c.c: correct debug messages
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-s3cc-correct-debug-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-s3c.c: correct debug messages
From: MyungJoo Ham <myungjoo.ham@samsung.com>

RTC-S3C used to print out debug messages incorrectly.  This patch corrects
incorrect outputs.  (undecoded bcd numbers, incorrectly decoded register
values) This patch affects the pr-debug messages only.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Changhwan Youn <chaos.youn@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-correct-debug-messages drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~drivers-rtc-rtc-s3cc-correct-debug-messages
+++ a/drivers/rtc/rtc-s3c.c
@@ -152,10 +152,6 @@ static int s3c_rtc_gettime(struct device
 		goto retry_get_time;
 	}
 
-	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
-		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
-		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
-
 	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
 	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
 	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
@@ -164,6 +160,11 @@ static int s3c_rtc_gettime(struct device
 	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	rtc_tm->tm_year += 100;
+
+	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
+		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
+		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
+
 	rtc_tm->tm_mon -= 1;
 
 	clk_disable(rtc_clk);
@@ -269,10 +270,9 @@ static int s3c_rtc_setalarm(struct devic
 	clk_enable(rtc_clk);
 	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
-		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
+		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
