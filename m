From: akpm@linux-foundation.org
Subject: [merged] cpu-timers-change-sigev_none-timer-implementation.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:27 -0400
Message-ID: <201004151840.o3FIe5hL024362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754382Ab0DOSrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, mingo@elte.hu, oleg@redhat.com, seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     cpu-timers: change SIGEV_NONE timer implementation
has been removed from the -mm tree.  Its filename was
     cpu-timers-change-sigev_none-timer-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu-timers: change SIGEV_NONE timer implementation
From: Stanislaw Gruszka <sgruszka@redhat.com>

When user will setup timer without associated signal and process does not
use any other cpu timers and does not exit, tsk->signal->cputimer is
enabled and running forever, change that.

I used below program to check patch does not break current user space
visible behavior.

 #include <sys/time.h>
 #include <signal.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
 #include <assert.h>

 void consume_cpu(void)
 {
	int i = 0;
	int count = 0;

	for(i=0; i<100000000; i++)
		count++;
 }

 int main(void)
 {
	int i;
	struct sigaction act;
	struct sigevent evt = { };
	timer_t tid;
	struct itimerspec spec = { };

	evt.sigev_notify = SIGEV_NONE;
	assert(timer_create(CLOCK_PROCESS_CPUTIME_ID, &evt,  &tid) == 0);

	spec.it_value.tv_sec = 10;
	assert(timer_settime(tid, 0, &spec,  NULL) == 0);

	for (i = 0; i < 30; i++) {
		consume_cpu();
		memset(&spec, 0, sizeof(spec));
		assert(timer_gettime(tid, &spec) == 0);
		printf("%lu.%09lu\n",
			(unsigned long) spec.it_value.tv_sec,
			(unsigned long) spec.it_value.tv_nsec);
	}

	assert(timer_delete(tid) == 0);
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

 kernel/posix-cpu-timers.c |   28 ++++++----------------------
 1 file changed, 6 insertions(+), 22 deletions(-)

diff -puN kernel/posix-cpu-timers.c~cpu-timers-change-sigev_none-timer-implementation kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~cpu-timers-change-sigev_none-timer-implementation
+++ a/kernel/posix-cpu-timers.c
@@ -614,7 +614,12 @@ static void arm_timer(struct k_itimer *t
  */
 static void cpu_timer_fire(struct k_itimer *timer)
 {
-	if (unlikely(timer->sigq == NULL)) {
+	if ((timer->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE) {
+		/*
+		 * User don't want any signal.
+		 */
+		timer->it.cpu.expires.sched = 0;
+	} else if (unlikely(timer->sigq == NULL)) {
 		/*
 		 * This a special case for clock_nanosleep,
 		 * not a normal timer from sys_timer_create.
@@ -783,7 +788,6 @@ int posix_cpu_timer_set(struct k_itimer 
 	 */
 	timer->it.cpu.expires = new_expires;
 	if (new_expires.sched != 0 &&
-	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    cpu_time_before(timer->it_clock, val, new_expires)) {
 		arm_timer(timer);
 	}
@@ -808,7 +812,6 @@ int posix_cpu_timer_set(struct k_itimer 
 	timer->it_overrun = -1;
 
 	if (new_expires.sched != 0 &&
-	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    !cpu_time_before(timer->it_clock, val, new_expires)) {
 		/*
 		 * The designated time already passed, so we notify
@@ -882,25 +885,6 @@ void posix_cpu_timer_get(struct k_itimer
 		read_unlock(&tasklist_lock);
 	}
 
-	if ((timer->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE) {
-		if (timer->it.cpu.incr.sched == 0 &&
-		    cpu_time_before(timer->it_clock,
-				    timer->it.cpu.expires, now)) {
-			/*
-			 * Do-nothing timer expired and has no reload,
-			 * so it's as if it was never set.
-			 */
-			timer->it.cpu.expires.sched = 0;
-			itp->it_value.tv_sec = itp->it_value.tv_nsec = 0;
-			return;
-		}
-		/*
-		 * Account for any expirations and reloads that should
-		 * have happened.
-		 */
-		bump_cpu_timer(timer, now);
-	}
