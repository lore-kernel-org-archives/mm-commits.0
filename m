From: akpm@linux-foundation.org
Subject: [merged] block-loop-dont-use-idr_remove_all.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:12:32 -0800
Message-ID: <20130228201233.0C9CB5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:37842 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756821Ab3B1UMe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:12:34 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so39791qcr.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:12:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block/loop: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     block-loop-dont-use-idr_remove_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: block/loop: don't use idr_remove_all()

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/block/loop.c~block-loop-dont-use-idr_remove_all drivers/block/loop.c
--- a/drivers/block/loop.c~block-loop-dont-use-idr_remove_all
+++ a/drivers/block/loop.c
@@ -1911,7 +1911,6 @@ static void __exit loop_exit(void)
 	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
 	idr_for_each(&loop_index_idr, &loop_exit_cb, NULL);
-	idr_remove_all(&loop_index_idr);
 	idr_destroy(&loop_index_idr);
 
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
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

