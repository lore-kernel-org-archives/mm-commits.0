From: akpm@linux-foundation.org
Subject: + task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch added to -mm tree
Date: Mon, 06 Aug 2007 13:22:07 -0700
Message-ID: <200708062022.l76KM7rw013039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760227AbXHFUWP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 16:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     containers: bdi init hooks
has been added to the -mm tree.  Its filename is
     task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: containers: bdi init hooks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

split off from the large bdi_init patch because containers are not slated for
mainline any time soon.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/container.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff -puN kernel/container.c~task-containersv11-add-procfs-interface-containers-bdi-init-hooks kernel/container.c
--- a/kernel/container.c~task-containersv11-add-procfs-interface-containers-bdi-init-hooks
+++ a/kernel/container.c
@@ -250,12 +250,13 @@ static int container_populate_dir(struct
 static struct inode_operations container_dir_inode_operations;
 static struct file_operations proc_containerstats_operations;
 
+static struct backing_dev_info container_backing_dev_info = {
+	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+};
+
 static struct inode *container_new_inode(mode_t mode, struct super_block *sb)
 {
 	struct inode *inode = new_inode(sb);
-	static struct backing_dev_info container_backing_dev_info = {
-		.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
-	};
 
 	if (inode) {
 		inode->i_mode = mode;
@@ -1580,6 +1581,10 @@ int __init container_init(void)
 	int i;
 	struct proc_dir_entry *entry;
 
+	err = bdi_init(&container_backing_dev_info);
+	if (err)
+		return err;
+
 	for (i = 0; i < CONTAINER_SUBSYS_COUNT; i++) {
 		struct container_subsys *ss = subsys[i];
 		if (!ss->early_init)
@@ -1595,6 +1600,9 @@ int __init container_init(void)
 		entry->proc_fops = &proc_containerstats_operations;
 
 out:
+	if (err)
+		bdi_destroy(&container_backing_dev_info);
+
 	return err;
 }
 
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
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
