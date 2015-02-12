From: akpm@linux-foundation.org
Subject: [folded-merged] zram-rework-reset-and-destroy-path-fix-3.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 14:15:48 -0800
Message-ID: <54dd2614.PCHAyC7gTCWgjbpa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60252 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbbBLWPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 17:15:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-rework-reset-and-destroy-path-fix-3
has been removed from the -mm tree.  Its filename was
     zram-rework-reset-and-destroy-path-fix-3.patch

This patch was dropped because it was folded into zram-rework-reset-and-destroy-path.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zram-rework-reset-and-destroy-path-fix-3

simplifications

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix-3 drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rework-reset-and-destroy-path-fix-3
+++ a/drivers/block/zram/zram_drv.c
@@ -1141,7 +1141,7 @@ static void destroy_devices(unsigned int
 
 static int __init zram_init(void)
 {
-	int ret = -ENOMEM, dev_id = 0;
+	int ret, dev_id;
 
 	if (num_devices > max_num_devices) {
 		pr_warn("Invalid value for num_devices: %u\n",
@@ -1157,8 +1157,10 @@ static int __init zram_init(void)
 
 	/* Allocate the device array and initialize each one */
 	zram_devices = kzalloc(num_devices * sizeof(struct zram), GFP_KERNEL);
-	if (!zram_devices)
-		goto out_error;
+	if (!zram_devices) {
+		unregister_blkdev(zram_major, "zram");
+		return -ENOMEM;
+	}
 
 	for (dev_id = 0; dev_id < num_devices; dev_id++) {
 		ret = create_device(&zram_devices[dev_id], dev_id);
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are

zram-rework-reset-and-destroy-path.patch

