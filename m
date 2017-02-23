From: akpm@linux-foundation.org
Subject: [merged] zram-remove-obsolete-sysfs-attrs.patch removed from -mm
 tree
Date: Thu, 23 Feb 2017 13:17:39 -0800
Message-ID: <58af5173.coFSMTJGe7a9qoG1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41624 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdBWVRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:17:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky.work@gmail.com, corbet@lwn.net, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove obsolete sysfs attrs
has been removed from the -mm tree.  Its filename was
     zram-remove-obsolete-sysfs-attrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zram: remove obsolete sysfs attrs

We had a deprecated_attr_warn() warning for 2 years and now the time has
come and we finally can do the cleanup.

The plan was as follows:

: per-stat sysfs attributes are considered to be deprecated.
: The basic strategy is:
: -- the existing RW nodes will be downgraded to WO nodes (in linux 4.11)
: -- deprecated RO sysfs nodes will eventually be removed (in linux 4.11)
:
: The list of deprecated attributes can be found here:
: Documentation/ABI/obsolete/sysfs-block-zram
:
: Basically, every attribute that has its own read accessible sysfs
: node (e.g. num_reads) *AND* is accessible via one of the stat files
: (zram<id>/stat or zram<id>/io_stat or zram<id>/mm_stat) is considered
: to be deprecated.

The patch also removes `obsolete/sysfs-block-zram', clean ups
`testing/sysfs-block-zram' and tweaks zram.txt files.

Link: http://lkml.kernel.org/r/20170118035838.11090-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/obsolete/sysfs-block-zram |  119 ------------------
 Documentation/ABI/testing/sysfs-block-zram  |  101 +--------------
 Documentation/blockdev/zram.txt             |   74 ++++-------
 drivers/block/zram/zram_drv.c               |  101 ---------------
 4 files changed, 42 insertions(+), 353 deletions(-)

diff -puN Documentation/ABI/obsolete/sysfs-block-zram~zram-remove-obsolete-sysfs-attrs /dev/null
--- a/Documentation/ABI/obsolete/sysfs-block-zram
+++ /dev/null
@@ -1,119 +0,0 @@
-What:		/sys/block/zram<id>/num_reads
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The num_reads file is read-only and specifies the number of
-		reads (failed or successful) done on this device.
-		Now accessible via zram<id>/stat node.
-
-What:		/sys/block/zram<id>/num_writes
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The num_writes file is read-only and specifies the number of
-		writes (failed or successful) done on this device.
-		Now accessible via zram<id>/stat node.
-
-What:		/sys/block/zram<id>/invalid_io
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The invalid_io file is read-only and specifies the number of
-		non-page-size-aligned I/O requests issued to this device.
-		Now accessible via zram<id>/io_stat node.
-
-What:		/sys/block/zram<id>/failed_reads
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The failed_reads file is read-only and specifies the number of
-		failed reads happened on this device.
-		Now accessible via zram<id>/io_stat node.
-
-What:		/sys/block/zram<id>/failed_writes
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The failed_writes file is read-only and specifies the number of
-		failed writes happened on this device.
-		Now accessible via zram<id>/io_stat node.
-
-What:		/sys/block/zram<id>/notify_free
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The notify_free file is read-only. Depending on device usage
-		scenario it may account a) the number of pages freed because
-		of swap slot free notifications or b) the number of pages freed
-		because of REQ_DISCARD requests sent by bio. The former ones
-		are sent to a swap block device when a swap slot is freed, which
-		implies that this disk is being used as a swap disk. The latter
-		ones are sent by filesystem mounted with discard option,
-		whenever some data blocks are getting discarded.
-		Now accessible via zram<id>/io_stat node.
-
-What:		/sys/block/zram<id>/zero_pages
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The zero_pages file is read-only and specifies number of zero
-		filled pages written to this disk. No memory is allocated for
-		such pages.
-		Now accessible via zram<id>/mm_stat node.
-
-What:		/sys/block/zram<id>/orig_data_size
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The orig_data_size file is read-only and specifies uncompressed
-		size of data stored in this disk. This excludes zero-filled
-		pages (zero_pages) since no memory is allocated for them.
-		Unit: bytes
-		Now accessible via zram<id>/mm_stat node.
-
-What:		/sys/block/zram<id>/compr_data_size
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The compr_data_size file is read-only and specifies compressed
-		size of data stored in this disk. So, compression ratio can be
-		calculated using orig_data_size and this statistic.
-		Unit: bytes
-		Now accessible via zram<id>/mm_stat node.
-
-What:		/sys/block/zram<id>/mem_used_total
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The mem_used_total file is read-only and specifies the amount
-		of memory, including allocator fragmentation and metadata
-		overhead, allocated for this disk. So, allocator space
-		efficiency can be calculated using compr_data_size and this
-		statistic.
-		Unit: bytes
-		Now accessible via zram<id>/mm_stat node.
-
-What:		/sys/block/zram<id>/mem_used_max
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The mem_used_max file is read/write and specifies the amount
-		of maximum memory zram have consumed to store compressed data.
-		For resetting the value, you should write "0". Otherwise,
-		you could see -EINVAL.
-		Unit: bytes
-		Downgraded to write-only node: so it's possible to set new
-		value only; its current value is stored in zram<id>/mm_stat
-		node.
-
-What:		/sys/block/zram<id>/mem_limit
-Date:		August 2015
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The mem_limit file is read/write and specifies the maximum
-		amount of memory ZRAM can use to store the compressed data.
-		The limit could be changed in run time and "0" means disable
-		the limit.  No limit is the initial state.  Unit: bytes
-		Downgraded to write-only node: so it's possible to set new
-		value only; its current value is stored in zram<id>/mm_stat
-		node.
diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-remove-obsolete-sysfs-attrs Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-remove-obsolete-sysfs-attrs
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -22,41 +22,6 @@ Description:
 		device. The reset operation frees all the memory associated
 		with this device.
 
-What:		/sys/block/zram<id>/num_reads
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The num_reads file is read-only and specifies the number of
-		reads (failed or successful) done on this device.
-
-What:		/sys/block/zram<id>/num_writes
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The num_writes file is read-only and specifies the number of
-		writes (failed or successful) done on this device.
-
-What:		/sys/block/zram<id>/invalid_io
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The invalid_io file is read-only and specifies the number of
-		non-page-size-aligned I/O requests issued to this device.
-
-What:		/sys/block/zram<id>/failed_reads
-Date:		February 2014
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The failed_reads file is read-only and specifies the number of
-		failed reads happened on this device.
-
-What:		/sys/block/zram<id>/failed_writes
-Date:		February 2014
-Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
-Description:
-		The failed_writes file is read-only and specifies the number of
-		failed writes happened on this device.
-
 What:		/sys/block/zram<id>/max_comp_streams
 Date:		February 2014
 Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
@@ -73,74 +38,24 @@ Description:
 		available and selected compression algorithms, change
 		compression algorithm selection.
 
-What:		/sys/block/zram<id>/notify_free
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The notify_free file is read-only. Depending on device usage
-		scenario it may account a) the number of pages freed because
-		of swap slot free notifications or b) the number of pages freed
-		because of REQ_DISCARD requests sent by bio. The former ones
-		are sent to a swap block device when a swap slot is freed, which
-		implies that this disk is being used as a swap disk. The latter
-		ones are sent by filesystem mounted with discard option,
-		whenever some data blocks are getting discarded.
-
-What:		/sys/block/zram<id>/zero_pages
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The zero_pages file is read-only and specifies number of zero
-		filled pages written to this disk. No memory is allocated for
-		such pages.
-
-What:		/sys/block/zram<id>/orig_data_size
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The orig_data_size file is read-only and specifies uncompressed
-		size of data stored in this disk. This excludes zero-filled
-		pages (zero_pages) since no memory is allocated for them.
-		Unit: bytes
-
-What:		/sys/block/zram<id>/compr_data_size
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The compr_data_size file is read-only and specifies compressed
-		size of data stored in this disk. So, compression ratio can be
-		calculated using orig_data_size and this statistic.
-		Unit: bytes
-
-What:		/sys/block/zram<id>/mem_used_total
-Date:		August 2010
-Contact:	Nitin Gupta <ngupta@vflare.org>
-Description:
-		The mem_used_total file is read-only and specifies the amount
-		of memory, including allocator fragmentation and metadata
-		overhead, allocated for this disk. So, allocator space
-		efficiency can be calculated using compr_data_size and this
-		statistic.
-		Unit: bytes
-
 What:		/sys/block/zram<id>/mem_used_max
 Date:		August 2014
 Contact:	Minchan Kim <minchan@kernel.org>
 Description:
-		The mem_used_max file is read/write and specifies the amount
-		of maximum memory zram have consumed to store compressed data.
-		For resetting the value, you should write "0". Otherwise,
-		you could see -EINVAL.
+		The mem_used_max file is write-only and is used to reset
+		the counter of maximum memory zram have consumed to store
+		compressed data. For resetting the value, you should write
+		"0". Otherwise, you could see -EINVAL.
 		Unit: bytes
 
 What:		/sys/block/zram<id>/mem_limit
 Date:		August 2014
 Contact:	Minchan Kim <minchan@kernel.org>
 Description:
-		The mem_limit file is read/write and specifies the maximum
-		amount of memory ZRAM can use to store the compressed data.  The
-		limit could be changed in run time and "0" means disable the
-		limit.  No limit is the initial state.  Unit: bytes
+		The mem_limit file is write-only and specifies the maximum
+		amount of memory ZRAM can use to store the compressed data.
+		The limit could be changed in run time and "0" means disable
+		the limit. No limit is the initial state.  Unit: bytes
 
 What:		/sys/block/zram<id>/compact
 Date:		August 2015
diff -puN Documentation/blockdev/zram.txt~zram-remove-obsolete-sysfs-attrs Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-remove-obsolete-sysfs-attrs
+++ a/Documentation/blockdev/zram.txt
@@ -161,42 +161,14 @@ Name            access            descri
 disksize          RW    show and set the device's disk size
 initstate         RO    shows the initialization state of the device
 reset             WO    trigger device reset
-num_reads         RO    the number of reads
-failed_reads      RO    the number of failed reads
-num_write         RO    the number of writes
-failed_writes     RO    the number of failed writes
-invalid_io        RO    the number of non-page-size-aligned I/O requests
+mem_used_max      WO    reset the `mem_used_max' counter (see later)
+mem_limit         WO    specifies the maximum amount of memory ZRAM can use
+                        to store the compressed data
 max_comp_streams  RW    the number of possible concurrent compress operations
 comp_algorithm    RW    show and change the compression algorithm
-notify_free       RO    the number of notifications to free pages (either
-                        slot free notifications or REQ_DISCARD requests)
-zero_pages        RO    the number of zero filled pages written to this disk
-orig_data_size    RO    uncompressed size of data stored in this disk
-compr_data_size   RO    compressed size of data stored in this disk
-mem_used_total    RO    the amount of memory allocated for this disk
-mem_used_max      RW    the maximum amount of memory zram have consumed to
-                        store the data (to reset this counter to the actual
-                        current value, write 1 to this attribute)
-mem_limit         RW    the maximum amount of memory ZRAM can use to store
-                        the compressed data
-pages_compacted   RO    the number of pages freed during compaction
-                        (available only via zram<id>/mm_stat node)
 compact           WO    trigger memory compaction
 debug_stat        RO    this file is used for zram debugging purposes
 
-WARNING
-=======
-per-stat sysfs attributes are considered to be deprecated.
-The basic strategy is:
--- the existing RW nodes will be downgraded to WO nodes (in linux 4.11)
--- deprecated RO sysfs nodes will eventually be removed (in linux 4.11)
-
-The list of deprecated attributes can be found here:
-Documentation/ABI/obsolete/sysfs-block-zram
-
-Basically, every attribute that has its own read accessible sysfs node
-(e.g. num_reads) *AND* is accessible via one of the stat files (zram<id>/stat
-or zram<id>/io_stat or zram<id>/mm_stat) is considered to be deprecated.
 
 User space is advised to use the following files to read the device statistics.
 
@@ -211,22 +183,40 @@ The stat file represents device's I/O st
 layer and, thus, not available in zram<id>/stat file. It consists of a
 single line of text and contains the following stats separated by
 whitespace:
-	failed_reads
-	failed_writes
-	invalid_io
-	notify_free
+ failed_reads     the number of failed reads
+ failed_writes    the number of failed writes
+ invalid_io       the number of non-page-size-aligned I/O requests
+ notify_free      Depending on device usage scenario it may account
+                  a) the number of pages freed because of swap slot free
+                  notifications or b) the number of pages freed because of
+                  REQ_DISCARD requests sent by bio. The former ones are
+                  sent to a swap block device when a swap slot is freed,
+                  which implies that this disk is being used as a swap disk.
+                  The latter ones are sent by filesystem mounted with
+                  discard option, whenever some data blocks are getting
+                  discarded.
 
 File /sys/block/zram<id>/mm_stat
 
 The stat file represents device's mm statistics. It consists of a single
 line of text and contains the following stats separated by whitespace:
-	orig_data_size
-	compr_data_size
-	mem_used_total
-	mem_limit
-	mem_used_max
-	zero_pages
-	num_migrated
+ orig_data_size   uncompressed size of data stored in this disk.
+                  This excludes zero-filled pages (zero_pages) since no
+                  memory is allocated for them.
+                  Unit: bytes
+ compr_data_size  compressed size of data stored in this disk
+ mem_used_total   the amount of memory allocated for this disk. This
+                  includes allocator fragmentation and metadata overhead,
+                  allocated for this disk. So, allocator space efficiency
+                  can be calculated using compr_data_size and this statistic.
+                  Unit: bytes
+ mem_limit        the maximum amount of memory ZRAM can use to store
+                  the compressed data
+ mem_used_max     the maximum amount of memory zram have consumed to
+                  store the data
+ zero_pages       the number of zero filled pages written to this disk.
+                  No memory is allocated for such pages.
+ pages_compacted  the number of pages freed during compaction
 
 9) Deactivate:
 	swapoff /dev/zram0
diff -puN drivers/block/zram/zram_drv.c~zram-remove-obsolete-sysfs-attrs drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-obsolete-sysfs-attrs
+++ a/drivers/block/zram/zram_drv.c
@@ -45,27 +45,6 @@ static const char *default_compressor =
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
-static inline void deprecated_attr_warn(const char *name)
-{
-	pr_warn_once("%d (%s) Attribute %s (and others) will be removed. %s\n",
-			task_pid_nr(current),
-			current->comm,
-			name,
-			"See zram documentation.");
-}
-
-#define ZRAM_ATTR_RO(name)						\
-static ssize_t name##_show(struct device *d,				\
-				struct device_attribute *attr, char *b)	\
-{									\
-	struct zram *zram = dev_to_zram(d);				\
-									\
-	deprecated_attr_warn(__stringify(name));			\
-	return scnprintf(b, PAGE_SIZE, "%llu\n",			\
-		(u64)atomic64_read(&zram->stats.name));			\
-}									\
-static DEVICE_ATTR_RO(name);
-
 static inline bool init_done(struct zram *zram)
 {
 	return zram->disksize;
@@ -218,47 +197,6 @@ static ssize_t disksize_show(struct devi
 	return scnprintf(buf, PAGE_SIZE, "%llu\n", zram->disksize);
 }
 
-static ssize_t orig_data_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	deprecated_attr_warn("orig_data_size");
-	return scnprintf(buf, PAGE_SIZE, "%llu\n",
-		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
-}
-
-static ssize_t mem_used_total_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	u64 val = 0;
-	struct zram *zram = dev_to_zram(dev);
-
-	deprecated_attr_warn("mem_used_total");
-	down_read(&zram->init_lock);
-	if (init_done(zram)) {
-		struct zram_meta *meta = zram->meta;
-		val = zs_get_total_pages(meta->mem_pool);
-	}
-	up_read(&zram->init_lock);
-
-	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
-}
-
-static ssize_t mem_limit_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	u64 val;
-	struct zram *zram = dev_to_zram(dev);
-
-	deprecated_attr_warn("mem_limit");
-	down_read(&zram->init_lock);
-	val = zram->limit_pages;
-	up_read(&zram->init_lock);
-
-	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
-}
-
 static ssize_t mem_limit_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -277,21 +215,6 @@ static ssize_t mem_limit_store(struct de
 	return len;
 }
 
-static ssize_t mem_used_max_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	u64 val = 0;
-	struct zram *zram = dev_to_zram(dev);
-
-	deprecated_attr_warn("mem_used_max");
-	down_read(&zram->init_lock);
-	if (init_done(zram))
-		val = atomic_long_read(&zram->stats.max_used_pages);
-	up_read(&zram->init_lock);
-
-	return scnprintf(buf, PAGE_SIZE, "%llu\n", val << PAGE_SHIFT);
-}
-
 static ssize_t mem_used_max_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -467,14 +390,6 @@ static ssize_t debug_stat_show(struct de
 static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
 static DEVICE_ATTR_RO(debug_stat);
-ZRAM_ATTR_RO(num_reads);
-ZRAM_ATTR_RO(num_writes);
-ZRAM_ATTR_RO(failed_reads);
-ZRAM_ATTR_RO(failed_writes);
-ZRAM_ATTR_RO(invalid_io);
-ZRAM_ATTR_RO(notify_free);
-ZRAM_ATTR_RO(zero_pages);
-ZRAM_ATTR_RO(compr_data_size);
 
 static inline bool zram_meta_get(struct zram *zram)
 {
@@ -1188,10 +1103,8 @@ static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
 static DEVICE_ATTR_WO(reset);
-static DEVICE_ATTR_RO(orig_data_size);
-static DEVICE_ATTR_RO(mem_used_total);
-static DEVICE_ATTR_RW(mem_limit);
-static DEVICE_ATTR_RW(mem_used_max);
+static DEVICE_ATTR_WO(mem_limit);
+static DEVICE_ATTR_WO(mem_used_max);
 static DEVICE_ATTR_RW(max_comp_streams);
 static DEVICE_ATTR_RW(comp_algorithm);
 
@@ -1199,17 +1112,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_disksize.attr,
 	&dev_attr_initstate.attr,
 	&dev_attr_reset.attr,
-	&dev_attr_num_reads.attr,
-	&dev_attr_num_writes.attr,
-	&dev_attr_failed_reads.attr,
-	&dev_attr_failed_writes.attr,
 	&dev_attr_compact.attr,
-	&dev_attr_invalid_io.attr,
-	&dev_attr_notify_free.attr,
-	&dev_attr_zero_pages.attr,
-	&dev_attr_orig_data_size.attr,
-	&dev_attr_compr_data_size.attr,
-	&dev_attr_mem_used_total.attr,
 	&dev_attr_mem_limit.attr,
 	&dev_attr_mem_used_max.attr,
 	&dev_attr_max_comp_streams.attr,
_

Patches currently in -mm which might be from sergey.senozhatsky.work@gmail.com are


