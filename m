From: akpm@linux-foundation.org
Subject: + fs-pipec-pipe_read-fix-error-return.patch added to -mm tree
Date: Thu, 21 Oct 2010 13:01:03 -0700
Message-ID: <201010212001.o9LK130P000445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041Ab0JUUBk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Oct 2010 16:01:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nikai@nikai.net, axboe@kernel.dk, viro@zeniv.linux.org.uk


The patch titled
     fs/pipe.c: pipe_read(): fix error return
has been added to the -mm tree.  Its filename is
     fs-pipec-pipe_read-fix-error-return.patch

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
Subject: fs/pipe.c: pipe_read(): fix error return
From: Nicolas Kaiser <nikai@nikai.net>

pipe_read() would accidentally return 0 if ->confirm failed.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/pipe.c~fs-pipec-pipe_read-fix-error-return fs/pipe.c
--- a/fs/pipe.c~fs-pipec-pipe_read-fix-error-return
+++ a/fs/pipe.c
@@ -382,7 +382,7 @@ pipe_read(struct kiocb *iocb, const stru
 			error = ops->confirm(pipe, buf);
 			if (error) {
 				if (!ret)
-					error = ret;
+					ret = error;
 				break;
 			}
 
_

Patches currently in -mm which might be from nikai@nikai.net are

linux-next.patch
fs-pipec-pipe_read-fix-error-return.patch

