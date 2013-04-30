From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-ds1216-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:04 -0700
Message-ID: <20130430190004.8CD0731C2AA@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:53426 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524Ab3D3TAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:05 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so88571qad.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-ds1216: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-ds1216-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-ds1216: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1216.c |   44 +++++++------------------------------
 1 file changed, 9 insertions(+), 35 deletions(-)

diff -puN drivers/rtc/rtc-ds1216.c~rtc-rtc-ds1216-use-devm_-functions drivers/rtc/rtc-ds1216.c
--- a/drivers/rtc/rtc-ds1216.c~rtc-rtc-ds1216-use-devm_-functions
+++ a/drivers/rtc/rtc-ds1216.c
@@ -30,8 +30,6 @@ struct ds1216_regs {
 struct ds1216_priv {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
-	size_t size;
-	unsigned long baseaddr;
 };
 
 static const u8 magic[] = {
@@ -144,57 +142,33 @@ static int __init ds1216_rtc_probe(struc
 {
 	struct resource *res;
 	struct ds1216_priv *priv;
-	int ret = 0;
 	u8 dummy[8];
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	priv = kzalloc(sizeof *priv, GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, priv);
 
-	priv->size = resource_size(res);
-	if (!request_mem_region(res->start, priv->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	priv->baseaddr = res->start;
-	priv->ioaddr = ioremap(priv->baseaddr, priv->size);
-	if (!priv->ioaddr) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	priv->rtc = rtc_device_register("ds1216", &pdev->dev,
-				  &ds1216_rtc_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc)) {
-		ret = PTR_ERR(priv->rtc);
-		goto out;
-	}
+	priv->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->ioaddr))
+		return PTR_ERR(priv->ioaddr);
+
+	priv->rtc = devm_rtc_device_register(&pdev->dev, "ds1216",
+					&ds1216_rtc_ops, THIS_MODULE);
+	if (IS_ERR(priv->rtc))
+		return PTR_ERR(priv->rtc);
 
 	/* dummy read to get clock into a known state */
 	ds1216_read(priv->ioaddr, dummy);
 	return 0;
-
-out:
-	if (priv->ioaddr)
-		iounmap(priv->ioaddr);
-	if (priv->baseaddr)
-		release_mem_region(priv->baseaddr, priv->size);
-	kfree(priv);
-	return ret;
 }
 
 static int __exit ds1216_rtc_remove(struct platform_device *pdev)
 {
-	struct ds1216_priv *priv = platform_get_drvdata(pdev);
