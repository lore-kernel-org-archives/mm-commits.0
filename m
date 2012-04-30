From: akpm@linux-foundation.org
Subject: + keys-kill-the-dummy-key_replace_session_keyring.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:51:04 -0700
Message-ID: <20120430235104.C13FCA04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58012 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070Ab2D3XvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:51:06 -0400
Received: by qabg24 with SMTP id g24so210305qab.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:51:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, agordeev@redhat.com, chris@zankel.net, dhowells@redhat.com, dsmith@redhat.com, fche@redhat.com, geert@linux-m68k.org, lwoodman@redhat.com, mingo@elte.hu, peterz@infradead.org, rkuo@codeaurora.org, tglx@linutronix.de, tj@kernel.org, torvalds@linux-foundation.org


The patch titled
     Subject: keys: kill the dummy key_replace_session_keyring()
has been added to the -mm tree.  Its filename is
     keys-kill-the-dummy-key_replace_session_keyring.patch

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
Subject: keys: kill the dummy key_replace_session_keyring()

After the previouse change key_replace_session_keyring() becomes a nop. 
Remove the dummy definition in key.h and update the callers in
arch/*/kernel/signal.c.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Kuo <rkuo@codeaurora.org>
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

 arch/alpha/kernel/signal.c     |    2 --
 arch/arm/kernel/signal.c       |    2 --
 arch/avr32/kernel/signal.c     |    2 --
 arch/blackfin/kernel/signal.c  |    2 --
 arch/c6x/kernel/signal.c       |    2 --
 arch/cris/kernel/ptrace.c      |    2 --
 arch/frv/kernel/signal.c       |    2 --
 arch/h8300/kernel/signal.c     |    2 --
 arch/hexagon/kernel/signal.c   |    2 --
 arch/ia64/kernel/process.c     |    2 --
 arch/m32r/kernel/signal.c      |    2 --
 arch/mips/kernel/signal.c      |    2 --
 arch/mn10300/kernel/signal.c   |    2 --
 arch/openrisc/kernel/signal.c  |    2 --
 arch/parisc/kernel/signal.c    |    2 --
 arch/powerpc/kernel/signal.c   |    2 --
 arch/s390/kernel/signal.c      |    2 --
 arch/sh/kernel/signal_32.c     |    2 --
 arch/sh/kernel/signal_64.c     |    2 --
 arch/sparc/kernel/signal_32.c  |    2 --
 arch/sparc/kernel/signal_64.c  |    2 --
 arch/tile/kernel/process.c     |    2 --
 arch/unicore32/kernel/signal.c |    2 --
 arch/x86/kernel/signal.c       |    2 --
 include/linux/key.h            |    2 --
 25 files changed, 50 deletions(-)

diff -puN arch/alpha/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/alpha/kernel/signal.c
--- a/arch/alpha/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/alpha/kernel/signal.c
@@ -616,7 +616,5 @@ do_notify_resume(struct pt_regs *regs, s
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/arm/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/arm/kernel/signal.c
--- a/arch/arm/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/arm/kernel/signal.c
@@ -737,7 +737,5 @@ do_notify_resume(struct pt_regs *regs, u
 	if (thread_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/avr32/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/avr32/kernel/signal.c
--- a/arch/avr32/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/avr32/kernel/signal.c
@@ -317,7 +317,5 @@ asmlinkage void do_notify_resume(struct 
 	if (ti->flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/blackfin/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/blackfin/kernel/signal.c
--- a/arch/blackfin/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/blackfin/kernel/signal.c
@@ -338,8 +338,6 @@ asmlinkage void do_notify_resume(struct 
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff -puN arch/c6x/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/c6x/kernel/signal.c
--- a/arch/c6x/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/c6x/kernel/signal.c
@@ -361,7 +361,5 @@ asmlinkage void do_notify_resume(struct 
 	if (thread_info_flags & (1 << TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/cris/kernel/ptrace.c~keys-kill-the-dummy-key_replace_session_keyring arch/cris/kernel/ptrace.c
--- a/arch/cris/kernel/ptrace.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/cris/kernel/ptrace.c
@@ -40,7 +40,5 @@ void do_notify_resume(int canrestart, st
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/frv/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/frv/kernel/signal.c
--- a/arch/frv/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/frv/kernel/signal.c
@@ -571,8 +571,6 @@ asmlinkage void do_notify_resume(__u32 t
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(__frame);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 } /* end do_notify_resume() */
diff -puN arch/h8300/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/h8300/kernel/signal.c
--- a/arch/h8300/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/h8300/kernel/signal.c
@@ -542,7 +542,5 @@ asmlinkage void do_notify_resume(struct 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/hexagon/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/hexagon/kernel/signal.c
--- a/arch/hexagon/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/hexagon/kernel/signal.c
@@ -273,8 +273,6 @@ void do_notify_resume(struct pt_regs *re
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff -puN arch/ia64/kernel/process.c~keys-kill-the-dummy-key_replace_session_keyring arch/ia64/kernel/process.c
--- a/arch/ia64/kernel/process.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/ia64/kernel/process.c
@@ -199,8 +199,6 @@ do_notify_resume_user(sigset_t *unused, 
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(&scr->pt);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 	/* copy user rbs to kernel rbs */
diff -puN arch/m32r/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/m32r/kernel/signal.c
--- a/arch/m32r/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/m32r/kernel/signal.c
@@ -383,8 +383,6 @@ void do_notify_resume(struct pt_regs *re
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 
 	clear_thread_flag(TIF_IRET);
diff -puN arch/mips/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/mips/kernel/signal.c
--- a/arch/mips/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/mips/kernel/signal.c
@@ -652,8 +652,6 @@ asmlinkage void do_notify_resume(struct 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff -puN arch/mn10300/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/mn10300/kernel/signal.c
--- a/arch/mn10300/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/mn10300/kernel/signal.c
@@ -563,7 +563,5 @@ asmlinkage void do_notify_resume(struct 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(current_frame());
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/openrisc/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/openrisc/kernel/signal.c
--- a/arch/openrisc/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/openrisc/kernel/signal.c
@@ -376,7 +376,5 @@ asmlinkage void do_notify_resume(struct 
 	if (current_thread_info()->flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/parisc/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/parisc/kernel/signal.c
--- a/arch/parisc/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/parisc/kernel/signal.c
@@ -639,7 +639,5 @@ void do_notify_resume(struct pt_regs *re
 	if (test_thread_flag(TIF_NOTIFY_RESUME)) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/powerpc/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/powerpc/kernel/signal.c
--- a/arch/powerpc/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/powerpc/kernel/signal.c
@@ -193,8 +193,6 @@ void do_notify_resume(struct pt_regs *re
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff -puN arch/s390/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/s390/kernel/signal.c
--- a/arch/s390/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/s390/kernel/signal.c
@@ -517,6 +517,4 @@ void do_notify_resume(struct pt_regs *re
 {
 	clear_thread_flag(TIF_NOTIFY_RESUME);
 	tracehook_notify_resume(regs);
-	if (current->replacement_session_keyring)
-		key_replace_session_keyring();
 }
diff -puN arch/sh/kernel/signal_32.c~keys-kill-the-dummy-key_replace_session_keyring arch/sh/kernel/signal_32.c
--- a/arch/sh/kernel/signal_32.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/sh/kernel/signal_32.c
@@ -633,7 +633,5 @@ asmlinkage void do_notify_resume(struct 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/sh/kernel/signal_64.c~keys-kill-the-dummy-key_replace_session_keyring arch/sh/kernel/signal_64.c
--- a/arch/sh/kernel/signal_64.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/sh/kernel/signal_64.c
@@ -737,7 +737,5 @@ asmlinkage void do_notify_resume(struct 
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
diff -puN arch/sparc/kernel/signal_32.c~keys-kill-the-dummy-key_replace_session_keyring arch/sparc/kernel/signal_32.c
--- a/arch/sparc/kernel/signal_32.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/sparc/kernel/signal_32.c
@@ -603,8 +603,6 @@ void do_notify_resume(struct pt_regs *re
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff -puN arch/sparc/kernel/signal_64.c~keys-kill-the-dummy-key_replace_session_keyring arch/sparc/kernel/signal_64.c
--- a/arch/sparc/kernel/signal_64.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/sparc/kernel/signal_64.c
@@ -618,8 +618,6 @@ void do_notify_resume(struct pt_regs *re
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff -puN arch/tile/kernel/process.c~keys-kill-the-dummy-key_replace_session_keyring arch/tile/kernel/process.c
--- a/arch/tile/kernel/process.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/tile/kernel/process.c
@@ -580,8 +580,6 @@ int do_work_pending(struct pt_regs *regs
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 		return 1;
 	}
 	if (thread_info_flags & _TIF_SINGLESTEP) {
diff -puN arch/unicore32/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/unicore32/kernel/signal.c
--- a/arch/unicore32/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/unicore32/kernel/signal.c
@@ -467,8 +467,6 @@ asmlinkage void do_notify_resume(struct 
 	if (thread_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 }
 
diff -puN arch/x86/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring arch/x86/kernel/signal.c
--- a/arch/x86/kernel/signal.c~keys-kill-the-dummy-key_replace_session_keyring
+++ a/arch/x86/kernel/signal.c
@@ -837,8 +837,6 @@ do_notify_resume(struct pt_regs *regs, v
 	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
 		clear_thread_flag(TIF_NOTIFY_RESUME);
 		tracehook_notify_resume(regs);
-		if (current->replacement_session_keyring)
-			key_replace_session_keyring();
 	}
 	if (thread_info_flags & _TIF_USER_RETURN_NOTIFY)
 		fire_user_return_notifiers();
diff -puN include/linux/key.h~keys-kill-the-dummy-key_replace_session_keyring include/linux/key.h
--- a/include/linux/key.h~keys-kill-the-dummy-key_replace_session_keyring
+++ a/include/linux/key.h
@@ -33,8 +33,6 @@ typedef uint32_t key_perm_t;
 
 struct key;
 
-#define key_replace_session_keyring()	do { } while (0)
-
 #ifdef CONFIG_KEYS
 
 #undef KEY_DEBUGGING
_
Subject: Subject: keys: kill the dummy key_replace_session_keyring()

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

