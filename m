From: akpm@linux-foundation.org
Subject: - aio-account-i-o-wait-time-properly.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:38 -0700
Message-ID: <200710180656.l9I6ucqR030717@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54901 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932619AbXJRHlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, bcrl@kvack.org, pbadari@us.ibm.com, suparna@in.ibm.com, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: account I/O wait time properly
has been removed from the -mm tree.  Its filename was
     aio-account-i-o-wait-time-properly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aio: account I/O wait time properly
From: Jeff Moyer <jmoyer@redhat.com>

Some months back I proposed changing the schedule() call in
read_events to an io_schedule():
	http://osdir.com/ml/linux.kernel.aio.general/2006-10/msg00024.html
This was rejected as there are AIO operations that do not initiate
disk I/O.  I've had another look at the problem, and the only AIO
operation that will not initiate disk I/O is IOCB_CMD_NOOP.  However,
this command isn't even wired up!

Given that it doesn't work, and hasn't for *years*, I'm going to
suggest again that we do proper I/O accounting when using AIO.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/aio.c~aio-account-i-o-wait-time-properly fs/aio.c
--- a/fs/aio.c~aio-account-i-o-wait-time-properly
+++ a/fs/aio.c
@@ -303,7 +303,7 @@ static void wait_for_all_aios(struct kio
 	set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 	while (ctx->reqs_active) {
 		spin_unlock_irq(&ctx->ctx_lock);
-		schedule();
+		io_schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
 		spin_lock_irq(&ctx->ctx_lock);
 	}
@@ -323,7 +323,7 @@ ssize_t fastcall wait_on_sync_kiocb(stru
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!iocb->ki_users)
 			break;
-		schedule();
+		io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 	return iocb->ki_user_data;
@@ -1170,7 +1170,7 @@ retry:
 			ret = 0;
 			if (to.timed_out)	/* Only check after read evt */
 				break;
-			schedule();
+			io_schedule();
 			if (signal_pending(tsk)) {
 				ret = -EINTR;
 				break;
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch
