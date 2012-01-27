From: akpm@linux-foundation.org
Subject: + thermal_sys-remove-obfuscating-used-once-macros.patch added to -mm tree
Date: Thu, 26 Jan 2012 16:55:03 -0800
Message-ID: <20120127005503.D8012A049C@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:45730 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2A0A5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 19:57:46 -0500
Received: by ggnk1 with SMTP id k1so139715ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 16:57:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, jj@chaosbits.net, lenb@kernel.org


The patch titled
     Subject: thermal_sys: remove obfuscating used-once macros
has been added to the -mm tree.  Its filename is
     thermal_sys-remove-obfuscating-used-once-macros.patch

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
Subject: thermal_sys: remove obfuscating used-once macros

These don't add any value as they are used only once and the surrounding
code uses similar variable.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Jesper Juhl <jj@chaosbits.net>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |   32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal_sys-remove-obfuscating-used-once-macros drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal_sys-remove-obfuscating-used-once-macros
+++ a/drivers/thermal/thermal_sys.c
@@ -310,22 +310,6 @@ static struct device_attribute trip_poin
 	__ATTR(trip_point_11_temp, 0444, trip_point_temp_show, NULL),
 };
 
-#define TRIP_POINT_ATTR_ADD(_dev, _index, result)     \
-do {    \
-	result = device_create_file(_dev,	\
-				&trip_point_attrs[_index * 2]);	\
-	if (result)	\
-		break;	\
-	result = device_create_file(_dev,	\
-			&trip_point_attrs[_index * 2 + 1]);	\
-} while (0)
-
-#define TRIP_POINT_ATTR_REMOVE(_dev, _index)	\
-do {	\
-	device_remove_file(_dev, &trip_point_attrs[_index * 2]);	\
-	device_remove_file(_dev, &trip_point_attrs[_index * 2 + 1]);	\
-} while (0)
-
 /* sys I/F for cooling device */
 #define to_cooling_device(_dev)	\
 	container_of(_dev, struct thermal_cooling_device, device)
@@ -1196,7 +1180,12 @@ struct thermal_zone_device *thermal_zone
 	}
 
 	for (count = 0; count < trips; count++) {
-		TRIP_POINT_ATTR_ADD(&tz->device, count, result);
+		result = device_create_file(&tz->device,
+					    &trip_point_attrs[count * 2]);
+		if (result)
+			break;
+		result = device_create_file(&tz->device,
+					    &trip_point_attrs[count * 2 + 1]);
 		if (result)
 			goto unregister;
 		tz->ops->get_trip_type(tz, count, &trip_type);
@@ -1276,9 +1265,12 @@ void thermal_zone_device_unregister(stru
 	if (tz->ops->get_mode)
 		device_remove_file(&tz->device, &dev_attr_mode);
 
-	for (count = 0; count < tz->trips; count++)
-		TRIP_POINT_ATTR_REMOVE(&tz->device, count);
-
+	for (count = 0; count < tz->trips; count++) {
+		device_remove_file(&tz->device,
+				   &trip_point_attrs[count * 2]);
+		device_remove_file(&tz->device,
+				   &trip_point_attrs[count * 2 + 1]);
+	}
 	thermal_remove_hwmon_sysfs(tz);
 	release_idr(&thermal_tz_idr, &thermal_idr_lock, tz->id);
 	idr_destroy(&tz->idr);
_
Subject: Subject: thermal_sys: remove obfuscating used-once macros

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-update-partitions-block-f-patterns.patch
maintainers-remove-imx5-section.patch
maintainers-remove-staging-sections.patch
maintainers-update-lguest-f-patterns.patch
linux-next.patch
thermal_sys-remove-unnecessary-line-continuations.patch
thermal_sys-remove-obfuscating-used-once-macros.patch
thermal_sys-kernel-style-cleanups.patch
thermal_sys-convert-printks-to-pr_level.patch
maintainers-staging-cx25821-add-l-linux-media.patch
maintainers-fix-remoteproc-f-typo.patch
include-and-checkpatch-prefer-__scanf-to-__attribute__formatscanf.patch

