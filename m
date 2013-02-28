From: akpm@linux-foundation.org
Subject: [merged] dmaengine-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:13:30 -0800
Message-ID: <20130228201330.A682131C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:48386 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3B1UNb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:13:31 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so244769vch.4
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:13:31 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, djbw@fb.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dmaengine: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     dmaengine-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: dmaengine: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Dan Williams <djbw@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmaengine.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN drivers/dma/dmaengine.c~dmaengine-convert-to-idr_alloc drivers/dma/dmaengine.c
--- a/drivers/dma/dmaengine.c~dmaengine-convert-to-idr_alloc
+++ a/drivers/dma/dmaengine.c
@@ -686,18 +686,14 @@ static int get_dma_id(struct dma_device 
 {
 	int rc;
 
- idr_retry:
-	if (!idr_pre_get(&dma_idr, GFP_KERNEL))
-		return -ENOMEM;
 	mutex_lock(&dma_list_mutex);
-	rc = idr_get_new(&dma_idr, NULL, &device->dev_id);
-	mutex_unlock(&dma_list_mutex);
-	if (rc == -EAGAIN)
-		goto idr_retry;
-	else if (rc != 0)
-		return rc;
 
-	return 0;
+	rc = idr_alloc(&dma_idr, NULL, 0, 0, GFP_KERNEL);
+	if (rc >= 0)
+		device->dev_id = rc;
+
+	mutex_unlock(&dma_list_mutex);
+	return rc < 0 ? rc : 0;
 }
 
 /**
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

