From: akpm@linux-foundation.org
Subject: + debug-sysfs-files-for-the-current-ratio-size-total.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:19:20 -0700
Message-ID: <200708062019.l76KJKG2012970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41084 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758100AbXHFUZg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:25:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     debug: sysfs files for the current ratio/size/total
has been added to the -mm tree.  Its filename is
     debug-sysfs-files-for-the-current-ratio-size-total.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: debug: sysfs files for the current ratio/size/total
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Expose the per bdi dirty limits in sysfs

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c   |   80 ++++++++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c |    4 +-
 2 files changed, 82 insertions(+), 2 deletions(-)

diff -puN block/ll_rw_blk.c~debug-sysfs-files-for-the-current-ratio-size-total block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~debug-sysfs-files-for-the-current-ratio-size-total
+++ a/block/ll_rw_blk.c
@@ -4000,6 +4000,56 @@ static ssize_t queue_nr_writeback_show(s
 			nr_writeback >> (PAGE_CACHE_SHIFT - 10));
 }
 
+extern void bdi_writeout_fraction(struct backing_dev_info *bdi,
+		long *numerator, long *denominator);
+
+static ssize_t queue_nr_cache_ratio_show(struct request_queue *q, char *page)
+{
+	long scale, div;
+
+	bdi_writeout_fraction(&q->backing_dev_info, &scale, &div);
+	scale *= 1024;
+	scale /= div;
+
+	return sprintf(page, "%ld\n", scale);
+}
+
+static ssize_t queue_nr_cache_num_show(struct request_queue *q, char *page)
+{
+	long scale, div;
+
+	bdi_writeout_fraction(&q->backing_dev_info, &scale, &div);
+
+	return sprintf(page, "%ld\n", scale);
+}
+
+static ssize_t queue_nr_cache_denom_show(struct request_queue *q, char *page)
+{
+	long scale, div;
+
+	bdi_writeout_fraction(&q->backing_dev_info, &scale, &div);
+
+	return sprintf(page, "%ld\n", div);
+}
+
+extern void
+get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
+		struct backing_dev_info *bdi);
+
+static ssize_t queue_nr_cache_size_show(struct request_queue *q, char *page)
+{
+	long background, dirty, bdi_dirty;
+	get_dirty_limits(&background, &dirty, &bdi_dirty, &q->backing_dev_info);
+	return sprintf(page, "%ld\n", bdi_dirty);
+}
+
+static ssize_t queue_nr_cache_total_show(struct request_queue *q, char *page)
+{
+	long background, dirty, bdi_dirty;
+	get_dirty_limits(&background, &dirty, &bdi_dirty, &q->backing_dev_info);
+	return sprintf(page, "%ld\n", dirty);
+}
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -4033,6 +4083,31 @@ static struct queue_sysfs_entry queue_wr
 	.show = queue_nr_writeback_show,
 };
 
+static struct queue_sysfs_entry queue_cache_ratio_entry = {
+	.attr = {.name = "cache_ratio", .mode = S_IRUGO },
+	.show = queue_nr_cache_ratio_show,
+};
+
+static struct queue_sysfs_entry queue_cache_num_entry = {
+	.attr = {.name = "cache_num", .mode = S_IRUGO },
+	.show = queue_nr_cache_num_show,
+};
+
+static struct queue_sysfs_entry queue_cache_denom_entry = {
+	.attr = {.name = "cache_denom", .mode = S_IRUGO },
+	.show = queue_nr_cache_denom_show,
+};
+
+static struct queue_sysfs_entry queue_cache_size_entry = {
+	.attr = {.name = "cache_size", .mode = S_IRUGO },
+	.show = queue_nr_cache_size_show,
+};
+
+static struct queue_sysfs_entry queue_cache_total_entry = {
+	.attr = {.name = "cache_total", .mode = S_IRUGO },
+	.show = queue_nr_cache_total_show,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -4046,6 +4121,11 @@ static struct attribute *default_attrs[]
 	&queue_max_sectors_entry.attr,
 	&queue_reclaimable_entry.attr,
 	&queue_writeback_entry.attr,
+	&queue_cache_ratio_entry.attr,
+	&queue_cache_num_entry.attr,
+	&queue_cache_denom_entry.attr,
+	&queue_cache_size_entry.attr,
+	&queue_cache_total_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
diff -puN mm/page-writeback.c~debug-sysfs-files-for-the-current-ratio-size-total mm/page-writeback.c
--- a/mm/page-writeback.c~debug-sysfs-files-for-the-current-ratio-size-total
+++ a/mm/page-writeback.c
@@ -176,7 +176,7 @@ static void task_dirty_inc(struct task_s
 /*
  * Obtain an accurate fraction of the BDI's portion.
  */
-static void bdi_writeout_fraction(struct backing_dev_info *bdi,
+void bdi_writeout_fraction(struct backing_dev_info *bdi,
 		long *numerator, long *denominator)
 {
 	if (bdi_cap_writeback_dirty(bdi)) {
@@ -300,7 +300,7 @@ static unsigned long determine_dirtyable
 	return x + 1;	/* Ensure that we never return 0 */
 }
 
-static void
+void
 get_dirty_limits(long *pbackground, long *pdirty, long *pbdi_dirty,
 		 struct backing_dev_info *bdi)
 {
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
nfs-remove-congestion_end.patch
lib-percpu_counter_add.patch
lib-percpu_counter-variable-batch.patch
lib-make-percpu_counter_add-take-s64.patch
lib-percpu_counter_set.patch
lib-percpu_counter_sum_positive.patch
lib-percpu_count_sum.patch
lib-percpu_counter_init-error-handling.patch
lib-percpu_counter_init_irq.patch
mm-bdi-init-hooks.patch
mtd-bdi-init-hooks.patch
mtd-clean-up-the-backing_dev_info-usage.patch
mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
lib-floating-proportions.patch
lib-floating-proportions-_single.patch
mm-per-device-dirty-threshold.patch
mm-dirty-balancing-for-tasks.patch
debug-sysfs-files-for-the-current-ratio-size-total.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
containers-bdi-init-hooks.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
