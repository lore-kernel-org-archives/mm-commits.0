From: akpm@linux-foundation.org
Subject: + rtc-isl1208-use-sysfs_create-remove_group.patch added to -mm tree
Date: Wed, 21 Apr 2010 11:11:28 -0700
Message-ID: <201004211811.o3LIBSPY000962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50128 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753426Ab0DUSMF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 14:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, a.zummo@towertech.it, hsweeten@visionengravers.com, p_gortmaker@yahoo.com


The patch titled
     rtc-isl1208: use sysfs_{create/remove}_group
has been added to the -mm tree.  Its filename is
     rtc-isl1208-use-sysfs_create-remove_group.patch

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
Subject: rtc-isl1208: use sysfs_{create/remove}_group
From: H Hartley Sweeten <hartleys@visionengravers.com>

Instead of individually creating and removing the sysfs device attribute
files, wrap them in an attribute_group and use
sysfs_{create/remove}_group.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-isl1208.c |   45 ++++++++----------------------------
 1 file changed, 11 insertions(+), 34 deletions(-)

diff -puN drivers/rtc/rtc-isl1208.c~rtc-isl1208-use-sysfs_create-remove_group drivers/rtc/rtc-isl1208.c
--- a/drivers/rtc/rtc-isl1208.c~rtc-isl1208-use-sysfs_create-remove_group
+++ a/drivers/rtc/rtc-isl1208.c
@@ -462,39 +462,16 @@ isl1208_sysfs_store_usr(struct device *d
 static DEVICE_ATTR(usr, S_IRUGO | S_IWUSR, isl1208_sysfs_show_usr,
 		   isl1208_sysfs_store_usr);
 
-static int
-isl1208_sysfs_register(struct device *dev)
-{
-	int err;
-
-	err = device_create_file(dev, &dev_attr_atrim);
-	if (err)
-		return err;
-
-	err = device_create_file(dev, &dev_attr_dtrim);
-	if (err) {
-		device_remove_file(dev, &dev_attr_atrim);
-		return err;
-	}
-
-	err = device_create_file(dev, &dev_attr_usr);
-	if (err) {
-		device_remove_file(dev, &dev_attr_atrim);
-		device_remove_file(dev, &dev_attr_dtrim);
-	}
-
-	return 0;
-}
-
-static int
-isl1208_sysfs_unregister(struct device *dev)
-{
-	device_remove_file(dev, &dev_attr_dtrim);
-	device_remove_file(dev, &dev_attr_atrim);
-	device_remove_file(dev, &dev_attr_usr);
+static struct attribute *isl1208_rtc_attrs[] = {
+	&dev_attr_atrim.attr,
+	&dev_attr_dtrim.attr,
+	&dev_attr_usr.attr,
+	NULL
+};
 
-	return 0;
-}
+static const struct attribute_group isl1208_rtc_sysfs_files = {
+	.attrs	= isl1208_rtc_attrs,
+};
 
 static int
 isl1208_probe(struct i2c_client *client, const struct i2c_device_id *id)
@@ -529,7 +506,7 @@ isl1208_probe(struct i2c_client *client,
 		dev_warn(&client->dev, "rtc power failure detected, "
 			 "please set clock.\n");
 
-	rc = isl1208_sysfs_register(&client->dev);
+	rc = sysfs_create_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
 	if (rc)
 		goto exit_unregister;
 
@@ -546,7 +523,7 @@ isl1208_remove(struct i2c_client *client
 {
 	struct rtc_device *rtc = i2c_get_clientdata(client);
 
-	isl1208_sysfs_unregister(&client->dev);
+	sysfs_remove_group(&client->dev.kobj, &isl1208_rtc_sysfs_files);
 	rtc_device_unregister(rtc);
 
 	return 0;
_

Patches currently in -mm which might be from hartleys@visionengravers.com are

linux-next.patch
scsi-sdc-quiet-all-sparse-noise.patch
fs-writebackc-bitfields-should-be-unsigned.patch
rtc-isl1208-use-sysfs_create-remove_group.patch

