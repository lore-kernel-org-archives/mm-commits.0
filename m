From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-introduce-per-device-debug_stat-sysfs-node-update.patch removed from
 -mm tree
Date: Fri, 20 May 2016 16:42:18 -0700
Message-ID: <573fa0da.PJeInlvXi2u2ZG2d%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcETXmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-introduce-per-device-debug_stat-sysfs-node-update
has been removed from the -mm tree.  Its filename was
     zram-introduce-per-device-debug_stat-sysfs-node-update.patch

This patch was dropped because it was folded into zram-introduce-per-device-debug_stat-sysfs-node.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram-introduce-per-device-debug_stat-sysfs-node-update

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    4 +++-
 drivers/block/zram/zram_drv.c              |    6 +++---
 drivers/block/zram/zram_drv.h              |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-introduce-per-device-debug_stat-sysfs-node-update Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-introduce-per-device-debug_stat-sysfs-node-update
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -172,4 +172,6 @@ Date:		July 2016
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
 Description:
 		The debug_stat file is read-only and represents various
-		device's debugging info.
+		device's debugging info useful for kernel developers. Its
+		format is not documented intentionally and may change
+		anytime without any notice.
diff -puN drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node-update drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node-update
+++ a/drivers/block/zram/zram_drv.c
@@ -438,7 +438,7 @@ static ssize_t mm_stat_show(struct devic
 static ssize_t debug_stat_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	unsigned int version = 1;
+	int version = 1;
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
@@ -446,7 +446,7 @@ static ssize_t debug_stat_show(struct de
 	ret = scnprintf(buf, PAGE_SIZE,
 			"version: %d\n%8llu\n",
 			version,
-			(u64)atomic64_read(&zram->stats.num_recompress));
+			(u64)atomic64_read(&zram->stats.writestall));
 	up_read(&zram->init_lock);
 
 	return ret;
@@ -737,7 +737,7 @@ compress_again:
 		zcomp_strm_release(zram->comp, zstrm);
 		zstrm = NULL;
 
-		atomic64_inc(&zram->stats.num_recompress);
+		atomic64_inc(&zram->stats.writestall);
 
 		handle = zs_malloc(meta->mem_pool, clen,
 				GFP_NOIO | __GFP_HIGHMEM);
diff -puN drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node-update drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node-update
+++ a/drivers/block/zram/zram_drv.h
@@ -85,7 +85,7 @@ struct zram_stats {
 	atomic64_t zero_pages;		/* no. of zero filled pages */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
-	atomic64_t num_recompress;	/* no. of compression slow paths */
+	atomic64_t writestall;		/* no. of write slow paths */
 };
 
 struct zram_meta {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-disable-fault-around-on-emulated-access-bit-architecture.patch
zsmalloc-use-first_page-rather-than-page.patch
zsmalloc-clean-up-many-bug_on.patch
zsmalloc-reordering-function-parameter.patch
zsmalloc-remove-unused-pool-param-in-obj_free.patch
zram-introduce-per-device-debug_stat-sysfs-node.patch
zram-introduce-per-device-debug_stat-sysfs-node-minchan.patch

