From: akpm@linux-foundation.org
Subject: + lib-percpu_counter_set.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:18:58 -0700
Message-ID: <200708062018.l76KIwCh012906@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761563AbXHFUTH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:19:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lib: percpu_counter_set
has been added to the -mm tree.  Its filename is
     lib-percpu_counter_set.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib: percpu_counter_set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Provide a method to set a percpu counter to a specified value.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    6 ++++++
 lib/percpu_counter.c           |   14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff -puN include/linux/percpu_counter.h~lib-percpu_counter_set include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter_set
+++ a/include/linux/percpu_counter.h
@@ -32,6 +32,7 @@ struct percpu_counter {
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
+void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
@@ -75,6 +76,11 @@ static inline void percpu_counter_destro
 {
 }
 
+static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
+{
+	fbc->count = amount;
+}
+
 #define __percpu_counter_add(fbc, amount, batch) \
 	percpu_counter_add(fbc, amount)
 
diff -puN lib/percpu_counter.c~lib-percpu_counter_set lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-percpu_counter_set
+++ a/lib/percpu_counter.c
@@ -14,6 +14,20 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
+void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
+{
+	int cpu;
+
+	spin_lock(&fbc->lock);
+	for_each_possible_cpu(cpu) {
+		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+		*pcount = 0;
+	}
+	fbc->count = amount;
+	spin_unlock(&fbc->lock);
+}
+EXPORT_SYMBOL(percpu_counter_set);
+
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
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
