From: akpm@linux-foundation.org
Subject: [merged] zram-export-new-mm_stat-sysfs-attrs.patch removed from
 -mm tree
Date: Thu, 16 Apr 2015 09:53:54 -0700
Message-ID: <552fe922.cWdhTrEarPRf5h7a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbbDPQsZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: export new 'mm_stat' sysfs attrs
has been removed from the -mm tree.  Its filename was
     zram-export-new-mm_stat-sysfs-attrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: export new 'mm_stat' sysfs attrs

Per-device `zram<id>/mm_stat' file provides mm statistics of a particular
zram device in a format similar to block layer statistics.  The file
consists of a single line and represents the following stats (separated by
whitespace):

	orig_data_size
	compr_data_size
	mem_used_total
	mem_limit
	mem_used_max
	zero_pages
	num_migrated

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    8 ++++
 Documentation/blockdev/zram.txt            |   12 +++++++
 drivers/block/zram/zram_drv.c              |   31 +++++++++++++++++++
 3 files changed, 51 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-export-new-mm_stat-sysfs-attrs Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-export-new-mm_stat-sysfs-attrs
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -158,3 +158,11 @@ Description:
 		statistics not accounted by block layer. For example,
 		failed_reads, failed_writes, etc. File format is similar to
 		block layer statistics file format.
+
+What:		/sys/block/zram<id>/mm_stat
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The mm_stat file is read-only and represents device's mm
+		statistics (orig_data_size, compr_data_size, etc.) in a format
+		similar to block layer statistics file format.
diff -puN Documentation/blockdev/zram.txt~zram-export-new-mm_stat-sysfs-attrs Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-export-new-mm_stat-sysfs-attrs
+++ a/Documentation/blockdev/zram.txt
@@ -144,6 +144,18 @@ whitespace:
 	invalid_io
 	notify_free
 
+File /sys/block/zram<id>/mm_stat
+
+The stat file represents device's mm statistics. It consists of a single
+line of text and contains the following stats separated by whitespace:
+	orig_data_size
+	compr_data_size
+	mem_used_total
+	mem_limit
+	mem_used_max
+	zero_pages
+	num_migrated
+
 8) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
diff -puN drivers/block/zram/zram_drv.c~zram-export-new-mm_stat-sysfs-attrs drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-export-new-mm_stat-sysfs-attrs
+++ a/drivers/block/zram/zram_drv.c
@@ -1051,7 +1051,37 @@ static ssize_t io_stat_show(struct devic
 	return ret;
 }
 
+static ssize_t mm_stat_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u64 orig_size, mem_used = 0;
+	long max_used;
+	ssize_t ret;
+
+	down_read(&zram->init_lock);
+	if (init_done(zram))
+		mem_used = zs_get_total_pages(zram->meta->mem_pool);
+
+	orig_size = atomic64_read(&zram->stats.pages_stored);
+	max_used = atomic_long_read(&zram->stats.max_used_pages);
+
+	ret = scnprintf(buf, PAGE_SIZE,
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8llu\n",
+			orig_size << PAGE_SHIFT,
+			(u64)atomic64_read(&zram->stats.compr_data_size),
+			mem_used << PAGE_SHIFT,
+			zram->limit_pages << PAGE_SHIFT,
+			max_used << PAGE_SHIFT,
+			(u64)atomic64_read(&zram->stats.zero_pages),
+			(u64)atomic64_read(&zram->stats.num_migrated));
+	up_read(&zram->init_lock);
+
+	return ret;
+}
+
 static DEVICE_ATTR_RO(io_stat);
+static DEVICE_ATTR_RO(mm_stat);
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
 ZRAM_ATTR_RO(failed_reads);
@@ -1080,6 +1110,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
 	&dev_attr_io_stat.attr,
+	&dev_attr_mm_stat.attr,
 	NULL,
 };
 
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

