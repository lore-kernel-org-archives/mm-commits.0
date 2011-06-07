From: akpm@linux-foundation.org
Subject: + thermal-split-hwmon-lookup-to-a-separate-function.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:13:03 -0700
Message-ID: <201106072313.p57ND3cg000844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48869 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759002Ab1FGXNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, guenter.roeck@ericsson.com, len.brown@intel.com, rene.herman@gmail.com


The patch titled
     thermal: split hwmon lookup to a separate function
has been added to the -mm tree.  Its filename is
     thermal-split-hwmon-lookup-to-a-separate-function.patch

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

linux-next.patch
thermal-hide-config_thermal_hwmon.patch
thermal-split-hwmon-lookup-to-a-separate-function.patch
thermal-make-thermal_hwmon-implementation-fully-internal.patch
drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

