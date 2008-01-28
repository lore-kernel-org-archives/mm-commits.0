From: akpm@linux-foundation.org
Subject: - revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch removed from -mm tree
Date: Mon, 28 Jan 2008 15:59:49 -0800
Message-ID: <200801282359.m0SNxnBV023189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52680 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967AbYA1X7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 18:59:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     revert gregkh-driver-atm-convert-struct-class_device-to-struct-device
has been removed from the -mm tree.  Its filename was
     revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert gregkh-driver-atm-convert-struct-class_device-to-struct-device
From: Andrew Morton <akpm@linux-foundation.org>

Davem merged it - please drop.

Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/atmdev.h |    4 +-
 net/atm/atm_sysfs.c    |   66 +++++++++++++++++----------------------
 2 files changed, 32 insertions(+), 38 deletions(-)

diff -puN include/linux/atmdev.h~revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device include/linux/atmdev.h
--- a/include/linux/atmdev.h~revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device
+++ a/include/linux/atmdev.h
@@ -359,7 +359,7 @@ struct atm_dev {
 	struct proc_dir_entry *proc_entry; /* proc entry */
 	char *proc_name;		/* proc entry name */
 #endif
-	struct device class_dev;	/* sysfs device */
+	struct class_device class_dev;	/* sysfs class device */
 	struct list_head dev_list;	/* linkage */
 };
 
@@ -461,7 +461,7 @@ static inline void atm_dev_put(struct at
 		BUG_ON(!test_bit(ATM_DF_REMOVED, &dev->flags));
 		if (dev->ops->dev_close)
 			dev->ops->dev_close(dev);
-		put_device(&dev->class_dev);
+		class_device_put(&dev->class_dev);
 	}
 }
 
diff -puN net/atm/atm_sysfs.c~revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device net/atm/atm_sysfs.c
--- a/net/atm/atm_sysfs.c~revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device
+++ a/net/atm/atm_sysfs.c
@@ -9,15 +9,13 @@
 
 #define to_atm_dev(cldev) container_of(cldev, struct atm_dev, class_dev)
 
-static ssize_t show_type(struct device *cdev,
-			 struct device_attribute *attr, char *buf)
+static ssize_t show_type(struct class_device *cdev, char *buf)
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
 	return sprintf(buf, "%s\n", adev->type);
 }
 
-static ssize_t show_address(struct device *cdev,
-			    struct device_attribute *attr, char *buf)
+static ssize_t show_address(struct class_device *cdev, char *buf)
 {
 	char *pos = buf;
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -30,8 +28,7 @@ static ssize_t show_address(struct devic
 	return pos - buf;
 }
 
-static ssize_t show_atmaddress(struct device *cdev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t show_atmaddress(struct class_device *cdev, char *buf)
 {
 	unsigned long flags;
 	char *pos = buf;
@@ -57,8 +54,7 @@ static ssize_t show_atmaddress(struct de
 	return pos - buf;
 }
 
-static ssize_t show_carrier(struct device *cdev,
-			    struct device_attribute *attr, char *buf)
+static ssize_t show_carrier(struct class_device *cdev, char *buf)
 {
 	char *pos = buf;
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -69,8 +65,7 @@ static ssize_t show_carrier(struct devic
 	return pos - buf;
 }
 
-static ssize_t show_link_rate(struct device *cdev,
-			      struct device_attribute *attr, char *buf)
+static ssize_t show_link_rate(struct class_device *cdev, char *buf)
 {
 	char *pos = buf;
 	struct atm_dev *adev = to_atm_dev(cdev);
@@ -95,23 +90,22 @@ static ssize_t show_link_rate(struct dev
 	return pos - buf;
 }
 
-static DEVICE_ATTR(address, S_IRUGO, show_address, NULL);
-static DEVICE_ATTR(atmaddress, S_IRUGO, show_atmaddress, NULL);
-static DEVICE_ATTR(carrier, S_IRUGO, show_carrier, NULL);
-static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
-static DEVICE_ATTR(link_rate, S_IRUGO, show_link_rate, NULL);
-
-static struct device_attribute *atm_attrs[] = {
-	&dev_attr_atmaddress,
-	&dev_attr_address,
-	&dev_attr_carrier,
-	&dev_attr_type,
-	&dev_attr_link_rate,
+static CLASS_DEVICE_ATTR(address, S_IRUGO, show_address, NULL);
+static CLASS_DEVICE_ATTR(atmaddress, S_IRUGO, show_atmaddress, NULL);
+static CLASS_DEVICE_ATTR(carrier, S_IRUGO, show_carrier, NULL);
+static CLASS_DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
+static CLASS_DEVICE_ATTR(link_rate, S_IRUGO, show_link_rate, NULL);
+
+static struct class_device_attribute *atm_attrs[] = {
+	&class_device_attr_atmaddress,
+	&class_device_attr_address,
+	&class_device_attr_carrier,
+	&class_device_attr_type,
+	&class_device_attr_link_rate,
 	NULL
 };
 
-
-static int atm_uevent(struct device *cdev, struct kobj_uevent_env *env)
+static int atm_uevent(struct class_device *cdev, struct kobj_uevent_env *env)
 {
 	struct atm_dev *adev;
 
@@ -128,7 +122,7 @@ static int atm_uevent(struct device *cde
 	return 0;
 }
 
-static void atm_release(struct device *cdev)
+static void atm_release(struct class_device *cdev)
 {
 	struct atm_dev *adev = to_atm_dev(cdev);
 
@@ -137,25 +131,25 @@ static void atm_release(struct device *c
 
 static struct class atm_class = {
 	.name		= "atm",
-	.dev_release	= atm_release,
-	.dev_uevent		= atm_uevent,
+	.release	= atm_release,
+	.uevent		= atm_uevent,
 };
 
 int atm_register_sysfs(struct atm_dev *adev)
 {
-	struct device *cdev = &adev->class_dev;
+	struct class_device *cdev = &adev->class_dev;
 	int i, j, err;
 
 	cdev->class = &atm_class;
-	dev_set_drvdata(cdev, adev);
+	class_set_devdata(cdev, adev);
 
-	snprintf(cdev->bus_id, BUS_ID_SIZE, "%s%d", adev->type, adev->number);
-	err = device_register(cdev);
+	snprintf(cdev->class_id, BUS_ID_SIZE, "%s%d", adev->type, adev->number);
+	err = class_device_register(cdev);
 	if (err < 0)
 		return err;
 
 	for (i = 0; atm_attrs[i]; i++) {
-		err = device_create_file(cdev, atm_attrs[i]);
+		err = class_device_create_file(cdev, atm_attrs[i]);
 		if (err)
 			goto err_out;
 	}
@@ -164,16 +158,16 @@ int atm_register_sysfs(struct atm_dev *a
 
 err_out:
 	for (j = 0; j < i; j++)
-		device_remove_file(cdev, atm_attrs[j]);
-	device_del(cdev);
+		class_device_remove_file(cdev, atm_attrs[j]);
+	class_device_del(cdev);
 	return err;
 }
 
 void atm_unregister_sysfs(struct atm_dev *adev)
 {
-	struct device *cdev = &adev->class_dev;
+	struct class_device *cdev = &adev->class_dev;
 
-	device_del(cdev);
+	class_device_del(cdev);
 }
 
 int __init atm_sysfs_init(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-ignore-acpi-video-devices-that-arent-present-in-hardware-checkpatch-fixes.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-alsa-disable-sound-pci-ice1712-ice1724c.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-audit-master.patch
git-audit-printk-warning-fix.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
git-powerpc.patch
include-asm-powerpc-nvramh-needs-listh.patch
include-asm-powerpc-nvramh-needs-listh-fix.patch
revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip-fix.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband-versus-driver-tree.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kbuild.patch
git-kvm.patch
git-libata-all-fix-drivers-ata-sata_fslc.patch
fix-ide-mm-ide-use-ide_destroy_dmatable-instead-of-pci_unmap_sg.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-ubi-wlc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-scanc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-cdevc-unused-var.patch
git-ubi.patch
git-net.patch
git-net-fix-conflicts.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-net-fix-more-conflicts.patch
git-netdev-all-fix-conflicts.patch
git-netdev-all-fix-conflicts-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
git-battery.patch
bluetooth-uninlining.patch
net-sunrpc-schedc-revert-git-net-changes.patch
net-sunrpc-schedc-reapply-git-net-changes.patch
git-nfsd.patch
git-selinux-vs-git-lblnet.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
fix-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
x86-validate-against-acpi-motherboard-resources.patch
revert-rcu-fix-section-mismatch.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-misc-vs-git-net.patch
git-scsi-misc-vs-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch
scsi-fix-isa-pcmcia-compile-problem-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
fix-gregkh-usb-usb-ti_usb-termios-cleanups.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-dma-bounce-buffer-support-v3-checkpatch-fixes.patch
usb-ohci-sm501-driver-v2-fix.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
drivers-net-wireless-iwlwifi-iwl-3945c-fix-printk-warning.patch
drivers-net-wireless-iwlwifi-iwl-4965c-fix-printk-warning.patch
drivers-net-wireless-rt2x00-rt2x00usbc-fix-uninitialized-var-warning.patch
git-ipwireless_cs.patch
revert-kvm-stuff-to-make-git-x86-apply.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fixup-2.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
git-newsetup.patch
git-cryptodev-fixup.patch
git-xtensa.patch
sysctl-kill-binary-sysctl-kern_ppc_l2cr.patch
cpufreq-fix-obvious-condition-statement-error.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
page-migraton-handle-orphaned-pages-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
export-iov_shorten-for-ext4s-use-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
add-have_oprofile.patch
drivers-isdn-hardware-eicon-debugc-fix-uninitialized-var-warning.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
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
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
rcu-split-listh-and-move-rcu-protected-lists-into-rculisth-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
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
