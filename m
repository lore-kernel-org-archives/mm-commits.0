From: akpm@linux-foundation.org
Subject: + pps-capture-monotonic_raw-timestamps-as-well-v7.patch added to -mm tree
Date: Tue, 21 Dec 2010 15:08:37 -0800
Message-ID: <201012212308.oBLN8btR031419@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0LUXIw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 18:08:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lasaine@lvk.cs.msu.su, giometti@enneenne.com, johnstul@us.ibm.com


The patch titled
     pps-capture-monotonic_raw-timestamps-as-well-v7
has been added to the -mm tree.  Its filename is
     pps-capture-monotonic_raw-timestamps-as-well-v7.patch

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
Subject: pps-capture-monotonic_raw-timestamps-as-well-v7
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pps_kernel.h |   13 +++++++++++++
 kernel/time/timekeeping.c  |    4 ++++
 2 files changed, 17 insertions(+)

diff -puN include/linux/pps_kernel.h~pps-capture-monotonic_raw-timestamps-as-well-v7 include/linux/pps_kernel.h
--- a/include/linux/pps_kernel.h~pps-capture-monotonic_raw-timestamps-as-well-v7
+++ a/include/linux/pps_kernel.h
@@ -47,7 +47,9 @@ struct pps_source_info {
 };
 
 struct pps_event_time {
+#ifdef CONFIG_NTP_PPS
 	struct timespec ts_raw;
+#endif /* CONFIG_NTP_PPS */
 	struct timespec ts_real;
 };
 
@@ -98,10 +100,21 @@ static inline void timespec_to_pps_ktime
 	kt->nsec = ts.tv_nsec;
 }
 
+#ifdef CONFIG_NTP_PPS
+
 static inline void pps_get_ts(struct pps_event_time *ts)
 {
 	getnstime_raw_and_real(&ts->ts_raw, &ts->ts_real);
 }
 
+#else /* CONFIG_NTP_PPS */
+
+static inline void pps_get_ts(struct pps_event_time *ts)
+{
+	getnstimeofday(&ts->ts_real);
+}
+
+#endif /* CONFIG_NTP_PPS */
+
 #endif /* LINUX_PPS_KERNEL_H */
 
diff -puN kernel/time/timekeeping.c~pps-capture-monotonic_raw-timestamps-as-well-v7 kernel/time/timekeeping.c
--- a/kernel/time/timekeeping.c~pps-capture-monotonic_raw-timestamps-as-well-v7
+++ a/kernel/time/timekeeping.c
@@ -288,6 +288,8 @@ void ktime_get_ts(struct timespec *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
+#ifdef CONFIG_NTP_PPS
+
 /**
  * getnstime_raw_and_real - get day and raw monotonic time in timespec format
  * @ts_raw:	pointer to the timespec to be set to raw monotonic time
@@ -327,6 +329,8 @@ void getnstime_raw_and_real(struct times
 }
 EXPORT_SYMBOL(getnstime_raw_and_real);
 
+#endif /* CONFIG_NTP_PPS */
+
 /**
  * do_gettimeofday - Returns the time of day in a timeval
  * @tv:		pointer to the timeval to be set
_

Patches currently in -mm which might be from lasaine@lvk.cs.msu.su are

pps-trivial-fixes.patch
pps-declare-variables-where-they-are-used-in-switch.patch
pps-fix-race-in-pps_fetch-handler.patch
pps-unify-timestamp-gathering.patch
pps-access-pps-device-by-direct-pointer.patch
pps-convert-printk-pr_-to-dev_.patch
pps-move-idr-stuff-to-ppsc.patch
pps-make-idr-lock-a-mutex-and-protect-idr_pre_get.patch
pps-use-bug_on-for-kernel-api-safety-checks.patch
pps-simplify-conditions-a-bit.patch
pps-timestamp-is-always-passed-to-dcd_change.patch
ntp-add-hardpps-implementation.patch
ntp-add-hardpps-implementation-update-v7.patch
pps-capture-monotonic_raw-timestamps-as-well.patch
pps-capture-monotonic_raw-timestamps-as-well-v7.patch
pps-add-kernel-consumer-support.patch
pps-add-parallel-port-pps-client.patch
pps-add-parallel-port-pps-signal-generator.patch

