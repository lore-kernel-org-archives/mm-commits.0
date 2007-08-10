From: akpm@linux-foundation.org
Subject: - task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch removed from -mm tree
Date: Thu, 09 Aug 2007 17:24:58 -0700
Message-ID: <200708100029.l7A0TrrA027080@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752845AbXHJAaF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 20:30:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     containers: bdi init hooks
has been removed from the -mm tree.  Its filename was
     task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch

This patch was dropped because an updated version will be merged

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
