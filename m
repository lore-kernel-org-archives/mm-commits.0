From: akpm@linux-foundation.org
Subject: + migrate_timers-add-comment-use-spinlock_irq.patch added to -mm tree
Date: Mon, 30 Jun 2008 16:40:54 -0700
Message-ID: <200806302340.m5UNesax031477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754637AbYF3Xma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 19:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@tv-sign.ru, mingo@elte.hu, srostedt@redhat.com, tglx@linutronix.de


The patch titled
     migrate_timers: add comment, use spinlock_irq()
has been added to the -mm tree.  Its filename is
     migrate_timers-add-comment-use-spinlock_irq.patch

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
@@ -1612,9 +1612,11 @@ static void migrate_hrtimers(int cpu)
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
@@ -1623,8 +1625,7 @@ static void migrate_hrtimers(int cpu)
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
@@ -1435,9 +1435,11 @@ static void __cpuinit migrate_timers(int
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
@@ -1452,8 +1454,7 @@ static void __cpuinit migrate_timers(int
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

get_user_pages-fix-possible-page-leak-on-oom.patch
posix-timers-timer_delete-remove-the-bogus-it_process-=-null-check.patch
posix-timers-release_posix_timer-kill-the-bogus-put_task_struct-it_process.patch
signals-collect_signal-remove-the-unneeded-sigismember-check.patch
signals-collect_signal-simplify-the-still_pending-logic.patch
signals-change-collect_signal-to-return-void.patch
__exit_signal-dont-take-rcu-lock.patch
signals-dequeue_signal-dont-check-signal_group_exit-when-setting-signal_stop_dequeued.patch
signals-do_signal_stop-kill-the-signal_unkillable-check.patch
coredump-zap_threads-comments-use-while_each_thread.patch
signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch
kernel-signalc-change-vars-pid-and-tgid-types-to-pid_t.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
ptrace-give-more-respect-to-sigkill.patch
ptrace-never-sleep-in-task_traced-if-sigkilled.patch
ptrace-kill-may_ptrace_stop.patch
introduce-pf_kthread-flag.patch
kill-pf_borrowed_mm-in-favour-of-pf_kthread.patch
coredump-zap_threads-must-skip-kernel-threads.patch
coredump-elf_core_dump-skip-kernel-threads.patch
pidns-remove-now-unused-kill_proc-function.patch
pidns-remove-now-unused-find_pid-function.patch
pidns-remove-find_task_by_pid-unused-for-a-long-time.patch
distinct-tgid-tid-i-o-statistics.patch
migrate_timers-add-comment-use-spinlock_irq.patch

