From: akpm@linux-foundation.org
Subject: [merged] zram-report-every-added-and-removed-device.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:22 -0700
Message-ID: <5591ae9e.wTDALeJ0Fl16E0Kh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbbF2UqX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: report every added and removed device
has been removed from the -mm tree.  Its filename was
     zram-report-every-added-and-removed-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: report every added and removed device

With dynamic device creation/removal (which will be introduced later in
the series) printing num_devices in zram_init() will not make a lot of
sense, as well as printing the number of destroyed devices in
destroy_devices().  Print per-device action (added/removed) in zram_add()
and zram_remove() instead.

Example:

[ 3645.259652] zram: Added device: zram5
[ 3646.152074] zram: Added device: zram6
[ 3650.585012] zram: Removed device: zram5
[ 3655.845584] zram: Added device: zram8
[ 3660.975223] zram: Removed device: zram6

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-report-every-added-and-removed-device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-report-every-added-and-removed-device
+++ a/drivers/block/zram/zram_drv.c
@@ -1238,6 +1238,8 @@ static int zram_add(int device_id)
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 	zram->meta = NULL;
 	zram->max_comp_streams = 1;
+
+	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return 0;
 
 out_free_disk:
@@ -1254,6 +1256,7 @@ out_free_dev:
 
 static void zram_remove(struct zram *zram)
 {
+	pr_info("Removed device: %s\n", zram->disk->disk_name);
 	/*
 	 * Remove sysfs first, so no one will perform a disksize
 	 * store while we destroy the devices
@@ -1280,7 +1283,6 @@ static void destroy_devices(void)
 	idr_for_each(&zram_index_idr, &zram_remove_cb, NULL);
 	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
-	pr_info("Destroyed device(s)\n");
 }
 
 static int __init zram_init(void)
@@ -1299,7 +1301,6 @@ static int __init zram_init(void)
 			goto out_error;
 	}
 
-	pr_info("Created %u device(s)\n", num_devices);
 	return 0;
 
 out_error:
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

