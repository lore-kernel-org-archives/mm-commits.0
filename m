From: akpm@google.com
Subject: [obsolete] ipc-semc-replace-busy-loop-with-completion-checkpatch-fixes.patch removed from -mm tree
Date: Mon, 17 Oct 2011 14:55:55 -0700
Message-ID: <201110172155.p9HLttTU017148@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:18438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1JQVz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2011 17:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@google.com, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-semc-replace-busy-loop-with-completion-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-semc-replace-busy-loop-with-completion-checkpatch-fixes.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@google.com>
Subject: ipc-semc-replace-busy-loop-with-completion-checkpatch-fixes

Cc: Manfred Spraul <manfred@colorfullife.com>

WARNING: please, no space before tabs
#75: FILE: ipc/sem.c:208:
+ *   ^I* if it's not -EINTR, then it must wait on q->done.$

WARNING: please, no space before tabs
#76: FILE: ipc/sem.c:209:
+ *   ^I* After the completion was signaled:$

WARNING: please, no space before tabs
#77: FILE: ipc/sem.c:210:
+ *   ^I  - if it's not -EINTR, then the operation was completed by$

WARNING: please, no space before tabs
#81: FILE: ipc/sem.c:213:
+ *   ^I  - otherwise it must acquire the spinlock and do the cleanup$

WARNING: braces {} are not necessary for single statement blocks
#205: FILE: ipc/sem.c:1420:
+		if (!IS_ERR(sma)) {
+			sem_unlock(sma);
+		}

total: 0 errors, 5 warnings, 170 lines checked

./patches/ipc-semc-replace-busy-loop-with-completion.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 ipc/sem.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN ipc/sem.c~ipc-semc-replace-busy-loop-with-completion-checkpatch-fixes ipc/sem.c
--- a/ipc/sem.c~ipc-semc-replace-busy-loop-with-completion-checkpatch-fixes
+++ a/ipc/sem.c
@@ -205,12 +205,12 @@ static inline void sem_rmid(struct ipc_n
  *	* call wake_up_process
  *	* complete_all(&q->done);
  * - the previously blocked thread checks queue.status:
- *   	* if it's not -EINTR, then it must wait on q->done.
- *   	* After the completion was signaled:
- *   	  - if it's not -EINTR, then the operation was completed by
- *   	  update_queue. semtimedop can return queue.status without
- *   	  performing any operation on the sem array.
- *   	  - otherwise it must acquire the spinlock and do the cleanup
+ *	* if it's not -EINTR, then it must wait on q->done.
+ *	* After the completion was signaled:
+ *	  - if it's not -EINTR, then the operation was completed by
+ *	    update_queue. semtimedop can return queue.status without
+ *	    performing any operation on the sem array.
+ *	  - otherwise it must acquire the spinlock and do the cleanup
  *
  * The completion is necessary to protect against the following
  * races:
@@ -1417,9 +1417,8 @@ sleep_again:
 	error = queue.status;
 	if (error != -EINTR) {
 		/* If there is a return code, then we can leave immediately. */
-		if (!IS_ERR(sma)) {
+		if (!IS_ERR(sma))
 			sem_unlock(sma);
-		}
 		/* Except that we must wait for the hands-off */
 		wait_for_completion(&queue.done);
 		goto out_free;
_

Patches currently in -mm which might be from akpm@google.com are

origin.patch
linux-next.patch
drivers-net-ethernet-i825xx-3c505c-fix-build-with-dynamic-debug.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem-checkpatch-fixes.patch
loop-cleanup-set_status-interface-checkpatch-fixes.patch
revert-treewide-use-__printf-not-__attribute__formatprintf.patch
leds-leds-lp5521-avoid-writing-uninitialized-value-to-lp5521_reg_op_mode-register-fix.patch

