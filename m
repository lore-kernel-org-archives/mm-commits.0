From: akpm@linux-foundation.org
Subject: [to-be-updated]
 zram-return-zram-device_id-value-from-zram_add.patch removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:17 -0700
Message-ID: <553804d9.QLFhTDnf6Z1CiU3/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbbDVUaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: return zram device_id value from zram_add()
has been removed from the -mm tree.  Its filename was
     zram-return-zram-device_id-value-from-zram_add.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: return zram device_id value from zram_add()

zram_add requires valid device_id to be provided, that can be a bit
inconvenient.  Change zram_add() to return negative value upon new device
creation failure, and device_id (>= 0) value otherwise.

This prepares zram_add to perform automatic device_id assignment.  New
device_id will be returned back to user-space (so user can reference that
device as /dev/zramX).

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-return-zram-device_id-value-from-zram_add drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-return-zram-device_id-value-from-zram_add
+++ a/drivers/block/zram/zram_drv.c
@@ -1128,6 +1128,8 @@ static struct attribute_group zram_disk_
 	.attrs = zram_disk_attrs,
 };
 
+/* allocate and initialize new zram device. the function returns
+ * '>= 0' device_id upon success, and negative value otherwise. */
 static int zram_add(int device_id)
 {
 	struct zram *zram;
@@ -1214,7 +1216,7 @@ static int zram_add(int device_id)
 	zram->max_comp_streams = 1;
 
 	pr_info("Added device: %s\n", zram->disk->disk_name);
-	return 0;
+	return device_id;
 
 out_free_disk:
 	del_gendisk(zram->disk);
@@ -1389,7 +1391,7 @@ static int __init zram_init(void)
 		mutex_lock(&zram_index_mutex);
 		ret = zram_add(dev_id);
 		mutex_unlock(&zram_index_mutex);
-		if (ret != 0)
+		if (ret < 0)
 			goto out_error;
 	}
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

