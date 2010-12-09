From: akpm@linux-foundation.org
Subject: + memstick-remove-mspro_block_mutex.patch added to -mm tree
Date: Thu, 09 Dec 2010 12:14:28 -0800
Message-ID: <201012092014.oB9KESxd004582@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756996Ab0LIUWG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 15:22:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oakad@yahoo.com


The patch titled
     memstick: remove mspro_block_mutex
has been added to the -mm tree.  Its filename is
     memstick-remove-mspro_block_mutex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

memstick-core-fix-device_register-error-handling.patch
memstick-fix-setup-for-jmicron-38x-controllers.patch
memstick-set-pmos-values-propery-for-jmicron-38x-controllers.patch
memstick-add-support-for-jmicron-jmb-385-and-390-controllers.patch
memstick-avert-possible-race-condition-between-idr_pre_get-and-idr_get_new.patch
memstick-remove-mspro_block_mutex.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc.patch
memstick-add-support-for-mspro-specific-data-transfer-method.patch

