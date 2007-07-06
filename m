From: akpm@linux-foundation.org
Subject: - cpuidle-menu-governor-change-the-early-break-condition.patch removed from -mm tree
Date: Thu, 05 Jul 2007 17:51:31 -0700
Message-ID: <200707060051.l660pVcb028293@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53316 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760702AbXGFAvs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jul 2007 20:51:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: venkatesh.pallipadi@intel.com, mm-commits@vger.kernel.org


The patch titled
     cpuidle: menu governor change the early break condition
has been removed from the -mm tree.  Its filename was
     cpuidle-menu-governor-change-the-early-break-condition.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuidle: menu governor change the early break condition
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Change the C-state early break out algorithm in menu governor.

We only look at early breakouts that result in wakeups shorter than idle
state's target_residency.  If such a breakout is frequent enough, eliminate
the particular idle state upto a timeout period.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/governors/menu.c |   58 +++++++++++++++++++++--------
 1 files changed, 43 insertions(+), 15 deletions(-)

diff -puN drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-change-the-early-break-condition drivers/cpuidle/governors/menu.c
--- a/drivers/cpuidle/governors/menu.c~cpuidle-menu-governor-change-the-early-break-condition
+++ a/drivers/cpuidle/governors/menu.c
@@ -14,19 +14,20 @@
 #include <linux/hrtimer.h>
 #include <linux/tick.h>
 
-#define BM_HOLDOFF	20000	/* 20 ms */
+#define BM_HOLDOFF			20000	/* 20 ms */
+#define DEMOTION_THRESHOLD		5
+#define DEMOTION_TIMEOUT_MULTIPLIER	1000
 
 struct menu_device {
 	int		last_state_idx;
-	int		deepest_bm_state;
 
-	int		break_last_us;
-	int		break_elapsed_us;
+	int		deepest_break_state;
+	struct timespec break_expire_time_ts;
+	int		break_last_cnt;
 
+	int		deepest_bm_state;
 	int		bm_elapsed_us;
 	int		bm_holdoff_us;
-
-	unsigned long	idle_jiffies;
 };
 
 static DEFINE_PER_CPU(struct menu_device, menu_devices);
@@ -45,7 +46,6 @@ static int menu_select(struct cpuidle_de
 
 	/* determine the expected residency time */
 	expected_us = (s32) ktime_to_ns(tick_nohz_get_sleep_length()) / 1000;
-	expected_us = min(expected_us, data->break_last_us);
 
 	/* determine the maximum state compatible with current BM status */
 	if (cpuidle_get_bm_activity())
@@ -53,17 +53,33 @@ static int menu_select(struct cpuidle_de
 	if (data->bm_elapsed_us <= data->bm_holdoff_us)
 		max_state = data->deepest_bm_state + 1;
 
+	/* determine the maximum state compatible with recent idle breaks */
+	if (data->deepest_break_state >= 0) {
+		struct timespec now;
+		ktime_get_ts(&now);
+		if (timespec_compare(&data->break_expire_time_ts, &now) > 0) {
+			max_state = min(max_state,
+					data->deepest_break_state + 1);
+		} else {
+			data->deepest_break_state = -1;
+		}
+	}
+
 	/* find the deepest idle state that satisfies our constraints */
 	for (i = 1; i < max_state; i++) {
 		struct cpuidle_state *s = &dev->states[i];
+
 		if (s->target_residency > expected_us)
 			break;
+
 		if (s->exit_latency > system_latency_constraint())
 			break;
 	}
 
+	if (data->last_state_idx != i - 1)
+		data->break_last_cnt = 0;
+
 	data->last_state_idx = i - 1;
-	data->idle_jiffies = tick_nohz_get_idle_jiffies();
 	return i - 1;
 }
 
@@ -91,14 +107,27 @@ static void menu_reflect(struct cpuidle_
 		measured_us = USEC_PER_SEC / HZ;
 
 	data->bm_elapsed_us += measured_us;
-	data->break_elapsed_us += measured_us;
+
+	if (data->last_state_idx == 0)
+		return;
 
 	/*
-	 * Did something other than the timer interrupt cause the break event?
+	 * Did something other than the timer interrupt
+	 * cause an early break event?
 	 */
-	if (tick_nohz_get_idle_jiffies() == data->idle_jiffies) {
-		data->break_last_us = data->break_elapsed_us;
-		data->break_elapsed_us = 0;
+	if (unlikely(measured_us < target->target_residency)) {
+		if (data->break_last_cnt > DEMOTION_THRESHOLD) {
+			data->deepest_break_state = data->last_state_idx - 1;
+			ktime_get_ts(&data->break_expire_time_ts);
+			timespec_add_ns(&data->break_expire_time_ts,
+						target->target_residency *
+						DEMOTION_TIMEOUT_MULTIPLIER);
+		} else {
+			data->break_last_cnt++;
+		}
+	} else {
+		if (data->break_last_cnt > 0)
+			data->break_last_cnt--;
 	}
 }
 
@@ -112,10 +141,9 @@ static void menu_scan_device(struct cpui
 	int i;
 
 	data->last_state_idx = 0;
-	data->break_last_us = 0;
-	data->break_elapsed_us = 0;
 	data->bm_elapsed_us = 0;
 	data->bm_holdoff_us = BM_HOLDOFF;
+	data->deepest_break_state = -1;
 
 	for (i = 1; i < dev->state_count; i++)
 		if (dev->states[i].flags & CPUIDLE_FLAG_CHECK_BM)
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default-fix.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable-fix.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
git-newsetup.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
