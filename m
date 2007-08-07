From: akpm@linux-foundation.org
Subject: + wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch added to -mm tree
Date: Tue, 07 Aug 2007 15:54:38 -0700
Message-ID: <200708072254.l77MsclU009134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761482AbXHGWzw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Aug 2007 18:55:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com


The patch titled
     wait_task_zombie: fix 2/3 races vs forget_original_parent()
has been added to the -mm tree.  Its filename is
     wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: wait_task_zombie: fix 2/3 races vs forget_original_parent()
From: Oleg Nesterov <oleg@tv-sign.ru>

Two threads, T1 and T2.  T2 ptraces P, and P is not a child of ptracer's
thread group.  P exits and goes to TASK_ZOMBIE.

T1 does wait_task_zombie(P):

	P->exit_state = TASK_DEAD;
	...
	read_unlock(&tasklist_lock);

					T2 does exit(), takes tasklist,
					forget_original_parent() does
					__ptrace_unlink(P) but doesn't
					call do_notify_parent(P) because
					p->exit_state == EXIT_DEAD.

Now, P is not visible to our process: __ptrace_unlink() removed it from
->children. We should send notification to P->parent and release P if and
only if SIGCHLD is ignored.

And we have 3 bugs:

1. P->parent does do_wait() and gets -ECHILD (P is on ->parent->children,
   but its state is TASK_DEAD).

2. // wait_task_zombie() continues

	if (put_user(...)) {
		// TODO: is this safe?
		p->exit_state = EXIT_ZOMBIE;
		return;
	}

   we return without notification/release, task_struct leaked.

   Solution: ignore -EFAULT and proceed. It is an application's bug if
   we can't fill infop/stat_addr (in case of VM_FAULT_OOM we have much
   more problems).

3. // wait_task_zombie() continues

	if (p->real_parent != p->parent) {
		// Not taken, it was untraced'ed
		...
	}

	release_task(p);

   we released the task which we shouldn't.

   Solution: check ->real_parent != ->parent before, under tasklist_lock,
   but use ptrace_unlink() instead of __ptrace_unlink() to check ->ptrace.

This patch hopefully solves 2 and 3, the 1st bug will be fixed later, we need
some cleanups in forget_original_parent/reparent_thread.

However, the first race is very unlikely and not critical, so I hope it makes
sense to fix 1 and 2 for now.

4. Small cleanup: don't "restore" EXIT_ZOMBIE unless we know we are not going
   to realease the child.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   45 +++++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 24 deletions(-)

diff -puN kernel/exit.c~wait_task_zombie-fix-2-3-races-vs-forget_original_parent kernel/exit.c
--- a/kernel/exit.c~wait_task_zombie-fix-2-3-races-vs-forget_original_parent
+++ a/kernel/exit.c
@@ -1166,8 +1166,7 @@ static int wait_task_zombie(struct task_
 			    int __user *stat_addr, struct rusage __user *ru)
 {
 	unsigned long state;
-	int retval;
-	int status;
+	int retval, status, traced;
 
 	if (unlikely(noreap)) {
 		pid_t pid = p->pid;
@@ -1209,7 +1208,10 @@ static int wait_task_zombie(struct task_
 		return 0;
 	}
 
-	if (likely(p->real_parent == p->parent)) {
+	/* traced means p->ptrace, but not vice versa */
+	traced = (p->real_parent != p->parent);
+
+	if (likely(!traced)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 
@@ -1291,35 +1293,30 @@ static int wait_task_zombie(struct task_
 		retval = put_user(p->pid, &infop->si_pid);
 	if (!retval && infop)
 		retval = put_user(p->uid, &infop->si_uid);
-	if (retval) {
-		// TODO: is this safe?
-		p->exit_state = EXIT_ZOMBIE;
-		return retval;
-	}
-	retval = p->pid;
-	if (p->real_parent != p->parent) {
+	if (!retval)
+		retval = p->pid;
+
+	if (traced) {
 		write_lock_irq(&tasklist_lock);
-		/* Double-check with lock held.  */
-		if (p->real_parent != p->parent) {
-			__ptrace_unlink(p);
-			// TODO: is this safe?
-			p->exit_state = EXIT_ZOMBIE;
-			/*
-			 * If this is not a detached task, notify the parent.
-			 * If it's still not detached after that, don't release
-			 * it now.
-			 */
+		/* We dropped tasklist, ptracer could die and untrace */
+		ptrace_unlink(p);
+		/*
+		 * If this is not a detached task, notify the parent.
+		 * If it's still not detached after that, don't release
+		 * it now.
+		 */
+		if (p->exit_signal != -1) {
+			do_notify_parent(p, p->exit_signal);
 			if (p->exit_signal != -1) {
-				do_notify_parent(p, p->exit_signal);
-				if (p->exit_signal != -1)
-					p = NULL;
+				p->exit_state = EXIT_ZOMBIE;
+				p = NULL;
 			}
 		}
 		write_unlock_irq(&tasklist_lock);
 	}
 	if (p != NULL)
 		release_task(p);
-	BUG_ON(!retval);
+
 	return retval;
 }
 
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

fix-theoretical-ccids_readwrite_lock-race.patch
i386-remove-unnecessary-code.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-cpuid-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
