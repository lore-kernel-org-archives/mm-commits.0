From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch removed from
 -mm tree
Date: Wed, 14 Dec 2016 14:30:17 -0800
Message-ID: <5851c7f9./95T3CdZDpxoGNwC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60800 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933465AbcLNW33 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 17:29:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-sem-optimize-perform_atomic_semop.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes

WARNING: Missing a blank line after declarations
#132: FILE: ipc/sem.c:747:
+			int undo = un->semadj[sop->sem_num] - sem_op;
+			un->semadj[sop->sem_num] = undo;

ERROR: spaces required around that '?' (ctx:VxW)
#142: FILE: ipc/sem.c:757:
+	return sop->sem_flg & IPC_NOWAIT? -EAGAIN : 1;
 	                                ^

total: 1 errors, 1 warnings, 171 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ipc-sem-optimize-perform_atomic_semop.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN ipc/sem.c~ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes
+++ a/ipc/sem.c
@@ -744,6 +744,7 @@ static int perform_atomic_semop(struct s
 
 		if (sop->sem_flg & SEM_UNDO) {
 			int undo = un->semadj[sop->sem_num] - sem_op;
+
 			un->semadj[sop->sem_num] = undo;
 		}
 		curr->semval += sem_op;
@@ -754,7 +755,7 @@ static int perform_atomic_semop(struct s
 
 would_block:
 	q->blocking = sop;
-	return sop->sem_flg & IPC_NOWAIT? -EAGAIN : 1;
+	return sop->sem_flg & IPC_NOWAIT ? -EAGAIN : 1;
 }
 
 static inline void wake_up_sem_queue_prepare(struct sem_queue *q, int error,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-optimize-perform_atomic_semop.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch

