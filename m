From: akpm@linux-foundation.org
Subject: - powerpc-full_regs-on-exec.patch removed from -mm tree
Date: Wed, 26 Sep 2007 18:43:01 -0700
Message-ID: <200709270143.l8R1h1X9013917@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbXI0BnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Sep 2007 21:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: FULL_REGS on exec
has been removed from the -mm tree.  Its filename was
     powerpc-full_regs-on-exec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: powerpc: FULL_REGS on exec
From: Roland McGrath <roland@redhat.com>

When PTRACE_O_TRACEEXEC is used, a ptrace call to fetch the registers at the
PTRACE_EVENT_EXEC stop (PTRACE_PEEKUSR) will oops in CHECK_FULL_REGS.  With
recent versions, "gdb --args /bin/sh -c 'exec /bin/true'" and "run" at the
(gdb) prompt is sufficient to produce this.  I also have written an isolated
test case, see https://bugzilla.redhat.com/show_bug.cgi?id=301791#c15.

This change fixes the problem by clearing the low bit of pt_regs.trap in
start_thread so that FULL_REGS is true again.  This is correct since all of
the GPRs that "full" refers to are cleared in start_thread.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/powerpc/kernel/process.c~powerpc-full_regs-on-exec arch/powerpc/kernel/process.c
--- a/arch/powerpc/kernel/process.c~powerpc-full_regs-on-exec
+++ a/arch/powerpc/kernel/process.c
@@ -605,6 +605,13 @@ void start_thread(struct pt_regs *regs, 
 	regs->ccr = 0;
 	regs->gpr[1] = sp;
 
+	/*
+	 * We have just cleared all the nonvolatile GPRs, so make
+	 * FULL_REGS(regs) return true.  This is necessary to allow
+	 * ptrace to examine the thread immediately after exec.
+	 */
+	regs->trap &= ~1UL;
+
 #ifdef CONFIG_PPC32
 	regs->mq = 0;
 	regs->nip = start;
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
powerpc-ptrace-check_full_regs.patch
x86_64-vdso-linker-script-cleanup.patch
x86_64-vdso-put-vars-in-rodata.patch
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
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
fix-tsk-exit_state-usage-resend.patch
