From: akpm@linux-foundation.org
Subject: [merged] posix_cpu_timer-consolidate-expiry-time-type.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:37:38 -0700
Message-ID: <51db1502.g9VpV6TThvpGZM7G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHThj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sgruszka@redhat.com, oleg@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl, fweisbec@gmail.com

Subject: [merged] posix_cpu_timer-consolidate-expiry-time-type.patch removed from -mm tree
To: fweisbec@gmail.com,a.p.zijlstra@chello.nl,mingo@elte.hu,oleg@redhat.com,sgruszka@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:38 -0700


The patch titled
     Subject: posix_cpu_timer: consolidate expiry time type
has been removed from the -mm tree.  Its filename was
     posix_cpu_timer-consolidate-expiry-time-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_cpu_timer: consolidate expiry time type

The posix cpu timer expiry time is stored in a union of two types: a 64
bits field if we rely on scheduler precise accounting, or a cputime_t if
we rely on jiffies.

This results in quite some duplicate code and special cases to handle the
two types.

Just unify this into a single 64 bits field.  cputime_t can always fit
into it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/posix-timers.h |   16 +
 kernel/posix-cpu-timers.c    |  266 +++++++++++++--------------------
 2 files changed, 117 insertions(+), 165 deletions(-)

diff -puN include/linux/posix-timers.h~posix_cpu_timer-consolidate-expiry-time-type include/linux/posix-timers.h
--- a/include/linux/posix-timers.h~posix_cpu_timer-consolidate-expiry-time-type
+++ a/include/linux/posix-timers.h
@@ -7,14 +7,20 @@
 #include <linux/timex.h>
 #include <linux/alarmtimer.h>
 
-union cpu_time_count {
-	cputime_t cpu;
-	unsigned long long sched;
-};
+
+static inline unsigned long long cputime_to_expires(cputime_t expires)
+{
+	return (__force unsigned long long)expires;
+}
+
+static inline cputime_t expires_to_cputime(unsigned long long expires)
+{
+	return (__force cputime_t)expires;
+}
 
 struct cpu_timer_list {
 	struct list_head entry;
-	union cpu_time_count expires, incr;
+	unsigned long long expires, incr;
 	struct task_struct *task;
 	int firing;
 };
diff -puN kernel/posix-cpu-timers.c~posix_cpu_timer-consolidate-expiry-time-type kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix_cpu_timer-consolidate-expiry-time-type
+++ a/kernel/posix-cpu-timers.c
@@ -51,59 +51,28 @@ static int check_clock(const clockid_t w
 	return error;
 }
 
-static inline union cpu_time_count
+static inline unsigned long long
 timespec_to_sample(const clockid_t which_clock, const struct timespec *tp)
 {
-	union cpu_time_count ret;
-	ret.sched = 0;		/* high half always zero when .cpu used */
+	unsigned long long ret;
+
+	ret = 0;		/* high half always zero when .cpu used */
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		ret.sched = (unsigned long long)tp->tv_sec * NSEC_PER_SEC + tp->tv_nsec;
+		ret = (unsigned long long)tp->tv_sec * NSEC_PER_SEC + tp->tv_nsec;
 	} else {
-		ret.cpu = timespec_to_cputime(tp);
+		ret = cputime_to_expires(timespec_to_cputime(tp));
 	}
 	return ret;
 }
 
 static void sample_to_timespec(const clockid_t which_clock,
-			       union cpu_time_count cpu,
+			       unsigned long long expires,
 			       struct timespec *tp)
 {
 	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED)
-		*tp = ns_to_timespec(cpu.sched);
+		*tp = ns_to_timespec(expires);
 	else
-		cputime_to_timespec(cpu.cpu, tp);
-}
-
-static inline int cpu_time_before(const clockid_t which_clock,
-				  union cpu_time_count now,
-				  union cpu_time_count then)
-{
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		return now.sched < then.sched;
-	}  else {
-		return now.cpu < then.cpu;
-	}
-}
-static inline void cpu_time_add(const clockid_t which_clock,
-				union cpu_time_count *acc,
-			        union cpu_time_count val)
-{
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		acc->sched += val.sched;
-	}  else {
-		acc->cpu += val.cpu;
-	}
-}
-static inline union cpu_time_count cpu_time_sub(const clockid_t which_clock,
-						union cpu_time_count a,
-						union cpu_time_count b)
-{
-	if (CPUCLOCK_WHICH(which_clock) == CPUCLOCK_SCHED) {
-		a.sched -= b.sched;
-	}  else {
-		a.cpu -= b.cpu;
-	}
-	return a;
+		cputime_to_timespec((__force cputime_t)expires, tp);
 }
 
 /*
@@ -111,47 +80,31 @@ static inline union cpu_time_count cpu_t
  * given the current clock sample.
  */
 static void bump_cpu_timer(struct k_itimer *timer,
-				  union cpu_time_count now)
+			   unsigned long long now)
 {
 	int i;
+	unsigned long long delta, incr;
 
-	if (timer->it.cpu.incr.sched == 0)
+	if (timer->it.cpu.incr == 0)
 		return;
 
-	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
-		unsigned long long delta, incr;
+	if (now < timer->it.cpu.expires)
+		return;
 
-		if (now.sched < timer->it.cpu.expires.sched)
-			return;
-		incr = timer->it.cpu.incr.sched;
-		delta = now.sched + incr - timer->it.cpu.expires.sched;
-		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; incr < delta - incr; i++)
-			incr = incr << 1;
-		for (; i >= 0; incr >>= 1, i--) {
-			if (delta < incr)
-				continue;
-			timer->it.cpu.expires.sched += incr;
-			timer->it_overrun += 1 << i;
-			delta -= incr;
-		}
-	} else {
-		cputime_t delta, incr;
+	incr = timer->it.cpu.incr;
+	delta = now + incr - timer->it.cpu.expires;
 
-		if (now.cpu < timer->it.cpu.expires.cpu)
-			return;
-		incr = timer->it.cpu.incr.cpu;
-		delta = now.cpu + incr - timer->it.cpu.expires.cpu;
-		/* Don't use (incr*2 < delta), incr*2 might overflow. */
-		for (i = 0; incr < delta - incr; i++)
-			     incr += incr;
-		for (; i >= 0; incr = incr >> 1, i--) {
-			if (delta < incr)
-				continue;
-			timer->it.cpu.expires.cpu += incr;
-			timer->it_overrun += 1 << i;
-			delta -= incr;
-		}
+	/* Don't use (incr*2 < delta), incr*2 might overflow. */
+	for (i = 0; incr < delta - incr; i++)
+		incr = incr << 1;
+
+	for (; i >= 0; incr >>= 1, i--) {
+		if (delta < incr)
+			continue;
+
+		timer->it.cpu.expires += incr;
+		timer->it_overrun += 1 << i;
+		delta -= incr;
 	}
 }
 
@@ -170,21 +123,21 @@ static inline int task_cputime_zero(cons
 	return 0;
 }
 
-static inline cputime_t prof_ticks(struct task_struct *p)
+static inline unsigned long long prof_ticks(struct task_struct *p)
 {
 	cputime_t utime, stime;
 
 	task_cputime(p, &utime, &stime);
 
-	return utime + stime;
+	return cputime_to_expires(utime + stime);
 }
-static inline cputime_t virt_ticks(struct task_struct *p)
+static inline unsigned long long virt_ticks(struct task_struct *p)
 {
 	cputime_t utime;
 
 	task_cputime(p, &utime, NULL);
 
-	return utime;
+	return cputime_to_expires(utime);
 }
 
 static int
@@ -225,19 +178,19 @@ posix_cpu_clock_set(const clockid_t whic
  * Sample a per-thread clock for the given task.
  */
 static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
-			    union cpu_time_count *cpu)
+			    unsigned long long *sample)
 {
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = prof_ticks(p);
+		*sample = prof_ticks(p);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = virt_ticks(p);
+		*sample = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = task_sched_runtime(p);
+		*sample = task_sched_runtime(p);
 		break;
 	}
 	return 0;
@@ -284,7 +237,7 @@ void thread_group_cputimer(struct task_s
  */
 static int cpu_clock_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
-				  union cpu_time_count *cpu)
+				  unsigned long long *sample)
 {
 	struct task_cputime cputime;
 
@@ -293,15 +246,15 @@ static int cpu_clock_sample_group(const
 		return -EINVAL;
 	case CPUCLOCK_PROF:
 		thread_group_cputime(p, &cputime);
-		cpu->cpu = cputime.utime + cputime.stime;
+		*sample = cputime_to_expires(cputime.utime + cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
 		thread_group_cputime(p, &cputime);
-		cpu->cpu = cputime.utime;
+		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
 		thread_group_cputime(p, &cputime);
-		cpu->sched = cputime.sum_exec_runtime;
+		*sample = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
@@ -312,7 +265,7 @@ static int posix_cpu_clock_get(const clo
 {
 	const pid_t pid = CPUCLOCK_PID(which_clock);
 	int error = -EINVAL;
-	union cpu_time_count rtn;
+	unsigned long long rtn;
 
 	if (pid == 0) {
 		/*
@@ -461,30 +414,30 @@ static void cleanup_timers(struct list_h
 
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (timer->expires.cpu < ptime) {
-			timer->expires.cpu = 0;
+		if (timer->expires < cputime_to_expires(ptime)) {
+			timer->expires = 0;
 		} else {
-			timer->expires.cpu -= ptime;
+			timer->expires -= cputime_to_expires(ptime);
 		}
 	}
 
 	++head;
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (timer->expires.cpu < utime) {
-			timer->expires.cpu = 0;
+		if (timer->expires < cputime_to_expires(utime)) {
+			timer->expires = 0;
 		} else {
-			timer->expires.cpu -= utime;
+			timer->expires -= cputime_to_expires(utime);
 		}
 	}
 
 	++head;
 	list_for_each_entry_safe(timer, next, head, entry) {
 		list_del_init(&timer->entry);
-		if (timer->expires.sched < sum_exec_runtime) {
-			timer->expires.sched = 0;
+		if (timer->expires < sum_exec_runtime) {
+			timer->expires = 0;
 		} else {
-			timer->expires.sched -= sum_exec_runtime;
+			timer->expires -= sum_exec_runtime;
 		}
 	}
 }
@@ -516,7 +469,7 @@ void posix_cpu_timers_exit_group(struct
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
-static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
+static void clear_dead_task(struct k_itimer *timer, unsigned long long now)
 {
 	/*
 	 * That's all for this thread or process.
@@ -524,9 +477,7 @@ static void clear_dead_task(struct k_iti
 	 */
 	put_task_struct(timer->it.cpu.task);
 	timer->it.cpu.task = NULL;
-	timer->it.cpu.expires = cpu_time_sub(timer->it_clock,
-					     timer->it.cpu.expires,
-					     now);
+	timer->it.cpu.expires -= now;
 }
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
@@ -558,14 +509,14 @@ static void arm_timer(struct k_itimer *t
 
 	listpos = head;
 	list_for_each_entry(next, head, entry) {
-		if (cpu_time_before(timer->it_clock, nt->expires, next->expires))
+		if (nt->expires < next->expires)
 			break;
 		listpos = &next->entry;
 	}
 	list_add(&nt->entry, listpos);
 
 	if (listpos == head) {
-		union cpu_time_count *exp = &nt->expires;
+		unsigned long long exp = nt->expires;
 
 		/*
 		 * We are the new earliest-expiring POSIX 1.b timer, hence
@@ -576,17 +527,17 @@ static void arm_timer(struct k_itimer *t
 
 		switch (CPUCLOCK_WHICH(timer->it_clock)) {
 		case CPUCLOCK_PROF:
-			if (expires_gt(cputime_expires->prof_exp, exp->cpu))
-				cputime_expires->prof_exp = exp->cpu;
+			if (expires_gt(cputime_expires->prof_exp, expires_to_cputime(exp)))
+				cputime_expires->prof_exp = expires_to_cputime(exp);
 			break;
 		case CPUCLOCK_VIRT:
-			if (expires_gt(cputime_expires->virt_exp, exp->cpu))
-				cputime_expires->virt_exp = exp->cpu;
+			if (expires_gt(cputime_expires->virt_exp, expires_to_cputime(exp)))
+				cputime_expires->virt_exp = expires_to_cputime(exp);
 			break;
 		case CPUCLOCK_SCHED:
 			if (cputime_expires->sched_exp == 0 ||
-			    cputime_expires->sched_exp > exp->sched)
-				cputime_expires->sched_exp = exp->sched;
+			    cputime_expires->sched_exp > exp)
+				cputime_expires->sched_exp = exp;
 			break;
 		}
 	}
@@ -601,20 +552,20 @@ static void cpu_timer_fire(struct k_itim
 		/*
 		 * User don't want any signal.
 		 */
-		timer->it.cpu.expires.sched = 0;
+		timer->it.cpu.expires = 0;
 	} else if (unlikely(timer->sigq == NULL)) {
 		/*
 		 * This a special case for clock_nanosleep,
 		 * not a normal timer from sys_timer_create.
 		 */
 		wake_up_process(timer->it_process);
-		timer->it.cpu.expires.sched = 0;
-	} else if (timer->it.cpu.incr.sched == 0) {
+		timer->it.cpu.expires = 0;
+	} else if (timer->it.cpu.incr == 0) {
 		/*
 		 * One-shot timer.  Clear it as soon as it's fired.
 		 */
 		posix_timer_event(timer, 0);
-		timer->it.cpu.expires.sched = 0;
+		timer->it.cpu.expires = 0;
 	} else if (posix_timer_event(timer, ++timer->it_requeue_pending)) {
 		/*
 		 * The signal did not get queued because the signal
@@ -632,7 +583,7 @@ static void cpu_timer_fire(struct k_itim
  */
 static int cpu_timer_sample_group(const clockid_t which_clock,
 				  struct task_struct *p,
-				  union cpu_time_count *cpu)
+				  unsigned long long *sample)
 {
 	struct task_cputime cputime;
 
@@ -641,13 +592,13 @@ static int cpu_timer_sample_group(const
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime.utime + cputime.stime;
+		*sample = cputime_to_expires(cputime.utime + cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = cputime.utime;
+		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		*sample = cputime.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
 	return 0;
@@ -694,7 +645,7 @@ static int posix_cpu_timer_set(struct k_
 			       struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count old_expires, new_expires, old_incr, val;
+	unsigned long long old_expires, new_expires, old_incr, val;
 	int ret;
 
 	if (unlikely(p == NULL)) {
@@ -749,7 +700,7 @@ static int posix_cpu_timer_set(struct k_
 	}
 
 	if (old) {
-		if (old_expires.sched == 0) {
+		if (old_expires == 0) {
 			old->it_value.tv_sec = 0;
 			old->it_value.tv_nsec = 0;
 		} else {
@@ -764,11 +715,8 @@ static int posix_cpu_timer_set(struct k_
 			 * new setting.
 			 */
 			bump_cpu_timer(timer, val);
-			if (cpu_time_before(timer->it_clock, val,
-					    timer->it.cpu.expires)) {
-				old_expires = cpu_time_sub(
-					timer->it_clock,
-					timer->it.cpu.expires, val);
+			if (val < timer->it.cpu.expires) {
+				old_expires = timer->it.cpu.expires - val;
 				sample_to_timespec(timer->it_clock,
 						   old_expires,
 						   &old->it_value);
@@ -791,8 +739,8 @@ static int posix_cpu_timer_set(struct k_
 		goto out;
 	}
 
-	if (new_expires.sched != 0 && !(flags & TIMER_ABSTIME)) {
-		cpu_time_add(timer->it_clock, &new_expires, val);
+	if (new_expires != 0 && !(flags & TIMER_ABSTIME)) {
+		new_expires += val;
 	}
 
 	/*
@@ -801,8 +749,7 @@ static int posix_cpu_timer_set(struct k_
 	 * arm the timer (we'll just fake it for timer_gettime).
 	 */
 	timer->it.cpu.expires = new_expires;
-	if (new_expires.sched != 0 &&
-	    cpu_time_before(timer->it_clock, val, new_expires)) {
+	if (new_expires != 0 && val < new_expires) {
 		arm_timer(timer);
 	}
 
@@ -826,8 +773,7 @@ static int posix_cpu_timer_set(struct k_
 	timer->it_overrun_last = 0;
 	timer->it_overrun = -1;
 
-	if (new_expires.sched != 0 &&
-	    !cpu_time_before(timer->it_clock, val, new_expires)) {
+	if (new_expires != 0 && !(val < new_expires)) {
 		/*
 		 * The designated time already passed, so we notify
 		 * immediately, even if the thread never runs to
@@ -849,7 +795,7 @@ static int posix_cpu_timer_set(struct k_
 
 static void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 {
-	union cpu_time_count now;
+	unsigned long long now;
 	struct task_struct *p = timer->it.cpu.task;
 	int clear_dead;
 
@@ -859,7 +805,7 @@ static void posix_cpu_timer_get(struct k
 	sample_to_timespec(timer->it_clock,
 			   timer->it.cpu.incr, &itp->it_interval);
 
-	if (timer->it.cpu.expires.sched == 0) {	/* Timer not armed at all.  */
+	if (timer->it.cpu.expires == 0) {	/* Timer not armed at all.  */
 		itp->it_value.tv_sec = itp->it_value.tv_nsec = 0;
 		return;
 	}
@@ -891,7 +837,7 @@ static void posix_cpu_timer_get(struct k
 			 */
 			put_task_struct(p);
 			timer->it.cpu.task = NULL;
-			timer->it.cpu.expires.sched = 0;
+			timer->it.cpu.expires = 0;
 			read_unlock(&tasklist_lock);
 			goto dead;
 		} else {
@@ -912,10 +858,9 @@ static void posix_cpu_timer_get(struct k
 		goto dead;
 	}
 
-	if (cpu_time_before(timer->it_clock, now, timer->it.cpu.expires)) {
+	if (now < timer->it.cpu.expires) {
 		sample_to_timespec(timer->it_clock,
-				   cpu_time_sub(timer->it_clock,
-						timer->it.cpu.expires, now),
+				   timer->it.cpu.expires - now,
 				   &itp->it_value);
 	} else {
 		/*
@@ -946,8 +891,8 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || prof_ticks(tsk) < t->expires.cpu) {
-			tsk->cputime_expires.prof_exp = t->expires.cpu;
+		if (!--maxfire || prof_ticks(tsk) < t->expires) {
+			tsk->cputime_expires.prof_exp = expires_to_cputime(t->expires);
 			break;
 		}
 		t->firing = 1;
@@ -961,8 +906,8 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || virt_ticks(tsk) < t->expires.cpu) {
-			tsk->cputime_expires.virt_exp = t->expires.cpu;
+		if (!--maxfire || virt_ticks(tsk) < t->expires) {
+			tsk->cputime_expires.virt_exp = expires_to_cputime(t->expires);
 			break;
 		}
 		t->firing = 1;
@@ -976,8 +921,8 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
-			tsk->cputime_expires.sched_exp = t->expires.sched;
+		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires) {
+			tsk->cputime_expires.sched_exp = t->expires;
 			break;
 		}
 		t->firing = 1;
@@ -1030,7 +975,8 @@ static void stop_process_timers(struct s
 static u32 onecputick;
 
 static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
-			     cputime_t *expires, cputime_t cur_time, int signo)
+			     unsigned long long *expires,
+			     unsigned long long cur_time, int signo)
 {
 	if (!it->expires)
 		return;
@@ -1068,7 +1014,7 @@ static void check_process_timers(struct
 {
 	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, ptime, virt_expires, prof_expires;
+	unsigned long long utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
@@ -1078,8 +1024,8 @@ static void check_process_timers(struct
 	 * Collect the current process totals.
 	 */
 	thread_group_cputimer(tsk, &cputime);
-	utime = cputime.utime;
-	ptime = utime + cputime.stime;
+	utime = cputime_to_expires(cputime.utime);
+	ptime = utime + cputime_to_expires(cputime.stime);
 	sum_sched_runtime = cputime.sum_exec_runtime;
 	maxfire = 20;
 	prof_expires = 0;
@@ -1087,8 +1033,8 @@ static void check_process_timers(struct
 		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || ptime < tl->expires.cpu) {
-			prof_expires = tl->expires.cpu;
+		if (!--maxfire || ptime < tl->expires) {
+			prof_expires = tl->expires;
 			break;
 		}
 		tl->firing = 1;
@@ -1102,8 +1048,8 @@ static void check_process_timers(struct
 		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || utime < tl->expires.cpu) {
-			virt_expires = tl->expires.cpu;
+		if (!--maxfire || utime < tl->expires) {
+			virt_expires = tl->expires;
 			break;
 		}
 		tl->firing = 1;
@@ -1117,8 +1063,8 @@ static void check_process_timers(struct
 		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || sum_sched_runtime < tl->expires.sched) {
-			sched_expires = tl->expires.sched;
+		if (!--maxfire || sum_sched_runtime < tl->expires) {
+			sched_expires = tl->expires;
 			break;
 		}
 		tl->firing = 1;
@@ -1162,8 +1108,8 @@ static void check_process_timers(struct
 		}
 	}
 
-	sig->cputime_expires.prof_exp = prof_expires;
-	sig->cputime_expires.virt_exp = virt_expires;
+	sig->cputime_expires.prof_exp = expires_to_cputime(prof_expires);
+	sig->cputime_expires.virt_exp = expires_to_cputime(virt_expires);
 	sig->cputime_expires.sched_exp = sched_expires;
 	if (task_cputime_zero(&sig->cputime_expires))
 		stop_process_timers(sig);
@@ -1176,7 +1122,7 @@ static void check_process_timers(struct
 void posix_cpu_timer_schedule(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count now;
+	unsigned long long now;
 
 	if (unlikely(p == NULL))
 		/*
@@ -1205,7 +1151,7 @@ void posix_cpu_timer_schedule(struct k_i
 			 */
 			put_task_struct(p);
 			timer->it.cpu.task = p = NULL;
-			timer->it.cpu.expires.sched = 0;
+			timer->it.cpu.expires = 0;
 			goto out_unlock;
 		} else if (unlikely(p->exit_state) && thread_group_empty(p)) {
 			/*
@@ -1387,7 +1333,7 @@ void run_posix_cpu_timers(struct task_st
 void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval)
 {
-	union cpu_time_count now;
+	unsigned long long now;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
@@ -1399,17 +1345,17 @@ void set_process_cpu_timer(struct task_s
 		 * it to be absolute.
 		 */
 		if (*oldval) {
-			if (*oldval <= now.cpu) {
+			if (*oldval <= now) {
 				/* Just about to fire. */
 				*oldval = cputime_one_jiffy;
 			} else {
-				*oldval -= now.cpu;
+				*oldval -= now;
 			}
 		}
 
 		if (!*newval)
 			goto out;
-		*newval += now.cpu;
+		*newval += now;
 	}
 
 	/*
@@ -1459,7 +1405,7 @@ static int do_cpu_nanosleep(const clocki
 		}
 
 		while (!signal_pending(current)) {
-			if (timer.it.cpu.expires.sched == 0) {
+			if (timer.it.cpu.expires == 0) {
 				/*
 				 * Our timer fired and was reset, below
 				 * deletion can not fail.
_

Patches currently in -mm which might be from fweisbec@gmail.com are

origin.patch
linux-next.patch
ptrace-x86-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-powerpc-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-arm-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-sh-revert-hw_breakpoints-fix-racy-access-to-ptrace-breakpoints.patch
ptrace-revert-prepare-to-fix-racy-accesses-on-task-breakpoints.patch
ptrace-x86-simplify-the-disable-logic-in-ptrace_write_dr7.patch
ptrace-x86-dont-delay-disable-till-second-pass-in-ptrace_write_dr7.patch
ptrace-x86-introduce-ptrace_register_breakpoint.patch
ptrace-x86-ptrace_write_dr7-should-create-bp-if-disabled.patch
ptrace-x86-cleanup-ptrace_set_debugreg.patch
ptrace-ptrace_detach-should-do-flush_ptrace_hw_breakpointchild.patch
ptrace-x86-flush_ptrace_hw_breakpoint-shoule-clear-the-virtual-debug-registers.patch

