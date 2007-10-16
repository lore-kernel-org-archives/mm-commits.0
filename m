From: akpm@linux-foundation.org
Subject: + git-alsa-fixup.patch added to -mm tree
Date: Tue, 16 Oct 2007 13:15:27 -0700
Message-ID: <200710162015.l9GKFR5L013745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50533 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964887AbXJPUPj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:15:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, perex@suse.cz, tiwai@suse.de


The patch titled
     git-alsa-fixup
has been added to the -mm tree.  Its filename is
     git-alsa-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-alsa-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Fix git rejects aginst mainline.

Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/sparc/cs4231.c |   62 -----------------------------------------
 1 file changed, 62 deletions(-)

diff -puN sound/sparc/cs4231.c~git-alsa-fixup sound/sparc/cs4231.c
--- a/sound/sparc/cs4231.c~git-alsa-fixup
+++ a/sound/sparc/cs4231.c
@@ -400,14 +400,8 @@ static void snd_cs4231_mce_up(struct snd
 
 static void snd_cs4231_mce_down(struct snd_cs4231 *chip)
 {
-<<<<<<< HEAD:sound/sparc/cs4231.c
-	unsigned long flags;
-	unsigned long end_time;
-	int timeout;
-=======
 	unsigned long flags, timeout;
 	int reg;
->>>>>>> FETCH_HEAD:sound/sparc/cs4231.c
 
 	snd_cs4231_busy_wait(chip);
 	spin_lock_irqsave(&chip->lock, flags);
@@ -417,84 +411,28 @@ static void snd_cs4231_mce_down(struct s
 			    CS4231U(chip, REGSEL));
 #endif
 	chip->mce_bit &= ~CS4231_MCE;
-<<<<<<< HEAD:sound/sparc/cs4231.c
-	timeout = __cs4231_readb(chip, CS4231U(chip, REGSEL));
-	__cs4231_writeb(chip, chip->mce_bit | (timeout & 0x1f),
-=======
 	reg = __cs4231_readb(chip, CS4231U(chip, REGSEL));
 	__cs4231_writeb(chip, chip->mce_bit | (reg & 0x1f),
->>>>>>> FETCH_HEAD:sound/sparc/cs4231.c
 			CS4231U(chip, REGSEL));
-<<<<<<< HEAD:sound/sparc/cs4231.c
-	if (timeout == 0x80)
-		snd_printdd("mce_down [%p]: serious init problem - "
-			    "codec still busy\n",
-			    chip->port);
-	if ((timeout & CS4231_MCE) == 0) {
-=======
 	if (reg == 0x80)
 		snd_printdd("mce_down [%p]: serious init problem "
 			    "- codec still busy\n", chip->port);
 	if ((reg & CS4231_MCE) == 0) {
->>>>>>> FETCH_HEAD:sound/sparc/cs4231.c
 		spin_unlock_irqrestore(&chip->lock, flags);
 		return;
 	}
-<<<<<<< HEAD:sound/sparc/cs4231.c
-
-	/*
-	 * Wait for (possible -- during init auto-calibration may not be set)
-	 * calibration process to start. Needs upto 5 sample periods on AD1848
-	 * which at the slowest possible rate of 5.5125 kHz means 907 us.
-	 */
-	msleep(1);
 
-	/* check condition up to 250ms */
-	end_time = jiffies + msecs_to_jiffies(250);
-	while (snd_cs4231_in(chip, CS4231_TEST_INIT) &
-		CS4231_CALIB_IN_PROGRESS) {
-=======
->>>>>>> FETCH_HEAD:sound/sparc/cs4231.c
-
-<<<<<<< HEAD:sound/sparc/cs4231.c
-=======
 	/*
 	 * Wait for auto-calibration (AC) process to finish, i.e. ACI to go low.
 	 */
 	timeout = jiffies + msecs_to_jiffies(250);
 	do {
->>>>>>> FETCH_HEAD:sound/sparc/cs4231.c
 		spin_unlock_irqrestore(&chip->lock, flags);
-<<<<<<< HEAD:sound/sparc/cs4231.c
-		if (time_after(jiffies, end_time)) {
-			snd_printk("mce_down - "
-				   "auto calibration time out (2)\n");
-			return;
-		}
-=======
->>>>>>> FETCH_HEAD:sound/sparc/cs4231.c
 		msleep(1);
 		spin_lock_irqsave(&chip->lock, flags);
-<<<<<<< HEAD:sound/sparc/cs4231.c
-	}
-
-	/* check condition up to 100ms */
-	end_time = jiffies + msecs_to_jiffies(100);
-	while (__cs4231_readb(chip, CS4231U(chip, REGSEL)) & CS4231_INIT) {
-		spin_unlock_irqrestore(&chip->lock, flags);
-		if (time_after(jiffies, end_time)) {
-			snd_printk("mce_down - "
-				   "auto calibration time out (3)\n");
-			return;
-		}
-		msleep(1);
-		spin_lock_irqsave(&chip->lock, flags);
-	}
-=======
 		reg = snd_cs4231_in(chip, CS4231_TEST_INIT);
 		reg &= CS4231_CALIB_IN_PROGRESS;
 	} while (reg && time_before(jiffies, timeout));
->>>>>>> FETCH_HEAD:sound/sparc/cs4231.c
 	spin_unlock_irqrestore(&chip->lock, flags);
 
 	if (reg)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
applesmc-for-mac-pro-2-x-quad-core-fix.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-jg-warning-fixes.patch
git-jg-misc-powernow-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
forcedeth-power-down-phy-when-interface-is-down-checkpatch-fixes.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-nfs-vs-git-unionfs.patch
git-nfsd-fixup.patch
qla2xxx-printk-fixes.patch
sparc-support-for-new-termios-checkpatch-fixes.patch
git-unionfs.patch
git-watchdog-fixup.patch
git-wireless.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
intel_cacheinfo-misc-section-annotation-fixes.patch
asm-i386-ioh-fix-constness.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
git-xfs.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
mm-bdi-init-hooks.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-fix-2.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
oom-change-all_unreclaimable-zone-member-to-flags-fix.patch
oom-do-not-take-callback_mutex-fix.patch
writeback-dont-propagate-aop_writepage_activate.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
add-in-sunos-41x-compatible-mode-for-ufs-fix.patch
core_pattern-fix-up-a-few-miscellaneous-bugs-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
deprecate-aout-elf-interpreters-fix.patch
ext2-ext3-ext4-add-block-bitmap-validation-fix.patch
pie-executable-randomization-fix-2.patch
binfmt_flat-warning-fixes.patch
console-events-and-accessibility-fix.patch
send-quota-messages-via-netlink-fix-fix.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
reiserfs-workaround-for-dead-loop-in-finish_unfinished-fix.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
tty-expose-new-methods-needed-for-drivers-to-get-termios-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
userc-ifdef-mq_bytes-fix.patch
f_dupfd_cloexec-implementation-fix-2.patch
ext3-lighten-up-resize-transaction-requirements-checkpatch-fixes.patch
drivers-char-ip2-fix-used-uninitd-bug-checkpatch-fixes.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
writeback-fix-time-ordering-of-the-per-superblock-inode-lists-8.patch
writeback-remove-pages_skipped-accounting-in-__block_write_full_page-fix.patch
revert-faster-ext2_clear_inode.patch
ext2-reservations-fix-for-percpu_counter-changes.patch
md-software-raid-autodetect-dev-list-not-array.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist-fix.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
pnp-use-dev_info-dev_err-etc-in-core-fix.patch
pnp-add-debug-message-for-adding-new-device-fix-fix.patch
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
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
profile-likely-unlikely-macros-fix.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
