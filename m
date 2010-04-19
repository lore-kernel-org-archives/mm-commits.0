From: akpm@linux-foundation.org
Subject: + sched-add-a-comment-to-get_cpu_idle_time_us.patch added to -mm tree
Date: Mon, 19 Apr 2010 15:35:34 -0700
Message-ID: <201004192235.o3JMZYvm013686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838Ab0DSWfg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Apr 2010 18:35:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com


The patch titled
     sched: add a comment to get_cpu_idle_time_us()
has been added to the -mm tree.  Its filename is
     sched-add-a-comment-to-get_cpu_idle_time_us.patch

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
Subject: sched: add a comment to get_cpu_idle_time_us()
From: Arjan van de Ven <arjan@linux.intel.com>

The exported function get_cpu_idle_time_us() has no comment
describing it; add a kerneldoc comment

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN kernel/time/tick-sched.c~sched-add-a-comment-to-get_cpu_idle_time_us kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~sched-add-a-comment-to-get_cpu_idle_time_us
+++ a/kernel/time/tick-sched.c
@@ -179,6 +179,20 @@ static ktime_t tick_nohz_start_idle(stru
 	return now;
 }
 
+/**
+ * get_cpu_idle_time_us - get the total idle time of a cpu
+ * @cpu: CPU number to query
+ * @last_update_time: variable to store update time in
+ *
+ * Return the cummulative idle time (since boot) for a given
+ * CPU, in microseconds. The idle time returned includes
+ * the iowait time (unlike what "top" and co report).
+ *
+ * This time is measured via accounting rather than sampling,
+ * and is as accurate as ktime_get() is.
+ *
+ * This function returns -1 if NOHZ is not enabled.
+ */
 u64 get_cpu_idle_time_us(int cpu, u64 *last_update_time)
 {
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
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

