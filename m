From: akpm@linux-foundation.org
Subject: [merged] sched-update-the-idle-statistics-in-get_cpu_idle_time_us.patch removed from -mm tree
Date: Tue, 11 May 2010 12:16:47 -0400
Message-ID: <201005111918.o4BJIFR4018189@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab0EKTSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: update the idle statistics in get_cpu_idle_time_us()
has been removed from the -mm tree.  Its filename was
     sched-update-the-idle-statistics-in-get_cpu_idle_time_us.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: update the idle statistics in get_cpu_idle_time_us()
From: Arjan van de Ven <arjan@linux.intel.com>

Right now, get_cpu_idle_time_us() only reports the idle statistics
upto the point the CPU entered last idle; not what is valid right now.

This patch adds an update of the idle statistics to get_cpu_idle_time_us(),
so that calling this function always returns statistics that are accurate
at the point of the call.

This includes resetting the start of the idle time for accounting purposes
to avoid double accounting.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~sched-update-the-idle-statistics-in-get_cpu_idle_time_us kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-update-the-idle-statistics-in-get_cpu_idle_time_us
+++ a/kernel/time/tick-sched.c
@@ -161,6 +161,7 @@ static void update_ts_time_stats(struct 
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
+		ts->idle_entrytime = now;
 	}
 }
 
@@ -205,14 +206,18 @@ static ktime_t tick_nohz_start_idle(stru
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+	ktime_t now;
 
 	if (!tick_nohz_enabled)
 		return -1;
 
+	now = ktime_get();
+	update_ts_time_stats(ts, now);
+
 	if (ts->idle_active)
 		*last_update_time = ktime_to_us(ts->idle_lastupdate);
 	else
-		*last_update_time = ktime_to_us(ktime_get());
+		*last_update_time = ktime_to_us(now);
 
 	return ktime_to_us(ts->idle_sleeptime);
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor.patch

