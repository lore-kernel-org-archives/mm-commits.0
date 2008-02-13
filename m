From: akpm@linux-foundation.org
Subject: + rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch added to -mm tree
Date: Wed, 13 Feb 2008 15:16:19 -0800
Message-ID: <200802132316.m1DNGKRF019029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbYBMXQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 18:16:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc-pcf8563-new-style-conversion-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch

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
Subject: rtc-pcf8563-new-style-conversion-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: __func__ should be used instead of gcc specific __FUNCTION__
#100: FILE: drivers/rtc/rtc-pcf8563.c:255:
+	dev_dbg(&client->dev, "%s\n", __FUNCTION__);

ERROR: do not use assignment in if condition
#120: FILE: drivers/rtc/rtc-pcf8563.c:260:
+	if (!(pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL)))

WARNING: line over 80 characters
#141: FILE: drivers/rtc/rtc-pcf8563.c:271:
+	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name, &client->dev,

total: 1 errors, 2 warnings, 180 lines checked

./patches/rtc-pcf8563-new-style-conversion.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8563.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-new-style-conversion-checkpatch-fixes drivers/rtc/rtc-pcf8563.c
--- a/drivers/rtc/rtc-pcf8563.c~rtc-pcf8563-new-style-conversion-checkpatch-fixes
+++ a/drivers/rtc/rtc-pcf8563.c
@@ -252,12 +252,13 @@ static int pcf8563_probe(struct i2c_clie
 
 	int err = 0;
 
-	dev_dbg(&client->dev, "%s\n", __FUNCTION__);
+	dev_dbg(&client->dev, "%s\n", __func__);
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	if (!(pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL)))
+	pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL));
+	if (!pcf8563)
 		return -ENOMEM;
 
 	/* Verify the chip is really an PCF8563 */
@@ -268,8 +269,8 @@ static int pcf8563_probe(struct i2c_clie
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name, &client->dev,
-				&pcf8563_rtc_ops, THIS_MODULE);
+	pcf8563->rtc = rtc_device_register(pcf8563_driver.driver.name,
+				&client->dev, &pcf8563_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(pcf8563->rtc)) {
 		err = PTR_ERR(pcf8563->rtc);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

softlockup-workaround.patch
include-linux-remove-all-users-of-fastcall-macro.patch
fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
smack-check-for-struct-socket-with-null-sk.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
fix-ide-mm-ide-remove-broken-dangerous-ide-unregister-scan-hwif-ioctls.patch
git-net.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-rc-fixes.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-conflicts.patch
git-sparc64.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-conflicts.patch
git-x86.patch
git-x86-vs-git-kvm.patch
git-x86-cpa-build-fix.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xfs-git-conflicts.patch
git-xtensa.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
rename-open_namei-to-open_pathname-vs-git-acpi.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
procfs-task-exe-symlink-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
