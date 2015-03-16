From: akpm@linux-foundation.org
Subject: + zram-move-compact_store-to-sysfs-functions-area.patch added to
 -mm tree
Date: Mon, 16 Mar 2015 16:17:15 -0700
Message-ID: <5507647b.GTgc7aIFLmcQzBUX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37508 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbbCPXRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 19:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, ngupta@vflare.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: move compact_store() to sysfs functions area
has been added to the -mm tree.  Its filename is
     zram-move-compact_store-to-sysfs-functions-area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-move-compact_store-to-sysfs-functions-area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-move-compact_store-to-sysfs-functions-area.patch

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
Subject: zram: move compact_store() to sysfs functions area

A cosmetic change.  We have a new code layout and keep zram per-device
sysfs store and show functions in one place.  Move compact_store() to that
handlers block to conform to current layout.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   42 ++++++++++++++++----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-move-compact_store-to-sysfs-functions-area drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-move-compact_store-to-sysfs-functions-area
+++ a/drivers/block/zram/zram_drv.c
@@ -67,27 +67,6 @@ static inline struct zram *dev_to_zram(s
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
 /* flag operations require table entry bit_spin_lock() being held */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
@@ -384,6 +363,27 @@ static ssize_t comp_algorithm_store(stru
 	return len;
 }
 
+static ssize_t compact_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	unsigned long nr_migrated;
+	struct zram *zram = dev_to_zram(dev);
+	struct zram_meta *meta;
+
+	down_read(&zram->init_lock);
+	if (!init_done(zram)) {
+		up_read(&zram->init_lock);
+		return -EINVAL;
+	}
+
+	meta = zram->meta;
+	nr_migrated = zs_compact(meta->mem_pool);
+	atomic64_add(nr_migrated, &zram->stats.num_migrated);
+	up_read(&zram->init_lock);
+
+	return len;
+}
+
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
 ZRAM_ATTR_RO(failed_reads);
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

