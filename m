From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch removed
 from -mm tree
Date: Tue, 11 Oct 2016 13:38:58 -0700
Message-ID: <57fd4de2.Q/z3Y7pp/v9uJ3++%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37724 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753121AbcJKUpu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:45:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-msg-avoid-waking-sender-upon-full-queue.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes

WARNING: braces {} are not necessary for single statement blocks
#134: FILE: ipc/msg.c:679:
+		if (msg_fits_inqueue(msq, msgsz)) {
 			break;
 		}

total: 0 errors, 1 warnings, 118 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ipc-msg-avoid-waking-sender-upon-full-queue.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN ipc/msg.c~ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes ipc/msg.c
--- a/ipc/msg.c~ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes
+++ a/ipc/msg.c
@@ -676,9 +676,8 @@ long do_msgsnd(int msqid, long mtype, vo
 		if (err)
 			goto out_unlock0;
 
-		if (msg_fits_inqueue(msq, msgsz)) {
+		if (msg_fits_inqueue(msq, msgsz))
 			break;
-		}
 
 		/* queue full, wait: */
 		if (msgflg & IPC_NOWAIT) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

ipc-msg-avoid-waking-sender-upon-full-queue.patch
hung_task-allow-hung_task_panic-when-hung_task_warnings-is-0-fix.patch
fs-use-mapping_set_error-instead-of-opencoded-set_bit-fix.patch

