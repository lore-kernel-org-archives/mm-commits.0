From: akpm@linux-foundation.org
Subject: + w1-omap-hdq-convert-to-devm_-functions.patch added to -mm tree
Date: Tue, 14 Aug 2012 16:12:53 -0700
Message-ID: <20120814231254.4C9371E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:56742 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2HNXMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Aug 2012 19:12:55 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so733742obb.1
        for <mm-commits@vger.kernel.org>; Tue, 14 Aug 2012 16:12:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbi@ti.com, greg@kroah.com, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/masters/omap_hdq.c: convert to devm_* functions
has been added to the -mm tree.  Its filename is
     w1-omap-hdq-convert-to-devm_-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
-
 }
 
 static int __devexit omap_hdq_remove(struct platform_device *pdev)
@@ -644,10 +634,6 @@ static int __devexit omap_hdq_remove(str
 
 	/* remove module dependency */
 	pm_runtime_disable(&pdev->dev);
-	free_irq(INT_24XX_HDQ_IRQ, hdq_data);
-	platform_set_drvdata(pdev, NULL);
-	iounmap(hdq_data->hdq_base);
-	kfree(hdq_data);
 
 	return 0;
 }
_

Patches currently in -mm which might be from balbi@ti.com are

linux-next.patch
w1-omap-hdq-add-section-annotation-to-remove.patch
w1-omap-hdq-dont-hardcode-resource-size.patch
w1-omap-hdq-convert-to-module_platform_driver.patch
w1-omap-hdq-convert-to-devm_-functions.patch
w1-omap-hdq-remove-unnecessary-return.patch
w1-omap-hdq-drop-arch-dependency.patch

