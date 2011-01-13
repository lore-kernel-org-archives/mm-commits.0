From: akpm@linux-foundation.org
Subject: [merged] memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:47 -0800
Message-ID: <201101132012.p0DKCSju030296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731Ab1AMUUc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: avert possible race condition between idr_pre_get and idr_get_new
has been removed from the -mm tree.  Its filename was
     memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: avert possible race condition between idr_pre_get and idr_get_new
From: Alex Dubov <oakad@yahoo.com>

Implement the usual pattern around idr_pre_get() and idr_get_new() to
handlethe situation where another thread concurrently steals this thread's
idr_pre_get() preallocation.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/memstick.c    |   18 +++++++++++-------
 drivers/memstick/core/mspro_block.c |    6 ++++--
 2 files changed, 15 insertions(+), 9 deletions(-)

diff -puN drivers/memstick/core/memstick.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new drivers/memstick/core/memstick.c
--- a/drivers/memstick/core/memstick.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new
+++ a/drivers/memstick/core/memstick.c
@@ -511,14 +511,18 @@ int memstick_add_host(struct memstick_ho
 {
 	int rc;
 
-	if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
-		return -ENOMEM;
+	while (1) {
+		if (!idr_pre_get(&memstick_host_idr, GFP_KERNEL))
+			return -ENOMEM;
 
-	spin_lock(&memstick_host_lock);
-	rc = idr_get_new(&memstick_host_idr, host, &host->id);
-	spin_unlock(&memstick_host_lock);
-	if (rc)
-		return rc;
+		spin_lock(&memstick_host_lock);
+		rc = idr_get_new(&memstick_host_idr, host, &host->id);
+		spin_unlock(&memstick_host_lock);
+		if (!rc)
+			break;
+		else if (rc != -EAGAIN)
+			return rc;
+	}
 
 	dev_set_name(&host->dev, "memstick%u", host->id);
 
diff -puN drivers/memstick/core/mspro_block.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new
+++ a/drivers/memstick/core/mspro_block.c
@@ -1206,10 +1206,12 @@ static int mspro_block_init_disk(struct 
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
-	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL))
+	mutex_lock(&mspro_block_disk_lock);
+	if (!idr_pre_get(&mspro_block_disk_idr, GFP_KERNEL)) {
+		mutex_unlock(&mspro_block_disk_lock);
 		return -ENOMEM;
+	}
 
-	mutex_lock(&mspro_block_disk_lock);
 	rc = idr_get_new(&mspro_block_disk_idr, card, &disk_id);
 	mutex_unlock(&mspro_block_disk_lock);
 
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update.patch

