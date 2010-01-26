From: akpm@linux-foundation.org
Subject: + cpu-timers-optimize-run_posix_cpu_timers.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:39:36 -0800
Message-ID: <201001262139.o0QLdbMP021911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041Ab0AZVkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:40:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, mingo@elte.hu, oleg@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de


The patch titled
     cpu-timers: optimize run_posix_cpu_timers()
has been added to the -mm tree.  Its filename is
     cpu-timers-optimize-run_posix_cpu_timers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu-timers: optimize run_posix_cpu_timers()
From: Stanislaw Gruszka <sgruszka@redhat.com>

We can optimize and simplify things taking into account signal->cputimer
is always running when we have configured any process wide cpu timer.

In check_process_timers(), we don't have to check if new updated value of
signal->cputime_expires is smaller, since we maintain new first expiration
time ({prof,virt,sched}_expires) in code flow and all other writes to
expiration cache are protected by sighand->siglock .

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   80 +++++++++++++-----------------------
 1 file changed, 29 insertions(+), 51 deletions(-)

diff -puN kernel/posix-cpu-timers.c~cpu-timers-optimize-run_posix_cpu_timers kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~cpu-timers-optimize-run_posix_cpu_timers
+++ a/kernel/posix-cpu-timers.c
@@ -1000,16 +1000,9 @@ static void stop_process_timers(struct s
 	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
-	if (!cputimer->running)
-		return;
-
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
-
-	sig->cputime_expires.prof_exp = cputime_zero;
-	sig->cputime_expires.virt_exp = cputime_zero;
-	sig->cputime_expires.sched_exp = 0;
 }
 
 static u32 onecputick;
@@ -1046,6 +1039,23 @@ static void check_cpu_itimer(struct task
 	}
 }
 
+/**
+ * task_cputime_zero - Check a task_cputime struct for all zero fields.
+ *
+ * @cputime:	The struct to compare.
+ *
+ * Checks @cputime to see if all fields are zero.  Returns true if all fields
+ * are zero, false if any field is nonzero.
+ */
+static inline int task_cputime_zero(const struct task_cputime *cputime)
+{
+	if (cputime_eq(cputime->utime, cputime_zero) &&
+	    cputime_eq(cputime->stime, cputime_zero) &&
+	    cputime->sum_exec_runtime == 0)
+		return 1;
+	return 0;
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1062,19 +1072,6 @@ static void check_process_timers(struct 
 	struct task_cputime cputime;
 
 	/*
-	 * Don't sample the current process CPU clocks if there are no timers.
-	 */
-	if (list_empty(&timers[CPUCLOCK_PROF]) &&
-	    cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) &&
-	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
-	    list_empty(&timers[CPUCLOCK_VIRT]) &&
-	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
-	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(sig);
-		return;
-	}
-
-	/*
 	 * Collect the current process totals.
 	 */
 	thread_group_cputimer(tsk, &cputime);
@@ -1161,18 +1158,11 @@ static void check_process_timers(struct 
 		}
 	}
 
-	if (!cputime_eq(prof_expires, cputime_zero) &&
-	    (cputime_eq(sig->cputime_expires.prof_exp, cputime_zero) ||
-	     cputime_gt(sig->cputime_expires.prof_exp, prof_expires)))
-		sig->cputime_expires.prof_exp = prof_expires;
-	if (!cputime_eq(virt_expires, cputime_zero) &&
-	    (cputime_eq(sig->cputime_expires.virt_exp, cputime_zero) ||
-	     cputime_gt(sig->cputime_expires.virt_exp, virt_expires)))
-		sig->cputime_expires.virt_exp = virt_expires;
-	if (sched_expires != 0 &&
-	    (sig->cputime_expires.sched_exp == 0 ||
-	     sig->cputime_expires.sched_exp > sched_expires))
-		sig->cputime_expires.sched_exp = sched_expires;
+	sig->cputime_expires.prof_exp = prof_expires;
+	sig->cputime_expires.virt_exp = virt_expires;
+	sig->cputime_expires.sched_exp = sched_expires;
+	if (task_cputime_zero(&sig->cputime_expires))
+		stop_process_timers(sig);
 }
 
 /*
@@ -1245,23 +1235,6 @@ out:
 }
 
 /**
- * task_cputime_zero - Check a task_cputime struct for all zero fields.
- *
- * @cputime:	The struct to compare.
- *
- * Checks @cputime to see if all fields are zero.  Returns true if all fields
- * are zero, false if any field is nonzero.
- */
-static inline int task_cputime_zero(const struct task_cputime *cputime)
-{
-	if (cputime_eq(cputime->utime, cputime_zero) &&
-	    cputime_eq(cputime->stime, cputime_zero) &&
-	    cputime->sum_exec_runtime == 0)
-		return 1;
-	return 0;
-}
-
-/**
  * task_cputime_expired - Compare two task_cputime entities.
  *
  * @sample:	The task_cputime structure to be checked for expiration.
@@ -1317,7 +1290,7 @@ static inline int fastpath_timer_check(s
 	}
 
 	sig = tsk->signal;
-	if (!task_cputime_zero(&sig->cputime_expires)) {
+	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
 		thread_group_cputimer(tsk, &group_sample);
@@ -1354,7 +1327,12 @@ void run_posix_cpu_timers(struct task_st
 	 * put them on the firing list.
 	 */
 	check_thread_timers(tsk, &firing);
-	check_process_timers(tsk, &firing);
+	/*
+	 * If there are any active process wide timers (POSIX 1.b, itimers,
+	 * RLIMIT_CPU) cputimer must be running.
+	 */
+	if (tsk->signal->cputimer.running)
+		check_process_timers(tsk, &firing);
 
 	/*
 	 * We must release these locks before taking any timer's lock.
_

Patches currently in -mm which might be from sgruszka@redhat.com are

posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch

