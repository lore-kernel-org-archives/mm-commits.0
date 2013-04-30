From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-msm6242-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:28 -0700
Message-ID: <20130430190028.6EE755A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:59553 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab3D3TA3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:29 -0400
Received: by mail-gg0-f201.google.com with SMTP id y3so87294ggc.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-msm6242: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-msm6242-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-msm6242: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-msm6242.c |   32 +++++++++++---------------------
 1 file changed, 11 insertions(+), 21 deletions(-)

diff -puN drivers/rtc/rtc-msm6242.c~rtc-rtc-msm6242-use-devm_-functions drivers/rtc/rtc-msm6242.c
--- a/drivers/rtc/rtc-msm6242.c~rtc-rtc-msm6242-use-devm_-functions
+++ a/drivers/rtc/rtc-msm6242.c
@@ -194,30 +194,28 @@ static const struct rtc_class_ops msm624
 	.set_time	= msm6242_set_time,
 };
 
-static int __init msm6242_rtc_probe(struct platform_device *dev)
+static int __init msm6242_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct msm6242_priv *priv;
 	struct rtc_device *rtc;
 	int error;
 
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->regs = ioremap(res->start, resource_size(res));
-	if (!priv->regs) {
-		error = -ENOMEM;
-		goto out_free_priv;
-	}
-	platform_set_drvdata(dev, priv);
+	priv->regs = devm_ioremap(&pdev->dev, res->start, resource_size(res));
+	if (!priv->regs)
+		return -ENOMEM;
+	platform_set_drvdata(pdev, priv);
 
-	rtc = rtc_device_register("rtc-msm6242", &dev->dev, &msm6242_rtc_ops,
-				  THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, "rtc-msm6242",
+				&msm6242_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		error = PTR_ERR(rtc);
 		goto out_unmap;
@@ -227,20 +225,12 @@ static int __init msm6242_rtc_probe(stru
 	return 0;
 
 out_unmap:
-	platform_set_drvdata(dev, NULL);
-	iounmap(priv->regs);
-out_free_priv:
-	kfree(priv);
+	platform_set_drvdata(pdev, NULL);
 	return error;
 }
 
-static int __exit msm6242_rtc_remove(struct platform_device *dev)
+static int __exit msm6242_rtc_remove(struct platform_device *pdev)
 {
-	struct msm6242_priv *priv = platform_get_drvdata(dev);
