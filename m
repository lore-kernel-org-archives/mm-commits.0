From: akpm@linux-foundation.org
Subject: [merged] zram-remove-zram-stats-code-duplication.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:02:53 -0700
Message-ID: <534463fd.Qbwkej9BKqSpJaOB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbaDHVCy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:02:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-remove-zram-stats-code-duplication.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:02:53 -0700


The patch titled
     Subject: zram: remove zram stats code duplication
has been removed from the -mm tree.  Its filename was
     zram-remove-zram-stats-code-duplication.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove zram stats code duplication

Introduce ZRAM_ATTR_RO macro that generates device_attribute and default
ATTR show() function for existing atomic64_t zram stats.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   82 ++++++++------------------------
 1 file changed, 23 insertions(+), 59 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-zram-stats-code-duplication drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-zram-stats-code-duplication
+++ a/drivers/block/zram/zram_drv.c
@@ -42,6 +42,17 @@ static struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+#define ZRAM_ATTR_RO(name)						\
+static ssize_t zram_attr_##name##_show(struct device *d,		\
+				struct device_attribute *attr, char *b)	\
+{									\
+	struct zram *zram = dev_to_zram(d);				\
+	return sprintf(b, "%llu\n",					\
+		(u64)atomic64_read(&zram->stats.name));			\
+}									\
+static struct device_attribute dev_attr_##name =			\
+	__ATTR(name, S_IRUGO, zram_attr_##name##_show, NULL);
+
 static inline int init_done(struct zram *zram)
 {
 	return zram->meta != NULL;
@@ -63,53 +74,14 @@ static ssize_t disksize_show(struct devi
 static ssize_t initstate_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	u32 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", init_done(zram));
-}
-
-static ssize_t num_reads_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.num_reads));
-}
-
-static ssize_t num_writes_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.num_writes));
-}
-
-static ssize_t invalid_io_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.invalid_io));
-}
-
-static ssize_t notify_free_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.notify_free));
-}
-
-static ssize_t zero_pages_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
+	down_read(&zram->init_lock);
+	val = init_done(zram);
+	up_read(&zram->init_lock);
 
-	return sprintf(buf, "%llu\n", (u64)atomic64_read(&zram->stats.zero_pages));
+	return sprintf(buf, "%u\n", val);
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -121,15 +93,6 @@ static ssize_t orig_data_size_show(struc
 		(u64)(atomic64_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
-static ssize_t compr_data_size_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%llu\n",
-			(u64)atomic64_read(&zram->stats.compr_data_size));
-}
-
 static ssize_t mem_used_total_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -762,15 +725,16 @@ static DEVICE_ATTR(disksize, S_IRUGO | S
 		disksize_show, disksize_store);
 static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
-static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
-static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
-static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
-static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
-static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
-static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
 
+ZRAM_ATTR_RO(num_reads);
+ZRAM_ATTR_RO(num_writes);
+ZRAM_ATTR_RO(invalid_io);
+ZRAM_ATTR_RO(notify_free);
+ZRAM_ATTR_RO(zero_pages);
+ZRAM_ATTR_RO(compr_data_size);
+
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
 	&dev_attr_initstate.attr,
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

