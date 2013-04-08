From: akpm@linux-foundation.org
Subject: + posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch added to -mm tree
Date: Mon, 08 Apr 2013 16:54:12 -0700
Message-ID: <20130408235413.022C85A432B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:46819 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760913Ab3DHXyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Apr 2013 19:54:14 -0400
Received: by mail-ie0-f202.google.com with SMTP id qd14so1623061ieb.3
        for <mm-commits@vger.kernel.org>; Mon, 08 Apr 2013 16:54:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org, gang.chen@asianux.com, mingo@elte.hu, oleg@redhat.com, sgruszka@redhat.com, tglx@linutronix.de


The patch titled
     Subject: posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()
has been added to the -mm tree.  Its filename is
     posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch

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
Subject: posix-timers: correctly get dying task time sample in posix_cpu_timer_schedule()

In order to arm the next timer to schedule, we take a sample of the
current process or thread cputime.

If the task is dying though, we don't arm anything but we cache the
remaining timer expiration delta for further reads.

Something similar is performed in posix_cpu_timer_get() but here we forget
to take the process wide cputime sample before caching it.

As a result we are storing random stack content, leading every further
reads of that timer to return junk values.

Fix this by taking the appropriate sample in the case of process wide
timers.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/posix-cpu-timers.c~posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule
+++ a/kernel/posix-cpu-timers.c
@@ -1062,6 +1062,7 @@ void posix_cpu_timer_schedule(struct k_i
 			 * not yet reaped.  Take this opportunity to
 			 * drop our task ref.
 			 */
+			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
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

