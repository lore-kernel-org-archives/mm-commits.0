From: akpm@linux-foundation.org
Subject: + zram-zram-memory-size-limitation.patch added to -mm tree
Date: Tue, 26 Aug 2014 14:39:41 -0700
Message-ID: <53fcfe9d.XmijnsrJRFHr6yxb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:55769 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbaHZVjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 17:39:43 -0400
Received: by mail-qg0-f74.google.com with SMTP id a108so1446950qge.5
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 14:39:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, ds2horner@gmail.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, seungho1.park@lge.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: zram memory size limitation
has been added to the -mm tree.  Its filename is
     zram-zram-memory-size-limitation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-zram-memory-size-limitation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-zram-memory-size-limitation.patch

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
Subject: zram: zram memory size limitation

Since zram has no control feature to limit memory usage, it makes hard to
manage system memrory.

This patch adds new knob "mem_limit" via sysfs to set up the a limit so
that zram could fail allocation once it reaches the limit.

In addition, user could change the limit in runtime so that he could
manage the memory more dynamically.

Initial state is no limit so it doesn't break old behavior.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: <juno.choi@lge.com>
Cc: <seungho1.park@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: David Horner <ds2horner@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   10 ++++
 Documentation/blockdev/zram.txt            |   24 +++++++++--
 drivers/block/zram/zram_drv.c              |   41 +++++++++++++++++++
 drivers/block/zram/zram_drv.h              |    5 ++
 4 files changed, 76 insertions(+), 4 deletions(-)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-zram-memory-size-limitation Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-zram-memory-size-limitation
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -119,3 +119,13 @@ Description:
 		efficiency can be calculated using compr_data_size and this
 		statistic.
 		Unit: bytes
+
+What:		/sys/block/zram<id>/mem_limit
+Date:		August 2014
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		The mem_limit file is read/write and specifies the amount
+		of memory to be able to consume memory to store store
+		compressed data. The limit could be changed in run time
+		and "0" means disable the limit. No limit is the initial state.
+		Unit: bytes
diff -puN Documentation/blockdev/zram.txt~zram-zram-memory-size-limitation Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-zram-memory-size-limitation
+++ a/Documentation/blockdev/zram.txt
@@ -74,14 +74,30 @@ There is little point creating a zram of
 since we expect a 2:1 compression ratio. Note that zram uses about 0.1% of the
 size of the disk when not in use so a huge zram is wasteful.
 
-5) Activate:
+5) Set memory limit: Optional
+	Set memory limit by writing the value to sysfs node 'mem_limit'.
+	The value can be either in bytes or you can use mem suffixes.
+	In addition, you could change the value in runtime.
+	Examples:
+	    # limit /dev/zram0 with 50MB memory
+	    echo $((50*1024*1024)) > /sys/block/zram0/mem_limit
+
+	    # Using mem suffixes
+	    echo 256K > /sys/block/zram0/mem_limit
+	    echo 512M > /sys/block/zram0/mem_limit
+	    echo 1G > /sys/block/zram0/mem_limit
+
+	    # To disable memory limit
+	    echo 0 > /sys/block/zram0/mem_limit
+
+6) Activate:
 	mkswap /dev/zram0
 	swapon /dev/zram0
 
 	mkfs.ext4 /dev/zram1
 	mount /dev/zram1 /tmp
 
-6) Stats:
+7) Stats:
 	Per-device statistics are exported as various nodes under
 	/sys/block/zram<id>/
 		disksize
@@ -96,11 +112,11 @@ size of the disk when not in use so a hu
 		compr_data_size
 		mem_used_total
 
-7) Deactivate:
+8) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
 
-8) Reset:
+9) Reset:
 	Write any positive value to 'reset' sysfs node
 	echo 1 > /sys/block/zram0/reset
 	echo 1 > /sys/block/zram1/reset
diff -puN drivers/block/zram/zram_drv.c~zram-zram-memory-size-limitation drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-zram-memory-size-limitation
+++ a/drivers/block/zram/zram_drv.c
@@ -122,6 +122,33 @@ static ssize_t max_comp_streams_show(str
 	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
 }
 
+static ssize_t mem_limit_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	u64 val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->limit_pages;
+	up_read(&zram->init_lock);
+
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
+}
+
+static ssize_t mem_limit_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	u64 limit;
+	struct zram *zram = dev_to_zram(dev);
+
+	limit = memparse(buf, NULL);
+	down_write(&zram->init_lock);
+	zram->limit_pages = PAGE_ALIGN(limit) >> PAGE_SHIFT;
+	up_write(&zram->init_lock);
+
+	return len;
+}
+
 static ssize_t max_comp_streams_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -513,6 +540,14 @@ static int zram_bvec_write(struct zram *
 		ret = -ENOMEM;
 		goto out;
 	}
+
+	if (zram->limit_pages &&
+		zs_get_total_pages(meta->mem_pool) > zram->limit_pages) {
+		zs_free(meta->mem_pool, handle);
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
 
 	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
@@ -617,6 +652,9 @@ static void zram_reset_device(struct zra
 	struct zram_meta *meta;
 
 	down_write(&zram->init_lock);
+
+	zram->limit_pages = 0;
+
 	if (!init_done(zram)) {
 		up_write(&zram->init_lock);
 		return;
@@ -857,6 +895,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, i
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(mem_limit, S_IRUGO | S_IWUSR, mem_limit_show,
+		mem_limit_store);
 static DEVICE_ATTR(max_comp_streams, S_IRUGO | S_IWUSR,
 		max_comp_streams_show, max_comp_streams_store);
 static DEVICE_ATTR(comp_algorithm, S_IRUGO | S_IWUSR,
@@ -885,6 +925,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
+	&dev_attr_mem_limit.attr,
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
 	NULL,
diff -puN drivers/block/zram/zram_drv.h~zram-zram-memory-size-limitation drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-zram-memory-size-limitation
+++ a/drivers/block/zram/zram_drv.h
@@ -112,6 +112,11 @@ struct zram {
 	u64 disksize;	/* bytes */
 	int max_comp_streams;
 	struct zram_stats stats;
+	/*
+	 * the number of pages zram can consume for storing compressed data
+	 */
+	unsigned long limit_pages;
+
 	char compressor[10];
 };
 #endif
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

