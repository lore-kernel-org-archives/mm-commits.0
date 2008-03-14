From: akpm@linux-foundation.org
Subject: - revert-acpi-thermal-fixup.patch removed from -mm tree
Date: Fri, 14 Mar 2008 00:31:42 -0700
Message-ID: <200803140731.m2E7VgpD022802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755570AbYCNHcs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Mar 2008 03:32:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andrea@qumranet.com, clameter@sgi.com, len.brown@intel.com, npiggin@suse.de, rjw@sisk.pl, rui.zhang@intel.com, sujith.thomas@intel.com, mm-commits@vger.kernel.org


The patch titled
     revert "ACPI: thermal fixup"
has been removed from the -mm tree.  Its filename was
     revert-acpi-thermal-fixup.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "ACPI: thermal fixup"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 653a00c9662304ef72a3eb4e681c91720960e0b4
Author: Zhang Rui <rui.zhang@intel.com>
Date:   Thu Jan 17 15:51:18 2008 +0800

Andrea reports

  this changeset prevents my SVM test system from booting with
  CONFIG_ACPI_THERMAL=y, so I set CONFIG_ACPI_THERMAL=n for now.

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Thomas Sujith <sujith.thomas@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/thermal.c |   42 ++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff -puN drivers/acpi/thermal.c~revert-acpi-thermal-fixup drivers/acpi/thermal.c
--- a/drivers/acpi/thermal.c~revert-acpi-thermal-fixup
+++ a/drivers/acpi/thermal.c
@@ -1018,9 +1018,7 @@ static int acpi_thermal_cooling_device_c
 {
 	struct acpi_device *device = cdev->devdata;
 	struct acpi_thermal *tz = thermal->devdata;
-	struct acpi_device *dev;
-	acpi_status status;
-	acpi_handle handle;
+	acpi_handle handle = device->handle;
 	int i;
 	int j;
 	int trip = -1;
@@ -1036,13 +1034,12 @@ static int acpi_thermal_cooling_device_c
 		trip++;
 		for (i = 0; i < tz->trips.passive.devices.count;
 		    i++) {
-			handle = tz->trips.passive.devices.handles[i];
-			status = acpi_bus_get_device(handle, &dev);
-			if (ACPI_SUCCESS(status) && (dev == device)) {
-				result = action(thermal, trip, cdev);
-				if (result)
-					goto failed;
-			}
+			if (tz->trips.passive.devices.handles[i] !=
+				handle)
+				continue;
+			result = action(thermal, trip, cdev);
+			if (result)
+				goto failed;
 		}
 	}
 
@@ -1053,24 +1050,21 @@ static int acpi_thermal_cooling_device_c
 		for (j = 0;
 		    j < tz->trips.active[i].devices.count;
 		    j++) {
-			handle = tz->trips.active[i].devices.handles[j];
-			status = acpi_bus_get_device(handle, &dev);
-			if (ACPI_SUCCESS(status) && (dev == device)) {
-				result = action(thermal, trip, cdev);
-				if (result)
-					goto failed;
-			}
+			if (tz->trips.active[i].devices.
+						handles[j] != handle)
+				continue;
+			result = action(thermal, trip, cdev);
+			if (result)
+				goto failed;
 		}
 	}
 
 	for (i = 0; i < tz->devices.count; i++) {
-		handle = tz->devices.handles[i];
-		status = acpi_bus_get_device(handle, &dev);
-		if (ACPI_SUCCESS(status) && (dev == device)) {
-			result = action(thermal, -1, cdev);
-			if (result)
-				goto failed;
-		}
+		if (tz->devices.handles[i] != handle)
+			continue;
+		result = action(thermal, -1, cdev);
+		if (result)
+			goto failed;
 	}
 
 failed:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-tiwai.patch
cifs-suppress-warning.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
pm-make-wakeup-flags-available-whenever-config_pm-is-set-checkpatch-fixes.patch
git-drm.patch
git-dvb.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
drivers-media-video-soc_camerac-reads-return-size_t.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller.patch
git-kvm.patch
git-leds.patch
devres-implement-pcim_iomap_regions_request_all-fix.patch
devres-implement-pcim_iomap_regions_request_all-fix-fix.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-sched-make-sure-jiffies-is-up-to-date-before-calling-__update_rq_clock.patch
git-sh.patch
git-scsi-misc-revert-st-show-options-currently-set-in-sysfs.patch
scsi-aic94xx-cleanups.patch
scsi-fix-section-mismatch-in-aic94xx-fix.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
ipsc-fix-build-warning.patch
drivers-scsi-initioc-suppress-compile-warning.patch
drivers-scsi-hptiopc-fix-build-warning.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
git-unionfs.patch
fix-gregkh-usb-usb-add-usb-serial-spcp8x5-driver.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
drivers-usb-core-devioc-suppress-warning-with-64k-page_size.patch
git-v9fs.patch
git-watchdog.patch
git-semaphore-git-rejects.patch
x86-fix-aperture-vs-suspend-problem-checkpatch-fixes.patch
revert-acpi-thermal-fixup.patch
revert-pcie-utilize-pcie-transaction-pending-bit.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-mem_map-allocation-continuous-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lib-swiotlbc-cleanups.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ext4-is-broken.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

