From: akpm@linux-foundation.org
Subject: + k_getrusage-dont-take-rcu_read_lock.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:34 -0800
Message-ID: <200802230736.m1N7aNDM018426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763364AbYBWIEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, roland@redhat.com


The patch titled
     k_getrusage: don't take rcu_read_lock()
has been added to the -mm tree.  Its filename is
     k_getrusage-dont-take-rcu_read_lock.patch

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
Subject: k_getrusage: don't take rcu_read_lock()
From: Oleg Nesterov <oleg@tv-sign.ru>

Just a trivial example, more to come.

k_getrusage() holds rcu_read_lock() because it was previously required by
lock_task_sighand().  Unneeded now.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/sys.c~k_getrusage-dont-take-rcu_read_lock kernel/sys.c
--- a/kernel/sys.c~k_getrusage-dont-take-rcu_read_lock
+++ a/kernel/sys.c
@@ -1566,11 +1566,8 @@ static void k_getrusage(struct task_stru
 		goto out;
 	}
 
-	rcu_read_lock();
-	if (!lock_task_sighand(p, &flags)) {
-		rcu_read_unlock();
+	if (!lock_task_sighand(p, &flags))
 		return;
-	}
 
 	switch (who) {
 		case RUSAGE_BOTH:
@@ -1606,9 +1603,7 @@ static void k_getrusage(struct task_stru
 		default:
 			BUG();
 	}
-
 	unlock_task_sighand(p, &flags);
-	rcu_read_unlock();
 
 out:
 	cputime_to_timeval(utime, &r->ru_utime);
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
