From: akpm@linux-foundation.org
Subject: - revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm.patch removed from -mm tree
Date: Tue, 27 Nov 2007 12:33:21 -0800
Message-ID: <200711272033.lARKXLwS028973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56551 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755928AbXK0Udz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 15:33:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, airlied@linux.ie, gregkh@suse.de, kay.sievers@vrfy.org, tonyj@suse.de, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm
has been removed from the -mm tree.  Its filename was
     revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: revert gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm
From: Andrew Morton <akpm@linux-foundation.org>

It looks like David has applied this to git-drm.

Cc: Tony Jones <tonyj@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: David Airlie <airlied@linux.ie>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drmP.h      |    8 ++--
 drivers/char/drm/drm_stub.c  |    9 ++---
 drivers/char/drm/drm_sysfs.c |   58 +++++++++++++++------------------
 3 files changed, 36 insertions(+), 39 deletions(-)

diff -puN drivers/char/drm/drmP.h~revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm drivers/char/drm/drmP.h
--- a/drivers/char/drm/drmP.h~revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm
+++ a/drivers/char/drm/drmP.h
@@ -634,7 +634,7 @@ struct drm_head {
 	struct drm_device *dev;
 	struct proc_dir_entry *dev_root;  /**< proc directory entry */
 	dev_t device;			/**< Device number for mknod */
-	struct device *drm_sysfs_class;
+	struct class_device *dev_class;
 };
 
 /**
@@ -1063,9 +1063,9 @@ extern void drm_pci_free(struct drm_devi
 			       /* sysfs support (drm_sysfs.c) */
 extern struct class *drm_sysfs_create(struct module *owner, char *name);
 extern void drm_sysfs_destroy(struct class *cs);
-extern struct device *drm_sysfs_device_add(struct class *cs,
-					   struct drm_head *head);
-extern void drm_sysfs_device_remove(struct device *drm_sysfs_dev);
+extern struct class_device *drm_sysfs_device_add(struct class *cs,
+						 struct drm_head *head);
+extern void drm_sysfs_device_remove(struct class_device *class_dev);
 
 /*
  * Basic memory manager support (drm_mm.c)
diff -puN drivers/char/drm/drm_stub.c~revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm drivers/char/drm/drm_stub.c
--- a/drivers/char/drm/drm_stub.c~revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm
+++ a/drivers/char/drm/drm_stub.c
@@ -168,12 +168,11 @@ static int drm_get_head(struct drm_devic
 				goto err_g1;
 			}
 
-			head->drm_sysfs_class =
-				drm_sysfs_device_add(drm_class, head);
-			if (IS_ERR(head->drm_sysfs_class)) {
+			head->dev_class = drm_sysfs_device_add(drm_class, head);
+			if (IS_ERR(head->dev_class)) {
 				printk(KERN_ERR
 				       "DRM: Error sysfs_device_add.\n");
-				ret = PTR_ERR(head->drm_sysfs_class);
+				ret = PTR_ERR(head->dev_class);
 				goto err_g2;
 			}
 			*heads = head;
@@ -284,7 +283,7 @@ int drm_put_head(struct drm_head * head)
 	DRM_DEBUG("release secondary minor %d\n", minor);
 
 	drm_proc_cleanup(minor, drm_proc_root, head->dev_root);
-	drm_sysfs_device_remove(head->drm_sysfs_class);
+	drm_sysfs_device_remove(head->dev_class);
 
 	*head = (struct drm_head) {.dev = NULL};
 
diff -puN drivers/char/drm/drm_sysfs.c~revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm drivers/char/drm/drm_sysfs.c
--- a/drivers/char/drm/drm_sysfs.c~revert-gregkh-driver-drm-convert-from-class_device-to-device-in-drivers-char-drm
+++ a/drivers/char/drm/drm_sysfs.c
@@ -78,81 +78,79 @@ void drm_sysfs_destroy(struct class *cla
 	class_destroy(class);
 }
 
-static ssize_t show_dri(struct device *drm_sysfs_dev,
-			struct device_attribute *attr, char *buf)
+static ssize_t show_dri(struct class_device *class_device, char *buf)
 {
-	struct drm_device *dev =
-		((struct drm_head *)dev_get_drvdata(drm_sysfs_dev))->dev;
-
+	struct drm_device * dev = ((struct drm_head *)class_get_devdata(class_device))->dev;
 	if (dev->driver->dri_library_name)
 		return dev->driver->dri_library_name(dev, buf);
 	return snprintf(buf, PAGE_SIZE, "%s\n", dev->driver->pci_driver.name);
 }
 
-static struct device_attribute drm_sysfs_device_attrs[] = {
+static struct class_device_attribute class_device_attrs[] = {
 	__ATTR(dri_library_name, S_IRUGO, show_dri, NULL),
 };
 
 /**
- * drm_sysfs_device_add - adds a device to sysfs for a character driver
+ * drm_sysfs_device_add - adds a class device to sysfs for a character driver
  * @cs: pointer to the struct class that this device should be registered to.
  * @dev: the dev_t for the device to be added.
  * @device: a pointer to a struct device that is assiociated with this class device.
  * @fmt: string for the class device's name
  *
- * A struct device will be created in sysfs, registered to the specified
+ * A struct class_device will be created in sysfs, registered to the specified
  * class.  A "dev" file will be created, showing the dev_t for the device.  The
- * pointer to the struct device will be returned from the call.  Any further
+ * pointer to the struct class_device will be returned from the call.  Any further
  * sysfs files that might be required can be created using this pointer.
  * Note: the struct class passed to this function must have previously been
  * created with a call to drm_sysfs_create().
  */
-struct device *drm_sysfs_device_add(struct class *cs, struct drm_head *head)
+struct class_device *drm_sysfs_device_add(struct class *cs, struct drm_head *head)
 {
-	struct device *drm_sysfs_dev;
+	struct class_device *class_dev;
 	int i, j, err;
 
-	drm_sysfs_dev = device_create(cs, &(head->dev->pdev)->dev,
-				MKDEV(DRM_MAJOR, head->minor),
-				"card%d", head->minor);
-	if (IS_ERR(drm_sysfs_dev)) {
-		err = PTR_ERR(drm_sysfs_dev);
+	class_dev = class_device_create(cs, NULL,
+					MKDEV(DRM_MAJOR, head->minor),
+					&(head->dev->pdev)->dev,
+					"card%d", head->minor);
+	if (IS_ERR(class_dev)) {
+		err = PTR_ERR(class_dev);
 		goto err_out;
 	}
 
-	dev_set_drvdata(drm_sysfs_dev, head);
+	class_set_devdata(class_dev, head);
 
-	for (i = 0; i < ARRAY_SIZE(drm_sysfs_device_attrs); i++) {
-		err = device_create_file(drm_sysfs_dev,
-					 &drm_sysfs_device_attrs[i]);
+	for (i = 0; i < ARRAY_SIZE(class_device_attrs); i++) {
+		err = class_device_create_file(class_dev,
+					       &class_device_attrs[i]);
 		if (err)
 			goto err_out_files;
 	}
 
-	return drm_sysfs_dev;
+	return class_dev;
 
 err_out_files:
 	if (i > 0)
 		for (j = 0; j < i; j++)
-			device_remove_file(drm_sysfs_dev,
-					   &drm_sysfs_device_attrs[i]);
-	device_unregister(drm_sysfs_dev);
+			class_device_remove_file(class_dev,
+						 &class_device_attrs[i]);
+	class_device_unregister(class_dev);
 err_out:
 	return ERR_PTR(err);
 }
 
 /**
- * drm_sysfs_device_remove - removes a device that was created with drm_sysfs_device_add()
- * @drm_sysfs_dev: the device that was previously registered
+ * drm_sysfs_device_remove - removes a class device that was created with drm_sysfs_device_add()
+ * @dev: the dev_t of the device that was previously registered.
  *
  * This call unregisters and cleans up a class device that was created with a
  * call to drm_sysfs_device_add()
  */
-void drm_sysfs_device_remove(struct device *drm_sysfs_dev)
+void drm_sysfs_device_remove(struct class_device *class_dev)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(drm_sysfs_device_attrs); i++)
-		device_remove_file(drm_sysfs_dev, &drm_sysfs_device_attrs[i]);
-	device_unregister(drm_sysfs_dev);
+	for (i = 0; i < ARRAY_SIZE(class_device_attrs); i++)
+		class_device_remove_file(class_dev, &class_device_attrs[i]);
+	class_device_unregister(class_dev);
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
file-capabilities-allow-sigcont-within-session-v2.patch
pnp-increase-the-maximum-number-of-resources-fix.patch
fix-linux-kdh-usage-in-userspace-checkpatch-fixes.patch
revert-keyspan-init-termios-properly.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-cpufreq.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
git-mips-fixup.patch
git-mmc.patch
git-mtd.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
msi-set-en-bit-of-msi-mapping-capability-on-ht-platform-fix.patch
git-sh-fixup.patch
git-scsi-misc-fixup.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
bidi-support-scsi_data_buffer-broke-qla1280.patch
bidi-support-scsi_data_buffer-broke-lots-of-stuff.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-cryptodev.patch
git-xtensa.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
mm-add-dirty_highmem-option-fix.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
alpha-atomic_add_return-should-return-int.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
kernel-printkc-concerns-about-the-console-handover.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
sync_sb_inodes-propagate-errors.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
w1-build-fix.patch
