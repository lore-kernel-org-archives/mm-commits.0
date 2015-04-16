From: akpm@linux-foundation.org
Subject: [merged] zram-export-new-io_stat-sysfs-attrs.patch removed from
 -mm tree
Date: Thu, 16 Apr 2015 09:53:52 -0700
Message-ID: <552fe920.2NHxsOGEvoIm/aAd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42995 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbDPQsX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: export new 'io_stat' sysfs attrs
has been removed from the -mm tree.  Its filename was
     zram-export-new-io_stat-sysfs-attrs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: export new 'io_stat' sysfs attrs

Per-device `zram<id>/io_stat' file provides accumulated I/O statistics of
particular zram device in a format similar to block layer statistics.  The
file consists of a single line and represents the following stats
(separated by whitespace):

	failed_reads
	failed_writes
	invalid_io
	notify_free

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    9 ++++++++
 Documentation/blockdev/zram.txt            |   11 ++++++++++
 drivers/block/zram/zram_drv.c              |   20 +++++++++++++++++++
 3 files changed, 40 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-export-new-io_stat-sysfs-attrs Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-export-new-io_stat-sysfs-attrs
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -149,3 +149,12 @@ Description:
 		The compact file is write-only and trigger compaction for
 		allocator zrm uses. The allocator moves some objects so that
 		it could free fragment space.
+
+What:		/sys/block/zram<id>/io_stat
+Date:		August 2015
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The io_stat file is read-only and accumulates device's I/O
+		statistics not accounted by block layer. For example,
+		failed_reads, failed_writes, etc. File format is similar to
+		block layer statistics file format.
diff -puN Documentation/blockdev/zram.txt~zram-export-new-io_stat-sysfs-attrs Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-export-new-io_stat-sysfs-attrs
+++ a/Documentation/blockdev/zram.txt
@@ -133,6 +133,17 @@ File /sys/block/zram<id>/stat
 Represents block layer statistics. Read Documentation/block/stat.txt for
 details.
 
+File /sys/block/zram<id>/io_stat
+
+The stat file represents device's I/O statistics not accounted by block
+layer and, thus, not available in zram<id>/stat file. It consists of a
+single line of text and contains the following stats separated by
+whitespace:
+	failed_reads
+	failed_writes
+	invalid_io
+	notify_free
+
 8) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
diff -puN drivers/block/zram/zram_drv.c~zram-export-new-io_stat-sysfs-attrs drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-export-new-io_stat-sysfs-attrs
+++ a/drivers/block/zram/zram_drv.c
@@ -1033,6 +1033,25 @@ static DEVICE_ATTR_RW(mem_used_max);
 static DEVICE_ATTR_RW(max_comp_streams);
 static DEVICE_ATTR_RW(comp_algorithm);
 
+static ssize_t io_stat_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	ssize_t ret;
+
+	down_read(&zram->init_lock);
+	ret = scnprintf(buf, PAGE_SIZE,
+			"%8llu %8llu %8llu %8llu\n",
+			(u64)atomic64_read(&zram->stats.failed_reads),
+			(u64)atomic64_read(&zram->stats.failed_writes),
+			(u64)atomic64_read(&zram->stats.invalid_io),
+			(u64)atomic64_read(&zram->stats.notify_free));
+	up_read(&zram->init_lock);
+
+	return ret;
+}
+
+static DEVICE_ATTR_RO(io_stat);
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
 ZRAM_ATTR_RO(failed_reads);
@@ -1060,6 +1079,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_mem_used_max.attr,
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
+	&dev_attr_io_stat.attr,
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

