From: akpm@linux-foundation.org
Subject: - oprofile-revert-i386-make-callgraph-use-dump_trace-on-i386-x86_64.patch removed from -mm tree
Date: Fri, 09 Nov 2007 13:49:14 -0800
Message-ID: <200711092149.lA9LnJVi001067@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37041 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754638AbXKIVuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 16:50:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, jbeulich@novell.com, mingo@elte.hu, phil.el@wanadoo.fr, robfitz@273k.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     oprofile: revert "i386: make callgraph use dump_trace() on i386/x86_64"
has been removed from the -mm tree.  Its filename was
     oprofile-revert-i386-make-callgraph-use-dump_trace-on-i386-x86_64.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: oprofile: revert "i386: make callgraph use dump_trace() on i386/x86_64"
From: Andrew Morton <akpm@linux-foundation.org>

Revert 574a60421c8ea5383a54ebee1f37fa871d00e1b9 - Robert Fitzsimons is
reporting oopses.

Cc: Robert Fitzsimons <robfitz@273k.net>
Cc: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Philippe Elie <phil.el@wanadoo.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/oprofile/backtrace.c |   96 ++++++++++++++++++++------------
 1 file changed, 60 insertions(+), 36 deletions(-)

diff -puN arch/x86/oprofile/backtrace.c~oprofile-revert-i386-make-callgraph-use-dump_trace-on-i386-x86_64 arch/x86/oprofile/backtrace.c
--- a/arch/x86/oprofile/backtrace.c~oprofile-revert-i386-make-callgraph-use-dump_trace-on-i386-x86_64
+++ a/arch/x86/oprofile/backtrace.c
@@ -13,45 +13,24 @@
 #include <linux/mm.h>
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
-#include <asm/stacktrace.h>
 
-static void backtrace_warning_symbol(void *data, char *msg,
-				     unsigned long symbol)
-{
-	/* Ignore warnings */
-}
-
-static void backtrace_warning(void *data, char *msg)
-{
-	/* Ignore warnings */
-}
+struct frame_head {
+	struct frame_head *ebp;
+	unsigned long ret;
+} __attribute__((packed));
 
-static int backtrace_stack(void *data, char *name)
+static struct frame_head *dump_kernel_backtrace(struct frame_head *head)
 {
-	/* Yes, we want all stacks */
-	return 0;
-}
+	oprofile_add_trace(head->ret);
 
-static void backtrace_address(void *data, unsigned long addr)
-{
-	unsigned int *depth = data;
+	/* frame pointers should strictly progress back up the stack
+	 * (towards higher addresses) */
+	if (head >= head->ebp)
+		return NULL;
 
-	if ((*depth)--)
-		oprofile_add_trace(addr);
+	return head->ebp;
 }
 
-static struct stacktrace_ops backtrace_ops = {
-	.warning = backtrace_warning,
-	.warning_symbol = backtrace_warning_symbol,
-	.stack = backtrace_stack,
-	.address = backtrace_address,
-};
-
-struct frame_head {
-	struct frame_head *ebp;
-	unsigned long ret;
-} __attribute__((packed));
-
 static struct frame_head *
 dump_user_backtrace(struct frame_head * head)
 {
@@ -73,16 +52,61 @@ dump_user_backtrace(struct frame_head * 
 	return bufhead[0].ebp;
 }
 
+/*
+ * |             | /\ Higher addresses
+ * |             |
+ * --------------- stack base (address of current_thread_info)
+ * | thread info |
+ * .             .
+ * |    stack    |
+ * --------------- saved regs->ebp value if valid (frame_head address)
+ * .             .
+ * --------------- saved regs->rsp value if x86_64
+ * |             |
+ * --------------- struct pt_regs * stored on stack if 32-bit
+ * |             |
+ * .             .
+ * |             |
+ * --------------- %esp
+ * |             |
+ * |             | \/ Lower addresses
+ *
+ * Thus, regs (or regs->rsp for x86_64) <-> stack base restricts the
+ * valid(ish) ebp values. Note: (1) for x86_64, NMI and several other
+ * exceptions use special stacks, maintained by the interrupt stack table
+ * (IST). These stacks are set up in trap_init() in
+ * arch/x86_64/kernel/traps.c. Thus, for x86_64, regs now does not point
+ * to the kernel stack; instead, it points to some location on the NMI
+ * stack. On the other hand, regs->rsp is the stack pointer saved when the
+ * NMI occurred. (2) For 32-bit, regs->esp is not valid because the
+ * processor does not save %esp on the kernel stack when interrupts occur
+ * in the kernel mode.
+ */
+#ifdef CONFIG_FRAME_POINTER
+static int valid_kernel_stack(struct frame_head *head, struct pt_regs *regs)
+{
+	unsigned long headaddr = (unsigned long)head;
+	unsigned long stack = stack_pointer(regs);
+	unsigned long stack_base = (stack & ~(THREAD_SIZE - 1)) + THREAD_SIZE;
+
+	return headaddr > stack && headaddr < stack_base;
+}
+#else
+/* without fp, it's just junk */
+static int valid_kernel_stack(struct frame_head *head, struct pt_regs *regs)
+{
+	return 0;
+}
+#endif
+
 void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
 	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
-	unsigned long stack = stack_pointer(regs);
 
 	if (!user_mode_vm(regs)) {
-		if (depth)
-			dump_trace(NULL, regs, (unsigned long *)stack,
-				   &backtrace_ops, &depth);
+		while (depth-- && valid_kernel_stack(head, regs))
+			head = dump_kernel_backtrace(head);
 		return;
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
oprofile-revert-i386-make-callgraph-use-dump_trace-on-i386-x86_64.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc-fix.patch
git-dvb.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
git-mtd.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-fixup.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fix-up.patch
git-x86-inlining-borkage.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-arch_register_cpu-section-fix.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
tty-fix-network-driver-interactions-with-tcget-set-checkpatch-fixes.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
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
