From: akpm@linux-foundation.org
Subject: - time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch removed from -mm tree
Date: Mon, 10 Mar 2008 11:05:44 -0700
Message-ID: <200803101805.m2AI5i5v030127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400AbYCJSHS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 14:07:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fzu@wemgehoertderstaat.de, mingo@elte.hu, paulmck@us.ibm.com, rjw@sisk.pl, rostedt@goodmis.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: don't touch an offlined CPU's ts->tick_stopped in tick_cancel_sched_timer()
has been removed from the -mm tree.  Its filename was
     time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: don't touch an offlined CPU's ts->tick_stopped in tick_cancel_sched_timer()
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

Silences WARN_ONs in rcu_enter_nohz() and rcu_exit_nohz(), which appeared
before caused by (repeated) calls to:
        $ echo 0 > /sys/devices/system/cpu/cpu1/online
        $ echo 1 > /sys/devices/system/cpu/cpu1/online

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rafael Wysocki <rjw@sisk.pl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer
+++ a/kernel/time/tick-sched.c
@@ -633,7 +633,7 @@ void tick_cancel_sched_timer(int cpu)
 
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
-	ts->tick_stopped = 0;
+
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
 #endif /* HIGH_RES_TIMERS */
_

Patches currently in -mm which might be from fzu@wemgehoertderstaat.de are

git-hrt.patch

