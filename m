From: akpm@linux-foundation.org
Subject: - exec-simplify-the-new-sighand-allocation.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:45 -0700
Message-ID: <200710180656.l9I6ujSp030726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756885AbXJRH0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     exec: simplify the new ->sighand allocation
has been removed from the -mm tree.  Its filename was
     exec-simplify-the-new-sighand-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: exec: simplify the new ->sighand allocation
From: Oleg Nesterov <oleg@tv-sign.ru>

de_thread() pre-allocates newsighand to make sure that exec() can't fail after
killing all sub-threads. Imho, this buys nothing, but complicates the code:

	- this is (mostly) needed to handle CLONE_SIGHAND without CLONE_THREAD
	  tasks, this is very unlikely (if ever used) case

	- unless we already have some serious problems, GFP_KERNEL allocation
	  should not fail

	- ENOMEM still can happen after de_thread(), ->sighand is not the last
	  object we have to allocate

Change the code to allocate the new ->sighand on demand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff -puN fs/exec.c~exec-simplify-the-new-sighand-allocation fs/exec.c
--- a/fs/exec.c~exec-simplify-the-new-sighand-allocation
+++ a/fs/exec.c
@@ -747,7 +747,7 @@ static int exec_mmap(struct mm_struct *m
 static int de_thread(struct task_struct *tsk)
 {
 	struct signal_struct *sig = tsk->signal;
-	struct sighand_struct *newsighand, *oldsighand = tsk->sighand;
+	struct sighand_struct *oldsighand = tsk->sighand;
 	spinlock_t *lock = &oldsighand->siglock;
 	struct task_struct *leader = NULL;
 	int count;
@@ -761,10 +761,6 @@ static int de_thread(struct task_struct 
 		return 0;
 	}
 
-	newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
-	if (!newsighand)
-		return -ENOMEM;
-
 	if (thread_group_empty(tsk))
 		goto no_thread_group;
 
@@ -781,7 +777,6 @@ static int de_thread(struct task_struct 
 		 */
 		spin_unlock_irq(lock);
 		read_unlock(&tasklist_lock);
-		kmem_cache_free(sighand_cachep, newsighand);
 		return -EAGAIN;
 	}
 
@@ -899,17 +894,16 @@ no_thread_group:
 	if (leader)
 		release_task(leader);
 
-	if (atomic_read(&oldsighand->count) == 1) {
-		/*
-		 * Now that we nuked the rest of the thread group,
-		 * it turns out we are not sharing sighand any more either.
-		 * So we can just keep it.
-		 */
-		kmem_cache_free(sighand_cachep, newsighand);
-	} else {
+	if (atomic_read(&oldsighand->count) != 1) {
+		struct sighand_struct *newsighand;
 		/*
-		 * Move our state over to newsighand and switch it in.
+		 * This ->sighand is shared with the CLONE_SIGHAND
+		 * but not CLONE_THREAD task, switch to the new one.
 		 */
+		newsighand = kmem_cache_alloc(sighand_cachep, GFP_KERNEL);
+		if (!newsighand)
+			return -ENOMEM;
+
 		atomic_set(&newsighand->count, 1);
 		memcpy(newsighand->action, oldsighand->action,
 		       sizeof(newsighand->action));
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
