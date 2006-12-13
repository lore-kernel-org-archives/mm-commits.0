From: akpm@osdl.org
Subject: - gtod-exponential-update_wall_time.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:48:15 -0800
Message-ID: <200612132248.kBDMmFaU023047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53323 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbWLMWvi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:51:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     GTOD: exponential update_wall_time
has been removed from the -mm tree.  Its filename was
     gtod-exponential-update_wall_time.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: GTOD: exponential update_wall_time
From: John Stultz <johnstul@us.ibm.com>

Accumulate time in update_wall_time() exponentially.  This avoids long running
loops seen with the dynticks patch as well as the problematic hang seen on
systems with broken clocksources.

NOTE: this only has relevance on dyntick kernels, so the quality of NTP
updates on jiffies-tick systems is unaffected.  (non-dyntick kernels call
update_wall_time() in every timer tick)

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/timer.c |   28 ++++++++++++++++++++--------
 1 files changed, 20 insertions(+), 8 deletions(-)

diff -puN kernel/timer.c~gtod-exponential-update_wall_time kernel/timer.c
--- a/kernel/timer.c~gtod-exponential-update_wall_time
+++ a/kernel/timer.c
@@ -907,6 +907,7 @@ static void clocksource_adjust(struct cl
 static void update_wall_time(void)
 {
 	cycle_t offset;
+	int shift = 0;
 
 	/* Make sure we're fully resumed: */
 	if (unlikely(timekeeping_suspended))
@@ -919,28 +920,39 @@ static void update_wall_time(void)
 #endif
 	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
 
+	while (offset > clock->cycle_interval << (shift + 1))
+		shift++;
+
 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
 	 */
 	while (offset >= clock->cycle_interval) {
+		if (offset < (clock->cycle_interval << shift)) {
+			shift--;
+			continue;
+		}
+
 		/* accumulate one interval */
-		clock->xtime_nsec += clock->xtime_interval;
-		clock->cycle_last += clock->cycle_interval;
-		offset -= clock->cycle_interval;
+		clock->xtime_nsec += clock->xtime_interval << shift;
+		clock->cycle_last += clock->cycle_interval << shift;
+		offset -= clock->cycle_interval << shift;
 
-		if (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
+		while (clock->xtime_nsec >= (u64)NSEC_PER_SEC << clock->shift) {
 			clock->xtime_nsec -= (u64)NSEC_PER_SEC << clock->shift;
 			xtime.tv_sec++;
 			second_overflow();
 		}
 
 		/* interpolator bits */
-		time_interpolator_update(clock->xtime_interval
-						>> clock->shift);
+		time_interpolator_update((clock->xtime_interval
+						>> clock->shift)<<shift);
 
 		/* accumulate error between NTP and clock interval */
-		clock->error += current_tick_length();
-		clock->error -= clock->xtime_interval << (TICK_LENGTH_SHIFT - clock->shift);
+		clock->error += current_tick_length() << shift;
+		clock->error -= (clock->xtime_interval
+			<< (TICK_LENGTH_SHIFT - clock->shift))<<shift;
+
+		shift--;
 	}
 
 	/* correct the clock when NTP error is too big */
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

origin.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
clockevents-core.patch
clockevents-i386-drivers.patch
high-res-timers-core.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
debugging-feature-add-proc-timer_stat.patch

