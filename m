From: akpm@linux-foundation.org
Subject: [nacked] thermal-add-sanity-check-for-the-passive-attribute.patch removed from -mm tree
Date: Tue, 17 Nov 2009 14:48:02 -0800
Message-ID: <200911172248.nAHMm3AE007264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558AbZKQWuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Nov 2009 17:50:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: elendil@planet.nl, lenb@kernel.org, mjg@redhat.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     thermal: add sanity check for the passive attribute
has been removed from the -mm tree.  Its filename was
     thermal-add-sanity-check-for-the-passive-attribute.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal: add sanity check for the passive attribute
From: Frans Pop <elendil@planet.nl>

Values below 1000 milli-celsius don't make sense and can cause the system
to go into a thermal heart attack: the actual temperature will always be
lower and thus the system will be throttled down to its lowest setting.

An additional problem is that values below 1000 will show as 0 in
/proc/acpi/thermal/TZx/trip_points:passive.

cat passive
0
echo -n 90 >passive
bash: echo: write error: Invalid argument
echo -n 90000 >passive
cat passive
90000

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13918

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/thermal/sysfs-api.txt |    1 +
 drivers/thermal/thermal_sys.c       |    6 ++++++
 2 files changed, 7 insertions(+)

diff -puN Documentation/thermal/sysfs-api.txt~thermal-add-sanity-check-for-the-passive-attribute Documentation/thermal/sysfs-api.txt
--- a/Documentation/thermal/sysfs-api.txt~thermal-add-sanity-check-for-the-passive-attribute
+++ a/Documentation/thermal/sysfs-api.txt
@@ -206,6 +206,7 @@ passive
 	passive trip point for the zone. Activation is done by polling with
 	an interval of 1 second.
 	Unit: millidegrees Celsius
+	Valid values: 0 (disabled) or greater than 1000
 	RW, Optional
 
 *****************************
diff -puN drivers/thermal/thermal_sys.c~thermal-add-sanity-check-for-the-passive-attribute drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-add-sanity-check-for-the-passive-attribute
+++ a/drivers/thermal/thermal_sys.c
@@ -225,6 +225,12 @@ passive_store(struct device *dev, struct
 	if (!sscanf(buf, "%d\n", &state))
 		return -EINVAL;
 
+	/* sanity check: values below 1000 millicelcius don't make sense
+	 * and can cause the system to go into a thermal heart attack
+	 */
+	if (state && state < 1000)
+		return -EINVAL;
+
 	if (state && !tz->forced_passive) {
 		mutex_lock(&thermal_list_lock);
 		list_for_each_entry(cdev, &thermal_cdev_list, node) {
_

Patches currently in -mm which might be from elendil@planet.nl are

linux-next.patch
acpi-thermal-display-forced-passive-trip-points-in-proc.patch
thermal-add-sanity-check-for-the-passive-attribute.patch
thermal-only-set-passive_delay-for-forced_passive-cooling.patch
thermal-disable-polling-if-passive_delay-and-polling_delay-are-both-unset.patch
page-allocator-wait-on-both-sync-and-async-congestion-after-direct-reclaim.patch
vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch

