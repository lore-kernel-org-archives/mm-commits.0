From: akpm@linux-foundation.org
Subject: - make-wait_on_retry_sync_kiocb-killable.patch removed from -mm tree
Date: Thu, 25 Oct 2007 13:51:41 -0700
Message-ID: <200710252051.l9PKpgdx023639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50046 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbXJYUwL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 16:52:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthew@wil.cx, nickpiggin@yahoo.com.au, pbadari@us.ibm.com, willy@linux.intel.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Make wait_on_retry_sync_kiocb killable
has been removed from the -mm tree.  Its filename was
     make-wait_on_retry_sync_kiocb-killable.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: Make wait_on_retry_sync_kiocb killable
From: Matthew Wilcox <matthew@wil.cx>

Use TASK_KILLABLE to allow wait_on_retry_sync_kiocb to return -EINTR.
All callers then check the return value and break out of their loops.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff -puN fs/read_write.c~make-wait_on_retry_sync_kiocb-killable fs/read_write.c
--- a/fs/read_write.c~make-wait_on_retry_sync_kiocb-killable
+++ a/fs/read_write.c
@@ -218,14 +218,15 @@ Einval:
 	return -EINVAL;
 }
 
-static void wait_on_retry_sync_kiocb(struct kiocb *iocb)
+static int wait_on_retry_sync_kiocb(struct kiocb *iocb)
 {
-	set_current_state(TASK_UNINTERRUPTIBLE);
+	set_current_state(TASK_KILLABLE);
 	if (!kiocbIsKicked(iocb))
 		schedule();
 	else
 		kiocbClearKicked(iocb);
 	__set_current_state(TASK_RUNNING);
+	return fatal_signal_pending(current) ? -EINTR : 0;
 }
 
 ssize_t do_sync_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
@@ -242,7 +243,9 @@ ssize_t do_sync_read(struct file *filp, 
 		ret = filp->f_op->aio_read(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
-		wait_on_retry_sync_kiocb(&kiocb);
+		ret = wait_on_retry_sync_kiocb(&kiocb);
+		if (ret)
+			break;
 	}
 
 	if (-EIOCBQUEUED == ret)
@@ -300,7 +303,9 @@ ssize_t do_sync_write(struct file *filp,
 		ret = filp->f_op->aio_write(&kiocb, &iov, 1, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
-		wait_on_retry_sync_kiocb(&kiocb);
+		ret = wait_on_retry_sync_kiocb(&kiocb);
+		if (ret)
+			break;
 	}
 
 	if (-EIOCBQUEUED == ret)
@@ -466,7 +471,9 @@ ssize_t do_sync_readv_writev(struct file
 		ret = fn(&kiocb, iov, nr_segs, kiocb.ki_pos);
 		if (ret != -EIOCBRETRY)
 			break;
-		wait_on_retry_sync_kiocb(&kiocb);
+		ret = wait_on_retry_sync_kiocb(&kiocb);
+		if (ret)
+			break;
 	}
 
 	if (ret == -EIOCBQUEUED)
_

Patches currently in -mm which might be from matthew@wil.cx are

use-wake_up_locked-in-eventpoll.patch
use-macros-instead-of-task_-flags.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
add-task_wakekill.patch
add-lock_page_killable.patch
make-wait_on_retry_sync_kiocb-killable.patch
hash-add-explicit-u32-and-u64-versions-of-hash.patch
make-sure-nobodys-leaking-resources.patch
