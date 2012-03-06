From: akpm@linux-foundation.org
Subject: [merged] aio-wake-up-waiters-when-freeing-unused-kiocbs.patch removed from -mm tree
Date: Tue, 06 Mar 2012 11:34:52 -0800
Message-ID: <20120306193452.8634CA02EB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:50737 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab2CFTey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Mar 2012 14:34:54 -0500
Received: by mail-fa0-f74.google.com with SMTP id a19so206961faa.1
        for <mm-commits@vger.kernel.org>; Tue, 06 Mar 2012 11:34:53 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, bvanassche@acm.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: aio: wake up waiters when freeing unused kiocbs
has been removed from the -mm tree.  Its filename was
     aio-wake-up-waiters-when-freeing-unused-kiocbs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jeff Moyer <jmoyer@redhat.com>
Subject: aio: wake up waiters when freeing unused kiocbs

Bart Van Assche reported a hung fio process when either hot-removing
storage or when interrupting the fio process itself.  The (pruned) call
trace for the latter looks like so:

fio             D 0000000000000001     0  6849   6848 0x00000004
 ffff880092541b88 0000000000000046 ffff880000000000 ffff88012fa11dc0
 ffff88012404be70 ffff880092541fd8 ffff880092541fd8 ffff880092541fd8
 ffff880128b894d0 ffff88012404be70 ffff880092541b88 000000018106f24d
Call Trace:
 [<ffffffff813b683f>] schedule+0x3f/0x60
 [<ffffffff813b68ef>] io_schedule+0x8f/0xd0
 [<ffffffff81174410>] wait_for_all_aios+0xc0/0x100
 [<ffffffff81175385>] exit_aio+0x55/0xc0
 [<ffffffff810413cd>] mmput+0x2d/0x110
 [<ffffffff81047c1d>] exit_mm+0x10d/0x130
 [<ffffffff810482b1>] do_exit+0x671/0x860
 [<ffffffff81048804>] do_group_exit+0x44/0xb0
 [<ffffffff81058018>] get_signal_to_deliver+0x218/0x5a0
 [<ffffffff81002065>] do_signal+0x65/0x700
 [<ffffffff81002785>] do_notify_resume+0x65/0x80
 [<ffffffff813c0333>] int_signal+0x12/0x17

The problem lies with the allocation batching code.  It will
opportunistically allocate kiocbs, and then trim back the list of iocbs
when there is not enough room in the completion ring to hold all of the
events.  In the case above, what happens is that the pruning back of
events ends up freeing up the last active request and the context is
marked as dead, so it is thus responsible for waking up waiters. 
Unfortunately, the code does not check for this condition, so we end up
with a hung task.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Cc: <stable@kernel.org>		[3.2.x only]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/aio.c~aio-wake-up-waiters-when-freeing-unused-kiocbs fs/aio.c
--- a/fs/aio.c~aio-wake-up-waiters-when-freeing-unused-kiocbs
+++ a/fs/aio.c
@@ -490,6 +490,8 @@ static void kiocb_batch_free(struct kioc
 		kmem_cache_free(kiocb_cachep, req);
 		ctx->reqs_active--;
 	}
+	if (unlikely(!ctx->reqs_active && ctx->dead))
+		wake_up_all(&ctx->wait);
 	spin_unlock_irq(&ctx->ctx_lock);
 }
 
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch
linux-next.patch

