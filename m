From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-vr41xx-use-devm_-functions.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 11:02:38 -0800
Message-ID: <52e2b8ce.tFTG3U7JCBtX2mWa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaAXTCi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 14:02:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yuasa@linux-mips.org, grygorii.strashko@ti.com, jg1.han@samsung.com

Subject: [merged] rtc-rtc-vr41xx-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,grygorii.strashko@ti.com,yuasa@linux-mips.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 11:02:38 -0800


The patch titled
     Subject: drivers/rtc/rtc-vr41xx.c: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-vr41xx-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: drivers/rtc/rtc-vr41xx.c: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler, and remove
unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vr41xx.c |   50 ++++++++-----------------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

diff -puN drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-use-devm_-functions drivers/rtc/rtc-vr41xx.c
--- a/drivers/rtc/rtc-vr41xx.c~rtc-rtc-vr41xx-use-devm_-functions
+++ a/drivers/rtc/rtc-vr41xx.c
@@ -293,7 +293,7 @@ static int rtc_probe(struct platform_dev
 	if (!res)
 		return -EBUSY;
 
-	rtc1_base = ioremap(res->start, resource_size(res));
+	rtc1_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!rtc1_base)
 		return -EBUSY;
 
@@ -303,13 +303,14 @@ static int rtc_probe(struct platform_dev
 		goto err_rtc1_iounmap;
 	}
 
-	rtc2_base = ioremap(res->start, resource_size(res));
+	rtc2_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!rtc2_base) {
 		retval = -EBUSY;
 		goto err_rtc1_iounmap;
 	}
 
-	rtc = rtc_device_register(rtc_name, &pdev->dev, &vr41xx_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, rtc_name, &vr41xx_rtc_ops,
+					THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		retval = PTR_ERR(rtc);
 		goto err_iounmap_all;
@@ -330,24 +331,24 @@ static int rtc_probe(struct platform_dev
 	aie_irq = platform_get_irq(pdev, 0);
 	if (aie_irq <= 0) {
 		retval = -EBUSY;
-		goto err_device_unregister;
+		goto err_iounmap_all;
 	}
 
-	retval = request_irq(aie_irq, elapsedtime_interrupt, 0,
-			     "elapsed_time", pdev);
+	retval = devm_request_irq(&pdev->dev, aie_irq, elapsedtime_interrupt, 0,
+				"elapsed_time", pdev);
 	if (retval < 0)
-		goto err_device_unregister;
+		goto err_iounmap_all;
 
 	pie_irq = platform_get_irq(pdev, 1);
 	if (pie_irq <= 0) {
 		retval = -EBUSY;
-		goto err_free_irq;
+		goto err_iounmap_all;
 	}
 
-	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
-			     "rtclong1", pdev);
+	retval = devm_request_irq(&pdev->dev, pie_irq, rtclong1_interrupt, 0,
+				"rtclong1", pdev);
 	if (retval < 0)
-		goto err_free_irq;
+		goto err_iounmap_all;
 
 	platform_set_drvdata(pdev, rtc);
 
@@ -358,47 +359,20 @@ static int rtc_probe(struct platform_dev
 
 	return 0;
 
-err_free_irq:
-	free_irq(aie_irq, pdev);
-
-err_device_unregister:
-	rtc_device_unregister(rtc);
-
 err_iounmap_all:
-	iounmap(rtc2_base);
 	rtc2_base = NULL;
 
 err_rtc1_iounmap:
-	iounmap(rtc1_base);
 	rtc1_base = NULL;
 
 	return retval;
 }
 
-static int rtc_remove(struct platform_device *pdev)
-{
-	struct rtc_device *rtc;
-
-	rtc = platform_get_drvdata(pdev);
-	if (rtc)
-		rtc_device_unregister(rtc);
-
-	free_irq(aie_irq, pdev);
-	free_irq(pie_irq, pdev);
-	if (rtc1_base)
-		iounmap(rtc1_base);
-	if (rtc2_base)
-		iounmap(rtc2_base);
-
-	return 0;
-}
