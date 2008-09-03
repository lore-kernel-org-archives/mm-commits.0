From: akpm@linux-foundation.org
Subject: + sched_clock-fix-nohz-interaction.patch added to -mm tree
Date: Tue, 02 Sep 2008 22:59:57 -0700
Message-ID: <200809030559.m835xvQk032321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752558AbYICGAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 02:00:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, avi@qumranet.com, mingo@elte.hu, parag.lkml@gmail.com, tglx@linutronix.de


The patch titled
     sched_clock: fix NOHZ interaction
has been added to the -mm tree.  Its filename is
     sched_clock-fix-nohz-interaction.patch

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
Subject: sched_clock: fix NOHZ interaction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

If HLT stops the TSC, we'll fail to account idle time, thereby inflating
the actual process times.  Fix this by re-calibrating the clock against
GTOD when leaving nohz mode.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Tested-by: Avi Kivity <avi@qumranet.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "Parag Warudkar" <parag.lkml@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN kernel/time/tick-sched.c~sched_clock-fix-nohz-interaction kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched_clock-fix-nohz-interaction
+++ a/kernel/time/tick-sched.c
@@ -163,6 +163,8 @@ void tick_nohz_stop_idle(int cpu)
 		ts->idle_lastupdate = now;
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_active = 0;
+
+		sched_clock_idle_wakeup_event(0);
 	}
 }
 
@@ -178,6 +180,7 @@ static ktime_t tick_nohz_start_idle(stru
 	}
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
+	sched_clock_idle_sleep_event();
 	return now;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
sched_clock-fix-nohz-interaction.patch
percpu-counters-clean-up-percpu_counter_sum_and_set-interface.patch
irq-warn-about-irqf_disabledirqf_shared.patch

