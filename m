From: akpm@linux-foundation.org
Subject: + fs-direct-ioc-adjust-suspicious-bit-operation.patch added to -mm tree
Date: Thu, 07 Jun 2012 15:45:00 -0700
Message-ID: <20120607224501.08E65A00B0@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:50385 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FGWpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jun 2012 18:45:03 -0400
Received: by eeit10 with SMTP id t10so70669eei.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Jun 2012 15:45:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Julia.Lawall@lip6.fr, jmoyer@redhat.com, julia@diku.dk, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs/direct-io.c: adjust suspicious bit operation
has been added to the -mm tree.  Its filename is
     fs-direct-ioc-adjust-suspicious-bit-operation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: fs/direct-io.c: adjust suspicious bit operation

Patches currently in -mm which might be from Julia.Lawall@lip6.fr are

linux-next.patch
fs-direct-ioc-adjust-suspicious-bit-operation.patch

