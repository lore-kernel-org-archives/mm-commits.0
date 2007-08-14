From: akpm@linux-foundation.org
Subject: + pid-namespaces-rework-forget_original_parent.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:44 -0700
Message-ID: <200708142004.l7EK4iLt018583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752807AbXHNUFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, menage@google.com, sukadev@us.ibm.com, xemul@openvz.org


The patch titled
     pid namespaces: rework forget_original_parent()
has been added to the -mm tree.  Its filename is
     pid-namespaces-rework-forget_original_parent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: rework forget_original_parent()
From: Oleg Nesterov <oleg@tv-sign.ru>

A pid namespace is a "view" of a particular set of tasks on the system.  They
work in a similar way to filesystem namespaces.  A file (or a process) can be
accessed in multiple namespaces, but it may have a different name in each.  In
a filesystem, this name might be /etc/passwd in one namespace, but
/chroot/etc/passwd in another.

For processes, a process may have pid 1234 in one namespace, but be pid 1 in
another.  This allows new pid namespaces to have basically arbitrary pids, and
not have to worry about what pids exist in other namespaces.  This is
essential for checkpoint/restart where a restarted process's pid might collide
with an existing process on the system's pid.

In this particular implementation, pid namespaces have a parent-child
relationship, just like processes.  A process in a pid namespace may see all
of the processes in the same namespace, as well as all of the processes in all
of the namespaces which are children of its namespace.  Processes may not,
however, see others which are in their parent's namespace, but not in their
own.  The same goes for sibling namespaces.

The know issue to be solved in the nearest future is signal handling in the
namespace boundary.  That is, currently the namespace's init is treated like
an ordinary task that can be killed from within an namespace.  Ideally, the
signal handling by the namespace's init should have two sides: when signaling
the init from its namespace, the init should look like a real init task, i.e. 
receive only those signals, that is explicitly wants to; when signaling the
init from one of the parent namespaces, init should look like an ordinary
task, i.e.  receive any signal, only taking the general permissions into
account.

The pid namespace was developed by Pavel Emlyanov and Sukadev Bhattiprolu and
we eventually came to almost the same implementation, which differed in some
details.  This set is based on Pavel's patches, but it includes comments and
patches that from Sukadev.

Many thanks to Oleg, who reviewed the patches, pointed out many BUGs and made
valuable advises on how to make this set cleaner.



This patch:

We have to call exit_task_namespaces() only after the exiting task has
reparented all his children and is sure that no other threads will reparent
theirs for it.  Why this is needed is explained in appropriate patch.  This
one only reworks the forget_original_parent() so that after calling this a
task cannot be/become parent of any other task.

We check PF_EXITING instead of ->exit_state while choosing the new parent. 
Note that tasklits_lock acts as a barrier, everyone who takes tasklist after
us (when forget_original_parent() drops it) must see PF_EXITING.

The other changes are just cleanups.  They just move some code from
exit_notify to forget_original_parent().  It is a bit silly to declare
ptrace_dead in exit_notify(), take tasklist, pass ptrace_dead to
forget_original_parent(), unlock-lock-unlock tasklist, and then use
ptrace_dead.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   39 +++++++++++++++++++++------------------
 1 files changed, 21 insertions(+), 18 deletions(-)

diff -puN kernel/exit.c~pid-namespaces-rework-forget_original_parent kernel/exit.c
--- a/kernel/exit.c~pid-namespaces-rework-forget_original_parent
+++ a/kernel/exit.c
@@ -672,10 +672,14 @@ reparent_thread(struct task_struct *p, s
  * the child reaper process (ie "init") in our pid
  * space.
  */
-static void
-forget_original_parent(struct task_struct *father, struct list_head *to_release)
+static void forget_original_parent(struct task_struct *father)
 {
 	struct task_struct *p, *n, *reaper = father;
+	struct list_head ptrace_dead;
+
+	INIT_LIST_HEAD(&ptrace_dead);
+
+	write_lock_irq(&tasklist_lock);
 
 	do {
 		reaper = next_thread(reaper);
@@ -683,7 +687,7 @@ forget_original_parent(struct task_struc
 			reaper = task_child_reaper(father);
 			break;
 		}
-	} while (reaper->exit_state);
+	} while (reaper->flags & PF_EXITING);
 
 	/*
 	 * There are only two places where our children can be:
@@ -720,12 +724,23 @@ forget_original_parent(struct task_struc
 		 * while it was being traced by us, to be able to see it in wait4.
 		 */
 		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
-			list_add(&p->ptrace_list, to_release);
+			list_add(&p->ptrace_list, &ptrace_dead);
 	}
+
 	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
 		p->real_parent = reaper;
 		reparent_thread(p, father, 1);
 	}
+
+	write_unlock_irq(&tasklist_lock);
+	BUG_ON(!list_empty(&father->children));
+	BUG_ON(!list_empty(&father->ptrace_children));
+
+	list_for_each_entry_safe(p, n, &ptrace_dead, ptrace_list) {
+		list_del_init(&p->ptrace_list);
+		release_task(p);
+	}
+
 }
 
 /*
@@ -736,7 +751,6 @@ static void exit_notify(struct task_stru
 {
 	int state;
 	struct task_struct *t;
-	struct list_head ptrace_dead, *_p, *_n;
 	struct pid *pgrp;
 
 	if (signal_pending(tsk) && !(tsk->signal->flags & SIGNAL_GROUP_EXIT)
@@ -757,8 +771,6 @@ static void exit_notify(struct task_stru
 		spin_unlock_irq(&tsk->sighand->siglock);
 	}
 
-	write_lock_irq(&tasklist_lock);
-
 	/*
 	 * This does two things:
 	 *
@@ -767,12 +779,9 @@ static void exit_notify(struct task_stru
 	 *	as a result of our exiting, and if they have any stopped
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
 	 */
+	forget_original_parent(tsk);
 
-	INIT_LIST_HEAD(&ptrace_dead);
-	forget_original_parent(tsk, &ptrace_dead);
-	BUG_ON(!list_empty(&tsk->children));
-	BUG_ON(!list_empty(&tsk->ptrace_children));
-
+	write_lock_irq(&tasklist_lock);
 	/*
 	 * Check to see if any process groups have become orphaned
 	 * as a result of our exiting, and if they have any stopped
@@ -832,12 +841,6 @@ static void exit_notify(struct task_stru
 
 	write_unlock_irq(&tasklist_lock);
 
-	list_for_each_safe(_p, _n, &ptrace_dead) {
-		list_del_init(_p);
-		t = list_entry(_p, struct task_struct, ptrace_list);
-		release_task(t);
-	}
-
 	/* If the process is dead, release it - nobody will wait for it */
 	if (state == EXIT_DEAD)
 		release_task(tsk);
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-dvb.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
do_sys_poll-simplify-playing-with-on-stack-data.patch
do_sys_poll-simplify-playing-with-on-stack-data-fix.patch
do_poll-return-eintr-when-signalled.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-remove-unneeded-child-signal-check.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
exit_notify-dont-take-tasklist-for-tif_sigpending-re-targeting.patch
zap_other_threads-dont-optimize-thread_group_empty-case.patch
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
make-access-to-tasks-nsproxy-lighter.patch
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
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
