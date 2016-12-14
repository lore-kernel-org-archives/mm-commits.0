From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch removed from -mm
 tree
Date: Wed, 14 Dec 2016 14:31:15 -0800
Message-ID: <5851c833.z7XOOPuIbiDr05q3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60814 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933349AbcLNWa1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 17:30:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-sem-simplify-wait-wake-loop-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-sem-simplify-wait-wake-loop.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-sem-simplify-wait-wake-loop-checkpatch-fixes

WARNING: line over 80 characters
#69: FILE: ipc/sem.c:1997:
+		 * fastpath: the semop has completed, either successfully or not, from

WARNING: line over 80 characters
#70: FILE: ipc/sem.c:1998:
+		 * the syscall pov, is quite irrelevant to us at this point; we're done.

WARNING: line over 80 characters
#73: FILE: ipc/sem.c:2001:
+		 * spuriously.  The queue.status is checked again in the slowpath (aka

WARNING: line over 80 characters
#74: FILE: ipc/sem.c:2002:
+		 * after taking sem_lock), such that we can detect scenarios where we

WARNING: line over 80 characters
#75: FILE: ipc/sem.c:2003:
+		 * were awakened externally, during the window between wake_q_add() and

WARNING: line over 80 characters
#84: FILE: ipc/sem.c:2009:
+			 * User space could assume that semop() is a memory barrier:

WARNING: line over 80 characters
#85: FILE: ipc/sem.c:2010:
+			 * Without the mb(), the cpu could speculatively read in user

WARNING: line over 80 characters
#86: FILE: ipc/sem.c:2011:
+			 * space stale data that was overwritten by the previous owner

total: 0 errors, 8 warnings, 127 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ipc-sem-simplify-wait-wake-loop.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff -puN ipc/sem.c~ipc-sem-simplify-wait-wake-loop-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-sem-simplify-wait-wake-loop-checkpatch-fixes
+++ a/ipc/sem.c
@@ -1994,22 +1994,23 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 			schedule();
 
 		/*
-		 * fastpath: the semop has completed, either successfully or not, from
-		 * the syscall pov, is quite irrelevant to us at this point; we're done.
+		 * fastpath: the semop has completed, either successfully or
+		 * not, from the syscall pov, is quite irrelevant to us at this
+		 * point; we're done.
 		 *
 		 * We _do_ care, nonetheless, about being awoken by a signal or
-		 * spuriously.  The queue.status is checked again in the slowpath (aka
-		 * after taking sem_lock), such that we can detect scenarios where we
-		 * were awakened externally, during the window between wake_q_add() and
-		 * wake_up_q().
+		 * spuriously.  The queue.status is checked again in the
+		 * slowpath (aka after taking sem_lock), such that we can detect
+		 * scenarios where we were awakened externally, during the
+		 * window between wake_q_add() and wake_up_q().
 		 */
 		error = READ_ONCE(queue.status);
 		if (error != -EINTR) {
 			/*
-			 * User space could assume that semop() is a memory barrier:
-			 * Without the mb(), the cpu could speculatively read in user
-			 * space stale data that was overwritten by the previous owner
-			 * of the semaphore.
+			 * User space could assume that semop() is a memory
+			 * barrier: Without the mb(), the cpu could
+			 * speculatively read in userspace stale data that was
+			 * overwritten by the previous owner of the semaphore.
 			 */
 			smp_mb();
 			goto out_free;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-simplify-wait-wake-loop.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch

