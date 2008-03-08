From: akpm@linux-foundation.org
Subject: + regulator-framework-core-fix.patch added to -mm tree
Date: Fri, 07 Mar 2008 16:12:44 -0800
Message-ID: <200803080022.m280MDv6024736@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755400AbYCHAWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Mar 2008 19:22:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, lg@opensource.wolfsonmicro.com


The patch titled
     regulator-framework-core-fix
has been added to the -mm tree.  Its filename is
     regulator-framework-core-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: regulator-framework-core-fix
From: Andrew Morton <akpm@linux-foundation.org>

alpha:

drivers/regulator/reg-core.c:857:43: error: macro "get_current" passed 1 arguments, but takes just 0
drivers/regulator/reg-core.c: In function '_regulator_get_current':
drivers/regulator/reg-core.c:857: warning: assignment makes integer from pointer without a cast

Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/regulator/reg-core.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff -puN drivers/regulator/reg-core.c~regulator-framework-core-fix drivers/regulator/reg-core.c
--- a/drivers/regulator/reg-core.c~regulator-framework-core-fix
+++ a/drivers/regulator/reg-core.c
@@ -70,7 +70,7 @@ struct regulator {
 static int _regulator_is_enabled(struct regulator_cdev *rcdev);
 static int _regulator_disable(struct regulator_cdev *rcdev);
 static int _regulator_get_voltage(struct regulator_cdev *rcdev);
-static int _regulator_get_current(struct regulator_cdev *rcdev);
+static int _regulator_read_current(struct regulator_cdev *rcdev);
 static unsigned int _regulator_get_mode(struct regulator_cdev *rcdev);
 
 /* gets the regulator for a given consumer device */
@@ -198,7 +198,7 @@ static ssize_t regulator_uA_show(struct 
 {
 	struct regulator_cdev *rcdev = to_rcdev(cdev);
 
-	return sprintf(buf, "%d\n", _regulator_get_current(rcdev));
+	return sprintf(buf, "%d\n", _regulator_read_current(rcdev));
 }
 
 static ssize_t regulator_opmode_show(struct class_device *cdev, char *buf)
@@ -842,26 +842,26 @@ out:
 }
 EXPORT_SYMBOL_GPL(regulator_set_current);
 
-static int _regulator_get_current(struct regulator_cdev *rcdev)
+static int _regulator_read_current(struct regulator_cdev *rcdev)
 {
 	int ret;
 
 	mutex_lock(&rcdev->mutex);
 
 	/* sanity check */
-	if (!rcdev->desc->ops->get_current) {
+	if (!rcdev->desc->ops->read_current) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = rcdev->desc->ops->get_current(rcdev);
+	ret = rcdev->desc->ops->read_current(rcdev);
 out:
 	mutex_unlock(&rcdev->mutex);
 	return ret;
 }
 
 /**
- * regulator_get_current - get regulator output current
+ * regulator_read_current - get regulator output current
  * @regulator: regulator source
  *
  * This returns the current supplied by the specified current sink in uA.
@@ -869,11 +869,11 @@ out:
  * NOTE: If the regulator is disabled it will return the current value. This
  * function should not be used to determine regulator state.
  */
-int regulator_get_current(struct regulator *regulator)
+int regulator_read_current(struct regulator *regulator)
 {
-	return _regulator_get_current(regulator->rcdev);
+	return _regulator_read_current(regulator->rcdev);
 }
-EXPORT_SYMBOL_GPL(regulator_get_current);
+EXPORT_SYMBOL_GPL(regulator_read_current);
 
 /**
  * regulator_set_mode - set regulator operating mode
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
poweroff-workaround.patch
rename-declare_pci_device_table-to-define_pci_device_table.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-kgdb-light-kconfig-fix.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa.patch
git-alsa-fix-git-conflicts.patch
git-arm-master.patch
git-powerpc-fix-git-rejects.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
usb-video-add-a-device-link-to-usbvideo-devices-else-hal-will-ignore-them-checkpatch-fixes.patch
drivers-media-video-pvrusb2-pvrusb2-sysfsc-fix-printk-warnings.patch
oz99x-i2c-button-and-led-support-driver.patch
git-hwmon.patch
git-hrt.patch
git-ieee1394.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-ocfs2.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
git-sh.patch
scsi-aic94xx-cleanups.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-prevent-kconfig-explosion.patch
git-semaphore-git-rejects.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
fat_valid_media-remove-pointless-test.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
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
regulator-consumer-interface-fix.patch
regulator-regulator-driver-interface-fix.patch
regulator-framework-core-fix.patch
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

