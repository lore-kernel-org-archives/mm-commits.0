From: akpm@linux-foundation.org
Subject: +
 block-change-config-option-name-for-cmdline-partition-parsing.patch added
 to -mm tree
Date: Wed, 25 Sep 2013 18:09:24 -0700
Message-ID: <52438944.7W1k/kCeADHy4g25%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab3IZBJZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 21:09:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yongjun_wei@trendmicro.com.cn, caizhiyong@huawei.com, axboe@kernel.dk, paul.gortmaker@windriver.com

Subject: + block-change-config-option-name-for-cmdline-partition-parsing.patch added to -mm tree
To: paul.gortmaker@windriver.com,axboe@kernel.dk,caizhiyong@huawei.com,yongjun_wei@trendmicro.com.cn
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 18:09:24 -0700


The patch titled
     Subject: block: change config option name for cmdline partition parsing
has been added to the -mm tree.  Its filename is
     block-change-config-option-name-for-cmdline-partition-parsing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-change-config-option-name-for-cmdline-partition-parsing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-change-config-option-name-for-cmdline-partition-parsing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: block: change config option name for cmdline partition parsing

Recently added bab55417b10c9 ("block: support embedded device command line
partition") introduced CONFIG_CMDLINE_PARSER.  However, that name is too
generic and sounds like it enables/disables generic kernel boot arg
processing, when it really is block specific.

Before this option becomes a part of a full/final release, add the BLK_
prefix to it so that it is clear in absence of any other context that it
is block specific.

In addition, fix up the following less critical items:
 - help text was not really at all helpful.
 - index file for Documentation was not updated
 - add the new arg to Documentation/kernel-parameters.txt
 - clarify wording in source comments

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Cai Zhiyong <caizhiyong@huawei.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/block/00-INDEX              |    2 ++
 Documentation/block/cmdline-partition.txt |    8 ++++----
 Documentation/kernel-parameters.txt       |    4 ++++
 block/Kconfig                             |    9 +++++++--
 block/Makefile                            |    2 +-
 block/partitions/Kconfig                  |    4 ++--
 block/partitions/cmdline.c                |    8 ++++----
 7 files changed, 24 insertions(+), 13 deletions(-)

diff -puN Documentation/block/00-INDEX~block-change-config-option-name-for-cmdline-partition-parsing Documentation/block/00-INDEX
--- a/Documentation/block/00-INDEX~block-change-config-option-name-for-cmdline-partition-parsing
+++ a/Documentation/block/00-INDEX
@@ -6,6 +6,8 @@ capability.txt
 	- Generic Block Device Capability (/sys/block/<device>/capability)
 cfq-iosched.txt
 	- CFQ IO scheduler tunables
+cmdline-partition.txt
+	- how to specify block device partitions on kernel command line
 data-integrity.txt
 	- Block data integrity
 deadline-iosched.txt
diff -puN Documentation/block/cmdline-partition.txt~block-change-config-option-name-for-cmdline-partition-parsing Documentation/block/cmdline-partition.txt
--- a/Documentation/block/cmdline-partition.txt~block-change-config-option-name-for-cmdline-partition-parsing
+++ a/Documentation/block/cmdline-partition.txt
@@ -1,9 +1,9 @@
-Embedded device command line partition
+Embedded device command line partition parsing
 =====================================================================
 
-Read block device partition table from command line.
-The partition used for fixed block device (eMMC) embedded device.
-It is no MBR, save storage space. Bootloader can be easily accessed
+Support for reading the block device partition table from the command line.
+It is typically used for fixed block (eMMC) embedded devices.
+It has no MBR, so saves storage space. Bootloader can be easily accessed
 by absolute address of data on the block device.
 Users can easily change the partition.
 
diff -puN Documentation/kernel-parameters.txt~block-change-config-option-name-for-cmdline-partition-parsing Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~block-change-config-option-name-for-cmdline-partition-parsing
+++ a/Documentation/kernel-parameters.txt
@@ -480,6 +480,10 @@ bytes respectively. Such letter suffixes
 			Format: <io>,<irq>,<mode>
 			See header of drivers/net/hamradio/baycom_ser_hdx.c.
 
+	blkdevparts=	Manual partition parsing of block device(s) for
+			embedded devices based on command line input.
+			See Documentation/block/cmdline-partition.txt
+
 	boot_delay=	Milliseconds to delay each printk during boot.
 			Values larger than 10 seconds (10000) are changed to
 			no delay (0).
diff -puN block/Kconfig~block-change-config-option-name-for-cmdline-partition-parsing block/Kconfig
--- a/block/Kconfig~block-change-config-option-name-for-cmdline-partition-parsing
+++ a/block/Kconfig
@@ -99,11 +99,16 @@ config BLK_DEV_THROTTLING
 
 	See Documentation/cgroups/blkio-controller.txt for more information.
 
-config CMDLINE_PARSER
+config BLK_CMDLINE_PARSER
 	bool "Block device command line partition parser"
 	default n
 	---help---
-	Parsing command line, get the partitions information.
+	Enabling this option allows you to specify the partition layout from
+	the kernel boot args.  This is typically of use for embedded devices
+	which don't otherwise have any standardized method for listing the
+	partitions on a block device.
+
+	See Documentation/block/cmdline-partition.txt for more information.
 
 menu "Partition Types"
 
diff -puN block/Makefile~block-change-config-option-name-for-cmdline-partition-parsing block/Makefile
--- a/block/Makefile~block-change-config-option-name-for-cmdline-partition-parsing
+++ a/block/Makefile
@@ -18,4 +18,4 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched
 
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY)	+= blk-integrity.o
-obj-$(CONFIG_CMDLINE_PARSER)	+= cmdline-parser.o
+obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
diff -puN block/partitions/Kconfig~block-change-config-option-name-for-cmdline-partition-parsing block/partitions/Kconfig
--- a/block/partitions/Kconfig~block-change-config-option-name-for-cmdline-partition-parsing
+++ a/block/partitions/Kconfig
@@ -263,7 +263,7 @@ config SYSV68_PARTITION
 
 config CMDLINE_PARTITION
 	bool "Command line partition support" if PARTITION_ADVANCED
-	select CMDLINE_PARSER
+	select BLK_CMDLINE_PARSER
 	help
-	  Say Y here if you would read the partitions table from bootargs.
+	  Say Y here if you want to read the partition table from bootargs.
 	  The format for the command line is just like mtdparts.
diff -puN block/partitions/cmdline.c~block-change-config-option-name-for-cmdline-partition-parsing block/partitions/cmdline.c
--- a/block/partitions/cmdline.c~block-change-config-option-name-for-cmdline-partition-parsing
+++ a/block/partitions/cmdline.c
@@ -2,15 +2,15 @@
  * Copyright (C) 2013 HUAWEI
  * Author: Cai Zhiyong <caizhiyong@huawei.com>
  *
- * Read block device partition table from command line.
- * The partition used for fixed block device (eMMC) embedded device.
- * It is no MBR, save storage space. Bootloader can be easily accessed
+ * Read block device partition table from the command line.
+ * Typically used for fixed block (eMMC) embedded devices.
+ * It has no MBR, so saves storage space. Bootloader can be easily accessed
  * by absolute address of data on the block device.
  * Users can easily change the partition.
  *
  * The format for the command line is just like mtdparts.
  *
- * Verbose config please reference "Documentation/block/cmdline-partition.txt"
+ * For further information, see "Documentation/block/cmdline-partition.txt"
  *
  */
 
_

Patches currently in -mm which might be from paul.gortmaker@windriver.com are

block-change-config-option-name-for-cmdline-partition-parsing.patch

