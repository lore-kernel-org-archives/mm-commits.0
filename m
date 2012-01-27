From: akpm@linux-foundation.org
Subject: + thermal_sys-kernel-style-cleanups.patch added to -mm tree
Date: Thu, 26 Jan 2012 16:55:05 -0800
Message-ID: <20120127005505.DF478A049C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:49909 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754532Ab2A0AzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 19:55:08 -0500
Received: by eaaf1 with SMTP id f1so62993eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 16:55:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jj@chaosbits.net, lenb@kernel.org


The patch titled
     Subject: thermal_sys: kernel style cleanups
has been added to the -mm tree.  Its filename is
     thermal_sys-kernel-style-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: thermal_sys: kernel style cleanups

Just a few tidies to make it more like most kernel sources.

A couple of long lines still remain.

Signed-off-by: Joe Perches <joe@perches.com>
Reviewed-by: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal_sys-kernel-style-cleanups drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal_sys-kernel-style-cleanups
+++ a/drivers/thermal/thermal_sys.c
@@ -64,7 +64,7 @@ static int get_idr(struct idr *idr, stru
 {
 	int err;
 
-      again:
+again:
 	if (unlikely(idr_pre_get(idr, GFP_KERNEL) == 0))
 		return -ENOMEM;
 
@@ -816,15 +816,14 @@ int thermal_zone_bind_cooling_device(str
 		return 0;
 
 	device_remove_file(&tz->device, &dev->attr);
-      remove_symbol_link:
+remove_symbol_link:
 	sysfs_remove_link(&tz->device.kobj, dev->name);
-      release_idr:
+release_idr:
 	release_idr(&tz->idr, &tz->lock, dev->id);
-      free_mem:
+free_mem:
 	kfree(dev);
 	return result;
 }
-
 EXPORT_SYMBOL(thermal_zone_bind_cooling_device);
 
 /**
@@ -854,14 +853,13 @@ int thermal_zone_unbind_cooling_device(s
 
 	return -ENODEV;
 
-      unbind:
+unbind:
 	device_remove_file(&tz->device, &pos->attr);
 	sysfs_remove_link(&tz->device.kobj, pos->name);
 	release_idr(&tz->idr, &tz->lock, pos->id);
 	kfree(pos);
 	return 0;
 }
-
 EXPORT_SYMBOL(thermal_zone_unbind_cooling_device);
 
 static void thermal_release(struct device *dev)
@@ -869,7 +867,8 @@ static void thermal_release(struct devic
 	struct thermal_zone_device *tz;
 	struct thermal_cooling_device *cdev;
 
-	if (!strncmp(dev_name(dev), "thermal_zone", sizeof "thermal_zone" - 1)) {
+	if (!strncmp(dev_name(dev), "thermal_zone",
+		     sizeof("thermal_zone") - 1)) {
 		tz = to_thermal_zone(dev);
 		kfree(tz);
 	} else {
@@ -889,8 +888,9 @@ static struct class thermal_class = {
  * @devdata:	device private data.
  * @ops:		standard thermal cooling devices callbacks.
  */
-struct thermal_cooling_device *thermal_cooling_device_register(
-     char *type, void *devdata, const struct thermal_cooling_device_ops *ops)
+struct thermal_cooling_device *
+thermal_cooling_device_register(char *type, void *devdata,
+				const struct thermal_cooling_device_ops *ops)
 {
 	struct thermal_cooling_device *cdev;
 	struct thermal_zone_device *pos;
@@ -955,12 +955,11 @@ struct thermal_cooling_device *thermal_c
 	if (!result)
 		return cdev;
 
-      unregister:
+unregister:
 	release_idr(&thermal_cdev_idr, &thermal_idr_lock, cdev->id);
 	device_unregister(&cdev->device);
 	return ERR_PTR(result);
 }
-
 EXPORT_SYMBOL(thermal_cooling_device_register);
 
 /**
@@ -1005,7 +1004,6 @@ void thermal_cooling_device_unregister(s
 	device_unregister(&cdev->device);
 	return;
 }
-
 EXPORT_SYMBOL(thermal_cooling_device_unregister);
 
 /**
@@ -1081,7 +1079,7 @@ void thermal_zone_device_update(struct t
 
 	tz->last_temperature = temp;
 
-      leave:
+leave:
 	if (tz->passive)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
 	else if (tz->polling_delay)
@@ -1221,12 +1219,11 @@ struct thermal_zone_device *thermal_zone
 	if (!result)
 		return tz;
 
-      unregister:
+unregister:
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	device_unregister(&tz->device);
 	return ERR_PTR(result);
 }
-
 EXPORT_SYMBOL(thermal_zone_device_register);
 
 /**
@@ -1278,7 +1275,6 @@ void thermal_zone_device_unregister(stru
 	device_unregister(&tz->device);
 	return;
 }
