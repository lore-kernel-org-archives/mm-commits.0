From: akpm@linux-foundation.org
Subject: - wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:29 -0700
Message-ID: <200710180655.l9I6tTNT030616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59334 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760556AbXJRHg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_zombie: fix 2/3 races vs forget_original_parent()
has been removed from the -mm tree.  Its filename was
     wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 21 insertions(+), 24 deletions(-)

diff -puN kernel/exit.c~wait_task_zombie-fix-2-3-races-vs-forget_original_parent kernel/exit.c
--- a/kernel/exit.c~wait_task_zombie-fix-2-3-races-vs-forget_original_parent
+++ a/kernel/exit.c
@@ -1158,8 +1158,7 @@ static int wait_task_zombie(struct task_
 			    int __user *stat_addr, struct rusage __user *ru)
 {
 	unsigned long state;
-	int retval;
-	int status;
+	int retval, status, traced;
 
 	if (unlikely(noreap)) {
 		pid_t pid = p->pid;
@@ -1201,7 +1200,10 @@ static int wait_task_zombie(struct task_
 		return 0;
 	}
 
-	if (likely(p->real_parent == p->parent)) {
+	/* traced means p->ptrace, but not vice versa */
+	traced = (p->real_parent != p->parent);
+
+	if (likely(!traced)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
 
@@ -1288,35 +1290,30 @@ static int wait_task_zombie(struct task_
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

origin.patch
git-x86.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-merge-fix.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
fix-tsk-exit_state-usage-resend.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
