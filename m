From: akpm@linux-foundation.org
Subject: + sched-introduce-a-function-to-update-the-idle-statistics.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:35:36 -0700
Message-ID: <201004192235.o3JMZag2013689@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab0DSWfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     sched: introduce a function to update the idle statistics
has been added to the -mm tree.  Its filename is
     sched-introduce-a-function-to-update-the-idle-statistics.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
sched-add-a-comment-to-get_cpu_idle_time_us.patch
sched-introduce-a-function-to-update-the-idle-statistics.patch
sched-update-the-idle-statistics-in-get_cpu_idle_time_us.patch
sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats.patch
sched-eliminate-the-ts-idle_lastupdate-field.patch
sched-introduce-get_cpu_iowait_time_us.patch
ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io.patch

