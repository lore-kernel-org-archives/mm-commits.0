From: akpm@linux-foundation.org
Subject: [merged] rtc-max77686-use-dev_info-instead-of-printk.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:14 -0800
Message-ID: <20130222204414.BD9035A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:38274 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab3BVUoP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:15 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so104368yhr.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: max77686: use dev_info() instead of printk()
has been removed from the -mm tree.  Its filename was
     rtc-max77686-use-dev_info-instead-of-printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: max77686: use dev_info() instead of printk()

Fix the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-max77686.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-max77686.c~rtc-max77686-use-dev_info-instead-of-printk drivers/rtc/rtc-max77686.c
--- a/drivers/rtc/rtc-max77686.c~rtc-max77686-use-dev_info-instead-of-printk
+++ a/drivers/rtc/rtc-max77686.c
@@ -503,7 +503,7 @@ static int max77686_rtc_probe(struct pla
 	struct max77686_rtc_info *info;
 	int ret, virq;
 
-	printk(KERN_INFO "%s\n", __func__);
+	dev_info(&pdev->dev, "%s\n", __func__);
 
 	info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);
 	if (!info)
@@ -542,7 +542,7 @@ static int max77686_rtc_probe(struct pla
 			&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
-		printk(KERN_INFO "%s: fail\n", __func__);
+		dev_info(&pdev->dev, "%s: fail\n", __func__);
 
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

