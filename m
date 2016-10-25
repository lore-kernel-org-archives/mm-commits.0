From: akpm@linux-foundation.org
Subject: + ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 25 Oct 2016 16:02:49 -0700
Message-ID: <580fe499.xf3EvPU/T8ok0zxi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40316 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754167AbcJYXCu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 19:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

