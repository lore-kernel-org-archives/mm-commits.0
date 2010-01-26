From: akpm@linux-foundation.org
Subject: + cpu-timers-simplify-rlimit_cpu-handling.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:39:24 -0800
Message-ID: <201001262139.o0QLdPbQ021887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33058 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932142Ab0AZVkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:40:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, mingo@elte.hu, oleg@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de


The patch titled
     cpu-timers: simplify RLIMIT_CPU handling
has been added to the -mm tree.  Its filename is
     cpu-timers-simplify-rlimit_cpu-handling.patch

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
Subject: cpu-timers: simplify RLIMIT_CPU handling
From: Stanislaw Gruszka <sgruszka@redhat.com>

Let always set signal->cputime_expires expiration cache when setting new
itimer, POSIX 1.b timer, and RLIMIT_CPU.  Since we are initializing
prof_exp expiration cache during fork(), this allow to remove "RLIMIT_CPU
!= inf" check from fastpath_timer_check() and do some other cleanups.

Checked against regression using test cases from:
http://marc.info/?l=linux-kernel&m=123749066504641&w=4
http://marc.info/?l=linux-kernel&m=123811277916642&w=2

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   74 ++++++++++++------------------------
 1 file changed, 26 insertions(+), 48 deletions(-)

diff -puN kernel/posix-cpu-timers.c~cpu-timers-simplify-rlimit_cpu-handling kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~cpu-timers-simplify-rlimit_cpu-handling
+++ a/kernel/posix-cpu-timers.c
@@ -11,19 +11,17 @@
 #include <trace/events/timer.h>
 
 /*
- * Called after updating RLIMIT_CPU to set timer expiration if necessary.
+ * Called after updating RLIMIT_CPU to run cpu timer and update
+ * tsk->signal->cputime_expires expiration cache if necessary. Needs siglock
+ * protection since other code may update expiration cache as well.
  */
 void update_rlimit_cpu(struct task_struct *task, unsigned long rlim_new)
 {
 	cputime_t cputime = secs_to_cputime(rlim_new);
-	struct signal_struct *const sig = task->signal;
 
-	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
-	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
-		spin_lock_irq(&task->sighand->siglock);
-		set_process_cpu_timer(task, CPUCLOCK_PROF, &cputime, NULL);
-		spin_unlock_irq(&task->sighand->siglock);
-	}
+	spin_lock_irq(&task->sighand->siglock);
+	set_process_cpu_timer(task, CPUCLOCK_PROF, &cputime, NULL);
+	spin_unlock_irq(&task->sighand->siglock);
 }
 
 static int check_clock(const clockid_t which_clock)
@@ -564,7 +562,6 @@ static void arm_timer(struct k_itimer *t
 	struct list_head *head, *listpos;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
-	unsigned long i;
 
 	head = (CPUCLOCK_PERTHREAD(timer->it_clock) ?
 		p->cpu_timers : p->signal->cpu_timers);
@@ -630,20 +627,11 @@ static void arm_timer(struct k_itimer *t
 			default:
 				BUG();
 			case CPUCLOCK_VIRT:
-				if (expires_le(sig->it[CPUCLOCK_VIRT].expires,
-					       exp->cpu))
-					break;
-				sig->cputime_expires.virt_exp = exp->cpu;
-				break;
+				if (expires_gt(sig->cputime_expires.virt_exp, exp->cpu))
+					sig->cputime_expires.virt_exp = exp->cpu;
 			case CPUCLOCK_PROF:
-				if (expires_le(sig->it[CPUCLOCK_PROF].expires,
-					       exp->cpu))
-					break;
-				i = sig->rlim[RLIMIT_CPU].rlim_cur;
-				if (i != RLIM_INFINITY &&
-				    i <= cputime_to_secs(exp->cpu))
-					break;
-				sig->cputime_expires.prof_exp = exp->cpu;
+				if (expires_gt(sig->cputime_expires.prof_exp, exp->cpu))
+					sig->cputime_expires.prof_exp = exp->cpu;
 				break;
 			case CPUCLOCK_SCHED:
 				sig->cputime_expires.sched_exp = exp->sched;
@@ -1386,7 +1374,7 @@ static inline int fastpath_timer_check(s
 			return 1;
 	}
 
-	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
+	return 0;
 }
 
 /*
@@ -1452,21 +1440,23 @@ void run_posix_cpu_timers(struct task_st
 }
 
 /*
- * Set one of the process-wide special case CPU timers.
+ * Set one of the process-wide special case CPU timers or RLIMIT_CPU.
  * The tsk->sighand->siglock must be held by the caller.
- * The *newval argument is relative and we update it to be absolute, *oldval
- * is absolute and we update it to be relative.
  */
 void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval)
 {
 	union cpu_time_count now;
-	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
+		/*
+		 * We are setting itimer. The *oldval is absolute and we update
+		 * it to be relative, *newval argument is relative and we update
+		 * it to be absolute.
+		 */
 		if (!cputime_eq(*oldval, cputime_zero)) {
 			if (cputime_le(*oldval, now.cpu)) {
 				/* Just about to fire. */
@@ -1479,33 +1469,21 @@ void set_process_cpu_timer(struct task_s
 		if (cputime_eq(*newval, cputime_zero))
 			return;
 		*newval = cputime_add(*newval, now.cpu);
-
-		/*
-		 * If the RLIMIT_CPU timer will expire before the
-		 * ITIMER_PROF timer, we have nothing else to do.
-		 */
-		if (tsk->signal->rlim[RLIMIT_CPU].rlim_cur
-		    < cputime_to_secs(*newval))
-			return;
 	}
 
 	/*
-	 * Check whether there are any process timers already set to fire
-	 * before this one.  If so, we don't have anything more to do.
+	 * Update expiration cache if we are the earliest timer, or eventually
+	 * RLIMIT_CPU limit is earlier than prof_exp cpu timer expire.
 	 */
-	head = &tsk->signal->cpu_timers[clock_idx];
-	if (list_empty(head) ||
-	    cputime_ge(list_first_entry(head,
-				  struct cpu_timer_list, entry)->expires.cpu,
-		       *newval)) {
-		switch (clock_idx) {
-		case CPUCLOCK_PROF:
+	switch (clock_idx) {
+	case CPUCLOCK_PROF:
+		if (expires_gt(tsk->signal->cputime_expires.prof_exp, *newval))
 			tsk->signal->cputime_expires.prof_exp = *newval;
-			break;
-		case CPUCLOCK_VIRT:
+		break;
+	case CPUCLOCK_VIRT:
+		if (expires_gt(tsk->signal->cputime_expires.virt_exp, *newval))
 			tsk->signal->cputime_expires.virt_exp = *newval;
-			break;
-		}
+		break;
 	}
 }
 
_

Patches currently in -mm which might be from sgruszka@redhat.com are

posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch

