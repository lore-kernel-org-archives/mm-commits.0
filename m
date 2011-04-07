From: akpm@linux-foundation.org
Subject: + init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch added to -mm tree
Date: Thu, 07 Apr 2011 15:17:51 -0700
Message-ID: <201104072217.p37MHp6G003462@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46595 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755798Ab1DGWR7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Apr 2011 18:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amworsley@gmail.com, ext-phil.2.carmody@nokia.com


The patch titled
     init/calibrate.c: fix for critical bogoMIPS intermittent calculation failure
has been added to the -mm tree.  Its filename is
     init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch

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
Subject: init/calibrate.c: fix for critical bogoMIPS intermittent calculation failure
From: Andrew Worsley <amworsley@gmail.com>

A fix to the TSC (Time Stamp Counter) based bogoMIPS calculation used on
secondary CPUs which has two faults:

1: Not handling wrapping of the lower 32 bits of the TSC counter on
   32bit kernel - perhaps TSC is not reset by a warm reset?

2: TSC and Jiffies are no incrementing together properly.  Either
   jiffies increment too quickly or Time Stamp Counter isn't incremented
   in during an SMI but the real time clock is and jiffies are
   incremented.

Case 1 can result in a factor of 16 too large a value which makes udelay()
values too small and can cause mysterious driver errors.  Case 2 appears
to give smaller 10-15% errors after averaging but enough to cause
occasional failures on my own board

I have tested this code on my own branch and attach patch suitable for
current kernel code.  See below for examples of the failures and how the
fix handles these situations now.

I reported this issue earlier here:
     Intermittent problem with BogoMIPs calculation on Intel AP CPUs -
http://marc.info/?l=linux-kernel&m=129947246316875&w=4

I suspect this issue has been seen by others but as it is intermittent and
bogoMIPS for secondary CPUs are no longer printed out it might have been
difficult to identify this as the cause.  Perhaps these unresolved issues,
although quite old, might be relevant as possibly this fault has been
around for a while.  In particular Case 1 may only be relevant to 32bit
kernels on newer HW (most people run 64bit kernels?).  Case 2 is less
dramatic since the earlier fix in this area and also intermittent.

   Re: bogomips discrepancy on Intel Core2 Quad CPU -
http://marc.info/?l=linux-kernel&m=118929277524298&w=4
   slow system and bogus bogomips  -
http://marc.info/?l=linux-kernel&m=116791286716107&w=4
   Re: Re: [RFC-PATCH] clocksource: update lpj if clocksource has -
http://marc.info/?l=linux-kernel&m=128952775819467&w=4

This issue is masked a little by commit feae3203d711db0a ("timers, init:
Limit the number of per cpu calibration bootup messages") which only
prints out the first bogoMIPS value making it much harder to notice other
values differing.  Perhaps it should be changed to only suppress them when
they are similar values?

Here are some outputs showing faults occurring and the new code handling
them properly.  See my earlier message for examples of the original
failure.

    Case 1:   A Time Stamp Counter wrap:
...
Calibrating delay loop (skipped), value calculated using timer
frequency.. 6332.70 BogoMIPS (lpj=31663540)
....
calibrate_delay_direct() timer_rate_max=31666493
timer_rate_min=31666151 pre_start=4170369255 pre_end=4202035539
calibrate_delay_direct() timer_rate_max=2425955274
timer_rate_min=2425954941 pre_start=4265368533 pre_end=2396356387
calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap
around start=4265368581 >=post_end=2396356511
calibrate_delay_direct() timer_rate_max=31666274
timer_rate_min=31665942 pre_start=2440373374 pre_end=2472039515
calibrate_delay_direct() timer_rate_max=31666492
timer_rate_min=31666160 pre_start=2535372139 pre_end=2567038422
calibrate_delay_direct() timer_rate_max=31666455
timer_rate_min=31666207 pre_start=2630371084 pre_end=2662037415
Calibrating delay using timer specific routine.. 6333.28 BogoMIPS (lpj=31666428)
Total of 2 processors activated (12665.99 BogoMIPS).
....

    Case 2:  Some thing (presumably the SMM interrupt?) causing the
very low increase in TSC counter for the DELAY_CALIBRATION_TICKS
increase in jiffies
...
Calibrating delay loop (skipped), value calculated using timer
frequency.. 6333.25 BogoMIPS (lpj=31666270)
...
calibrate_delay_direct() timer_rate_max=31666483
timer_rate_min=31666074 pre_start=4199536526 pre_end=4231202809
calibrate_delay_direct() timer_rate_max=864348 timer_rate_min=864016
pre_start=2405343672 pre_end=2406207897
calibrate_delay_direct() timer_rate_max=31666483
timer_rate_min=31666179 pre_start=2469540464 pre_end=2501206823
calibrate_delay_direct() timer_rate_max=31666511
timer_rate_min=31666122 pre_start=2564539400 pre_end=2596205712
calibrate_delay_direct() timer_rate_max=31666084
timer_rate_min=31665685 pre_start=2659538782 pre_end=2691204657
calibrate_delay_direct() dropping min bogoMips estimate 1 = 864348
Calibrating delay using timer specific routine.. 6333.27 BogoMIPS (lpj=31666390)
Total of 2 processors activated (12666.53 BogoMIPS).
...

After 70 boots I saw 2 variations <1% slip through

Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/calibrate.c |   70 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 5 deletions(-)

diff -puN init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure init/calibrate.c
--- a/init/calibrate.c~init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure
+++ a/init/calibrate.c
@@ -38,6 +38,9 @@ static unsigned long __cpuinit calibrate
 	unsigned long timer_rate_min, timer_rate_max;
 	unsigned long good_timer_sum = 0;
 	unsigned long good_timer_count = 0;
+	unsigned long measured_times[MAX_DIRECT_CALIBRATION_RETRIES];
+	int max = -1; /* index of measured_times with max/min values or not set */
+	int min = -1;
 	int i;
 
 	if (read_current_timer(&pre_start) < 0 )
@@ -90,17 +93,74 @@ static unsigned long __cpuinit calibrate
 		 * If the upper limit and lower limit of the timer_rate is
 		 * >= 12.5% apart, redo calibration.
 		 */
-		if (pre_start != 0 && pre_end != 0 &&
+		printk(KERN_DEBUG
+"calibrate_delay_direct() timer_rate_max=%lu timer_rate_min=%lu pre_start=%lu pre_end=%lu\n",
+			  timer_rate_max, timer_rate_min, pre_start, pre_end);
+		if (start >= post_end)
+			printk(KERN_NOTICE
+				"calibrate_delay_direct() ignoring timer_rate as we had a TSC wrap around start=%lu >=post_end=%lu\n",
+				start, post_end);
+		if (start < post_end && pre_start != 0 && pre_end != 0 &&
 		    (timer_rate_max - timer_rate_min) < (timer_rate_max >> 3)) {
 			good_timer_count++;
 			good_timer_sum += timer_rate_max;
-		}
+			measured_times[i] = timer_rate_max;
+			if (max < 0 || timer_rate_max > measured_times[max])
+				max = i;
+			if (min < 0 || timer_rate_max < measured_times[min])
+				min = i;
+		} else
+			measured_times[i] = 0;
+
 	}
 
-	if (good_timer_count)
-		return (good_timer_sum/good_timer_count);
+	/*
+	 * Find the maximum & minimum - if they differ too much throw out the one with
+	 * the largest difference from the mean and try again...
+	 */
+	while (good_timer_count > 1) {
+		unsigned long estimate;
+		unsigned long maxdiff;
+
+		/* compute the estimate */
+		estimate = (good_timer_sum/good_timer_count);
+		maxdiff = estimate >> 3;
+
+		/* if range is within 12% let's take it */
+		if ((measured_times[max] - measured_times[min]) < maxdiff)
+			return (estimate);
+
+		/* ok - drop the worse value and try again... */
+		good_timer_sum = 0;
+		good_timer_count = 0;
+		if ((measured_times[max] - estimate) < (estimate - measured_times[min])) {
+			printk(KERN_NOTICE
+	"calibrate_delay_direct() dropping min bogoMips estimate %d = %lu\n",
+				min, measured_times[min]);
+			measured_times[min] = 0;
+			min = max;
+		} else {
+			printk(KERN_NOTICE
+	"calibrate_delay_direct() dropping max bogoMips estimate %d = %lu\n",
+				max, measured_times[max]);
+			measured_times[max] = 0;
+			max = min;
+		}
+
+		for (i = 0; i < MAX_DIRECT_CALIBRATION_RETRIES; i++) {
+			if (measured_times[i] == 0)
+				continue;
+			good_timer_count++;
+			good_timer_sum += measured_times[i];
+			if (measured_times[i] < measured_times[min])
+				min = i;
+			if (measured_times[i] > measured_times[max])
+				max = i;
+		}
+
+	}
 
-	printk(KERN_WARNING "calibrate_delay_direct() failed to get a good "
+	printk(KERN_NOTICE "calibrate_delay_direct() failed to get a good "
 	       "estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
 	return 0;
 }
_

Patches currently in -mm which might be from amworsley@gmail.com are

init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-checkpatch-fixes.patch
init-calibratec-fix-for-critical-bogomips-intermittent-calculation-failure-fix.patch

