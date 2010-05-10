From: akpm@linux-foundation.org
Subject: + cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor.patch added to -mm tree
Date: Mon, 10 May 2010 14:38:59 -0700
Message-ID: <201005102138.o4ALcx9T024168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757299Ab0EJVjC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 May 2010 17:39:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, czoccolo@gmail.com


The patch titled
     cpuidle: add a repeating pattern detector to the menu governor
has been added to the -mm tree.  Its filename is
     cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor.patch

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
Subject: cpuidle: add a repeating pattern detector to the menu governor
From: Arjan van de Ven <arjan@linux.intel.com>

Currently, the menu governor uses the (corrected) next timer as key item
for predicting the idle duration.

It turns out that there are specific cases where this breaks down: There
are cases where we have a very repetitive pattern of idle durations, where
the idle period is pretty much the same, for reasons completely unrelated
to the next timer event.  Examples of such repeating patterns are network
loads with irq mitigation, the mouse moving but in theory also the wifi
beacons.

This patch adds a relatively simple detector for such repeating patterns,
where the standard deviation of the last 8 idle periods is compared to a
threshold.

With this extra predictor in place, measurements show that the DECAY
factor can now be increased (the decaying average will now decay slower)
to get an even more stable result.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   60 ++++++++++++++++++++++++++++-
 1 file changed, 59 insertions(+), 1 deletion(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor
+++ a/drivers/cpuidle/governors/menu.c
@@ -21,9 +21,12 @@
 #include <linux/math64.h>
 
 #define BUCKETS 12
+#define INTERVALS 8
 #define RESOLUTION 1024
-#define DECAY 4
+#define DECAY 8
 #define MAX_INTERESTING 50000
+#define STDDEV_THRESH 400
+
 
 /*
  * Concepts and ideas behind the menu governor
@@ -64,6 +67,16 @@
  * indexed based on the magnitude of the expected duration as well as the
  * "is IO outstanding" property.
  *
+ * Repeatable-interval-detector
+ * ----------------------------
+ * There are some cases where "next timer" is a completely unusable predictor:
+ * Those cases where the interval is fixed, for example due to hardware
+ * interrupt mitigation, but also due to fixed transfer rate devices such as
+ * mice.
+ * For this, we use a different predictor: We track the duration of the last 8
+ * intervals and if the stand deviation of these 8 intervals is below a
+ * threshold value, we use the average of these intervals as prediction.
+ *
  * Limiting Performance Impact
  * ---------------------------
  * C states, especially those with large exit latencies, can have a real
@@ -104,6 +117,8 @@ struct menu_device {
 	unsigned int	exit_us;
 	unsigned int	bucket;
 	u64		correction_factor[BUCKETS];
+	u32		intervals[INTERVALS];
+	int		interval_ptr;
 };
 
 
@@ -175,6 +190,42 @@ static u64 div_round64(u64 dividend, u32
 	return div_u64(dividend + (divisor / 2), divisor);
 }
 
+/*
+ * Try detecting repeating patterns by keeping track of the last 8
+ * intervals, and checking if the standard deviation of that set
+ * of points is below a threshold. If it is... then use the
+ * average of these 8 points as the estimated value.
+ */
+static void detect_repeating_patterns(struct menu_device *data)
+{
+	int i;
+	uint64_t avg = 0;
+	uint64_t stddev = 0; /* contains the square of the std deviation */
+
+	/* first calculate average and standard deviation of the past */
+	for (i = 0; i < INTERVALS; i++)
+		avg += data->intervals[i];
+
+	/* if the avg is beyond the known next tick, it's worthless */
+	if (avg > data->expected_us)
+		return;
+
+	avg = avg / INTERVALS;
+	for (i = 0; i < INTERVALS; i++)
+		stddev += (data->intervals[i] - avg) *
+			  (data->intervals[i] - avg);
+
+	stddev = stddev / INTERVALS;
+
+	/*
+	 * now.. if stddev is small.. then assume we have a
+	 * repeating pattern and predict we keep doing this.
+	 */
+
+	if (avg && stddev < STDDEV_THRESH)
+		data->predicted_us = avg;
+}
+
 /**
  * menu_select - selects the next idle state to enter
  * @dev: the CPU
@@ -218,6 +269,8 @@ static int menu_select(struct cpuidle_de
 	data->predicted_us = div_round64(data->expected_us * data->correction_factor[data->bucket],
 					 RESOLUTION * DECAY);
 
+	detect_repeating_patterns(data);
+
 	/*
 	 * We want to default to C1 (hlt), not to busy polling
 	 * unless the timer is happening really really soon.
@@ -310,6 +363,11 @@ static void menu_update(struct cpuidle_d
 		new_factor = 1;
 
 	data->correction_factor[data->bucket] = new_factor;
+
+	/* update the repeating-pattern data */
+	data->intervals[data->interval_ptr++] = last_idle_us;
+	if (data->interval_ptr >= INTERVALS)
+		data->interval_ptr = 0;
 }
 
 /**
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
cpuidle-add-a-repeating-pattern-detector-to-the-menu-governor.patch

