From: akpm@linux-foundation.org
Subject: - acpi-thermal-trip-points-increased-to-12.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:24 -0700
Message-ID: <200804162255.m3GMtOqP011115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752275AbYDPW4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, lenb@kernel.org, rjw@sisk.pl, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi thermal trip points increased to 12
has been removed from the -mm tree.  Its filename was
     acpi-thermal-trip-points-increased-to-12.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi thermal trip points increased to 12
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The THERMAL_MAX_TRIPS value is set to 10.  It is too few for the Compaq AP550
machine which has 12 trip points.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Len Brown <lenb@kernel.org>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal.c |    4 ++++
 include/linux/thermal.h   |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/thermal/thermal.c~acpi-thermal-trip-points-increased-to-12 drivers/thermal/thermal.c
--- a/drivers/thermal/thermal.c~acpi-thermal-trip-points-increased-to-12
+++ a/drivers/thermal/thermal.c
@@ -196,6 +196,10 @@ static struct device_attribute trip_poin
 	__ATTR(trip_point_8_temp, 0444, trip_point_temp_show, NULL),
 	__ATTR(trip_point_9_type, 0444, trip_point_type_show, NULL),
 	__ATTR(trip_point_9_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_10_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_10_temp, 0444, trip_point_temp_show, NULL),
+	__ATTR(trip_point_11_type, 0444, trip_point_type_show, NULL),
+	__ATTR(trip_point_11_temp, 0444, trip_point_temp_show, NULL),
 };
 
 #define TRIP_POINT_ATTR_ADD(_dev, _index, result)     \
diff -puN include/linux/thermal.h~acpi-thermal-trip-points-increased-to-12 include/linux/thermal.h
--- a/include/linux/thermal.h~acpi-thermal-trip-points-increased-to-12
+++ a/include/linux/thermal.h
@@ -50,7 +50,7 @@ struct thermal_cooling_device_ops {
 };
 
 #define THERMAL_TRIPS_NONE -1
-#define THERMAL_MAX_TRIPS 10
+#define THERMAL_MAX_TRIPS 12
 #define THERMAL_NAME_LENGTH 20
 struct thermal_cooling_device {
 	int id;
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
pm2fb-correct-error-values-returned-from-probe-function.patch
pm2fb-change-option-mode-to-mode_option.patch
tridentfb-change-option-mode-to-mode_option.patch
pm3fb-change-option-mode-to-mode_option.patch
update-modedbtxt-documentation-about-mode_option-parameter-change.patch
vt8623fb-change-option-mode-to-mode_option.patch
arkfb-add-option-mode_option.patch
s3fb-add-option-mode_option.patch
fbdev-add-removed-option-mode-to-keep-compatibility.patch
video-replace-remaining-__function__-occurrences.patch

