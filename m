From: akpm@linux-foundation.org
Subject: + zram-export-new-mm_stat-sysfs-attrs.patch added to -mm tree
Date: Mon, 16 Mar 2015 16:17:23 -0700
Message-ID: <55076483.Oe9aG4Z5nHkf0nle%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933061AbbCPXRY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 19:17:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: export new 'mm_stat' sysfs attrs
has been added to the -mm tree.  Its filename is
     zram-export-new-mm_stat-sysfs-attrs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-export-new-mm_stat-sysfs-attrs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-export-new-mm_stat-sysfs-attrs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 Documentation/blockdev/zram.txt            |   14 ++++++++
 drivers/block/zram/zram_drv.c              |   31 +++++++++++++++++++
 3 files changed, 53 insertions(+)

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
@@ -165,6 +165,20 @@ whitespace:
 	invalid_io
 	notify_free
 
+
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
+
 9) Deactivate:
 	swapoff /dev/zram0
 	umount /dev/zram1
diff -puN drivers/block/zram/zram_drv.c~zram-export-new-mm_stat-sysfs-attrs drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-export-new-mm_stat-sysfs-attrs
+++ a/drivers/block/zram/zram_drv.c
@@ -402,7 +402,37 @@ static ssize_t io_stat_show(struct devic
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
@@ -1105,6 +1135,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
 	&dev_attr_io_stat.attr,
+	&dev_attr_mm_stat.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

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
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch
zram-remove-num_migrated-device-attr.patch
zram-move-compact_store-to-sysfs-functions-area.patch
zram-use-generic-start-end-io-accounting.patch
zram-describe-device-attrs-in-documentation.patch
zram-export-new-io_stat-sysfs-attrs.patch
zram-export-new-mm_stat-sysfs-attrs.patch
zram-deprecate-zram-attrs-sysfs-nodes.patch
cpumask-dont-perform-while-loop-in-cpumask_next_and.patch
lib-lz4-pull-out-constant-tables.patch

