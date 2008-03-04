From: akpm@linux-foundation.org
Subject: - exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:33 -0800
Message-ID: <200803042010.m24KAXYF026920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757561AbYCDULp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:11:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     pgrp: exit_notify: fix kill_orphaned_pgrp() usage with mt exit
has been removed from the -mm tree.  Its filename was
     exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pgrp: exit_notify: fix kill_orphaned_pgrp() usage with mt exit
From: Oleg Nesterov <oleg@tv-sign.ru>

1. exit_notify() always calls kill_orphaned_pgrp(). This is wrong, we
   should do this only when the whole process exits.

2. exit_notify() uses "current" as "ignored_task", obviously wrong.
   Use ->group_leader instead.

Test case:

	void hup(int sig)
	{
		printf("HUP received\n");
	}

	void *tfunc(void *arg)
	{
		sleep(2);
		printf("sub-thread exited\n");
		return NULL;
	}

	int main(int argc, char *argv[])
	{
		if (!fork()) {
			signal(SIGHUP, hup);
			kill(getpid(), SIGSTOP);
			exit(0);
		}

		pthread_t thr;
		pthread_create(&thr, NULL, tfunc, NULL);

		sleep(1);
		printf("main thread exited\n");
		syscall(__NR_exit, 0);

		return 0;
	}

output:

	main thread exited
	HUP received
	Hangup

With this patch the output is:

	main thread exited
	sub-thread exited
	HUP received

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/exit.c~exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit kernel/exit.c
--- a/kernel/exit.c~exit_notify-fix-kill_orphaned_pgrp-usage-with-mt-exit
+++ a/kernel/exit.c
@@ -750,7 +750,7 @@ static void forget_original_parent(struc
  * Send signals to all our closest relatives so that they know
  * to properly mourn us..
  */
-static void exit_notify(struct task_struct *tsk)
+static void exit_notify(struct task_struct *tsk, int group_dead)
 {
 	int state;
 
@@ -766,7 +766,8 @@ static void exit_notify(struct task_stru
 	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
-	kill_orphaned_pgrp(tsk, NULL);
+	if (group_dead)
+		kill_orphaned_pgrp(tsk->group_leader, NULL);
 
 	/* Let father know we died
 	 *
@@ -981,7 +982,7 @@ NORET_TYPE void do_exit(long code)
 		module_put(tsk->binfmt->module);
 
 	proc_exit_connector(tsk);
-	exit_notify(tsk);
+	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
 	tsk->mempolicy = NULL;
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-hrt.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
documentation-atomic_add_unless-doesnt-imply-mb-on-failure-fix.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
remove-unused-variable-from-send_signal.patch
turn-legacy_queue-macro-into-static-inline-function.patch
consolidate-checking-for-ignored-legacy-signals.patch
consolidate-checking-for-ignored-legacy-signals-simplify.patch
signals-do_signal_stop-use-signal_group_exit.patch
signals-do_group_exit-use-signal_group_exit-more-consistently.patch
lock_task_sighand-add-rcu-lock-unlock.patch
k_getrusage-dont-take-rcu_read_lock.patch
do_task_stat-dont-take-rcu_read_lock.patch
signals-consolidate-checks-for-whether-or-not-to-ignore-a-signal.patch
signals-clean-dequeue_signal-from-excess-checks-and-assignments.patch
signals-consolidate-send_sigqueue-and-send_group_sigqueue.patch
signals-cleanup-security_task_kill-usage-implementation.patch
ptrace-introduce-task_detached-helper.patch
ptrace-introduce-ptrace_reparented-helper.patch
reparent_thread-use-same_thread_group.patch
document-de_thread-with-exit_notify-connection.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
resume-tty-on-susp-and-fix-crnl-order-in-n_tty-line-discipline.patch
tty_io-fix-remaining-pid-struct-locking.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

