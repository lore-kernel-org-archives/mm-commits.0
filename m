From: akpm@linux-foundation.org
Subject: [merged] posix-cpu-timers-fix-nanosleep-task_struct-leak.patch removed from -mm tree
Date: Tue, 19 Feb 2013 13:03:33 -0800
Message-ID: <20130219210335.DC5C731C19C__45953.3653957353$1361307845$gmane$org@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:55482 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab3BSVDk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Feb 2013 16:03:40 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so712672yhr.0
        for <mm-commits@vger.kernel.org>; Tue, 19 Feb 2013 13:03:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sgruszka@redhat.com, davej@redhat.com, john.stultz@linaro.org, mingo@elte.hu, oleg@redhat.com, stable@vger.kernel.org, tglx@linutronix.de, tt.rantala@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: posix-cpu-timers: fix nanosleep task_struct leak
has been removed from the -mm tree.  Its filename was
     posix-cpu-timers-fix-nanosleep-task_struct-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

