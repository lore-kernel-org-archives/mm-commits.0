From: akpm@linux-foundation.org
Subject: + posix-cpu-timers-fix-nanosleep-task_struct-leak.patch added to -mm tree
Date: Fri, 15 Feb 2013 15:07:40 -0800
Message-ID: <20130215230740.B04635A42F8__44639.2125603326$1360969689$gmane$org@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:46528 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3BOXHm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Feb 2013 18:07:42 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so404102vch.4
        for <mm-commits@vger.kernel.org>; Fri, 15 Feb 2013 15:07:41 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, davej@redhat.com, john.stultz@linaro.org, mingo@elte.hu, oleg@redhat.com, stable@vger.kernel.org, tglx@linutronix.de, tt.rantala@gmail.com


The patch titled
     Subject: posix-cpu-timers: fix nanosleep task_struct leak
has been added to the -mm tree.  Its filename is
     posix-cpu-timers-fix-nanosleep-task_struct-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: posix-cpu-timers: fix nanosleep task_struct leak

In do_cpu_nanosleep() we do posic_cpu_timer_create(), but forgot
corresponding posix_cpu_timer_del() what lead to task_struct leak.

This looks like a DoS problem fix, since it's possible to eat kernel
memory (very slowly though) by normal user, hence Cc stable.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Tested-by: Tommi Rantala <tt.rantala@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix-cpu-timers-fix-nanosleep-task_struct-leak kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix-cpu-timers-fix-nanosleep-task_struct-leak
+++ a/kernel/posix-cpu-timers.c
@@ -1417,8 +1417,10 @@ static int do_cpu_nanosleep(const clocki
 		while (!signal_pending(current)) {
 			if (timer.it.cpu.expires.sched == 0) {
 				/*
-				 * Our timer fired and was reset.
+				 * Our timer fired and was reset, below
+				 * deletion can not fail.
 				 */
+				posix_cpu_timer_del(&timer);
 				spin_unlock_irq(&timer.it_lock);
 				return 0;
 			}
@@ -1436,9 +1438,26 @@ static int do_cpu_nanosleep(const clocki
 		 * We were interrupted by a signal.
 		 */
 		sample_to_timespec(which_clock, timer.it.cpu.expires, rqtp);
-		posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		error = posix_cpu_timer_set(&timer, 0, &zero_it, it);
+		if (!error) {
+			/*
+			 * Timer is now unarmed, deletion can not fail.
+			 */
+			posix_cpu_timer_del(&timer);
+		}
 		spin_unlock_irq(&timer.it_lock);
 
+		while (error == TIMER_RETRY) {
+			/*
+			 * We need to handle case when timer was or is in the
+			 * middle of firing. In other cases we already freed
+			 * resources.
+			 */
+			spin_lock_irq(&timer.it_lock);
+			error = posix_cpu_timer_del(&timer);
+			spin_unlock_irq(&timer.it_lock);
+		}
+
 		if ((it->it_value.tv_sec | it->it_value.tv_nsec) == 0) {
 			/*
 			 * It actually did fire already.
_

Patches currently in -mm which might be from sgruszka@redhat.com are

linux-next.patch
posix-cpu-timers-fix-nanosleep-task_struct-leak.patch

