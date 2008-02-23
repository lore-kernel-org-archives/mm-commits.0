From: akpm@linux-foundation.org
Subject: + do_task_stat-dont-take-rcu_read_lock.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:36 -0800
Message-ID: <200802230736.m1N7aPLx018429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:43593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933488AbYBWIQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, paulmck@linux.vnet.ibm.com, roland@redhat.com, xemul@sw.ru


The patch titled
     do_task_stat: don't take rcu_read_lock()
has been added to the -mm tree.  Its filename is
     do_task_stat-dont-take-rcu_read_lock.patch

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
Subject: do_task_stat: don't take rcu_read_lock()
From: Oleg Nesterov <oleg@tv-sign.ru>

lock_task_sighand() was changed, and do_task_stat() doesn't need
rcu_read_lock any longer.  sighand->siglock protects all "interesting"
fields.

Except: it doesn't protect ->tty->pgrp, but neither does rcu_read_lock(), this
should be fixed.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Emelyanov <xemul@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/array.c~do_task_stat-dont-take-rcu_read_lock fs/proc/array.c
--- a/fs/proc/array.c~do_task_stat-dont-take-rcu_read_lock
+++ a/fs/proc/array.c
@@ -425,7 +425,6 @@ static int do_task_stat(struct seq_file 
 	cutime = cstime = utime = stime = cputime_zero;
 	cgtime = gtime = cputime_zero;
 
-	rcu_read_lock();
 	if (lock_task_sighand(task, &flags)) {
 		struct signal_struct *sig = task->signal;
 
@@ -469,7 +468,6 @@ static int do_task_stat(struct seq_file 
 
 		unlock_task_sighand(task, &flags);
 	}
-	rcu_read_unlock();
 
 	if (!whole || num_threads < 2)
 		wchan = get_wchan(task);
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
