From: akpm@linux-foundation.org
Subject: + ib-ehca-convert-to-idr_alloc.patch added to -mm tree
Date: Wed, 06 Feb 2013 14:38:17 -0800
Message-ID: <20130206223817.E79285A4277@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45659 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab3BFWiT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2013 17:38:19 -0500
Received: by mail-vb0-f74.google.com with SMTP id r6so209892vbi.1
        for <mm-commits@vger.kernel.org>; Wed, 06 Feb 2013 14:38:18 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tj@kernel.org, hnguyen@de.ibm.com, raisch@de.ibm.com


The patch titled
     Subject: IB/ehca: convert to idr_alloc()
has been added to the -mm tree.  Its filename is
     ib-ehca-convert-to-idr_alloc.patch

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
Subject: IB/ehca: convert to idr_alloc()

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ehca/ehca_cq.c |   27 +++++--------------
 drivers/infiniband/hw/ehca/ehca_qp.c |   34 +++++++++++--------------
 2 files changed, 22 insertions(+), 39 deletions(-)

diff -puN drivers/infiniband/hw/ehca/ehca_cq.c~ib-ehca-convert-to-idr_alloc drivers/infiniband/hw/ehca/ehca_cq.c
--- a/drivers/infiniband/hw/ehca/ehca_cq.c~ib-ehca-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -128,7 +128,7 @@ struct ib_cq *ehca_create_cq(struct ib_d
 	void *vpage;
 	u32 counter;
 	u64 rpage, cqx_fec, h_ret;
-	int ipz_rc, ret, i;
+	int ipz_rc, i;
 	unsigned long flags;
 
 	if (cqe >= 0xFFFFFFFF - 64 - additional_cqe)
@@ -163,32 +163,19 @@ struct ib_cq *ehca_create_cq(struct ib_d
 	adapter_handle = shca->ipz_hca_handle;
 	param.eq_handle = shca->eq.ipz_eq_handle;
 
-	do {
-		if (!idr_pre_get(&ehca_cq_idr, GFP_KERNEL)) {
-			cq = ERR_PTR(-ENOMEM);
-			ehca_err(device, "Can't reserve idr nr. device=%p",
-				 device);
-			goto create_cq_exit1;
-		}
-
-		write_lock_irqsave(&ehca_cq_idr_lock, flags);
-		ret = idr_get_new(&ehca_cq_idr, my_cq, &my_cq->token);
-		write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
-	} while (ret == -EAGAIN);
+	idr_preload(GFP_KERNEL);
+	write_lock_irqsave(&ehca_cq_idr_lock, flags);
+	my_cq->token = idr_alloc(&ehca_cq_idr, my_cq, 0, 0x2000000, GFP_NOWAIT);
+	write_unlock_irqrestore(&ehca_cq_idr_lock, flags);
+	idr_preload_end();
 
-	if (ret) {
+	if (my_cq->token < 0) {
 		cq = ERR_PTR(-ENOMEM);
 		ehca_err(device, "Can't allocate new idr entry. device=%p",
 			 device);
 		goto create_cq_exit1;
 	}
 
-	if (my_cq->token > 0x1FFFFFF) {
-		cq = ERR_PTR(-ENOMEM);
-		ehca_err(device, "Invalid number of cq. device=%p", device);
-		goto create_cq_exit2;
-	}
-
 	/*
 	 * CQs maximum depth is 4GB-64, but we need additional 20 as buffer
 	 * for receiving errors CQEs.
diff -puN drivers/infiniband/hw/ehca/ehca_qp.c~ib-ehca-convert-to-idr_alloc drivers/infiniband/hw/ehca/ehca_qp.c
--- a/drivers/infiniband/hw/ehca/ehca_qp.c~ib-ehca-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -636,30 +636,26 @@ static struct ehca_qp *internal_create_q
 		my_qp->send_cq =
 			container_of(init_attr->send_cq, struct ehca_cq, ib_cq);
 
-	do {
-		if (!idr_pre_get(&ehca_qp_idr, GFP_KERNEL)) {
+	idr_preload(GFP_KERNEL);
+	write_lock_irqsave(&ehca_qp_idr_lock, flags);
+
+	ret = idr_alloc(&ehca_qp_idr, my_qp, 0, 0x2000000, GFP_NOWAIT);
+	if (ret >= 0)
+		my_qp->token = ret;
+
+	write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
+	idr_preload_end();
+	if (ret < 0) {
+		if (ret == -ENOSPC) {
+			ret = -EINVAL;
+			ehca_err(pd->device, "Invalid number of qp");
+		} else {
 			ret = -ENOMEM;
-			ehca_err(pd->device, "Can't reserve idr resources.");
-			goto create_qp_exit0;
+			ehca_err(pd->device, "Can't allocate new idr entry.");
 		}
-
-		write_lock_irqsave(&ehca_qp_idr_lock, flags);
-		ret = idr_get_new(&ehca_qp_idr, my_qp, &my_qp->token);
-		write_unlock_irqrestore(&ehca_qp_idr_lock, flags);
-	} while (ret == -EAGAIN);
-
-	if (ret) {
-		ret = -ENOMEM;
-		ehca_err(pd->device, "Can't allocate new idr entry.");
 		goto create_qp_exit0;
 	}
 
-	if (my_qp->token > 0x1FFFFFF) {
-		ret = -EINVAL;
-		ehca_err(pd->device, "Invalid number of qp");
-		goto create_qp_exit1;
-	}
-
 	if (has_srq)
 		parms.srq_token = my_qp->token;
 
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

