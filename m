From: akpm@linux-foundation.org
Subject: [to-be-updated] itimers-merge-itimer_virt-and-itimer_prof-common-code.patch removed from -mm tree
Date: Thu, 28 May 2009 00:21:36 -0700
Message-ID: <200905280721.n4S7LaOX009090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751083AbZE1HWJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 May 2009 03:22:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, a.p.zijlstra@chello.nl, johnstul@us.ibm.com, mingo@elte.hu, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     itimers: merge ITIMER_VIRT and ITIMER_PROF common code
has been removed from the -mm tree.  Its filename was
     itimers-merge-itimer_virt-and-itimer_prof-common-code.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: itimers: merge ITIMER_VIRT and ITIMER_PROF common code
From: Stanislaw Gruszka <sgruszka@redhat.com>

Both cpu itimers have same data flow in the few places, this patch make
unification of code related with VIRT and PROF itimers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h     |    8 +
 kernel/fork.c             |    8 -
 kernel/itimer.c           |  151 +++++++++++++++++-------------------
 kernel/posix-cpu-timers.c |   86 ++++++++++----------
 4 files changed, 125 insertions(+), 128 deletions(-)

diff -puN include/linux/sched.h~itimers-merge-itimer_virt-and-itimer_prof-common-code include/linux/sched.h
--- a/include/linux/sched.h~itimers-merge-itimer_virt-and-itimer_prof-common-code
+++ a/include/linux/sched.h
@@ -455,6 +455,11 @@ struct pacct_struct {
 	unsigned long		ac_minflt, ac_majflt;
 };
 
+struct cpu_itimer {
+	cputime_t expires;
+	cputime_t incr;
+};
+
 /**
  * struct task_cputime - collected CPU time counts
  * @utime:		time spent in user mode, in &cputime_t units
@@ -541,8 +546,7 @@ struct signal_struct {
 	ktime_t it_real_incr;
 
 	/* ITIMER_PROF and ITIMER_VIRTUAL timers for the process */
-	cputime_t it_prof_expires, it_virt_expires;
-	cputime_t it_prof_incr, it_virt_incr;
+	struct cpu_itimer it[2];
 
 	/*
 	 * Thread group totals for process CPU timers.
diff -puN kernel/fork.c~itimers-merge-itimer_virt-and-itimer_prof-common-code kernel/fork.c
--- a/kernel/fork.c~itimers-merge-itimer_virt-and-itimer_prof-common-code
+++ a/kernel/fork.c
@@ -789,10 +789,10 @@ static void posix_cpu_timers_init_group(
 	thread_group_cputime_init(sig);
 
 	/* Expiration times and increments. */
-	sig->it_virt_expires = cputime_zero;
-	sig->it_virt_incr = cputime_zero;
-	sig->it_prof_expires = cputime_zero;
-	sig->it_prof_incr = cputime_zero;
+	sig->it[0].expires = cputime_zero;
+	sig->it[0].incr = cputime_zero;
+	sig->it[1].expires = cputime_zero;
+	sig->it[1].incr = cputime_zero;
 
 	/* Cached expiration times. */
 	sig->cputime_expires.prof_exp = cputime_zero;
diff -puN kernel/itimer.c~itimers-merge-itimer_virt-and-itimer_prof-common-code kernel/itimer.c
--- a/kernel/itimer.c~itimers-merge-itimer_virt-and-itimer_prof-common-code
+++ a/kernel/itimer.c
@@ -41,10 +41,48 @@ static struct timeval itimer_get_remtime
 	return ktime_to_timeval(rem);
 }
 
+static void get_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
+			   struct itimerval *value)
+{
+	cputime_t cval, cinterval;
+	struct cpu_itimer *it = &tsk->signal->it[clock_id];
+
+	spin_lock_irq(&tsk->sighand->siglock);
+
+	cval = it->expires;
+	cinterval = it->incr;
+	if (!cputime_eq(cval, cputime_zero)) {
+		struct task_cputime cputime;
+		cputime_t t;
+
+		thread_group_cputimer(tsk, &cputime);
+		switch (clock_id) {
+		default:
+			BUG();
+		case CPUCLOCK_PROF:
+			t = cputime_add(cputime.utime, cputime.stime);
+			break;
+		case CPUCLOCK_VIRT:
+			t = cputime.utime;
+			break;
+		}
+
+		if (cputime_le(cval, t)) { /* about to fire */
+			cval = jiffies_to_cputime(1);
+		} else {
+			cval = cputime_sub(cval, t);
+		}
+	}
+
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	cputime_to_timeval(cval, &value->it_value);
+	cputime_to_timeval(cinterval, &value->it_interval);
+}
+
 int do_getitimer(int which, struct itimerval *value)
 {
 	struct task_struct *tsk = current;
-	cputime_t cinterval, cval;
 
 	switch (which) {
 	case ITIMER_REAL:
@@ -55,44 +93,10 @@ int do_getitimer(int which, struct itime
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_virt_expires;
-		cinterval = tsk->signal->it_virt_incr;
-		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_cputime cputime;
-			cputime_t utime;
-
-			thread_group_cputimer(tsk, &cputime);
-			utime = cputime.utime;
-			if (cputime_le(cval, utime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
-			} else {
-				cval = cputime_sub(cval, utime);
-			}
-		}
-		spin_unlock_irq(&tsk->sighand->siglock);
-		cputime_to_timeval(cval, &value->it_value);
-		cputime_to_timeval(cinterval, &value->it_interval);
+		get_cpu_itimer(tsk, CPUCLOCK_VIRT, value);
 		break;
 	case ITIMER_PROF:
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_prof_expires;
-		cinterval = tsk->signal->it_prof_incr;
-		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_cputime times;
-			cputime_t ptime;
-
-			thread_group_cputimer(tsk, &times);
-			ptime = cputime_add(times.utime, times.stime);
-			if (cputime_le(cval, ptime)) { /* about to fire */
-				cval = jiffies_to_cputime(1);
-			} else {
-				cval = cputime_sub(cval, ptime);
-			}
-		}
-		spin_unlock_irq(&tsk->sighand->siglock);
-		cputime_to_timeval(cval, &value->it_value);
-		cputime_to_timeval(cinterval, &value->it_interval);
+		get_cpu_itimer(tsk, CPUCLOCK_PROF, value);
 		break;
 	default:
 		return(-EINVAL);
@@ -128,6 +132,36 @@ enum hrtimer_restart it_real_fn(struct h
 	return HRTIMER_NORESTART;
 }
 
+static void set_cpu_itimer(struct task_struct *tsk, unsigned int clock_id,
+			   struct itimerval *value, struct itimerval *ovalue)
+{
+	cputime_t cval, cinterval, nval, ninterval;
+	struct cpu_itimer *it = &tsk->signal->it[clock_id];
+
+	nval = timeval_to_cputime(&value->it_value);
+	ninterval = timeval_to_cputime(&value->it_interval);
+
+	spin_lock_irq(&tsk->sighand->siglock);
+
+	cval = it->expires;
+	cinterval = it->incr;
+	if (!cputime_eq(cval, cputime_zero) ||
+	    !cputime_eq(nval, cputime_zero)) {
+		if (cputime_gt(nval, cputime_zero))
+			nval = cputime_add(nval, jiffies_to_cputime(1));
+		set_process_cpu_timer(tsk, clock_id, &nval, &cval);
+	}
+	it->expires = nval;
+	it->incr = ninterval;
+
+	spin_unlock_irq(&tsk->sighand->siglock);
+
+	if (ovalue) {
+		cputime_to_timeval(cval, &ovalue->it_value);
+		cputime_to_timeval(cinterval, &ovalue->it_interval);
+	}
+}
+
 /*
  * Returns true if the timeval is in canonical form
  */
@@ -139,7 +173,6 @@ int do_setitimer(int which, struct itime
 	struct task_struct *tsk = current;
 	struct hrtimer *timer;
 	ktime_t expires;
-	cputime_t cval, cinterval, nval, ninterval;
 
 	/*
 	 * Validate the timevals in value.
@@ -174,48 +207,10 @@ again:
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		nval = timeval_to_cputime(&value->it_value);
-		ninterval = timeval_to_cputime(&value->it_interval);
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_virt_expires;
-		cinterval = tsk->signal->it_virt_incr;
-		if (!cputime_eq(cval, cputime_zero) ||
-		    !cputime_eq(nval, cputime_zero)) {
-			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
-			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
-					      &nval, &cval);
-		}
-		tsk->signal->it_virt_expires = nval;
-		tsk->signal->it_virt_incr = ninterval;
-		spin_unlock_irq(&tsk->sighand->siglock);
-		if (ovalue) {
-			cputime_to_timeval(cval, &ovalue->it_value);
-			cputime_to_timeval(cinterval, &ovalue->it_interval);
-		}
+		set_cpu_itimer(tsk, CPUCLOCK_VIRT, value, ovalue);
 		break;
 	case ITIMER_PROF:
-		nval = timeval_to_cputime(&value->it_value);
-		ninterval = timeval_to_cputime(&value->it_interval);
-		spin_lock_irq(&tsk->sighand->siglock);
-		cval = tsk->signal->it_prof_expires;
-		cinterval = tsk->signal->it_prof_incr;
-		if (!cputime_eq(cval, cputime_zero) ||
-		    !cputime_eq(nval, cputime_zero)) {
-			if (cputime_gt(nval, cputime_zero))
-				nval = cputime_add(nval,
-						   jiffies_to_cputime(1));
-			set_process_cpu_timer(tsk, CPUCLOCK_PROF,
-					      &nval, &cval);
-		}
-		tsk->signal->it_prof_expires = nval;
-		tsk->signal->it_prof_incr = ninterval;
-		spin_unlock_irq(&tsk->sighand->siglock);
-		if (ovalue) {
-			cputime_to_timeval(cval, &ovalue->it_value);
-			cputime_to_timeval(cinterval, &ovalue->it_interval);
-		}
+		set_cpu_itimer(tsk, CPUCLOCK_PROF, value, ovalue);
 		break;
 	default:
 		return -EINVAL;
diff -puN kernel/posix-cpu-timers.c~itimers-merge-itimer_virt-and-itimer_prof-common-code kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~itimers-merge-itimer_virt-and-itimer_prof-common-code
+++ a/kernel/posix-cpu-timers.c
@@ -14,11 +14,11 @@
  */
 void update_rlimit_cpu(unsigned long rlim_new)
 {
-	cputime_t cputime;
+	cputime_t cputime = secs_to_cputime(rlim_new);
+	struct signal_struct *const sig = current->signal;
 
-	cputime = secs_to_cputime(rlim_new);
-	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
-	    cputime_gt(current->signal->it_prof_expires, cputime)) {
+	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
+	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
 		spin_lock_irq(&current->sighand->siglock);
 		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
 		spin_unlock_irq(&current->sighand->siglock);
@@ -613,36 +613,39 @@ static void arm_timer(struct k_itimer *t
 				break;
 			}
 		} else {
+			struct signal_struct *const sig = p->signal;
+
 			/*
 			 * For a process timer, set the cached expiration time.
 			 */
+
 			switch (CPUCLOCK_WHICH(timer->it_clock)) {
 			default:
 				BUG();
 			case CPUCLOCK_VIRT:
-				if (!cputime_eq(p->signal->it_virt_expires,
+				if (!cputime_eq(sig->it[CPUCLOCK_VIRT].expires,
 						cputime_zero) &&
-				    cputime_lt(p->signal->it_virt_expires,
+				    cputime_lt(sig->it[CPUCLOCK_VIRT].expires,
 					       timer->it.cpu.expires.cpu))
 					break;
 				p->signal->cputime_expires.virt_exp =
 					timer->it.cpu.expires.cpu;
 				break;
 			case CPUCLOCK_PROF:
-				if (!cputime_eq(p->signal->it_prof_expires,
+				if (!cputime_eq(sig->it[CPUCLOCK_PROF].expires,
 						cputime_zero) &&
-				    cputime_lt(p->signal->it_prof_expires,
+				    cputime_lt(sig->it[CPUCLOCK_PROF].expires,
 					       timer->it.cpu.expires.cpu))
 					break;
 				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
 				if (i != RLIM_INFINITY &&
 				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
 					break;
-				p->signal->cputime_expires.prof_exp =
+				sig->cputime_expires.prof_exp =
 					timer->it.cpu.expires.cpu;
 				break;
 			case CPUCLOCK_SCHED:
-				p->signal->cputime_expires.sched_exp =
+				sig->cputime_expires.sched_exp =
 					timer->it.cpu.expires.sched;
 				break;
 			}
@@ -1070,6 +1073,28 @@ static void stop_process_timers(struct t
 	spin_unlock_irqrestore(&cputimer->lock, flags);
 }
 
+static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
+			     cputime_t *expires, cputime_t cur_time, int signo)
+{
+	if (cputime_eq(it->expires, cputime_zero))
+		return;
+
+	if (cputime_ge(cur_time, it->expires)) {
+		it->expires = it->incr;
+		if (!cputime_eq(it->expires, cputime_zero)) {
+			it->expires = cputime_add(it->expires, cur_time);
+		}
+
+		__group_send_sig_info(signo, SEND_SIG_PRIV, tsk);
+	}
+
+	if (!cputime_eq(it->expires, cputime_zero) &&
+	    (cputime_eq(*expires, cputime_zero) ||
+	     cputime_lt(it->expires, *expires))) {
+		*expires = it->expires;
+	}
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1089,10 +1114,10 @@ static void check_process_timers(struct 
 	 * Don't sample the current process CPU clocks if there are no timers.
 	 */
 	if (list_empty(&timers[CPUCLOCK_PROF]) &&
-	    cputime_eq(sig->it_prof_expires, cputime_zero) &&
+	    cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) &&
 	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
 	    list_empty(&timers[CPUCLOCK_VIRT]) &&
-	    cputime_eq(sig->it_virt_expires, cputime_zero) &&
+	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
 	    list_empty(&timers[CPUCLOCK_SCHED])) {
 		stop_process_timers(tsk);
 		return;
@@ -1152,38 +1177,11 @@ static void check_process_timers(struct 
 	/*
 	 * Check for the special case process timers.
 	 */
-	if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
-		if (cputime_ge(ptime, sig->it_prof_expires)) {
-			/* ITIMER_PROF fires and reloads.  */
-			sig->it_prof_expires = sig->it_prof_incr;
-			if (!cputime_eq(sig->it_prof_expires, cputime_zero)) {
-				sig->it_prof_expires = cputime_add(
-					sig->it_prof_expires, ptime);
-			}
-			__group_send_sig_info(SIGPROF, SEND_SIG_PRIV, tsk);
-		}
-		if (!cputime_eq(sig->it_prof_expires, cputime_zero) &&
-		    (cputime_eq(prof_expires, cputime_zero) ||
-		     cputime_lt(sig->it_prof_expires, prof_expires))) {
-			prof_expires = sig->it_prof_expires;
-		}
-	}
-	if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
-		if (cputime_ge(utime, sig->it_virt_expires)) {
-			/* ITIMER_VIRTUAL fires and reloads.  */
-			sig->it_virt_expires = sig->it_virt_incr;
-			if (!cputime_eq(sig->it_virt_expires, cputime_zero)) {
-				sig->it_virt_expires = cputime_add(
-					sig->it_virt_expires, utime);
-			}
-			__group_send_sig_info(SIGVTALRM, SEND_SIG_PRIV, tsk);
-		}
-		if (!cputime_eq(sig->it_virt_expires, cputime_zero) &&
-		    (cputime_eq(virt_expires, cputime_zero) ||
-		     cputime_lt(sig->it_virt_expires, virt_expires))) {
-			virt_expires = sig->it_virt_expires;
-		}
-	}
+	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_PROF], &prof_expires, ptime,
+			 SIGPROF);
+	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
+			 SIGVTALRM);
+
 	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
 		cputime_t x;
_

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
itimers-merge-itimer_virt-and-itimer_prof-common-code.patch
itimers-fix-periodic-tics-precision.patch

