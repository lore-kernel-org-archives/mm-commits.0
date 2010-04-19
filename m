From: akpm@linux-foundation.org
Subject: + sched-eliminate-the-ts-idle_lastupdate-field.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:35:42 -0700
Message-ID: <201004192235.o3JMZgRN013698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752746Ab0DSWfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     sched: eliminate the ts->idle_lastupdate field
has been added to the -mm tree.  Its filename is
     sched-eliminate-the-ts-idle_lastupdate-field.patch

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
sched-add-a-comment-to-get_cpu_idle_time_us.patch
sched-introduce-a-function-to-update-the-idle-statistics.patch
sched-update-the-idle-statistics-in-get_cpu_idle_time_us.patch
sched-fold-updating-of-the-last-update-time-into-update_ts_time_stats.patch
sched-eliminate-the-ts-idle_lastupdate-field.patch
sched-introduce-get_cpu_iowait_time_us.patch
ondemand-solve-the-big-performance-issue-with-ondemand-during-disk-io.patch

