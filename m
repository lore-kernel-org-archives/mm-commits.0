From: akpm@linux-foundation.org
Subject: + thermal-constify-type-argument-for-the-registration-routine.patch added to -mm tree
Date: Tue, 19 Jun 2012 17:11:32 -0700
Message-ID: <20120620001132.A4589A0353@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:37226 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab2FTALe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jun 2012 20:11:34 -0400
Received: by vbnl22 with SMTP id l22so624143vbn.1
        for <mm-commits@vger.kernel.org>; Tue, 19 Jun 2012 17:11:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton.vorontsov@linaro.org, cbouatmailru@gmail.com, khali@linux-fr.org, len.brown@intel.com


The patch titled
     Subject: thermal: constify 'type' argument for the registration routine
has been added to the -mm tree.  Its filename is
     thermal-constify-type-argument-for-the-registration-routine.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1215,7 +1215,7 @@ static int create_trip_hyst_attr(struct 
  * longer needed. The passive cooling formula uses tc1 and tc2 as described in
  * section 11.1.5.1 of the ACPI specification 3.0.
  */
-struct thermal_zone_device *thermal_zone_device_register(char *type,
+struct thermal_zone_device *thermal_zone_device_register(const char *type,
 	int trips, int flag, void *devdata,
 	const struct thermal_zone_device_ops *ops,
 	int tc1, int tc2, int passive_delay, int polling_delay)
diff -puN include/linux/thermal.h~thermal-constify-type-argument-for-the-registration-routine include/linux/thermal.h
--- a/include/linux/thermal.h~thermal-constify-type-argument-for-the-registration-routine
+++ a/include/linux/thermal.h
@@ -146,7 +146,8 @@ enum {
 };
 #define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
 
-struct thermal_zone_device *thermal_zone_device_register(char *, int, int,
+struct thermal_zone_device *
+thermal_zone_device_register(const char *, int, int,
 		void *, const struct thermal_zone_device_ops *, int tc1,
 		int tc2, int passive_freq, int polling_freq);
 void thermal_zone_device_unregister(struct thermal_zone_device *);
_
Subject: Subject: thermal: constify 'type' argument for the registration routine

Patches currently in -mm which might be from anton.vorontsov@linaro.org are

linux-next.patch
thermal-constify-type-argument-for-the-registration-routine.patch

