From: akpm@linux-foundation.org
Subject: + block-remove-blk_dev_dax-config-option.patch added to -mm tree
Date: Fri, 29 Jul 2016 15:57:42 -0700
Message-ID: <579bdf66.HdL8isPs82BZLpno%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbcG2W5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 18:57:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@kernel.dk, dan.j.williams@intel.com, dave.hansen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: remove BLK_DEV_DAX config option
has been added to the -mm tree.  Its filename is
     block-remove-blk_dev_dax-config-option.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-remove-blk_dev_dax-config-option.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-remove-blk_dev_dax-config-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: block: remove BLK_DEV_DAX config option

The functionality for block device DAX was already removed with this
commit:

commit acc93d30d7d4 ("Revert "block: enable dax for raw block devices"")

However, we still had a config option hanging around that was always
disabled because it depended on CONFIG_BROKEN.  This config option was
introduced in this commit:

commit 03cdadb04077 ("block: disable block device DAX by default")

This change reverts that commit, removing the dead config option.

Link: http://lkml.kernel.org/r/20160729182314.6368-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig  |   13 -------------
 fs/block_dev.c |    6 +-----
 2 files changed, 1 insertion(+), 18 deletions(-)

diff -puN block/Kconfig~block-remove-blk_dev_dax-config-option block/Kconfig
--- a/block/Kconfig~block-remove-blk_dev_dax-config-option
+++ a/block/Kconfig
@@ -88,19 +88,6 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
-config BLK_DEV_DAX
-	bool "Block device DAX support"
-	depends on FS_DAX
-	depends on BROKEN
-	help
-	  When DAX support is available (CONFIG_FS_DAX) raw block
-	  devices can also support direct userspace access to the
-	  storage capacity via MMAP(2) similar to a file on a
-	  DAX-enabled filesystem.  However, the DAX I/O-path disables
-	  some standard I/O-statistics, and the MMAP(2) path has some
-	  operational differences due to bypassing the page
-	  cache.  If in doubt, say N.
-
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
 	depends on BLK_CGROUP=y
diff -puN fs/block_dev.c~block-remove-blk_dev_dax-config-option fs/block_dev.c
--- a/fs/block_dev.c~block-remove-blk_dev_dax-config-option
+++ a/fs/block_dev.c
@@ -1275,11 +1275,7 @@ static int __blkdev_get(struct block_dev
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
-		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) &&
-		    blk_queue_dax(disk->queue))
-			bdev->bd_inode->i_flags = S_DAX;
-		else
-			bdev->bd_inode->i_flags = 0;
+		bdev->bd_inode->i_flags = 0;
 
 		if (!partno) {
 			ret = -ENXIO;
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-fix-comment-about-exceptional-bits.patch
block-remove-blk_dev_dax-config-option.patch

