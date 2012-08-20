From: akpm@linux-foundation.org
Subject: [merged] w1-omap-hdq-convert-to-devm_-functions.patch removed from -mm tree
Date: Mon, 20 Aug 2012 12:57:02 -0700
Message-ID: <20120820195702.B43CD1E0049@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:34156 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab2HTT5E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 15:57:04 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so4032395obb.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 12:57:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbi@ti.com, greg@kroah.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: convert to devm_* functions
has been removed from the -mm tree.  Its filename was
     w1-omap-hdq-convert-to-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Felipe Balbi <balbi@ti.com>
Subject: drivers/w1/masters/omap_hdq.c: convert to devm_* functions

This lets us remove a bit of boilerplate code.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/omap_hdq.c |   32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff -puN drivers/w1/masters/omap_hdq.c~w1-omap-hdq-convert-to-devm_-functions drivers/w1/masters/omap_hdq.c
--- a/drivers/w1/masters/omap_hdq.c~w1-omap-hdq-convert-to-devm_-functions
+++ a/drivers/w1/masters/omap_hdq.c
@@ -544,33 +544,31 @@ static void omap_w1_write_byte(void *_hd
 
 static int __devinit omap_hdq_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct hdq_data *hdq_data;
 	struct resource *res;
 	int ret, irq;
 	u8 rev;
 
-	hdq_data = kmalloc(sizeof(*hdq_data), GFP_KERNEL);
+	hdq_data = devm_kzalloc(dev, sizeof(*hdq_data), GFP_KERNEL);
 	if (!hdq_data) {
 		dev_dbg(&pdev->dev, "unable to allocate memory\n");
-		ret = -ENOMEM;
-		goto err_kmalloc;
+		return -ENOMEM;
 	}
 
-	hdq_data->dev = &pdev->dev;
+	hdq_data->dev = dev;
 	platform_set_drvdata(pdev, hdq_data);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_dbg(&pdev->dev, "unable to get resource\n");
-		ret = -ENXIO;
-		goto err_resource;
+		return -ENXIO;
 	}
 
-	hdq_data->hdq_base = ioremap(res->start, resource_size(res));
+	hdq_data->hdq_base = devm_request_and_ioremap(dev, res);
 	if (!hdq_data->hdq_base) {
 		dev_dbg(&pdev->dev, "ioremap failed\n");
-		ret = -EINVAL;
-		goto err_ioremap;
+		return -ENOMEM;
 	}
 
 	hdq_data->hdq_usecount = 0;
@@ -591,7 +589,8 @@ static int __devinit omap_hdq_probe(stru
 		goto err_irq;
 	}
 
-	ret = request_irq(irq, hdq_isr, IRQF_DISABLED, "omap_hdq", hdq_data);
+	ret = devm_request_irq(dev, irq, hdq_isr, IRQF_DISABLED,
+			"omap_hdq", hdq_data);
 	if (ret < 0) {
 		dev_dbg(&pdev->dev, "could not request irq\n");
 		goto err_irq;
@@ -616,16 +615,7 @@ err_irq:
 err_w1:
 	pm_runtime_disable(&pdev->dev);
 
-	iounmap(hdq_data->hdq_base);
-
-err_ioremap:
-err_resource:
-	platform_set_drvdata(pdev, NULL);
-	kfree(hdq_data);
-
-err_kmalloc:
 	return ret;
