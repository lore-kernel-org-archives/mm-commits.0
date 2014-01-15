From: akpm@linux-foundation.org
Subject: + zram-introduce-zram-tb_lock.patch added to -mm tree
Date: Tue, 14 Jan 2014 17:39:48 -0800
Message-ID: <52d5e6e4.yna92ZuNEjwIeTaA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35837 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 20:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: + zram-introduce-zram-tb_lock.patch added to -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 17:39:48 -0800


The patch titled
     Subject: zram: introduce zram->tb_lock
has been added to the -mm tree.  Its filename is
     zram-introduce-zram-tb_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-zram-tb_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-zram-tb_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-remove-bug_on-from-mlock_vma_page.patch
mm-hugetlb-use-get_page_foll-in-follow_hugetlb_page.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-thp-optimize-compound_trans_huge.patch
mm-tail-page-refcounting-optimization-for-slab-and-hugetlbfs.patch
mm-hugetlbfs-use-__compound_tail_refcounted-in-__get_page_tail-too.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-hugetlbc-defer-pageheadhuge-symbol-export.patch
memblock-numa-introduce-flags-field-into-memblock.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions.patch
memblock-make-memblock_set_node-support-different-memblock_type.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock.patch
acpi-numa-mem_hotplug-mark-all-nodes-the-kernel-resides-un-hotpluggable.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed.patch
x86-numa-acpi-memory-hotplug-make-movable_node-have-higher-priority.patch
mm-zswapc-change-params-from-hidden-to-ro.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
linux-next.patch
zsmalloc-move-it-under-mm.patch
zram-promote-zram-from-staging.patch
zram-remove-old-private-project-comment.patch
zram-add-copyright.patch
zsmalloc-add-copyright.patch
zram-add-zram-maintainers.patch
zsmalloc-add-maintainers.patch
zram-fix-race-between-reset-and-flushing-pending-work.patch
zram-delay-pending-free-request-in-read-path.patch
zram-remove-unnecessary-free.patch
zram-use-atomic-operation-for-stat.patch
zram-introduce-zram-tb_lock.patch
zram-remove-workqueue-for-freeing-removed-pending-slot.patch
zram-remove-zram-lock-in-read-path-and-change-it-with-mutex.patch
debugging-keep-track-of-page-owners.patch

