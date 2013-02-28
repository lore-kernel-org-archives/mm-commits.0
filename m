From: akpm@linux-foundation.org
Subject: [merged] ib-cxgb3-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:09 -0800
Message-ID: <20130228201409.A4F715A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:46433 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3B1UOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:10 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so244776ghb.3
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, swise@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/cxgb3: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-cxgb3-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/cxgb3: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/cxgb3/iwch.h |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff -puN drivers/infiniband/hw/cxgb3/iwch.h~ib-cxgb3-convert-to-idr_alloc drivers/infiniband/hw/cxgb3/iwch.h
--- a/drivers/infiniband/hw/cxgb3/iwch.h~ib-cxgb3-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/cxgb3/iwch.h
@@ -153,19 +153,17 @@ static inline int insert_handle(struct i
 				void *handle, u32 id)
 {
 	int ret;
-	int newid;
 
-	do {
-		if (!idr_pre_get(idr, GFP_KERNEL)) {
-			return -ENOMEM;
-		}
-		spin_lock_irq(&rhp->lock);
-		ret = idr_get_new_above(idr, handle, id, &newid);
-		BUG_ON(newid != id);
-		spin_unlock_irq(&rhp->lock);
-	} while (ret == -EAGAIN);
+	idr_preload(GFP_KERNEL);
+	spin_lock_irq(&rhp->lock);
+
+	ret = idr_alloc(idr, handle, id, id + 1, GFP_NOWAIT);
+
+	spin_unlock_irq(&rhp->lock);
+	idr_preload_end();
 
-	return ret;
+	BUG_ON(ret == -ENOSPC);
+	return ret < 0 ? ret : 0;
 }
 
 static inline void remove_handle(struct iwch_dev *rhp, struct idr *idr, u32 id)
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

