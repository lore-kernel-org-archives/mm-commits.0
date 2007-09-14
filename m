From: akpm@linux-foundation.org
Subject: + lib-percpu_counter_sub.patch added to -mm tree
Date: Fri, 14 Sep 2007 04:20:44 -0700
Message-ID: <200709141120.l8EBKiqI002263@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756742AbXINLU4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:20:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, hugh@veritas.com


The patch titled
     lib: percpu_counter_sub
has been added to the -mm tree.  Its filename is
     lib-percpu_counter_sub.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lib: percpu_counter_sub
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Hugh spotted that some code does:
  percpu_counter_add(&counter, -unsignedlong)

which, when the amount argument is of type s32, sort-of works thanks to
two's-complement. However when we'd change the type to s64 this breaks on 32bit
machines, because the promotion rules zero extend the unsigned number.

Provide percpu_counter_sub() to hide the s64 cast. That is:
  percpu_counter_sub(&counter, foo)
is equal to:
  percpu_counter_add(&counter, -(s64)foo);

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c               |    2 +-
 fs/ext3/balloc.c               |    2 +-
 fs/ext4/balloc.c               |    2 +-
 include/linux/percpu_counter.h |    5 +++++
 4 files changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/ext2/balloc.c~lib-percpu_counter_sub fs/ext2/balloc.c
--- a/fs/ext2/balloc.c~lib-percpu_counter_sub
+++ a/fs/ext2/balloc.c
@@ -124,7 +124,7 @@ static int reserve_blocks(struct super_b
 			return 0;
 	}
 
-	percpu_counter_add(&sbi->s_freeblocks_counter, -count);
+	percpu_counter_sub(&sbi->s_freeblocks_counter, count);
 	sb->s_dirt = 1;
 	return count;
 }
diff -puN fs/ext3/balloc.c~lib-percpu_counter_sub fs/ext3/balloc.c
--- a/fs/ext3/balloc.c~lib-percpu_counter_sub
+++ a/fs/ext3/balloc.c
@@ -1633,7 +1633,7 @@ allocated:
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_add(&sbi->s_freeblocks_counter, -num);
+	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext3_journal_dirty_metadata(handle, gdp_bh);
diff -puN fs/ext4/balloc.c~lib-percpu_counter_sub fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~lib-percpu_counter_sub
+++ a/fs/ext4/balloc.c
@@ -1647,7 +1647,7 @@ allocated:
 	gdp->bg_free_blocks_count =
 			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count)-num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_add(&sbi->s_freeblocks_counter, -num);
+	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext4_journal_dirty_metadata(handle, gdp_bh);
diff -puN include/linux/percpu_counter.h~lib-percpu_counter_sub include/linux/percpu_counter.h
--- a/include/linux/percpu_counter.h~lib-percpu_counter_sub
+++ a/include/linux/percpu_counter.h
@@ -105,4 +105,9 @@ static inline void percpu_counter_dec(st
 	percpu_counter_add(fbc, -1);
 }
 
+static inline void percpu_counter_sub(struct percpu_counter *fbc, s64 amount)
+{
+	percpu_counter_add(fbc, -amount);
+}
+
 #endif /* _LINUX_PERCPU_COUNTER_H */
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
