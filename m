From: akpm@linux-foundation.org
Subject: - powerpc-ptrace-check_full_regs.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:46 -0700
Message-ID: <200710051956.l95JukgC022390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45648 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932173AbXJET5B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:57:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: ptrace CHECK_FULL_REGS
has been removed from the -mm tree.  Its filename was
     powerpc-ptrace-check_full_regs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: ptrace CHECK_FULL_REGS
From: Roland McGrath <roland@redhat.com>

This restores the CHECK_FULL_REGS sanity check to every place that can access
the nonvolatile GPRs for ptrace.  This is already done for native-bitwidth
PTRACE_PEEKUSR, but was omitted for many other cases (32-bit ptrace,
PTRACE_GETREGS, etc.); I think there may have been more uniform checks before
that were lost in the recent cleanup of GETREGS et al.

Signed-off-by: Roland McGrath <roland@redhat.com>
Fair-enough-to: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ptrace.c   |    4 ++++
 arch/powerpc/kernel/ptrace32.c |    8 ++++++++
 2 files changed, 12 insertions(+)

diff -puN arch/powerpc/kernel/ptrace.c~powerpc-ptrace-check_full_regs arch/powerpc/kernel/ptrace.c
--- a/arch/powerpc/kernel/ptrace.c~powerpc-ptrace-check_full_regs
+++ a/arch/powerpc/kernel/ptrace.c
@@ -331,6 +331,7 @@ static long arch_ptrace_old(struct task_
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned long __user *tmp = (unsigned long __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = put_user(*reg, tmp);
 			if (ret)
@@ -346,6 +347,7 @@ static long arch_ptrace_old(struct task_
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned long __user *tmp = (unsigned long __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = get_user(*reg, tmp);
 			if (ret)
@@ -513,6 +515,7 @@ long arch_ptrace(struct task_struct *chi
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret |= __put_user(ptrace_get_reg(child, ui),
@@ -533,6 +536,7 @@ long arch_ptrace(struct task_struct *chi
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret = __get_user(tmp, (unsigned long __user *) data);
diff -puN arch/powerpc/kernel/ptrace32.c~powerpc-ptrace-check_full_regs arch/powerpc/kernel/ptrace32.c
--- a/arch/powerpc/kernel/ptrace32.c~powerpc-ptrace-check_full_regs
+++ a/arch/powerpc/kernel/ptrace32.c
@@ -53,6 +53,7 @@ static long compat_ptrace_old(struct tas
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned int __user *tmp = (unsigned int __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = put_user(*reg, tmp);
 			if (ret)
@@ -68,6 +69,7 @@ static long compat_ptrace_old(struct tas
 		unsigned long *reg = &((unsigned long *)child->thread.regs)[0];
 		unsigned int __user *tmp = (unsigned int __user *)addr;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		for (i = 0; i < 32; i++) {
 			ret = get_user(*reg, tmp);
 			if (ret)
@@ -164,6 +166,7 @@ long compat_sys_ptrace(int request, int 
 		if ((addr & 3) || (index > PT_FPSCR32))
 			break;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		if (index < PT_FPR0) {
 			tmp = ptrace_get_reg(child, index);
 		} else {
@@ -210,6 +213,7 @@ long compat_sys_ptrace(int request, int 
 		if ((addr & 3) || numReg > PT_FPSCR)
 			break;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		if (numReg >= PT_FPR0) {
 			flush_fp_to_thread(child);
 			tmp = ((unsigned long int *)child->thread.fpr)[numReg - PT_FPR0];
@@ -270,6 +274,7 @@ long compat_sys_ptrace(int request, int 
 		if ((addr & 3) || (index > PT_FPSCR32))
 			break;
 
+		CHECK_FULL_REGS(child->thread.regs);
 		if (index < PT_FPR0) {
 			ret = ptrace_put_reg(child, index, data);
 		} else {
@@ -307,6 +312,7 @@ long compat_sys_ptrace(int request, int 
 		 */
 		if ((addr & 3) || (numReg > PT_FPSCR))
 			break;
+		CHECK_FULL_REGS(child->thread.regs);
 		if (numReg < PT_FPR0) {
 			unsigned long freg = ptrace_get_reg(child, numReg);
 			if (index % 2)
@@ -342,6 +348,7 @@ long compat_sys_ptrace(int request, int 
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret |= __put_user(ptrace_get_reg(child, ui),
@@ -359,6 +366,7 @@ long compat_sys_ptrace(int request, int 
 			ret = -EIO;
 			break;
 		}
+		CHECK_FULL_REGS(child->thread.regs);
 		ret = 0;
 		for (ui = 0; ui < PT_REGS_COUNT; ui ++) {
 			ret = __get_user(tmp, (unsigned int __user *) data);
_

Patches currently in -mm which might be from roland@redhat.com are

git-powerpc.patch
git-kbuild.patch
x86_64-vdso-linker-script-cleanup.patch
x86_64-vdso-put-vars-in-rodata.patch
add-sys-module-name-notes.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
wait_task_zombie-dont-fight-with-non-existing-race-with-a-dying-ptracee.patch
__group_complete_signal-eliminate-unneeded-wakeup-of-group_exit_task.patch
wait_task_stopped-continued-remove-unneeded-p-signal-=-null-check.patch
add-mmf_dump_elf_headers.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
exec-simplify-sighand-switching.patch
exec-simplify-the-new-sighand-allocation.patch
exec-consolidate-2-fast-paths.patch
exec-rt-sub-thread-can-livelock-and-monopolize-cpu-on-exec.patch
do_sigaction-dont-worry-about-signal_pending.patch
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
fix-tsk-exit_state-usage-resend.patch
