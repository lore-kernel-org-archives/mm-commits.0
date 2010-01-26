From: akpm@linux-foundation.org
Subject: + cpu-timers-cleanup-arm_timer.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:39:27 -0800
Message-ID: <201001262139.o0QLdRnA021894@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753753Ab0AZVkT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:40:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, mingo@elte.hu, oleg@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de


The patch titled
     cpu-timers: cleanup arm_timer()
has been added to the -mm tree.  Its filename is
     cpu-timers-cleanup-arm_timer.patch

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
Subject: cpu-timers: cleanup arm_timer()
From: Stanislaw Gruszka <sgruszka@redhat.com>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |  104 ++++++++++++------------------------
 1 file changed, 35 insertions(+), 69 deletions(-)

diff -puN kernel/posix-cpu-timers.c~cpu-timers-cleanup-arm_timer kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~cpu-timers-cleanup-arm_timer
+++ a/kernel/posix-cpu-timers.c
@@ -546,97 +546,63 @@ static inline int expires_gt(cputime_t e
 	       cputime_gt(expires, new_exp);
 }
 
-static inline int expires_le(cputime_t expires, cputime_t new_exp)
-{
-	return !cputime_eq(expires, cputime_zero) &&
-	       cputime_le(expires, new_exp);
-}
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
  * for reading, and interrupts disabled.
  */
-static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
+static void arm_timer(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	struct list_head *head, *listpos;
+	struct task_cputime *cputime_expires;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
 
-	head = (CPUCLOCK_PERTHREAD(timer->it_clock) ?
-		p->cpu_timers : p->signal->cpu_timers);
+	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+		head = p->cpu_timers;
+		cputime_expires = &p->cputime_expires;
+	} else {
+		head = p->signal->cpu_timers;
+		cputime_expires = &p->signal->cputime_expires;
+	}
 	head += CPUCLOCK_WHICH(timer->it_clock);
 
 	BUG_ON(!irqs_disabled());
 	spin_lock(&p->sighand->siglock);
 
 	listpos = head;
-	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
-		list_for_each_entry(next, head, entry) {
-			if (next->expires.sched > nt->expires.sched)
-				break;
-			listpos = &next->entry;
-		}
-	} else {
-		list_for_each_entry(next, head, entry) {
-			if (cputime_gt(next->expires.cpu, nt->expires.cpu))
-				break;
-			listpos = &next->entry;
-		}
+	list_for_each_entry(next, head, entry) {
+		if (cpu_time_before(timer->it_clock, nt->expires, next->expires))
+			break;
+		listpos = &next->entry;
 	}
 	list_add(&nt->entry, listpos);
 
 	if (listpos == head) {
+		union cpu_time_count *exp = &nt->expires;
+
 		/*
-		 * We are the new earliest-expiring timer.
-		 * If we are a thread timer, there can always
-		 * be a process timer telling us to stop earlier.
+		 * We are the new earliest-expiring POSIX 1.b timer, hence
+		 * need to update expiration cache. Take into account that
+		 * for process timers we share expiration cache with itimers
+		 * and RLIMIT_CPU and for thread timers with RLIMIT_RTTIME.
 		 */
 
-		if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-			union cpu_time_count *exp = &nt->expires;
-
-			switch (CPUCLOCK_WHICH(timer->it_clock)) {
-			default:
-				BUG();
-			case CPUCLOCK_PROF:
-				if (expires_gt(p->cputime_expires.prof_exp,
-					       exp->cpu))
-					p->cputime_expires.prof_exp = exp->cpu;
-				break;
-			case CPUCLOCK_VIRT:
-				if (expires_gt(p->cputime_expires.virt_exp,
-					       exp->cpu))
-					p->cputime_expires.virt_exp = exp->cpu;
-				break;
-			case CPUCLOCK_SCHED:
-				if (p->cputime_expires.sched_exp == 0 ||
-				    p->cputime_expires.sched_exp > exp->sched)
-					p->cputime_expires.sched_exp =
-								exp->sched;
-				break;
-			}
-		} else {
-			struct signal_struct *const sig = p->signal;
-			union cpu_time_count *exp = &timer->it.cpu.expires;
-
-			/*
-			 * For a process timer, set the cached expiration time.
-			 */
-			switch (CPUCLOCK_WHICH(timer->it_clock)) {
-			default:
-				BUG();
-			case CPUCLOCK_VIRT:
-				if (expires_gt(sig->cputime_expires.virt_exp, exp->cpu))
-					sig->cputime_expires.virt_exp = exp->cpu;
-			case CPUCLOCK_PROF:
-				if (expires_gt(sig->cputime_expires.prof_exp, exp->cpu))
-					sig->cputime_expires.prof_exp = exp->cpu;
-				break;
-			case CPUCLOCK_SCHED:
-				sig->cputime_expires.sched_exp = exp->sched;
-				break;
-			}
+		switch (CPUCLOCK_WHICH(timer->it_clock)) {
+		case CPUCLOCK_PROF:
+			if (expires_gt(cputime_expires->prof_exp, exp->cpu))
+				cputime_expires->prof_exp = exp->cpu;
+			break;
+		case CPUCLOCK_VIRT:
+			if (expires_gt(cputime_expires->virt_exp, exp->cpu))
+				cputime_expires->virt_exp = exp->cpu;
+			break;
+		case CPUCLOCK_SCHED:
+			if (cputime_expires->sched_exp == 0 ||
+			    cputime_expires->sched_exp > exp->sched)
+				cputime_expires->sched_exp = exp->sched;
+			break;
 		}
 	}
 
@@ -818,7 +784,7 @@ int posix_cpu_timer_set(struct k_itimer 
 	if (new_expires.sched != 0 &&
 	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    cpu_time_before(timer->it_clock, val, new_expires)) {
-		arm_timer(timer, val);
+		arm_timer(timer);
 	}
 
 	read_unlock(&tasklist_lock);
@@ -1282,7 +1248,7 @@ void posix_cpu_timer_schedule(struct k_i
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
-	arm_timer(timer, now);
+	arm_timer(timer);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from sgruszka@redhat.com are

posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch

