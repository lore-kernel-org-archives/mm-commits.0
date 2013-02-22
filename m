From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-coh901331-use-devm_clk_get.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:53 -0800
Message-ID: <20130222204453.9448E5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:34518 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419Ab3BVUoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:54 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so119176qah.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-coh901331: use devm_clk_get()
has been removed from the -mm tree.  Its filename was
     rtc-rtc-coh901331-use-devm_clk_get.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-coh901331: use devm_clk_get()

Use devm_clk_get() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-coh901331.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_clk_get drivers/rtc/rtc-coh901331.c
--- a/drivers/rtc/rtc-coh901331.c~rtc-rtc-coh901331-use-devm_clk_get
+++ a/drivers/rtc/rtc-coh901331.c
@@ -157,7 +157,6 @@ static int __exit coh901331_remove(struc
 	if (rtap) {
 		rtc_device_unregister(rtap->rtc);
 		clk_unprepare(rtap->clk);
-		clk_put(rtap->clk);
 		platform_set_drvdata(pdev, NULL);
 	}
 
@@ -196,7 +195,7 @@ static int __init coh901331_probe(struct
 			     "RTC COH 901 331 Alarm", rtap))
 		return -EIO;
 
-	rtap->clk = clk_get(&pdev->dev, NULL);
+	rtap->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(rtap->clk)) {
 		ret = PTR_ERR(rtap->clk);
 		dev_err(&pdev->dev, "could not get clock\n");
@@ -207,7 +206,7 @@ static int __init coh901331_probe(struct
 	ret = clk_prepare_enable(rtap->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "could not enable clock\n");
-		goto out_no_clk_prepenable;
+		return ret;
 	}
 	clk_disable(rtap->clk);
 
@@ -224,8 +223,6 @@ static int __init coh901331_probe(struct
  out_no_rtc:
 	platform_set_drvdata(pdev, NULL);
 	clk_unprepare(rtap->clk);
- out_no_clk_prepenable:
-	clk_put(rtap->clk);
 	return ret;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

