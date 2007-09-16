From: akpm@linux-foundation.org
Subject: - mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch removed from -mm tree
Date: Sun, 16 Sep 2007 13:04:31 -0700
Message-ID: <200709162010.l8GKACCp030762@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59563 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570AbXIPUK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 16:10:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, dwmw2@infradead.org, rkaiser@sysgo.de, mm-commits@vger.kernel.org


The patch titled
     mtd: give mtdconcat devices their own backing_dev_info
has been removed from the -mm tree.  Its filename was
     mtd-give-mtdconcat-devices-their-own-backing_dev_info.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: mtd: give mtdconcat devices their own backing_dev_info
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

These are actual devices, give them their own BDI.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Robert Kaiser <rkaiser@sysgo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdconcat.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff -puN drivers/mtd/mtdconcat.c~mtd-give-mtdconcat-devices-their-own-backing_dev_info drivers/mtd/mtdconcat.c
--- a/drivers/mtd/mtdconcat.c~mtd-give-mtdconcat-devices-their-own-backing_dev_info
+++ a/drivers/mtd/mtdconcat.c
@@ -31,6 +31,7 @@ struct mtd_concat {
 	struct mtd_info mtd;
 	int num_subdev;
 	struct mtd_info **subdev;
+	struct backing_dev_info backing_dev_info;
 };
 
 /*
@@ -745,10 +746,9 @@ struct mtd_info *mtd_concat_create(struc
 
 	for (i = 1; i < num_devs; i++) {
 		if (concat->mtd.type != subdev[i]->type) {
-			kfree(concat);
 			printk("Incompatible device type on \"%s\"\n",
 			       subdev[i]->name);
-			return NULL;
+			goto error;
 		}
 		if (concat->mtd.flags != subdev[i]->flags) {
 			/*
@@ -757,10 +757,9 @@ struct mtd_info *mtd_concat_create(struc
 			 */
 			if ((concat->mtd.flags ^ subdev[i]->
 			     flags) & ~MTD_WRITEABLE) {
-				kfree(concat);
 				printk("Incompatible device flags on \"%s\"\n",
 				       subdev[i]->name);
-				return NULL;
+				goto error;
 			} else
 				/* if writeable attribute differs,
 				   make super device writeable */
@@ -775,10 +774,9 @@ struct mtd_info *mtd_concat_create(struc
 		    concat->mtd.oobsize    !=  subdev[i]->oobsize ||
 		    !concat->mtd.read_oob  != !subdev[i]->read_oob ||
 		    !concat->mtd.write_oob != !subdev[i]->write_oob) {
-			kfree(concat);
 			printk("Incompatible OOB or ECC data on \"%s\"\n",
 			       subdev[i]->name);
-			return NULL;
+			goto error;
 		}
 		concat->subdev[i] = subdev[i];
 
@@ -856,11 +854,10 @@ struct mtd_info *mtd_concat_create(struc
 		    kmalloc(num_erase_region *
 			    sizeof (struct mtd_erase_region_info), GFP_KERNEL);
 		if (!erase_region_p) {
-			kfree(concat);
 			printk
 			    ("memory allocation error while creating erase region list"
 			     " for device \"%s\"\n", name);
-			return NULL;
+			goto error;
 		}
 
 		/*
@@ -921,6 +918,12 @@ struct mtd_info *mtd_concat_create(struc
 	}
 
 	return &concat->mtd;
+
+error:
+	if (concat->mtd.backing_dev_info == &concat->backing_dev_info)
+		bdi_destroy(&concat->backing_dev_info);
+	kfree(concat);
+	return NULL;
 }
 
 /*
@@ -930,6 +933,8 @@ struct mtd_info *mtd_concat_create(struc
 void mtd_concat_destroy(struct mtd_info *mtd)
 {
 	struct mtd_concat *concat = CONCAT(mtd);
+	if (concat->mtd.backing_dev_info == &concat->backing_dev_info)
+		bdi_destroy(&concat->backing_dev_info);
 	if (concat->mtd.numeraseregions)
 		kfree(concat->mtd.eraseregions);
 	kfree(concat);
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
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
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
