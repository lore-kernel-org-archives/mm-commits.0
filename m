From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-jz4740-use-devm_-functions.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:33:24 -0700
Message-ID: <51db1404.vDsVt7HaOgjmA61F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab3GHTdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: [merged] rtc-rtc-jz4740-use-devm_-functions.patch removed from -mm tree
To: jg1.han@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:33:24 -0700


The patch titled
     Subject: rtc: rtc-jz4740: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-jz4740-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-jz4740: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-jz4740.c |   65 +++++++++----------------------------
 1 file changed, 16 insertions(+), 49 deletions(-)

diff -puN drivers/rtc/rtc-jz4740.c~rtc-rtc-jz4740-use-devm_-functions drivers/rtc/rtc-jz4740.c
--- a/drivers/rtc/rtc-jz4740.c~rtc-rtc-jz4740-use-devm_-functions
+++ a/drivers/rtc/rtc-jz4740.c
@@ -14,6 +14,7 @@
  *
  */
 
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -216,37 +217,34 @@ static int jz4740_rtc_probe(struct platf
 	struct jz4740_rtc *rtc;
 	uint32_t scratchpad;
 
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
 	rtc->irq = platform_get_irq(pdev, 0);
 	if (rtc->irq < 0) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform irq\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
 	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!rtc->mem) {
-		ret = -ENOENT;
 		dev_err(&pdev->dev, "Failed to get platform mmio memory\n");
-		goto err_free;
+		return -ENOENT;
 	}
 
-	rtc->mem = request_mem_region(rtc->mem->start, resource_size(rtc->mem),
-					pdev->name);
+	rtc->mem = devm_request_mem_region(&pdev->dev, rtc->mem->start,
+					resource_size(rtc->mem), pdev->name);
 	if (!rtc->mem) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		goto err_free;
+		return -EBUSY;
 	}
 
-	rtc->base = ioremap_nocache(rtc->mem->start, resource_size(rtc->mem));
+	rtc->base = devm_ioremap_nocache(&pdev->dev, rtc->mem->start,
+					resource_size(rtc->mem));
 	if (!rtc->base) {
-		ret = -EBUSY;
 		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		goto err_release_mem_region;
+		return -EBUSY;
 	}
 
 	spin_lock_init(&rtc->lock);
@@ -255,19 +253,19 @@ static int jz4740_rtc_probe(struct platf
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev, &jz4740_rtc_ops,
-					THIS_MODULE);
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&jz4740_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
 		dev_err(&pdev->dev, "Failed to register rtc device: %d\n", ret);
-		goto err_iounmap;
+		return ret;
 	}
 
-	ret = request_irq(rtc->irq, jz4740_rtc_irq, 0,
+	ret = devm_request_irq(&pdev->dev, rtc->irq, jz4740_rtc_irq, 0,
 				pdev->name, rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request rtc irq: %d\n", ret);
-		goto err_unregister_rtc;
+		return ret;
 	}
 
 	scratchpad = jz4740_rtc_reg_read(rtc, JZ_REG_RTC_SCRATCHPAD);
@@ -276,43 +274,13 @@ static int jz4740_rtc_probe(struct platf
 		ret = jz4740_rtc_reg_write(rtc, JZ_REG_RTC_SEC, 0);
 		if (ret) {
 			dev_err(&pdev->dev, "Could not write write to RTC registers\n");
-			goto err_free_irq;
+			return ret;
 		}
 	}
 
 	return 0;
-
-err_free_irq:
-	free_irq(rtc->irq, rtc);
-err_unregister_rtc:
-	rtc_device_unregister(rtc->rtc);
-err_iounmap:
-	iounmap(rtc->base);
-err_release_mem_region:
-	release_mem_region(rtc->mem->start, resource_size(rtc->mem));
-err_free:
-	kfree(rtc);
-
-	return ret;
 }
 
-static int jz4740_rtc_remove(struct platform_device *pdev)
-{
-	struct jz4740_rtc *rtc = platform_get_drvdata(pdev);
-
-	free_irq(rtc->irq, rtc);
-
-	rtc_device_unregister(rtc->rtc);
-
-	iounmap(rtc->base);
-	release_mem_region(rtc->mem->start, resource_size(rtc->mem));
-
-	kfree(rtc);
-
-	return 0;
-}
-
