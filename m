From: akpm@linux-foundation.org
Subject: [merged] rtc-rtc-rp5c01-use-devm_-functions.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:00:48 -0700
Message-ID: <20130430190048.710F65A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:46656 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933292Ab3D3TAt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:00:49 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so87386vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:00:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc: rtc-rp5c01: use devm_*() functions
has been removed from the -mm tree.  Its filename was
     rtc-rtc-rp5c01-use-devm_-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: rtc: rtc-rp5c01: use devm_*() functions

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-rp5c01.c |   26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff -puN drivers/rtc/rtc-rp5c01.c~rtc-rtc-rp5c01-use-devm_-functions drivers/rtc/rtc-rp5c01.c
--- a/drivers/rtc/rtc-rp5c01.c~rtc-rtc-rp5c01-use-devm_-functions
+++ a/drivers/rtc/rtc-rp5c01.c
@@ -230,15 +230,13 @@ static int __init rp5c01_rtc_probe(struc
 	if (!res)
 		return -ENODEV;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&dev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
-	priv->regs = ioremap(res->start, resource_size(res));
-	if (!priv->regs) {
-		error = -ENOMEM;
-		goto out_free_priv;
-	}
+	priv->regs = devm_ioremap(&dev->dev, res->start, resource_size(res));
+	if (!priv->regs)
+		return -ENOMEM;
 
 	sysfs_bin_attr_init(&priv->nvram_attr);
 	priv->nvram_attr.attr.name = "nvram";
@@ -251,27 +249,22 @@ static int __init rp5c01_rtc_probe(struc
 
 	platform_set_drvdata(dev, priv);
 
-	rtc = rtc_device_register("rtc-rp5c01", &dev->dev, &rp5c01_rtc_ops,
+	rtc = devm_rtc_device_register(&dev->dev, "rtc-rp5c01", &rp5c01_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		error = PTR_ERR(rtc);
-		goto out_unmap;
+		goto out;
 	}
 	priv->rtc = rtc;
 
 	error = sysfs_create_bin_file(&dev->dev.kobj, &priv->nvram_attr);
 	if (error)
-		goto out_unregister;
+		goto out;
 
 	return 0;
 
-out_unregister:
-	rtc_device_unregister(rtc);
-out_unmap:
+out:
 	platform_set_drvdata(dev, NULL);
-	iounmap(priv->regs);
-out_free_priv:
-	kfree(priv);
 	return error;
 }
 
@@ -280,9 +273,6 @@ static int __exit rp5c01_rtc_remove(stru
 	struct rp5c01_priv *priv = platform_get_drvdata(dev);
 
 	sysfs_remove_bin_file(&dev->dev.kobj, &priv->nvram_attr);
-	rtc_device_unregister(priv->rtc);
-	iounmap(priv->regs);
-	kfree(priv);
 	return 0;
 }
 
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
rtc-rtc-v3020-use-gpio_request_array.patch
drivers-rtc-rtc-pxac-use-devm_-apis.patch
memstick-r592-make-r592_pm_ops-static.patch

