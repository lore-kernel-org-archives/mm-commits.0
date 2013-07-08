From: akpm@linux-foundation.org
Subject: [merged]
 posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch removed from
 -mm tree
Date: Mon, 08 Jul 2013 12:37:48 -0700
Message-ID: <51db150c.Lr4zy/LYSMMenBVK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3GHTht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, sgruszka@redhat.com, oleg@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl, fweisbec@gmail.com

Subject: [merged] posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch removed from -mm tree
To: fweisbec@gmail.com,a.p.zijlstra@chello.nl,mingo@elte.hu,oleg@redhat.com,sgruszka@redhat.com,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:37:48 -0700


The patch titled
     Subject: posix_timers: fix racy timer delta caching on task exit
has been removed from the -mm tree.  Its filename was
     posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_timers: fix racy timer delta caching on task exit

When a task exits, we perform a caching of the remaining cputime delta
before expiring of its timers.

This is done from the following places:

* When the task is reaped. We iterate through its list of
  posix cpu timers and store the remaining timer delta to
  the timer struct instead of the absolute value.
  (See posix_cpu_timers_exit() / posix_cpu_timers_exit_group() )

* When we call posix_cpu_timer_get() or posix_cpu_timer_schedule().
  If the timer's task is considered dying when watched from these
  places, the same conversion from absolute to relative expiry time
  is performed. Then the given task's reference is released.
  (See clear_dead_task() ).

The relevance of this caching is questionable but this is another
and deeper debate.

The big issue here is that these two sources of caching don't mix
up very well together.

More specifically, the caching can easily be done twice, resulting
in a wrong delta as it gets spuriously substracted a second time by
the elapsed clock. This can happen in the following scenario:

1) The task exits and gets reaped: we call posix_cpu_timers_exit()
   and the absolute timer expiry values are converted to a relative
   delta.

2) timer_gettime() -> posix_cpu_timer_get() is called and relies on
   clear_dead_task() because  tsk->exit_state == EXIT_DEAD.
   The delta gets substracted again by the elapsed clock and we return
   a wrong result.

To fix this, just remove the caching done on task reaping time.  It
doesn't bring much value on its own.  The caching done from
posix_cpu_timer_get/schedule is enough.

And it would also be hard to get it really right: we could make it put and
clear the target task in the timer struct so that readers know if they are
dealing with a relative cached of absolute value.  But it would be racy.
The only safe way to do it would be to lock the itimer->it_lock so that we
know nobody reads the cputime expiry value while we modify it and its
target task reference.  Doing so would involve some funny workarounds to
avoid circular lock against the sighand lock.  There is just no reason to
maintain this.

The user visible effect of this patch can be observed by running the
following code: it creates a subthread that launches a posix cputimer
which expires after 10 seconds. But then the subthread only busy loops for 2
seconds and exits. The parent reaps the subthread and read the timer value.
Its expected value should the be the initial timer's expiration value
minus the cputime elapsed in the subthread. Roughly 10 - 2 = 8 seconds:

	#include <sys/time.h>
	#include <stdio.h>
	#include <unistd.h>
	#include <time.h>
	#include <pthread.h>

	static timer_t id;
	static struct itimerspec val = { .it_value.tv_sec = 10, }, new;

	static void *thread(void *unused)
	{
		int err;
		struct timeval start, end, diff;

		timer_create(CLOCK_THREAD_CPUTIME_ID, NULL, &id);
		if (err < 0) {
			perror("Can't create timer\n");
			return NULL;
		}

		/* Arm 10 sec timer */
		err = timer_settime(id, 0, &val, NULL);
		if (err < 0) {
			perror("Can't set timer\n");
			return NULL;
		}

		/* Exit after 2 seconds of execution */
		gettimeofday(&start, NULL);
	        do {
			gettimeofday(&end, NULL);
			timersub(&end, &start, &diff);
		} while (diff.tv_sec < 2);

		return NULL;
	}

	int main(int argc, char **argv)
	{
		pthread_t pthread;
		int err;

		err = pthread_create(&pthread, NULL, thread, NULL);
		if (err) {
			perror("Can't create thread\n");
			return -1;
		}
		pthread_join(pthread, NULL);
		/* Just wait a little bit to make sure the child got reaped */
		sleep(1);
		err = timer_gettime(id, &new);
		if (err)
			perror("Can't get timer value\n");
		printf("%d %ld\n", new.it_value.tv_sec, new.it_value.tv_nsec);

		return 0;
	}

Before the patch:

       $ ./posix_cpu_timers
       6 2278074

After the patch:

      $ ./posix_cpu_timers
      8 1158766

Before the patch, the elapsed time got two more seconds spuriously accounted.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix_timers-fix-racy-timer-delta-caching-on-task-exit kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix_timers-fix-racy-timer-delta-caching-on-task-exit
+++ a/kernel/posix-cpu-timers.c
@@ -404,14 +404,8 @@ static void cleanup_timers_list(struct l
 {
 	struct cpu_timer_list *timer, *next;
 
-	list_for_each_entry_safe(timer, next, head, entry) {
+	list_for_each_entry_safe(timer, next, head, entry)
 		list_del_init(&timer->entry);
-		if (timer->expires < curr) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= curr;
-		}
-	}
 }
 
 /*
@@ -459,15 +453,21 @@ void posix_cpu_timers_exit_group(struct
 		       tsk->se.sum_exec_runtime + sig->sum_sched_runtime);
 }
 
-static void clear_dead_task(struct k_itimer *timer, unsigned long long now)
+static void clear_dead_task(struct k_itimer *itimer, unsigned long long now)
 {
+	struct cpu_timer_list *timer = &itimer->it.cpu;
+
 	/*
 	 * That's all for this thread or process.
 	 * We leave our residual in expires to be reported.
 	 */
-	put_task_struct(timer->it.cpu.task);
-	timer->it.cpu.task = NULL;
-	timer->it.cpu.expires -= now;
+	put_task_struct(timer->task);
+	timer->task = NULL;
+	if (timer->expires < now) {
+		timer->expires = 0;
+	} else {
+		timer->expires -= now;
+	}
 }
 
 static inline int expires_gt(cputime_t expires, cputime_t new_exp)
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

