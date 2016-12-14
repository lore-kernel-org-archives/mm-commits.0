From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-sem-rework-task-wakeups-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 14 Dec 2016 14:29:53 -0800
Message-ID: <5851c7e1.P1tXQV7y6vVcgA83%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933714AbcLNW3F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 17:29:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-sem-rework-task-wakeups-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-sem-rework-task-wakeups-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-sem-rework-task-wakeups.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-sem-rework-task-wakeups-checkpatch-fixes

WARNING: line over 80 characters
#241: FILE: ipc/sem.c:815:
+				semop_completed |= wake_const_ops(sma, num, wake_q);

WARNING: line over 80 characters
#250: FILE: ipc/sem.c:826:
+				semop_completed |= wake_const_ops(sma, i, wake_q);

WARNING: line over 80 characters
#282: FILE: ipc/sem.c:857:
+static int update_queue(struct sem_array *sma, int semnum, struct wake_q_head *wake_q)

WARNING: line over 80 characters
#344: FILE: ipc/sem.c:973:
+							      sops[i].sem_num, wake_q);

WARNING: Missing a blank line after declarations
#405: FILE: ipc/sem.c:1242:
+	int err, val;
+	WAKE_Q(wake_q);

WARNING: line over 80 characters
#570: FILE: ipc/sem.c:1920:
+	 * We _do_ care, nonetheless, about being awoken by a signal or spuriously.

total: 0 errors, 6 warnings, 567 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ipc-sem-rework-task-wakeups.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN ipc/sem.c~ipc-sem-rework-task-wakeups-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-sem-rework-task-wakeups-checkpatch-fixes
+++ a/ipc/sem.c
@@ -1917,10 +1917,11 @@ sleep_again:
 	 * fastpath: the semop has completed, either successfully or not, from
 	 * the syscall pov, is quite irrelevant to us at this point; we're done.
 	 *
-	 * We _do_ care, nonetheless, about being awoken by a signal or spuriously.
-	 * The queue.status is checked again in the slowpath (aka after taking
-	 * sem_lock), such that we can detect scenarios where we were awakened
-	 * externally, during the window between wake_q_add() and wake_up_q().
+	 * We _do_ care, nonetheless, about being awoken by a signal or
+	 * spuriously.  The queue.status is checked again in the slowpath (aka
+	 * after taking sem_lock), such that we can detect scenarios where we
+	 * were awakened externally, during the window between wake_q_add() and
+	 * wake_up_q().
 	 */
 	error = READ_ONCE(queue.status);
 	if (error != -EINTR) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch

