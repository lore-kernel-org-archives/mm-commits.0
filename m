From: akpm@linux-foundation.org
Subject: + rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch added to -mm tree
Date: Tue, 08 Jan 2013 14:00:36 -0800
Message-ID: <20130108220037.986AB2000B5@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:49881 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3AHWAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jan 2013 17:00:40 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so8111wib.2
        for <mm-commits@vger.kernel.org>; Tue, 08 Jan 2013 14:00:38 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ldewangan@nvidia.com, devendra.aaru@gmail.com


The patch titled
     Subject: rtc-add-rtc-driver-for-tps80031-tps80032-v2
has been added to the -mm tree.  Its filename is
     rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laxman Dewangan <ldewangan@nvidia.com>
Subject: rtc-add-rtc-driver-for-tps80031-tps80032-v2

Changes from V1:
- remvoe the checks for alarm time whether this is past or not in set_alarm.
- add error prints if rtc registration failed.
- add include of pm.h

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Devendra Naga <devendra.aaru@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps80031.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-tps80031.c~rtc-add-rtc-driver-for-tps80031-tps80032-v2 drivers/rtc/rtc-tps80031.c
--- a/drivers/rtc/rtc-tps80031.c~rtc-add-rtc-driver-for-tps80031-tps80032-v2
+++ a/drivers/rtc/rtc-tps80031.c
@@ -4,7 +4,7 @@
  * RTC driver for TI TPS80031/TPS80032 Fully Integrated
  * Power Management with Power Path and Battery Charger
  *
- * Copyright (c) 2012-2013, NVIDIA Corporation.
+ * Copyright (c) 2012, NVIDIA Corporation.
  *
  * Author: Laxman Dewangan <ldewangan@nvidia.com>
  *
@@ -233,7 +233,7 @@ static const struct rtc_class_ops tps800
 	.alarm_irq_enable = tps80031_rtc_alarm_irq_enable,
 };
 
-static int tps80031_rtc_probe(struct platform_device *pdev)
+static int __devinit tps80031_rtc_probe(struct platform_device *pdev)
 {
 	struct tps80031_rtc *rtc;
 	struct rtc_time tm;
@@ -261,7 +261,7 @@ static int tps80031_rtc_probe(struct pla
 		(tm.tm_mday == TPS80031_RTC_POR_DAY)) {
 		tm.tm_year = 2000;
 		tm.tm_mday = 1;
-		tm.tm_mon = 0;
+		tm.tm_mon = 1;
 		ret = tps80031_rtc_set_time(&pdev->dev, &tm);
 		if (ret < 0) {
 			dev_err(&pdev->dev,
@@ -298,7 +298,7 @@ static int tps80031_rtc_probe(struct pla
 	return 0;
 }
 
-static int tps80031_rtc_remove(struct platform_device *pdev)
+static int __devexit tps80031_rtc_remove(struct platform_device *pdev)
 {
 	struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
 
@@ -338,7 +338,7 @@ static struct platform_driver tps80031_r
 		.pm	= &tps80031_pm_ops,
 	},
 	.probe	= tps80031_rtc_probe,
-	.remove	= tps80031_rtc_remove,
+	.remove	= __devexit_p(tps80031_rtc_remove),
 };
 
 module_platform_driver(tps80031_rtc_driver);
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
linux-next.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch

