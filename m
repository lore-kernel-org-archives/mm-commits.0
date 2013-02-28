From: akpm@linux-foundation.org
Subject: [merged] ib-cxgb4-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:12 -0800
Message-ID: <20130228201412.A0CD231C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:39354 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3B1UON (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:13 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245178qen.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:13 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, swise@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/cxgb4: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-cxgb4-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/cxgb4: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/cxgb4/iw_cxgb4.h |   25 +++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN drivers/infiniband/hw/cxgb4/iw_cxgb4.h~ib-cxgb4-convert-to-idr_alloc drivers/infiniband/hw/cxgb4/iw_cxgb4.h
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h~ib-cxgb4-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -260,20 +260,21 @@ static inline int _insert_handle(struct 
 				 void *handle, u32 id, int lock)
 {
 	int ret;
-	int newid;
 
-	do {
-		if (!idr_pre_get(idr, lock ? GFP_KERNEL : GFP_ATOMIC))
-			return -ENOMEM;
-		if (lock)
-			spin_lock_irq(&rhp->lock);
-		ret = idr_get_new_above(idr, handle, id, &newid);
-		BUG_ON(!ret && newid != id);
-		if (lock)
-			spin_unlock_irq(&rhp->lock);
-	} while (ret == -EAGAIN);
+	if (lock) {
+		idr_preload(GFP_KERNEL);
+		spin_lock_irq(&rhp->lock);
+	}
+
+	ret = idr_alloc(idr, handle, id, id + 1, GFP_ATOMIC);
+
+	if (lock) {
+		spin_unlock_irq(&rhp->lock);
+		idr_preload_end();
+	}
 
-	return ret;
+	BUG_ON(ret == -ENOSPC);
+	return ret < 0 ? ret : 0;
 }
 
 static inline int insert_handle(struct c4iw_dev *rhp, struct idr *idr,
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

