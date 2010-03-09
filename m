From: akpm@linux-foundation.org
Subject: [merged] rtc-ep93xxc-cleanup-probe-remove-routines.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:22 -0800
Message-ID: <201003091910.o29JAM4j031590@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41263 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755953Ab0CITWT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, a.zummo@towertech.it, hsweeten@visionengravers.com, p_gortmaker@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     rtc-ep93xx.c: cleanup probe/remove routines
has been removed from the -mm tree.  Its filename was
     rtc-ep93xxc-cleanup-probe-remove-routines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc-ep93xx.c: cleanup probe/remove routines
From: H Hartley Sweeten <hartleys@visionengravers.com>

Fix issue with rtc device not getting unregistered in probe error path.

Use the devres managed resource functions in the probe routine to cleanup
the error path.

Use sysfs_{create/remove}_group to add/remove the sysfs files.

Reduces the text size by 132 bytes, increases data by 12 bytes:
    text	   data	    bss	    dec	    hex	filename
-    937	    124	      0	   1061	    425	rtc-ep93xx.o
+    805	    136	      0	    941	    3ad	rtc-ep93xx.o

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ep93xx.c |   73 ++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 44 deletions(-)

diff -puN drivers/rtc/rtc-ep93xx.c~rtc-ep93xxc-cleanup-probe-remove-routines drivers/rtc/rtc-ep93xx.c
--- a/drivers/rtc/rtc-ep93xx.c~rtc-ep93xxc-cleanup-probe-remove-routines
+++ a/drivers/rtc/rtc-ep93xx.c
@@ -115,6 +115,15 @@ static ssize_t ep93xx_rtc_show_comp_dele
 }
 static DEVICE_ATTR(comp_delete, S_IRUGO, ep93xx_rtc_show_comp_delete, NULL);
 
+static struct attribute *ep93xx_rtc_attrs[] = {
+	&dev_attr_comp_preload.attr,
+	&dev_attr_comp_delete.attr,
+	NULL
+};
+
+static const struct attribute_group ep93xx_rtc_sysfs_files = {
+	.attrs	= ep93xx_rtc_attrs,
+};
 
 static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 {
@@ -123,27 +132,22 @@ static int __init ep93xx_rtc_probe(struc
 	struct rtc_device *rtc;
 	int err;
 
-	ep93xx_rtc = kzalloc(sizeof(struct ep93xx_rtc), GFP_KERNEL);
-	if (ep93xx_rtc == NULL)
+	ep93xx_rtc = devm_kzalloc(&pdev->dev, sizeof(*ep93xx_rtc), GFP_KERNEL);
+	if (!ep93xx_rtc)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		err = -ENXIO;
-		goto fail_free;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (res == NULL) {
-		err = -EBUSY;
-		goto fail_free;
-	}
+	if (!res)
+		return -ENXIO;
 
-	ep93xx_rtc->mmio_base = ioremap(res->start, resource_size(res));
-	if (ep93xx_rtc->mmio_base == NULL) {
-		err = -ENXIO;
-		goto fail;
-	}
+	if (!devm_request_mem_region(&pdev->dev, res->start,
+				     resource_size(res), pdev->name))
+		return -EBUSY;
+
+	ep93xx_rtc->mmio_base = devm_ioremap(&pdev->dev, res->start,
+					     resource_size(res));
+	if (!ep93xx_rtc->mmio_base)
+		return -ENXIO;
 
 	pdev->dev.platform_data = ep93xx_rtc;
 
@@ -151,53 +155,34 @@ static int __init ep93xx_rtc_probe(struc
 				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		err = PTR_ERR(rtc);
-		goto fail;
+		goto exit;
 	}
 
 	platform_set_drvdata(pdev, rtc);
 
-	err = device_create_file(&pdev->dev, &dev_attr_comp_preload);
+	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	if (err)
 		goto fail;
-	err = device_create_file(&pdev->dev, &dev_attr_comp_delete);
-	if (err) {
-		device_remove_file(&pdev->dev, &dev_attr_comp_preload);
-		goto fail;
-	}
 
 	return 0;
 
 fail:
-	if (ep93xx_rtc->mmio_base) {
-		iounmap(ep93xx_rtc->mmio_base);
-		pdev->dev.platform_data = NULL;
-	}
-	release_mem_region(res->start, resource_size(res));
-fail_free:
-	kfree(ep93xx_rtc);
+	platform_set_drvdata(pdev, NULL);
+	rtc_device_unregister(rtc);
+exit:
+	pdev->dev.platform_data = NULL;
 	return err;
 }
 
 static int __exit ep93xx_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
-	struct ep93xx_rtc *ep93xx_rtc = pdev->dev.platform_data;
-	struct resource *res;
-
-	/* cleanup sysfs */
-	device_remove_file(&pdev->dev, &dev_attr_comp_delete);
-	device_remove_file(&pdev->dev, &dev_attr_comp_preload);
 
+	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
+	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(rtc);
-
-	iounmap(ep93xx_rtc->mmio_base);
 	pdev->dev.platform_data = NULL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, resource_size(res));
-
-	platform_set_drvdata(pdev, NULL);
