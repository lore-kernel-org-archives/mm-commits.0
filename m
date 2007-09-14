From: akpm@linux-foundation.org
Subject: + nfs-remove-congestion_end.patch added to -mm tree
Date: Fri, 14 Sep 2007 04:20:41 -0700
Message-ID: <200709141120.l8EBKfAG002257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756433AbXINLVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 07:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     nfs: remove congestion_end()
has been added to the -mm tree.  Its filename is
     nfs-remove-congestion_end.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfs: remove congestion_end()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

These patches aim to improve balance_dirty_pages() and directly address three
issues:
  1) inter device starvation
  2) stacked device deadlocks
  3) inter process starvation

1 and 2 are a direct result from removing the global dirty limit and using
per device dirty limits. By giving each device its own dirty limit is will
no longer starve another device, and the cyclic dependancy on the dirty limit
is broken.

In order to efficiently distribute the dirty limit across the independant
devices a floating proportion is used, this will allocate a share of the total
limit proportional to the device's recent activity.

3 is done by also scaling the dirty limit proportional to the current task's
recent dirty rate.


This patch:


nfs: remove congestion_end().  It's redundant, clear_bdi_congested() already
wakes the waiters.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c              |    4 +---
 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |   13 -------------
 3 files changed, 1 insertion(+), 17 deletions(-)

diff -puN fs/nfs/write.c~nfs-remove-congestion_end fs/nfs/write.c
--- a/fs/nfs/write.c~nfs-remove-congestion_end
+++ a/fs/nfs/write.c
@@ -242,10 +242,8 @@ static void nfs_end_page_writeback(struc
 	struct nfs_server *nfss = NFS_SERVER(inode);
 
 	end_page_writeback(page);
-	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH) {
+	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH)
 		clear_bdi_congested(&nfss->backing_dev_info, WRITE);
-		congestion_end(WRITE);
-	}
 }
 
 /*
diff -puN include/linux/backing-dev.h~nfs-remove-congestion_end include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~nfs-remove-congestion_end
+++ a/include/linux/backing-dev.h
@@ -93,7 +93,6 @@ static inline int bdi_rw_congested(struc
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
-void congestion_end(int rw);
 
 #define bdi_cap_writeback_dirty(bdi) \
 	(!((bdi)->capabilities & BDI_CAP_NO_WRITEBACK))
diff -puN mm/backing-dev.c~nfs-remove-congestion_end mm/backing-dev.c
--- a/mm/backing-dev.c~nfs-remove-congestion_end
+++ a/mm/backing-dev.c
@@ -54,16 +54,3 @@ long congestion_wait(int rw, long timeou
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait);
-
-/**
- * congestion_end - wake up sleepers on a congested backing_dev_info
- * @rw: READ or WRITE
- */
-void congestion_end(int rw)
-{
-	wait_queue_head_t *wqh = &congestion_wqh[rw];
-
-	if (waitqueue_active(wqh))
-		wake_up(wqh);
-}
-EXPORT_SYMBOL(congestion_end);
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
