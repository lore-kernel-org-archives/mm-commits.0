From: akpm@linux-foundation.org
Subject: + lock_task_sighand-add-rcu-lock-unlock.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:32 -0800
Message-ID: <200802230736.m1N7aLTR018423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764915AbYBWIJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:09:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, roland@redhat.com


The patch titled
     lock_task_sighand: add rcu lock/unlock
has been added to the -mm tree.  Its filename is
     lock_task_sighand-add-rcu-lock-unlock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lock_task_sighand: add rcu lock/unlock
From: Oleg Nesterov <oleg@tv-sign.ru>

Most of the callers of lock_task_sighand() doesn't actually need rcu_lock(). 
lock_task_sighand() needs it only to safely play with tsk->sighand, it can
take the lock itself.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN kernel/signal.c~lock_task_sighand-add-rcu-lock-unlock kernel/signal.c
--- a/kernel/signal.c~lock_task_sighand-add-rcu-lock-unlock
+++ a/kernel/signal.c
@@ -971,13 +971,11 @@ int __fatal_signal_pending(struct task_s
 }
 EXPORT_SYMBOL(__fatal_signal_pending);
 
-/*
- * Must be called under rcu_read_lock() or with tasklist_lock read-held.
- */
 struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
 {
 	struct sighand_struct *sighand;
 
+	rcu_read_lock();
 	for (;;) {
 		sighand = rcu_dereference(tsk->sighand);
 		if (unlikely(sighand == NULL))
@@ -988,6 +986,7 @@ struct sighand_struct *lock_task_sighand
 			break;
 		spin_unlock_irqrestore(&sighand->siglock, *flags);
 	}
+	rcu_read_unlock();
 
 	return sighand;
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

kthread-synchronization-issues.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
kthread-call-wake_up_process-without-the-lock-being-held.patch
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
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
timers-simplify-lockdep-stuff.patch
hrtimers-simplify-lockdep-stuff.patch
kill-double_spin_lock.patch
redo-locking-of-tty-pgrp.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
