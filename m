From: akpm@linux-foundation.org
Subject: - sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:48:19 -0700
Message-ID: <200704301848.l3UImJfx011822@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56077 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946613AbXD3Ssy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kernel@kolivas.org, mm-commits@vger.kernel.org


The patch titled
     sched: implement staircase deadline scheduler rework priomatrix (doc)
has been removed from the -mm tree.  Its filename was
     sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch

This patch was dropped because I need to clear the decks

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
sched-implement-staircase-deadline-scheduler-rework-priomatrix-doc.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
sched-implement-staircase-deadline-scheduler-docupdate.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
swap-prefetch-avoid-repeating-entry.patch
