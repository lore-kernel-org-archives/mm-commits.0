From: akpm@linux-foundation.org
Subject: [merged] remoteproc-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:03 -0800
Message-ID: <20130228201503.9ED6C5A42AB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:40464 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3B1UPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:04 -0500
Received: by mail-qe0-f73.google.com with SMTP id a11so245298qen.2
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ohad@wizery.com, mm-commits@vger.kernel.org


The patch titled
     Subject: remoteproc: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     remoteproc-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: remoteproc: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/remoteproc/remoteproc_core.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/remoteproc/remoteproc_core.c~remoteproc-convert-to-idr_alloc drivers/remoteproc/remoteproc_core.c
--- a/drivers/remoteproc/remoteproc_core.c~remoteproc-convert-to-idr_alloc
+++ a/drivers/remoteproc/remoteproc_core.c
@@ -199,11 +199,6 @@ int rproc_alloc_vring(struct rproc_vdev 
 	/* actual size of vring (in bytes) */
 	size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
 
-	if (!idr_pre_get(&rproc->notifyids, GFP_KERNEL)) {
-		dev_err(dev, "idr_pre_get failed\n");
-		return -ENOMEM;
-	}
-
 	/*
 	 * Allocate non-cacheable memory for the vring. In the future
 	 * this call will also configure the IOMMU for us
@@ -221,12 +216,13 @@ int rproc_alloc_vring(struct rproc_vdev 
 	 * TODO: let the rproc know the notifyid of this vring
 	 * TODO: support predefined notifyids (via resource table)
 	 */
-	ret = idr_get_new(&rproc->notifyids, rvring, &notifyid);
+	ret = idr_alloc(&rproc->notifyids, rvring, 0, 0, GFP_KERNEL);
 	if (ret) {
-		dev_err(dev, "idr_get_new failed: %d\n", ret);
+		dev_err(dev, "idr_alloc failed: %d\n", ret);
 		dma_free_coherent(dev->parent, size, va, dma);
 		return ret;
 	}
+	notifyid = ret;
 
 	/* Store largest notifyid */
 	rproc->max_notifyid = max(rproc->max_notifyid, notifyid);
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

