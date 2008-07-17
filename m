From: akpm@linux-foundation.org
Subject: + tracehook-exec.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:30:33 -0700
Message-ID: <200807170830.m6H8UXN5006949@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753570AbYGQIbg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:31:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: exec
has been added to the -mm tree.  Its filename is
     tracehook-exec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tracehook: exec
From: Roland McGrath <roland@redhat.com>

This moves all the ptrace hooks related to exec into tracehook.h inlines.

This also lifts the calls for tracing out of the binfmt load_binary hooks
into search_binary_handler() after it calls into the binfmt module.  This
change has no effect, since all the binfmt modules' load_binary functions
did the call at the end on success, and now search_binary_handler() does
it immediately after return if successful.  We consolidate the repeated
code, and binfmt modules no longer need to import ptrace_notify().

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32_aout.c |    6 ----
 fs/binfmt_aout.c          |    6 ----
 fs/binfmt_elf.c           |    6 ----
 fs/binfmt_elf_fdpic.c     |    7 -----
 fs/binfmt_flat.c          |    3 --
 fs/binfmt_som.c           |    2 -
 fs/exec.c                 |   12 +++------
 include/linux/tracehook.h |   46 ++++++++++++++++++++++++++++++++++++
 8 files changed, 50 insertions(+), 38 deletions(-)

diff -puN arch/x86/ia32/ia32_aout.c~tracehook-exec arch/x86/ia32/ia32_aout.c
--- a/arch/x86/ia32/ia32_aout.c~tracehook-exec
+++ a/arch/x86/ia32/ia32_aout.c
@@ -441,12 +441,6 @@ beyond_if:
 	regs->r8 = regs->r9 = regs->r10 = regs->r11 =
 	regs->r12 = regs->r13 = regs->r14 = regs->r15 = 0;
 	set_fs(USER_DS);
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
 	return 0;
 }
 
diff -puN fs/binfmt_aout.c~tracehook-exec fs/binfmt_aout.c
--- a/fs/binfmt_aout.c~tracehook-exec
+++ a/fs/binfmt_aout.c
@@ -444,12 +444,6 @@ beyond_if:
 	regs->gp = ex.a_gpvalue;
 #endif
 	start_thread(regs, ex.a_entry, current->mm->start_stack);
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify ((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
 	return 0;
 }
 
diff -puN fs/binfmt_elf.c~tracehook-exec fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~tracehook-exec
+++ a/fs/binfmt_elf.c
@@ -975,12 +975,6 @@ static int load_elf_binary(struct linux_
 #endif
 
 	start_thread(regs, elf_entry, bprm->p);
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify ((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
 	retval = 0;
 out:
 	kfree(loc);
diff -puN fs/binfmt_elf_fdpic.c~tracehook-exec fs/binfmt_elf_fdpic.c
--- a/fs/binfmt_elf_fdpic.c~tracehook-exec
+++ a/fs/binfmt_elf_fdpic.c
@@ -433,13 +433,6 @@ static int load_elf_fdpic_binary(struct 
 	entryaddr = interp_params.entry_addr ?: exec_params.entry_addr;
 	start_thread(regs, entryaddr, current->mm->start_stack);
 
-	if (unlikely(current->ptrace & PT_PTRACED)) {
-		if (current->ptrace & PT_TRACE_EXEC)
-			ptrace_notify((PTRACE_EVENT_EXEC << 8) | SIGTRAP);
-		else
-			send_sig(SIGTRAP, current, 0);
-	}
-
 	retval = 0;
 
 error:
diff -puN fs/binfmt_flat.c~tracehook-exec fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~tracehook-exec
+++ a/fs/binfmt_flat.c
@@ -920,9 +920,6 @@ static int load_flat_binary(struct linux
 	
 	start_thread(regs, start_addr, current->mm->start_stack);
 
-	if (current->ptrace & PT_PTRACED)
-		send_sig(SIGTRAP, current, 0);
-
 	return 0;
 }
 
diff -puN fs/binfmt_som.c~tracehook-exec fs/binfmt_som.c
--- a/fs/binfmt_som.c~tracehook-exec
+++ a/fs/binfmt_som.c
@@ -274,8 +274,6 @@ load_som_binary(struct linux_binprm * bp
 	map_hpux_gateway_page(current,current->mm);
 
 	start_thread_som(regs, som_entry, bprm->p);
-	if (current->ptrace & PT_PTRACED)
-		send_sig(SIGTRAP, current, 0);
 	return 0;
 
 	/* error cleanup */
diff -puN fs/exec.c~tracehook-exec fs/exec.c
--- a/fs/exec.c~tracehook-exec
+++ a/fs/exec.c
@@ -42,13 +42,13 @@
 #include <linux/module.h>
 #include <linux/namei.h>
 #include <linux/proc_fs.h>
-#include <linux/ptrace.h>
 #include <linux/mount.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/tsacct_kern.h>
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
+#include <linux/tracehook.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -1071,13 +1071,8 @@ EXPORT_SYMBOL(prepare_binprm);
 
 static int unsafe_exec(struct task_struct *p)
 {
-	int unsafe = 0;
-	if (p->ptrace & PT_PTRACED) {
-		if (p->ptrace & PT_PTRACE_CAP)
-			unsafe |= LSM_UNSAFE_PTRACE_CAP;
-		else
-			unsafe |= LSM_UNSAFE_PTRACE;
-	}
+	int unsafe = tracehook_unsafe_exec(p);
+
 	if (atomic_read(&p->fs->count) > 1 ||
 	    atomic_read(&p->files->count) > 1 ||
 	    atomic_read(&p->sighand->count) > 1)
@@ -1214,6 +1209,7 @@ int search_binary_handler(struct linux_b
 			read_unlock(&binfmt_lock);
 			retval = fn(bprm, regs);
 			if (retval >= 0) {
+				tracehook_report_exec(fmt, bprm, regs);
 				put_binfmt(fmt);
 				allow_write_access(bprm->file);
 				if (bprm->file)
diff -puN include/linux/tracehook.h~tracehook-exec include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-exec
+++ a/include/linux/tracehook.h
@@ -48,5 +48,51 @@
 
 #include <linux/sched.h>
 #include <linux/ptrace.h>
+#include <linux/security.h>
+struct linux_binprm;
+
+/**
+ * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
+ * @task:		current task doing exec
+ *
+ * Return %LSM_UNSAFE_* bits applied to an exec because of tracing.
+ *
+ * Called with task_lock() held on @task.
+ */
+static inline int tracehook_unsafe_exec(struct task_struct *task)
+{
+	int unsafe = 0;
+	int ptrace = task_ptrace(task);
+	if (ptrace & PT_PTRACED) {
+		if (ptrace & PT_PTRACE_CAP)
+			unsafe |= LSM_UNSAFE_PTRACE_CAP;
+		else
+			unsafe |= LSM_UNSAFE_PTRACE;
+	}
+	return unsafe;
+}
+
+/**
+ * tracehook_report_exec - a successful exec was completed
+ * @fmt:		&struct linux_binfmt that performed the exec
+ * @bprm:		&struct linux_binprm containing exec details
+ * @regs:		user-mode register state
+ *
+ * An exec just completed, we are shortly going to return to user mode.
+ * The freshly initialized register state can be seen and changed in @regs.
+ * The name, file and other pointers in @bprm are still on hand to be
+ * inspected, but will be freed as soon as this returns.
+ *
+ * Called with no locks, but with some kernel resources held live
+ * and a reference on @fmt->module.
+ */
+static inline void tracehook_report_exec(struct linux_binfmt *fmt,
+					 struct linux_binprm *bprm,
+					 struct pt_regs *regs)
+{
+	if (!ptrace_event(PT_TRACE_EXEC, PTRACE_EVENT_EXEC, 0) &&
+	    unlikely(task_ptrace(current) & PT_PTRACED))
+		send_sig(SIGTRAP, current, 0);
+}
 
 #endif	/* <linux/tracehook.h> */
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
execve-filename-document-and-export-via-auxiliary-vector.patch
flag-parameters-paccept-fix.patch
flag-parameters-paccept-fix-flag-parameters-arch-specific-sock_nonblock.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-simplify-ptrace_stop-sigkill_pending-path.patch
ptrace-do_wait-reorganization.patch
ptrace-ptrace-children-revamp.patch
ptrace-do_wait-return-security_task_wait-error-code-in-place-of-echild.patch
ptrace-fix-dangling-zombie-when-new-parent-ignores-children.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
coredump-turn-mm-core_startup_done-into-the-pointer-to-struct-core_state.patch
coredump-move-mm-core_waiters-into-struct-core_state.patch
coredump-simplify-core_state-nr_threads-calculation.patch
coredump-turn-core_state-nr_threads-into-atomic_t.patch
coredump-make-mm-core_state-visible-to-core_dump.patch
coredump-construct-the-list-of-coredumping-threads-at-startup-time.patch
coredump-elf_core_dump-use-core_state-dumper-list.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
coredump-kill-mm-core_done.patch
coredump-binfmt_elf_fdpic-dont-use-sub-threads-mm.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state.patch
coredump-exit_mm-clear-mm-first-then-play-with-core_state-checkpatch-fixes.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch

