From: akpm@linux-foundation.org
Subject: + zram-remove-max_num_devices-limitation.patch added to -mm tree
Date: Fri, 08 May 2015 14:35:52 -0700
Message-ID: <554d2c38.B66NNwVeksU6KQqX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932464AbbEHVfx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 May 2015 17:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


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
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |    4 +++-
 drivers/block/zram/zram_drv.c   |    8 +-------
 drivers/block/zram/zram_drv.h   |    6 ------
 3 files changed, 4 insertions(+), 14 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-remove-max_num_devices-limitation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-remove-max_num_devices-limitation
+++ a/Documentation/blockdev/zram.txt
@@ -19,7 +19,9 @@ Following shows a typical sequence of st
 1) Load Module:
 	modprobe zram num_devices=4
 	This creates 4 devices: /dev/zram{0,1,2,3}
-	(num_devices parameter is optional. Default: 1)
+
+num_devices parameter is optional and tells zram how many devices should be
+pre-created. Default: 1.
 
 2) Set max number of compression streams
 	Compression backend may use up to max_comp_streams compression streams,
diff -puN drivers/block/zram/zram_drv.c~zram-remove-max_num_devices-limitation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-max_num_devices-limitation
+++ a/drivers/block/zram/zram_drv.c
@@ -1285,12 +1285,6 @@ static int __init zram_init(void)
 {
 	int ret, dev_id;
 
-	if (num_devices > max_num_devices) {
-		pr_warn("Invalid value for num_devices: %u\n",
-				num_devices);
-		return -EINVAL;
-	}
-
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
 		pr_warn("Unable to get major number\n");
@@ -1320,7 +1314,7 @@ module_init(zram_init);
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
