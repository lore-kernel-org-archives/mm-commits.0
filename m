From: akpm@linux-foundation.org
Subject: + aio-always-reinitialize-iocb-ki_run_list-at-the-end-of-aio_run_iocb.patch added to -mm tree
Date: Fri, 21 May 2010 14:47:44 -0700
Message-ID: <201005212147.o4LLli4G003392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758551Ab0EUVsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 May 2010 17:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: temerkhanov@yandex.ru, bcrl@kvack.org, jmoyer@redhat.com, temerkhanov@cifronik.ru, zach.brown@oracle.com


The patch titled
     aio: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
has been added to the -mm tree.  Its filename is
     aio-always-reinitialize-iocb-ki_run_list-at-the-end-of-aio_run_iocb.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: always reinitialize iocb->ki_run_list at the end of aio_run_iocb()
From: Sergey Temerkhanov <temerkhanov@yandex.ru>

Make aio_run_iocb() to always reinitialize iocb->ki_run_list (not only
when iocb->ki_retry() function returns -EIOCBRETRY) so that subsequent
call of kick_iocb() will succeed.

I've written the driver code which implements a zero-copy DMA char device.
 It has aio_read() and aio_write() methods which return -EIOCBQUEUED after
the successful preparation of the buffers described by kiocb and posting
it to the descriptor chain.  When the descriptors are processed, the DMA
engine raises the interrupt and the cleanup work is done in the handler,
including aio_complete() for the completed kiocbs.

This works fine, however, there is a problem with canceling the queued
requests, espesially on io_destroy() syscall.  Since there is no simple
way to remove single kiocb from the descriptor chain, I'm removing all of
them from the queue using aio_complete() or aio_put_req() in the
ki_cancel() callback routine of my driver.  The main problem is the
reference counting in aio_cancel_all():

		if (cancel) {
			iocb->ki_users++;
			spin_unlock_irq(&ctx->ctx_lock);
			cancel(iocb, &res);
			spin_lock_irq(&ctx->ctx_lock);
		}

Here the iocb->ki_users gets incremented which already has the value 1 at
this point (after the io_submit_one() completion) and it's never released
().  So I have to call aio_put_req() twice for the given kiocb (this seems
to be the hack to me) or I'll end up with the unkillable process stuck in
wait_for_all_aios() at the io_schedule().  I've posted the patches where
I've added aio_put_req() but I think it needs more testing.  So, I've
tried another approach (hack) - requeue the kiocb with kick_iocb() before
calling aio_put_req() in the ki_cancel() callback (that's because
aio_run_iocb() takes some special actions for the canceled kiocbs).  And
I've found out that kick_iocb() fails because aio_run_iocb() does this:

	iocb->ki_run_list.next = iocb->ki_run_list.prev = NULL;

and only reinitializes iocb->ki_run_list when iocb->ki_retry() returns
-EIOCBRETRY but kick_iocb() is exported and looks like intended for usage
(though not recommended).

The only place where I've found the similar approach to AIO in the device 
driver is drivers/usb/gadget/inode.c.

Signed-off-by: Sergey Temerkhanov <temerkhanov@cifronik.ru>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/aio.c~aio-always-reinitialize-iocb-ki_run_list-at-the-end-of-aio_run_iocb fs/aio.c
--- a/fs/aio.c~aio-always-reinitialize-iocb-ki_run_list-at-the-end-of-aio_run_iocb
+++ a/fs/aio.c
@@ -717,6 +717,9 @@ static ssize_t aio_run_iocb(struct kiocb
 out:
 	spin_lock_irq(&ctx->ctx_lock);
 
+	/* will make __queue_kicked_iocb succeed from here on */
+	INIT_LIST_HEAD(&iocb->ki_run_list);
+
 	if (-EIOCBRETRY == ret) {
 		/*
 		 * OK, now that we are done with this iteration
@@ -725,8 +728,6 @@ out:
 		 * "kick" can start the next iteration
 		 */
 
-		/* will make __queue_kicked_iocb succeed from here on */
-		INIT_LIST_HEAD(&iocb->ki_run_list);
 		/* we must queue the next iteration ourselves, if it
 		 * has already been kicked */
 		if (kiocbIsKicked(iocb)) {
_

Patches currently in -mm which might be from temerkhanov@yandex.ru are

aio-always-reinitialize-iocb-ki_run_list-at-the-end-of-aio_run_iocb.patch

