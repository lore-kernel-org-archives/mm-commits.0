From: akpm@linux-foundation.org
Subject: [to-be-updated] zram-report-every-added-and-removed-device.patch
 removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:13 -0700
Message-ID: <553804d5.ZMIy10wfy0yjoMdW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbbDVUaN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: report every added and removed device
has been removed from the -mm tree.  Its filename was
     zram-report-every-added-and-removed-device.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: report every added and removed device

With dynamic device creation/removal printing num_devices in zram_init()
doesn't make a lot of sense, as well as printing the number of destroyed
devices in destroy_devices().  Print per-device action (added/removed) in
zram_add() and zram_remove() instead.

Example:

[ 3645.259652] zram: Added device: zram5
[ 3646.152074] zram: Added device: zram6
[ 3650.585012] zram: Removed device: zram5
[ 3655.845584] zram: Added device: zram8
[ 3660.975223] zram: Removed device: zram6

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-report-every-added-and-removed-device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-report-every-added-and-removed-device
+++ a/drivers/block/zram/zram_drv.c
@@ -1212,6 +1212,8 @@ static int zram_add(int device_id)
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 	zram->meta = NULL;
 	zram->max_comp_streams = 1;
+
+	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return 0;
 
 out_free_disk:
@@ -1238,6 +1240,8 @@ static void zram_remove(struct zram *zra
 	zram_reset_device_internal(zram);
 	idr_remove(&zram_index_idr, zram->disk->first_minor);
 	blk_cleanup_queue(zram->disk->queue);
+
+	pr_info("Removed device: %s\n", zram->disk->disk_name);
 	del_gendisk(zram->disk);
 	put_disk(zram->disk);
 	kfree(zram);
@@ -1362,7 +1366,6 @@ static void destroy_devices(void)
 	idr_for_each(&zram_index_idr, &zram_exit_cb, NULL);
 	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
-	pr_info("Destroyed device(s)\n");
 }
 
 static int __init zram_init(void)
@@ -1390,7 +1393,6 @@ static int __init zram_init(void)
 			goto out_error;
 	}
 
-	pr_info("Created %u device(s)\n", num_devices);
 	return 0;
 
 out_error:
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
revert-zram-move-compact_store-to-sysfs-functions-area.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch

