From: akpm@linux-foundation.org
Subject: [folded-merged]
 loop-use-worker-per-cgroup-instead-of-kworker-fix.patch removed from -mm
 tree
Date: Tue, 03 Mar 2020 16:25:21 -0800
Message-ID: <20200304002521.-DG_orGiC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727865AbgCDAZW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 3 Mar 2020 19:25:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mm-commits@vger.kernel.org, schatzberg.dan@gmail.com, sfr@canb.auug.org.au


The patch titled
     Subject: loop: fix IS_ERR() vs NULL bugs in loop_prepare_queue()
has been removed from the -mm tree.  Its filename was
     loop-use-worker-per-cgroup-instead-of-kworker-fix.patch

This patch was dropped because it was folded into loop-use-worker-per-cgroup-instead-of-kworker.patch

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

lib-test_kmod-remove-a-null-test.patch
loop-use-worker-per-cgroup-instead-of-kworker.patch
