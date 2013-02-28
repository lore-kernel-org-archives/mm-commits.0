From: akpm@linux-foundation.org
Subject: [merged] block-loop-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:18 -0800
Message-ID: <20130228201318.A8CE25A4242@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:56664 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UNT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:19 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so244859vea.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block/loop: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     block-loop-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: block/loop: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff -puN drivers/block/loop.c~block-loop-convert-to-idr_alloc drivers/block/loop.c
--- a/drivers/block/loop.c~block-loop-convert-to-idr_alloc
+++ a/drivers/block/loop.c
@@ -1624,30 +1624,17 @@ static int loop_add(struct loop_device *
 	if (!lo)
 		goto out;
 
-	if (!idr_pre_get(&loop_index_idr, GFP_KERNEL))
-		goto out_free_dev;
-
+	/* allocate id, if @id >= 0, we're requesting that specific id */
 	if (i >= 0) {
-		int m;
-
-		/* create specific i in the index */
-		err = idr_get_new_above(&loop_index_idr, lo, i, &m);
-		if (err >= 0 && i != m) {
-			idr_remove(&loop_index_idr, m);
+		err = idr_alloc(&loop_index_idr, lo, i, i + 1, GFP_KERNEL);
+		if (err == -ENOSPC)
 			err = -EEXIST;
-		}
-	} else if (i == -1) {
-		int m;
-
-		/* get next free nr */
-		err = idr_get_new(&loop_index_idr, lo, &m);
-		if (err >= 0)
-			i = m;
 	} else {
-		err = -EINVAL;
+		err = idr_alloc(&loop_index_idr, lo, 0, 0, GFP_KERNEL);
 	}
 	if (err < 0)
 		goto out_free_dev;
+	i = err;
 
 	lo->lo_queue = blk_alloc_queue(GFP_KERNEL);
 	if (!lo->lo_queue)
_

Patches currently in -mm which might be from tj@kernel.org are

origin.patch
linux-next.patch
slub-correctly-bootstrap-boot-caches.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch
nfsd-idr_destroy-no-longer-needs-idr_remove_all.patch

