From: akpm@linux-foundation.org
Subject: - migrate_timers-add-comment-use-spinlock_irq.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:44:55 -0700
Message-ID: <200808261844.m7QIitKS021352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757544AbYHZSqN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, mingo@elte.hu, srostedt@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     migrate_timers: add comment, use spinlock_irq()
has been removed from the -mm tree.  Its filename was
     migrate_timers-add-comment-use-spinlock_irq.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: migrate_timers: add comment, use spinlock_irq()
From: Oleg Nesterov <oleg@tv-sign.ru>

Add the comment to explain why the double lock in migrate_timers()
can't deadlock.

Change the code to use spinlock_irq() instead of local_irq_disable()
+ spin_lock().

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Steven Rostedt <srostedt@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |   11 ++++++-----
 kernel/timer.c   |   11 ++++++-----
 2 files changed, 12 insertions(+), 10 deletions(-)

diff -puN kernel/hrtimer.c~migrate_timers-add-comment-use-spinlock_irq kernel/hrtimer.c
--- a/kernel/hrtimer.c~migrate_timers-add-comment-use-spinlock_irq
+++ a/kernel/hrtimer.c
@@ -1620,9 +1620,11 @@ static void migrate_hrtimers(int cpu)
 	new_base = &get_cpu_var(hrtimer_bases);
 
 	tick_cancel_sched_timer(cpu);
-
-	local_irq_disable();
-	spin_lock(&new_base->lock);
+	/*
+	 * The caller is globally serialized and nobody else
+	 * takes two locks at once, deadlock is not possible.
+	 */
+	spin_lock_irq(&new_base->lock);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
@@ -1631,8 +1633,7 @@ static void migrate_hrtimers(int cpu)
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
-	local_irq_enable();
+	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(hrtimer_bases);
 }
 #endif /* CONFIG_HOTPLUG_CPU */
diff -puN kernel/timer.c~migrate_timers-add-comment-use-spinlock_irq kernel/timer.c
--- a/kernel/timer.c~migrate_timers-add-comment-use-spinlock_irq
+++ a/kernel/timer.c
@@ -1436,9 +1436,11 @@ static void __cpuinit migrate_timers(int
 	BUG_ON(cpu_online(cpu));
 	old_base = per_cpu(tvec_bases, cpu);
 	new_base = get_cpu_var(tvec_bases);
-
-	local_irq_disable();
-	spin_lock(&new_base->lock);
+	/*
+	 * The caller is globally serialized and nobody else
+	 * takes two locks at once, deadlock is not possible.
+	 */
+	spin_lock_irq(&new_base->lock);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
 	BUG_ON(old_base->running_timer);
@@ -1453,8 +1455,7 @@ static void __cpuinit migrate_timers(int
 	}
 
 	spin_unlock(&old_base->lock);
-	spin_unlock(&new_base->lock);
-	local_irq_enable();
+	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(tvec_bases);
 }
 #endif /* CONFIG_HOTPLUG_CPU */
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

linux-next.patch
posix-timers-dont-switch-to-group_leader-if-it_process-dies.patch
posix-timers-always-do-get_task_structtimer-it_process.patch
posix-timers-sys_timer_create-remove-the-buggy-pf_exiting-check.patch
posix-timers-sys_timer_create-simplify-and-s-tasklist-rcu.patch
posix-timers-move-the-initialization-of-timer-sigq-from-send-to-create-path.patch
posix-timers-sys_timer_create-cleanup-the-error-handling.patch
posix-timers-kill-it_sigev_signo-and-it_sigev_value.patch
posix-timers-lock_timer-kill-the-bogus-it_id-check.patch
posix-timers-lock_timer-make-it-readable.patch
posix-timers-use-struct-pid-instead-of-struct-task_struct.patch
posix-timers-check-it_signal-instead-of-it_pid-to-validate-the-timer.patch
posix-timers-simplify-de_thread-exit_itimers-path.patch
make-ptrace_untrace-static.patch
coredump-format_corename-dont-append-%pid-if-multi-threaded.patch
kthread_bind-use-wait_task_inactivetask_uninterruptible.patch

