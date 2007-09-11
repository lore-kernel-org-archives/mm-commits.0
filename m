From: akpm@linux-foundation.org
Subject: - fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach.patch removed from -mm tree
Date: Tue, 11 Sep 2007 13:21:03 -0700
Message-ID: <200709112021.l8BKL3Up027761@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54486 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601AbXIKUWL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Sep 2007 16:22:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, ak@suse.de, jan.kratochvil@redhat.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     Fix spurious syscall tracing after PTRACE_DETACH + PTRACE_ATTACH
has been removed from the -mm tree.  Its filename was
     fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix spurious syscall tracing after PTRACE_DETACH + PTRACE_ATTACH
From: Roland McGrath <roland@redhat.com>

There is a test case in https://bugzilla.redhat.com/show_bug.cgi?id=276861
to demonstrate this bug.

When PTRACE_SYSCALL was used and then PTRACE_DETACH is used, the
TIF_SYSCALL_TRACE flag is left set on the formerly-traced task.  This means
that when a new tracer comes along and does PTRACE_ATTACH, it's possible he
gets a syscall tracing stop even though he's never used PTRACE_SYSCALL. 
This happens if the task was in the middle of a system call when the second
PTRACE_ATTACH was done.  The symptom is an unexpected SIGTRAP when the
tracer thinks that only SIGSTOP should have been provoked by his ptrace
calls so far.

A few machines already fixed this in ptrace_disable (i386, ia64, m68k). 
But all other machines do not, and still have this bug.  On x86_64, this
constitutes a regression in IA32 compatibility support.

Since all machines now use TIF_SYSCALL_TRACE for this, I put the clearing
of TIF_SYSCALL_TRACE in the generic ptrace_detach code rather than adding
it to every other machine's ptrace_disable.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: <jan.kratochvil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/ptrace.c |    1 -
 arch/ia64/kernel/ptrace.c |    1 -
 arch/m68k/kernel/ptrace.c |    1 -
 kernel/ptrace.c           |    1 +
 4 files changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/i386/kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach arch/i386/kernel/ptrace.c
--- a/arch/i386/kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach
+++ a/arch/i386/kernel/ptrace.c
@@ -274,7 +274,6 @@ static void clear_singlestep(struct task
 void ptrace_disable(struct task_struct *child)
 { 
 	clear_singlestep(child);
-	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_EMU);
 }
 
diff -puN arch/ia64/kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach arch/ia64/kernel/ptrace.c
--- a/arch/ia64/kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach
+++ a/arch/ia64/kernel/ptrace.c
@@ -1577,7 +1577,6 @@ sys_ptrace (long request, pid_t pid, uns
 
 	      case PTRACE_DETACH:
 		/* detach a process that was attached. */
-		clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 		ret = ptrace_detach(child, data);
 		goto out_tsk;
 
diff -puN arch/m68k/kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach arch/m68k/kernel/ptrace.c
--- a/arch/m68k/kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach
+++ a/arch/m68k/kernel/ptrace.c
@@ -116,7 +116,6 @@ static inline void singlestep_disable(st
 void ptrace_disable(struct task_struct *child)
 {
 	singlestep_disable(child);
-	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 }
 
 long arch_ptrace(struct task_struct *child, long request, long addr, long data)
diff -puN kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach kernel/ptrace.c
--- a/kernel/ptrace.c~fix-spurious-syscall-tracing-after-ptrace_detach-ptrace_attach
+++ a/kernel/ptrace.c
@@ -233,6 +233,7 @@ int ptrace_detach(struct task_struct *ch
 
 	/* Architecture-specific hardware disable .. */
 	ptrace_disable(child);
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
 
 	write_lock_irq(&tasklist_lock);
 	/* protect against de_thread()->release_task() */
_

Patches currently in -mm which might be from roland@redhat.com are

powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
pass-g-to-assembler-under-config_debug_info.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
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
fix-tsk-exit_state-usage-resend.patch
