From: akpm@linux-foundation.org
Subject: [merged] memstick-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:14:33 -0800
Message-ID: <20130228201433.B3D5F31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:51348 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587Ab3B1UOe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:14:34 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so245118vch.0
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:14:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memstick: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     memstick-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: memstick: convert to idr_alloc()

Convert to the much saner new idr interface.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |   21 ++++++++++-----------
 drivers/memstick/core/mspro_block.c |   17 +++--------------
 2 files changed, 13 insertions(+), 25 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-convert-to-idr_alloc drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-convert-to-idr_alloc
+++ a/drivers/memstick/core/memstick.c
@@ -512,18 +512,17 @@ int memstick_add_host(struct memstick_ho
 {
 	int rc;
 
-	while (1) {
-		if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
-			return -ENOMEM;
+	idr_preload(GFP_KERNEL);
+	spin_lock(&memstick_host_lock);
 
-		spin_lock(&memstick_host_lock);
-		rc = idr_get_new(&memstick_host_idr, host, &host->id);
-		spin_unlock(&memstick_host_lock);
-		if (!rc)
-			break;
-		else if (rc != -EAGAIN)
-			return rc;
-	}
+	rc = idr_alloc(&memstick_host_idr, host, 0, 0, GFP_NOWAIT);
+	if (rc >= 0)
+		host->id = rc;
+
+	spin_unlock(&memstick_host_lock);
+	idr_preload_end();
+	if (rc < 0)
+		return rc;
 
 	dev_set_name(&host->dev, "memstick%u", host->id);
 
diff -puN drivers/memstick/core/mspro_block.c~memstick-convert-to-idr_alloc drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-convert-to-idr_alloc
+++ a/drivers/memstick/core/mspro_block.c
@@ -1213,21 +1213,10 @@ static int mspro_block_init_disk(struct 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
 	mutex_lock(&mspro_block_disk_lock);
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
-		mutex_unlock(&mspro_block_disk_lock);
-		return -ENOMEM;
-	}
-
-	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
+	disk_id = idr_alloc(&mspro_block_disk_idr, card, 0, 256, GFP_KERNEL);
 	mutex_unlock(&mspro_block_disk_lock);
-
-	if (rc)
-		return rc;
-
-	if ((disk_id << MSPRO_BLOCK_PART_SHIFT) > 255) {
-		rc = -ENOSPC;
-		goto out_release_id;
-	}
+	if (disk_id < 0)
+		return disk_id;
 
 	msb->disk = alloc_disk(1 << MSPRO_BLOCK_PART_SHIFT);
 	if (!msb->disk) {
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

