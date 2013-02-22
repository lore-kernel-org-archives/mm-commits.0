From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-max8997-use-devm_request_threaded_irq.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:45:11 -0800
Message-ID: <20130222204511.97FDA5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:35045 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3BVUpM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:45:12 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so104429vch.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:45:12 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-max8997: use devm_request_threaded_irq()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-max8997-use-devm_request_threaded_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-max8997: use devm_request_threaded_irq()

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max8997.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-max8997.c~rtc-rtc-max8997-use-devm_request_threaded_irq drivers/rtc/rtc-max8997.c
--- a/drivers/rtc/rtc-max8997.c~rtc-rtc-max8997-use-devm_request_threaded_irq
+++ a/drivers/rtc/rtc-max8997.c
@@ -495,7 +495,8 @@ static int max8997_rtc_probe(struct plat
 	}
 	info->virq = virq;
 
-	ret = request_threaded_irq(virq, NULL, max8997_rtc_alarm_irq, 0,
+	ret = devm_request_threaded_irq(&pdev->dev, virq, NULL,
+				max8997_rtc_alarm_irq, 0,
 				"rtc-alarm0", info);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
@@ -514,10 +515,8 @@ static int max8997_rtc_remove(struct pla
 {
 	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
 
-	if (info) {
-		free_irq(info->virq, info);
+	if (info)
 		rtc_device_unregister(info->rtc_dev);
-	}
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

