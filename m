From: akpm@linux-foundation.org
Subject: [patch 102/111] w1: remove need for ida and use
 PLATFORM_DEVID_AUTO
Date: Tue, 02 Aug 2016 14:07:06 -0700
Message-ID: <57a10b7a.cRF5Z9++ZeoQkbmD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60742 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbcHBVXx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:23:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, afd@ti.com, greg@kroah.com, zbr@ioremap.net

From: "Andrew F. Davis" <afd@ti.com>
Subject: w1: remove need for ida and use PLATFORM_DEVID_AUTO

PLATFORM_DEVID_AUTO can be used to have the platform core assign
a unique ID instead of manually creating one with IDA. Do this
in all applicable drivers.

Link: http://lkml.kernel.org/r/20160531204313.20979-1-afd@ti.com
Signed-off-by: Andrew F. Davis <afd@ti.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2760.c |   28 +++++-----------------------
 drivers/w1/slaves/w1_ds2780.c |   25 ++++---------------------
 drivers/w1/slaves/w1_ds2781.c |   26 ++++----------------------
 3 files changed, 13 insertions(+), 66 deletions(-)

diff -puN drivers/w1/slaves/w1_ds2760.c~w1-remove-need-for-ida-and-use-platform_devid_auto drivers/w1/slaves/w1_ds2760.c
--- a/drivers/w1/slaves/w1_ds2760.c~w1-remove-need-for-ida-and-use-platform_devid_auto
+++ a/drivers/w1/slaves/w1_ds2760.c
@@ -121,25 +121,14 @@ static const struct attribute_group *w1_
 	NULL,
 };
 
-static DEFINE_IDA(bat_ida);
-
 static int w1_ds2760_add_slave(struct w1_slave *sl)
 {
 	int ret;
-	int id;
 	struct platform_device *pdev;
 
-	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
-	if (id < 0) {
-		ret = id;
-		goto noid;
-	}
-
-	pdev = platform_device_alloc("ds2760-battery", id);
-	if (!pdev) {
-		ret = -ENOMEM;
-		goto pdev_alloc_failed;
-	}
+	pdev = platform_device_alloc("ds2760-battery", PLATFORM_DEVID_AUTO);
+	if (!pdev)
+		return -ENOMEM;
 	pdev->dev.parent = &sl->dev;
 
 	ret = platform_device_add(pdev);
@@ -148,24 +137,19 @@ static int w1_ds2760_add_slave(struct w1
 
 	dev_set_drvdata(&sl->dev, pdev);
 
-	goto success;
+	return 0;
 
 pdev_add_failed:
 	platform_device_put(pdev);
-pdev_alloc_failed:
-	ida_simple_remove(&bat_ida, id);
-noid:
-success:
+
 	return ret;
 }
 
 static void w1_ds2760_remove_slave(struct w1_slave *sl)
 {
 	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
-	int id = pdev->id;
 
 	platform_device_unregister(pdev);
-	ida_simple_remove(&bat_ida, id);
 }
 
 static struct w1_family_ops w1_ds2760_fops = {
@@ -182,14 +166,12 @@ static struct w1_family w1_ds2760_family
 static int __init w1_ds2760_init(void)
 {
 	pr_info("1-Wire driver for the DS2760 battery monitor chip - (c) 2004-2005, Szabolcs Gyurko\n");
-	ida_init(&bat_ida);
 	return w1_register_family(&w1_ds2760_family);
 }
 
 static void __exit w1_ds2760_exit(void)
 {
 	w1_unregister_family(&w1_ds2760_family);
-	ida_destroy(&bat_ida);
 }
 
 EXPORT_SYMBOL(w1_ds2760_read);
diff -puN drivers/w1/slaves/w1_ds2780.c~w1-remove-need-for-ida-and-use-platform_devid_auto drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~w1-remove-need-for-ida-and-use-platform_devid_auto
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -113,25 +113,14 @@ static const struct attribute_group *w1_
 	NULL,
 };
 
-static DEFINE_IDA(bat_ida);
-
 static int w1_ds2780_add_slave(struct w1_slave *sl)
 {
 	int ret;
-	int id;
 	struct platform_device *pdev;
 
-	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
-	if (id < 0) {
-		ret = id;
-		goto noid;
-	}
-
-	pdev = platform_device_alloc("ds2780-battery", id);
-	if (!pdev) {
-		ret = -ENOMEM;
-		goto pdev_alloc_failed;
-	}
+	pdev = platform_device_alloc("ds2780-battery", PLATFORM_DEVID_AUTO);
+	if (!pdev)
+		return -ENOMEM;
 	pdev->dev.parent = &sl->dev;
 
 	ret = platform_device_add(pdev);
@@ -144,19 +133,15 @@ static int w1_ds2780_add_slave(struct w1
 
 pdev_add_failed:
 	platform_device_put(pdev);
-pdev_alloc_failed:
-	ida_simple_remove(&bat_ida, id);
-noid:
+
 	return ret;
 }
 
 static void w1_ds2780_remove_slave(struct w1_slave *sl)
 {
 	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
-	int id = pdev->id;
 
 	platform_device_unregister(pdev);
-	ida_simple_remove(&bat_ida, id);
 }
 
 static struct w1_family_ops w1_ds2780_fops = {
@@ -172,14 +157,12 @@ static struct w1_family w1_ds2780_family
 
 static int __init w1_ds2780_init(void)
 {
-	ida_init(&bat_ida);
 	return w1_register_family(&w1_ds2780_family);
 }
 
 static void __exit w1_ds2780_exit(void)
 {
 	w1_unregister_family(&w1_ds2780_family);
-	ida_destroy(&bat_ida);
 }
 
 module_init(w1_ds2780_init);
diff -puN drivers/w1/slaves/w1_ds2781.c~w1-remove-need-for-ida-and-use-platform_devid_auto drivers/w1/slaves/w1_ds2781.c
--- a/drivers/w1/slaves/w1_ds2781.c~w1-remove-need-for-ida-and-use-platform_devid_auto
+++ a/drivers/w1/slaves/w1_ds2781.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/mutex.h>
-#include <linux/idr.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
@@ -111,25 +110,14 @@ static const struct attribute_group *w1_
 	NULL,
 };
 
-static DEFINE_IDA(bat_ida);
-
 static int w1_ds2781_add_slave(struct w1_slave *sl)
 {
 	int ret;
-	int id;
 	struct platform_device *pdev;
 
-	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
-	if (id < 0) {
-		ret = id;
-		goto noid;
-	}
-
-	pdev = platform_device_alloc("ds2781-battery", id);
-	if (!pdev) {
-		ret = -ENOMEM;
-		goto pdev_alloc_failed;
-	}
+	pdev = platform_device_alloc("ds2781-battery", PLATFORM_DEVID_AUTO);
+	if (!pdev)
+		return -ENOMEM;
 	pdev->dev.parent = &sl->dev;
 
 	ret = platform_device_add(pdev);
@@ -142,19 +130,15 @@ static int w1_ds2781_add_slave(struct w1
 
 pdev_add_failed:
 	platform_device_put(pdev);
-pdev_alloc_failed:
-	ida_simple_remove(&bat_ida, id);
-noid:
+
 	return ret;
 }
 
 static void w1_ds2781_remove_slave(struct w1_slave *sl)
 {
 	struct platform_device *pdev = dev_get_drvdata(&sl->dev);
-	int id = pdev->id;
 
 	platform_device_unregister(pdev);
-	ida_simple_remove(&bat_ida, id);
 }
 
 static struct w1_family_ops w1_ds2781_fops = {
@@ -170,14 +154,12 @@ static struct w1_family w1_ds2781_family
 
 static int __init w1_ds2781_init(void)
 {
-	ida_init(&bat_ida);
 	return w1_register_family(&w1_ds2781_family);
 }
 
 static void __exit w1_ds2781_exit(void)
 {
 	w1_unregister_family(&w1_ds2781_family);
-	ida_destroy(&bat_ida);
 }
 
 module_init(w1_ds2781_init);
_
