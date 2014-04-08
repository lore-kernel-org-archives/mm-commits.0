From: akpm@linux-foundation.org
Subject: [merged] zram-use-atomic64_t-for-all-zram-stats.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:02:21 -0700
Message-ID: <534463dd.yS+4B6iHbQOXQTiH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVCW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:02:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-use-atomic64_t-for-all-zram-stats.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:02:21 -0700


The patch titled
     Subject: zram: use atomic64_t for all zram stats
has been removed from the -mm tree.  Its filename was
     zram-use-atomic64_t-for-all-zram-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: use atomic64_t for all zram stats

This is a preparation patch for stats code duplication removal.

1) use atomic64_t for `pages_zero' and `pages_stored' zram stats.

2) `compr_size' and `pages_zero' struct zram_stats members did not
   follow the existing device attr naming scheme: zram_stats.ATTR has
   ATTR_show() function.  rename them:

   -- compr_size -> compr_data_size
   -- pages_zero -> zero_pages

Minchan Kim's note:
 If we really have trouble with atomic stat operation, we could
 change it with percpu_counter so that it could solve atomic overhead and
 unnecessary memory space by introducing unsigned long instead of 64bit
 atomic_t.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   18 +++++++++---------
 drivers/block/zram/zram_drv.h |    6 +++---
 2 files changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-atomic64_t-for-all-zram-stats drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-atomic64_t-for-all-zram-stats
+++ a/drivers/block/zram/zram_drv.c
@@ -109,7 +109,7 @@ static ssize_t zero_pages_show(struct de
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", atomic_read(&zram->stats.pages_zero));
+	return sprintf(buf, "%llu\n", (u64)atomic64_read(&zram->stats.zero_pages));
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -118,7 +118,7 @@ static ssize_t orig_data_size_show(struc
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		(u64)(atomic_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
+		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
 static ssize_t compr_data_size_show(struct device *dev,
@@ -127,7 +127,7 @@ static ssize_t compr_data_size_show(stru
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.compr_size));
+			(u64)atomic64_read(&zram->stats.compr_data_size));
 }
 
 static ssize_t mem_used_total_show(struct device *dev,
@@ -301,15 +301,15 @@ static void zram_free_page(struct zram *
 		 */
 		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
 			zram_clear_flag(meta, index, ZRAM_ZERO);
-			atomic_dec(&zram->stats.pages_zero);
+			atomic64_dec(&zram->stats.zero_pages);
 		}
 		return;
 	}
 
 	zs_free(meta->mem_pool, handle);
 
-	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
-	atomic_dec(&zram->stats.pages_stored);
+	atomic64_sub(meta->table[index].size, &zram->stats.compr_data_size);
+	atomic64_dec(&zram->stats.pages_stored);
 
 	meta->table[index].handle = 0;
 	meta->table[index].size = 0;
@@ -452,7 +452,7 @@ static int zram_bvec_write(struct zram *
 		zram_set_flag(meta, index, ZRAM_ZERO);
 		write_unlock(&zram->meta->tb_lock);
 
-		atomic_inc(&zram->stats.pages_zero);
+		atomic64_inc(&zram->stats.zero_pages);
 		ret = 0;
 		goto out;
 	}
@@ -508,8 +508,8 @@ static int zram_bvec_write(struct zram *
 	write_unlock(&zram->meta->tb_lock);
 
 	/* Update stats */
-	atomic64_add(clen, &zram->stats.compr_size);
-	atomic_inc(&zram->stats.pages_stored);
+	atomic64_add(clen, &zram->stats.compr_data_size);
+	atomic64_inc(&zram->stats.pages_stored);
 out:
 	if (locked)
 		mutex_unlock(&meta->buffer_lock);
diff -puN drivers/block/zram/zram_drv.h~zram-use-atomic64_t-for-all-zram-stats drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-use-atomic64_t-for-all-zram-stats
+++ a/drivers/block/zram/zram_drv.h
@@ -69,15 +69,15 @@ struct table {
 } __aligned(4);
 
 struct zram_stats {
-	atomic64_t compr_size;	/* compressed size of pages stored */
+	atomic64_t compr_data_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
 	atomic64_t num_writes;	/* --do-- */
 	atomic64_t failed_reads;	/* should NEVER! happen */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
-	atomic_t pages_zero;		/* no. of zero filled pages */
-	atomic_t pages_stored;	/* no. of pages currently stored */
+	atomic64_t zero_pages;		/* no. of zero filled pages */
+	atomic64_t pages_stored;	/* no. of pages currently stored */
 };
 
 struct zram_meta {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

