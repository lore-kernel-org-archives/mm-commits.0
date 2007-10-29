From: akpm@linux-foundation.org
Subject: - git-perfmon-fill-in-i386-syscall-table.patch removed from -mm tree
Date: Mon, 29 Oct 2007 13:24:58 -0700
Message-ID: <200710292024.l9TKOwZE021583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56388 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbXJ2UZY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 16:25:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eranian@hpl.hp.com, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     git-perfmon: fill in i386 syscall table
has been removed from the -mm tree.  Its filename was
     git-perfmon-fill-in-i386-syscall-table.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-perfmon: fill in i386 syscall table
From: Andrew Morton <akpm@linux-foundation.org>

They're defined in include/asm-x86/unistd_32.h so they shold occupy table
slots in arch/x86/kernel/syscall_table_32.S.

Because I'm about to renumber the revoke() sycalls..

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stephane Eranian <eranian@hpl.hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/syscall_table_32.S |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN arch/x86/kernel/syscall_table_32.S~git-perfmon-fill-in-i386-syscall-table arch/x86/kernel/syscall_table_32.S
--- a/arch/x86/kernel/syscall_table_32.S~git-perfmon-fill-in-i386-syscall-table
+++ a/arch/x86/kernel/syscall_table_32.S
@@ -324,3 +324,16 @@ ENTRY(sys_call_table)
 	.long sys_timerfd
 	.long sys_eventfd
 	.long sys_fallocate
+	.long sys_ni_syscall		/* pfm_create_context */ /* 325 */
+	.long sys_ni_syscall		/* pfm_write_pmcs */
+	.long sys_ni_syscall		/* pfm_write_pmds */
+	.long sys_ni_syscall		/* pfm_read_pmds */
+	.long sys_ni_syscall		/* pfm_load_context */
+	.long sys_ni_syscall		/* pfm_start */		/* 330 */
+	.long sys_ni_syscall		/* pfm_stop */
+	.long sys_ni_syscall		/* pfm_restart */
+	.long sys_ni_syscall		/* pfm_create_evtsets */
+	.long sys_ni_syscall		/* pfm_getinfo_evtsets */
+	.long sys_ni_syscall		/* pfm_delete_evtsets */ /* 335 */
+	.long sys_ni_syscall		/* pfm_unload_context */
+
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sunrpc-fix-rpc-debugging-checkpatch-fixes.patch
revert-ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
acpi-add-reboot-mechanism.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
revert-gregkh-driver-block-device.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
fix-appletouch-geyser-1-breakage-checkpatch-fixes.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
libata-pata_it821x-improve-handling-of-poorly-compatible-emulations-checkpatch-fixes.patch
ide-arm-hack.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fixes.patch
nf_ct_alloc_hashtable-use-__gfp_nowarn.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc-vs-git-libata-all.patch
git-scsi-rc-fixes.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
git-unionfs.patch
git-watchdog.patch
watchdog-add-nano-7240-driver-checkpatch-fixes.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
git-perfmon-fill-in-i386-syscall-table.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
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
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
