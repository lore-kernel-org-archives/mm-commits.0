From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-s3c-fix-failed-first-read-of-rtc-time.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:12 -0700
Message-ID: <553550f4.oqc8ShgHotCK9SjL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbbDTTLv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.kozlowski@samsung.com, a.zummo@towertech.it, alexandre.belloni@free-electrons.com, cw00.choi@samsung.com, m.szyprowski@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-s3c.c: fix failed first read of RTC time
has been removed from the -mm tree.  Its filename was
     rtc-rtc-s3c-fix-failed-first-read-of-rtc-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: drivers/rtc/rtc-s3c.c: fix failed first read of RTC time

Initialize the device time (if it is wrong) before registering RTC device
to fix following error message during rtc-s3c probe:

[    2.215414] rtc (null): read_time: fail to read
[    2.216322] s3c-rtc 10070000.rtc: rtc core: registered s3c as rtc1

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-s3c.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff -puN drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-failed-first-read-of-rtc-time drivers/rtc/rtc-s3c.c
--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-failed-first-read-of-rtc-time
+++ a/drivers/rtc/rtc-s3c.c
@@ -496,6 +496,22 @@ static int s3c_rtc_probe(struct platform
 
 	device_init_wakeup(&pdev->dev, 1);
 
+	/* Check RTC Time */
+	s3c_rtc_gettime(&pdev->dev, &rtc_tm);
+
+	if (rtc_valid_tm(&rtc_tm)) {
+		rtc_tm.tm_year	= 100;
+		rtc_tm.tm_mon	= 0;
+		rtc_tm.tm_mday	= 1;
+		rtc_tm.tm_hour	= 0;
+		rtc_tm.tm_min	= 0;
+		rtc_tm.tm_sec	= 0;
+
+		s3c_rtc_settime(&pdev->dev, &rtc_tm);
+
+		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
+	}
+
 	/* register RTC and exit */
 	info->rtc = devm_rtc_device_register(&pdev->dev, "s3c", &s3c_rtcops,
 				  THIS_MODULE);
@@ -519,22 +535,6 @@ static int s3c_rtc_probe(struct platform
 		goto err_nortc;
 	}
 
-	/* Check RTC Time */
-	s3c_rtc_gettime(&pdev->dev, &rtc_tm);
-
-	if (rtc_valid_tm(&rtc_tm)) {
-		rtc_tm.tm_year	= 100;
-		rtc_tm.tm_mon	= 0;
-		rtc_tm.tm_mday	= 1;
-		rtc_tm.tm_hour	= 0;
-		rtc_tm.tm_min	= 0;
-		rtc_tm.tm_sec	= 0;
-
-		s3c_rtc_settime(&pdev->dev, &rtc_tm);
-
-		dev_warn(&pdev->dev, "warning: invalid RTC value so initializing it\n");
-	}
