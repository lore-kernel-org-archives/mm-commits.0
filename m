From: akpm@linux-foundation.org
Subject: [merged] sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats.patch removed from -mm tree
Date: Tue, 11 May 2010 12:16:50 -0400
Message-ID: <201005111918.o4BJIIU1018192@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab0EKTSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: fold updating of the last update time into update_ts_time_stats()
has been removed from the -mm tree.  Its filename was
     sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: fold updating of the last update time into update_ts_time_stats()
From: Arjan van de Ven <arjan@linux.intel.com>

This patch folds the updating of the last_update_time into the
update_ts_time_stats() function, and updates the callers.

This allows for further cleanups that are done in the next patch.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN kernel/time/tick-sched.c~sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats
+++ a/kernel/time/tick-sched.c
@@ -153,7 +153,8 @@ static void tick_nohz_update_jiffies(kti
 /*
  * Updates the per cpu time idle statistics counters
  */
-static void update_ts_time_stats(struct tick_sched *ts, ktime_t now)
+static void
+update_ts_time_stats(struct tick_sched *ts, ktime_t now, u64 *last_update_time)
 {
 	ktime_t delta;
 
@@ -163,13 +164,19 @@ static void update_ts_time_stats(struct 
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
+
+	if (ts->idle_active && last_update_time)
+		*last_update_time = ktime_to_us(ts->idle_lastupdate);
+	else
+		*last_update_time = ktime_to_us(now);
+
 }
 
 static void tick_nohz_stop_idle(int cpu, ktime_t now)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 
-	update_ts_time_stats(ts, now);
+	update_ts_time_stats(ts, now, NULL);
 	ts->idle_active = 0;
 
 	sched_clock_idle_wakeup_event(0);
@@ -181,7 +188,7 @@ static ktime_t tick_nohz_start_idle(stru
 
 	now = ktime_get();
 
-	update_ts_time_stats(ts, now);
+	update_ts_time_stats(ts, now, NULL);
 
 	ts->idle_entrytime = now;
 	ts->idle_active = 1;
@@ -206,18 +213,11 @@ static ktime_t tick_nohz_start_idle(stru
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
-	ktime_t now;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
-	now = ktime_get();
-	update_ts_time_stats(ts, now);
