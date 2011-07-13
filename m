From: akpm@linux-foundation.org
Subject: + signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch added to -mm tree
Date: Wed, 13 Jul 2011 12:09:49 -0700
Message-ID: <201107131909.p6DJ9nqp029362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50667 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab1GMTKE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Jul 2011 15:10:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, matt.fleming@linux.intel.com, tj@kernel.org


The patch titled
     signals: sys_ssetmask/sys_rt_sigsuspend should use set_current_blocked()
has been added to the -mm tree.  Its filename is
     signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch

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
Subject: signals: sys_ssetmask/sys_rt_sigsuspend should use set_current_blocked()
From: Oleg Nesterov <oleg@redhat.com>

sys_ssetmask(), sys_rt_sigsuspend() and compat_sys_rt_sigsuspend()
change ->blocked directly. This is not correct, see the changelog in
e6fa16ab "signal: sigprocmask() should do retarget_shared_pending()"

Change them to use set_current_blocked().

Another change is that now we are doing ->saved_sigmask = ->blocked
lockless, it doesn't make any sense to do this under ->siglock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/compat.c |    5 +----
 kernel/signal.c |   17 +++++------------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff -puN kernel/compat.c~signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked kernel/compat.c
--- a/kernel/compat.c~signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked
+++ a/kernel/compat.c
@@ -993,11 +993,8 @@ asmlinkage long compat_sys_rt_sigsuspend
 	sigset_from_compat(&newset, &newset32);
 	sigdelsetmask(&newset, sigmask(SIGKILL)|sigmask(SIGSTOP));
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
diff -puN kernel/signal.c~signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked kernel/signal.c
--- a/kernel/signal.c~signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked
+++ a/kernel/signal.c
@@ -3090,15 +3090,11 @@ SYSCALL_DEFINE0(sgetmask)
 
 SYSCALL_DEFINE1(ssetmask, int, newmask)
 {
-	int old;
-
-	spin_lock_irq(&current->sighand->siglock);
-	old = current->blocked.sig[0];
+	int old = current->blocked.sig[0];
+	sigset_t newset;
 
-	siginitset(&current->blocked, newmask & ~(sigmask(SIGKILL)|
-						  sigmask(SIGSTOP)));
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	siginitset(&newset, newmask & ~(sigmask(SIGKILL) | sigmask(SIGSTOP)));
+	set_current_blocked(&newset);
 
 	return old;
 }
@@ -3155,11 +3151,8 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t 
 		return -EFAULT;
 	sigdelsetmask(&newset, sigmask(SIGKILL)|sigmask(SIGSTOP));
 
-	spin_lock_irq(&current->sighand->siglock);
 	current->saved_sigmask = current->blocked;
-	current->blocked = newset;
-	recalc_sigpending();
-	spin_unlock_irq(&current->sighand->siglock);
+	set_current_blocked(&newset);
 
 	current->state = TASK_INTERRUPTIBLE;
 	schedule();
_

Patches currently in -mm which might be from oleg@redhat.com are

xtensa-prevent-arbitrary-read-in-ptrace.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
linux-next.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
signals-convert-the-ia32_emulation-code-to-use-set_current_blocked.patch
signals-convert-the-x86_32-code-to-use-set_current_blocked.patch
signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch
coredump-use-task-comm-instead-of-unknown.patch
do_coredump-fix-the-ispipe-error-check.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

