From: akpm@linux-foundation.org
Subject: - aio-negative-offset-should-return-einval.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:16:28 -0800
Message-ID: <200802082016.m18KG9sc010682@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40783 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756358AbYBHUrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:47:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, zach.brown@oracle.com, mm-commits@vger.kernel.org


The patch titled
     aio: negative offset should return -EINVAL
has been removed from the -mm tree.  Its filename was
     aio-negative-offset-should-return-einval.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: aio: negative offset should return -EINVAL
From: Rusty Russell <rusty@rustcorp.com.au>

An AIO read or write should return -EINVAL if the offset is negative.
This check matches the one in pread and pwrite.

This was found by the libaio test suite.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/aio.c~aio-negative-offset-should-return-einval fs/aio.c
--- a/fs/aio.c~aio-negative-offset-should-return-einval
+++ a/fs/aio.c
@@ -1329,6 +1329,10 @@ static ssize_t aio_rw_vect_retry(struct 
 		opcode = IOCB_CMD_PWRITEV;
 	}
 
+	/* This matches the pread()/pwrite() logic */
+	if (iocb->ki_pos < 0)
+		return -EINVAL;
+
 	do {
 		ret = rw_op(iocb, &iocb->ki_iovec[iocb->ki_cur_seg],
 			    iocb->ki_nr_segs - iocb->ki_cur_seg,
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
git-kvm.patch
reiser4.patch
