From: akpm@linux-foundation.org
Subject: [merged] ib-amso1100-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:06 -0800
Message-ID: <20130228201406.AD4935A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59284 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3B1UOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:07 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246549yhz.1
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, swise@opengridcomputing.com, tom@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/amso1100: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-amso1100-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/amso1100: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/amso1100/c2_qp.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN drivers/infiniband/hw/amso1100/c2_qp.c~ib-amso1100-convert-to-idr_alloc drivers/infiniband/hw/amso1100/c2_qp.c
--- a/drivers/infiniband/hw/amso1100/c2_qp.c~ib-amso1100-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -382,14 +382,17 @@ static int c2_alloc_qpn(struct c2_dev *c
 {
 	int ret;
 
-        do {
-		spin_lock_irq(&c2dev->qp_table.lock);
-		ret = idr_get_new_above(&c2dev->qp_table.idr, qp,
-					c2dev->qp_table.last++, &qp->qpn);
-		spin_unlock_irq(&c2dev->qp_table.lock);
-        } while ((ret == -EAGAIN) &&
-	 	 idr_pre_get(&c2dev->qp_table.idr, GFP_KERNEL));
-	return ret;
+	idr_preload(GFP_KERNEL);
+	spin_lock_irq(&c2dev->qp_table.lock);
+
+	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
+			GFP_NOWAIT);
+	if (ret >= 0)
+		qp->qpn = ret;
+
+	spin_unlock_irq(&c2dev->qp_table.lock);
+	idr_preload_end();
+	return ret < 0 ? ret : 0;
 }
 
 static void c2_free_qpn(struct c2_dev *c2dev, int qpn)
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

