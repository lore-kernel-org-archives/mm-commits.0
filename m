From: akpm@linux-foundation.org
Subject: [merged] thermal_sys-kernel-style-cleanups.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:43 -0700
Message-ID: <20120323182243.5943DA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:38796 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759169Ab2CWSWo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:44 -0400
Received: by yhgm50 with SMTP id m50so540065yhg.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jj@chaosbits.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal_sys: kernel style cleanups
has been removed from the -mm tree.  Its filename was
     thermal_sys-kernel-style-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
-
 EXPORT_SYMBOL(thermal_zone_device_unregister);
 
 #ifdef CONFIG_NET
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
get_maintainer-use-a-default-unknown-s-status-role.patch
get_maintainerpl-add-support-for-moderated-lists.patch
maintainers-fix-remoteproc-f-typo.patch
maintainers-update-mca-section.patch
maintainers-update-git-urls-for-26-deletions.patch
maintainers-add-status-to-alpha-architecture.patch
maintainers-add-s-maintained-to-clkdev-and-clk-sections.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch
checkpatch-add-some-strict-coding-style-checks.patch
checkpatch-add-some-strict-coding-style-checks-v3.patch
checkpatchpl-be-silent-when-q-and-ignore-is-given.patch
checkpatch-catch-usage-when-not-at-the-beginning-of-defination.patch
checkpatch-allow-simple-character-constants-in-defines.patch
checkpatch-handle-string-concatenation-in-simple-defines.patch
checkpatch-high-precidence-operators-do-not-require-additional-parentheses-in-defines.patch
checkpatch-add-to-type-extensions.patch
checkpatch-add-strict-tests-for-braces-comments-and-casts.patch
checkpatch-add-strict-test-for-strings-split-across-multiple-lines.patch
checkpatch-warn-on-use-of-yield.patch
checkpatch-whitespace-add-remove-blank-lines.patch
checkpatch-check-for-quoted-strings-broken-across-lines.patch
checkpatch-suggest-pr_level-over-printkkern_level.patch

