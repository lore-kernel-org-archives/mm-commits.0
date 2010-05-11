From: akpm@linux-foundation.org
Subject: [merged] sched-add-a-comment-to-get_cpu_idle_time_us.patch removed from -mm tree
Date: Tue, 11 May 2010 12:16:42 -0400
Message-ID: <201005111918.o4BJIBm8018183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507Ab0EKTSO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 May 2010 15:18:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arjan@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     sched: add a comment to get_cpu_idle_time_us()
has been removed from the -mm tree.  Its filename was
     sched-add-a-comment-to-get_cpu_idle_time_us.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor.patch

