From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1286-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:07 -0700
Message-ID: <20130430190007.702935A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:49656 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab3D3TAI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:08 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so87395vcb.3
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1286: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1286-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1286: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1286.c |   46 +++++++------------------------------
 1 file changed, 9 insertions(+), 37 deletions(-)

diff -puN drivers/rtc/rtc-ds1286.c~rtc-rtc-ds1286-use-devm_-functions drivers/rtc/rtc-ds1286.c
--- a/drivers/rtc/rtc-ds1286.c~rtc-rtc-ds1286-use-devm_-functions
+++ a/drivers/rtc/rtc-ds1286.c
@@ -25,8 +25,6 @@
 struct ds1286_priv {
 	struct rtc_device *rtc;
 	u32 __iomem *rtcregs;
-	size_t size;
-	unsigned long baseaddr;
 	spinlock_t lock;
 };
 
@@ -333,56 +331,30 @@ static int ds1286_probe(struct platform_
 	struct rtc_device *rtc;
 	struct resource *res;
 	struct ds1286_priv *priv;
-	int ret = 0;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	priv = kzalloc(sizeof(struct ds1286_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct ds1286_priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->size = resource_size(res);
-	if (!request_mem_region(res->start, priv->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	priv->baseaddr = res->start;
-	priv->rtcregs = ioremap(priv->baseaddr, priv->size);
-	if (!priv->rtcregs) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	priv->rtcregs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->rtcregs))
+		return PTR_ERR(priv->rtcregs);
+
 	spin_lock_init(&priv->lock);
 	platform_set_drvdata(pdev, priv);
-	rtc = rtc_device_register("ds1286", &pdev->dev,
-				  &ds1286_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto out;
-	}
+	rtc = devm_rtc_device_register(&pdev->dev, "ds1286", &ds1286_ops,
+					THIS_MODULE);
+	if (IS_ERR(rtc))
+		return PTR_ERR(rtc);
 	priv->rtc = rtc;
 	return 0;
-
-out:
-	if (priv->rtc)
-		rtc_device_unregister(priv->rtc);
-	if (priv->rtcregs)
-		iounmap(priv->rtcregs);
-	if (priv->baseaddr)
-		release_mem_region(priv->baseaddr, priv->size);
-	kfree(priv);
-	return ret;
 }
 
 static int ds1286_remove(struct platform_device *pdev)
 {
-	struct ds1286_priv *priv = platform_get_drvdata(pdev);
