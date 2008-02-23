From: akpm@linux-foundation.org
Subject: + put_pid-make-sure-we-dont-free-the-live-pid.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:38:10 -0800
Message-ID: <200802230738.m1N7cxPe018691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754255AbYBWHkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:40:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, alan@lxorguk.ukuu.org.uk, ebiederm@xmission.com, kamalesh@linux.vnet.ibm.com, roland@redhat.com, xemul@openvz.org


The patch titled
     put_pid: make sure we don't free the live pid
has been added to the -mm tree.  Its filename is
     put_pid-make-sure-we-dont-free-the-live-pid.patch

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
Subject: put_pid: make sure we don't free the live pid
From: Oleg Nesterov <oleg@tv-sign.ru>

Add the temporary (for -mm only) debugging code to catch the unbalanced
put_pid()'s.  At least those which can free the "live" pid.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Valdis.Kletnieks@vt.edu
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN kernel/pid.c~put_pid-make-sure-we-dont-free-the-live-pid kernel/pid.c
--- a/kernel/pid.c~put_pid-make-sure-we-dont-free-the-live-pid
+++ a/kernel/pid.c
@@ -210,6 +210,10 @@ void put_pid(struct pid *pid)
 	ns = pid->numbers[pid->level].ns;
 	if ((atomic_read(&pid->count) == 1) ||
 	     atomic_dec_and_test(&pid->count)) {
+		int type = PIDTYPE_MAX;
+		while (--type >= 0)
+			if (WARN_ON(!hlist_empty(&pid->tasks[type])))
+				return;
 		kmem_cache_free(ns->pid_cachep, pid);
 		put_pid_ns(ns);
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
