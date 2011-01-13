From: akpm@linux-foundation.org
Subject: [merged] memstick-remove-mspro_block_mutex.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:09:49 -0800
Message-ID: <201101132012.p0DKCUaX030299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756629Ab1AMUUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:20:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oakad@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     memstick: remove mspro_block_mutex
has been removed from the -mm tree.  Its filename was
     memstick-remove-mspro_block_mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memstick: remove mspro_block_mutex
From: Alex Dubov <oakad@yahoo.com>

mspro_block_mutex is identical in scope to mspro_block_disk_lock and therefore
unnecessary.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~memstick-remove-mspro_block_mutex drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~memstick-remove-mspro_block_mutex
+++ a/drivers/memstick/core/mspro_block.c
@@ -23,7 +23,6 @@
 
 #define DRIVER_NAME "mspro_block"
 
-static DEFINE_MUTEX(mspro_block_mutex);
 static int major;
 module_param(major, int, 0644);
 
@@ -181,7 +180,6 @@ static int mspro_block_bd_open(struct bl
 	struct mspro_block_data *msb = disk->private_data;
 	int rc = -ENXIO;
 
-	mutex_lock(&mspro_block_mutex);
 	mutex_lock(&mspro_block_disk_lock);
 
 	if (msb && msb->card) {
@@ -193,7 +191,6 @@ static int mspro_block_bd_open(struct bl
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
-	mutex_unlock(&mspro_block_mutex);
 
 	return rc;
 }
@@ -225,11 +222,7 @@ static int mspro_block_disk_release(stru
 
 static int mspro_block_bd_release(struct gendisk *disk, fmode_t mode)
 {
-	int ret;
-	mutex_lock(&mspro_block_mutex);
-	ret = mspro_block_disk_release(disk);
-	mutex_unlock(&mspro_block_mutex);
-	return ret;
+	return mspro_block_disk_release(disk);
 }
 
 static int mspro_block_bd_getgeo(struct block_device *bdev,
_

Patches currently in -mm which might be from oakad@yahoo.com are

origin.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader.patch
memstick-add-support-for-legacy-memorysticks.patch
memstick-add-support-for-legacy-memorysticks-update.patch

