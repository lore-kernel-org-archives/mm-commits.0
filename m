From: akpm@linux-foundation.org
Subject: - hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:46:12 -0700
Message-ID: <200810182346.m9INkCDi001031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751692AbYJRXqZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jim.cromie@gmail.com, khali@linux-fr.org, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup
has been removed from the -mm tree.  Its filename was
     hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch

This patch was dropped because it was folded into hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/pc87360.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup drivers/hwmon/pc87360.c
--- a/drivers/hwmon/pc87360.c~hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup
+++ a/drivers/hwmon/pc87360.c
@@ -498,16 +498,16 @@ static struct sensor_device_attribute in
    register (sec 11.5.12), not the vin event status registers (sec
    11.5.2) that (legacy) show_in_alarm() resds (via data->in_alarms) */
 
-static ssize_t show_in_min_alarm(struct device *dev, struct device_attribute
-			     *devattr, char *buf)
+static ssize_t show_in_min_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = pc87360_update_device(dev);
 	unsigned nr = to_sensor_dev_attr(devattr)->index;
 
 	return sprintf(buf, "%u\n", !!(data->in_status[nr] & CHAN_ALM_MIN));
 }
-static ssize_t show_in_max_alarm(struct device *dev, struct device_attribute
-			     *devattr, char *buf)
+static ssize_t show_in_max_alarm(struct device *dev,
+			struct device_attribute *devattr, char *buf)
 {
 	struct pc87360_data *data = pc87360_update_device(dev);
 	unsigned nr = to_sensor_dev_attr(devattr)->index;
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
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
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

