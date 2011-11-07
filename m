From: akpm@linux-foundation.org
Subject: [merged] w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:29:26 -0800
Message-ID: <201111072029.pA7KTQZ4005952@wpaz29.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47730 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:29:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jic23@cam.ac.uk, cabarnes@indesign-llc.com, zbr@ioremap.net, mm-commits@vger.kernel.org


The patch titled
     Subject: w1: ds2760 and ds2780, use ida for id and ida_simple_get() to get it
has been removed from the -mm tree.  Its filename was
     w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jonathan Cameron <jic23@cam.ac.uk>
Subject: w1: ds2760 and ds2780, use ida for id and ida_simple_get() to get it

Straightforward.  As an aside, the ida_init calls are not needed as far as
I can see needed.  (DEFINE_IDA does the same already).

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Acked-by: Clifton Barnes <cabarnes@indesign-llc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2760.c |   48 ++++----------------------------
 drivers/w1/slaves/w1_ds2780.c |   48 ++++----------------------------
 2 files changed, 12 insertions(+), 84 deletions(-)

diff -puN drivers/w1/slaves/w1_ds2760.c~w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it drivers/w1/slaves/w1_ds2760.c
--- a/drivers/w1/slaves/w1_ds2760.c~w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it
+++ a/drivers/w1/slaves/w1_ds2760.c
@@ -114,43 +114,7 @@ static struct bin_attribute w1_ds2760_bi
 	.read = w1_ds2760_read_bin,
 };
 
-static DEFINE_IDR(bat_idr);
-static DEFINE_MUTEX(bat_idr_lock);
-
-static int new_bat_id(void)
-{
-	int ret;
-
-	while (1) {
-		int id;
-
-		ret = idr_pre_get(&bat_idr, GFP_KERNEL);
-		if (ret == 0)
-			return -ENOMEM;
-
-		mutex_lock(&bat_idr_lock);
-		ret = idr_get_new(&bat_idr, NULL, &id);
-		mutex_unlock(&bat_idr_lock);
-
-		if (ret == 0) {
-			ret = id & MAX_ID_MASK;
-			break;
-		} else if (ret == -EAGAIN) {
-			continue;
-		} else {
-			break;
-		}
-	}
-
-	return ret;
-}
-
-static void release_bat_id(int id)
-{
-	mutex_lock(&bat_idr_lock);
-	idr_remove(&bat_idr, id);
-	mutex_unlock(&bat_idr_lock);
-}
+static DEFINE_IDA(bat_ida);
 
 static int w1_ds2760_add_slave(struct w1_slave *sl)
 {
@@ -158,7 +122,7 @@ static int w1_ds2760_add_slave(struct w1
 	int id;
 	struct platform_device *pdev;
 
-	id = new_bat_id();
+	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
 		ret = id;
 		goto noid;
@@ -187,7 +151,7 @@ bin_attr_failed:
 pdev_add_failed:
 	platform_device_unregister(pdev);
 pdev_alloc_failed:
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 noid:
 success:
 	return ret;
@@ -199,7 +163,7 @@ static void w1_ds2760_remove_slave(struc
 	int id = pdev->id;
 
 	platform_device_unregister(pdev);
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2760_bin_attr);
 }
 
@@ -217,14 +181,14 @@ static int __init w1_ds2760_init(void)
 {
 	printk(KERN_INFO "1-Wire driver for the DS2760 battery monitor "
 	       " chip  - (c) 2004-2005, Szabolcs Gyurko\n");
-	idr_init(&bat_idr);
+	ida_init(&bat_ida);
 	return w1_register_family(&w1_ds2760_family);
 }
 
 static void __exit w1_ds2760_exit(void)
 {
 	w1_unregister_family(&w1_ds2760_family);
-	idr_destroy(&bat_idr);
+	ida_destroy(&bat_ida);
 }
 
 EXPORT_SYMBOL(w1_ds2760_read);
diff -puN drivers/w1/slaves/w1_ds2780.c~w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it drivers/w1/slaves/w1_ds2780.c
--- a/drivers/w1/slaves/w1_ds2780.c~w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it
+++ a/drivers/w1/slaves/w1_ds2780.c
@@ -99,43 +99,7 @@ static struct bin_attribute w1_ds2780_bi
 	.read = w1_ds2780_read_bin,
 };
 
-static DEFINE_IDR(bat_idr);
-static DEFINE_MUTEX(bat_idr_lock);
-
-static int new_bat_id(void)
-{
-	int ret;
-
-	while (1) {
-		int id;
-
-		ret = idr_pre_get(&bat_idr, GFP_KERNEL);
-		if (ret == 0)
-			return -ENOMEM;
-
-		mutex_lock(&bat_idr_lock);
-		ret = idr_get_new(&bat_idr, NULL, &id);
-		mutex_unlock(&bat_idr_lock);
-
-		if (ret == 0) {
-			ret = id & MAX_ID_MASK;
-			break;
-		} else if (ret == -EAGAIN) {
-			continue;
-		} else {
-			break;
-		}
-	}
-
-	return ret;
-}
-
-static void release_bat_id(int id)
-{
-	mutex_lock(&bat_idr_lock);
-	idr_remove(&bat_idr, id);
-	mutex_unlock(&bat_idr_lock);
-}
+static DEFINE_IDA(bat_ida);
 
 static int w1_ds2780_add_slave(struct w1_slave *sl)
 {
@@ -143,7 +107,7 @@ static int w1_ds2780_add_slave(struct w1
 	int id;
 	struct platform_device *pdev;
 
-	id = new_bat_id();
+	id = ida_simple_get(&bat_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
 		ret = id;
 		goto noid;
@@ -172,7 +136,7 @@ bin_attr_failed:
 pdev_add_failed:
 	platform_device_unregister(pdev);
 pdev_alloc_failed:
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 noid:
 	return ret;
 }
@@ -183,7 +147,7 @@ static void w1_ds2780_remove_slave(struc
 	int id = pdev->id;
 
 	platform_device_unregister(pdev);
-	release_bat_id(id);
+	ida_simple_remove(&bat_ida, id);
 	sysfs_remove_bin_file(&sl->dev.kobj, &w1_ds2780_bin_attr);
 }
 
@@ -199,14 +163,14 @@ static struct w1_family w1_ds2780_family
 
 static int __init w1_ds2780_init(void)
 {
-	idr_init(&bat_idr);
+	ida_init(&bat_ida);
 	return w1_register_family(&w1_ds2780_family);
 }
 
 static void __exit w1_ds2780_exit(void)
 {
 	w1_unregister_family(&w1_ds2780_family);
-	idr_destroy(&bat_idr);
+	ida_destroy(&bat_ida);
 }
 
 module_init(w1_ds2780_init);
_

Patches currently in -mm which might be from jic23@cam.ac.uk are

origin.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch

