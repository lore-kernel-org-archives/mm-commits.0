From: akpm@linux-foundation.org
Subject: + hexagon-do_notify_resume-needs-tracehook_notify_resume.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:50:56 -0700
Message-ID: <20120430235057.125B8A04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:41978 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757374Ab2D3Xu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2012 19:50:59 -0400
Received: by laai8 with SMTP id i8so171580laa.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:50:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, agordeev@redhat.com, chris@zankel.net, dhowells@redhat.com, dsmith@redhat.com, fche@redhat.com, geert@linux-m68k.org, lwoodman@redhat.com, mingo@elte.hu, peterz@infradead.org, rkuo@codeaurora.org, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org


The patch titled
     Subject: hexagon: do_notify_resume() needs tracehook_notify_resume()
has been added to the -mm tree.  Its filename is
     hexagon-do_notify_resume-needs-tracehook_notify_resume.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: hexagon: do_notify_resume() needs tracehook_notify_resume()

arch/hexagon/kernel/signal.c:do_notify_resume() forgets to call
tracehook_notify_resume() if TIF_NOTIFY_RESUME is set.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Richard Kuo <rkuo@codeaurora.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: David Smith <dsmith@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/kernel/signal.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/hexagon/kernel/signal.c~hexagon-do_notify_resume-needs-tracehook_notify_resume arch/hexagon/kernel/signal.c
--- a/arch/hexagon/kernel/signal.c~hexagon-do_notify_resume-needs-tracehook_notify_resume
+++ a/arch/hexagon/kernel/signal.c
@@ -272,6 +272,7 @@ void do_notify_resume(struct pt_regs *re
 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
+		tracehook_notify_resume(regs);
 		if (current->replacement_session_keyring)
 			key_replace_session_keyring();
 	}
_
Subject: Subject: hexagon: do_notify_resume() needs tracehook_notify_resume()

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
avr32-dont-mask-signals-in-the-error-path.patch
avr32-use-set_current_blocked-in-handle_signal-sys_rt_sigreturn.patch
avr32-use-block_sigmask.patch
m32r-use-set_current_blocked-and-block_sigmask.patch
m68k-use-set_current_blocked-and-block_sigmask.patch
mn10300-use-set_current_blocked-and-block_sigmask.patch
cris-use-set_current_blocked-and-block_sigmask.patch
ia64-use-set_current_blocked-and-block_sigmask.patch
microblaze-dont-reimplement-force_sigsegv.patch
microblaze-no-need-to-reset-handler-if-sa_oneshot.patch
microblaze-fix-signal-masking.patch
microblaze-use-set_current_blocked-and-block_sigmask.patch
score-dont-mask-signals-if-we-fail-to-setup-signal-stack.patch
score-use-set_current_blocked-and-block_sigmask.patch
h8300-use-set_current_blocked-and-block_sigmask.patch
unicore32-use-block_sigmask.patch
blackfin-use-set_current_blocked-and-block_sigmask.patch
mm-fork-fix-overflow-in-vma-length-when-copying-mmap-on-clone.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
frv-use-set_current_blocked-and-block_sigmask.patch
parisc-use-set_current_blocked-and-block_sigmask.patch
task_work_add-generic-process-context-callbacks.patch
genirq-reimplement-exit_irq_thread-hook-via-task_work_add.patch
hexagon-do_notify_resume-needs-tracehook_notify_resume.patch
keys-change-keyctl_session_to_parent-to-use-task_work_add.patch
keys-kill-the-dummy-key_replace_session_keyring.patch
keys-kill-task_struct-replacement_session_keyring.patch
kmod-unexport-call_usermodehelper_freeinfo.patch
kmod-convert-two-call-sites-to-call_usermodehelper_fns.patch
kmod-move-call_usermodehelper_fns-to-c-file-and-unexport-all-its-helpers.patch
cred-remove-task_is_dead-from-__task_cred-validation.patch
stack-usage-add-pid-to-warning-printk-in-check_stack_usage.patch
proc-clean-up-proc-pid-environ-handling.patch
proc-unify-ptrace_may_access-locking-code.patch
proc-remove-mm_for_maps.patch
proc-use-mm_access-instead-of-ptrace_may_access.patch
proc-use-is_err_or_null.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
cpu-introduce-clear_tasks_mm_cpumask-helper.patch
arm-use-clear_tasks_mm_cpumask.patch
powerpc-use-clear_tasks_mm_cpumask.patch
sh-use-clear_tasks_mm_cpumask.patch
blackfin-a-couple-of-task-mm-handling-fixes.patch
blackfin-fix-possible-deadlock-in-decode_address.patch
um-should-hold-tasklist_lock-while-traversing-processes.patch
um-fix-possible-race-on-task-mm.patch
um-properly-check-all-process-threads-for-a-live-mm.patch
aio-vfs-cleanup-of-rw_copy_check_uvector-and-compat_rw_copy_check_uvector.patch
sysctl-make-kernelns_last_pid-control-being-checkpoint_restore-dependent.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9-fix.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-prctl-drop-vma-flags-test-on-pr_set_mm_-stack-data-assignment.patch

