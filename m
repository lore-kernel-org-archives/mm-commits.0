From: akpm@linux-foundation.org
Subject: - 3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch removed from -mm tree
Date: Mon, 03 Mar 2008 20:18:52 -0800
Message-ID: <200803040428.m244SGap023337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbYCDE27 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 23:28:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bjorn.helgaas@hp.com, jeff@garzik.org, linux@rainbow-software.org, mm-commits@vger.kernel.org


The patch titled
     3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup
has been removed from the -mm tree.  Its filename was
     3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: 3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup
From: Andrew Morton <akpm@linux-foundation.org>

The standard ifdef-avoidance trick.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/3c509.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/net/3c509.c~3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup drivers/net/3c509.c
--- a/drivers/net/3c509.c~3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup
+++ a/drivers/net/3c509.c
@@ -378,15 +378,16 @@ static int el3_isa_resume(struct device 
 	outw(0x0f00, ioaddr + WN0_IRQ);
 	return el3_resume(dev);
 }
+#else
+#define el3_isa_suspend NULL
+#define el3_isa_resume NULL
 #endif
 
 static struct isa_driver el3_isa_driver = {
 	.match		= el3_isa_match,
 	.remove		= __devexit_p(el3_isa_remove),
-#ifdef CONFIG_PM
 	.suspend	= el3_isa_suspend,
 	.resume		= el3_isa_resume,
-#endif
 	.driver		= {
 		.name	= "3c509"
 	},
@@ -461,6 +462,9 @@ static int el3_pnp_resume(struct pnp_dev
 {
 	return el3_resume(&pdev->dev);
 }
+#else
+#define el3_pnp_suspend NULL
+#define el3_pnp_resume NULL
 #endif
 
 static struct pnp_driver el3_pnp_driver = {
@@ -468,10 +472,8 @@ static struct pnp_driver el3_pnp_driver 
 	.id_table	= el3_pnp_ids,
 	.probe		= el3_pnp_probe,
 	.remove		= __devexit_p(el3_pnp_remove),
-#ifdef CONFIG_PM
 	.suspend	= el3_pnp_suspend,
 	.resume		= el3_pnp_resume,
-#endif
 };
 static int pnp_registered;
 #endif /* CONFIG_PNP */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
zlc_setup-handle-jiffies-wraparound-fix.patch
git-x86.patch
arch-x86-kernel-ptracec-fix-defined-but-unused-warnings.patch
git-acpi-fixup.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-alsa-fix-git-conflicts.patch
git-alsa-build-fix.patch
git-cifs.patch
revert-gregkh-driver-video-add-the-go7007-driver.patch
driver-core-debug-for-bad-dev_attr_show-return-value.patch
git-drm.patch
git-dvb.patch
git-hwmon.patch
git-hrt.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
maple-add-driver-for-sega-dreamcast-controller-update-checkpatch-fixes.patch
git-kvm.patch
pata-i-do-not-think-it-means-what-you-think-it-means-checkpatch-fixes.patch
git-md-accel.patch
git-ubi.patch
3c509-convert-to-isa_driver-and-pnp_driver-v4-cleanup.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd.patch
fs-ocfs2-dlm-dlmdomainc-fix-printk-warning.patch
scsi-aic94xx-cleanups.patch
git-block-git-rejects.patch
git-unionfs.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-remove-unnecessary-type-casting-of-urb-context-checkpatch-fixes.patch
git-v9fs.patch
git-semaphore-git-rejects.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
tridentfb-resource-management-fixes-in-probe-function-fix.patch
add-noinline_for_stack.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division.patch
ndelay-switch-to-c-function-to-avoid-64-bit-division-fix.patch
sm501-add-support-for-the-sm502-programmable-pll-checkpatch-fixes.patch
markers-dont-risk-null-deref-in-marker-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
iommu-parisc-pass-struct-device-to-iommu_alloc_range-checkpatch-fixes.patch
iommu-parisc-make-the-iommus-respect-the-segment-boundary-limits-checkpatch-fixes.patch
drivers-media-video-em28xx-correct-use-of-and-fix.patch
slub-fix-possible-null-pointer-dereference-fix.patch
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
r-o-bind-mounts-elevate-write-count-for-callers-of-vfs_mkdir-fix.patch
r-o-bind-mounts-elevate-write-count-for-xattr_permission-callers-fix.patch
r-o-bind-mounts-get-write-access-for-vfs_rename-callers-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix.patch
r-o-bind-mounts-check-mnt-instead-of-superblock-directly-fix-2.patch
r-o-bind-mounts-get-callers-of-vfs_mknod-create-fix.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
use-page_cache_xxx-in-ext2-fix.patch
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
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch

