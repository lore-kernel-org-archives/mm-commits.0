From: akpm@linux-foundation.org
Subject: + sched-implement-staircase-deadline-scheduler-rework-priomatrix.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:35:39 -0700
Message-ID: <200704132135.l3DLZdVA009994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53466 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030599AbXDMVfn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:35:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org


The patch titled
     sched: implement staircase deadline scheduler rework priomatrix
has been added to the -mm tree.  Its filename is
     sched-implement-staircase-deadline-scheduler-rework-priomatrix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: implement staircase deadline scheduler rework priomatrix
From: Con Kolivas <kernel@kolivas.org>

Rework the priority matrix used by the staircase-deadline cpu scheduler.

Ensuring every nice level uses priority slot 139 means that niced tasks will
not cause expiration prematurely for less niced tasks that have been sleeping.

This also increases the frequency less niced tasks preempt niced tasks, and
simplifies greatly the code that generates the priority matrix.

Update the documentation accordingly and explain why the priority matrix
exists in the first place.

Signed-off-by: Con Kolivas <kernel@kolivas.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff -puN kernel/sched.c~sched-implement-staircase-deadline-scheduler-rework-priomatrix kernel/sched.c
--- a/kernel/sched.c~sched-implement-staircase-deadline-scheduler-rework-priomatrix
+++ a/kernel/sched.c
@@ -112,15 +112,19 @@ int rr_interval __read_mostly;
  * for the valid priorities each different nice level can have. It allows
  * us to stagger the slots where differing priorities run in a way that
  * keeps latency differences between different nice levels at a minimum.
+ * The purpose of a pre-generated matrix is for rapid lookup of next slot in
+ * O(1) time without having to recalculate every time priority gets demoted.
+ * All nice levels use priority slot 39 as this allows less niced tasks to
+ * get all priority slots better than that before expiration is forced.
  * ie, where 0 means a slot for that priority, priority running from left to
- * right:
+ * right is from prio 0 to prio 39:
  * nice -20 0000000000000000000000000000000000000000
- * nice -10 1001000100100010001001000100010010001000
- * nice   0 0101010101010101010101010101010101010101
- * nice   5 1101011010110101101011010110101101011011
- * nice  10 0110111011011101110110111011101101110111
- * nice  15 0111110111111011111101111101111110111111
- * nice  19 1111111111111111111011111111111111111111
+ * nice -10 1000100010001000100010001000100010010000
+ * nice   0 1010101010101010101010101010101010101010
+ * nice   5 1011010110110101101101011011010110110110
+ * nice  10 1110111011101110111011101110111011101110
+ * nice  15 1111111011111110111111101111111011111110
+ * nice  19 1111111111111111111111111111111111111110
  */
 static unsigned long prio_matrix[PRIO_RANGE][BITS_TO_LONGS(PRIO_RANGE)]
 				 __read_mostly;
@@ -6870,20 +6874,11 @@ void __init sched_init(void)
 
 	/* Generate the priority matrix */
 	for (i = 0; i < PRIO_RANGE; i++) {
-		if (i < 20) {
-			bitmap_zero(prio_matrix[i] , PRIO_RANGE);
-			j = PRIO_RANGE * PRIO_RANGE / (i + 1);
-			for (k = j; k < PRIO_RANGE * PRIO_RANGE; k += j)
-				__set_bit(k / PRIO_RANGE, prio_matrix[i]);
-		} else if (i == 20) {
-			bitmap_fill(prio_matrix[i], PRIO_RANGE);
-			for (k = 1; k < PRIO_RANGE; k += 2)
-				__clear_bit(k, prio_matrix[i]);
-		} else {
-			bitmap_fill(prio_matrix[i], PRIO_RANGE);
-			j = PRIO_RANGE * PRIO_RANGE / (PRIO_RANGE - i + 1);
-			for (k = j; k < PRIO_RANGE * PRIO_RANGE; k += j)
-				__clear_bit(k / PRIO_RANGE, prio_matrix[i]);
+		bitmap_fill(prio_matrix[i], PRIO_RANGE);
+		j = PRIO_RANGE * PRIO_RANGE / (PRIO_RANGE - i);
+		for (k = 0; k <= PRIO_RANGE * (PRIO_RANGE - 1); k += j) {
+			__clear_bit(PRIO_RANGE - 1 - (k / PRIO_RANGE),
+				    prio_matrix[i]);
 		}
 	}
 
_

Patches currently in -mm which might be from kernel@kolivas.org are

sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array-update.patch
sched-dont-renice-kernel-threads.patch
sched-remove-sleepavg-from-proc.patch
revert-sched-redundant-reschedule-when-set_user_nice-boosts-a-prio-of-a-task-from-the-expired-array.patch
sched-implement-staircase-deadline-cpu-scheduler.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
sched-implement-staircase-deadline-cpu-scheduler-improvements-fix.patch
sched-implement-staircase-deadline-cpu-scheduler-avoid-redundant-reschedule-in-set_user_nice.patch
sched-implement-staircase-deadline-cpu-scheduler-tweak.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix.patch
sched-remove-noninteractive-flag.patch
sched-document-sd-cpu-scheduler.patch
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
