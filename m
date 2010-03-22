From: akpm@linux-foundation.org
Subject: [merged] posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch removed from -mm tree
Date: Mon, 22 Mar 2010 11:31:16 -0400
Message-ID: <201003221832.o2MIW6uu019972@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644Ab0CVScw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 14:32:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, mingo@elte.hu, oleg@redhat.com, peterz@infradead.org, seto.hidetoshi@jp.fujitsu.com, spencer@bluehost.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     posix-cpu-timers: reset expire cache when no timer is running
has been removed from the -mm tree.  Its filename was
     posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: posix-cpu-timers: reset expire cache when no timer is running
From: Stanislaw Gruszka <sgruszka@redhat.com>

When process delete cpu timer or timer expires we do not clear
expiration cache sig->cputimer_expires. This create situation when in
fastpath_timer_check() we _on_ cputimer (together with loop on all
threads) just to turn in off in check_process_timers(). We not
necessary go to slowpath and not necessary loop on all threads in
fastpath - and this is repeated on every tick.

To fix we zero sig->cputimer_expires in stop_process_timers().

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Spencer Candland <spencer@bluehost.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-cpu-timers-reset-expire-cache-when-no-timer-is-running kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-cpu-timers-reset-expire-cache-when-no-timer-is-running
+++ a/kernel/posix-cpu-timers.c
@@ -1061,9 +1061,9 @@ static void check_thread_timers(struct t
 	}
 }
 
-static void stop_process_timers(struct task_struct *tsk)
+static void stop_process_timers(struct signal_struct *sig)
 {
-	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
 	if (!cputimer->running)
@@ -1072,6 +1072,10 @@ static void stop_process_timers(struct t
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
+
+	sig->cputime_expires.prof_exp = cputime_zero;
+	sig->cputime_expires.virt_exp = cputime_zero;
+	sig->cputime_expires.sched_exp = 0;
 }
 
 static u32 onecputick;
@@ -1133,7 +1137,7 @@ static void check_process_timers(struct 
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
 	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(tsk);
+		stop_process_timers(sig);
 		return;
 	}
 
_

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch

