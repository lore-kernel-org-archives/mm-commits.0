From: akpm@linux-foundation.org
Subject: + zram-use-atomic-operation-for-stat.patch added to -mm tree
Date: Tue, 14 Jan 2014 17:39:47 -0800
Message-ID: <52d5e6e3.Oi3q6fCKKZ3FBbAe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaAOBjs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jan 2014 20:39:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: + zram-use-atomic-operation-for-stat.patch added to -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com
From: akpm@linux-foundation.org
Date: Tue, 14 Jan 2014 17:39:47 -0800


The patch titled
     Subject: zram: use atomic operation for stat
has been added to the -mm tree.  Its filename is
     zram-use-atomic-operation-for-stat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-use-atomic-operation-for-stat.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-use-atomic-operation-for-stat.patch

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
Subject: zram: use atomic operation for stat

Some of fields in zram->stats are protected by zram->lock which
is rather coarse-grained so let's use atomic operation without
explict locking.

This patch is ready for removing dependency of zram->lock in
read path which is very coarse-grained rw_semaphore.
Of course, this patch adds new atomic operation so it might make
slow but my 12CPU test couldn't spot any regression.
All gain/lose is marginal within stddev.

iozone -t -T -l 12 -u 12 -r 16K -s 60M -I +Z -V 0

==Initial write	==Initial write
records: 50		records: 50
avg:  412875.17		avg:  415638.23
std:   38543.12 (9.34%)	std:   36601.11 (8.81%)
max:  521262.03		max:  502976.72
min:  343263.13		min:  351389.12
==Rewrite	==Rewrite
records: 50		records: 50
avg:  416640.34		avg:  397914.33
std:   60798.92 (14.59%)	std:   46150.42 (11.60%)
max:  543057.07		max:  522669.17
min:  304071.67		min:  316588.77
==Read	==Read
records: 50		records: 50
avg: 4147338.63		avg: 4070736.51
std:  179333.25 (4.32%)	std:  223499.89 (5.49%)
max: 4459295.28		max: 4539514.44
min: 3753057.53		min: 3444686.31
==Re-read	==Re-read
records: 50		records: 50
avg: 4096706.71		avg: 4117218.57
std:  229735.04 (5.61%)	std:  171676.25 (4.17%)
max: 4430012.09		max: 4459263.94
min: 2987217.80		min: 3666904.28
==Reverse Read	==Reverse Read
records: 50		records: 50
avg: 4062763.83		avg: 4078508.32
std:  186208.46 (4.58%)	std:  172684.34 (4.23%)
max: 4401358.78		max: 4424757.22
min: 3381625.00		min: 3679359.94
==Stride read	==Stride read
records: 50		records: 50
avg: 4094933.49		avg: 4082170.22
std:  185710.52 (4.54%)	std:  196346.68 (4.81%)
max: 4478241.25		max: 4460060.97
min: 3732593.23		min: 3584125.78
==Random read	==Random read
records: 50		records: 50
avg: 4031070.04		avg: 4074847.49
std:  192065.51 (4.76%)	std:  206911.33 (5.08%)
max: 4356931.16		max: 4399442.56
min: 3481619.62		min: 3548372.44
==Mixed workload	==Mixed workload
records: 50		records: 50
avg:  149925.73		avg:  149675.54
std:    7701.26 (5.14%)	std:    6902.09 (4.61%)
max:  191301.56		max:  175162.05
min:  133566.28		min:  137762.87
==Random write	==Random write
records: 50		records: 50
avg:  404050.11		avg:  393021.47
std:   58887.57 (14.57%)	std:   42813.70 (10.89%)
max:  601798.09		max:  524533.43
min:  325176.99		min:  313255.34
==Pwrite	==Pwrite
records: 50		records: 50
avg:  411217.70		avg:  411237.96
std:   43114.99 (10.48%)	std:   33136.29 (8.06%)
max:  530766.79		max:  471899.76
min:  320786.84		min:  317906.94
==Pread	==Pread
records: 50		records: 50
avg: 4154908.65		avg: 4087121.92
std:  151272.08 (3.64%)	std:  219505.04 (5.37%)
max: 4459478.12		max: 4435857.38
min: 3730512.41		min: 3101101.67

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   20 ++++++++++----------
 drivers/block/zram/zram_drv.h |   16 ++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-atomic-operation-for-stat drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-atomic-operation-for-stat
+++ a/drivers/block/zram/zram_drv.c
@@ -104,7 +104,7 @@ static ssize_t zero_pages_show(struct de
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", zram->stats.pages_zero);
+	return sprintf(buf, "%u\n", atomic_read(&zram->stats.pages_zero));
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -113,7 +113,7 @@ static ssize_t orig_data_size_show(struc
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		(u64)(zram->stats.pages_stored) << PAGE_SHIFT);
+		(u64)(atomic_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
 static ssize_t compr_data_size_show(struct device *dev,
@@ -293,21 +293,21 @@ static void zram_free_page(struct zram *
 		 */
 		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
 			zram_clear_flag(meta, index, ZRAM_ZERO);
-			zram->stats.pages_zero--;
+			atomic_dec(&zram->stats.pages_zero);
 		}
 		return;
 	}
 
 	if (unlikely(size > max_zpage_size))
-		zram->stats.bad_compress--;
+		atomic_dec(&zram->stats.bad_compress);
 
 	zs_free(meta->mem_pool, handle);
 
 	if (size <= PAGE_SIZE / 2)
-		zram->stats.good_compress--;
+		atomic_dec(&zram->stats.good_compress);
 
 	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
-	zram->stats.pages_stored--;
+	atomic_dec(&zram->stats.pages_stored);
 
 	meta->table[index].handle = 0;
 	meta->table[index].size = 0;
@@ -435,7 +435,7 @@ static int zram_bvec_write(struct zram *
 		/* Free memory associated with this sector now. */
 		zram_free_page(zram, index);
 
-		zram->stats.pages_zero++;
+		atomic_inc(&zram->stats.pages_zero);
 		zram_set_flag(meta, index, ZRAM_ZERO);
 		ret = 0;
 		goto out;
@@ -456,7 +456,7 @@ static int zram_bvec_write(struct zram *
 	}
 
 	if (unlikely(clen > max_zpage_size)) {
-		zram->stats.bad_compress++;
+		atomic_inc(&zram->stats.bad_compress);
 		clen = PAGE_SIZE;
 		src = NULL;
 		if (is_partial_io(bvec))
@@ -493,9 +493,9 @@ static int zram_bvec_write(struct zram *
 
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_size);
-	zram->stats.pages_stored++;
+	atomic_inc(&zram->stats.pages_stored);
 	if (clen <= PAGE_SIZE / 2)
-		zram->stats.good_compress++;
+		atomic_inc(&zram->stats.good_compress);
 
 out:
 	if (is_partial_io(bvec))
diff -puN drivers/block/zram/zram_drv.h~zram-use-atomic-operation-for-stat drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-use-atomic-operation-for-stat
+++ a/drivers/block/zram/zram_drv.h
@@ -68,10 +68,6 @@ struct table {
 	u8 flags;
 } __aligned(4);
 
-/*
- * All 64bit fields should only be manipulated by 64bit atomic accessors.
- * All modifications to 32bit counter should be protected by zram->lock.
- */
 struct zram_stats {
 	atomic64_t compr_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
@@ -80,10 +76,10 @@ struct zram_stats {
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
-	u32 pages_zero;		/* no. of zero filled pages */
-	u32 pages_stored;	/* no. of pages currently stored */
-	u32 good_compress;	/* % of pages with compression ratio<=50% */
-	u32 bad_compress;	/* % of pages with compression ratio>=75% */
+	atomic_t pages_zero;		/* no. of zero filled pages */
+	atomic_t pages_stored;	/* no. of pages currently stored */
+	atomic_t good_compress;	/* % of pages with compression ratio<=50% */
+	atomic_t bad_compress;	/* % of pages with compression ratio>=75% */
 };
 
 struct zram_meta {
@@ -101,8 +97,8 @@ struct zram_slot_free {
 struct zram {
 	struct zram_meta *meta;
 	struct rw_semaphore lock; /* protect compression buffers, table,
-				   * 32bit stat counters against concurrent
-				   * notifications, reads and writes */
+				   * reads and writes
+				   */
 
 	struct work_struct free_work;  /* handle pending free request */
 	struct zram_slot_free *slot_free_rq; /* list head of free request */
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

