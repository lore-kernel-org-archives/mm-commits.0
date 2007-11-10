From: akpm@linux-foundation.org
Subject: + suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch added to -mm tree
Date: Fri, 09 Nov 2007 19:28:11 -0800
Message-ID: <200711100328.lAA3SBer015793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35110 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbXKJD2h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 22:28:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, dhowells@redhat.com


The patch titled
     suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: externs should be avoided in .c files
#724: FILE: fs/binfmt_elf.c:514:
+extern unsigned long load_aout_interp(struct exec *interp_ex,

ERROR: "foo * bar" should be "foo *bar"
#875: FILE: include/asm-alpha/a.out-core.h:26:
+	struct switch_stack * sw = ((struct switch_stack *) pt) - 1;

WARNING: line over 80 characters
#997: FILE: include/asm-arm/a.out-core.h:32:
+	dump->u_dsize = (tsk->mm->brk - tsk->mm->start_data + PAGE_SIZE - 1) >> PAGE_SHIFT;

WARNING: no space between function name and open parenthesis '('
#1010: FILE: include/asm-arm/a.out-core.h:45:
+	dump->u_fpvalid = dump_fpu (regs, &dump->u_fp);

WARNING: line over 80 characters
#1262: FILE: include/asm-m68k/a.out-core.h:38:
+		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;

WARNING: no space between function name and open parenthesis '('
#1287: FILE: include/asm-m68k/a.out-core.h:63:
+	dump->u_fpvalid = dump_fpu (regs, &dump->m68kfp);

WARNING: line over 80 characters
#1583: FILE: include/asm-sparc/a.out-core.h:33:
+	memcpy(&dump->regs.regs[0], &regs->u_regs[1], (sizeof(unsigned long) * 15));

WARNING: line over 80 characters
#1592: FILE: include/asm-sparc/a.out-core.h:42:
+	memcpy(&dump->fpu.fpstatus.fregs.regs[0], &current->thread.float_regs[0], (sizeof(unsigned long) * 32));

WARNING: line over 80 characters
#1865: FILE: include/asm-x86/a.out-core.h:33:
+	dump->u_dsize = ((unsigned long) (current->mm->brk + (PAGE_SIZE-1))) >> PAGE_SHIFT;

WARNING: line over 80 characters
#1872: FILE: include/asm-x86/a.out-core.h:40:
+		dump->u_ssize = ((unsigned long) (TASK_SIZE - dump->start_stack)) >> PAGE_SHIFT;

ERROR: need space after that ',' (ctx:VxV)
#1884: FILE: include/asm-x86/a.out-core.h:52:
+	savesegment(gs,dump->regs.gs);
 	              ^

WARNING: no space between function name and open parenthesis '('
#1892: FILE: include/asm-x86/a.out-core.h:60:
+	dump->u_fpvalid = dump_fpu (regs, &dump->i387);

total: 2 errors, 10 warnings, 1565 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/a.out-core.h |    2 +-
 include/asm-arm/a.out-core.h   |    2 +-
 include/asm-m68k/a.out-core.h  |    2 +-
 include/asm-sparc/a.out-core.h |    7 +++++--
 include/asm-x86/a.out-core.h   |    4 ++--
 5 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/asm-alpha/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes include/asm-alpha/a.out-core.h
--- a/include/asm-alpha/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes
+++ a/include/asm-alpha/a.out-core.h
@@ -23,7 +23,7 @@ static inline void
 aout_dump_thread(struct pt_regs *pt, struct user *dump)
 {
 	/* switch stack follows right below pt_regs: */
-	struct switch_stack * sw = ((struct switch_stack *) pt) - 1;
+	struct switch_stack *sw = ((struct switch_stack *)pt) - 1;
 
 	dump->magic = CMAGIC;
 	dump->start_code  = current->mm->start_code;
diff -puN include/asm-arm/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes include/asm-arm/a.out-core.h
--- a/include/asm-arm/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes
+++ a/include/asm-arm/a.out-core.h
@@ -42,7 +42,7 @@ static inline void aout_dump_thread(stru
 		dump->u_ssize = (0x04000000 - dump->start_stack) >> PAGE_SHIFT;
 
 	dump->regs = *regs;
-	dump->u_fpvalid = dump_fpu (regs, &dump->u_fp);
+	dump->u_fpvalid = dump_fpu(regs, &dump->u_fp);
 }
 
 #endif /* __KERNEL__ */
diff -puN include/asm-m68k/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes include/asm-m68k/a.out-core.h
--- a/include/asm-m68k/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes
+++ a/include/asm-m68k/a.out-core.h
@@ -60,7 +60,7 @@ static inline void aout_dump_thread(stru
 	dump->regs.pc = regs->pc;
 	dump->regs.fmtvec = (regs->format << 12) | regs->vector;
 	/* dump floating point stuff */
-	dump->u_fpvalid = dump_fpu (regs, &dump->m68kfp);
+	dump->u_fpvalid = dump_fpu(regs, &dump->m68kfp);
 }
 
 #endif /* __KERNEL__ */
diff -puN include/asm-sparc/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes include/asm-sparc/a.out-core.h
--- a/include/asm-sparc/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes
+++ a/include/asm-sparc/a.out-core.h
@@ -30,7 +30,8 @@ static inline void aout_dump_thread(stru
 	dump->regs.npc = regs->npc;
 	dump->regs.y = regs->y;
 	/* fuck me plenty */
-	memcpy(&dump->regs.regs[0], &regs->u_regs[1], (sizeof(unsigned long) * 15));
+	memcpy(&dump->regs.regs[0], &regs->u_regs[1],
+			(sizeof(unsigned long) * 15));
 	dump->uexec = current->thread.core_exec;
 	dump->u_tsize = (((unsigned long) current->mm->end_code) -
 		((unsigned long) current->mm->start_code)) & ~(PAGE_SIZE - 1);
@@ -39,7 +40,9 @@ static inline void aout_dump_thread(stru
 	dump->u_dsize &= ~(PAGE_SIZE - 1);
 	first_stack_page = (regs->u_regs[UREG_FP] & ~(PAGE_SIZE - 1));
 	dump->u_ssize = (TASK_SIZE - first_stack_page) & ~(PAGE_SIZE - 1);
-	memcpy(&dump->fpu.fpstatus.fregs.regs[0], &current->thread.float_regs[0], (sizeof(unsigned long) * 32));
+	memcpy(&dump->fpu.fpstatus.fregs.regs[0],
+			&current->thread.float_regs[0],
+			sizeof(unsigned long) * 32);
 	dump->fpu.fpstatus.fsr = current->thread.fsr;
 	dump->fpu.fpstatus.flags = dump->fpu.fpstatus.extra = 0;
 	dump->fpu.fpstatus.fpq_count = current->thread.fpqdepth;
diff -puN include/asm-x86/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes include/asm-x86/a.out-core.h
--- a/include/asm-x86/a.out-core.h~suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes
+++ a/include/asm-x86/a.out-core.h
@@ -49,7 +49,7 @@ static inline void aout_dump_thread(stru
 	dump->regs.ds = regs->xds;
 	dump->regs.es = regs->xes;
 	dump->regs.fs = regs->xfs;
-	savesegment(gs,dump->regs.gs);
+	savesegment(gs, dump->regs.gs);
 	dump->regs.orig_eax = regs->orig_eax;
 	dump->regs.eip = regs->eip;
 	dump->regs.cs = regs->xcs;
@@ -57,7 +57,7 @@ static inline void aout_dump_thread(stru
 	dump->regs.esp = regs->esp;
 	dump->regs.ss = regs->xss;
 
-	dump->u_fpvalid = dump_fpu (regs, &dump->i387);
+	dump->u_fpvalid = dump_fpu(regs, &dump->i387);
 }
 
 #endif /* CONFIG_X86_32 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
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
nfs-stop-sillyname-renames-and-unmounts-from-racing-checkpatch-fixes.patch
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
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
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
