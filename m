From: akpm@linux-foundation.org
Subject: - via-velocity-section-fix.patch removed from -mm tree
Date: Wed, 13 Feb 2008 12:15:46 -0800
Message-ID: <200802132015.m1DKFk0P011400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755550AbYBMUUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Feb 2008 15:20:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jeff@garzik.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     via-velocity section fix
has been removed from the -mm tree.  Its filename was
     via-velocity-section-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: via-velocity section fix
From: Andrew Morton <akpm@linux-foundation.org>

gcc-3.4.4 on powerpc:

drivers/net/via-velocity.c:443: error: chip_info_table causes a section type conflict

on this one I had to remove the __devinitdata too.  Don't know why.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/via-velocity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/via-velocity.c~via-velocity-section-fix drivers/net/via-velocity.c
--- a/drivers/net/via-velocity.c~via-velocity-section-fix
+++ a/drivers/net/via-velocity.c
@@ -440,7 +440,7 @@ static void velocity_unregister_notifier
  *	Internal board variants. At the moment we have only one
  */
 
-static const struct velocity_info_tbl chip_info_table[] __devinitdata = {
+static struct velocity_info_tbl chip_info_table[] = {
 	{CHIP_TYPE_VT6110, "VIA Networking Velocity Family Gigabit Ethernet Adapter", 1, 0x00FFFFFFUL},
 	{ }
 };
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

softlockup-workaround.patch
include-linux-remove-all-users-of-fastcall-macro-checkpatch-fixes.patch
fs-smbfs-inodec-fix-warning-message-deprecating-smbfs.patch
smack-check-for-struct-socket-with-null-sk-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
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
git-sparc64.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xtensa.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
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
