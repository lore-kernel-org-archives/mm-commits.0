From: akpm@linux-foundation.org
Subject: + mtd-clean-up-the-backing_dev_info-usage.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:19:06 -0700
Message-ID: <200708062019.l76KJ6F9012935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38748 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760689AbXHFUTQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:19:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mtd: clean up the backing_dev_info usage
has been added to the -mm tree.  Its filename is
     mtd-clean-up-the-backing_dev_info-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mtd: clean up the backing_dev_info usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Give each mtd device its own backing_dev_info instance.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdcore.c   |    8 +++++---
 include/linux/mtd/mtd.h |    2 ++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/mtdcore.c~mtd-clean-up-the-backing_dev_info-usage drivers/mtd/mtdcore.c
--- a/drivers/mtd/mtdcore.c~mtd-clean-up-the-backing_dev_info-usage
+++ a/drivers/mtd/mtdcore.c
@@ -19,6 +19,7 @@
 #include <linux/init.h>
 #include <linux/mtd/compatmac.h>
 #include <linux/proc_fs.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/mtd.h>
 #include "internal.h"
@@ -53,15 +54,16 @@ int add_mtd_device(struct mtd_info *mtd)
 	if (!mtd->backing_dev_info) {
 		switch (mtd->type) {
 		case MTD_RAM:
-			mtd->backing_dev_info = &mtd_bdi_rw_mappable;
+			mtd->mtd_backing_dev_info = mtd_bdi_rw_mappable;
 			break;
 		case MTD_ROM:
-			mtd->backing_dev_info = &mtd_bdi_ro_mappable;
+			mtd->mtd_backing_dev_info = mtd_bdi_ro_mappable;
 			break;
 		default:
-			mtd->backing_dev_info = &mtd_bdi_unmappable;
+			mtd->mtd_backing_dev_info = mtd_bdi_unmappable;
 			break;
 		}
+		mtd->backing_dev_info = &mtd->mtd_backing_dev_info;
 	}
 	err = bdi_init(mtd->backing_dev_info);
 	if (err)
diff -puN include/linux/mtd/mtd.h~mtd-clean-up-the-backing_dev_info-usage include/linux/mtd/mtd.h
--- a/include/linux/mtd/mtd.h~mtd-clean-up-the-backing_dev_info-usage
+++ a/include/linux/mtd/mtd.h
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/uio.h>
 #include <linux/notifier.h>
+#include <linux/backing-dev.h>
 
 #include <linux/mtd/compatmac.h>
 #include <mtd/mtd-abi.h>
@@ -154,6 +155,7 @@ struct mtd_info {
 	 * - provides mmap capabilities
 	 */
 	struct backing_dev_info *backing_dev_info;
+	struct backing_dev_info mtd_backing_dev_info;
 
 
 	int (*read) (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf);
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
