From: akpm@linux-foundation.org
Subject: + arm-fix-rd_size-declaration.patch added to -mm tree
Date: Tue, 27 Jun 2017 13:52:46 -0700
Message-ID: <5952c59e.xLUv7G6y/al9IAXm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54156 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753490AbdF0Uwr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jun 2017 16:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bart.vanassche@wdc.com, axboe@kernel.dk, bart.vanassche@sandisk.com, jack@suse.cz, linux@armlinux.org.uk, miaoxie@huawei.com, yanaijie@huawei.com, zhaohongjiang@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ARM: fix rd_size declaration
has been added to the -mm tree.  Its filename is
     arm-fix-rd_size-declaration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-fix-rd_size-declaration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-fix-rd_size-declaration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Russell King <linux@armlinux.org.uk>
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

Patches currently in -mm which might be from bart.vanassche@wdc.com are

arm-fix-rd_size-declaration.patch

