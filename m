From: akpm@linux-foundation.org
Subject: + sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:36:03 -0700
Message-ID: <200704132136.l3DLa3aG010005@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030801AbXDMVgF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:36:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kernel@kolivas.org


The patch titled
     sched: implement staircase deadline scheduler rework priomatrix (doc)
has been added to the -mm tree.  Its filename is
     sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sched: implement staircase deadline scheduler rework priomatrix (doc)
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

 Documentation/sched-design.txt |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff -puN Documentation/sched-design.txt~sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc Documentation/sched-design.txt
--- a/Documentation/sched-design.txt~sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc
+++ a/Documentation/sched-design.txt
@@ -268,13 +268,14 @@ there are 40 priority slots where a task
 and the allocation of slots is dependant on nice level. In the
 following table, a zero represents a slot where the task may run.
 
+PRIORITY:0..................20.................39
 nice -20 0000000000000000000000000000000000000000
-nice -10 1001000100100010001001000100010010001000
-nice   0 0101010101010101010101010101010101010101
-nice   5 1101011010110101101011010110101101011011
-nice  10 0110111011011101110110111011101101110111
-nice  15 0111110111111011111101111101111110111111
-nice  19 1111111111111111111011111111111111111111
+nice -10 1000100010001000100010001000100010010000
+nice   0 1010101010101010101010101010101010101010
+nice   5 1011010110110101101101011011010110110110
+nice  10 1110111011101110111011101110111011101110
+nice  15 1111111011111110111111101111111011111110
+nice  19 1111111111111111111111111111111111111110
 
 As can be seen, a nice -20 task runs in every priority slot whereas a nice 19
 task only runs one slot per major rotation. This dithered table allows for the
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
