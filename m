From: akpm@linux-foundation.org
Subject: - mtd-bdi-init-hooks.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:56:35 -0700
Message-ID: <200708092056.l79KuZdT019040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57439 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764202AbXHIU4n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:56:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mtd: bdi init hooks
has been removed from the -mm tree.  Its filename was
     mtd-bdi-init-hooks.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mtd: bdi init hooks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

split off because the relevant mtd changes seem particular to -mm

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/mtd/mtdcore.c~mtd-bdi-init-hooks drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mtd-bdi-init-hooks
+++ a/drivers/mtd/mtdcore.c
@@ -48,6 +48,7 @@ static LIST_HEAD(mtd_notifiers);
 int add_mtd_device(struct mtd_info *mtd)
 {
 	int i;
+	int err;
 
 	if (!mtd->backing_dev_info) {
 		switch (mtd->type) {
@@ -62,6 +63,9 @@ int add_mtd_device(struct mtd_info *mtd)
 			break;
 		}
 	}
+	err = bdi_init(mtd->backing_dev_info);
+	if (err)
+		return 1;
 
 	BUG_ON(mtd->writesize == 0);
 	mutex_lock(&mtd_table_mutex);
@@ -102,6 +106,7 @@ int add_mtd_device(struct mtd_info *mtd)
 		}
 
 	mutex_unlock(&mtd_table_mutex);
+	bdi_destroy(mtd->backing_dev_info);
 	return 1;
 }
 
@@ -144,6 +149,10 @@ int del_mtd_device (struct mtd_info *mtd
 	}
 
 	mutex_unlock(&mtd_table_mutex);
+
+	if (mtd->backing_dev_info)
+		bdi_destroy(mtd->backing_dev_info);
+
 	return ret;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
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
