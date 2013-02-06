From: akpm@linux-foundation.org
Subject: [to-be-updated] block-loop-dont-use-idr_remove_all.patch removed from -mm tree
Date: Wed, 06 Feb 2013 14:00:42 -0800
Message-ID: <20130206220042.9840E5A424B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:55178 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab3BFWAo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:00:44 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so206854qcr.2
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:00:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block/loop: don't use idr_remove_all()
has been removed from the -mm tree.  Its filename was
     block-loop-dont-use-idr_remove_all.patch

This patch was dropped because an updated version will be merged

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
@@ -1908,7 +1908,6 @@ static void __exit loop_exit(void)
 	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
 	idr_for_each(&loop_index_idr, &loop_exit_cb, NULL);
-	idr_remove_all(&loop_index_idr);
 	idr_destroy(&loop_index_idr);
 
 	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
cfq-fix-lock-imbalance-with-failed-allocations.patch
block-restore-proc-partitions-to-not-display-non-partitionable-removable-devices.patch
memcg-do-not-create-memsw-files-if-swap-accounting-is-disabled.patch
memcg-clean-up-swap-accounting-initialization-code.patch
memcg-prevent-changes-to-move_charge_at_immigrate-during-task-attach.patch
memcg-split-part-of-memcg-creation-to-css_online.patch
memcg-fast-hierarchy-aware-child-test.patch
memcg-fast-hierarchy-aware-child-test-fix.patch
memcg-replace-cgroup_lock-with-memcg-specific-memcg_lock.patch
memcg-increment-static-branch-right-after-limit-set.patch
memcg-avoid-dangling-reference-count-in-creation-failure.patch
firewire-dont-use-idr_remove_all.patch
drm-dont-use-idr_remove_all.patch
dm-dont-use-idr_remove_all.patch
remoteproc-dont-use-idr_remove_all.patch
rpmsg-dont-use-idr_remove_all.patch
dlm-use-idr_for_each_entry-in-recover_idr_clear-error-path.patch
dlm-dont-use-idr_remove_all.patch
nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
inotify-dont-use-idr_remove_all.patch
cgroup-dont-use-idr_remove_all.patch
idr-deprecate-idr_remove_all.patch

