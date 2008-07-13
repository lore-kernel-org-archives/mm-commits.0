From: akpm@linux-foundation.org
Subject: + sched_clock-fix-calculation-of-other-cpu.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:00:21 -0700
Message-ID: <200807130600.m6D60LbC007029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbYGMGCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, johnstul@us.ibm.com, mingo@elte.hu, peterz@infradead.org, srostedt@redhat.com, tglx@linutronix.de


The patch titled
     sched_clock: fix calculation of other CPU
has been added to the -mm tree.  Its filename is
     sched_clock-fix-calculation-of-other-cpu.patch

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
Subject: sched_clock: fix calculation of other CPU
From: Steven Rostedt <rostedt@goodmis.org>

The algorithm to calculate the 'now' of another CPU is not correct.  At
each scheduler tick, each CPU records the last sched_clock and gtod
(tick_raw and tick_gtod respectively).  If the TSC is somewhat the same in
speed between two clocks the algorithm would be:

  tick_gtod1 + (now1 - tick_raw1) = tick_gtod2 + (now2 - tick_raw2)

To calculate now2 we would have:

  now2 = (tick_gtod1 - tick_gtod2) + (tick_raw2 - tick_raw1) + now1

Currently the algorithm is:

  now2 = (tick_gtod1 - tick_gtod2) + (tick_raw1 - tick_raw2) + now1

This solves most of the rest of the issues I've had with timestamps in
ftace.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_clock.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sched_clock.c~sched_clock-fix-calculation-of-other-cpu kernel/sched_clock.c
--- a/kernel/sched_clock.c~sched_clock-fix-calculation-of-other-cpu
+++ a/kernel/sched_clock.c
@@ -160,8 +160,8 @@ u64 sched_clock_cpu(int cpu)
 		now -= my_scd->tick_raw;
 		now += scd->tick_raw;
 
-		now -= my_scd->tick_gtod;
-		now += scd->tick_gtod;
+		now += my_scd->tick_gtod;
+		now -= scd->tick_gtod;
 
 		__raw_spin_unlock(&my_scd->lock);
 	} else {
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
linux-next.patch
sched_clock-fix-calculation-of-other-cpu.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch

