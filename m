From: akpm@linux-foundation.org
Subject: + zram-introduce-per-device-debug_stat-sysfs-node.patch added to
 -mm tree
Date: Wed, 11 May 2016 15:42:37 -0700
Message-ID: <5733b55d.hVsLd8nOv5POBNcn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbcEKWmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2016 18:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: introduce per-device debug_stat sysfs node
has been added to the -mm tree.  Its filename is
     zram-introduce-per-device-debug_stat-sysfs-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-introduce-per-device-debug_stat-sysfs-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-introduce-per-device-debug_stat-sysfs-node.patch

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
Subject: zram: introduce per-device debug_stat sysfs node

debug_stat sysfs is read-only and represents various debugging data that
zram developers may need.  This file is not meant to be used by anyone
else: its content is not documented and will change any time w/o any
notice.  Therefore, the output of debug_stat file contains a version
string.  To reduce the possibility of contusion, etc.  we would increase
the version number every time we modify the output.

At the moment this file exports only one value -- the number of
re-compressions, IOW, the number of times compression fast path has
failed; which is a temporarily stats, that we will be using should any
per-cpu regressions happen.  It's excepted to go away.

Link: http://lkml.kernel.org/r/20160511134553.12655-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |    7 ++++++
 Documentation/blockdev/zram.txt            |    1 
 drivers/block/zram/zram_drv.c              |   21 +++++++++++++++++++
 drivers/block/zram/zram_drv.h              |    1 
 4 files changed, 30 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-introduce-per-device-debug_stat-sysfs-node Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-introduce-per-device-debug_stat-sysfs-node
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -166,3 +166,10 @@ Description:
 		The mm_stat file is read-only and represents device's mm
 		statistics (orig_data_size, compr_data_size, etc.) in a format
 		similar to block layer statistics file format.
+
+What:		/sys/block/zram<id>/debug_stat
+Date:		July 2016
+Contact:	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
+Description:
+		The debug_stat file is read-only and represents various
+		device's debugging info.
diff -puN Documentation/blockdev/zram.txt~zram-introduce-per-device-debug_stat-sysfs-node Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-introduce-per-device-debug_stat-sysfs-node
+++ a/Documentation/blockdev/zram.txt
@@ -172,6 +172,7 @@ mem_limit         RW    the maximum amou
 pages_compacted   RO    the number of pages freed during compaction
                         (available only via zram<id>/mm_stat node)
 compact           WO    trigger memory compaction
+debug_stat        RO    this file is used for zram debugging purposes
 
 WARNING
 =======
diff -puN drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-introduce-per-device-debug_stat-sysfs-node
+++ a/drivers/block/zram/zram_drv.c
@@ -435,8 +435,26 @@ static ssize_t mm_stat_show(struct devic
 	return ret;
 }
 
+static ssize_t debug_stat_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	unsigned int version = 1;
+	struct zram *zram = dev_to_zram(dev);
+	ssize_t ret;
+
+	down_read(&zram->init_lock);
+	ret = scnprintf(buf, PAGE_SIZE,
+			"version: %d\n%8llu\n",
+			version,
+			(u64)atomic64_read(&zram->stats.num_recompress));
+	up_read(&zram->init_lock);
+
+	return ret;
+}
+
 static DEVICE_ATTR_RO(io_stat);
 static DEVICE_ATTR_RO(mm_stat);
+static DEVICE_ATTR_RO(debug_stat);
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
 ZRAM_ATTR_RO(failed_reads);
@@ -719,6 +737,8 @@ compress_again:
 		zcomp_strm_release(zram->comp, zstrm);
 		zstrm = NULL;
 
+		atomic64_inc(&zram->stats.num_recompress);
+
 		handle = zs_malloc(meta->mem_pool, clen,
 				GFP_NOIO | __GFP_HIGHMEM);
 		if (handle)
@@ -1181,6 +1201,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_comp_algorithm.attr,
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
+	&dev_attr_debug_stat.attr,
 	NULL,
 };
 
diff -puN drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-introduce-per-device-debug_stat-sysfs-node
+++ a/drivers/block/zram/zram_drv.h
@@ -85,6 +85,7 @@ struct zram_stats {
 	atomic64_t zero_pages;		/* no. of zero filled pages */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
+	atomic64_t num_recompress;	/* no. of compression slow paths */
 };
 
 struct zram_meta {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-require-gfp-in-zs_malloc.patch
zsmalloc-require-gfp-in-zs_malloc-v2.patch
zram-user-per-cpu-compression-streams.patch
zram-user-per-cpu-compression-streams-fix.patch
zram-remove-max_comp_streams-internals.patch
zram-introduce-per-device-debug_stat-sysfs-node.patch

