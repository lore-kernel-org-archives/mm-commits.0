From: akpm@linux-foundation.org
Subject: [merged] zram-introduce-zram-tb_lock.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:30 -0800
Message-ID: <52ebf68e.+BwJiQcweZ7/iLsP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: [merged] zram-introduce-zram-tb_lock.patch removed from -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:30 -0800


The patch titled
     Subject: zram: introduce zram->tb_lock
has been removed from the -mm tree.  Its filename was
     zram-introduce-zram-tb_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: introduce zram->tb_lock

Currently, table is protected by zram->lock but it's rather coarse-grained
lock and it makes hard for scalibility.

Let's use own rwlock instead of depending on zram->lock.  This patch adds
new locking so obviously, it would make slow but this patch is just
prepartion for removing coarse-grained rw_semaphore(ie, zram->lock) which
is hurdle about zram scalability.

Final patch in this patchset series will remove the lock from read-path
and change rw_semaphore with mutex in write path.  With bonus, we could
drop pending slot free mess in next patch.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   26 +++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |    3 ++-
 2 files changed, 23 insertions(+), 6 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-introduce-zram-tb_lock drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-zram-tb_lock
+++ a/drivers/block/zram/zram_drv.c
@@ -140,6 +140,7 @@ static ssize_t mem_used_total_show(struc
 	return sprintf(buf, "%llu\n", val);
 }
 
+/* flag operations needs meta->tb_lock */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
@@ -228,6 +229,7 @@ static struct zram_meta *zram_meta_alloc
 		goto free_table;
 	}
 
+	rwlock_init(&meta->tb_lock);
 	return meta;
 
 free_table:
@@ -280,6 +282,7 @@ static void handle_zero_page(struct bio_
 	flush_dcache_page(page);
 }
 
+/* NOTE: caller should hold meta->tb_lock with write-side */
 static void zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
@@ -319,20 +322,26 @@ static int zram_decompress_page(struct z
 	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
-	unsigned long handle = meta->table[index].handle;
+	unsigned long handle;
+	u16 size;
+
+	read_lock(&meta->tb_lock);
+	handle = meta->table[index].handle;
+	size = meta->table[index].size;
 
 	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
+		read_unlock(&meta->tb_lock);
 		clear_page(mem);
 		return 0;
 	}
 
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
-	if (meta->table[index].size == PAGE_SIZE)
+	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, meta->table[index].size,
-						mem, &clen);
+		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
 	zs_unmap_object(meta->mem_pool, handle);
+	read_unlock(&meta->tb_lock);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
@@ -353,11 +362,14 @@ static int zram_bvec_read(struct zram *z
 	struct zram_meta *meta = zram->meta;
 	page = bvec->bv_page;
 
+	read_lock(&meta->tb_lock);
 	if (unlikely(!meta->table[index].handle) ||
 			zram_test_flag(meta, index, ZRAM_ZERO)) {
+		read_unlock(&meta->tb_lock);
 		handle_zero_page(bvec);
 		return 0;
 	}
+	read_unlock(&meta->tb_lock);
 
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
@@ -433,10 +445,12 @@ static int zram_bvec_write(struct zram *
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
+		write_lock(&zram->meta->tb_lock);
 		zram_free_page(zram, index);
+		zram_set_flag(meta, index, ZRAM_ZERO);
+		write_unlock(&zram->meta->tb_lock);
 
 		atomic_inc(&zram->stats.pages_zero);
-		zram_set_flag(meta, index, ZRAM_ZERO);
 		ret = 0;
 		goto out;
 	}
@@ -486,10 +500,12 @@ static int zram_bvec_write(struct zram *
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
+	write_lock(&zram->meta->tb_lock);
 	zram_free_page(zram, index);
 
 	meta->table[index].handle = handle;
 	meta->table[index].size = clen;
+	write_unlock(&zram->meta->tb_lock);
 
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_size);
diff -puN drivers/block/zram/zram_drv.h~zram-introduce-zram-tb_lock drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-introduce-zram-tb_lock
+++ a/drivers/block/zram/zram_drv.h
@@ -83,6 +83,7 @@ struct zram_stats {
 };
 
 struct zram_meta {
+	rwlock_t tb_lock;	/* protect table */
 	void *compress_workmem;
 	void *compress_buffer;
 	struct table *table;
@@ -96,7 +97,7 @@ struct zram_slot_free {
 
 struct zram {
 	struct zram_meta *meta;
-	struct rw_semaphore lock; /* protect compression buffers, table,
+	struct rw_semaphore lock; /* protect compression buffers,
 				   * reads and writes
 				   */
 
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

