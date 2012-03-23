From: akpm@linux-foundation.org
Subject: [merged] thermal_sys-remove-obfuscating-used-once-macros.patch removed from -mm tree
Date: Fri, 23 Mar 2012 11:22:41 -0700
Message-ID: <20120323182241.616E9A02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:51163 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079Ab2CWSWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 14:22:43 -0400
Received: by bkcjm19 with SMTP id jm19so183786bkc.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 11:22:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jj@chaosbits.net, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal_sys: remove obfuscating used-once macros
has been removed from the -mm tree.  Its filename was
     thermal_sys-remove-obfuscating-used-once-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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

