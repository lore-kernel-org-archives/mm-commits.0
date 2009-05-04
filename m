From: akpm@linux-foundation.org
Subject: + allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch added to -mm tree
Date: Mon, 04 May 2009 16:37:55 -0700
Message-ID: <200905042337.n44NbtmZ019866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328AbZEDXkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 19:40:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     allow_signal: kill the bogus ->mm check, add a note about CLONE_SIGHAND
has been added to the -mm tree.  Its filename is
     allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: allow_signal: kill the bogus ->mm check, add a note about CLONE_SIGHAND
From: Oleg Nesterov <oleg@redhat.com>

allow_signal() checks ->mm == NULL.  Not sure why.  Perhaps to make sure
current is the kernel thread.  But this helper must not be used unless we
are the kernel thread, kill this check.

Also, document the fact that the CLONE_SIGHAND kthread must not use
allow_signal(), unless the caller really wants to change the parent's
->sighand->action as well.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand kernel/exit.c
--- a/kernel/exit.c~allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand
+++ a/kernel/exit.c
@@ -370,9 +370,8 @@ static void set_special_pids(struct pid 
 }
 
 /*
- * Let kernel threads use this to say that they
- * allow a certain signal (since daemonize() will
- * have disabled all of them by default).
+ * Let kernel threads use this to say that they allow a certain signal.
+ * Must not be used if kthread was cloned with CLONE_SIGHAND.
  */
 int allow_signal(int sig)
 {
@@ -380,14 +379,14 @@ int allow_signal(int sig)
 		return -EINVAL;
 
 	spin_lock_irq(&current->sighand->siglock);
+	/* This is only needed for daemonize()'ed kthreads */
 	sigdelset(&current->blocked, sig);
-	if (!current->mm) {
-		/* Kernel threads handle their own signals.
-		   Let the signal code know it'll be handled, so
-		   that they don't get converted to SIGKILL or
-		   just silently dropped */
-		current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
-	}
+	/*
+	 * Kernel threads handle their own signals. Let the signal code
+	 * know it'll be handled, so that they don't get converted to
+	 * SIGKILL or just silently dropped.
+	 */
+	current->sighand->action[(sig)-1].sa.sa_handler = (void __user *)2;
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 	return 0;
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
rcu_sched_grace_period-kill-the-bogus-flush_signals.patch
drivers-staging-epl-do-not-use-clone_sighand-with-allow_signal.patch
slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
allow_signal-kill-the-bogus-mm-check-add-a-note-about-clone_sighand.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment-fix.patch
ptrace-do-not-use-task-ptrace-directly-in-core-kernel.patch
copy_process-remove-the-unneeded-clear_tsk_thread_flagtif_sigpending.patch
elf_core_dump-use-rcu_read_lock-to-access-real_parent.patch
kthreads-simplify-the-startup-synchronization.patch
kthreads-rework-kthread_stop.patch
kthreads-simplify-migration_thread-exit-path.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch
utrace-core-kill-exclude_xtrace-logic.patch

