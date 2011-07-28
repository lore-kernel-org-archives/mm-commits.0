From: akpm@linux-foundation.org
Subject: [merged] signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch removed from -mm tree
Date: Thu, 28 Jul 2011 13:01:22 -0700
Message-ID: <201107281959.p6SJxvRm005318@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754833Ab1G1UAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jul 2011 16:00:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, matt.fleming@linux.intel.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     signals: sys_ssetmask/sys_rt_sigsuspend should use set_current_blocked()
has been removed from the -mm tree.  Its filename was
     signals-sys_ssetmask-sys_rt_sigsuspend-should-use-set_current_blocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -992,11 +992,8 @@ asmlinkage long compat_sys_rt_sigsuspend
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
@@ -3102,15 +3102,11 @@ SYSCALL_DEFINE0(sgetmask)
 
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
@@ -3167,11 +3163,8 @@ SYSCALL_DEFINE2(rt_sigsuspend, sigset_t 
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

origin.patch
linux-next.patch
proc_fork_connector-a-lockless-real_parent-usage-is-not-safe.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch

