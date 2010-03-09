From: akpm@linux-foundation.org
Subject: [merged] kernel-core-use-helpers-for-rlimits.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:06:29 -0800
Message-ID: <201003091906.o29J6TkU031262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756009Ab0CITWl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, johnstul@us.ibm.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     kernel core: use helpers for rlimits
has been removed from the -mm tree.  Its filename was
     kernel-core-use-helpers-for-rlimits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel core: use helpers for rlimits
From: Jiri Slaby <jslaby@suse.cz>

Make sure compiler won't do weird things with limits.  E.g.  fetching them
twice may return 2 different values after writable limits are implemented.

I.e.  either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd ("resource: add helpers for
fetching rlimits") or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c             |   10 ++++++----
 kernel/perf_event.c       |    2 +-
 kernel/posix-cpu-timers.c |   10 ++++++----
 kernel/sched.c            |    4 ++--
 kernel/sched_rt.c         |    5 +++--
 kernel/signal.c           |    2 +-
 kernel/sys.c              |    3 +--
 7 files changed, 20 insertions(+), 16 deletions(-)

diff -puN kernel/fork.c~kernel-core-use-helpers-for-rlimits kernel/fork.c
--- a/kernel/fork.c~kernel-core-use-helpers-for-rlimits
+++ a/kernel/fork.c
@@ -828,6 +828,8 @@ void __cleanup_sighand(struct sighand_st
  */
 static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
+	unsigned long cpu_limit;
+
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
@@ -842,9 +844,9 @@ static void posix_cpu_timers_init_group(
 	sig->cputime_expires.virt_exp = cputime_zero;
 	sig->cputime_expires.sched_exp = 0;
 
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-		sig->cputime_expires.prof_exp =
-			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
+	if (cpu_limit != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
 		sig->cputimer.running = 1;
 	}
 
@@ -1037,7 +1039,7 @@ static struct task_struct *copy_process(
 #endif
 	retval = -EAGAIN;
 	if (atomic_read(&p->real_cred->user->processes) >=
-			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
+			task_rlimit(p, RLIMIT_NPROC)) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
 		    p->real_cred->user != INIT_USER)
 			goto bad_fork_free;
diff -puN kernel/perf_event.c~kernel-core-use-helpers-for-rlimits kernel/perf_event.c
--- a/kernel/perf_event.c~kernel-core-use-helpers-for-rlimits
+++ a/kernel/perf_event.c
@@ -2610,7 +2610,7 @@ static int perf_mmap(struct file *file, 
 	if (user_locked > user_lock_limit)
 		extra = user_locked - user_lock_limit;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
diff -puN kernel/posix-cpu-timers.c~kernel-core-use-helpers-for-rlimits kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~kernel-core-use-helpers-for-rlimits
+++ a/kernel/posix-cpu-timers.c
@@ -1031,9 +1031,10 @@ static void check_thread_timers(struct t
 	/*
 	 * Check for the special case thread timers.
 	 */
-	soft = sig->rlim[RLIMIT_RTTIME].rlim_cur;
+	soft = ACCESS_ONCE(sig->rlim[RLIMIT_RTTIME].rlim_cur);
 	if (soft != RLIM_INFINITY) {
-		unsigned long hard = sig->rlim[RLIMIT_RTTIME].rlim_max;
+		unsigned long hard =
+			ACCESS_ONCE(sig->rlim[RLIMIT_RTTIME].rlim_max);
 
 		if (hard != RLIM_INFINITY &&
 		    tsk->rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
@@ -1194,10 +1195,11 @@ static void check_process_timers(struct 
 			 SIGPROF);
 	check_cpu_itimer(tsk, &sig->it[CPUCLOCK_VIRT], &virt_expires, utime,
 			 SIGVTALRM);
-	soft = sig->rlim[RLIMIT_CPU].rlim_cur;
+	soft = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 	if (soft != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
-		unsigned long hard = sig->rlim[RLIMIT_CPU].rlim_max;
+		unsigned long hard =
+			ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_max);
 		cputime_t x;
 		if (psecs >= hard) {
 			/*
diff -puN kernel/sched.c~kernel-core-use-helpers-for-rlimits kernel/sched.c
--- a/kernel/sched.c~kernel-core-use-helpers-for-rlimits
+++ a/kernel/sched.c
@@ -4353,7 +4353,7 @@ int can_nice(const struct task_struct *p
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
 	int nice_rlim = 20 - nice;
 
-	return (nice_rlim <= p->signal->rlim[RLIMIT_NICE].rlim_cur ||
+	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
 		capable(CAP_SYS_NICE));
 }
 
@@ -4530,7 +4530,7 @@ recheck:
 
 			if (!lock_task_sighand(p, &flags))
 				return -ESRCH;
-			rlim_rtprio = p->signal->rlim[RLIMIT_RTPRIO].rlim_cur;
+			rlim_rtprio = task_rlimit(p, RLIMIT_RTPRIO);
 			unlock_task_sighand(p, &flags);
 
 			/* can't set/change the rt policy */
diff -puN kernel/sched_rt.c~kernel-core-use-helpers-for-rlimits kernel/sched_rt.c
--- a/kernel/sched_rt.c~kernel-core-use-helpers-for-rlimits
+++ a/kernel/sched_rt.c
@@ -1662,8 +1662,9 @@ static void watchdog(struct rq *rq, stru
 	if (!p->signal)
 		return;
 
-	soft = p->signal->rlim[RLIMIT_RTTIME].rlim_cur;
-	hard = p->signal->rlim[RLIMIT_RTTIME].rlim_max;
+	/* max may change after cur was read, this will be fixed next tick */
+	soft = task_rlimit(p, RLIMIT_RTTIME);
+	hard = task_rlimit_max(p, RLIMIT_RTTIME);
 
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
diff -puN kernel/signal.c~kernel-core-use-helpers-for-rlimits kernel/signal.c
--- a/kernel/signal.c~kernel-core-use-helpers-for-rlimits
+++ a/kernel/signal.c
@@ -245,7 +245,7 @@ __sigqueue_alloc(int sig, struct task_st
 
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
-			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur) {
+			task_rlimit(t, RLIMIT_SIGPENDING)) {
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
 	} else {
 		print_dropped_signal(sig);
diff -puN kernel/sys.c~kernel-core-use-helpers-for-rlimits kernel/sys.c
--- a/kernel/sys.c~kernel-core-use-helpers-for-rlimits
+++ a/kernel/sys.c
@@ -571,8 +571,7 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
-	if (atomic_read(&new_user->processes) >=
-				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
+	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
 			new_user != INIT_USER) {
 		free_uid(new_user);
 		return -EAGAIN;
_

Patches currently in -mm which might be from jslaby@suse.cz are

linux-next.patch
bootmem-avoid-dma32-zone-by-default.patch
ipc-use-rlimit-helpers.patch
edac-add-__init-to-i7core_xeon_pci_fixup.patch

