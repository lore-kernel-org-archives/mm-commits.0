From: akpm@linux-foundation.org
Subject: + signal-cleanup-sys_rt_sigprocmask.patch added to -mm tree
Date: Wed, 20 Apr 2011 17:23:53 -0700
Message-ID: <201104210023.p3L0Nrjr003900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420Ab1DUAYW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Apr 2011 20:24:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hpa@zytor.com, matt@console-pimps.org, mingo@elte.hu, nyoushchenko@mvista.com, tglx@linutronix.de, tj@kernel.org


The patch titled
     signal: cleanup sys_rt_sigprocmask()
has been added to the -mm tree.  Its filename is
     signal-cleanup-sys_rt_sigprocmask.patch

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
Subject: signal: cleanup sys_rt_sigprocmask()
From: Oleg Nesterov <oleg@redhat.com>

sys_rt_sigprocmask() looks unnecessarily complicated, simplify it.  We can
just read current->blocked lockless unconditionally before anything else
and then copy-to-user it if needed.  At worst we copy 4 words on mips.

We could copy-to-user the old mask first and simplify the code even more,
but the patch tries to keep the current behaviour: we change
current->block even if copy_to_user(oset) fails.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff -puN kernel/signal.c~signal-cleanup-sys_rt_sigprocmask kernel/signal.c
--- a/kernel/signal.c~signal-cleanup-sys_rt_sigprocmask
+++ a/kernel/signal.c
@@ -2355,40 +2355,34 @@ int sigprocmask(int how, sigset_t *set, 
  *  @oset: previous value of signal mask if non-null
  *  @sigsetsize: size of sigset_t type
  */
-SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, set,
+SYSCALL_DEFINE4(rt_sigprocmask, int, how, sigset_t __user *, nset,
 		sigset_t __user *, oset, size_t, sigsetsize)
 {
-	int error = -EINVAL;
 	sigset_t old_set, new_set;
+	int error;
 
-	/* XXX: Don't preclude handling different sized sigset_t's.  */
+	/* Don't preclude handling different sized sigset_t's. */
 	if (sigsetsize != sizeof(sigset_t))
-		goto out;
+		return -EINVAL;
 
-	if (set) {
-		error = -EFAULT;
-		if (copy_from_user(&new_set, set, sizeof(*set)))
-			goto out;
+	old_set = current->blocked;
+
+	if (nset) {
+		if (copy_from_user(&new_set, nset, sizeof(sigset_t)))
+			return -EFAULT;
 		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
 
-		error = sigprocmask(how, &new_set, &old_set);
+		error = sigprocmask(how, &new_set, NULL);
 		if (error)
-			goto out;
-		if (oset)
-			goto set_old;
-	} else if (oset) {
-		spin_lock_irq(&current->sighand->siglock);
-		old_set = current->blocked;
-		spin_unlock_irq(&current->sighand->siglock);
+			return error;
+	}
 
-	set_old:
-		error = -EFAULT;
-		if (copy_to_user(oset, &old_set, sizeof(*oset)))
-			goto out;
+	if (oset) {
+		if (copy_to_user(oset, &old_set, sizeof(sigset_t)))
+			return -EFAULT;
 	}
-	error = 0;
-out:
-	return error;
+
+	return 0;
 }
 
 long do_sigpending(void __user *set, unsigned long sigsetsize)
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
oom-use-pte-pages-in-oom-score.patch
cgroups-read-write-lock-clone_thread-forking-per-threadgroup.patch
cgroups-add-per-thread-subsystem-callbacks.patch
cgroups-make-procs-file-writable.patch
cgroups-use-flex_array-in-attach_proc.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
signal-introduce-retarget_shared_pending.patch
signal-retarget_shared_pending-consider-shared-unblocked-signals-only.patch
signal-retarget_shared_pending-optimize-while_each_thread-loop.patch
signal-sigprocmask-narrow-the-scope-of-siglock.patch
signal-sigprocmask-should-do-retarget_shared_pending.patch
x86-signal-handle_signal-should-use-set_current_blocked.patch
x86-signal-sys_rt_sigreturn-should-use-set_current_blocked.patch
signal-cleanup-sys_rt_sigprocmask.patch
fs-execc-provide-the-correct-process-pid-to-the-pipe-helper.patch

