Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 728FD3EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905017; cv=none; b=sfjqLrMa1f7jqNxQRZ1xG0R3+mIcM8cccHuy3cCpYHfFU7BNo8Tub50NWBvDZbvyhwj2DRQGwwbGjORujiLHQrDQ1/Kq6iQvDjiPNGOqbfd72ZiUKv6wUcntszZHZpvuQYfaI3gGwPne+Y/bWSMrXtffVqvpeLf0HhZExce+EC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905017; c=relaxed/simple;
	bh=RCnZgwYUb7UqrTouBSgy255irJubuqOkka5BiVQtuG8=;
	h=Date:To:From:Subject:Message-Id; b=eEpEky+Zp7FEUP0GJB3PUPWa5gxKGZlnm3V9zPzlLkk/KKqTY6jw+zDgr14ybw2YsfuFevKbqEhOtJi0SDpUDsj+sdGMlVg/nFY5mmUrfaDRc4RcBrzBUtgzywmCxSMKMWqd0pjPGY57mrsu2yHMlU8xsquqw8nFDUv0bv3Qog4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CWO8x/jU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CWO8x/jU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476C8C4CEF1;
	Sun,  1 Feb 2026 00:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905017;
	bh=RCnZgwYUb7UqrTouBSgy255irJubuqOkka5BiVQtuG8=;
	h=Date:To:From:Subject:From;
	b=CWO8x/jU5xl42PSQWFmwjFlkrVKnGmn7hU/1wnhsGFL2N0eWrLBmRvgQQ+NyOixWs
	 lqt0t1yXxZKf9ob8fNBOdiYR9p9/vUyo2ZcSZmhB53U48dZNUeWhwWXth9u24SOGGC
	 h831v4O1Jeu8U9nbfcTGlm92VebkKghVInPnpRiw=
Date: Sat, 31 Jan 2026 16:16:56 -0800
To: mm-commits@vger.kernel.org,yang.yang29@zte.com.cn,xu.xin16@zte.com.cn,fan.yu9@zte.com.cn,corbet@lwn.net,wang.yaxin@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] delayacct-add-timestamp-of-delay-max.patch removed from -mm tree
Message-Id: <20260201001657.476C8C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: delayacct: add timestamp of delay max
has been removed from the -mm tree.  Its filename was
     delayacct-add-timestamp-of-delay-max.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wang Yaxin <wang.yaxin@zte.com.cn>
Subject: delayacct: add timestamp of delay max
Date: Mon, 19 Jan 2026 10:02:41 +0800 (CST)

Problem
=======
Commit 658eb5ab916d ("delayacct: add delay max to record delay peak")
introduced the delay max for getdelays, which records abnormal latency
peaks and helps us understand the magnitude of such delays.  However, the
peak latency value alone is insufficient for effective root cause
analysis.  Without the precise timestamp of when the peak occurred, we
still lack the critical context needed to correlate it with other system
events.

Solution
========
To address this, we need to additionally record a precise timestamp when
the maximum latency occurs.  By correlating this timestamp with system
logs and monitoring metrics, we can identify processes with abnormal
resource usage at the same moment, which can help us to pinpoint root
causes.

Use Case
========
bash-4.4# ./getdelays -d -t 227
print delayacct stats ON
TGID    227
CPU         count     real total  virtual total    delay total  delay average      delay max      delay min      delay max timestamp
               46      188000000      192348334        4098012          0.089ms     0.429260ms     0.051205ms    2026-01-15T15:06:58
IO          count    delay total  delay average      delay max      delay min      delay max timestamp
                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
SWAP        count    delay total  delay average      delay max      delay min      delay max timestamp
                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
RECLAIM     count    delay total  delay average      delay max      delay min      delay max timestamp
                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
THRAS HING   count    delay total  delay average      delay max      delay min      delay max timestamp
                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
COMPACT     count    delay total  delay average      delay max      delay min      delay max timestamp
                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
WPCOPY      count    delay total  delay average      delay max      delay min      delay max timestamp
              182       19413338          0.107ms     0.547353ms     0.022462ms    2026-01-15T15:05:24
IRQ         count    delay total  delay average      delay max      delay min      delay max timestamp
                0              0          0.000ms     0.000000ms     0.000000ms                    N/A

Link: https://lkml.kernel.org/r/20260119100241520gWubW8-5QfhSf9gjqcc_E@zte.com.cn
Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
Cc: Fan Yu <fan.yu9@zte.com.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: xu xin <xu.xin16@zte.com.cn>
Cc: Yang Yang <yang.yang29@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/delay-accounting.rst |   32 +-
 include/linux/delayacct.h                     |    8 
 include/linux/sched.h                         |    5 
 include/uapi/linux/taskstats.h                |   22 +
 kernel/delayacct.c                            |   31 +-
 kernel/sched/stats.h                          |    8 
 tools/accounting/getdelays.c                  |  180 +++++++++++++---
 7 files changed, 227 insertions(+), 59 deletions(-)

--- a/Documentation/accounting/delay-accounting.rst~delayacct-add-timestamp-of-delay-max
+++ a/Documentation/accounting/delay-accounting.rst
@@ -107,22 +107,22 @@ Get sum and peak of delays, since system
 	TGID    242
 
 
-	CPU         count     real total  virtual total    delay total  delay average      delay max      delay min
-	               39      156000000      156576579        2111069          0.054ms     0.212296ms     0.031307ms
-	IO          count    delay total  delay average      delay max      delay min
-	                0              0          0.000ms     0.000000ms     0.000000ms
-	SWAP        count    delay total  delay average      delay max      delay min
-	                0              0          0.000ms     0.000000ms     0.000000ms
-	RECLAIM     count    delay total  delay average      delay max      delay min
-	                0              0          0.000ms     0.000000ms     0.000000ms
-	THRASHING   count    delay total  delay average      delay max      delay min
-	                0              0          0.000ms     0.000000ms     0.000000ms
-	COMPACT     count    delay total  delay average      delay max      delay min
-	                0              0          0.000ms     0.000000ms     0.000000ms
-	WPCOPY      count    delay total  delay average      delay max      delay min
-	              156       11215873          0.072ms     0.207403ms     0.033913ms
-	IRQ         count    delay total  delay average      delay max      delay min
-	                0              0          0.000ms     0.000000ms     0.000000ms
+	CPU         count     real total  virtual total    delay total  delay average      delay max      delay min      delay max timestamp
+	               46      188000000      192348334        4098012          0.089ms     0.429260ms     0.051205ms    2026-01-15T15:06:58
+	IO          count    delay total  delay average      delay max      delay min      delay max timestamp
+	                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
+	SWAP        count    delay total  delay average      delay max      delay min      delay max timestamp
+	                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
+	RECLAIM     count    delay total  delay average      delay max      delay min      delay max timestamp
+	                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
+	THRASHING   count    delay total  delay average      delay max      delay min      delay max timestamp
+	                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
+	COMPACT     count    delay total  delay average      delay max      delay min      delay max timestamp
+	                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
+	WPCOPY      count    delay total  delay average      delay max      delay min      delay max timestamp
+	              182       19413338          0.107ms     0.547353ms     0.022462ms    2026-01-15T15:05:24
+	IRQ         count    delay total  delay average      delay max      delay min      delay max timestamp
+	                0              0          0.000ms     0.000000ms     0.000000ms                    N/A
 
 Get IO accounting for pid 1, it works only with -p::
 
--- a/include/linux/delayacct.h~delayacct-add-timestamp-of-delay-max
+++ a/include/linux/delayacct.h
@@ -69,6 +69,14 @@ struct task_delay_info {
 	u32 compact_count;	/* total count of memory compact */
 	u32 wpcopy_count;	/* total count of write-protect copy */
 	u32 irq_count;	/* total count of IRQ/SOFTIRQ */
+
+	struct timespec64 blkio_delay_max_ts;
+	struct timespec64 swapin_delay_max_ts;
+	struct timespec64 freepages_delay_max_ts;
+	struct timespec64 thrashing_delay_max_ts;
+	struct timespec64 compact_delay_max_ts;
+	struct timespec64 wpcopy_delay_max_ts;
+	struct timespec64 irq_delay_max_ts;
 };
 #endif
 
--- a/include/linux/sched.h~delayacct-add-timestamp-of-delay-max
+++ a/include/linux/sched.h
@@ -49,6 +49,7 @@
 #include <linux/tracepoint-defs.h>
 #include <linux/unwind_deferred_types.h>
 #include <asm/kmap_size.h>
+#include <linux/time64.h>
 #ifndef COMPILE_OFFSETS
 #include <generated/rq-offsets.h>
 #endif
@@ -86,6 +87,7 @@ struct signal_struct;
 struct task_delay_info;
 struct task_group;
 struct task_struct;
+struct timespec64;
 struct user_event_mm;
 
 #include <linux/sched/ext.h>
@@ -435,6 +437,9 @@ struct sched_info {
 	/* When were we last queued to run? */
 	unsigned long long		last_queued;
 
+	/* Timestamp of max time spent waiting on a runqueue: */
+	struct timespec64		max_run_delay_ts;
+
 #endif /* CONFIG_SCHED_INFO */
 };
 
--- a/include/uapi/linux/taskstats.h~delayacct-add-timestamp-of-delay-max
+++ a/include/uapi/linux/taskstats.h
@@ -18,6 +18,16 @@
 #define _LINUX_TASKSTATS_H
 
 #include <linux/types.h>
+#ifdef __KERNEL__
+#include <linux/time64.h>
+#else
+#ifndef _LINUX_TIME64_H
+struct timespec64 {
+	__s64   tv_sec;         /* seconds */
+	long    tv_nsec;        /* nanoseconds */
+};
+#endif
+#endif
 
 /* Format for per-task data returned to userland when
  *	- a task exits
@@ -34,7 +44,7 @@
  */
 
 
-#define TASKSTATS_VERSION	16
+#define TASKSTATS_VERSION	17
 #define TS_COMM_LEN		32	/* should be >= TASK_COMM_LEN
 					 * in linux/sched.h */
 
@@ -230,6 +240,16 @@ struct taskstats {
 
 	__u64	irq_delay_max;
 	__u64	irq_delay_min;
+
+	/*v17: delay max timestamp record*/
+	struct timespec64 cpu_delay_max_ts;
+	struct timespec64 blkio_delay_max_ts;
+	struct timespec64 swapin_delay_max_ts;
+	struct timespec64 freepages_delay_max_ts;
+	struct timespec64 thrashing_delay_max_ts;
+	struct timespec64 compact_delay_max_ts;
+	struct timespec64 wpcopy_delay_max_ts;
+	struct timespec64 irq_delay_max_ts;
 };
 
 
--- a/kernel/delayacct.c~delayacct-add-timestamp-of-delay-max
+++ a/kernel/delayacct.c
@@ -18,6 +18,7 @@
 do { \
 	d->type##_delay_max = tsk->delays->type##_delay_max; \
 	d->type##_delay_min = tsk->delays->type##_delay_min; \
+	d->type##_delay_max_ts = tsk->delays->type##_delay_max_ts; \
 	tmp = d->type##_delay_total + tsk->delays->type##_delay; \
 	d->type##_delay_total = (tmp < d->type##_delay_total) ? 0 : tmp; \
 	d->type##_count += tsk->delays->type##_count; \
@@ -104,7 +105,8 @@ void __delayacct_tsk_init(struct task_st
  * Finish delay accounting for a statistic using its timestamps (@start),
  * accumulator (@total) and @count
  */
-static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count, u64 *max, u64 *min)
+static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count,
+							 u64 *max, u64 *min, struct timespec64 *ts)
 {
 	s64 ns = local_clock() - *start;
 	unsigned long flags;
@@ -113,8 +115,10 @@ static void delayacct_end(raw_spinlock_t
 		raw_spin_lock_irqsave(lock, flags);
 		*total += ns;
 		(*count)++;
-		if (ns > *max)
+		if (ns > *max) {
 			*max = ns;
+			ktime_get_real_ts64(ts);
+		}
 		if (*min == 0 || ns < *min)
 			*min = ns;
 		raw_spin_unlock_irqrestore(lock, flags);
@@ -137,7 +141,8 @@ void __delayacct_blkio_end(struct task_s
 		      &p->delays->blkio_delay,
 		      &p->delays->blkio_count,
 		      &p->delays->blkio_delay_max,
-		      &p->delays->blkio_delay_min);
+		      &p->delays->blkio_delay_min,
+		      &p->delays->blkio_delay_max_ts);
 }
 
 int delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
@@ -170,6 +175,7 @@ int delayacct_add_tsk(struct taskstats *
 
 	d->cpu_delay_max = tsk->sched_info.max_run_delay;
 	d->cpu_delay_min = tsk->sched_info.min_run_delay;
+	d->cpu_delay_max_ts = tsk->sched_info.max_run_delay_ts;
 	tmp = (s64)d->cpu_delay_total + t2;
 	d->cpu_delay_total = (tmp < (s64)d->cpu_delay_total) ? 0 : tmp;
 	tmp = (s64)d->cpu_run_virtual_total + t3;
@@ -217,7 +223,8 @@ void __delayacct_freepages_end(void)
 		      &current->delays->freepages_delay,
 		      &current->delays->freepages_count,
 		      &current->delays->freepages_delay_max,
-		      &current->delays->freepages_delay_min);
+		      &current->delays->freepages_delay_min,
+		      &current->delays->freepages_delay_max_ts);
 }
 
 void __delayacct_thrashing_start(bool *in_thrashing)
@@ -241,7 +248,8 @@ void __delayacct_thrashing_end(bool *in_
 		      &current->delays->thrashing_delay,
 		      &current->delays->thrashing_count,
 		      &current->delays->thrashing_delay_max,
-		      &current->delays->thrashing_delay_min);
+		      &current->delays->thrashing_delay_min,
+		      &current->delays->thrashing_delay_max_ts);
 }
 
 void __delayacct_swapin_start(void)
@@ -256,7 +264,8 @@ void __delayacct_swapin_end(void)
 		      &current->delays->swapin_delay,
 		      &current->delays->swapin_count,
 		      &current->delays->swapin_delay_max,
-		      &current->delays->swapin_delay_min);
+		      &current->delays->swapin_delay_min,
+		      &current->delays->swapin_delay_max_ts);
 }
 
 void __delayacct_compact_start(void)
@@ -271,7 +280,8 @@ void __delayacct_compact_end(void)
 		      &current->delays->compact_delay,
 		      &current->delays->compact_count,
 		      &current->delays->compact_delay_max,
-		      &current->delays->compact_delay_min);
+		      &current->delays->compact_delay_min,
+		      &current->delays->compact_delay_max_ts);
 }
 
 void __delayacct_wpcopy_start(void)
@@ -286,7 +296,8 @@ void __delayacct_wpcopy_end(void)
 		      &current->delays->wpcopy_delay,
 		      &current->delays->wpcopy_count,
 		      &current->delays->wpcopy_delay_max,
-		      &current->delays->wpcopy_delay_min);
+		      &current->delays->wpcopy_delay_min,
+		      &current->delays->wpcopy_delay_max_ts);
 }
 
 void __delayacct_irq(struct task_struct *task, u32 delta)
@@ -296,8 +307,10 @@ void __delayacct_irq(struct task_struct
 	raw_spin_lock_irqsave(&task->delays->lock, flags);
 	task->delays->irq_delay += delta;
 	task->delays->irq_count++;
-	if (delta > task->delays->irq_delay_max)
+	if (delta > task->delays->irq_delay_max) {
 		task->delays->irq_delay_max = delta;
+		ktime_get_real_ts64(&task->delays->irq_delay_max_ts);
+	}
 	if (delta && (!task->delays->irq_delay_min || delta < task->delays->irq_delay_min))
 		task->delays->irq_delay_min = delta;
 	raw_spin_unlock_irqrestore(&task->delays->lock, flags);
--- a/kernel/sched/stats.h~delayacct-add-timestamp-of-delay-max
+++ a/kernel/sched/stats.h
@@ -253,8 +253,10 @@ static inline void sched_info_dequeue(st
 	delta = rq_clock(rq) - t->sched_info.last_queued;
 	t->sched_info.last_queued = 0;
 	t->sched_info.run_delay += delta;
-	if (delta > t->sched_info.max_run_delay)
+	if (delta > t->sched_info.max_run_delay) {
 		t->sched_info.max_run_delay = delta;
+		ktime_get_real_ts64(&t->sched_info.max_run_delay_ts);
+	}
 	if (delta && (!t->sched_info.min_run_delay || delta < t->sched_info.min_run_delay))
 		t->sched_info.min_run_delay = delta;
 	rq_sched_info_dequeue(rq, delta);
@@ -278,8 +280,10 @@ static void sched_info_arrive(struct rq
 	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
-	if (delta > t->sched_info.max_run_delay)
+	if (delta > t->sched_info.max_run_delay) {
 		t->sched_info.max_run_delay = delta;
+		ktime_get_real_ts64(&t->sched_info.max_run_delay_ts);
+	}
 	if (delta && (!t->sched_info.min_run_delay || delta < t->sched_info.min_run_delay))
 		t->sched_info.min_run_delay = delta;
 
--- a/tools/accounting/getdelays.c~delayacct-add-timestamp-of-delay-max
+++ a/tools/accounting/getdelays.c
@@ -24,6 +24,7 @@
 #include <sys/socket.h>
 #include <sys/wait.h>
 #include <signal.h>
+#include <time.h>
 
 #include <linux/genetlink.h>
 #include <linux/taskstats.h>
@@ -195,6 +196,37 @@ static int get_family_id(int sd)
 #define delay_ms(t) (t / 1000000ULL)
 
 /*
+ * Format timespec64 to human readable string (YYYY-MM-DD HH:MM:SS)
+ * Returns formatted string or "N/A" if timestamp is zero
+ */
+static const char *format_timespec64(struct timespec64 *ts)
+{
+	static char buffer[32];
+	struct tm tm_info;
+	time_t time_sec;
+
+	/* Check if timestamp is zero (not set) */
+	if (ts->tv_sec == 0 && ts->tv_nsec == 0)
+		return "N/A";
+
+	time_sec = (time_t)ts->tv_sec;
+
+	/* Use thread-safe localtime_r */
+	if (localtime_r(&time_sec, &tm_info) == NULL)
+		return "N/A";
+
+	snprintf(buffer, sizeof(buffer), "%04d-%02d-%02dT%02d:%02d:%02d",
+		tm_info.tm_year + 1900,
+		tm_info.tm_mon + 1,
+		tm_info.tm_mday,
+		tm_info.tm_hour,
+		tm_info.tm_min,
+		tm_info.tm_sec);
+
+	return buffer;
+}
+
+/*
  * Version compatibility note:
  * Field availability depends on taskstats version (t->version),
  * corresponding to TASKSTATS_VERSION in kernel headers
@@ -205,13 +237,28 @@ static int get_family_id(int sd)
  * version >= 13  - supports WPCOPY statistics
  * version >= 14  - supports IRQ statistics
  * version >= 16  - supports *_max and *_min delay statistics
+ * version >= 17  - supports delay max timestamp statistics
  *
  * Always verify version before accessing version-dependent fields
  * to maintain backward compatibility.
  */
 #define PRINT_CPU_DELAY(version, t) \
 	do { \
-		if (version >= 16) { \
+		if (version >= 17) { \
+			printf("%-10s%15s%15s%15s%15s%15s%15s%15s%25s\n", \
+				"CPU", "count", "real total", "virtual total", \
+				"delay total", "delay average", "delay max", \
+				"delay min", "delay max timestamp"); \
+			printf("          %15llu%15llu%15llu%15llu%15.3fms%13.6fms%13.6fms%23s\n", \
+				(unsigned long long)(t)->cpu_count, \
+				(unsigned long long)(t)->cpu_run_real_total, \
+				(unsigned long long)(t)->cpu_run_virtual_total, \
+				(unsigned long long)(t)->cpu_delay_total, \
+				average_ms((double)(t)->cpu_delay_total, (t)->cpu_count), \
+				delay_ms((double)(t)->cpu_delay_max), \
+				delay_ms((double)(t)->cpu_delay_min), \
+				format_timespec64(&(t)->cpu_delay_max_ts)); \
+		} else if (version >= 16) { \
 			printf("%-10s%15s%15s%15s%15s%15s%15s%15s\n", \
 				"CPU", "count", "real total", "virtual total", \
 				"delay total", "delay average", "delay max", "delay min"); \
@@ -257,44 +304,115 @@ static int get_family_id(int sd)
 		} \
 	} while (0)
 
+#define PRINT_FILED_DELAY_WITH_TS(name, version, t, count, total, max, min, max_ts) \
+	do { \
+		if (version >= 17) { \
+			printf("%-10s%15s%15s%15s%15s%15s%25s\n", \
+				name, "count", "delay total", "delay average", \
+				"delay max", "delay min", "delay max timestamp"); \
+			printf("          %15llu%15llu%15.3fms%13.6fms%13.6fms%23s\n", \
+				(unsigned long long)(t)->count, \
+				(unsigned long long)(t)->total, \
+				average_ms((double)(t)->total, (t)->count), \
+				delay_ms((double)(t)->max), \
+				delay_ms((double)(t)->min), \
+				format_timespec64(&(t)->max_ts)); \
+		} else if (version >= 16) { \
+			printf("%-10s%15s%15s%15s%15s%15s\n", \
+				name, "count", "delay total", "delay average", \
+				"delay max", "delay min"); \
+			printf("          %15llu%15llu%15.3fms%13.6fms%13.6fms\n", \
+				(unsigned long long)(t)->count, \
+				(unsigned long long)(t)->total, \
+				average_ms((double)(t)->total, (t)->count), \
+				delay_ms((double)(t)->max), \
+				delay_ms((double)(t)->min)); \
+		} else { \
+			printf("%-10s%15s%15s%15s\n", \
+				name, "count", "delay total", "delay average"); \
+			printf("          %15llu%15llu%15.3fms\n", \
+				(unsigned long long)(t)->count, \
+				(unsigned long long)(t)->total, \
+				average_ms((double)(t)->total, (t)->count)); \
+		} \
+	} while (0)
+
 static void print_delayacct(struct taskstats *t)
 {
 	printf("\n\n");
 
 	PRINT_CPU_DELAY(t->version, t);
 
-	PRINT_FILED_DELAY("IO", t->version, t,
-		blkio_count, blkio_delay_total,
-		blkio_delay_max, blkio_delay_min);
-
-	PRINT_FILED_DELAY("SWAP", t->version, t,
-		swapin_count, swapin_delay_total,
-		swapin_delay_max, swapin_delay_min);
-
-	PRINT_FILED_DELAY("RECLAIM", t->version, t,
-		freepages_count, freepages_delay_total,
-		freepages_delay_max, freepages_delay_min);
-
-	PRINT_FILED_DELAY("THRASHING", t->version, t,
-		thrashing_count, thrashing_delay_total,
-		thrashing_delay_max, thrashing_delay_min);
-
-	if (t->version >= 11) {
-		PRINT_FILED_DELAY("COMPACT", t->version, t,
-			compact_count, compact_delay_total,
-			compact_delay_max, compact_delay_min);
-	}
+	/* Use new macro with timestamp support for version >= 17 */
+	if (t->version >= 17) {
+		PRINT_FILED_DELAY_WITH_TS("IO", t->version, t,
+			blkio_count, blkio_delay_total,
+			blkio_delay_max, blkio_delay_min, blkio_delay_max_ts);
+
+		PRINT_FILED_DELAY_WITH_TS("SWAP", t->version, t,
+			swapin_count, swapin_delay_total,
+			swapin_delay_max, swapin_delay_min, swapin_delay_max_ts);
+
+		PRINT_FILED_DELAY_WITH_TS("RECLAIM", t->version, t,
+			freepages_count, freepages_delay_total,
+			freepages_delay_max, freepages_delay_min, freepages_delay_max_ts);
+
+		PRINT_FILED_DELAY_WITH_TS("THRASHING", t->version, t,
+			thrashing_count, thrashing_delay_total,
+			thrashing_delay_max, thrashing_delay_min, thrashing_delay_max_ts);
+
+		if (t->version >= 11) {
+			PRINT_FILED_DELAY_WITH_TS("COMPACT", t->version, t,
+				compact_count, compact_delay_total,
+				compact_delay_max, compact_delay_min, compact_delay_max_ts);
+		}
 
-	if (t->version >= 13) {
-		PRINT_FILED_DELAY("WPCOPY", t->version, t,
-			wpcopy_count, wpcopy_delay_total,
-			wpcopy_delay_max, wpcopy_delay_min);
-	}
+		if (t->version >= 13) {
+			PRINT_FILED_DELAY_WITH_TS("WPCOPY", t->version, t,
+				wpcopy_count, wpcopy_delay_total,
+				wpcopy_delay_max, wpcopy_delay_min, wpcopy_delay_max_ts);
+		}
 
-	if (t->version >= 14) {
-		PRINT_FILED_DELAY("IRQ", t->version, t,
-			irq_count, irq_delay_total,
-			irq_delay_max, irq_delay_min);
+		if (t->version >= 14) {
+			PRINT_FILED_DELAY_WITH_TS("IRQ", t->version, t,
+				irq_count, irq_delay_total,
+				irq_delay_max, irq_delay_min, irq_delay_max_ts);
+		}
+	} else {
+		/* Use original macro for older versions */
+		PRINT_FILED_DELAY("IO", t->version, t,
+			blkio_count, blkio_delay_total,
+			blkio_delay_max, blkio_delay_min);
+
+		PRINT_FILED_DELAY("SWAP", t->version, t,
+			swapin_count, swapin_delay_total,
+			swapin_delay_max, swapin_delay_min);
+
+		PRINT_FILED_DELAY("RECLAIM", t->version, t,
+			freepages_count, freepages_delay_total,
+			freepages_delay_max, freepages_delay_min);
+
+		PRINT_FILED_DELAY("THRASHING", t->version, t,
+			thrashing_count, thrashing_delay_total,
+			thrashing_delay_max, thrashing_delay_min);
+
+		if (t->version >= 11) {
+			PRINT_FILED_DELAY("COMPACT", t->version, t,
+				compact_count, compact_delay_total,
+				compact_delay_max, compact_delay_min);
+		}
+
+		if (t->version >= 13) {
+			PRINT_FILED_DELAY("WPCOPY", t->version, t,
+				wpcopy_count, wpcopy_delay_total,
+				wpcopy_delay_max, wpcopy_delay_min);
+		}
+
+		if (t->version >= 14) {
+			PRINT_FILED_DELAY("IRQ", t->version, t,
+				irq_count, irq_delay_total,
+				irq_delay_max, irq_delay_min);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from wang.yaxin@zte.com.cn are


