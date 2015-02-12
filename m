From: akpm@linux-foundation.org
Subject: [folded-merged] zram-rework-reset-and-destroy-path-fix-2.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 14:15:45 -0800
Message-ID: <54dd2611.9171zAJ9C1vAkIuR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60248 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLWPq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:15:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, opensource.ganesh@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: set default dev_id value to zero in zram_init()
has been removed from the -mm tree.  Its filename was
     zram-rework-reset-and-destroy-path-fix-2.patch

This patch was dropped because it was folded into zram-rework-reset-and-destroy-path.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: set default dev_id value to zero in zram_init()

Set dev_id to zero and fix zram_devices allocation error handling
path, can pass uninit dev_id to destroy_devices().

cosmetic:
change destroy_devices() message from pr_debug() to pr_info(), as
proposed by Minchan Kim.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix-2 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix-2
+++ a/drivers/block/zram/zram_drv.c
@@ -1136,12 +1136,12 @@ static void destroy_devices(unsigned int
 
 	kfree(zram_devices);
 	unregister_blkdev(zram_major, "zram");
-	pr_debug("Destroyed %u device(s)\n", nr);
+	pr_info("Destroyed %u device(s)\n", nr);
 }
 
 static int __init zram_init(void)
 {
-	int ret, dev_id;
+	int ret = -ENOMEM, dev_id = 0;
 
 	if (num_devices > max_num_devices) {
 		pr_warn("Invalid value for num_devices: %u\n",
@@ -1157,10 +1157,8 @@ static int __init zram_init(void)
 
 	/* Allocate the device array and initialize each one */
 	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
-	if (!zram_devices) {
-		ret = -ENOMEM;
+	if (!zram_devices)
 		goto out_error;
-	}
 
 	for (dev_id = 0; dev_id < num_devices; dev_id++) {
 		ret = create_device(&zram_devices[dev_id], dev_id);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
zram-clean-up-zram_meta_alloc.patch
zram-free-meta-table-in-zram_meta_free.patch
zram-fix-umount-reset_store-mount-race-condition.patch
zram-rework-reset-and-destroy-path.patch
zram-rework-reset-and-destroy-path-fix-3.patch
zram-check-bd_openers-instead-bd_holders.patch
zram-remove-init_lock-in-zram_make_request.patch
zram-remove-request_queue-from-struct-zram.patch

