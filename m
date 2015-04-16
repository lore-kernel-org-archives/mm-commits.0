From: akpm@linux-foundation.org
Subject: [merged] zram-move-compact_store-to-sysfs-functions-area.patch
 removed from -mm tree
Date: Thu, 16 Apr 2015 09:53:46 -0700
Message-ID: <552fe91a.RcKHYcCJNzJZAQ7O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42983 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbbDPQsR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 12:48:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: move compact_store() to sysfs functions area
has been removed from the -mm tree.  Its filename was
     zram-move-compact_store-to-sysfs-functions-area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: move compact_store() to sysfs functions area

A cosmetic change.  We have a new code layout and keep zram per-device
sysfs store and show functions in one place.  Move compact_store() to that
handlers block to conform to current layout.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   23 -----------------------
 1 file changed, 23 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-move-compact_store-to-sysfs-functions-area drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-move-compact_store-to-sysfs-functions-area
+++ a/drivers/block/zram/zram_drv.c
@@ -63,27 +63,6 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-static ssize_t compact_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t len)
-{
-	unsigned long nr_migrated;
-	struct zram *zram = dev_to_zram(dev);
-	struct zram_meta *meta;
-
-	down_read(&zram->init_lock);
-	if (!init_done(zram)) {
-		up_read(&zram->init_lock);
-		return -EINVAL;
-	}
-
-	meta = zram->meta;
-	nr_migrated = zs_compact(meta->mem_pool);
-	atomic64_add(nr_migrated, &zram->stats.num_migrated);
-	up_read(&zram->init_lock);
-
-	return len;
-}
-
 static ssize_t disksize_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1038,7 +1017,6 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
-static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
 static DEVICE_ATTR_WO(reset);
@@ -1066,7 +1044,6 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
 	&dev_attr_failed_writes.attr,
-	&dev_attr_compact.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
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

