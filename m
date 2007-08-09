From: akpm@linux-foundation.org
Subject: - lib-percpu_counter_init_irq.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:56:31 -0700
Message-ID: <200708092056.l79KuVtX019031@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763669AbXHIU4l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:56:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     lib: percpu_counter_init_irq
has been removed from the -mm tree.  Its filename was
     lib-percpu_counter_init_irq.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: lib: percpu_counter_init_irq
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

provide a way to init percpu_counters that are supposed to be used from irq
safe contexts.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    3 +++
 lib/percpu_counter.c           |   12 ++++++++++++
 2 files changed, 15 insertions(+)

diff -puN include/linux/percpu_counter.h~lib-percpu_counter_init_irq include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter_init_irq
+++ a/include/linux/percpu_counter.h
@@ -31,6 +31,7 @@ struct percpu_counter {
 #endif
 
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
+int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
@@ -84,6 +85,8 @@ static inline int percpu_counter_init(st
 	return 0;
 }
 
+#define percpu_counter_init_irq percpu_counter_init
+
 static inline void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 }
diff -puN lib/percpu_counter.c~lib-percpu_counter_init_irq lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counter_init_irq
+++ a/lib/percpu_counter.c
@@ -68,6 +68,8 @@ s64 __percpu_counter_sum(struct percpu_c
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
+static struct lock_class_key percpu_counter_irqsafe;
+
 int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	spin_lock_init(&fbc->lock);
@@ -84,6 +86,16 @@ int percpu_counter_init(struct percpu_co
 }
 EXPORT_SYMBOL(percpu_counter_init);
 
+int percpu_counter_init_irq(struct percpu_counter *fbc, s64 amount)
+{
+	int err;
+
+	err = percpu_counter_init(fbc, amount);
+	if (!err)
+		lockdep_set_class(&fbc->lock, &percpu_counter_irqsafe);
+	return err;
+}
+
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
 	if (!fbc->counters)
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
lib-percpu_counter_init_irq.patch
mm-bdi-init-hooks.patch
mm-bdi-init-hooks-fix.patch
mtd-bdi-init-hooks.patch
mtd-clean-up-the-backing_dev_info-usage.patch
mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch
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
