From: akpm@linux-foundation.org
Subject: - driver-core-debug-for-bad-dev_attr_show-return-value.patch removed from -mm tree
Date: Thu, 13 Mar 2008 11:59:38 -0700
Message-ID: <200803131859.m2DIxcXA027967@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754547AbYCMTAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balajirrao@gmail.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     driver core: debug for bad dev_attr_show() return value.
has been removed from the -mm tree.  Its filename was
     driver-core-debug-for-bad-dev_attr_show-return-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: driver core: debug for bad dev_attr_show() return value.
From: Andrew Morton <akpm@linux-foundation.org>

Try to find the culprit who caused
http://bugzilla.kernel.org/show_bug.cgi?id=10150

Cc: <balajirrao@gmail.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    5 +++++
 fs/sysfs/file.c     |    8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/Kconfig~driver-core-debug-for-bad-dev_attr_show-return-value fs/Kconfig
diff -puN fs/sysfs/file.c~driver-core-debug-for-bad-dev_attr_show-return-value fs/sysfs/file.c
--- a/fs/sysfs/file.c~driver-core-debug-for-bad-dev_attr_show-return-value
+++ a/fs/sysfs/file.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/kobject.h>
+#include <linux/kallsyms.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
@@ -94,7 +95,12 @@ static int fill_read_buffer(struct dentr
 	 * The code works fine with PAGE_SIZE return but it's likely to
 	 * indicate truncated result or overflow in normal use cases.
 	 */
-	BUG_ON(count >= (ssize_t)PAGE_SIZE);
+	if (count >= (ssize_t)PAGE_SIZE) {
+		print_symbol("fill_read_buffer: %s returned bad count\n",
+			(unsigned long)ops->show);
+		/* Try to struggle along */
+		count = PAGE_SIZE - 1;
+	}
 	if (count >= 0) {
 		buffer->needs_read_fill = 0;
 		buffer->count = count;
diff -puN drivers/base/core.c~driver-core-debug-for-bad-dev_attr_show-return-value drivers/base/core.c
--- a/drivers/base/core.c~driver-core-debug-for-bad-dev_attr_show-return-value
+++ a/drivers/base/core.c
@@ -19,6 +19,7 @@
 #include <linux/kdev_t.h>
 #include <linux/notifier.h>
 #include <linux/genhd.h>
+#include <linux/kallsyms.h>
 #include <asm/semaphore.h>
 
 #include "base.h"
@@ -68,6 +69,10 @@ static ssize_t dev_attr_show(struct kobj
 
 	if (dev_attr->show)
 		ret = dev_attr->show(dev, dev_attr, buf);
+	if (ret >= (ssize_t)PAGE_SIZE) {
+		print_symbol("dev_attr_show: %s returned bad count\n",
+				(unsigned long)dev_attr->show);
+	}
 	return ret;
 }
 
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
revert-acpi-thermal-fixup.patch
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
add-warn_on_secs-macro-fix-fix.patch
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
pnp-use-dev_printk-for-quirk-messages-fix.patch
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
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
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

