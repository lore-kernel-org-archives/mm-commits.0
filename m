From: akpm@linux-foundation.org
Subject: + thermal-make-thermal_hwmon-implementation-fully-internal.patch added to -mm tree
Date: Tue, 07 Jun 2011 16:13:05 -0700
Message-ID: <201106072313.p57ND51t000847@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759005Ab1FGXNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:13:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, guenter.roeck@ericsson.com, len.brown@intel.com, rene.herman@gmail.com


The patch titled
     thermal: make THERMAL_HWMON implementation fully internal
has been added to the -mm tree.  Its filename is
     thermal-make-thermal_hwmon-implementation-fully-internal.patch

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
Subject: thermal: make THERMAL_HWMON implementation fully internal
From: Jean Delvare <khali@linux-fr.org>

THERMAL_HWMON is implemented inside the thermal_sys driver and has no
effect on drivers implementing thermal zones, so they shouldn't see
anything related to it in <linux/thermal.h>.  Making the THERMAL_HWMON
implementation fully internal has two advantages beyond the cleaner
design:

* This avoids rebuilding all thermal drivers if the THERMAL_HWMON
  implementation changes, or if CONFIG_THERMAL_HWMON gets enabled or
  disabled.

* This avoids breaking the thermal kABI in these cases too, which should
  make distributions happy.

The only drawback I can see is slightly higher memory fragmentation, as
the number of kzalloc() calls will increase by one per thermal zone.  But
I doubt it will be a problem in practice, as I've never seen a system with
more than two thermal zones.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Rene Herman <rene.herman@gmail.com>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/thermal_sys.c |  117 +++++++++++++++++++++++++-------
 include/linux/thermal.h       |   22 ------
 2 files changed, 92 insertions(+), 47 deletions(-)

diff -puN drivers/thermal/thermal_sys.c~thermal-make-thermal_hwmon-implementation-fully-internal drivers/thermal/thermal_sys.c
--- a/drivers/thermal/thermal_sys.c~thermal-make-thermal_hwmon-implementation-fully-internal
+++ a/drivers/thermal/thermal_sys.c
@@ -420,6 +420,29 @@ thermal_cooling_device_trip_point_show(s
 
 /* hwmon sys I/F */
 #include <linux/hwmon.h>
+
+/* thermal zone devices with the same type share one hwmon device */
+struct thermal_hwmon_device {
+	char type[THERMAL_NAME_LENGTH];
+	struct device *device;
+	int count;
+	struct list_head tz_list;
+	struct list_head node;
+};
+
+struct thermal_hwmon_attr {
+	struct device_attribute attr;
+	char name[16];
+};
+
+/* one temperature input for each thermal zone */
+struct thermal_hwmon_temp {
+	struct list_head hwmon_node;
+	struct thermal_zone_device *tz;
+	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
+	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
+};
+
 static LIST_HEAD(thermal_hwmon_list);
 
 static ssize_t
@@ -437,9 +460,10 @@ temp_input_show(struct device *dev, stru
 	int ret;
 	struct thermal_hwmon_attr *hwmon_attr
 			= container_of(attr, struct thermal_hwmon_attr, attr);
-	struct thermal_zone_device *tz
-			= container_of(hwmon_attr, struct thermal_zone_device,
+	struct thermal_hwmon_temp *temp
+			= container_of(hwmon_attr, struct thermal_hwmon_temp,
 				       temp_input);
+	struct thermal_zone_device *tz = temp->tz;
 
 	ret = tz->ops->get_temp(tz, &temperature);
 
@@ -455,9 +479,10 @@ temp_crit_show(struct device *dev, struc
 {
 	struct thermal_hwmon_attr *hwmon_attr
 			= container_of(attr, struct thermal_hwmon_attr, attr);
-	struct thermal_zone_device *tz
-			= container_of(hwmon_attr, struct thermal_zone_device,
+	struct thermal_hwmon_temp *temp
+			= container_of(hwmon_attr, struct thermal_hwmon_temp,
 				       temp_crit);
+	struct thermal_zone_device *tz = temp->tz;
 	long temperature;
 	int ret;
 
@@ -485,10 +510,29 @@ thermal_hwmon_lookup_by_type(const struc
 	return NULL;
 }
 
+/* Find the temperature input matching a given thermal zone */
+static struct thermal_hwmon_temp *
+thermal_hwmon_lookup_temp(const struct thermal_hwmon_device *hwmon,
+			  const struct thermal_zone_device *tz)
+{
+	struct thermal_hwmon_temp *temp;
+
+	mutex_lock(&thermal_list_lock);
+	list_for_each_entry(temp, &hwmon->tz_list, hwmon_node)
+		if (temp->tz == tz) {
+			mutex_unlock(&thermal_list_lock);
+			return temp;
+		}
+	mutex_unlock(&thermal_list_lock);
+
+	return NULL;
+}
+
 static int
 thermal_add_hwmon_sysfs(struct thermal_zone_device *tz)
 {
 	struct thermal_hwmon_device *hwmon;
+	struct thermal_hwmon_temp *temp;
 	int new_hwmon_device = 1;
 	int result;
 
@@ -515,30 +559,36 @@ thermal_add_hwmon_sysfs(struct thermal_z
 		goto free_mem;
 
  register_sys_interface:
-	tz->hwmon = hwmon;
+	temp = kzalloc(sizeof(struct thermal_hwmon_temp), GFP_KERNEL);
+	if (!temp) {
+		result = -ENOMEM;
+		goto unregister_name;
+	}
+
+	temp->tz = tz;
 	hwmon->count++;
 
-	snprintf(tz->temp_input.name, THERMAL_NAME_LENGTH,
+	snprintf(temp->temp_input.name, THERMAL_NAME_LENGTH,
 		 "temp%d_input", hwmon->count);
-	tz->temp_input.attr.attr.name = tz->temp_input.name;
-	tz->temp_input.attr.attr.mode = 0444;
-	tz->temp_input.attr.show = temp_input_show;
-	sysfs_attr_init(&tz->temp_input.attr.attr);
-	result = device_create_file(hwmon->device, &tz->temp_input.attr);
+	temp->temp_input.attr.attr.name = temp->temp_input.name;
+	temp->temp_input.attr.attr.mode = 0444;
+	temp->temp_input.attr.show = temp_input_show;
+	sysfs_attr_init(&temp->temp_input.attr.attr);
+	result = device_create_file(hwmon->device, &temp->temp_input.attr);
 	if (result)
-		goto unregister_name;
+		goto free_temp_mem;
 
 	if (tz->ops->get_crit_temp) {
 		unsigned long temperature;
 		if (!tz->ops->get_crit_temp(tz, &temperature)) {
-			snprintf(tz->temp_crit.name, THERMAL_NAME_LENGTH,
+			snprintf(temp->temp_crit.name, THERMAL_NAME_LENGTH,
 				"temp%d_crit", hwmon->count);
-			tz->temp_crit.attr.attr.name = tz->temp_crit.name;
-			tz->temp_crit.attr.attr.mode = 0444;
-			tz->temp_crit.attr.show = temp_crit_show;
-			sysfs_attr_init(&tz->temp_crit.attr.attr);
+			temp->temp_crit.attr.attr.name = temp->temp_crit.name;
+			temp->temp_crit.attr.attr.mode = 0444;
+			temp->temp_crit.attr.show = temp_crit_show;
+			sysfs_attr_init(&temp->temp_crit.attr.attr);
 			result = device_create_file(hwmon->device,
-						    &tz->temp_crit.attr);
+						    &temp->temp_crit.attr);
 			if (result)
 				goto unregister_input;
 		}
@@ -547,13 +597,15 @@ thermal_add_hwmon_sysfs(struct thermal_z
 	mutex_lock(&thermal_list_lock);
 	if (new_hwmon_device)
 		list_add_tail(&hwmon->node, &thermal_hwmon_list);
-	list_add_tail(&tz->hwmon_node, &hwmon->tz_list);
+	list_add_tail(&temp->hwmon_node, &hwmon->tz_list);
 	mutex_unlock(&thermal_list_lock);
 
 	return 0;
 
  unregister_input:
-	device_remove_file(hwmon->device, &tz->temp_input.attr);
+	device_remove_file(hwmon->device, &temp->temp_input.attr);
+ free_temp_mem:
+	kfree(temp);
  unregister_name:
 	if (new_hwmon_device) {
 		device_remove_file(hwmon->device, &dev_attr_name);
@@ -569,15 +621,30 @@ thermal_add_hwmon_sysfs(struct thermal_z
 static void
 thermal_remove_hwmon_sysfs(struct thermal_zone_device *tz)
 {
-	struct thermal_hwmon_device *hwmon = tz->hwmon;
+	struct thermal_hwmon_device *hwmon;
+	struct thermal_hwmon_temp *temp;
+
+	hwmon = thermal_hwmon_lookup_by_type(tz);
+	if (unlikely(!hwmon)) {
+		/* Should never happen... */
+		dev_dbg(&tz->device, "hwmon device lookup failed!\n");
+		return;
+	}
+
+	temp = thermal_hwmon_lookup_temp(hwmon, tz);
+	if (unlikely(!temp)) {
+		/* Should never happen... */
+		dev_dbg(&tz->device, "temperature input lookup failed!\n");
+		return;
+	}
 
-	tz->hwmon = NULL;
-	device_remove_file(hwmon->device, &tz->temp_input.attr);
+	device_remove_file(hwmon->device, &temp->temp_input.attr);
 	if (tz->ops->get_crit_temp)
-		device_remove_file(hwmon->device, &tz->temp_crit.attr);
+		device_remove_file(hwmon->device, &temp->temp_crit.attr);
 
 	mutex_lock(&thermal_list_lock);
-	list_del(&tz->hwmon_node);
+	list_del(&temp->hwmon_node);
+	kfree(temp);
 	if (!list_empty(&hwmon->tz_list)) {
 		mutex_unlock(&thermal_list_lock);
 		return;
diff -puN include/linux/thermal.h~thermal-make-thermal_hwmon-implementation-fully-internal include/linux/thermal.h
--- a/include/linux/thermal.h~thermal-make-thermal_hwmon-implementation-fully-internal
+++ a/include/linux/thermal.h
@@ -85,22 +85,6 @@ struct thermal_cooling_device {
 				((long)t-2732+5)/10 : ((long)t-2732-5)/10)
 #define CELSIUS_TO_KELVIN(t)	((t)*10+2732)
 
-#if defined(CONFIG_THERMAL_HWMON)
-/* thermal zone devices with the same type share one hwmon device */
-struct thermal_hwmon_device {
-	char type[THERMAL_NAME_LENGTH];
-	struct device *device;
-	int count;
-	struct list_head tz_list;
-	struct list_head node;
-};
-
-struct thermal_hwmon_attr {
-	struct device_attribute attr;
-	char name[16];
-};
-#endif
-
 struct thermal_zone_device {
 	int id;
 	char type[THERMAL_NAME_LENGTH];
@@ -120,12 +104,6 @@ struct thermal_zone_device {
 	struct mutex lock;	/* protect cooling devices list */
 	struct list_head node;
 	struct delayed_work poll_queue;
-#if defined(CONFIG_THERMAL_HWMON)
-	struct list_head hwmon_node;
-	struct thermal_hwmon_device *hwmon;
-	struct thermal_hwmon_attr temp_input;	/* hwmon sys attr */
-	struct thermal_hwmon_attr temp_crit;	/* hwmon sys attr */
-#endif
 };
 /* Adding event notification support elements */
 #define THERMAL_GENL_FAMILY_NAME                "thermal_event"
_

Patches currently in -mm which might be from khali@linux-fr.org are

linux-next.patch
thermal-hide-config_thermal_hwmon.patch
thermal-split-hwmon-lookup-to-a-separate-function.patch
thermal-make-thermal_hwmon-implementation-fully-internal.patch
drivers-firmware-dmi_scanc-make-dmi_name_in_vendors-more-focused.patch

