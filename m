From: akpm@linux-foundation.org
Subject: + cpu-timers-return-correct-previous-timer-reload-value.patch added to -mm tree
Date: Tue, 26 Jan 2010 13:39:30 -0800
Message-ID: <201001262139.o0QLdULN021899@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932150Ab0AZVkQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jan 2010 16:40:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, mingo@elte.hu, oleg@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de


The patch titled
     cpu-timers: return correct previous timer reload value
has been added to the -mm tree.  Its filename is
     cpu-timers-return-correct-previous-timer-reload-value.patch

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

posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch

