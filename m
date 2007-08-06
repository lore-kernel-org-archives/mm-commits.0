From: akpm@linux-foundation.org
Subject: + lib-make-percpu_counter_add-take-s64.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:18:56 -0700
Message-ID: <200708062018.l76KIuIB012903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760880AbXHFUTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:19:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     lib: make percpu_counter_add take s64
has been added to the -mm tree.  Its filename is
     lib-make-percpu_counter_add-take-s64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib: make percpu_counter_add take s64
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

percpu_counter is a s64 counter, make _add consitent.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/percpu_counter.h |    6 +++---
 lib/percpu_counter.c           |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN include/linux/percpu_counter.h~lib-make-percpu_counter_add-take-s64 include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-make-percpu_counter_add-take-s64
+++ a/include/linux/percpu_counter.h
@@ -32,10 +32,10 @@ struct percpu_counter {
 
 void percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
-void __percpu_counter_add(struct percpu_counter *fbc, s32 amount, s32 batch);
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
 s64 percpu_counter_sum(struct percpu_counter *fbc);
 
-static inline void percpu_counter_add(struct percpu_counter *fbc, s32 amount)
+static inline void percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
 	__percpu_counter_add(fbc, amount, FBC_BATCH);
 }
@@ -79,7 +79,7 @@ static inline void percpu_counter_destro
 	percpu_counter_add(fbc, amount)
 
 static inline void
-percpu_counter_add(struct percpu_counter *fbc, s32 amount)
+percpu_counter_add(struct percpu_counter *fbc, s64 amount)
 {
 	preempt_disable();
 	fbc->count += amount;
diff -puN lib/percpu_counter.c~lib-make-percpu_counter_add-take-s64 lib/percpu_counter.c
--- a/lib/percpu_counter.c~lib-make-percpu_counter_add-take-s64
+++ a/lib/percpu_counter.c
@@ -14,9 +14,9 @@ static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
-void __percpu_counter_add(struct percpu_counter *fbc, s32 amount, s32 batch)
+void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
-	long count;
+	s64 count;
 	s32 *pcount;
 	int cpu = get_cpu();
 
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
