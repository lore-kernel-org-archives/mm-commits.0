From: akpm@linux-foundation.org
Subject: [merged] ib-ipath-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:18 -0800
Message-ID: <20130228201418.AE9F131C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:42310 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab3B1UOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:19 -0500
Received: by mail-ye0-f202.google.com with SMTP id q5so245047yen.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, mike.marciniszyn@intel.com, yongjun_wei@trendmicro.com.cn, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/ipath: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-ipath-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/ipath: convert to idr_alloc()

Convert to the much saner new idr interface.

[yongjun_wei@trendmicro.com.cn: use GFP_NOWAIT under spin lock]
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_driver.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff -puN drivers/infiniband/hw/ipath/ipath_driver.c~ib-ipath-convert-to-idr_alloc drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c~ib-ipath-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -194,11 +194,6 @@ static struct ipath_devdata *ipath_alloc
 	struct ipath_devdata *dd;
 	int ret;
 
-	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
-		dd = ERR_PTR(-ENOMEM);
-		goto bail;
-	}
-
 	dd = vzalloc(sizeof(*dd));
 	if (!dd) {
 		dd = ERR_PTR(-ENOMEM);
@@ -206,9 +201,10 @@ static struct ipath_devdata *ipath_alloc
 	}
 	dd->ipath_unit = -1;
 
+	idr_preload(GFP_KERNEL);
 	spin_lock_irqsave(&ipath_devs_lock, flags);
 
-	ret = idr_get_new(&unit_table, dd, &dd->ipath_unit);
+	ret = idr_alloc(&unit_table, dd, 0, 0, GFP_NOWAIT);
 	if (ret < 0) {
 		printk(KERN_ERR IPATH_DRV_NAME
 		       ": Could not allocate unit ID: error %d\n", -ret);
@@ -216,6 +212,7 @@ static struct ipath_devdata *ipath_alloc
 		dd = ERR_PTR(ret);
 		goto bail_unlock;
 	}
+	dd->ipath_unit = ret;
 
 	dd->pcidev = pdev;
 	pci_set_drvdata(pdev, dd);
@@ -224,7 +221,7 @@ static struct ipath_devdata *ipath_alloc
 
 bail_unlock:
 	spin_unlock_irqrestore(&ipath_devs_lock, flags);
-
+	idr_preload_end();
 bail:
 	return dd;
 }
@@ -2503,11 +2500,6 @@ static int __init infinipath_init(void)
 	 * the PCI subsystem.
 	 */
 	idr_init(&unit_table);
-	if (!idr_pre_get(&unit_table, GFP_KERNEL)) {
-		printk(KERN_ERR IPATH_DRV_NAME ": idr_pre_get() failed\n");
-		ret = -ENOMEM;
-		goto bail;
-	}
 
 	ret = pci_register_driver(&ipath_driver);
 	if (ret < 0) {
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

