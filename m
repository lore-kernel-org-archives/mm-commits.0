From: akpm@linux-foundation.org
Subject: + zram-report-maximum-used-memory.patch added to -mm tree
Date: Tue, 26 Aug 2014 14:39:43 -0700
Message-ID: <53fcfe9f.E6B7Xx596oeZMQv/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:63297 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaHZVjo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 17:39:44 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so4095586pab.3
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 14:39:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, ds2horner@gmail.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, seungho1.park@lge.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: report maximum used memory
has been added to the -mm tree.  Its filename is
     zram-report-maximum-used-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-report-maximum-used-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-report-maximum-used-memory.patch

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
Subject: zram: report maximum used memory

Normally, zram user could get maximum memory usage zram consumed via
polling mem_used_total with sysfs in userspace.

But it has a critical problem because user can miss peak memory usage
during update inverval of polling.  For avoiding that, user should poll it
with shorter interval(ie, 0.0000000001s) with mlocking to avoid page fault
delay when memory pressure is heavy.  It would be troublesome.

This patch adds new knob "mem_used_max" so user could see the maximum
memory usage easily via reading the knob and reset it via "echo 0 >
/sys/block/zram0/mem_used_max".

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Dan Streetman <ddstreet@ieee.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: <juno.choi@lge.com>
Cc: <seungho1.park@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Reviewed-by: David Horner <ds2horner@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   10 +++
 Documentation/blockdev/zram.txt            |    1 
 drivers/block/zram/zram_drv.c              |   60 ++++++++++++++++++-
 drivers/block/zram/zram_drv.h              |    1 
 4 files changed, 70 insertions(+), 2 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-report-maximum-used-memory Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-report-maximum-used-memory
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -120,6 +120,16 @@ Description:
 		statistic.
 		Unit: bytes
 
+What:		/sys/block/zram<id>/mem_used_max
+Date:		August 2014
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		The mem_used_max file is read/write and specifies the amount
+		of maximum memory zram have consumed to store compressed data.
+		For resetting the value, you should write "0". Otherwise,
+		you could see -EINVAL.
+		Unit: bytes
+
 What:		/sys/block/zram<id>/mem_limit
 Date:		August 2014
 Contact:	Minchan Kim <minchan@kernel.org>
diff -puN Documentation/blockdev/zram.txt~zram-report-maximum-used-memory Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-report-maximum-used-memory
+++ a/Documentation/blockdev/zram.txt
@@ -111,6 +111,7 @@ size of the disk when not in use so a hu
 		orig_data_size
 		compr_data_size
 		mem_used_total
+		mem_used_max
 
 8) Deactivate:
 	swapoff /dev/zram0
diff -puN drivers/block/zram/zram_drv.c~zram-report-maximum-used-memory drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-report-maximum-used-memory
+++ a/drivers/block/zram/zram_drv.c
@@ -149,6 +149,41 @@ static ssize_t mem_limit_store(struct de
 	return len;
 }
 
+static ssize_t mem_used_max_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u64 val = 0;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	if (init_done(zram))
+		val = atomic_long_read(&zram->stats.max_used_pages);
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
+}
+
+static ssize_t mem_used_max_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	int err;
+	unsigned long val;
+	struct zram *zram = dev_to_zram(dev);
+	struct zram_meta *meta = zram->meta;
+
+	err = kstrtoul(buf, 10, &val);
+	if (err || val != 0)
+		return -EINVAL;
+
+	down_read(&zram->init_lock);
+	if (init_done(zram))
+		atomic_long_set(&zram->stats.max_used_pages,
+				zs_get_total_pages(meta->mem_pool));
+	up_read(&zram->init_lock);
+
+	return len;
+}
+
 static ssize_t max_comp_streams_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -461,6 +496,21 @@ out_cleanup:
 	return ret;
 }
 
+static inline void update_used_max(struct zram *zram,
+					const unsigned long pages)
+{
+	int old_max, cur_max;
+
+	old_max = atomic_long_read(&zram->stats.max_used_pages);
+
+	do {
+		cur_max = old_max;
+		if (pages > cur_max)
+			old_max = atomic_long_cmpxchg(
+				&zram->stats.max_used_pages, cur_max, pages);
+	} while (old_max != cur_max);
+}
+
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			   int offset)
 {
@@ -472,6 +522,7 @@ static int zram_bvec_write(struct zram *
 	struct zram_meta *meta = zram->meta;
 	struct zcomp_strm *zstrm;
 	bool locked = false;
+	unsigned long alloced_pages;
 
 	page = bvec->bv_page;
 	if (is_partial_io(bvec)) {
@@ -541,13 +592,15 @@ static int zram_bvec_write(struct zram *
 		goto out;
 	}
 
-	if (zram->limit_pages &&
-		zs_get_total_pages(meta->mem_pool) > zram->limit_pages) {
+	alloced_pages = zs_get_total_pages(meta->mem_pool);
+	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
 		zs_free(meta->mem_pool, handle);
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	update_used_max(zram, alloced_pages);
+
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
 
 	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
@@ -897,6 +950,8 @@ static DEVICE_ATTR(orig_data_size, S_IRU
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
 static DEVICE_ATTR(mem_limit, S_IRUGO | S_IWUSR, mem_limit_show,
 		mem_limit_store);
+static DEVICE_ATTR(mem_used_max, S_IRUGO | S_IWUSR, mem_used_max_show,
+		mem_used_max_store);
 static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
 		max_comp_streams_show, max_comp_streams_store);
 static DEVICE_ATTR(comp_algorithm, S_IRUGO | S_IWUSR,
@@ -926,6 +981,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
 	&dev_attr_mem_limit.attr,
+	&dev_attr_mem_used_max.attr,
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
 	NULL,
diff -puN drivers/block/zram/zram_drv.h~zram-report-maximum-used-memory drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-report-maximum-used-memory
+++ a/drivers/block/zram/zram_drv.h
@@ -90,6 +90,7 @@ struct zram_stats {
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic64_t zero_pages;		/* no. of zero filled pages */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
+	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
 };
 
 struct zram_meta {
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-fix-incorrectly-stat-with-failed_reads.patch
mm-zpool-use-prefixed-module-loading.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone-fix.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched-fix.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
zsmalloc-move-pages_allocated-to-zs_pool.patch
zsmalloc-change-return-value-unit-of-zs_get_total_size_bytes.patch
zram-zram-memory-size-limitation.patch
zram-zram-memory-size-limitation-fix.patch
zram-report-maximum-used-memory.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
page-owners-correct-page-order-when-to-free-page.patch

