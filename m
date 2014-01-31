From: akpm@linux-foundation.org
Subject: [merged]
 zram-remove-zram-lock-in-read-path-and-change-it-with-mutex.patch removed
 from -mm tree
Date: Fri, 31 Jan 2014 11:16:34 -0800
Message-ID: <52ebf692.7utXv2Anri4zGr/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, ngupta@vflare.org, jmarchan@redhat.com, minchan@kernel.org

Subject: [merged] zram-remove-zram-lock-in-read-path-and-change-it-with-mutex.patch removed from -mm tree
To: minchan@kernel.org,jmarchan@redhat.com,ngupta@vflare.org,sergey.senozhatsky@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:34 -0800


The patch titled
     Subject: zram: remove zram->lock in read path and change it with mutex
has been removed from the -mm tree.  Its filename was
     zram-remove-zram-lock-in-read-path-and-change-it-with-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: remove zram->lock in read path and change it with mutex

Finally, we separated zram->lock dependency from 32bit stat/ table
handling so there is no reason to use rw_semaphore between read and write
path so this patch removes the lock from read path totally and changes
rw_semaphore with mutex.  So, we could do

old:

read-read: OK
read-write: NO
write-write: NO

Now:

read-read: OK
read-write: OK
write-write: NO

So below data proves mixed workload performs well 11 times
and there is also enhance on write-write path because current
rw-semaphore doesn't support SPIN_ON_OWNER.
It's side effect but anyway good thing for us.

Write-related test perform better(from 61% to 1058%) but
read path has good/bad(from -2.22% to 1.45%) but they are all
marginal within stddev.

CPU 12
iozone -t -T -l 12 -u 12 -r 16K -s 60M -I +Z -V 0

==Initial write           ==Initial write
records: 10               records: 10
avg:  516189.16           avg:  839907.96
std:   22486.53 (4.36%)   std:   47902.17 (5.70%)
max:  546970.60           max:  909910.35
min:  481131.54           min:  751148.38
==Rewrite                 ==Rewrite
records: 10               records: 10
avg:  509527.98           avg: 1050156.37
std:   45799.94 (8.99%)   std:   40695.44 (3.88%)
max:  611574.27           max: 1111929.26
min:  443679.95           min:  980409.62
==Read                    ==Read
records: 10               records: 10
avg: 4408624.17           avg: 4472546.76
std:  281152.61 (6.38%)   std:  163662.78 (3.66%)
max: 4867888.66           max: 4727351.03
min: 4058347.69           min: 4126520.88
==Re-read                 ==Re-read
records: 10               records: 10
avg: 4462147.53           avg: 4363257.75
std:  283546.11 (6.35%)   std:  247292.63 (5.67%)
max: 4912894.44           max: 4677241.75
min: 4131386.50           min: 4035235.84
==Reverse Read            ==Reverse Read
records: 10               records: 10
avg: 4565865.97           avg: 4485818.08
std:  313395.63 (6.86%)   std:  248470.10 (5.54%)
max: 5232749.16           max: 4789749.94
min: 4185809.62           min: 3963081.34
==Stride read             ==Stride read
records: 10               records: 10
avg: 4515981.80           avg: 4418806.01
std:  211192.32 (4.68%)   std:  212837.97 (4.82%)
max: 4889287.28           max: 4686967.22
min: 4210362.00           min: 4083041.84
==Random read             ==Random read
records: 10               records: 10
avg: 4410525.23           avg: 4387093.18
std:  236693.22 (5.37%)   std:  235285.23 (5.36%)
max: 4713698.47           max: 4669760.62
min: 4057163.62           min: 3952002.16
==Mixed workload          ==Mixed workload
records: 10               records: 10
avg:  243234.25           avg: 2818677.27
std:   28505.07 (11.72%)  std:  195569.70 (6.94%)
max:  288905.23           max: 3126478.11
min:  212473.16           min: 2484150.69
==Random write            ==Random write
records: 10               records: 10
avg:  555887.07           avg: 1053057.79
std:   70841.98 (12.74%)  std:   35195.36 (3.34%)
max:  683188.28           max: 1096125.73
min:  437299.57           min:  992481.93
==Pwrite                  ==Pwrite
records: 10               records: 10
avg:  501745.93           avg:  810363.09
std:   16373.54 (3.26%)   std:   19245.01 (2.37%)
max:  518724.52           max:  833359.70
min:  464208.73           min:  765501.87
==Pread                   ==Pread
records: 10               records: 10
avg: 4539894.60           avg: 4457680.58
std:  197094.66 (4.34%)   std:  188965.60 (4.24%)
max: 4877170.38           max: 4689905.53
min: 4226326.03           min: 4095739.72

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 ++++++++---------
 drivers/block/zram/zram_drv.h |    4 +---
 2 files changed, 9 insertions(+), 12 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-zram-lock-in-read-path-and-change-it-with-mutex drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-zram-lock-in-read-path-and-change-it-with-mutex
+++ a/drivers/block/zram/zram_drv.c
@@ -230,6 +230,7 @@ static struct zram_meta *zram_meta_alloc
 	}
 
 	rwlock_init(&meta->tb_lock);
+	mutex_init(&meta->buffer_lock);
 	return meta;
 
 free_table:
@@ -412,6 +413,7 @@ static int zram_bvec_write(struct zram *
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
+	bool locked = false;
 
 	page = bvec->bv_page;
 	src = meta->compress_buffer;
@@ -431,6 +433,8 @@ static int zram_bvec_write(struct zram *
 			goto out;
 	}
 
+	mutex_lock(&meta->buffer_lock);
+	locked = true;
 	user_mem = kmap_atomic(page);
 
 	if (is_partial_io(bvec)) {
@@ -457,7 +461,6 @@ static int zram_bvec_write(struct zram *
 
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       meta->compress_workmem);
-
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
 		user_mem = NULL;
@@ -514,6 +517,8 @@ static int zram_bvec_write(struct zram *
 		atomic_inc(&zram->stats.good_compress);
 
 out:
+	if (locked)
+		mutex_unlock(&meta->buffer_lock);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
 
@@ -527,15 +532,10 @@ static int zram_bvec_rw(struct zram *zra
 {
 	int ret;
 
-	if (rw == READ) {
-		down_read(&zram->lock);
+	if (rw == READ)
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
-		up_read(&zram->lock);
-	} else {
-		down_write(&zram->lock);
+	else
 		ret = zram_bvec_write(zram, bvec, index, offset);
-		up_write(&zram->lock);
-	}
 
 	return ret;
 }
@@ -808,7 +808,6 @@ static int create_device(struct zram *zr
 {
 	int ret = -ENOMEM;
 
-	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
 
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
diff -puN drivers/block/zram/zram_drv.h~zram-remove-zram-lock-in-read-path-and-change-it-with-mutex drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-zram-lock-in-read-path-and-change-it-with-mutex
+++ a/drivers/block/zram/zram_drv.h
@@ -88,13 +88,11 @@ struct zram_meta {
 	void *compress_buffer;
 	struct table *table;
 	struct zs_pool *mem_pool;
+	struct mutex buffer_lock; /* protect compress buffers */
 };
 
 struct zram {
 	struct zram_meta *meta;
-	struct rw_semaphore lock; /* protect compression buffers,
-				   * reads and writes
-				   */
 	struct request_queue *queue;
 	struct gendisk *disk;
 	int init_done;
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

