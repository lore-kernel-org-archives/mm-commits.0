From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-vt8500-use-devm_-functions.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:44:50 -0800
Message-ID: <20130222204450.93D7131C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:45195 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758407Ab3BVUov (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:44:51 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so119722qaj.3
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:44:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-vt8500: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-vt8500-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-vt8500: use devm_*() functions

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-vt8500.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_-functions drivers/rtc/rtc-vt8500.c
--- a/drivers/rtc/rtc-vt8500.c~rtc-rtc-vt8500-use-devm_-functions
+++ a/drivers/rtc/rtc-vt8500.c
@@ -231,20 +231,21 @@ static int vt8500_rtc_probe(struct platf
 		return -ENXIO;
 	}
 
-	vt8500_rtc->res = request_mem_region(vt8500_rtc->res->start,
-					     resource_size(vt8500_rtc->res),
-					     "vt8500-rtc");
+	vt8500_rtc->res = devm_request_mem_region(&pdev->dev,
+					vt8500_rtc->res->start,
+					resource_size(vt8500_rtc->res),
+					"vt8500-rtc");
 	if (vt8500_rtc->res == NULL) {
 		dev_err(&pdev->dev, "failed to request I/O memory\n");
 		return -EBUSY;
 	}
 
-	vt8500_rtc->regbase = ioremap(vt8500_rtc->res->start,
+	vt8500_rtc->regbase = devm_ioremap(&pdev->dev, vt8500_rtc->res->start,
 				      resource_size(vt8500_rtc->res));
 	if (!vt8500_rtc->regbase) {
 		dev_err(&pdev->dev, "Unable to map RTC I/O memory\n");
 		ret = -EBUSY;
-		goto err_release;
+		goto err_return;
 	}
 
 	/* Enable RTC and set it to 24-hour mode */
@@ -257,11 +258,11 @@ static int vt8500_rtc_probe(struct platf
 		ret = PTR_ERR(vt8500_rtc->rtc);
 		dev_err(&pdev->dev,
 			"Failed to register RTC device -> %d\n", ret);
-		goto err_unmap;
+		goto err_return;
 	}
 
-	ret = request_irq(vt8500_rtc->irq_alarm, vt8500_rtc_irq, 0,
-			  "rtc alarm", vt8500_rtc);
+	ret = devm_request_irq(&pdev->dev, vt8500_rtc->irq_alarm,
+				vt8500_rtc_irq, 0, "rtc alarm", vt8500_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "can't get irq %i, err %d\n",
 			vt8500_rtc->irq_alarm, ret);
@@ -272,11 +273,7 @@ static int vt8500_rtc_probe(struct platf
 
 err_unreg:
 	rtc_device_unregister(vt8500_rtc->rtc);
-err_unmap:
-	iounmap(vt8500_rtc->regbase);
-err_release:
-	release_mem_region(vt8500_rtc->res->start,
-			   resource_size(vt8500_rtc->res));
+err_return:
 	return ret;
 }
 
@@ -284,15 +281,10 @@ static int vt8500_rtc_remove(struct plat
 {
 	struct vt8500_rtc *vt8500_rtc = platform_get_drvdata(pdev);
 
-	free_irq(vt8500_rtc->irq_alarm, vt8500_rtc);
