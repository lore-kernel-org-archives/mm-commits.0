From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:29:02 -0800
Message-ID: <20130221232902.D6C175A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:46998 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3BUX3E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:29:04 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so11302qeb.4
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:29:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldewangan@nvidia.com, devendra.aaru@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-add-rtc-driver-for-tps80031-tps80032-v2
has been removed from the -mm tree.  Its filename was
     rtc-add-rtc-driver-for-tps80031-tps80032-v2.patch

This patch was dropped because it was folded into rtc-add-rtc-driver-for-tps80031-tps80032.patch

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

 drivers/rtc/rtc-tps80031.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
 
_

Patches currently in -mm which might be from ldewangan@nvidia.com are

origin.patch
rtc-add-rtc-driver-for-tps80031-tps80032.patch
rtc-add-rtc-driver-for-tps80031-tps80032-v2-fix.patch
drivers-rtc-rtc-tps65910c-enable-disable-wake-in-suspend-resume.patch
drivers-rtc-rtc-tps65910c-remove-unnecessary-irq-stat-save-and-restore.patch
drivers-rtc-rtc-tps65910c-use-sleep_pm_ops-macro-for-initialising-suspend-resume-callbacks.patch
drivers-rtc-rtc-tps65910c-set-irq-flag-to-irqf_early_resume-during-irq-request.patch

