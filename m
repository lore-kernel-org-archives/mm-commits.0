From: akpm@linux-foundation.org
Subject: [merged] zram-deprecate-zram-attrs-sysfs-nodes.patch removed from -mm tree
Date: Thu, 16 Apr 2015 09:53:56 -0700
Message-ID: <552fe924.HZx0yunw0FG3EopZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43003 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbDPQs1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: deprecate zram attrs sysfs nodes
has been removed from the -mm tree.  Its filename was
     zram-deprecate-zram-attrs-sysfs-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: deprecate zram attrs sysfs nodes

Add Documentation/ABI/obsolete/sysfs-block-zram file and list obsolete and
deprecated attributes there.  The patch also adds additional information
to zram documentation and describes the basic strategy:

- the existing RW nodes will be downgraded to WO nodes (in 4.11)
- deprecated RO sysfs nodes will eventually be removed (in 4.11)

Users will be additionally notified about deprecated attr usage by
pr_warn_once() (added to every deprecated attr _show()), as suggested by
Minchan Kim.

User space is advised to use zram<id>/stat, zram<id>/io_stat and
zram<id>/mm_stat files.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/obsolete/sysfs-block-zram |  119 ++++++++++++++++++
 Documentation/blockdev/zram.txt             |   16 ++
 drivers/block/zram/zram_drv.c               |   15 ++
 3 files changed, 150 insertions(+)

diff -puN /dev/null Documentation/ABI/obsolete/sysfs-block-zram
--- /dev/null
+++ a/Documentation/ABI/obsolete/sysfs-block-zram
@@ -0,0 +1,119 @@
+What:		/sys/block/zram<id>/num_reads
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The num_reads file is read-only and specifies the number of
+		reads (failed or successful) done on this device.
+		Now accessible via zram<id>/stat node.
+
+What:		/sys/block/zram<id>/num_writes
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The num_writes file is read-only and specifies the number of
+		writes (failed or successful) done on this device.
+		Now accessible via zram<id>/stat node.
+
+What:		/sys/block/zram<id>/invalid_io
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The invalid_io file is read-only and specifies the number of
+		non-page-size-aligned I/O requests issued to this device.
+		Now accessible via zram<id>/io_stat node.
+
+What:		/sys/block/zram<id>/failed_reads
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The failed_reads file is read-only and specifies the number of
+		failed reads happened on this device.
+		Now accessible via zram<id>/io_stat node.
+
+What:		/sys/block/zram<id>/failed_writes
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The failed_writes file is read-only and specifies the number of
+		failed writes happened on this device.
+		Now accessible via zram<id>/io_stat node.
+
+What:		/sys/block/zram<id>/notify_free
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The notify_free file is read-only. Depending on device usage
+		scenario it may account a) the number of pages freed because
+		of swap slot free notifications or b) the number of pages freed
+		because of REQ_DISCARD requests sent by bio. The former ones
+		are sent to a swap block device when a swap slot is freed, which
+		implies that this disk is being used as a swap disk. The latter
+		ones are sent by filesystem mounted with discard option,
+		whenever some data blocks are getting discarded.
+		Now accessible via zram<id>/io_stat node.
+
+What:		/sys/block/zram<id>/zero_pages
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The zero_pages file is read-only and specifies number of zero
+		filled pages written to this disk. No memory is allocated for
+		such pages.
+		Now accessible via zram<id>/mm_stat node.
+
+What:		/sys/block/zram<id>/orig_data_size
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The orig_data_size file is read-only and specifies uncompressed
+		size of data stored in this disk. This excludes zero-filled
+		pages (zero_pages) since no memory is allocated for them.
+		Unit: bytes
+		Now accessible via zram<id>/mm_stat node.
+
+What:		/sys/block/zram<id>/compr_data_size
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The compr_data_size file is read-only and specifies compressed
+		size of data stored in this disk. So, compression ratio can be
+		calculated using orig_data_size and this statistic.
+		Unit: bytes
+		Now accessible via zram<id>/mm_stat node.
+
+What:		/sys/block/zram<id>/mem_used_total
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The mem_used_total file is read-only and specifies the amount
+		of memory, including allocator fragmentation and metadata
+		overhead, allocated for this disk. So, allocator space
+		efficiency can be calculated using compr_data_size and this
+		statistic.
+		Unit: bytes
+		Now accessible via zram<id>/mm_stat node.
+
+What:		/sys/block/zram<id>/mem_used_max
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The mem_used_max file is read/write and specifies the amount
+		of maximum memory zram have consumed to store compressed data.
+		For resetting the value, you should write "0". Otherwise,
+		you could see -EINVAL.
+		Unit: bytes
+		Downgraded to write-only node: so it's possible to set new
+		value only; its current value is stored in zram<id>/mm_stat
+		node.
+
+What:		/sys/block/zram<id>/mem_limit
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The mem_limit file is read/write and specifies the maximum
+		amount of memory ZRAM can use to store the compressed data.
+		The limit could be changed in run time and "0" means disable
+		the limit.  No limit is the initial state.  Unit: bytes
+		Downgraded to write-only node: so it's possible to set new
+		value only; its current value is stored in zram<id>/mm_stat
+		node.
diff -puN Documentation/blockdev/zram.txt~zram-deprecate-zram-attrs-sysfs-nodes Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-deprecate-zram-attrs-sysfs-nodes
+++ a/Documentation/blockdev/zram.txt
@@ -128,6 +128,22 @@ mem_limit         RW    the maximum amou
 num_migrated      RO    the number of objects migrated migrated by compaction
 
 
+WARNING
+=======
+per-stat sysfs attributes are considered to be deprecated.
+The basic strategy is:
+-- the existing RW nodes will be downgraded to WO nodes (in linux 4.11)
+-- deprecated RO sysfs nodes will eventually be removed (in linux 4.11)
+
+The list of deprecated attributes can be found here:
+Documentation/ABI/obsolete/sysfs-block-zram
+
+Basically, every attribute that has its own read accessible sysfs node
+(e.g. num_reads) *AND* is accessible via one of the stat files (zram<id>/stat
+or zram<id>/io_stat or zram<id>/mm_stat) is considered to be deprecated.
+
+User space is advised to use the following files to read the device statistics.
+
 File /sys/block/zram<id>/stat
 
 Represents block layer statistics. Read Documentation/block/stat.txt for
diff -puN drivers/block/zram/zram_drv.c~zram-deprecate-zram-attrs-sysfs-nodes drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-deprecate-zram-attrs-sysfs-nodes
+++ a/drivers/block/zram/zram_drv.c
@@ -43,11 +43,22 @@ static const char *default_compressor =
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+static inline void deprecated_attr_warn(const char *name)
+{
+	pr_warn_once("%d (%s) Attribute %s (and others) will be removed. %s\n",
+			task_pid_nr(current),
+			current->comm,
+			name,
+			"See zram documentation.");
+}
+
 #define ZRAM_ATTR_RO(name)						\
 static ssize_t name##_show(struct device *d,		\
 				struct device_attribute *attr, char *b)	\
 {									\
 	struct zram *zram = dev_to_zram(d);				\
+									\
+	deprecated_attr_warn(__stringify(name));			\
 	return scnprintf(b, PAGE_SIZE, "%llu\n",			\
 		(u64)atomic64_read(&zram->stats.name));			\
 }									\
@@ -89,6 +100,7 @@ static ssize_t orig_data_size_show(struc
 {
 	struct zram *zram = dev_to_zram(dev);
 
+	deprecated_attr_warn("orig_data_size");
 	return scnprintf(buf, PAGE_SIZE, "%llu\n",
 		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
@@ -99,6 +111,7 @@ static ssize_t mem_used_total_show(struc
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
 
+	deprecated_attr_warn("mem_used_total");
 	down_read(&zram->init_lock);
 	if (init_done(zram)) {
 		struct zram_meta *meta = zram->meta;
@@ -128,6 +141,7 @@ static ssize_t mem_limit_show(struct dev
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
+	deprecated_attr_warn("mem_limit");
 	down_read(&zram->init_lock);
 	val = zram->limit_pages;
 	up_read(&zram->init_lock);
@@ -159,6 +173,7 @@ static ssize_t mem_used_max_show(struct
 	u64 val = 0;
 	struct zram *zram = dev_to_zram(dev);
 
+	deprecated_attr_warn("mem_used_max");
 	down_read(&zram->init_lock);
 	if (init_done(zram))
 		val = atomic_long_read(&zram->stats.max_used_pages);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zram-return-zram-device_id-value-from-zram_add.patch
zram-introduce-automatic-device_id-generation.patch
zram-introduce-automatic-device_id-generation-fix.patch
zram-do-not-let-user-enforce-new-device-dev_id.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch

