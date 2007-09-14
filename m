From: akpm@linux-foundation.org
Subject: + mm-expose-bdi-statistics-in-sysfs.patch added to -mm tree
Date: Fri, 14 Sep 2007 04:21:02 -0700
Message-ID: <200709141121.l8EBL2FI002316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41442 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433AbXINLVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:21:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mm: expose BDI statistics in sysfs
has been added to the -mm tree.  Its filename is
     mm-expose-bdi-statistics-in-sysfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: expose BDI statistics in sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Expose the per BDI stats in /sys/block/<dev>/queue/*

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/ll_rw_blk.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff -puN block/ll_rw_blk.c~mm-expose-bdi-statistics-in-sysfs block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~mm-expose-bdi-statistics-in-sysfs
+++ a/block/ll_rw_blk.c
@@ -4098,6 +4098,24 @@ static ssize_t queue_max_segments_show(s
 	return queue_var_show(q->max_phys_segments, page);
 }
 
+static ssize_t queue_nr_reclaimable_show(struct request_queue *q, char *page)
+{
+	unsigned long long nr_reclaimable =
+		bdi_stat(&q->backing_dev_info, BDI_RECLAIMABLE);
+
+	return sprintf(page, "%llu\n",
+			nr_reclaimable >> (PAGE_CACHE_SHIFT - 10));
+}
+
+static ssize_t queue_nr_writeback_show(struct request_queue *q, char *page)
+{
+	unsigned long long nr_writeback =
+		bdi_stat(&q->backing_dev_info, BDI_WRITEBACK);
+
+	return sprintf(page, "%llu\n",
+			nr_writeback >> (PAGE_CACHE_SHIFT - 10));
+}
+
 static ssize_t queue_max_segments_store(struct request_queue *q,
 					const char *page, size_t count)
 {
@@ -4139,6 +4157,16 @@ static struct queue_sysfs_entry queue_ma
 	.store = queue_max_segments_store,
 };
 
+static struct queue_sysfs_entry queue_reclaimable_entry = {
+	.attr = {.name = "reclaimable_kb", .mode = S_IRUGO },
+	.show = queue_nr_reclaimable_show,
+};
+
+static struct queue_sysfs_entry queue_writeback_entry = {
+	.attr = {.name = "writeback_kb", .mode = S_IRUGO },
+	.show = queue_nr_writeback_show,
+};
+
 static struct queue_sysfs_entry queue_iosched_entry = {
 	.attr = {.name = "scheduler", .mode = S_IRUGO | S_IWUSR },
 	.show = elv_iosched_show,
@@ -4151,6 +4179,8 @@ static struct attribute *default_attrs[]
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
 	&queue_max_segments_entry.attr,
+	&queue_reclaimable_entry.attr,
+	&queue_writeback_entry.attr,
 	&queue_iosched_entry.attr,
 	NULL,
 };
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
nfs-remove-congestion_end.patch
lib-percpu_counter_add.patch
lib-percpu_counter_sub.patch
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
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
containers-bdi-init-hooks.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
