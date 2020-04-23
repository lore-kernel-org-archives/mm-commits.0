From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-pass-task-and-mm-to-do_madvise-fix.patch added to
 -mm tree
Date: Thu, 23 Apr 2020 15:41:20 -0700
Message-ID: <20200423224120.qf7LcNBi5%akpm@linux-foundation.org>
References: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbgDWWlW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 18:41:22 -0400
In-Reply-To: <20200420181310.c18b3c0aa4dc5b3e5ec1be10@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: axboe@kernel.dk, jannh@google.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs: use current->mm for io_uring
has been added to the -mm tree.  Its filename is
     mm-pass-task-and-mm-to-do_madvise-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pass-task-and-mm-to-do_madvise-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pass-task-and-mm-to-do_madvise-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: fs: use current->mm for io_uring

per-request by Jens,
https://lore.kernel.org/io-uring/46e5b8bf-0f14-caff-f706-91794191e730@kernel.dk/

Andrew, please fold this into "mm/madvise: pass task and mm to do_madvise"

Link: http://lkml.kernel.org/r/20200423145215.72666-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jann Horn <jannh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c~mm-pass-task-and-mm-to-do_madvise-fix
+++ a/fs/io_uring.c
@@ -3267,7 +3267,7 @@ static int io_madvise(struct io_kiocb *r
 	if (force_nonblock)
 		return -EAGAIN;
 
-	ret = do_madvise(NULL, req->work.mm, ma->addr, ma->len, ma->advice);
+	ret = do_madvise(NULL, current->mm, ma->addr, ma->len, ma->advice);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_cqring_add_event(req, ret);
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-pass-task-and-mm-to-do_madvise.patch
mm-pass-task-and-mm-to-do_madvise-fix.patch
mm-introduce-external-memory-hinting-api.patch
mm-introduce-external-memory-hinting-api-fix.patch
mm-check-fatal-signal-pending-of-target-process.patch
pid-move-pidfd_get_pid-function-to-pidc.patch
mm-support-both-pid-and-pidfd-for-process_madvise.patch
