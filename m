From: akpm@linux-foundation.org
Subject: - hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:46:53 -0700
Message-ID: <200810182346.m9INksbx001114@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44642 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbYJRXrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup
has been removed from the -mm tree.  Its filename was
     hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch

This patch was dropped because it was folded into hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup
+++ a/drivers/hwmon/pc87360.c
@@ -849,24 +849,24 @@ static DEVICE_ATTR(alarms_temp, S_IRUGO,
    register (sec 12.3.7), not the temp event status registers (sec
    12.3.2) that show_temp_alarm() reads (via data->temp_alarms) */
 
-static ssize_t show_temp_min_alarm(struct device *dev, struct device_attribute
-				   *devattr, char *buf)
+static ssize_t show_temp_min_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = pc87360_update_device(dev);
 	unsigned nr = to_sensor_dev_attr(devattr)->index;
 
 	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & CHAN_ALM_MIN));
 }
-static ssize_t show_temp_max_alarm(struct device *dev, struct device_attribute
-				   *devattr, char *buf)
+static ssize_t show_temp_max_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = pc87360_update_device(dev);
 	unsigned nr = to_sensor_dev_attr(devattr)->index;
 
 	return sprintf(buf, "%u\n", !!(data->temp_status[nr] & CHAN_ALM_MAX));
 }
-static ssize_t show_temp_crit_alarm(struct device *dev, struct device_attribute
-				   *devattr, char *buf)
+static ssize_t show_temp_crit_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = pc87360_update_device(dev);
 	unsigned nr = to_sensor_dev_attr(devattr)->index;
@@ -891,8 +891,8 @@ static struct sensor_device_attribute te
 };
 
 #define TEMP_FAULT	0x40	/* open diode */
-static ssize_t show_temp_fault(struct device *dev, struct device_attribute
-			       *devattr, char *buf)
+static ssize_t show_temp_fault(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = pc87360_update_device(dev);
 	unsigned nr = to_sensor_dev_attr(devattr)->index;
@@ -928,8 +928,8 @@ static const struct attribute_group pc87
 	.attrs = pc8736x_temp_attr_array,
 };
 
-static ssize_t show_name(struct device *dev, struct device_attribute
-			 *devattr, char *buf)
+static ssize_t show_name(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = dev_get_drvdata(dev);
 	return sprintf(buf, "%s\n", data->name);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

