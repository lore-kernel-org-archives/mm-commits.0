From: akpm@linux-foundation.org
Subject: [merged] fs-direct-ioc-adjust-suspicious-bit-operation.patch removed from -mm tree
Date: Wed, 13 Jun 2012 12:15:00 -0700
Message-ID: <20120613191500.5DC36A017E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:62547 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab2FMTPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jun 2012 15:15:01 -0400
Received: by qcsp5 with SMTP id p5so80147qcs.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Jun 2012 12:15:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Julia.Lawall@lip6.fr, jmoyer@redhat.com, julia@diku.dk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/direct-io.c: adjust suspicious bit operation
has been removed from the -mm tree.  Its filename was
     fs-direct-ioc-adjust-suspicious-bit-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: fs/direct-io.c: adjust suspicious bit operation

READ is 0, so the result of the bit-and operation is 0.  Rewrite with == as
done elsewhere in the same file.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <julia@diku.dk>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/direct-io.c~fs-direct-ioc-adjust-suspicious-bit-operation fs/direct-io.c
--- a/fs/direct-io.c~fs-direct-ioc-adjust-suspicious-bit-operation
+++ a/fs/direct-io.c
@@ -1258,7 +1258,7 @@ do_blockdev_direct_IO(int rw, struct kio
 	 */
 	BUG_ON(retval == -EIOCBQUEUED);
 	if (dio->is_async && retval == 0 && dio->result &&
-	    ((rw & READ) || (dio->result == sdio.size)))
+	    ((rw == READ) || (dio->result == sdio.size)))
 		retval = -EIOCBQUEUED;
 
 	if (retval != -EIOCBQUEUED)
_

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

linux-next.patch

