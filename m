From: akpm@linux-foundation.org
Subject: [merged] ib-ehca-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:15 -0800
Message-ID: <20130228201415.97ED331C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:36261 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab3B1UOQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:16 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so244860ghb.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:16 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, hnguyen@de.ibm.com, raisch@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/ehca: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-ehca-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/ehca: convert to idr_alloc()

Convert to the much saner new idr interface.

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
