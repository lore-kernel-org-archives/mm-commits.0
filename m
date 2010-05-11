From: akpm@linux-foundation.org
Subject: [merged] sched-introduce-a-function-to-update-the-idle-statistics.patch removed from -mm tree
Date: Tue, 11 May 2010 12:16:45 -0400
Message-ID: <201005111918.o4BJIDXb018186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab0EKTSQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: introduce a function to update the idle statistics
has been removed from the -mm tree.  Its filename was
     sched-introduce-a-function-to-update-the-idle-statistics.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: introduce a function to update the idle statistics
From: Arjan van de Ven <arjan@linux.intel.com>

Currently, two places update the idle statistics (and more to
come later in this series).

This patch creates a helper function for updating these statistics.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff -puN kernel/time/tick-sched.c~sched-introduce-a-function-to-update-the-idle-statistics kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-introduce-a-function-to-update-the-idle-statistics
+++ a/kernel/time/tick-sched.c
@@ -150,14 +150,25 @@ static void tick_nohz_update_jiffies(kti
 	touch_softlockup_watchdog();
 }
 
-static void tick_nohz_stop_idle(int cpu, ktime_t now)
+/*
+ * Updates the per cpu time idle statistics counters
+ */
+static void update_ts_time_stats(struct tick_sched *ts, ktime_t now)
 {
-	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t delta;
 
-	delta = ktime_sub(now, ts->idle_entrytime);
 	ts->idle_lastupdate = now;
-	ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	if (ts->idle_active) {
+		delta = ktime_sub(now, ts->idle_entrytime);
+		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+	}
+}
+
+static void tick_nohz_stop_idle(int cpu, ktime_t now)
+{
+	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+
+	update_ts_time_stats(ts, now);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -165,14 +176,12 @@ static void tick_nohz_stop_idle(int cpu,
 
 static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
 {
-	ktime_t now, delta;
+	ktime_t now;
 
 	now = ktime_get();
-	if (ts->idle_active) {
-		delta = ktime_sub(now, ts->idle_entrytime);
-		ts->idle_lastupdate = now;
-		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
-	}
+
+	update_ts_time_stats(ts, now);
+
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
 	sched_clock_idle_sleep_event();
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor.patch

