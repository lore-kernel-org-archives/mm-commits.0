From: akpm@linux-foundation.org
Subject: [merged] drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch removed from -mm tree
Date: Tue, 30 Apr 2013 12:02:02 -0700
Message-ID: <20130430190202.7BA425A405D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:62822 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab3D3TCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 15:02:04 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so87469qcr.4
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 12:02:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, swise@opengridcomputing.com, tj@kernel.org, tom@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/hw/amso1100: convert to using idr_alloc_cyclic
has been removed from the -mm tree.  Its filename was
     drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jeff Layton <jlayton@redhat.com>
Subject: drivers/infiniband/hw/amso1100: convert to using idr_alloc_cyclic

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/amso1100/c2.h    |    1 -
 drivers/infiniband/hw/amso1100/c2_qp.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/infiniband/hw/amso1100/c2.h~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic drivers/infiniband/hw/amso1100/c2.h
--- a/drivers/infiniband/hw/amso1100/c2.h~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/hw/amso1100/c2.h
@@ -265,7 +265,6 @@ struct c2_pd_table {
 struct c2_qp_table {
 	struct idr idr;
 	spinlock_t lock;
-	int last;
 };
 
 struct c2_element {
diff -puN drivers/infiniband/hw/amso1100/c2_qp.c~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic drivers/infiniband/hw/amso1100/c2_qp.c
--- a/drivers/infiniband/hw/amso1100/c2_qp.c~drivers-infiniband-hw-amso1100-convert-to-using-idr_alloc_cyclic
+++ a/drivers/infiniband/hw/amso1100/c2_qp.c
@@ -385,8 +385,7 @@ static int c2_alloc_qpn(struct c2_dev *c
 	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2dev->qp_table.lock);
 
-	ret = idr_alloc(&c2dev->qp_table.idr, qp, c2dev->qp_table.last++, 0,
-			GFP_NOWAIT);
+	ret = idr_alloc_cyclic(&c2dev->qp_table.idr, qp, 0, 0, GFP_NOWAIT);
 	if (ret >= 0)
 		qp->qpn = ret;
 
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch

