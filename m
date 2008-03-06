From: akpm@linux-foundation.org
Subject: + fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch added to -mm tree
Date: Wed, 05 Mar 2008 20:22:25 -0800
Message-ID: <200803060422.m264MP6d008454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754486AbYCFEW2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 23:22:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, greg@kroah.com, oakad@yahoo.com


The patch titled
     fix gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name
has been added to the -mm tree.  Its filename is
     fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch

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
Subject: fix gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name
From: Andrew Morton <akpm@linux-foundation.org>

Update
gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name
for new memstick stuff

Cc: Greg KH <greg@kroah.com>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/host/jmb38x_ms.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/memstick/host/jmb38x_ms.c~fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name drivers/memstick/host/jmb38x_ms.c
--- a/drivers/memstick/host/jmb38x_ms.c~fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name
+++ a/drivers/memstick/host/jmb38x_ms.c
@@ -341,15 +341,15 @@ static int jmb38x_ms_issue_cmd(struct me
 	unsigned int data_len, cmd, t_val;
 
 	if (!(STATUS_HAS_MEDIA & readl(host->addr + STATUS))) {
-		dev_dbg(msh->cdev.dev, "no media status\n");
+		dev_dbg(&msh->dev, "no media status\n");
 		host->req->error = -ETIME;
 		return host->req->error;
 	}
 
-	dev_dbg(msh->cdev.dev, "control %08x\n",
+	dev_dbg(&msh->dev, "control %08x\n",
 		readl(host->addr + HOST_CONTROL));
-	dev_dbg(msh->cdev.dev, "status %08x\n", readl(host->addr + INT_STATUS));
-	dev_dbg(msh->cdev.dev, "hstatus %08x\n", readl(host->addr + STATUS));
+	dev_dbg(&msh->dev, "status %08x\n", readl(host->addr + INT_STATUS));
+	dev_dbg(&msh->dev, "hstatus %08x\n", readl(host->addr + STATUS));
 
 	host->cmd_flags = 0;
 	host->block_pos = 0;
@@ -429,7 +429,7 @@ static int jmb38x_ms_issue_cmd(struct me
 	host->req->error = 0;
 
 	writel(cmd, host->addr + TPC);
-	dev_dbg(msh->cdev.dev, "executing TPC %08x, len %x\n", cmd, data_len);
+	dev_dbg(&msh->dev, "executing TPC %08x, len %x\n", cmd, data_len);
 
 	return 0;
 }
@@ -442,11 +442,11 @@ static void jmb38x_ms_complete_cmd(struc
 
 	del_timer(&host->timer);
 
-	dev_dbg(msh->cdev.dev, "c control %08x\n",
+	dev_dbg(&msh->dev, "c control %08x\n",
 		readl(host->addr + HOST_CONTROL));
-	dev_dbg(msh->cdev.dev, "c status %08x\n",
+	dev_dbg(&msh->dev, "c status %08x\n",
 		readl(host->addr + INT_STATUS));
-	dev_dbg(msh->cdev.dev, "c hstatus %08x\n", readl(host->addr + STATUS));
+	dev_dbg(&msh->dev, "c hstatus %08x\n", readl(host->addr + STATUS));
 
 	if (host->req->get_int_reg) {
 		t_val = readl(host->addr + TPC_P0);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa.patch
git-alsa-fix-git-conflicts.patch
git-powerpc-fix-git-rejects.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
fix-gregkh-driver-net-convert-the-phy_device-file-to-use-bus_find_device_by_name.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
oz99x-i2c-button-and-led-support-driver.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means.patch
git-md-accel.patch
git-md-accel-fix-git-rejects.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
git-ocfs2.patch
sh-export-copy-page-to-modules.patch
scsi-aic94xx-cleanups.patch
scsi-chc-fix-shadowed-variable-warnings-checkpatch-fixes.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
git-v9fs.patch
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
security-replace-remaining-__function__-occurences-checkpatch-fixes.patch
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

