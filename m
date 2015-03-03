From: akpm@linux-foundation.org
Subject: + zram-remove-max_num_devices-limitation.patch added to -mm tree
Date: Tue, 03 Mar 2015 14:02:06 -0800
Message-ID: <54f62f5e.R07ah+Rb/oPg9ZXu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbbCCWCH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Mar 2015 17:02:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove max_num_devices limitation
has been added to the -mm tree.  Its filename is
     zram-remove-max_num_devices-limitation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-max_num_devices-limitation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-max_num_devices-limitation.patch

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
@@ -1302,12 +1302,6 @@ static int __init zram_init(void)
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
@@ -1346,7 +1340,7 @@ module_init(zram_init);
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
