From: akpm@linux-foundation.org
Subject: + w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch added to -mm tree
Date: Thu, 28 Jul 2011 15:48:54 -0700
Message-ID: <201107282248.p6SMmsiB013057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498Ab1G1WtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 18:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jic23@cam.ac.uk, zbr@ioremap.net


The patch titled
     w1: ds2760 and ds2780, use ida for id and ida_simple_get() to get it
has been added to the -mm tree.  Its filename is
     w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: ds2760 and ds2780, use ida for id and ida_simple_get() to get it
From: Jonathan Cameron <jic23@cam.ac.uk>

Straightforward.  As an aside, the ida_init calls are not needed as far as
I can see needed.  (DEFINE_IDA does the same already).

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
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
ida-simplified-functions-for-id-allocation.patch
hwmon-convert-idr-to-ida-and-use-ida_simple-interface.patch
drivers-hwmon-hwmonc-convert-idr-to-ida-and-use-ida_simple_get.patch
drivers-scsi-sdc-use-ida_simple_get-and-ida_simple_remove-in-place-of-boilerplate-code.patch
drm-vmwgfx-use-ida_simple_get-for-id-allocation.patch
drivers-scsi-osd-osd_uldc-use-ida_simple_get-to-handle-id.patch
w1-ds2760-and-ds2780-use-ida-for-id-and-ida_simple_get-to-get-it.patch
drivers-rtc-classc-convert-idr-to-ida-and-use-ida_simple_get.patch
linux-next.patch

