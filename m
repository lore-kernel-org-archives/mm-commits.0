From: akpm@linux-foundation.org
Subject: - optimise-tick_nohz_stop_sched_tick-a-bit.patch removed from -mm tree
Date: Fri, 29 Feb 2008 16:46:16 -0800
Message-ID: <200803010046.m210kGWF029030@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55978 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762054AbYCAAqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Feb 2008 19:46:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fzu@wemgehoertderstaat.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: optimise tick_nohz_stop_sched_tick() a bit
has been removed from the -mm tree.  Its filename was
     optimise-tick_nohz_stop_sched_tick-a-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-hrt.patch
time-dont-touch-an-offlined-cpus-ts-tick_stopped-in-tick_cancel_sched_timer.patch

