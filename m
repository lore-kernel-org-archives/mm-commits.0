From: akpm@linux-foundation.org
Subject: + acpi-thermal-fix-result-check.patch added to -mm tree
Date: Mon, 07 Apr 2008 14:34:08 -0700
Message-ID: <200804072134.m37LY8sD026259@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754118AbYDGVe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2008 17:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: krzysztof.h1@wp.pl, lenb@kernel.org, rjw@sisk.pl


The patch titled
     acpi thermal: fix result check
has been added to the -mm tree.  Its filename is
     acpi-thermal-fix-result-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi thermal: fix result check
From: Krzysztof Helt <krzysztof.h1@wp.pl>

The thermal_zone_device_register() uses ERR_PTR macro to return values.  A
correct check is to use the IS_ERR macro.

The 2.6.25 kernels panic on Compaq AP550 without this patch as it has more
then 10 (THERMAL_MAX_TRIPS) trip points (there are 12).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>
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

acpi-thermal-fix-result-check.patch
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

