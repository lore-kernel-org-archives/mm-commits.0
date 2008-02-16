From: akpm@linux-foundation.org
Subject: + bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch added to -mm tree
Date: Fri, 15 Feb 2008 20:49:33 -0800
Message-ID: <200802160449.m1G4nX5V009024@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48690 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754104AbYBPEtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 23:49:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davem@davemloft.net, hidave.darkstar@gmail.com


The patch titled
     bluetooth: fix warning in net/bluetooth/hci_sysfs.c
has been added to the -mm tree.  Its filename is
     bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch

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
Subject: bluetooth: fix warning in net/bluetooth/hci_sysfs.c
From: Andrew Morton <akpm@linux-foundation.org>

net/bluetooth/hci_sysfs.c: In function 'del_conn':
net/bluetooth/hci_sysfs.c:339: warning: suggest parentheses around assignment used as truth value

Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/bluetooth/hci_sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/bluetooth/hci_sysfs.c~bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc net/bluetooth/hci_sysfs.c
--- a/net/bluetooth/hci_sysfs.c~bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc
+++ a/net/bluetooth/hci_sysfs.c
@@ -336,7 +336,7 @@ static void del_conn(struct work_struct 
 	struct device *dev;
 	struct hci_conn *conn = container_of(work, struct hci_conn, work);
 
-	while (dev = device_find_child(&conn->dev, NULL, __match_tty)) {
+	while ((dev = device_find_child(&conn->dev, NULL, __match_tty))) {
 		device_move(dev, NULL);
 		put_device(dev);
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-send-a-single-notification-on-device-state-changes.patch
softlockup-workaround.patch
git-acpi-powerpc-kconfig-fix.patch
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
fix-ide-mm-ide-rework-powermac-media-bay-support.patch
git-md-accel.patch
git-ubi.patch
git-net.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
git-sched.patch
git-sched-git-rejects.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-block-git-rejects.patch
git-sparc64.patch
git-unionfs.patch
git-unionfs-git-rejects.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
git-xtensa.patch
add-rcu_assign_index-if-ever-needed-fix.patch
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
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
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
bluetooth-fix-warning-in-net-bluetooth-hci_sysfsc.patch
