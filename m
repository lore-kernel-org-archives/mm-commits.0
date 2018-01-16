From: akpm@linux-foundation.org
Subject: + pps-parport-use-timespec64-instead-of-timespec.patch added to
 -mm tree
Date: Tue, 16 Jan 2018 12:41:54 -0800
Message-ID: <5a5e6392.tZTbFjI22/cdAjAC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55978 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752071AbeAPUlz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Jan 2018 15:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, giometti@enneenne.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pps: parport: use timespec64 instead of timespec
has been added to the -mm tree.  Its filename is
     pps-parport-use-timespec64-instead-of-timespec.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pps-parport-use-timespec64-instead-of-timespec.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pps-parport-use-timespec64-instead-of-timespec.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: pps: parport: use timespec64 instead of timespec

getnstimeofday() is deprecated, so I'm converting this to use
ktime_get_real_ts64() as a safe replacement.  I considered using
ktime_get_real() instead, but since the algorithm here depends on the
exact timing, I decided to introduce fewer changes and leave the code that
determines the nanoseconds since the last seconds wrap untouched.

It's not entirely clear to me whether we should also change the time base
to CLOCK_BOOTTIME or CLOCK_TAI.  With boottime, we would be independent of
changes due to settimeofday() and only see the speed adjustment from the
upstream clock source, with the downside of having the signal be at an
arbirary offset from the start of the UTC second signal.  With CLOCK_TAI,
we would use the same offset from the UTC second as before and still
suffer from settimeofday() adjustments, but would be less confused during
leap seconds.

Both boottime and tai only offer usable (i.e.  avoiding ktime_t to
timespec64 conversion) interfaces for ktime_t though, so either way,
changing it wouldn't take significantly more work.  CLOCK_MONOTONIC could
be used with ktime_get_ts64(), but would lose synchronization across a
suspend/resume cycle, which seems worse.

Link: http://lkml.kernel.org/r/20180116171451.3095620-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/generators/pps_gen_parport.c |   40 ++++++++++-----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN drivers/pps/generators/pps_gen_parport.c~pps-parport-use-timespec64-instead-of-timespec drivers/pps/generators/pps_gen_parport.c
--- a/drivers/pps/generators/pps_gen_parport.c~pps-parport-use-timespec64-instead-of-timespec
+++ a/drivers/pps/generators/pps_gen_parport.c
@@ -70,7 +70,7 @@ static long hrtimer_error = SAFETY_INTER
 /* the kernel hrtimer event */
 static enum hrtimer_restart hrtimer_event(struct hrtimer *timer)
 {
-	struct timespec expire_time, ts1, ts2, ts3, dts;
+	struct timespec64 expire_time, ts1, ts2, ts3, dts;
 	struct pps_generator_pp *dev;
 	struct parport *port;
 	long lim, delta;
@@ -78,7 +78,7 @@ static enum hrtimer_restart hrtimer_even
 
 	/* We have to disable interrupts here. The idea is to prevent
 	 * other interrupts on the same processor to introduce random
-	 * lags while polling the clock. getnstimeofday() takes <1us on
+	 * lags while polling the clock. ktime_get_real_ts64() takes <1us on
 	 * most machines while other interrupt handlers can take much
 	 * more potentially.
 	 *
@@ -88,22 +88,22 @@ static enum hrtimer_restart hrtimer_even
 	local_irq_save(flags);
 
 	/* first of all we get the time stamp... */
-	getnstimeofday(&ts1);
-	expire_time = ktime_to_timespec(hrtimer_get_softexpires(timer));
+	ktime_get_real_ts64(&ts1);
+	expire_time = ktime_to_timespec64(hrtimer_get_softexpires(timer));
 	dev = container_of(timer, struct pps_generator_pp, timer);
 	lim = NSEC_PER_SEC - send_delay - dev->port_write_time;
 
 	/* check if we are late */
 	if (expire_time.tv_sec != ts1.tv_sec || ts1.tv_nsec > lim) {
 		local_irq_restore(flags);
-		pr_err("we are late this time %ld.%09ld\n",
-				ts1.tv_sec, ts1.tv_nsec);
+		pr_err("we are late this time %lld.%09ld\n",
+				(s64)ts1.tv_sec, ts1.tv_nsec);
 		goto done;
 	}
 
 	/* busy loop until the time is right for an assert edge */
 	do {
-		getnstimeofday(&ts2);
+		ktime_get_real_ts64(&ts2);
 	} while (expire_time.tv_sec == ts2.tv_sec && ts2.tv_nsec < lim);
 
 	/* set the signal */
@@ -113,25 +113,25 @@ static enum hrtimer_restart hrtimer_even
 	/* busy loop until the time is right for a clear edge */
 	lim = NSEC_PER_SEC - dev->port_write_time;
 	do {
-		getnstimeofday(&ts2);
+		ktime_get_real_ts64(&ts2);
 	} while (expire_time.tv_sec == ts2.tv_sec && ts2.tv_nsec < lim);
 
 	/* unset the signal */
 	port->ops->write_control(port, NO_SIGNAL);
 
-	getnstimeofday(&ts3);
+	ktime_get_real_ts64(&ts3);
 
 	local_irq_restore(flags);
 
 	/* update calibrated port write time */
-	dts = timespec_sub(ts3, ts2);
+	dts = timespec64_sub(ts3, ts2);
 	dev->port_write_time =
-		(dev->port_write_time + timespec_to_ns(&dts)) >> 1;
+		(dev->port_write_time + timespec64_to_ns(&dts)) >> 1;
 
 done:
 	/* update calibrated hrtimer error */
-	dts = timespec_sub(ts1, expire_time);
-	delta = timespec_to_ns(&dts);
+	dts = timespec64_sub(ts1, expire_time);
+	delta = timespec64_to_ns(&dts);
 	/* If the new error value is bigger then the old, use the new
 	 * value, if not then slowly move towards the new value. This
 	 * way it should be safe in bad conditions and efficient in
@@ -161,17 +161,17 @@ static void calibrate_port(struct pps_ge
 	long acc = 0;
 
 	for (i = 0; i < (1 << PORT_NTESTS_SHIFT); i++) {
-		struct timespec a, b;
+		struct timespec64 a, b;
 		unsigned long irq_flags;
 
 		local_irq_save(irq_flags);
-		getnstimeofday(&a);
+		ktime_get_real_ts64(&a);
 		port->ops->write_control(port, NO_SIGNAL);
-		getnstimeofday(&b);
+		ktime_get_real_ts64(&b);
 		local_irq_restore(irq_flags);
 
-		b = timespec_sub(b, a);
-		acc += timespec_to_ns(&b);
+		b = timespec64_sub(b, a);
+		acc += timespec64_to_ns(&b);
 	}
 
 	dev->port_write_time = acc >> PORT_NTESTS_SHIFT;
@@ -180,9 +180,9 @@ static void calibrate_port(struct pps_ge
 
 static inline ktime_t next_intr_time(struct pps_generator_pp *dev)
 {
-	struct timespec ts;
+	struct timespec64 ts;
 
-	getnstimeofday(&ts);
+	ktime_get_real_ts64(&ts);
 
 	return ktime_set(ts.tv_sec +
 			((ts.tv_nsec > 990 * NSEC_PER_MSEC) ? 1 : 0),
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-thp-use-down_read_trylock-in-khugepaged-to-avoid-long-block-fix-2.patch
kasan-added-functions-for-unpoisoning-stack-variables-fix-fix.patch
bugh-work-around-gcc-pr82365-in-bug.patch
pps-parport-use-timespec64-instead-of-timespec.patch
kasan-rework-kconfig-settings.patch

