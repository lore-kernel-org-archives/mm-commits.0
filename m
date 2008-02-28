From: akpm@linux-foundation.org
Subject: + time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch added to -mm tree
Date: Thu, 28 Feb 2008 11:30:45 -0800
Message-ID: <200802281930.m1SJUl99016316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:39111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758635AbYB1TcE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 14:32:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fzu@wemgehoertderstaat.de, mingo@elte.hu, paulmck@us.ibm.com, rjw@sisk.pl, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     time: don't touch an offlined CPU's ts->tick_stopped in tick_cancel_sched_timer()
has been added to the -mm tree.  Its filename is
     time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -635,7 +635,7 @@ void tick_cancel_sched_timer(int cpu)
 
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
-	ts->tick_stopped = 0;
+
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
 #endif /* HIGH_RES_TIMERS */
_

Patches currently in -mm which might be from fzu@wemgehoertderstaat.de are

time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch

