From: akpm@linux-foundation.org
Subject: - handle-the-multi-threaded-inits-exit-properly.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:55:11 -0700
Message-ID: <200710180655.l9I6tBfM030588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59535 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761582AbXJRHrh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, clg@fr.ibm.com, ebiederm@xmission.com, mingo@elte.hu, roland@redhat.com, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     handle the multi-threaded init's exit() properly
has been removed from the -mm tree.  Its filename was
     handle-the-multi-threaded-inits-exit-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: handle the multi-threaded init's exit() properly
From: Oleg Nesterov <oleg@tv-sign.ru>

With or without this patch, multi-threaded init's are not fully supported,
but do_exit() is completely wrong.  This becomes a real problem when we
support pid namespaces.

1. do_exit() panics when the main thread of /sbin/init exits. It should not
   until the whole thread group exits. Move the code below, under the
   "if (group_dead)" check.

   Note: this means that forget_original_parent() can use an already dead
   child_reaper()'s task_struct. This is OK for /sbin/init because

   	- do_wait() from alive sub-thread still can reap a zombie, we iterate
   	  over all sub-thread's ->children lists

   	- do_notify_parent() will wakeup some alive sub-thread because it sends
   	  the group-wide signal

   However, we should remove choose_new_parent()->BUG_ON(reaper->exit_state)
   for this.

2. We are playing games with ->nsproxy->pid_ns. This code is bogus today, and
   it has to be changed anyway when we really support pid namespaces, just
   remove it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff -puN kernel/exit.c~handle-the-multi-threaded-inits-exit-properly kernel/exit.c
--- a/kernel/exit.c~handle-the-multi-threaded-inits-exit-properly
+++ a/kernel/exit.c
@@ -592,17 +592,6 @@ static void exit_mm(struct task_struct *
 	mmput(mm);
 }
 
-static inline void
-choose_new_parent(struct task_struct *p, struct task_struct *reaper)
-{
-	/*
-	 * Make sure we're not reparenting to ourselves and that
-	 * the parent is not a zombie.
-	 */
-	BUG_ON(p == reaper || reaper->exit_state);
-	p->real_parent = reaper;
-}
-
 static void
 reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 {
@@ -710,7 +699,7 @@ forget_original_parent(struct task_struc
 
 		if (father == p->real_parent) {
 			/* reparent with a reaper, real father it's us */
-			choose_new_parent(p, reaper);
+			p->real_parent = reaper;
 			reparent_thread(p, father, 0);
 		} else {
 			/* reparent ptraced task to its real parent */
@@ -731,7 +720,7 @@ forget_original_parent(struct task_struc
 	}
 	list_for_each_safe(_p, _n, &father->ptrace_children) {
 		p = list_entry(_p, struct task_struct, ptrace_list);
-		choose_new_parent(p, reaper);
+		p->real_parent = reaper;
 		reparent_thread(p, father, 1);
 	}
 }
@@ -882,6 +871,14 @@ static void check_stack_usage(void)
 static inline void check_stack_usage(void) {}
 #endif
 
+static inline void exit_child_reaper(struct task_struct *tsk)
+{
+	if (likely(tsk->group_leader != child_reaper(tsk)))
+		return;
+
+	panic("Attempted to kill init!");
+}
+
 fastcall NORET_TYPE void do_exit(long code)
 {
 	struct task_struct *tsk = current;
@@ -895,13 +892,6 @@ fastcall NORET_TYPE void do_exit(long co
 		panic("Aiee, killing interrupt handler!");
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
-	if (unlikely(tsk == child_reaper(tsk))) {
-		if (tsk->nsproxy->pid_ns != &init_pid_ns)
-			tsk->nsproxy->pid_ns->child_reaper = init_pid_ns.child_reaper;
-		else
-			panic("Attempted to kill init!");
-	}
-
 
 	if (unlikely(current->ptrace & PT_TRACE_EXIT)) {
 		current->ptrace_message = code;
@@ -951,6 +941,7 @@ fastcall NORET_TYPE void do_exit(long co
 	}
 	group_dead = atomic_dec_and_test(&tsk->signal->live);
 	if (group_dead) {
+		exit_child_reaper(tsk);
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
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
