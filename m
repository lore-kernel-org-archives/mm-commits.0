From: akpm@linux-foundation.org
Subject: [merged] ib-ocrdma-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:24 -0800
Message-ID: <20130228201424.9DDE431C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:63257 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757903Ab3B1UOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:25 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245195qen.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, roland@purestorage.com, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/ocrdma: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ib-ocrdma-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: IB/ocrdma: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/infiniband/hw/ocrdma/ocrdma_main.c~ib-ocrdma-convert-to-idr_alloc drivers/infiniband/hw/ocrdma/ocrdma_main.c
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c~ib-ocrdma-convert-to-idr_alloc
+++ a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -51,18 +51,6 @@ static DEFINE_IDR(ocrdma_dev_id);
 
 static union ib_gid ocrdma_zero_sgid;
 
-static int ocrdma_get_instance(void)
-{
-	int instance = 0;
-
-	/* Assign an unused number */
-	if (!idr_pre_get(&ocrdma_dev_id, GFP_KERNEL))
-		return -1;
-	if (idr_get_new(&ocrdma_dev_id, NULL, &instance))
-		return -1;
-	return instance;
-}
-
 void ocrdma_get_guid(struct ocrdma_dev *dev, u8 *guid)
 {
 	u8 mac_addr[6];
@@ -416,7 +404,7 @@ static struct ocrdma_dev *ocrdma_add(str
 		goto idr_err;
 
 	memcpy(&dev->nic_info, dev_info, sizeof(*dev_info));
-	dev->id = ocrdma_get_instance();
+	dev->id = idr_alloc(&ocrdma_dev_id, NULL, 0, 0, GFP_KERNEL);
 	if (dev->id < 0)
 		goto idr_err;
 
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

