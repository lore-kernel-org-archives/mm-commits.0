From: akpm@linux-foundation.org
Subject: + pps-capture-monotonic_raw-timestamps-as-well.patch added to -mm tree
Date: Fri, 17 Dec 2010 16:20:13 -0800
Message-ID: <201012180020.oBI0KDhA004925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756652Ab0LRAUe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Dec 2010 19:20:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, johnstul@us.ibm.com


The patch titled
     pps: capture MONOTONIC_RAW timestamps as well
has been added to the -mm tree.  Its filename is
     pps-capture-monotonic_raw-timestamps-as-well.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pps_kernel.h |    3 +-
 include/linux/time.h       |    2 +
 kernel/time/timekeeping.c  |   39 +++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff -puN include/linux/pps_kernel.h~pps-capture-monotonic_raw-timestamps-as-well include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-capture-monotonic_raw-timestamps-as-well
+++ a/include/linux/pps_kernel.h
@@ -47,6 +47,7 @@ struct pps_source_info {
 };
 
 struct pps_event_time {
+	struct timespec ts_raw;
 	struct timespec ts_real;
 };
 
@@ -99,7 +100,7 @@ static inline void timespec_to_pps_ktime
 
 static inline void pps_get_ts(struct pps_event_time *ts)
 {
-	getnstimeofday(&ts->ts_real);
+	getnstime_raw_and_real(&ts->ts_raw, &ts->ts_real);
 }
 
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
@@ -289,6 +289,45 @@ void ktime_get_ts(struct timespec *ts)
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
 /**
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
+/**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
  *
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-do-not-disable-interrupts-for-idr-operations.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

