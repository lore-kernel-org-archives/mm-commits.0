From: akpm@linux-foundation.org
Subject: [merged] ib-qib-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:27 -0800
Message-ID: <20130228201427.987ED5A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57229 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab3B1UO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:28 -0500
Received: by mail-gg0-f201.google.com with SMTP id l2so245042ggn.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, infinipath@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/qib: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-qib-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/qib: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Mike Marciniszyn <infinipath@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/qib/qib_init.c |   21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff -puN drivers/infiniband/hw/qib/qib_init.c~ib-qib-convert-to-idr_alloc drivers/infiniband/hw/qib/qib_init.c
--- a/drivers/infiniband/hw/qib/qib_init.c~ib-qib-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/qib/qib_init.c
@@ -1060,22 +1060,23 @@ struct qib_devdata *qib_alloc_devdata(st
 	struct qib_devdata *dd;
 	int ret;
 
-	if (!idr_pre_get(&qib_unit_table, GFP_KERNEL)) {
-		dd = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
 	dd = (struct qib_devdata *) ib_alloc_device(sizeof(*dd) + extra);
 	if (!dd) {
 		dd = ERR_PTR(-ENOMEM);
 		goto bail;
 	}
 
+	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&qib_devs_lock, flags);
-	ret = idr_get_new(&qib_unit_table, dd, &dd->unit);
-	if (ret >= 0)
+
+	ret = idr_alloc(&qib_unit_table, dd, 0, 0, GFP_NOWAIT);
+	if (ret >= 0) {
+		dd->unit = ret;
 		list_add(&dd->list, &qib_dev_list);
+	}
+
 	spin_unlock_irqrestore(&qib_devs_lock, flags);
+	idr_preload_end();
 
 	if (ret < 0) {
 		qib_early_err(&pdev->dev,
@@ -1180,11 +1181,6 @@ static int __init qlogic_ib_init(void)
 	 * the PCI subsystem.
 	 */
 	idr_init(&qib_unit_table);
-	if (!idr_pre_get(&qib_unit_table, GFP_KERNEL)) {
-		pr_err("idr_pre_get() failed\n");
-		ret = -ENOMEM;
-		goto bail_cq_wq;
-	}
 
 	ret = pci_register_driver(&qib_driver);
 	if (ret < 0) {
@@ -1199,7 +1195,6 @@ static int __init qlogic_ib_init(void)
 
 bail_unit:
 	idr_destroy(&qib_unit_table);
-bail_cq_wq:
 	destroy_workqueue(qib_cq_wq);
 bail_dev:
 	qib_dev_cleanup();
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

