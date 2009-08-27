From: akpm@linux-foundation.org
Subject: [merged] thermal_sys-check-get_temp-return-value.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:24 -0700
Message-ID: <200908271918.n7RJIOL2010145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZH0TT1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:19:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mibru@gmx.de, lenb@kernel.org, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     thermal_sys: check get_temp return value
has been removed from the -mm tree.  Its filename was
     thermal_sys-check-get_temp-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal_sys: check get_temp return value
From: Michael Brunner <mibru@gmx.de>

The return value of the get_temp function is not checked when doing a
thermal zone update.  This may lead to a critical shutdown if get_temp
fails and the content of the temp variable is incorrectly set higher than
the critical trip point.

This has been observed on a system with incorrect ACPI implementation
where the corresponding methods were not serialized and therefore
sometimes triggered ACPI errors (AE_ALREADY_EXISTS).  The following
critical shutdowns indicated a temperature of 2097 C, which was obviously
wrong.

The patch adds a return value check that jumps over all trip point
evaluations printing a warning if get_temp fails.  The trip points are
evaluated again on the next polling interval with successful get_temp
execution.

Signed-off-by: Michael Brunner <mibru@gmx.de>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/thermal/thermal_sys.c~thermal_sys-check-get_temp-return-value drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal_sys-check-get_temp-return-value
+++ a/drivers/thermal/thermal_sys.c
@@ -953,7 +953,12 @@ void thermal_zone_device_update(struct t
 
 	mutex_lock(&tz->lock);
 
-	tz->ops->get_temp(tz, &temp);
+	if (tz->ops->get_temp(tz, &temp)) {
+		/* get_temp failed - retry it later */
+		printk(KERN_WARNING PREFIX "failed to read out thermal zone "
+		       "%d\n", tz->id);
+		goto leave;
+	}
 
 	for (count = 0; count < tz->trips; count++) {
 		tz->ops->get_trip_type(tz, count, &trip_type);
@@ -1005,6 +1010,8 @@ void thermal_zone_device_update(struct t
 					    THERMAL_TRIPS_NONE);
 
 	tz->last_temperature = temp;
+
+      leave:
 	if (tz->passive)
 		thermal_zone_device_set_polling(tz, tz->passive_delay);
 	else if (tz->polling_delay)
_

Patches currently in -mm which might be from mibru@gmx.de are

origin.patch
linux-next.patch

