From: akpm@linux-foundation.org
Subject: - git-acpi-fixup.patch removed from -mm tree
Date: Sun, 23 Sep 2007 17:18:05 -0700
Message-ID: <200709240018.l8O0I6fW001414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33657 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbXIXASh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Sep 2007 20:18:37 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8O0I6Xv025934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Sun, 23 Sep 2007 17:18:07 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-acpi-fixup
has been removed from the -mm tree.  Its filename was
     git-acpi-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-acpi-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/thinkpad-acpi.txt |   75 ------------------------------
 1 file changed, 75 deletions(-)

diff -puN Documentation/thinkpad-acpi.txt~git-acpi-fixup Documentation/thinkpad-acpi.txt
--- a/Documentation/thinkpad-acpi.txt~git-acpi-fixup
+++ a/Documentation/thinkpad-acpi.txt
@@ -173,17 +173,10 @@ below), the driver will report HKEY even
 
 Some of these events refer to hot key presses, but not all.
 
-<<<<<<< HEAD/Documentation/thinkpad-acpi.txt
-The driver will generate events over the input layer for hot keys and
-radio switches, and over the ACPI netlink layer for other events.  The
-input layer support accepts the standard IOCTLs to remap the keycodes
-assigned to each hot key.
-=======
 The driver will generate events over the input layer for hot keys and
 radio switches, and over the netlink layer for other events.  The input
 layer support accepts the standard IOCTLs to remap the keycodes assigned
 to each hot key.
->>>>>>> /Documentation/thinkpad-acpi.txt
 
 The hot key bit mask allows some control over which hot keys generate
 events.  If a key is "masked" (bit set to 0 in the mask), the firmware
@@ -265,22 +258,6 @@ sysfs notes:
 		disabled" postition, and 1 if the switch is in the
 		"radios enabled" position.
 
-<<<<<<< HEAD/Documentation/thinkpad-acpi.txt
-	hotkey_report_mode:
-		Returns the state of the procfs ACPI event report mode
-		filter for hot keys.  If it is set to 1 (the default),
-		all hot key presses are reported both through the input
-		layer and also as ACPI events through procfs (but not
-		through netlink).  If it is set to 2, hot key presses
-		are reported only through the input layer.
-
-		This attribute is read-only in kernels 2.6.23 or later,
-		and read-write on earlier kernels.
-
-		May return -EPERM (write access locked out by module
-		parameter) or -EACCES (read-only).
-
-=======
 	hotkey_report_mode:
 		Returns the state of the procfs ACPI event report mode
 		filter for hot keys.  If 1, all hot key presses are
@@ -294,7 +271,6 @@ sysfs notes:
 		May return -EPERM (write access locked out by module
 		parameter) or -EACCES (read-only).
 
->>>>>>> /Documentation/thinkpad-acpi.txt
 input layer notes:
 
 A Hot key is mapped to a single input layer EV_KEY event, possibly
@@ -442,55 +418,6 @@ Non hot-key ACPI HKEY event map:
 0x5002		Lid opened
 0x7000		Radio Switch may have changed state
 
-<<<<<<< HEAD/Documentation/thinkpad-acpi.txt
-The above events are not propagated by the driver, except for legacy
-compatibility purposes when hotkey_report_mode is set to 1.
-
-Compatibility notes:
-
-ibm-acpi and thinkpad-acpi 0.15 (mainline kernels before 2.6.23) never
-supported the input layer, and sent events over the procfs ACPI event
-interface.
-
-To avoid sending duplicate events over the input layer and the ACPI
-event interface, thinkpad-acpi 0.16 implements a module parameter
-(hotkey_report_mode), and also a sysfs device attribute with the same
-name.
-
-Make no mistake here: userspace is expected to switch to using the input
-layer interface of thinkpad-acpi, together with the ACPI netlink event
-interface in kernels 2.6.23 and later, or with the ACPI procfs event
-interface in kernels 2.6.22 and earlier.
-
-If no hotkey_report_mode module parameter is specified (or it is set to
-zero), the driver defaults to mode 1 (see below), and on kernels 2.6.22
-and earlier, also allows one to change the hotkey_report_mode through
-sysfs.  In kernels 2.6.23 and later, where the netlink ACPI event
-interface is available, hotkey_report_mode cannot be changed through
-sysfs (it is read-only).
-
-If the hotkey_report_mode module parameter is set to 1 or 2, it cannot
-be changed later through sysfs (any writes will return -EPERM to signal
-that hotkey_report_mode was locked.  On 2.6.23 and later, where
-hotkey_report_mode cannot be changed at all, writes will return -EACES).
-
-hotkey_report_mode set to 1 makes the driver export through the procfs
-ACPI event interface all hot key presses (which are *also* sent to the
-input layer).  This is a legacy compatibility behaviour, and it is also
-the default mode of operation for the driver.
-
-hotkey_report_mode set to 2 makes the driver filter out the hot key
-presses from the procfs ACPI event interface, so these events will only
-be sent through the input layer.  Userspace that has been updated to use
-the thinkpad-acpi input layer interface should set hotkey_report_mode to
-2.
-
-Hot key press events are never sent to the ACPI netlink event interface.
-Really up-to-date userspace under kernel 2.6.23 and later is to use the
-netlink interface and the input layer interface, and don't bother at all
-with hotkey_report_mode.
-
-=======
 The above events are not propagated by the driver, except for legacy
 compatibility purposes when hotkey_report_mode is set to 1.
 
@@ -534,8 +461,6 @@ Really up-to-date userspace under kernel
 netlink interface and the input layer interface, and don't bother at all
 with hotkey_report_mode.
 
->>>>>>> /Documentation/thinkpad-acpi.txt
-
 Bluetooth
 ---------
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
missing-null-termination-in-one-wire-uevent.patch
fix-oops-in-platform-uevent.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
git-alsa-kconfig-fix.patch
alsa-procfs-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
fix-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
fix-2--gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
git-jg-misc-fix.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mips.patch
git-mips-fixup.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-net.patch
git-net-fixup.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net-sky2-fixups.patch
git-net-fix-wireless-kconfig.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
git-backlight-build-fix.patch
git-backlight-dependency-fix.patch
revert-git-battery.patch
git-net-vs-git-nfs.patch
git-nfs-vs-git-unionfs.patch
git-nfsd.patch
git-ocfs2.patch
revert-gregkh-pci-pci_bridge-device.patch
pci-remove-irritating-try-pci=assign-busses-warning.patch
fix-ide-legacy-mode-resources-fix.patch
i386-compaq-evo-n800c-needs-pci-bus-renumbering-fix.patch
git-s390.patch
git-scsi-misc.patch
git-scsi-misc-fixup.patch
git-scsi-misc-arcmsr-build-fix.patch
advansys-printk-fix.patch
git-block.patch
git-block-fixup.patch
git-block-fix-headers_check.patch
git-block-fix-qlogicpti-build.patch
git-unionfs.patch
git-unionfs-fix-2.patch
fix-gregkh-usb-usb-sisusb2vga-convert-printk-to-dev_-macros.patch
git-wireless.patch
git-wireless-fixup.patch
git-wireless-vs-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
net-add-ath5k-wireless-driver-fix.patch
iwl3945-is-bust.patch
p54pci-terminate-pci-table.patch
git-wireless-b44-is-bust.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-fix.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-fix.patch
git-xfs.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix.patch
readahead-combine-file_ra_stateprev_index-prev_offset-into-prev_pos-fix-2.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
mm-use-pagevec-to-rotate-reclaimable-page-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
git-nfs-vs-nfs-convert-to-new-aops.patch
git-nfs-vs-nfs-convert-to-new-aops-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2.patch
categorize-gfp-flags-fix.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
mm-mempolicyc-cleanups-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
uml-clocksource-support-fix.patch
uml-tickless-support-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
i386-and-x86_64-randomize-brk-fix.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
keys-make-request_key-and-co-fundamentally-asynchronous-vs-git-mmc.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
ecryptfs-printk-warning-fixes.patch
tdfxfb-mtrr-support-fix.patch
fbdev-fb_create_modedb-non-static-int-first-=-1-fix.patch
intel-fb-support-for-interlaced-video-modes.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
md-software-raid-autodetect-dev-list-not-array-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
