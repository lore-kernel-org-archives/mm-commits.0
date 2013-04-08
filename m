From: akpm@linux-foundation.org
Subject: + posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch added to -mm tree
Date: Mon, 08 Apr 2013 16:54:15 -0700
Message-ID: <20130408235416.105BA31C300@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:40838 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764732Ab3DHXyR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 19:54:17 -0400
Received: by mail-ob0-f201.google.com with SMTP id uz6so1623635obc.2
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 16:54:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, sgruszka@redhat.com, tglx@linutronix.de


The patch titled
     Subject: posix_timers: Fix racy timer delta caching on task exit
has been added to the -mm tree.  Its filename is
     posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_timers: Fix racy timer delta caching on task exit

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

The task exits and gets reaped: we call posix_cpu_timers_exit()
and the absolute timer expiry values are converted to a relative
delta.

timer_gettime() -> posix_cpu_timer_get() is called and relies on
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
@@ -387,14 +387,8 @@ static void cleanup_timers_list(struct l
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
@@ -442,15 +436,21 @@ void posix_cpu_timers_exit_group(struct
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

linux-next.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
selftests-add-basic-posix-timers-selftests.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
posix_timers-fix-racy-timer-delta-caching-on-task-exit.patch
posix_timers-remove-dead-task-timer-expiry-caching.patch
mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
printk-tracing-rework-console-tracing.patch

