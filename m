From: akpm@linux-foundation.org
Subject: + signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch added to -mm tree
Date: Wed, 15 Aug 2007 14:40:40 -0700
Message-ID: <200708152140.l7FLeeCR016413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41827 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbXHOVmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 17:42:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, benh@kernel.crashing.org, davidel@xmailserver.org, mingo@elte.hu, mtk-manpages@gmx.net, roland@redhat.com, stable@kernel.org, tglx@linutronix.de


The patch titled
     signalfd: make it group-wide, fix posix-timers scheduling
has been added to the -mm tree.  Its filename is
     signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: signalfd: make it group-wide, fix posix-timers scheduling
From: Oleg Nesterov <oleg@tv-sign.ru>

With this patch any thread can dequeue its own private signals via signalfd,
even if it was created by another sub-thread.

To do so, we pass "current" to dequeue_signal() if the caller is from the same
thread group. This also fixes the scheduling of posix timers broken by the
previous patch.

If the caller doesn't belong to this thread group, we can't handle __SI_TIMER
case properly anyway. Perhaps we should forbid the cross-process signalfd usage
and convert ctx->tsk to ctx->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c     |    9 ++-------
 fs/signalfd.c |   14 ++++++++++----
 2 files changed, 12 insertions(+), 11 deletions(-)

diff -puN fs/exec.c~signalfd-make-it-group-wide-fix-posix-timers-scheduling fs/exec.c
--- a/fs/exec.c~signalfd-make-it-group-wide-fix-posix-timers-scheduling
+++ a/fs/exec.c
@@ -780,18 +780,12 @@ static int de_thread(struct task_struct 
 	int count;
 
 	/*
-	 * Tell all the sighand listeners that this sighand has
-	 * been detached. The signalfd_detach() function grabs the
-	 * sighand lock, if signal listeners are present on the sighand.
-	 */
-	signalfd_detach(tsk);
-
-	/*
 	 * If we don't share sighandlers, then we aren't sharing anything
 	 * and we can just re-use it all.
 	 */
 	if (atomic_read(&oldsighand->count) <= 1) {
 		BUG_ON(atomic_read(&sig->count) != 1);
+		signalfd_detach(tsk);
 		exit_itimers(sig);
 		return 0;
 	}
@@ -930,6 +924,7 @@ static int de_thread(struct task_struct 
 	sig->flags = 0;
 
 no_thread_group:
+	signalfd_detach(tsk);
 	exit_itimers(sig);
 	if (leader)
 		release_task(leader);
diff -puN fs/signalfd.c~signalfd-make-it-group-wide-fix-posix-timers-scheduling fs/signalfd.c
--- a/fs/signalfd.c~signalfd-make-it-group-wide-fix-posix-timers-scheduling
+++ a/fs/signalfd.c
@@ -56,12 +56,18 @@ static int signalfd_lock(struct signalfd
 		sighand = lock_task_sighand(lk->tsk, &lk->flags);
 	rcu_read_unlock();
 
-	if (sighand && !ctx->tsk) {
+	if (!sighand)
+		return 0;
+
+	if (!ctx->tsk) {
 		unlock_task_sighand(lk->tsk, &lk->flags);
-		sighand = NULL;
+		return 0;
 	}
 
-	return sighand != NULL;
+	if (lk->tsk->tgid == current->tgid)
+		lk->tsk = current;
+
+	return 1;
 }
 
 static void signalfd_unlock(struct signalfd_lockctx *lk)
@@ -331,7 +337,7 @@ asmlinkage long sys_signalfd(int ufd, si
 
 		init_waitqueue_head(&ctx->wqh);
 		ctx->sigmask = sigmask;
-		ctx->tsk = current;
+		ctx->tsk = current->group_leader;
 
 		sighand = current->sighand;
 		/*
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
posix-timers-fix-creation-race.patch
signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
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
