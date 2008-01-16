From: akpm@linux-foundation.org
Subject: + revert-gregkh-usb-usb-export-suspend-statistics.patch added to -mm tree
Date: Wed, 16 Jan 2008 03:48:25 -0800
Message-ID: <200801161156.m0GBukQI002645@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52595 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415AbYAPL4x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Jan 2008 06:56:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@linux.intel.com, greg@kroah.com, saharabeara@gmail.com


The patch titled
     revert gregkh-usb-usb-export-suspend-statistics
has been added to the -mm tree.  Its filename is
     revert-gregkh-usb-usb-export-suspend-statistics.patch

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
Subject: revert gregkh-usb-usb-export-suspend-statistics
From: Andrew Morton <akpm@linux-foundation.org>

busted with CONFIG_PM=n

Cc: Sarah Sharp <saharabeara@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Arjan Van De Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/core/hub.c   |   10 --------
 drivers/usb/core/sysfs.c |   46 -------------------------------------
 drivers/usb/core/usb.c   |    2 -
 include/linux/usb.h      |    2 -
 4 files changed, 1 insertion(+), 59 deletions(-)

diff -puN drivers/usb/core/hub.c~revert-gregkh-usb-usb-export-suspend-statistics drivers/usb/core/hub.c
--- a/drivers/usb/core/hub.c~revert-gregkh-usb-usb-export-suspend-statistics
+++ a/drivers/usb/core/hub.c
@@ -1034,10 +1034,8 @@ static void recursively_mark_NOTATTACHED
 		if (udev->children[i])
 			recursively_mark_NOTATTACHED(udev->children[i]);
 	}
-	if (udev->state == USB_STATE_SUSPENDED) {
+	if (udev->state == USB_STATE_SUSPENDED)
 		udev->discon_suspended = 1;
-		udev->active_duration -= jiffies;
-	}
 	udev->state = USB_STATE_NOTATTACHED;
 }
 
@@ -1086,12 +1084,6 @@ void usb_set_device_state(struct usb_dev
 			else
 				device_init_wakeup(&udev->dev, 0);
 		}
-		if (udev->state == USB_STATE_SUSPENDED &&
-			new_state != USB_STATE_SUSPENDED)
-			udev->active_duration -= jiffies;
-		else if (new_state == USB_STATE_SUSPENDED &&
-				udev->state != USB_STATE_SUSPENDED)
-			udev->active_duration += jiffies;
 		udev->state = new_state;
 	} else
 		recursively_mark_NOTATTACHED(udev);
diff -puN drivers/usb/core/sysfs.c~revert-gregkh-usb-usb-export-suspend-statistics drivers/usb/core/sysfs.c
--- a/drivers/usb/core/sysfs.c~revert-gregkh-usb-usb-export-suspend-statistics
+++ a/drivers/usb/core/sysfs.c
@@ -249,38 +249,6 @@ static void remove_persist_attributes(st
 #ifdef	CONFIG_USB_SUSPEND
 
 static ssize_t
-show_connected_duration(struct device *dev, struct device_attribute *attr,
-		char *buf)
-{
-	struct usb_device *udev = to_usb_device(dev);
-
-	return sprintf(buf, "%lu\n", jiffies - udev->connect_time);
-}
-
-static DEVICE_ATTR(connected_duration, S_IRUGO, show_connected_duration, NULL);
-
-/*
- * If the device is resumed, the last time the device was suspended has
- * been pre-subtracted from active_duration.  We add the current time to
- * get the duration that the device was actually active.
- *
- * If the device is suspended, the active_duration is up-to-date.
- */
-static ssize_t
-show_active_duration(struct device *dev, struct device_attribute *attr,
-		char *buf)
-{
-	struct usb_device *udev = to_usb_device(dev);
-
-	if (udev->state != USB_STATE_SUSPENDED)
-		return sprintf(buf, "%lu\n", jiffies + udev->active_duration);
-	else
-		return sprintf(buf, "%lu\n", udev->active_duration);
-}
-
-static DEVICE_ATTR(active_duration, S_IRUGO, show_active_duration, NULL);
-
-static ssize_t
 show_autosuspend(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct usb_device *udev = to_usb_device(dev);
@@ -397,14 +365,6 @@ static int add_power_attributes(struct d
 			rc = sysfs_add_file_to_group(&dev->kobj,
 					&dev_attr_level.attr,
 					power_group);
-		if (rc == 0)
-			rc = sysfs_add_file_to_group(&dev->kobj,
-					&dev_attr_connected_duration.attr,
-					power_group);
-		if (rc == 0)
-			rc = sysfs_add_file_to_group(&dev->kobj,
-					&dev_attr_active_duration.attr,
-					power_group);
 	}
 	return rc;
 }
@@ -412,12 +372,6 @@ static int add_power_attributes(struct d
 static void remove_power_attributes(struct device *dev)
 {
 	sysfs_remove_file_from_group(&dev->kobj,
-			&dev_attr_active_duration.attr,
-			power_group);
-	sysfs_remove_file_from_group(&dev->kobj,
-			&dev_attr_connected_duration.attr,
-			power_group);
-	sysfs_remove_file_from_group(&dev->kobj,
 			&dev_attr_level.attr,
 			power_group);
 	sysfs_remove_file_from_group(&dev->kobj,
diff -puN drivers/usb/core/usb.c~revert-gregkh-usb-usb-export-suspend-statistics drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c~revert-gregkh-usb-usb-export-suspend-statistics
+++ a/drivers/usb/core/usb.c
@@ -339,8 +339,6 @@ usb_alloc_dev(struct usb_device *parent,
 	mutex_init(&dev->pm_mutex);
 	INIT_DELAYED_WORK(&dev->autosuspend, usb_autosuspend_work);
 	dev->autosuspend_delay = usb_autosuspend_delay * HZ;
-	dev->connect_time = jiffies;
-	dev->active_duration = -jiffies;
 #endif
 	if (root_hub)	/* Root hub always ok [and always wired] */
 		dev->authorized = 1;
diff -puN include/linux/usb.h~revert-gregkh-usb-usb-export-suspend-statistics include/linux/usb.h
--- a/include/linux/usb.h~revert-gregkh-usb-usb-export-suspend-statistics
+++ a/include/linux/usb.h
@@ -425,8 +425,6 @@ struct usb_device {
 
 	unsigned long last_busy;	/* time of last use */
 	int autosuspend_delay;		/* in jiffies */
-	unsigned long active_duration;	/* total time device is not suspended */
-	unsigned long connect_time;	/* time device was first connected */
 
 	unsigned auto_pm:1;		/* autosuspend/resume in progress */
 	unsigned do_remote_wakeup:1;	/* remote wakeup should be enabled */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
address-hfs-on-disk-corruption-robustness-review-comments-checkpatch-fixes.patch
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
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-resume.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
intel_agp-add-new-chipset-ids-checkpatch-fixes.patch
git-arm.patch
git-audit-master.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
drivers-md-dm-ioctlc-fix-uninitialized-var-warning.patch
drivers-md-dm-tablec-fix-uninitialized-var-warning.patch
git-powerpc.patch
git-powerpc-fixup.patch
revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
git-dvb.patch
drivers-media-dvb-frontends-xc5000c-dont-return-garbage-from-xc5000_init.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-dont-direct-your-stderr-to-dev-null.patch
git-infiniband-versus-driver-tree.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-wtf.patch
git-libata-drivers-ata-pata_pcmciac-fixup.patch
git-libata-more-pata-fixes.patch
drivers-ide-ide-acpic-fix-uninitialized-var-warning.patch
drivers-ide-legacy-hdc-fix-uninitialized-var-warning.patch
git-md-accel.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-ubi-wlc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-scanc-fix-uninitialized-var-warning.patch
drivers-mtd-ubi-cdevc-unused-var.patch
git-net.patch
git-net-fix-conflicts.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
git-netdev-all-fix-conflicts.patch
git-netdev-all-fix-conflicts-fix.patch
git-net-vs-git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
git-battery.patch
bluetooth-uninlining.patch
net-sunrpc-schedc-revert-git-net-changes.patch
net-sunrpc-schedc-reapply-git-net-changes.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
fix-gregkh-pci-pci-make-pci-extended-config-space-a-driver-opt-in.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-git-libata-all.patch
git-scsi-misc-vs-gregkh-pci-pci-remove-users-of-pci_enable_device_bars.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
drivers-scsi-dc395xc-fix-uninitialized-var-warning.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
revert-gregkh-usb-usb-ti_usb-termios-cleanups.patch
revert-gregkh-usb-usb-export-suspend-statistics.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
wdt-fix-locking-checkpatch-fixes.patch
git-wireless.patch
drivers-net-wireless-iwlwifi-iwl-3945c-fix-printk-warning.patch
drivers-net-wireless-iwlwifi-iwl-4965c-fix-printk-warning.patch
drivers-net-wireless-rt2x00-rt2x00usbc-fix-uninitialized-var-warning.patch
git-ipwireless_cs.patch
revert-kvm-stuff-to-make-git-x86-apply.patch
git-x86.patch
git-x86-fix-conflicts.patch
git-x86-fixup.patch
git-x86-fixup-2.patch
git-x86-vs-something-else.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
arch-x86-mm-numa_64c-section-fix.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
pci-dont-load-acpi_php-when-acpi-is-disabled-fix.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch
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
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
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
rtc-add-support-for-the-s-35390a-rtc-chip.patch
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
