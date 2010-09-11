From: akpm@linux-foundation.org
Subject: + aio-do-not-return-erestartsys-as-a-result-of-aio-v2.patch added to -mm tree
Date: Fri, 10 Sep 2010 17:08:33 -0700
Message-ID: <201009110008.o8B08XNK010941@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337Ab0IKAJU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Sep 2010 20:09:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, hch@infradead.org, jmoyer@redhat.com, stable@kernel.org, zach.brown@oracle.com


The patch titled
     aio: do not return ERESTARTSYS as a result of AIO
has been added to the -mm tree.  Its filename is
     aio-do-not-return-erestartsys-as-a-result-of-aio-v2.patch

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
Subject: aio: do not return ERESTARTSYS as a result of AIO
From: Jan Kara <jack@suse.cz>

OCFS2 can return ERESTARTSYS from its write function when the process is
signalled while waiting for a cluster lock (and the filesystem is mounted
with intr mount option).  Generally, it seems reasonable to allow
filesystems to return this error code from its IO functions.  As we must
not leak ERESTARTSYS (and similar error codes) to userspace as a result of
an AIO operation, we have to properly convert it to EINTR inside AIO code
(restarting the syscall isn't really an option because other AIO could
have been already submitted by the same io_submit syscall).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-do-not-return-erestartsys-as-a-result-of-aio-v2 fs/aio.c
--- a/fs/aio.c~aio-do-not-return-erestartsys-as-a-result-of-aio-v2
+++ a/fs/aio.c
@@ -712,8 +712,16 @@ static ssize_t aio_run_iocb(struct kiocb
 	 */
 	ret = retry(iocb);
 
-	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED)
+	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
+		/*
+		 * There's no easy way to restart the syscall since other AIO's
+		 * may be already running. Just fail this IO with EINTR.
+		 */
+		if (unlikely(ret == -ERESTARTSYS || ret == -ERESTARTNOINTR ||
+			     ret == -ERESTARTNOHAND || ret == -ERESTART_RESTARTBLOCK))
+			ret = -EINTR;
 		aio_complete(iocb, ret, 0);
+	}
 out:
 	spin_lock_irq(&ctx->ctx_lock);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
aio-do-not-return-erestartsys-as-a-result-of-aio-v2.patch
reiser4.patch

