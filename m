From: akpm@linux-foundation.org
Subject: + ib-qib-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:28 -0800
Message-ID: <20130206223829.2129431C1FF@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:61365 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWia (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:30 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so95357ggi.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, infinipath@intel.com


The patch titled
     Subject: IB/qib: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     ib-qib-convert-to-idr_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/qib: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

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
idr-fix-a-subtle-bug-in-idr_get_next.patch
idr-make-idr_destroy-imply-idr_remove_all.patch
atm-nicstar-dont-use-idr_remove_all.patch
block-loop-dont-use-idr_remove_all.patch
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
idr-cosmetic-updates-to-struct-initializer-definitions.patch
idr-relocate-idr_for_each_entry-and-reorganize-id_get_new.patch
idr-remove-_idr_rc_to_errno-hack.patch
idr-refactor-idr_get_new_above.patch
idr-implement-idr_preload-and-idr_alloc.patch
block-fix-synchronization-and-limit-check-in-blk_alloc_devt.patch
block-convert-to-idr_alloc.patch
block-loop-convert-to-idr_alloc.patch
atm-nicstar-convert-to-idr_alloc.patch
drbd-convert-to-idr_alloc.patch
dca-convert-to-idr_alloc.patch
dmaengine-convert-to-idr_alloc.patch
firewire-add-minor-number-range-check-to-fw_device_init.patch
firewire-convert-to-idr_alloc.patch
gpio-convert-to-idr_alloc.patch
drm-convert-to-idr_alloc.patch
drm-exynos-convert-to-idr_alloc.patch
drm-i915-convert-to-idr_alloc.patch
drm-sis-convert-to-idr_alloc.patch
drm-via-convert-to-idr_alloc.patch
drm-vmwgfx-convert-to-idr_alloc.patch
i2c-convert-to-idr_alloc.patch
ib-core-convert-to-idr_alloc.patch
ib-amso1100-convert-to-idr_alloc.patch
ib-cxgb3-convert-to-idr_alloc.patch
ib-cxgb4-convert-to-idr_alloc.patch
ib-ehca-convert-to-idr_alloc.patch
ib-ipath-convert-to-idr_alloc.patch
ib-mlx4-convert-to-idr_alloc.patch
ib-ocrdma-convert-to-idr_alloc.patch
ib-qib-convert-to-idr_alloc.patch
dm-convert-to-idr_alloc.patch
memstick-convert-to-idr_alloc.patch
mfd-convert-to-idr_alloc.patch
misc-c2port-convert-to-idr_alloc.patch
misc-tifm_core-convert-to-idr_alloc.patch
mmc-convert-to-idr_alloc.patch
mtd-convert-to-idr_alloc.patch
macvtap-convert-to-idr_alloc.patch
ppp-convert-to-idr_alloc.patch
power-convert-to-idr_alloc.patch
pps-convert-to-idr_alloc.patch
remoteproc-convert-to-idr_alloc.patch
rpmsg-convert-to-idr_alloc.patch
scsi-bfa-convert-to-idr_alloc.patch
scsi-convert-to-idr_alloc.patch
target-iscsi-convert-to-idr_alloc.patch
scsi-lpfc-convert-to-idr_alloc.patch
thermal-convert-to-idr_alloc.patch
uio-convert-to-idr_alloc.patch
vfio-convert-to-idr_alloc.patch
dlm-convert-to-idr_alloc.patch
inotify-convert-to-idr_alloc.patch
ocfs2-convert-to-idr_alloc.patch
ipc-convert-to-idr_alloc.patch
cgroup-convert-to-idr_alloc.patch
events-convert-to-idr_alloc.patch
posix-timers-convert-to-idr_alloc.patch
net-9p-convert-to-idr_alloc.patch
mac80211-convert-to-idr_alloc.patch
sctp-convert-to-idr_alloc.patch
nfs4client-convert-to-idr_alloc.patch

