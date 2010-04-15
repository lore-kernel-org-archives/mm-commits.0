From: akpm@linux-foundation.org
Subject: [merged] cpu-timers-return-correct-previous-timer-reload-value.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:24 -0400
Message-ID: <201004151840.o3FIe2Vi024355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755480Ab0DOSlG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:41:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, mingo@elte.hu, oleg@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     cpu-timers: return correct previous timer reload value
has been removed from the -mm tree.  Its filename was
     cpu-timers-return-correct-previous-timer-reload-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu-timers: return correct previous timer reload value
From: Stanislaw Gruszka <sgruszka@redhat.com>

According POSIX we need to correctly set old timer it_interval value when
user request that in timer_settime().  Tested using below program.

 #include <sys/time.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <time.h>
 #include <unistd.h>
 #include <assert.h>

 int main(void)
 {
	struct sigaction act;
	struct sigevent evt = { };
	timer_t tid;
	struct itimerspec spec, u_spec, k_spec;

	evt.sigev_notify = SIGEV_SIGNAL;
	evt.sigev_signo = SIGPROF;
	assert(timer_create(CLOCK_PROCESS_CPUTIME_ID, &evt,  &tid) == 0);

	spec.it_value.tv_sec = 1;
	spec.it_value.tv_nsec = 2;
	spec.it_interval.tv_sec = 3;
	spec.it_interval.tv_nsec = 4;
	u_spec = spec;
	assert(timer_settime(tid, 0, &spec,  NULL) == 0);

	spec.it_value.tv_sec = 5;
	spec.it_value.tv_nsec = 6;
	spec.it_interval.tv_sec = 7;
	spec.it_interval.tv_nsec = 8;
	assert(timer_settime(tid, 0, &spec,  &k_spec) == 0);

 #define PRT(val) printf(#val ":\t%d/%d\n", (int) u_spec.val, (int) k_spec.val)
	PRT(it_value.tv_sec);
	PRT(it_value.tv_nsec);
	PRT(it_interval.tv_sec);
	PRT(it_interval.tv_nsec);

	return 0;
 }

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/posix-cpu-timers.c~cpu-timers-return-correct-previous-timer-reload-value kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~cpu-timers-return-correct-previous-timer-reload-value
+++ a/kernel/posix-cpu-timers.c
@@ -675,7 +675,7 @@ int posix_cpu_timer_set(struct k_itimer 
 			struct itimerspec *new, struct itimerspec *old)
 {
 	struct task_struct *p = timer->it.cpu.task;
-	union cpu_time_count old_expires, new_expires, val;
+	union cpu_time_count old_expires, new_expires, old_incr, val;
 	int ret;
 
 	if (unlikely(p == NULL)) {
@@ -706,6 +706,7 @@ int posix_cpu_timer_set(struct k_itimer 
 	BUG_ON(!irqs_disabled());
 
 	ret = 0;
+	old_incr = timer->it.cpu.incr;
 	spin_lock(&p->sighand->siglock);
 	old_expires = timer->it.cpu.expires;
 	if (unlikely(timer->it.cpu.firing)) {
@@ -821,7 +822,7 @@ int posix_cpu_timer_set(struct k_itimer 
  out:
 	if (old) {
 		sample_to_timespec(timer->it_clock,
-				   timer->it.cpu.incr, &old->it_interval);
+				   old_incr, &old->it_interval);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
cpu-timers-optimize-run_posix_cpu_timers.patch
posix-cpu-timers-avoid-task-signal-=-null-checks.patch
ia64-ptrace_attach_sync_user_rbs-avoid-task-signal-=-null-checks.patch
exit-__exit_signal-use-thread_group_leader-consistently.patch
kill-the-obsolete-thread_group_cputime_free-and-taskstats_tgid_init-helpers.patch
exit-move-taskstats_tgid_free-from-__exit_signal-to-free_signal_struct.patch
check_unshare_flags-kill-the-bogus-clone_sighand-sig-count-check.patch

