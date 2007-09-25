From: akpm@linux-foundation.org
Subject: + git-jg-warning-fixes.patch added to -mm tree
Date: Tue, 25 Sep 2007 00:07:03 -0700
Message-ID: <200709250707.l8P773c2005802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35739 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089AbXIYHHM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Sep 2007 03:07:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, jeff@garzik.org


The patch titled
     git-jg-warning-fixes
has been added to the -mm tree.  Its filename is
     git-jg-warning-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-jg-warning-fixes
From: Andrew Morton <akpm@linux-foundation.org>

arch/i386/kernel/acpi/sleep.c:95: warning: initialization from incompatible pointer type
drivers/acpi/processor_idle.c:183: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:968: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:980: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:988: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:996: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1004: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1012: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1020: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1028: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1036: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1044: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1052: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1060: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1072: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1089: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1097: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1108: warning: initialization from incompatible pointer type
arch/i386/kernel/acpi/boot.c:1119: warning: initialization from incompatible pointer type

Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c  |    8 ++++----
 arch/i386/kernel/acpi/sleep.c |    2 +-
 drivers/acpi/processor_idle.c |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN arch/i386/kernel/acpi/sleep.c~git-jg-warning-fixes arch/i386/kernel/acpi/sleep.c
--- a/arch/i386/kernel/acpi/sleep.c~git-jg-warning-fixes
+++ a/arch/i386/kernel/acpi/sleep.c
@@ -84,7 +84,7 @@ __setup("acpi_sleep=", acpi_sleep_setup)
 
 /* Ouch, we want to delete this. We already have better version in userspace, in
    s2ram from suspend.sf.net project */
-static __init int reset_videomode_after_s3(struct dmi_system_id *d)
+static __init int reset_videomode_after_s3(const struct dmi_system_id *d)
 {
 	acpi_realmode_flags |= 2;
 	return 0;
diff -puN arch/i386/kernel/acpi/boot.c~git-jg-warning-fixes arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~git-jg-warning-fixes
+++ a/arch/i386/kernel/acpi/boot.c
@@ -907,7 +907,7 @@ static void __init acpi_process_madt(voi
 
 #ifdef __i386__
 
-static int __init disable_acpi_irq(struct dmi_system_id *d)
+static int __init disable_acpi_irq(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
 		printk(KERN_NOTICE "%s detected: force use of acpi=noirq\n",
@@ -917,7 +917,7 @@ static int __init disable_acpi_irq(struc
 	return 0;
 }
 
-static int __init disable_acpi_pci(struct dmi_system_id *d)
+static int __init disable_acpi_pci(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
 		printk(KERN_NOTICE "%s detected: force use of pci=noacpi\n",
@@ -927,7 +927,7 @@ static int __init disable_acpi_pci(struc
 	return 0;
 }
 
-static int __init dmi_disable_acpi(struct dmi_system_id *d)
+static int __init dmi_disable_acpi(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
 		printk(KERN_NOTICE "%s detected: acpi off\n", d->ident);
@@ -942,7 +942,7 @@ static int __init dmi_disable_acpi(struc
 /*
  * Limit ACPI to CPU enumeration for HT
  */
-static int __init force_acpi_ht(struct dmi_system_id *d)
+static int __init force_acpi_ht(const struct dmi_system_id *d)
 {
 	if (!acpi_force) {
 		printk(KERN_NOTICE "%s detected: force use of acpi=ht\n",
diff -puN arch/i386/kernel/cpu/cpufreq/powernow-k7.c~git-jg-warning-fixes arch/i386/kernel/cpu/cpufreq/powernow-k7.c
diff -puN drivers/acpi/processor_idle.c~git-jg-warning-fixes drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~git-jg-warning-fixes
+++ a/drivers/acpi/processor_idle.c
@@ -113,7 +113,7 @@ static int set_max_cstate(const struct d
  * Dell provides a driver for other operating systems to hack around this bug, so we know
  * it's safe.
  */
-static int dmi_force_c3(struct dmi_system_id *id)
+static int dmi_force_c3(const struct dmi_system_id *id)
 {
 	forced_c3 = 1;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

missing-null-termination-in-one-wire-uevent.patch
fix-oops-in-platform-uevent.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-cifs-build-fix.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
revert-gregkh-driver-warn-when-statically-allocated-kobjects-are-used.patch
fix-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
fix-2--gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
fix-gregkh-driver-drivers-clean-up-direct-setting-of-the-name-of-a-kset.patch
git-dvb.patch
git-dvb-fixup-2.patch
git-dvb-build-fix.patch
git-hwmon-fixup.patch
git-infiniband.patch
infiniband-work-around-gcc-slub-problem.patch
git-input.patch
git-input-fixup.patch
adbhid-produce-all-capslock-key-events.patch
console-keyboard-events-and-accessibility-fix.patch
console-keyboard-events-and-accessibility-fix-2.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers-fix.patch
git-jg-misc-fix.patch
git-jg-warning-fixes.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-kvm.patch
git-libata-all.patch
ide-arm-hack.patch
git-mips.patch
git-mmc.patch
git-mmc-fixup2.patch
mmc-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct-vs-git-mmc.patch
git-mtd.patch
git-mtd-vs-powerpc.patch
git-net.patch
git-net-fixup.patch
revert-8139too-clean-up-i-o-remapping.patch
git-net-sky2-fixups.patch
git-net-fix-wireless-kconfig.patch
net-atm-lecc-printk-warning-fix.patch
git-backlight.patch
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
git-sched-build-fix.patch
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
p54pci-terminate-pci-table.patch
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
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix-2-3.patch
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
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
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
use-extended-crashkernel-command-line-on-i386-fix-config_nohighmem-for-extended-crashkernel-command-line-fix.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix.patch
rework-proc-locks-via-seq_files-and-seq_list-helpers-fix-2.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
