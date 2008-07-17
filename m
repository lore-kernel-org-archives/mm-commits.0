From: akpm@linux-foundation.org
Subject: + tracehook-tracehook_expect_breakpoints.patch added to -mm tree
Date: Thu, 17 Jul 2008 01:30:49 -0700
Message-ID: <200807170830.m6H8UnWt006973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34870 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752999AbYGQIhY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jul 2008 04:37:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@redhat.com, oleg@tv-sign.ru


The patch titled
     tracehook: tracehook_expect_breakpoints
has been added to the -mm tree.  Its filename is
     tracehook-tracehook_expect_breakpoints.patch

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
Subject: tracehook: tracehook_expect_breakpoints
From: Roland McGrath <roland@redhat.com>

This adds tracehook_expect_breakpoints() as a formal hook for the nommu
code to use for its, "Is text-poking likely?" check at mmap time.  This
names the actual semantics the code means to test, and documents it.

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tracehook.h |   15 +++++++++++++++
 mm/nommu.c                |    4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff -puN include/linux/tracehook.h~tracehook-tracehook_expect_breakpoints include/linux/tracehook.h
--- a/include/linux/tracehook.h~tracehook-tracehook_expect_breakpoints
+++ a/include/linux/tracehook.h
@@ -52,6 +52,21 @@
 struct linux_binprm;
 
 /**
+ * tracehook_expect_breakpoints - guess if task memory might be touched
+ * @task:		current task, making a new mapping
+ *
+ * Return nonzero if @task is expected to want breakpoint insertion in
+ * its memory at some point.  A zero return is no guarantee it won't
+ * be done, but this is a hint that it's known to be likely.
+ *
+ * May be called with @task->mm->mmap_sem held for writing.
+ */
+static inline int tracehook_expect_breakpoints(struct task_struct *task)
+{
+	return (task_ptrace(task) & PT_PTRACED) != 0;
+}
+
+/**
  * tracehook_unsafe_exec - check for exec declared unsafe due to tracing
  * @task:		current task doing exec
  *
diff -puN mm/nommu.c~tracehook-tracehook_expect_breakpoints mm/nommu.c
--- a/mm/nommu.c~tracehook-tracehook_expect_breakpoints
+++ a/mm/nommu.c
@@ -22,7 +22,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/ptrace.h>
+#include <linux/tracehook.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/mount.h>
@@ -745,7 +745,7 @@ static unsigned long determine_vm_flags(
 	 * it's being traced - otherwise breakpoints set in it may interfere
 	 * with another untraced process
 	 */
-	if ((flags & MAP_PRIVATE) && (current->ptrace & PT_PTRACED))
+	if ((flags & MAP_PRIVATE) && tracehook_expect_breakpoints(current))
 		vm_flags &= ~VM_MAYSHARE;
 
 	return vm_flags;
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

