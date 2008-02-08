From: akpm@linux-foundation.org
Subject: - aio-partial-write-should-not-return-error-code.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:18:43 -0800
Message-ID: <200802082018.m18KIO01010920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752060AbYBHUtG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:49:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: partial write should not return error code
has been removed from the -mm tree.  Its filename was
     aio-partial-write-should-not-return-error-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: partial write should not return error code
From: Rusty Russell <rusty@rustcorp.com.au>

When an AIO write gets an error after writing some data (eg.  ENOSPC), it
should return the amount written already, not the error.  Just like write()
is supposed to.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-By: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/aio.c~aio-partial-write-should-not-return-error-code fs/aio.c
--- a/fs/aio.c~aio-partial-write-should-not-return-error-code
+++ a/fs/aio.c
@@ -1347,6 +1347,13 @@ static ssize_t aio_rw_vect_retry(struct 
 	if ((ret == 0) || (iocb->ki_left == 0))
 		ret = iocb->ki_nbytes - iocb->ki_left;
 
+	/* If we managed to write some out we return that, rather than
+	 * the eventual error. */
+	if (opcode == IOCB_CMD_PWRITEV
+	    && ret < 0 && ret != -EIOCBQUEUED && ret != -EIOCBRETRY
+	    && iocb->ki_nbytes - iocb->ki_left)
+		ret = iocb->ki_nbytes - iocb->ki_left;
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
reiser4.patch
