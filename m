From: akpm@linux-foundation.org
Subject: + loop-use-worker-per-cgroup-instead-of-kworker-fix.patch
 added to -mm tree
Date: Sat, 29 Feb 2020 18:10:41 -0800
Message-ID: <20200301021041.zPbwWaL0U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgCACKo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 21:10:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org, schatzberg.dan@gmail.com, sfr@canb.auug.org.au


The patch titled
     Subject: loop: fix IS_ERR() vs NULL bugs in loop_prepare_queue()
has been added to the -mm tree.  Its filename is
     loop-use-worker-per-cgroup-instead-of-kworker-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/loop-use-worker-per-cgroup-instead-of-kworker-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/loop-use-worker-per-cgroup-instead-of-kworker-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: loop: fix IS_ERR() vs NULL bugs in loop_prepare_queue()

The alloc_workqueue() function returns NULL on error, it never returns
error pointers.

Link: http://lkml.kernel.org/r/20200228172136.h5dvwvrg5yfywxss@kili.mountain
Fixes: 29dab2122492 ("loop: use worker per cgroup instead of kworker")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/loop.c~loop-use-worker-per-cgroup-instead-of-kworker-fix
+++ a/drivers/block/loop.c
@@ -901,7 +901,7 @@ static int loop_prepare_queue(struct loo
 					WQ_UNBOUND | WQ_FREEZABLE |
 					WQ_MEM_RECLAIM,
 					lo->lo_number);
-	if (IS_ERR(lo->workqueue))
+	if (!lo->workqueue)
 		return -ENOMEM;
 
 	return 0;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

loop-use-worker-per-cgroup-instead-of-kworker-fix.patch
