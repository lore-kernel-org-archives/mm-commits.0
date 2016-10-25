From: akpm@linux-foundation.org
Subject: + ipc-sem-rework-task-wakeups-checkpatch-fixes.patch added to -mm tree
Date: Tue, 25 Oct 2016 15:56:55 -0700
Message-ID: <580fe337.cpW76MHJI5mNXjhw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752987AbcJYW45 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 18:56:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-sem-rework-task-wakeups-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ipc-sem-rework-task-wakeups-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-rework-task-wakeups-checkpatch-fixes.patch

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

i-need-old-gcc.patch
mm-page_alloc-use-kern_cont-where-appropriate-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

