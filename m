From: akpm@linux-foundation.org
Subject: + zram-report-every-added-and-removed-device.patch added to -mm
 tree
Date: Tue, 03 Mar 2015 14:02:08 -0800
Message-ID: <54f62f60.vUt2Eh/QfyAQZqMR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685AbbCCWCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:02:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: report every added and removed device
has been added to the -mm tree.  Its filename is
     zram-report-every-added-and-removed-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-report-every-added-and-removed-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-report-every-added-and-removed-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1149,6 +1149,8 @@ static int zram_add(int device_id)
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 	zram->meta = NULL;
 	zram->max_comp_streams = 1;
+
+	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return 0;
 
 out_free_disk:
@@ -1175,6 +1177,8 @@ static void zram_remove(struct zram *zra
 	zram_reset_device_internal(zram);
 	idr_remove(&zram_index_idr, zram->disk->first_minor);
 	blk_cleanup_queue(zram->disk->queue);
+
+	pr_info("Removed device: %s\n", zram->disk->disk_name);
 	del_gendisk(zram->disk);
 	put_disk(zram->disk);
 	kfree(zram);
@@ -1295,7 +1299,6 @@ static void destroy_devices(void)
 	idr_for_each(&zram_index_idr, &zram_exit_cb, NULL);
 	idr_destroy(&zram_index_idr);
 	unregister_blkdev(zram_major, "zram");
-	pr_info("Destroyed device(s)\n");
 }
 
 static int __init zram_init(void)
@@ -1323,7 +1326,6 @@ static int __init zram_init(void)
 			goto out_error;
 	}
 
-	pr_info("Created %u device(s)\n", num_devices);
 	return 0;
 
 out_error:
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

