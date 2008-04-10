From: akpm@linux-foundation.org
Subject: - acpi-thermal-fix-result-check.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:00:48 -0700
Message-ID: <200804102000.m3AK0m0G014923@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbYDJUBl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:01:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krzysztof.h1@wp.pl, lenb@kernel.org, rjw@sisk.pl, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi thermal: fix result check
has been removed from the -mm tree.  Its filename was
     acpi-thermal-fix-result-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi thermal: fix result check
From: Krzysztof Helt <krzysztof.h1@wp.pl>

thermal_zone_device_register() uses the ERR_PTR macro on its return values.  A
correct check is to use the IS_ERR() macro.

The 2.6.25 kernels panic on Compaq AP550 without this patch as it has more
then 10 (THERMAL_MAX_TRIPS) trip points (there are 12).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/thermal.c~acpi-thermal-fix-result-check drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~acpi-thermal-fix-result-check
+++ a/drivers/acpi/thermal.c
@@ -1125,7 +1125,7 @@ static int acpi_thermal_register_thermal
 			tz->trips.active[i].flags.valid; i++, trips++);
 	tz->thermal_zone = thermal_zone_device_register("ACPI thermal zone",
 					trips, tz, &acpi_thermal_zone_ops);
-	if (!tz->thermal_zone)
+	if (IS_ERR(tz->thermal_zone))
 		return -ENODEV;
 
 	result = sysfs_create_link(&tz->device->dev.kobj,
_

Patches currently in -mm which might be from krzysztof.h1@wp.pl are

origin.patch
acpi-thermal-trip-points-increased-to-12.patch
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

