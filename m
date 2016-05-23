From: akpm@linux-foundation.org
Subject: [merged] zram-remove-max_comp_streams-internals.patch removed
 from -mm tree
Date: Mon, 23 May 2016 12:47:56 -0700
Message-ID: <57435e6c.SNxqbwK+wAg3jNHu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37557 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbcEWTr5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove max_comp_streams internals
has been removed from the -mm tree.  Its filename was
     zram-remove-max_comp_streams-internals.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove max_comp_streams internals

Remove the internal part of max_comp_streams interface, since we switched
to per-cpu streams.  We will keep RW max_comp_streams attr around,
because:

a) we may (silently) switch back to idle compression streams list and
   don't want to disturb user space

b) max_comp_streams attr must wait for the next 'lay off cycle'; we
   give user space 2 years to adjust before we remove/downgrade the attr,
   and there are already several attrs scheduled for removal in 4.11, so
   it's too late for max_comp_streams.

This slightly change a user visible behaviour:

- First, reading from max_comp_stream file now will always return the
  number of online CPUs.

- Second, writing to max_comp_stream will not take any effect.

Link: http://lkml.kernel.org/r/20160503165546.25201-1-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/zram.txt |   25 ++++------------
 drivers/block/zram/zcomp.c      |    5 ---
 drivers/block/zram/zram_drv.c   |   45 +++++++-----------------------
 drivers/block/zram/zram_drv.h   |    1 
 4 files changed, 18 insertions(+), 58 deletions(-)

diff -puN Documentation/blockdev/zram.txt~zram-remove-max_comp_streams-internals Documentation/blockdev/zram.txt
--- a/Documentation/blockdev/zram.txt~zram-remove-max_comp_streams-internals
+++ a/Documentation/blockdev/zram.txt
@@ -59,27 +59,16 @@ num_devices parameter is optional and te
 pre-created. Default: 1.
 
 2) Set max number of compression streams
-	Compression backend may use up to max_comp_streams compression streams,
-	thus allowing up to max_comp_streams concurrent compression operations.
-	By default, compression backend uses single compression stream.
+	Regardless the value passed to this attribute, ZRAM will always
+	allocate multiple compression streams - one per online CPUs - thus
+	allowing several concurrent compression operations. The number of
+	allocated compression streams goes down when some of the CPUs
+	become offline. There is no single-compression-stream mode anymore,
+	unless you are running a UP system or has only 1 CPU online.
 
-	Examples:
-	#show max compression streams number
+	To find out how many streams are currently available:
 	cat /sys/block/zram0/max_comp_streams
 
-	#set max compression streams number to 3
-	echo 3 > /sys/block/zram0/max_comp_streams
-
-Note:
-In order to enable compression backend's multi stream support max_comp_streams
-must be initially set to desired concurrency level before ZRAM device
-initialisation. Once the device initialised as a single stream compression
-backend (max_comp_streams equals to 1), you will see error if you try to change
-the value of max_comp_streams because single stream compression backend
-implemented as a special case by lock overhead issue and does not support
-dynamic max_comp_streams. Only multi stream backend supports dynamic
-max_comp_streams adjustment.
-
 3) Select compression algorithm
 	Using comp_algorithm device attribute one can see available and
 	currently selected (shown in square brackets) compression algorithms,
diff -puN drivers/block/zram/zcomp.c~zram-remove-max_comp_streams-internals drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-remove-max_comp_streams-internals
+++ a/drivers/block/zram/zcomp.c
@@ -95,11 +95,6 @@ bool zcomp_available_algorithm(const cha
 	return find_backend(comp) != NULL;
 }
 
-bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
-{
-	return true;
-}
-
 struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
 	return *get_cpu_ptr(comp->stream);
diff -puN drivers/block/zram/zram_drv.c~zram-remove-max_comp_streams-internals drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-max_comp_streams-internals
+++ a/drivers/block/zram/zram_drv.c
@@ -304,46 +304,25 @@ static ssize_t mem_used_max_store(struct
 	return len;
 }
 
+/*
+ * We switched to per-cpu streams and this attr is not needed anymore.
+ * However, we will keep it around for some time, because:
+ * a) we may revert per-cpu streams in the future
+ * b) it's visible to user space and we need to follow our 2 years
+ *    retirement rule; but we already have a number of 'soon to be
+ *    altered' attrs, so max_comp_streams need to wait for the next
+ *    layoff cycle.
+ */
 static ssize_t max_comp_streams_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	int val;
-	struct zram *zram = dev_to_zram(dev);
-
-	down_read(&zram->init_lock);
-	val = zram->max_comp_streams;
-	up_read(&zram->init_lock);
-
-	return scnprintf(buf, PAGE_SIZE, "%d\n", val);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", num_online_cpus());
 }
 
 static ssize_t max_comp_streams_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
-	int num;
-	struct zram *zram = dev_to_zram(dev);
-	int ret;
-
-	ret = kstrtoint(buf, 0, &num);
-	if (ret < 0)
-		return ret;
-	if (num < 1)
-		return -EINVAL;
-
-	down_write(&zram->init_lock);
-	if (init_done(zram)) {
-		if (!zcomp_set_max_streams(zram->comp, num)) {
-			pr_info("Cannot change max compression streams\n");
-			ret = -EINVAL;
-			goto out;
-		}
-	}
-
-	zram->max_comp_streams = num;
-	ret = len;
-out:
-	up_write(&zram->init_lock);
-	return ret;
+	return len;
 }
 
 static ssize_t comp_algorithm_show(struct device *dev,
@@ -1035,7 +1014,6 @@ static void zram_reset_device(struct zra
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	zram->disksize = 0;
-	zram->max_comp_streams = 1;
 
 	set_capacity(zram->disk, 0);
 	part_stat_set_all(&zram->disk->part0, 0);
@@ -1299,7 +1277,6 @@ static int zram_add(void)
 	}
 	strlcpy(zram->compressor, default_compressor, sizeof(zram->compressor));
 	zram->meta = NULL;
-	zram->max_comp_streams = 1;
 
 	pr_info("Added device: %s\n", zram->disk->disk_name);
 	return device_id;
diff -puN drivers/block/zram/zram_drv.h~zram-remove-max_comp_streams-internals drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-remove-max_comp_streams-internals
+++ a/drivers/block/zram/zram_drv.h
@@ -102,7 +102,6 @@ struct zram {
 	 * the number of pages zram can consume for storing compressed data
 	 */
 	unsigned long limit_pages;
-	int max_comp_streams;
 
 	struct zram_stats stats;
 	atomic_t refcount; /* refcount for zram_meta */
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-introduce-per-device-debug_stat-sysfs-node.patch

