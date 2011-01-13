From: akpm@linux-foundation.org
Subject: [merged] pps-capture-monotonic_raw-timestamps-as-well.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:32 -0800
Message-ID: <201101132012.p0DKCDor030266@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933709Ab1AMUM5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:12:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pps: capture MONOTONIC_RAW timestamps as well
has been removed from the -mm tree.  Its filename was
     pps-capture-monotonic_raw-timestamps-as-well.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pps: capture MONOTONIC_RAW timestamps as well
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

MONOTONIC_RAW clock timestamps are ideally suited for frequency
calculation and also fit well into the original NTP hardpps design.  Now
phase and frequency can be adjusted separately: the former based on
REALTIME clock and the latter based on MONOTONIC_RAW clock.

A new function getnstime_raw_and_real is added to timekeeping subsystem to
capture both timestamps at the same time and atomically.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pps_kernel.h |   14 +++++++++++
 include/linux/time.h       |    2 +
 kernel/time/timekeeping.c  |   43 +++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff -puN include/linux/pps_kernel.h~pps-capture-monotonic_raw-timestamps-as-well include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-capture-monotonic_raw-timestamps-as-well
+++ a/include/linux/pps_kernel.h
@@ -47,6 +47,9 @@ struct pps_source_info {
 };
 
 struct pps_event_time {
+#ifdef CONFIG_NTP_PPS
+	struct timespec ts_raw;
+#endif /* CONFIG_NTP_PPS */
 	struct timespec ts_real;
 };
 
@@ -97,10 +100,21 @@ static inline void timespec_to_pps_ktime
 	kt->nsec = ts.tv_nsec;
 }
 
+#ifdef CONFIG_NTP_PPS
+
+static inline void pps_get_ts(struct pps_event_time *ts)
+{
+	getnstime_raw_and_real(&ts->ts_raw, &ts->ts_real);
+}
+
+#else /* CONFIG_NTP_PPS */
+
 static inline void pps_get_ts(struct pps_event_time *ts)
 {
 	getnstimeofday(&ts->ts_real);
 }
 
+#endif /* CONFIG_NTP_PPS */
+
 #endif /* LINUX_PPS_KERNEL_H */
 
diff -puN include/linux/time.h~pps-capture-monotonic_raw-timestamps-as-well include/linux/time.h
--- a/include/linux/time.h~pps-capture-monotonic_raw-timestamps-as-well
+++ a/include/linux/time.h
@@ -158,6 +158,8 @@ extern unsigned int alarm_setitimer(unsi
 extern int do_getitimer(int which, struct itimerval *value);
 extern void getnstimeofday(struct timespec *tv);
 extern void getrawmonotonic(struct timespec *ts);
+extern void getnstime_raw_and_real(struct timespec *ts_raw,
+		struct timespec *ts_real);
 extern void getboottime(struct timespec *ts);
 extern void monotonic_to_bootbased(struct timespec *ts);
 
diff -puN kernel/time/timekeeping.c~pps-capture-monotonic_raw-timestamps-as-well kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~pps-capture-monotonic_raw-timestamps-as-well
+++ a/kernel/time/timekeeping.c
@@ -288,6 +288,49 @@ void ktime_get_ts(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
+#ifdef CONFIG_NTP_PPS
+
+/**
+ * getnstime_raw_and_real - get day and raw monotonic time in timespec format
+ * @ts_raw:	pointer to the timespec to be set to raw monotonic time
+ * @ts_real:	pointer to the timespec to be set to the time of day
+ *
+ * This function reads both the time of day and raw monotonic time at the
+ * same time atomically and stores the resulting timestamps in timespec
+ * format.
+ */
+void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
+{
+	unsigned long seq;
+	s64 nsecs_raw, nsecs_real;
+
+	WARN_ON_ONCE(timekeeping_suspended);
+
+	do {
+		u32 arch_offset;
+
+		seq = read_seqbegin(&xtime_lock);
+
+		*ts_raw = raw_time;
+		*ts_real = xtime;
+
+		nsecs_raw = timekeeping_get_ns_raw();
+		nsecs_real = timekeeping_get_ns();
+
+		/* If arch requires, add in gettimeoffset() */
+		arch_offset = arch_gettimeoffset();
+		nsecs_raw += arch_offset;
+		nsecs_real += arch_offset;
+
+	} while (read_seqretry(&xtime_lock, seq));
+
+	timespec_add_ns(ts_raw, nsecs_raw);
+	timespec_add_ns(ts_real, nsecs_real);
+}
+EXPORT_SYMBOL(getnstime_raw_and_real);
+
+#endif /* CONFIG_NTP_PPS */
+
 /**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

origin.patch

