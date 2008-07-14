From: akpm@linux-foundation.org
Subject: - sched_clock-record-from-last-tick.patch removed from -mm tree
Date: Mon, 14 Jul 2008 12:35:56 -0700
Message-ID: <200807141935.m6EJZusY023977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39533 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482AbYGNTgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, peterz@infradead.org, srostedt@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     sched_clock: record from last tick
has been removed from the -mm tree.  Its filename was
     sched_clock-record-from-last-tick.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched_clock: record from last tick
From: Steven Rostedt <rostedt@goodmis.org>

The sched_clock code tries to keep within the gtod time by one tick
(jiffy).  The current code mistakenly keeps track of the delta jiffies
between updates of the clock, where the the delta is used to compare with
the number of jiffies that have past since an update of the gtod.  The
gtod is updated at each schedule tick not each sched_clock update.  After
one jiffy passes the clock is updated fine.  But the delta is taken from
the last update so if the next update happens before the next tick the
delta jiffies used will be incorrect.

This patch changes the code to check the delta of jiffies between ticks
and not updates to match the comparison of the updates with the gtod.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched_clock.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/sched_clock.c~sched_clock-record-from-last-tick kernel/sched_clock.c
--- a/kernel/sched_clock.c~sched_clock-record-from-last-tick
+++ a/kernel/sched_clock.c
@@ -40,7 +40,7 @@ struct sched_clock_data {
 	 */
 	raw_spinlock_t		lock;
 
-	unsigned long		prev_jiffies;
+	unsigned long		tick_jiffies;
 	u64			prev_raw;
 	u64			tick_raw;
 	u64			tick_gtod;
@@ -71,7 +71,7 @@ void sched_clock_init(void)
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
 		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
-		scd->prev_jiffies = now_jiffies;
+		scd->tick_jiffies = now_jiffies;
 		scd->prev_raw = 0;
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
@@ -90,7 +90,7 @@ void sched_clock_init(void)
 static void __update_sched_clock(struct sched_clock_data *scd, u64 now)
 {
 	unsigned long now_jiffies = jiffies;
-	long delta_jiffies = now_jiffies - scd->prev_jiffies;
+	long delta_jiffies = now_jiffies - scd->tick_jiffies;
 	u64 clock = scd->clock;
 	u64 min_clock, max_clock;
 	s64 delta = now - scd->prev_raw;
@@ -119,7 +119,6 @@ static void __update_sched_clock(struct 
 		clock = min_clock;
 
 	scd->prev_raw = now;
-	scd->prev_jiffies = now_jiffies;
 	scd->clock = clock;
 }
 
@@ -179,6 +178,7 @@ u64 sched_clock_cpu(int cpu)
 void sched_clock_tick(void)
 {
 	struct sched_clock_data *scd = this_scd();
+	unsigned long now_jiffies = jiffies;
 	u64 now, now_gtod;
 
 	if (unlikely(!sched_clock_running))
@@ -196,6 +196,7 @@ void sched_clock_tick(void)
 	 * already observe 1 new jiffy; adding a new tick_gtod to that would
 	 * increase the clock 2 jiffies.
 	 */
+	scd->tick_jiffies = now_jiffies;
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
 	__raw_spin_unlock(&scd->lock);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch
split-the-typecheck-macros-out-of-include-linux-kernelh.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags.patch
locking-add-typecheck-on-irqsave-and-friends-for-correct-flags-fix.patch

