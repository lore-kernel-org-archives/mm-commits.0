From: akpm@linux-foundation.org
Subject: [patch 079/115] ARM: fix rd_size declaration
Date: Mon, 10 Jul 2017 15:51:10 -0700
Message-ID: <20170710225110.8rsBd4-FV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43266 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754835AbdGJWvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:51:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk, bart.vanassche@sandisk.com, bart.vanassche@wdc.com, jack@suse.cz, miaoxie@huawei.com, mm-commits@vger.kernel.org, rmk+kernel@armlinux.org.uk, torvalds@linux-foundation.org, yanaijie@huawei.com, zhaohongjiang@huawei.com

From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: ARM: fix rd_size declaration

The global variable 'rd_size' is declared as 'int' in source file
arch/arm/kernel/atags_parse.c and as 'unsigned long' in
drivers/block/brd.c.  Fix this inconsistency.  Additionally, remove the
declarations of rd_image_start, rd_prompt and rd_doload from
parse_tag_ramdisk() since these duplicate existing declarations in
<linux/initrd.h>.

Link: http://lkml.kernel.org/r/20170627065024.12347-1-bart.vanassche@wdc.com
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Yan <yanaijie@huawei.com>
Cc: Zhaohongjiang <zhaohongjiang@huawei.com>
Cc: Miao Xie <miaoxie@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/atags_parse.c |    3 +--
 drivers/block/brd.c           |    1 +
 include/linux/initrd.h        |    3 +++
 3 files changed, 5 insertions(+), 2 deletions(-)

diff -puN arch/arm/kernel/atags_parse.c~arm-fix-rd_size-declaration arch/arm/kernel/atags_parse.c
--- a/arch/arm/kernel/atags_parse.c~arm-fix-rd_size-declaration
+++ a/arch/arm/kernel/atags_parse.c
@@ -18,6 +18,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/initrd.h>
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/root_dev.h>
@@ -91,8 +92,6 @@ __tagtable(ATAG_VIDEOTEXT, parse_tag_vid
 #ifdef CONFIG_BLK_DEV_RAM
 static int __init parse_tag_ramdisk(const struct tag *tag)
 {
-	extern int rd_size, rd_image_start, rd_prompt, rd_doload;
-
 	rd_image_start = tag->u.ramdisk.start;
 	rd_doload = (tag->u.ramdisk.flags & 1) == 0;
 	rd_prompt = (tag->u.ramdisk.flags & 2) == 0;
diff -puN drivers/block/brd.c~arm-fix-rd_size-declaration drivers/block/brd.c
--- a/drivers/block/brd.c~arm-fix-rd_size-declaration
+++ a/drivers/block/brd.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/init.h>
+#include <linux/initrd.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/major.h>
diff -puN include/linux/initrd.h~arm-fix-rd_size-declaration include/linux/initrd.h
--- a/include/linux/initrd.h~arm-fix-rd_size-declaration
+++ a/include/linux/initrd.h
@@ -10,6 +10,9 @@ extern int rd_prompt;
 /* starting block # of image */
 extern int rd_image_start;
 
+/* size of a single RAM disk */
+extern unsigned long rd_size;
+
 /* 1 if it is not an error if initrd_start < memory_start */
 extern int initrd_below_start_ok;
 
_
