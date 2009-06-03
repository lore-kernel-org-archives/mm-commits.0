From: akpm@linux-foundation.org
Subject: [merged] time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load.patch removed from -mm tree
Date: Wed, 03 Jun 2009 13:02:00 -0700
Message-ID: <200906032002.n53K20sR001331@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754375AbZFCUCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 16:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arve@android.com, a.p.zijlstra@chello.nl, mingo@elte.hu, rmk@arm.linux.org.uk, swetland@google.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: nohz: fix ondemand governor not always ramping up on 100% load.
has been removed from the -mm tree.  Its filename was
     time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: nohz: fix ondemand governor not always ramping up on 100% load.
From: Arve Hjonnevag <arve@android.com>

On systems that perform the context switch with interrupts enabled (e.g. 
ARM) get_cpu_idle_time_us could get stuck returning the last idle time
when the cpu is busy.  If an interrupt occurs while switching to the idle
thread, and this interrupt wakes up a thread, need-resched will be set on
the idle thread, but since we have not finished switching to the idle
thread tick_nohz_stop_sched_tick will be called.  (idle_cpu is true since
the head of the runqueue is the idle thread, but need_resched returns
false since we are still running in the context of the old thread)

Fix this by not calling tick_nohz_start_idle when returning from an
interrupt while the idle thread is in its schedule phase.  (!ts->inidle)

Signed-off-by: Arve Hjonnevag <arve@android.com>
Cc: Brian Sewtland <swetland@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-nohz-fix-ondemand-governor-not-always-ramping-up-on-100%-load
+++ a/kernel/time/tick-sched.c
@@ -224,7 +224,6 @@ void tick_nohz_stop_sched_tick(int inidl
 
 	cpu = smp_processor_id();
 	ts = &per_cpu(tick_cpu_sched, cpu);
-	now = tick_nohz_start_idle(ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
@@ -244,6 +243,7 @@ void tick_nohz_stop_sched_tick(int inidl
 	if (!inidle && !ts->inidle)
 		goto end;
 
+	now = tick_nohz_start_idle(ts);
 	ts->inidle = 1;
 
 	if (need_resched())
_

Patches currently in -mm which might be from arve@android.com are

linux-next.patch

