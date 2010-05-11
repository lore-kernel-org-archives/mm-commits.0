From: akpm@linux-foundation.org
Subject: [merged] sched-eliminate-the-ts-idle_lastupdate-field.patch removed from -mm tree
Date: Tue, 11 May 2010 12:16:52 -0400
Message-ID: <201005111918.o4BJIK8r018197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab0EKTSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: eliminate the ts->idle_lastupdate field
has been removed from the -mm tree.  Its filename was
     sched-eliminate-the-ts-idle_lastupdate-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sched: eliminate the ts->idle_lastupdate field
From: Arjan van de Ven <arjan@linux.intel.com>

Now that the only user of ts->idle_lastupdate is update_ts_time_stats(),
the entire field can be eliminated.

In update_ts_time_stats(), idle_lastupdate is first set to "now",
and a few lines later, the only user is an if() statement that
assigns a variable either to "now" or to ts->idle_lastupdate,
which has the value of "now" at that point.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/tick.h     |    1 -
 kernel/time/tick-sched.c |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN include/linux/tick.h~sched-eliminate-the-ts-idle_lastupdate-field include/linux/tick.h
--- a/include/linux/tick.h~sched-eliminate-the-ts-idle_lastupdate-field
+++ a/include/linux/tick.h
@@ -60,7 +60,6 @@ struct tick_sched {
 	ktime_t				idle_waketime;
 	ktime_t				idle_exittime;
 	ktime_t				idle_sleeptime;
-	ktime_t				idle_lastupdate;
 	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
diff -puN kernel/time/tick-sched.c~sched-eliminate-the-ts-idle_lastupdate-field kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-eliminate-the-ts-idle_lastupdate-field
+++ a/kernel/time/tick-sched.c
@@ -158,16 +158,13 @@ update_ts_time_stats(struct tick_sched *
 {
 	ktime_t delta;
 
-	ts->idle_lastupdate = now;
 	if (ts->idle_active) {
 		delta = ktime_sub(now, ts->idle_entrytime);
 		ts->idle_sleeptime = ktime_add(ts->idle_sleeptime, delta);
 		ts->idle_entrytime = now;
 	}
 
-	if (ts->idle_active && last_update_time)
-		*last_update_time = ktime_to_us(ts->idle_lastupdate);
-	else
+	if (last_update_time)
 		*last_update_time = ktime_to_us(now);
 
 }
_

Patches currently in -mm which might be from arjan@linux.intel.com are

linux-next.patch
cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor.patch

