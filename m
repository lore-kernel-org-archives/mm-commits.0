From: akpm@linux-foundation.org
Subject: - timers-simplify-lockdep-stuff.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:22 -0800
Message-ID: <200802272217.m1RMHMBk000809@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762380AbYB0WSm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, a.p.zijlstra@chello.nl, arjan@linux.intel.com, heiko.carstens@de.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timers: simplify lockdep stuff
has been removed from the -mm tree.  Its filename was
     timers-simplify-lockdep-stuff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timers: simplify lockdep stuff
From: Oleg Nesterov <oleg@tv-sign.ru>

In order to avoid the false positive from lockdep, each per-cpu base->lock has
the separate lock class and migrate_timers() uses double_spin_lock().

This all is overcomplicated: except for migrate_timers() we never take 2 locks
at once, and migrate_timers() can use spin_lock_nested().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN kernel/timer.c~timers-simplify-lockdep-stuff kernel/timer.c
--- a/kernel/timer.c~timers-simplify-lockdep-stuff
+++ a/kernel/timer.c
@@ -1220,13 +1220,6 @@ asmlinkage long sys_sysinfo(struct sysin
 	return 0;
 }
 
-/*
- * lockdep: we want to track each per-CPU base as a separate lock-class,
- * but timer-bases are kmalloc()-ed, so we need to attach separate
- * keys to them:
- */
-static struct lock_class_key base_lock_keys[NR_CPUS];
-
 static int __cpuinit init_timers_cpu(int cpu)
 {
 	int j;
@@ -1269,7 +1262,6 @@ static int __cpuinit init_timers_cpu(int
 	}
 
 	spin_lock_init(&base->lock);
-	lockdep_set_class(&base->lock, base_lock_keys + cpu);
 
 	for (j = 0; j < TVN_SIZE; j++) {
 		INIT_LIST_HEAD(base->tv5.vec + j);
@@ -1308,8 +1300,8 @@ static void __cpuinit migrate_timers(int
 	new_base = get_cpu_var(tvec_bases);
 
 	local_irq_disable();
-	double_spin_lock(&new_base->lock, &old_base->lock,
-			 smp_processor_id() < cpu);
+	spin_lock(&new_base->lock);
+	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	BUG_ON(old_base->running_timer);
 
@@ -1322,8 +1314,8 @@ static void __cpuinit migrate_timers(int
 		migrate_timer_list(new_base, old_base->tv5.vec + i);
 	}
 
-	double_spin_unlock(&new_base->lock, &old_base->lock,
-			   smp_processor_id() < cpu);
+	spin_unlock(&old_base->lock);
+	spin_unlock(&new_base->lock);
 	local_irq_enable();
 	put_cpu_var(tvec_bases);
 }
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

git-hrt.patch
kthread-add-a-missing-memory-barrier-to-kthread_stop.patch
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
workqueues-shrink-cpu_populated_map-when-cpu-dies.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
cleanup_workqueue_thread-remove-the-unneeded-cpu-parameter.patch
simplify-cpu_hotplug_begin-put_online_cpus.patch
redo-locking-of-tty-pgrp.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
free_pidmap-turn-it-into-free_pidmapstruct-upid.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch
