From: akpm@linux-foundation.org
Subject: + aio-do-not-return-erestartsys-and-friends-from-aio.patch added to -mm tree
Date: Wed, 30 Jun 2010 12:33:57 -0700
Message-ID: <201006301933.o5UJXvoN022213@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756294Ab0F3Te2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jun 2010 15:34:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jack@suse.cz, bcrl@kvack.org, hch@lst.de, jmoyer@redhat.com, oleg@redhat.com, viro@zeniv.linux.org.uk, zach.brown@oracle.com


The patch titled
     aio: do not return -ERESTARTSYS (and friends) from AIO
has been added to the -mm tree.  Its filename is
     aio-do-not-return-erestartsys-and-friends-from-aio.patch

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
Subject: aio: do not return -ERESTARTSYS (and friends) from AIO
From: Jan Kara <jack@suse.cz>

We must not leak ERESTARTSYS (and similar error codes) to userspace as a
return value of IO.  Because other AIO could have been already submitted
by the same io_submit syscall, there is no easy way to restart the
syscall.  So we do not have much other options than fail the particular IO
with EINTR.

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/aio.c~aio-do-not-return-erestartsys-and-friends-from-aio fs/aio.c
--- a/fs/aio.c~aio-do-not-return-erestartsys-and-friends-from-aio
+++ a/fs/aio.c
@@ -712,8 +712,18 @@ static ssize_t aio_run_iocb(struct kiocb
 	 */
 	ret = retry(iocb);
 
-	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED)
+	if (ret != -EIOCBRETRY && ret != -EIOCBQUEUED) {
+		/*
+		 * There's no easy way to restart the syscall since other AIO's
+		 * may be already running. Just fail this IO with EINTR.
+		 */
+		if (unlikely(ret == -ERESTARTSYS ||
+			     ret == -ERESTARTNOINTR ||
+			     ret == -ERESTARTNOHAND ||
+			     ret == -ERESTART_RESTARTBLOCK))
+			ret = -EINTR;
 		aio_complete(iocb, ret, 0);
+	}
 out:
 	spin_lock_irq(&ctx->ctx_lock);
 
_

Patches currently in -mm which might be from jack@suse.cz are

origin.patch
linux-next.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged.patch
radix-tree-implement-function-radix_tree_range_tag_if_tagged-checkpatch-fixes.patch
mm-implement-writeback-livelock-avoidance-using-page-tagging.patch
aio-do-not-return-erestartsys-and-friends-from-aio.patch
reiser4.patch

