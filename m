From: akpm@linux-foundation.org
Subject: - drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:23:07 -0800
Message-ID: <200802232023.m1NKN7qa013488@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755858AbYBWU23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/usb/serial/io_ti.c: remove pointless eye-candy in debug statements
has been removed from the -mm tree.  Its filename was
     drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/usb/serial/io_ti.c: remove pointless eye-candy in debug statements
From: Andrew Morton <akpm@linux-foundation.org>

These strings always come up as false positives whenever I'm doing
git-conflict fixups (ie: about 1000 times/day).

I don't think the zillion "<" and ">" characters are very useful and removing
them makes my life that little bit easier.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/serial/io_ti.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements drivers/usb/serial/io_ti.c
--- a/drivers/usb/serial/io_ti.c~drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements
+++ a/drivers/usb/serial/io_ti.c
@@ -1087,12 +1087,11 @@ static int TIDownloadFirmware (struct ed
 	if (serial->product_info.TiMode == TI_MODE_DOWNLOAD) {
 		struct ti_i2c_desc *rom_desc;
 
-		dbg ("%s - <<<<<<<<<<<<<<<RUNNING IN DOWNLOAD MODE>>>>>>>>>>", __FUNCTION__);
+		dbg("%s - RUNNING IN DOWNLOAD MODE", __FUNCTION__);
 
 		status = TiValidateI2cImage (serial);
 		if (status) {
-			dbg ("%s - <<<<<<<<<<<<<<<DOWNLOAD MODE -- BAD I2C >>>>>>>>>>",
-			     __FUNCTION__);
+			dbg("%s - DOWNLOAD MODE -- BAD I2C", __FUNCTION__);
 			return status;
 		}
 		
@@ -1346,8 +1345,7 @@ static int TIDownloadFirmware (struct ed
 	/********************************************************************/
 	/* Boot Mode */
 	/********************************************************************/
-	dbg ("%s - <<<<<<<<<<<<<<<RUNNING IN BOOT MODE>>>>>>>>>>>>>>>",
-	     __FUNCTION__);
+	dbg("%s - RUNNING IN BOOT MODE", __FUNCTION__);
 
 	// Configure the TI device so we can use the BULK pipes for download
 	status = TIConfigureBootDevice (serial->serial->dev);
@@ -1462,7 +1460,7 @@ static int TIDownloadFirmware (struct ed
 
 StayInBootMode:
 	// Eprom is invalid or blank stay in boot mode
-	dbg ("%s - <<<<<<<<<<<<<<<STAYING IN BOOT MODE>>>>>>>>>>>>", __FUNCTION__);
+	dbg("%s - STAYING IN BOOT MODE", __FUNCTION__);
 	serial->product_info.TiMode = TI_MODE_BOOT;
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-drm.patch
git-dvb.patch
git-dvb-someone-broke-the-gpio-includes.patch
git-hwmon.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-sched.patch
tracing-is-borked-on-powerpc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-x86.patch
git-x86-fixup.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
make-dev-kmem-a-config-option-fix.patch
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
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
