From: akpm@linux-foundation.org
Subject: [merged] thermal-split-hwmon-lookup-to-a-separate-function.patch removed from -mm tree
Date: Wed, 03 Aug 2011 11:59:50 -0700
Message-ID: <201108031857.p73IvJfj006726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab1HCS6D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2011 14:58:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, guenter.roeck@ericsson.com, len.brown@intel.com, rene.herman@gmail.com, mm-commits@vger.kernel.org


The patch titled
     thermal: split hwmon lookup to a separate function
has been removed from the -mm tree.  Its filename was
     thermal-split-hwmon-lookup-to-a-separate-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal: split hwmon lookup to a separate function
From: Jean Delvare <khali@linux-fr.org>

We'll soon need to reuse it.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-split-hwmon-lookup-to-a-separate-function drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-split-hwmon-lookup-to-a-separate-function
+++ a/drivers/thermal/thermal_sys.c
@@ -469,22 +469,35 @@ temp_crit_show(struct device *dev, struc
 }
 
 
-static int
-thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
+static struct thermal_hwmon_device *
+thermal_hwmon_lookup_by_type(const struct thermal_zone_device *tz)
 {
 	struct thermal_hwmon_device *hwmon;
-	int new_hwmon_device = 1;
-	int result;
 
 	mutex_lock(&thermal_list_lock);
 	list_for_each_entry(hwmon, &thermal_hwmon_list, node)
 		if (!strcmp(hwmon->type, tz->type)) {
-			new_hwmon_device = 0;
 			mutex_unlock(&thermal_list_lock);
-			goto register_sys_interface;
+			return hwmon;
 		}
 	mutex_unlock(&thermal_list_lock);
 
+	return NULL;
+}
+
+static int
+thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
+{
+	struct thermal_hwmon_device *hwmon;
+	int new_hwmon_device = 1;
+	int result;
+
+	hwmon = thermal_hwmon_lookup_by_type(tz);
+	if (hwmon) {
+		new_hwmon_device = 0;
+		goto register_sys_interface;
+	}
+
 	hwmon = kzalloc(sizeof(struct thermal_hwmon_device), GFP_KERNEL);
 	if (!hwmon)
 		return -ENOMEM;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
linux-next.patch
drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

