From: akpm@linux-foundation.org
Subject: + zram-remove-zram-stats-code-duplication.patch added to -mm tree
Date: Tue, 04 Feb 2014 14:19:14 -0800
Message-ID: <52f16762.4CJgDunnC1iMzFgh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935763AbaBDWTP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Feb 2014 17:19:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: + zram-remove-zram-stats-code-duplication.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org
From: akpm@linux-foundation.org
Date: Tue, 04 Feb 2014 14:19:14 -0800


The patch titled
     Subject: zram: remove zram stats code duplication
has been added to the -mm tree.  Its filename is
     zram-remove-zram-stats-code-duplication.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-remove-zram-stats-code-duplication.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-remove-zram-stats-code-duplication.patch

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
@@ -760,15 +723,16 @@ static DEVICE_ATTR(disksize, S_IRUGO | S
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

zram-drop-init_done-struct-zram-member.patch
zram-do-not-pass-rw-argument-to-__zram_make_request.patch
zram-remove-good-and-bad-compress-stats.patch
zram-use-atomic64_t-for-all-zram-stats.patch
zram-remove-zram-stats-code-duplication.patch
zram-report-failed-read-and-write-stats.patch
zram-drop-not-used-table-count-member.patch
zram-move-zram-size-warning-to-documentation.patch

