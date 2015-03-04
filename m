From: akpm@linux-foundation.org
Subject: + zram-support-compaction.patch added to -mm tree
Date: Wed, 04 Mar 2015 14:02:36 -0800
Message-ID: <54f780fc.3sOWZKr7rufmI85r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbCDWCh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2015 17:02:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, ddstreet@ieee.org, gunho.lee@lge.com, iamjoonsoo.kim@lge.com, jmarchan@redhat.com, juno.choi@lge.com, mel@csn.ul.ie, ngupta@vflare.org, semenzato@google.com, sergey.senozhatsky@gmail.com, sjennings@variantweb.net, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: support compaction
has been added to the -mm tree.  Its filename is
     zram-support-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-support-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-support-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: support compaction

Now that zsmalloc supports compaction, zram can use it.  For the first
step, this patch exports compact knob via sysfs so user can do compaction
via "echo 1 > /sys/block/zram0/compact".

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Gunho Lee <gunho.lee@lge.com>
Cc: Luigi Semenzato <semenzato@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram |   15 +++++++++++
 drivers/block/zram/zram_drv.c              |   25 +++++++++++++++++++
 drivers/block/zram/zram_drv.h              |    1 
 3 files changed, 41 insertions(+)

diff -puN Documentation/ABI/testing/sysfs-block-zram~zram-support-compaction Documentation/ABI/testing/sysfs-block-zram
--- a/Documentation/ABI/testing/sysfs-block-zram~zram-support-compaction
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -141,3 +141,18 @@ Description:
 		amount of memory ZRAM can use to store the compressed data.  The
 		limit could be changed in run time and "0" means disable the
 		limit.  No limit is the initial state.  Unit: bytes
+
+What:		/sys/block/zram<id>/compact
+Date:		August 2015
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		The compact file is write-only and trigger compaction for
+		allocator zrm uses. The allocator moves some objects so that
+		it could free fragment space.
+
+What:		/sys/block/zram<id>/num_migrated
+Date:		August 2015
+Contact:	Minchan Kim <minchan@kernel.org>
+Description:
+		The compact file is read-only and shows how many object
+		migrated by compaction.
diff -puN drivers/block/zram/zram_drv.c~zram-support-compaction drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-support-compaction
+++ a/drivers/block/zram/zram_drv.c
@@ -70,6 +70,27 @@ static inline struct zram *dev_to_zram(s
 	return (struct zram *)dev_to_disk(dev)->private_data;
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
 /* flag operations require table entry bit_spin_lock() being held */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
@@ -374,6 +395,7 @@ ZRAM_ATTR_RO(invalid_io);
 ZRAM_ATTR_RO(notify_free);
 ZRAM_ATTR_RO(zero_pages);
 ZRAM_ATTR_RO(compr_data_size);
+ZRAM_ATTR_RO(num_migrated);
 
 static inline bool zram_meta_get(struct zram *zram)
 {
@@ -1031,6 +1053,7 @@ static const struct block_device_operati
 	.owner = THIS_MODULE
 };
 
+static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
 static DEVICE_ATTR_RO(initstate);
 static DEVICE_ATTR_WO(reset);
@@ -1049,6 +1072,8 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
 	&dev_attr_failed_writes.attr,
+	&dev_attr_num_migrated.attr,
+	&dev_attr_compact.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
 	&dev_attr_zero_pages.attr,
diff -puN drivers/block/zram/zram_drv.h~zram-support-compaction drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-support-compaction
+++ a/drivers/block/zram/zram_drv.h
@@ -78,6 +78,7 @@ struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
 	atomic64_t num_writes;	/* --do-- */
+	atomic64_t num_migrated;	/* no. of migrated object */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-page_isolation-check-pfn-validity-before-access.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
x86-add-pmd_-for-thp.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp-fix.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
zram-cosmetic-zram_attr_ro-code-formatting-tweak.patch
zram-use-idr-instead-of-zram_devices-array.patch
zram-factor-out-device-reset-from-reset_store.patch
zram-reorganize-code-layout.patch
zram-add-dynamic-device-add-remove-functionality.patch
zram-remove-max_num_devices-limitation.patch
zram-report-every-added-and-removed-device.patch
zram-trivial-correct-flag-operations-comment.patch
zsmalloc-decouple-handle-and-object.patch
zsmalloc-factor-out-obj_.patch
zsmalloc-support-compaction.patch
zsmalloc-adjust-zs_almost_full.patch
zram-support-compaction.patch
zsmalloc-record-handle-in-page-private-for-huge-object.patch
zsmalloc-add-fullness-into-stat.patch

