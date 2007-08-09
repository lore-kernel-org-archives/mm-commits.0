From: akpm@linux-foundation.org
Subject: - mm-scalable-bdi-statistics-counters.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:56:42 -0700
Message-ID: <200708092056.l79KugKk019049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58278 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758984AbXHIU5A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:57:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: scalable bdi statistics counters.
has been removed from the -mm tree.  Its filename was
     mm-scalable-bdi-statistics-counters.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: scalable bdi statistics counters.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide scalable per backing_dev_info statistics counters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |   85 ++++++++++++++++++++++++++++++++--
 mm/backing-dev.c            |   27 ++++++++++
 2 files changed, 109 insertions(+), 3 deletions(-)

diff -puN include/linux/backing-dev.h~mm-scalable-bdi-statistics-counters include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-scalable-bdi-statistics-counters
+++ a/include/linux/backing-dev.h
@@ -8,6 +8,8 @@
 #ifndef _LINUX_BACKING_DEV_H
 #define _LINUX_BACKING_DEV_H
 
+#include <linux/percpu_counter.h>
+#include <linux/log2.h>
 #include <asm/atomic.h>
 
 struct page;
@@ -24,6 +26,12 @@ enum bdi_state {
 
 typedef int (congested_fn)(void *, int);
 
+enum bdi_stat_item {
+	NR_BDI_STAT_ITEMS
+};
+
+#define BDI_STAT_BATCH (8*(1+ilog2(nr_cpu_ids)))
+
 struct backing_dev_info {
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned long state;	/* Always use atomic bitops on this */
@@ -32,15 +40,86 @@ struct backing_dev_info {
 	void *congested_data;	/* Pointer to aux data for congested func */
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
+
+	struct percpu_counter bdi_stat[NR_BDI_STAT_ITEMS];
 };
 
-static inline int bdi_init(struct backing_dev_info *bdi)
+int bdi_init(struct backing_dev_info *bdi);
+void bdi_destroy(struct backing_dev_info *bdi);
+
+static inline void __mod_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item, s32 amount)
 {
-	return 0;
+	__percpu_counter_add(&bdi->bdi_stat[item], amount, BDI_STAT_BATCH);
 }
 
-static inline void bdi_destroy(struct backing_dev_info *bdi)
+static inline void __inc_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
 {
+	__mod_bdi_stat(bdi, item, 1);
+}
+
+static inline void inc_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__inc_bdi_stat(bdi, item);
+	local_irq_restore(flags);
+}
+
+static inline void __dec_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	__mod_bdi_stat(bdi, item, -1);
+}
+
+static inline void dec_bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	__dec_bdi_stat(bdi, item);
+	local_irq_restore(flags);
+}
+
+static inline s64 bdi_stat(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	return percpu_counter_read_positive(&bdi->bdi_stat[item]);
+}
+
+static inline s64 __bdi_stat_sum(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	return percpu_counter_sum_positive(&bdi->bdi_stat[item]);
+}
+
+static inline s64 bdi_stat_sum(struct backing_dev_info *bdi,
+		enum bdi_stat_item item)
+{
+	s64 sum;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	sum = __bdi_stat_sum(bdi, item);
+	local_irq_restore(flags);
+
+	return sum;
+}
+
+/*
+ * maximal error of a stat counter.
+ */
+static inline unsigned long bdi_stat_error(struct backing_dev_info *bdi)
+{
+#ifdef CONFIG_SMP
+	return nr_cpu_ids * BDI_STAT_BATCH;
+#else
+	return 1;
+#endif
 }
 
 /*
diff -puN mm/backing-dev.c~mm-scalable-bdi-statistics-counters mm/backing-dev.c
--- a/mm/backing-dev.c~mm-scalable-bdi-statistics-counters
+++ a/mm/backing-dev.c
@@ -5,6 +5,33 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 
+int bdi_init(struct backing_dev_info *bdi)
+{
+	int i, j;
+	int err;
+
+	for (i = 0; i < NR_BDI_STAT_ITEMS; i++) {
+		err = percpu_counter_init_irq(&bdi->bdi_stat[i], 0);
+		if (err) {
+			for (j = 0; j < i; j++)
+				perpcu_counter_destroy(&bdi->bdi_stat[i]);
+			break;
+		}
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(bdi_init);
+
+void bdi_destroy(struct backing_dev_info *bdi)
+{
+	int i;
+
+	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
+		percpu_counter_destroy(&bdi->bdi_stat[i]);
+}
+EXPORT_SYMBOL(bdi_destroy);
+
 static wait_queue_head_t congestion_wqh[2] = {
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[0]),
 		__WAIT_QUEUE_HEAD_INITIALIZER(congestion_wqh[1])
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
lib-floating-proportions.patch
lib-floating-proportions-_single.patch
lib-floating-proportions-_single-tidy.patch
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
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
