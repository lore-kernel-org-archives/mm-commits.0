From: akpm@linux-foundation.org
Subject: [withdrawn]
 zram-export-the-number-of-available-comp-streams.patch removed from -mm
 tree
Date: Thu, 17 Mar 2016 18:41:00 -0700
Message-ID: <56eb5cac.HqWyHXxnWacAhY5u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbcCRBlC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2016 21:41:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: export the number of available comp streams
has been removed from the -mm tree.  Its filename was
     zram-export-the-number-of-available-comp-streams.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: export the number of available comp streams

I've been asked several very simple questions:
a) How can I ensure that zram uses (or used) several compression
   streams?
b) What is the current number of comp streams (how much memory
   does zram *actually* use for compression streams, if there are
   more than one stream)?

zram, indeed, does not provide any info and does not answer these
questions.  Reading from `max_comp_streams' let to estimate only
theoretical comp streams memory consumption, which assumes that zram will
allocate max_comp_streams.  However, it's possible that the real number of
compression streams will never reach that max value, due to various
reasons, e.g.  max_comp_streams is too high, etc.

The patch adds `avail_streams' column to the /sys/block/zram<id>/mm_stat
device file.  For a single compression stream backend it's always 1, for a
multi stream backend - it shows the actual ->avail_strm value.

The number of allocated compression streams answers several
questions:
a) the current `level of concurrency' that the device has
   experienced
b) the amount of memory used by compression streams (by multiplying
   the `avail_streams' column value, ->buffer size and algorithm's
   specific scratch buffer size; the last are easy to find out,
   unlike `avail_streams').

[akpm@linux-foundation.org: tweak documentation text]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/blockdev/zram.txt~zram-export-the-number-of-available-comp-streams Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-export-the-number-of-available-comp-streams
+++ a/Documentation/blockdev/zram.txt
@@ -227,6 +227,16 @@ line of text and contains the following
 	mem_used_max
 	zero_pages
 	num_migrated
+	avail_streams
+
+`avail_streams' column shows the current number of available compression
+streams, which is not necessarily equal to the max number of compression
+streams.  The max number of compression streams can be set too high and
+can be unreachable (depending on the load and the usage pattern, of
+course).  `avail_streams' permits finding out the real 'level of
+concurrency' that a particular zram device saw and to calculate the real
+memory consumption by allocated compression streams, not the theoretical
+maximum value.
 
 9) Deactivate:
 	swapoff /dev/zram0
diff -puN drivers/block/zram/zcomp.c~zram-export-the-number-of-available-comp-streams drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-export-the-number-of-available-comp-streams
+++ a/drivers/block/zram/zcomp.c
@@ -183,6 +183,18 @@ static bool zcomp_strm_multi_set_max_str
 	return true;
 }
 
+static int zcomp_strm_multi_num_avail_streams(struct zcomp *comp)
+{
+	int avail;
+	struct zcomp_strm_multi *zs = comp->stream;
+
+	spin_lock(&zs->strm_lock);
+	avail = zs->avail_strm;
+	spin_unlock(&zs->strm_lock);
+
+	return avail;
+}
+
 static void zcomp_strm_multi_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_multi *zs = comp->stream;
@@ -206,6 +218,7 @@ static int zcomp_strm_multi_create(struc
 	comp->strm_find = zcomp_strm_multi_find;
 	comp->strm_release = zcomp_strm_multi_release;
 	comp->set_max_streams = zcomp_strm_multi_set_max_streams;
+	comp->num_avail_streams = zcomp_strm_multi_num_avail_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_multi), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -246,6 +259,11 @@ static bool zcomp_strm_single_set_max_st
 	return false;
 }
 
+static int zcomp_strm_single_num_avail_streams(struct zcomp *comp)
+{
+	return 1;
+}
+
 static void zcomp_strm_single_destroy(struct zcomp *comp)
 {
 	struct zcomp_strm_single *zs = comp->stream;
@@ -261,6 +279,7 @@ static int zcomp_strm_single_create(stru
 	comp->strm_find = zcomp_strm_single_find;
 	comp->strm_release = zcomp_strm_single_release;
 	comp->set_max_streams = zcomp_strm_single_set_max_streams;
+	comp->num_avail_streams = zcomp_strm_single_num_avail_streams;
 	zs = kmalloc(sizeof(struct zcomp_strm_single), GFP_KERNEL);
 	if (!zs)
 		return -ENOMEM;
@@ -304,6 +323,11 @@ bool zcomp_set_max_streams(struct zcomp
 	return comp->set_max_streams(comp, num_strm);
 }
 
+int zcomp_num_avail_streams(struct zcomp *comp)
+{
+	return comp->num_avail_streams(comp);
+}
+
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
 	return comp->strm_find(comp);
diff -puN drivers/block/zram/zcomp.h~zram-export-the-number-of-available-comp-streams drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-export-the-number-of-available-comp-streams
+++ a/drivers/block/zram/zcomp.h
@@ -47,6 +47,7 @@ struct zcomp {
 	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
 	void (*strm_release)(struct zcomp *comp, struct zcomp_strm *zstrm);
 	bool (*set_max_streams)(struct zcomp *comp, int num_strm);
+	int (*num_avail_streams)(struct zcomp *comp);
 	void (*destroy)(struct zcomp *comp);
 };
 
@@ -66,4 +67,5 @@ int zcomp_decompress(struct zcomp *comp,
 		size_t src_len, unsigned char *dst);
 
 bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
+int zcomp_num_avail_streams(struct zcomp *comp);
 #endif /* _ZCOMP_H_ */
diff -puN drivers/block/zram/zram_drv.c~zram-export-the-number-of-available-comp-streams drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-export-the-number-of-available-comp-streams
+++ a/drivers/block/zram/zram_drv.c
@@ -429,6 +429,7 @@ static ssize_t mm_stat_show(struct devic
 	struct zs_pool_stats pool_stats;
 	u64 orig_size, mem_used = 0;
 	long max_used;
+	int avail_streams = 0;
 	ssize_t ret;
 
 	memset(&pool_stats, 0x00, sizeof(struct zs_pool_stats));
@@ -437,20 +438,22 @@ static ssize_t mm_stat_show(struct devic
 	if (init_done(zram)) {
 		mem_used = zs_get_total_pages(zram->meta->mem_pool);
 		zs_pool_stats(zram->meta->mem_pool, &pool_stats);
+		avail_streams = zcomp_num_avail_streams(zram->comp);
 	}
 
 	orig_size = atomic64_read(&zram->stats.pages_stored);
 	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
 	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu\n",
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8d\n",
 			orig_size << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.compr_data_size),
 			mem_used << PAGE_SHIFT,
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.zero_pages),
-			pool_stats.pages_compacted);
+			pool_stats.pages_compacted,
+			avail_streams);
 	up_read(&zram->init_lock);
 
 	return ret;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

mm-zsmalloc-add-freeable-column-to-pool-stat.patch
printk-move-can_use_console-out-of-console_trylock_for_printk.patch
printk-set-may_schedule-for-some-of-console_trylock-callers.patch
printk-check-con_enabled-in-have_callable_console.patch

