From: akpm@linux-foundation.org
Subject: + optimise-tick_nohz_stop_sched_tick-a-bit.patch added to -mm tree
Date: Thu, 28 Feb 2008 17:16:39 -0800
Message-ID: <200802290116.m1T1GdbC030871@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55657 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbYB2BRT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 20:17:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fzu@wemgehoertderstaat.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     time: optimise tick_nohz_stop_sched_tick() a bit
has been added to the -mm tree.  Its filename is
     optimise-tick_nohz_stop_sched_tick-a-bit.patch

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
Subject: time: optimise tick_nohz_stop_sched_tick() a bit
From: Karsten Wiese <fzu@wemgehoertderstaat.de>

Call
	ts = &per_cpu(tick_cpu_sched, cpu);
and
	cpu = smp_processor_id();
once instead of twice.

No functional change done, as changed code runs with local irq off.  Reduces
source lines and text size (20bytes on x86_64).

Signed-off-by: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/time/tick-sched.c~optimise-tick_nohz_stop_sched_tick-a-bit kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~optimise-tick_nohz_stop_sched_tick-a-bit
+++ a/kernel/time/tick-sched.c
@@ -158,9 +158,8 @@ void tick_nohz_stop_idle(int cpu)
 	}
 }
 
-static ktime_t tick_nohz_start_idle(int cpu)
+static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, delta;
 
 	now = ktime_get();
@@ -200,8 +199,8 @@ void tick_nohz_stop_sched_tick(void)
 	local_irq_save(flags);
 
 	cpu = smp_processor_id();
-	now = tick_nohz_start_idle(cpu);
 	ts = &per_cpu(tick_cpu_sched, cpu);
+	now = tick_nohz_start_idle(cpu, ts);
 
 	/*
 	 * If this cpu is offline and it is the one which updates
@@ -221,7 +220,6 @@ void tick_nohz_stop_sched_tick(void)
 	if (need_resched())
 		goto end;
 
-	cpu = smp_processor_id();
 	if (unlikely(local_softirq_pending())) {
 		static int ratelimit;
 
_

Patches currently in -mm which might be from fzu@wemgehoertderstaat.de are

time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch
optimise-tick_nohz_stop_sched_tick-a-bit.patch
optimise-tick_nohz_stop_sched_tick-a-bit-fix.patch

