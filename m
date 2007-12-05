From: akpm@linux-foundation.org
Subject: + timerfd-v3-new-timerfd-api-arch-fixes.patch added to -mm tree
Date: Tue, 04 Dec 2007 16:25:13 -0800
Message-ID: <200712050032.lB50WcC6013168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40672 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXLEAcq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 19:32:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, davidel@xmailserver.org, heiko.carstens@de.ibm.com, mtk.manpages@gmail.com, schwidefsky@de.ibm.com


The patch titled
     timerfd-v3-new-timerfd-api-arch-fixes
has been added to the -mm tree.  Its filename is
     timerfd-v3-new-timerfd-api-arch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: timerfd-v3-new-timerfd-api-arch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

more trainwreckage repair.

The s390 change is probably wrong.

There are still references to compat_sys_timerfd() around the place.

Better patches, please.

Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/systbls.S          |    2 +-
 arch/arm/kernel/calls.S              |    2 +-
 arch/blackfin/mach-common/entry.S    |    2 +-
 arch/cris/arch-v10/kernel/entry.S    |    2 +-
 arch/m68knommu/kernel/syscalltable.S |    2 +-
 arch/s390/kernel/syscalls.S          |    2 +-
 arch/sh/kernel/syscalls_32.S         |    2 +-
 arch/sh/kernel/syscalls_64.S         |    2 +-
 arch/sparc/kernel/systbls.S          |    2 +-
 arch/sparc64/kernel/systbls.S        |    2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff -puN arch/alpha/kernel/systbls.S~timerfd-v3-new-timerfd-api-arch-fixes arch/alpha/kernel/systbls.S
--- a/arch/alpha/kernel/systbls.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/alpha/kernel/systbls.S
@@ -495,7 +495,7 @@ sys_call_table:
 	.quad sys_epoll_pwait
 	.quad sys_utimensat			/* 475 */
 	.quad sys_signalfd
-	.quad sys_timerfd
+	.quad sys_ni_syscall
 	.quad sys_eventfd
 
 	.size sys_call_table, . - sys_call_table
diff -puN arch/arm/kernel/calls.S~timerfd-v3-new-timerfd-api-arch-fixes arch/arm/kernel/calls.S
--- a/arch/arm/kernel/calls.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/arm/kernel/calls.S
@@ -359,7 +359,7 @@
 		CALL(sys_kexec_load)
 		CALL(sys_utimensat)
 		CALL(sys_signalfd)
-/* 350 */	CALL(sys_timerfd)
+/* 350 */	CALL(sys_ni_syscall)
 		CALL(sys_eventfd)
 		CALL(sys_fallocate)
 #ifndef syscalls_counted
diff -puN arch/blackfin/mach-common/entry.S~timerfd-v3-new-timerfd-api-arch-fixes arch/blackfin/mach-common/entry.S
--- a/arch/blackfin/mach-common/entry.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/blackfin/mach-common/entry.S
@@ -1356,7 +1356,7 @@ ENTRY(_sys_call_table)
 	.long _sys_epoll_pwait
 	.long _sys_utimensat
 	.long _sys_signalfd
-	.long _sys_timerfd
+	.long _sys_ni_syscall
 	.long _sys_eventfd	/* 350 */
 	.long _sys_pread64
 	.long _sys_pwrite64
diff -puN arch/cris/arch-v10/kernel/entry.S~timerfd-v3-new-timerfd-api-arch-fixes arch/cris/arch-v10/kernel/entry.S
--- a/arch/cris/arch-v10/kernel/entry.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/cris/arch-v10/kernel/entry.S
@@ -1167,7 +1167,7 @@ sys_call_table:	
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_ni_syscall
 	.long sys_eventfd
 	.long sys_fallocate
 
diff -puN arch/m68knommu/kernel/syscalltable.S~timerfd-v3-new-timerfd-api-arch-fixes arch/m68knommu/kernel/syscalltable.S
--- a/arch/m68knommu/kernel/syscalltable.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/m68knommu/kernel/syscalltable.S
@@ -336,7 +336,7 @@ ENTRY(sys_call_table)
 	.long sys_epoll_pwait		/* 315 */
 	.long sys_utimensat
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_ni_syscall
 	.long sys_eventfd
 	.long sys_fallocate		/* 320 */
 
diff -puN arch/s390/kernel/syscalls.S~timerfd-v3-new-timerfd-api-arch-fixes arch/s390/kernel/syscalls.S
--- a/arch/s390/kernel/syscalls.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/s390/kernel/syscalls.S
@@ -325,5 +325,5 @@ SYSCALL(sys_utimes,sys_utimes,compat_sys
 SYSCALL(s390_fallocate,sys_fallocate,sys_fallocate_wrapper)
 SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
-SYSCALL(sys_timerfd,sys_timerfd,compat_sys_timerfd_wrapper)
+SYSCALL(sys_timerfd,sys_ni_syscall,compat_sys_timerfd_wrapper)
 SYSCALL(sys_eventfd,sys_eventfd,sys_eventfd_wrapper)
diff -puN arch/sh/kernel/syscalls_32.S~timerfd-v3-new-timerfd-api-arch-fixes arch/sh/kernel/syscalls_32.S
--- a/arch/sh/kernel/syscalls_32.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/sh/kernel/syscalls_32.S
@@ -338,6 +338,6 @@ ENTRY(sys_call_table)
 	.long sys_epoll_pwait
 	.long sys_utimensat		/* 320 */
 	.long sys_signalfd
-	.long sys_timerfd
+	.long sys_ni_syscall
 	.long sys_eventfd
 	.long sys_fallocate
diff -puN arch/sh/kernel/syscalls_64.S~timerfd-v3-new-timerfd-api-arch-fixes arch/sh/kernel/syscalls_64.S
--- a/arch/sh/kernel/syscalls_64.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/sh/kernel/syscalls_64.S
@@ -376,6 +376,6 @@ sys_call_table:
 	.long sys_epoll_pwait
 	.long sys_utimensat
 	.long sys_signalfd
-	.long sys_timerfd		/* 350 */
+	.long sys_ni_syscall		/* 350 */
 	.long sys_eventfd
 	.long sys_fallocate
diff -puN arch/sparc/kernel/systbls.S~timerfd-v3-new-timerfd-api-arch-fixes arch/sparc/kernel/systbls.S
--- a/arch/sparc/kernel/systbls.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/sparc/kernel/systbls.S
@@ -79,7 +79,7 @@ sys_call_table:
 /*295*/	.long sys_fchmodat, sys_faccessat, sys_pselect6, sys_ppoll, sys_unshare
 /*300*/	.long sys_set_robust_list, sys_get_robust_list, sys_migrate_pages, sys_mbind, sys_get_mempolicy
 /*305*/	.long sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
-/*310*/	.long sys_utimensat, sys_signalfd, sys_timerfd, sys_eventfd, sys_fallocate
+/*310*/	.long sys_utimensat, sys_signalfd, sys_ni_syscall, sys_eventfd, sys_fallocate
 
 #ifdef CONFIG_SUNOS_EMUL
 	/* Now the SunOS syscall table. */
diff -puN arch/sparc64/kernel/systbls.S~timerfd-v3-new-timerfd-api-arch-fixes arch/sparc64/kernel/systbls.S
--- a/arch/sparc64/kernel/systbls.S~timerfd-v3-new-timerfd-api-arch-fixes
+++ a/arch/sparc64/kernel/systbls.S
@@ -152,7 +152,7 @@ sys_call_table:
 	.word sys_fchmodat, sys_faccessat, sys_pselect6, sys_ppoll, sys_unshare
 /*300*/	.word sys_set_robust_list, sys_get_robust_list, sys_migrate_pages, sys_mbind, sys_get_mempolicy
 	.word sys_set_mempolicy, sys_kexec_load, sys_move_pages, sys_getcpu, sys_epoll_pwait
-/*310*/	.word sys_utimensat, sys_signalfd, sys_timerfd, sys_eventfd, sys_fallocate
+/*310*/	.word sys_utimensat, sys_signalfd, sys_ni_syscall, sys_eventfd, sys_fallocate
 
 #if defined(CONFIG_SUNOS_EMUL) || defined(CONFIG_SOLARIS_EMUL) || \
     defined(CONFIG_SOLARIS_EMUL_MODULE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ufs-fix-nexstep-dir-block-size-checkpatch-fixes.patch
aoe-properly-initialise-the-request_queues-backing_dev_info.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
git-acpi.patch
git-acpi-ia64-build-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-avr32-fixup.patch
git-cpufreq.patch
git-cpufreq-query_current_values_with_pending_wait-build-fix.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
dm-persistent_read_metadata-warning-fix.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
driver-tree-broke-infiniband.patch
gregkh-driver-driver-core-move-the-driver-specific-module-code-into-the-driver-core-fix.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
git-sh.patch
git-scsi-misc-fixup.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
git-watchdog.patch
git-watchdog-hpwdt-build-fix.patch
add-support-for-sb1-hardware-watchdog-fix.patch
git-wireless.patch
bcm43xx_debugfs-sscanf-fix.patch
git-ipwireless_cs.patch
revert-git-kvm-changes-in-arch-x86-kconfig.patch
git-x86.patch
revert-revert-git-kvm-changes-in-arch-x86-kconfig.patch
git-x86-__vdso_getcpu-warning-fix.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
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
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch
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
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
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
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
cramfs-make-cramfs-little-endian-only-fix.patch
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
timerfd-v3-new-timerfd-api-arch-fixes.patch
