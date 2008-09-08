From: akpm@linux-foundation.org
Subject: - sched_clock-fix-nohz-interaction.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:27 -0700
Message-ID: <200809081907.m88J7RYh005555@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753779AbYIHTIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, avi@qumranet.com, mingo@elte.hu, parag.lkml@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sched_clock: fix NOHZ interaction
has been removed from the -mm tree.  Its filename was
     sched_clock-fix-nohz-interaction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
lockstat-documentation-update.patch
percpu-counters-clean-up-percpu_counter_sum_and_set-interface.patch
irq-warn-about-irqf_disabledirqf_shared.patch

