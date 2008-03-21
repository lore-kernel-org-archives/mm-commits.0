From: akpm@linux-foundation.org
Subject: - aio-bad-aio-race-in-aio_complete-leads-to-process-hang.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:28:54 -0700
Message-ID: <200803212028.m2LKSsxd008746@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759054AbYCUUaG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:30:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: qbarnes+linux@yahoo-inc.com, bcrl@kvack.org, nickpiggin@yahoo.com.au, stable@kernel.org, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: bad AIO race in aio_complete() leads to process hang
has been removed from the -mm tree.  Its filename was
     aio-bad-aio-race-in-aio_complete-leads-to-process-hang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: bad AIO race in aio_complete() leads to process hang
From: Quentin Barnes <qbarnes+linux@yahoo-inc.com>

My group ran into a AIO process hang on a 2.6.24 kernel with the process
sleeping indefinitely in io_getevents(2) waiting for the last wakeup to come
and it never would.

We ran the tests on x86_64 SMP.  The hang only occurred on a Xeon box
("Clovertown") but not a Core2Duo ("Conroe").  On the Xeon, the L2 cache isn't
shared between all eight processors, but is L2 is shared between between all
two processors on the Core2Duo we use.

My analysis of the hang is if you go down to the second while-loop
in read_events(), what happens on processor #1:
	1) add_wait_queue_exclusive() adds thread to ctx->wait
	2) aio_read_evt() to check tail
	3) if aio_read_evt() returned 0, call [io_]schedule() and sleep

In aio_complete() with processor #2:
	A) info->tail = tail;
	B) waitqueue_active(&ctx->wait)
	C) if waitqueue_active() returned non-0, call wake_up()

The way the code is written, step 1 must be seen by all other processors
before processor 1 checks for pending events in step 2 (that were recorded by
step A) and step A by processor 2 must be seen by all other processors
(checked in step 2) before step B is done.

The race I believed I was seeing is that steps 1 and 2 were
effectively swapped due to the __list_add() being delayed by the L2
cache not shared by some of the other processors.  Imagine:
proc 2: just before step A
proc 1, step 1: adds to ctx->wait, but is not visible by other processors yet
proc 1, step 2: checks tail and sees no pending events
proc 2, step A: updates tail
proc 1, step 3: calls [io_]schedule() and sleeps
proc 2, step B: checks ctx->wait, but sees no one waiting, skips wakeup
                so proc 1 sleeps indefinitely

My patch adds a memory barrier between steps A and B.  It ensures that the
update in step 1 gets seen on processor 2 before continuing.  If processor 1
was just before step 1, the memory barrier makes sure that step A (update
tail) gets seen by the time processor 1 makes it to step 2 (check tail).

Before the patch our AIO process would hang virtually 100% of the time.  After
the patch, we have yet to see the process ever hang.

Signed-off-by: Quentin Barnes <qbarnes+linux@yahoo-inc.com>
Reviewed-by: Zach Brown <zach.brown@oracle.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: <stable@kernel.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/aio.c~aio-bad-aio-race-in-aio_complete-leads-to-process-hang fs/aio.c
--- a/fs/aio.c~aio-bad-aio-race-in-aio_complete-leads-to-process-hang
+++ a/fs/aio.c
@@ -996,6 +996,14 @@ put_rq:
 	/* everything turned out well, dispose of the aiocb. */
 	ret = __aio_put_req(ctx, iocb);
 
+	/*
+	 * We have to order our ring_info tail store above and test
+	 * of the wait list below outside the wait lock.  This is
+	 * like in wake_up_bit() where clearing a bit has to be
+	 * ordered with the unlocked test.
+	 */
+	smp_mb();
+
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 
_

Patches currently in -mm which might be from qbarnes+linux@yahoo-inc.com are

origin.patch

