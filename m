From: akpm@linux-foundation.org
Subject: [to-be-updated] zram-remove-max_num_devices-limitation.patch
 removed from -mm tree
Date: Wed, 22 Apr 2015 13:30:11 -0700
Message-ID: <553804d3.KFIm468nU1Dz1RsU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49682 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbbDVUaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Apr 2015 16:30:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove max_num_devices limitation
has been removed from the -mm tree.  Its filename was
     zram-remove-max_num_devices-limitation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove max_num_devices limitation

Limiting the number of zram devices to 32 (default max_num_devices value)
is confusing, let's drop it.  A user with 2TB or 4TB of RAM, for example,
can request as many devices as he can handle.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +-------
 drivers/block/zram/zram_drv.h |    6 ------
 2 files changed, 1 insertion(+), 13 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-max_num_devices-limitation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-max_num_devices-limitation
+++ a/drivers/block/zram/zram_drv.c
@@ -1369,12 +1369,6 @@ static int __init zram_init(void)
 {
 	int ret, dev_id;
 
-	if (num_devices > max_num_devices) {
-		pr_warn("Invalid value for num_devices: %u\n",
-				num_devices);
-		return -EINVAL;
-	}
-
 	ret = class_register(&zram_control_class);
 	if (ret) {
 		pr_warn("Unable to register zram-control class\n");
@@ -1413,7 +1407,7 @@ module_init(zram_init);
 module_exit(zram_exit);
 
 module_param(num_devices, uint, 0);
-MODULE_PARM_DESC(num_devices, "Number of zram devices");
+MODULE_PARM_DESC(num_devices, "Number of pre-created zram devices");
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
diff -puN drivers/block/zram/zram_drv.h~zram-remove-max_num_devices-limitation drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-max_num_devices-limitation
+++ a/drivers/block/zram/zram_drv.h
@@ -20,12 +20,6 @@
 
 #include "zcomp.h"
 
-/*
- * Some arbitrary value. This is just to catch
- * invalid value for num_devices module parameter.
- */
-static const unsigned max_num_devices = 32;
