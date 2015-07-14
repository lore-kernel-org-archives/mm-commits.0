From: akpm@linux-foundation.org
Subject: [nacked] zram-make-compact-a-read-write-sysfs-node.patch removed
 from -mm tree
Date: Tue, 14 Jul 2015 11:31:58 -0700
Message-ID: <55a5559e.hu51TV5V7QlEKvD2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbbGNSb6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jul 2015 14:31:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: make compact a read-write sysfs node
has been removed from the -mm tree.  Its filename was
     zram-make-compact-a-read-write-sysfs-node.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: make compact a read-write sysfs node

Change zram's `compact' sysfs node to be a read-write attribute.  Write
triggers zsmalloc compaction, just as before, read returns the number of
pages that zsmalloc can potentially compact.

User space now has a chance to estimate possible compaction memory
savings and avoid unnecessary compactions.

Example:

  if [ `cat /sys/block/zram<id>/compact` -gt 10 ]; then
      echo 1 > /sys/block/zram<id>/compact;
  fi

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    7 ++++---
 Documentation/blockdev/zram.txt            |    4 +++-
 drivers/block/zram/zram_drv.c              |   16 +++++++++++++++-
 3 files changed, 22 insertions(+), 5 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-make-compact-a-read-write-sysfs-node Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-make-compact-a-read-write-sysfs-node
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -146,9 +146,10 @@ What:		/sys/block/zram<id>/compact
 Date:		August 2015
 Contact:	Minchan Kim <minchan@kernel.org>
 Description:
-		The compact file is write-only and trigger compaction for
-		allocator zrm uses. The allocator moves some objects so that
-		it could free fragment space.
+		The compact file is read/write. Write triggers underlying
+		allocator's memory compaction, which may result in memory
+		savings. Read returns the number of pages that compaction
+		can potentially (but not guaranteed to) free.
 
 What:		/sys/block/zram<id>/io_stat
 Date:		August 2015
diff -puN Documentation/blockdev/zram.txt~zram-make-compact-a-read-write-sysfs-node Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-make-compact-a-read-write-sysfs-node
+++ a/Documentation/blockdev/zram.txt
@@ -146,7 +146,9 @@ mem_limit         RW    the maximum amou
                         the compressed data
 pages_compacted   RO    the number of pages freed during compaction
                         (available only via zram<id>/mm_stat node)
-compact           WO    trigger memory compaction
+compact           RW    write triggers memory compaction, read shows how many
+                        pages can potentially (but not necessarily will) be
+                        compacted
 
 WARNING
 =======
diff -puN drivers/block/zram/zram_drv.c~zram-make-compact-a-read-write-sysfs-node drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-make-compact-a-read-write-sysfs-node
+++ a/drivers/block/zram/zram_drv.c
@@ -404,6 +404,20 @@ static ssize_t compact_store(struct devi
 	return len;
 }
 
+static ssize_t compact_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	unsigned long num_pages = 0;
+
+	down_read(&zram->init_lock);
+	if (init_done(zram))
+		num_pages = zs_pages_to_compact(zram->meta->mem_pool);
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%lu\n", num_pages);
+}
+
 static ssize_t io_stat_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1145,7 +1159,7 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
-static DEVICE_ATTR_WO(compact);
+static DEVICE_ATTR_RW(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
 static DEVICE_ATTR_WO(reset);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
zsmalloc-partial-page-ordering-within-a-fullness_list.patch
zsmalloc-consider-zs_almost_full-as-migrate-source.patch
zsmalloc-do-not-take-class-lock-in-zs_pages_to_compact.patch

