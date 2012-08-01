From: akpm@linux-foundation.org
Subject: [merged] thermal-constify-type-argument-for-the-registration-routine.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:19:25 -0700
Message-ID: <20120801201925.C69B21E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:52099 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab2HAUT0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:19:26 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5412588obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:19:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton.vorontsov@linaro.org, cbouatmailru@gmail.com, khali@linux-fr.org, len.brown@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thermal: constify 'type' argument for the registration routine
has been removed from the -mm tree.  Its filename was
     thermal-constify-type-argument-for-the-registration-routine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: thermal: constify 'type' argument for the registration routine

thermal_zone_device_register() does not modify 'type' argument, so it is
safe to declare it as const.  Otherwise, if we pass a const string, we are
getting the ugly warning:

  CC      drivers/power/power_supply_core.o
drivers/power/power_supply_core.c: In function 'psy_register_thermal':
drivers/power/power_supply_core.c:204:6: warning: passing argument 1 of `thermal_zone_device_register' discards 'const' qualifier from pointer target type [enabled by default]
include/linux/thermal.h:140:29: note: expected 'char *' but argument is of type 'const char *'

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    2 +-
 include/linux/thermal.h       |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-constify-type-argument-for-the-registration-routine drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-constify-type-argument-for-the-registration-routine
+++ a/drivers/thermal/thermal_sys.c
@@ -1251,7 +1251,7 @@ static void remove_trip_attrs(struct the
  * longer needed. The passive cooling formula uses tc1 and tc2 as described in
  * section 11.1.5.1 of the ACPI specification 3.0.
  */
-struct thermal_zone_device *thermal_zone_device_register(char *type,
+struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int trips, int mask, void *devdata,
 	const struct thermal_zone_device_ops *ops,
 	int tc1, int tc2, int passive_delay, int polling_delay)
diff -puN include/linux/thermal.h~thermal-constify-type-argument-for-the-registration-routine include/linux/thermal.h
--- a/include/linux/thermal.h~thermal-constify-type-argument-for-the-registration-routine
+++ a/include/linux/thermal.h
@@ -151,7 +151,8 @@ enum {
 };
 #define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
 
-struct thermal_zone_device *thermal_zone_device_register(char *, int, int,
+struct thermal_zone_device *
+thermal_zone_device_register(const char *, int, int,
 		void *, const struct thermal_zone_device_ops *, int tc1,
 		int tc2, int passive_freq, int polling_freq);
 void thermal_zone_device_unregister(struct thermal_zone_device *);
_

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

origin.patch
linux-next.patch

