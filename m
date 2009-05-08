From: akpm@linux-foundation.org
Subject: + acpi-thermal-fix-off-by-1-error-in-trip-point-trigger-condition.patch added to -mm tree
Date: Fri, 08 May 2009 12:13:12 -0700
Message-ID: <200905081913.n48JDCte019879@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754813AbZEHTQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2009 15:16:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eightgraph@gmail.com, lenb@kernel.org, rui.zhang@intel.com


The patch titled
     acpi thermal: fix off-by-1 error in trip point trigger condition
has been added to the -mm tree.  Its filename is
     acpi-thermal-fix-off-by-1-error-in-trip-point-trigger-condition.patch

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
Subject: acpi thermal: fix off-by-1 error in trip point trigger condition
From: Vladimir Zajac <eightgraph@gmail.com>

Fix a regression caused by commit b1569e99c795bf83b4ddf41c4f1c42761ab7f75e
("ACPI: move thermal trip handling to generic thermal layer") which
accidentally changed trip point trigger condition to temp > trip_temp

This patch changes the trigger condition back to
  temp >= trip_temp

Signed-off-by: Vladimir Zajac <eightgraph@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~acpi-thermal-fix-off-by-1-error-in-trip-point-trigger-condition drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~acpi-thermal-fix-off-by-1-error-in-trip-point-trigger-condition
+++ a/drivers/thermal/thermal_sys.c
@@ -961,7 +961,7 @@ void thermal_zone_device_update(struct t
 
 		switch (trip_type) {
 		case THERMAL_TRIP_CRITICAL:
-			if (temp > trip_temp) {
+			if (temp >= trip_temp) {
 				if (tz->ops->notify)
 					ret = tz->ops->notify(tz, count,
 							      trip_type);
@@ -974,7 +974,7 @@ void thermal_zone_device_update(struct t
 			}
 			break;
 		case THERMAL_TRIP_HOT:
-			if (temp > trip_temp)
+			if (temp >= trip_temp)
 				if (tz->ops->notify)
 					tz->ops->notify(tz, count, trip_type);
 			break;
@@ -986,14 +986,14 @@ void thermal_zone_device_update(struct t
 
 				cdev = instance->cdev;
 
-				if (temp > trip_temp)
+				if (temp >= trip_temp)
 					cdev->ops->set_cur_state(cdev, 1);
 				else
 					cdev->ops->set_cur_state(cdev, 0);
 			}
 			break;
 		case THERMAL_TRIP_PASSIVE:
-			if (temp > trip_temp || tz->passive)
+			if (temp >= trip_temp || tz->passive)
 				thermal_zone_device_passive(tz, temp,
 							    trip_temp, count);
 			break;
_

Patches currently in -mm which might be from eightgraph@gmail.com are

acpi-thermal-fix-off-by-1-error-in-trip-point-trigger-condition.patch

