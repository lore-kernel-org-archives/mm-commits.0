From: akpm@linux-foundation.org
Subject: - mm-count-reclaimable-pages-per-bdi.patch removed from -mm tree
Date: Thu, 09 Aug 2007 13:56:43 -0700
Message-ID: <200708092056.l79Kuh03019052@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57490 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759153AbXHIU44 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 16:56:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org


The patch titled
     mm: count reclaimable pages per BDI
has been removed from the -mm tree.  Its filename was
     mm-count-reclaimable-pages-per-bdi.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: mm: count reclaimable pages per BDI
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Count per BDI reclaimable pages; nr_reclaimable = nr_dirty + nr_unstable.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |    2 ++
 fs/nfs/write.c              |    7 +++++++
 include/linux/backing-dev.h |    1 +
 mm/page-writeback.c         |    4 ++++
 mm/truncate.c               |    2 ++
 5 files changed, 16 insertions(+)

diff -puN fs/buffer.c~mm-count-reclaimable-pages-per-bdi fs/buffer.c
--- a/fs/buffer.c~mm-count-reclaimable-pages-per-bdi
+++ a/fs/buffer.c
@@ -697,6 +697,8 @@ static int __set_page_dirty(struct page 
 
 		if (mapping_cap_account_dirty(mapping)) {
 			__inc_zone_page_state(page, NR_FILE_DIRTY);
+			__inc_bdi_stat(mapping->backing_dev_info,
+					BDI_RECLAIMABLE);
 			task_io_account_write(PAGE_CACHE_SIZE);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
diff -puN fs/nfs/write.c~mm-count-reclaimable-pages-per-bdi fs/nfs/write.c
--- a/fs/nfs/write.c~mm-count-reclaimable-pages-per-bdi
+++ a/fs/nfs/write.c
@@ -464,6 +464,7 @@ nfs_mark_request_commit(struct nfs_page 
 			NFS_PAGE_TAG_COMMIT);
 	spin_unlock(&inode->i_lock);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 }
 
@@ -550,6 +551,8 @@ static void nfs_cancel_commit_list(struc
 	while(!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
+				BDI_RECLAIMABLE);
 		nfs_list_remove_request(req);
 		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 		nfs_inode_remove_request(req);
@@ -1210,6 +1213,8 @@ nfs_commit_list(struct inode *inode, str
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
+				BDI_RECLAIMABLE);
 		nfs_clear_page_tag_locked(req);
 	}
 	return -ENOMEM;
@@ -1235,6 +1240,8 @@ static void nfs_commit_done(struct rpc_t
 		nfs_list_remove_request(req);
 		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
+				BDI_RECLAIMABLE);
 
 		dprintk("NFS: commit (%s/%Ld %d@%Ld)",
 			req->wb_context->path.dentry->d_inode->i_sb->s_id,
diff -puN include/linux/backing-dev.h~mm-count-reclaimable-pages-per-bdi include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-count-reclaimable-pages-per-bdi
+++ a/include/linux/backing-dev.h
@@ -27,6 +27,7 @@ enum bdi_state {
 typedef int (congested_fn)(void *, int);
 
 enum bdi_stat_item {
+	BDI_RECLAIMABLE,
 	NR_BDI_STAT_ITEMS
 };
 
diff -puN mm/page-writeback.c~mm-count-reclaimable-pages-per-bdi mm/page-writeback.c
--- a/mm/page-writeback.c~mm-count-reclaimable-pages-per-bdi
+++ a/mm/page-writeback.c
@@ -827,6 +827,8 @@ int __set_page_dirty_nobuffers(struct pa
 			WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
 			if (mapping_cap_account_dirty(mapping)) {
 				__inc_zone_page_state(page, NR_FILE_DIRTY);
+				__inc_bdi_stat(mapping->backing_dev_info,
+						BDI_RECLAIMABLE);
 				task_io_account_write(PAGE_CACHE_SIZE);
 			}
 			radix_tree_tag_set(&mapping->page_tree,
@@ -961,6 +963,8 @@ int clear_page_dirty_for_io(struct page 
 		 */
 		if (TestClearPageDirty(page)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
+			dec_bdi_stat(mapping->backing_dev_info,
+					BDI_RECLAIMABLE);
 			return 1;
 		}
 		return 0;
diff -puN mm/truncate.c~mm-count-reclaimable-pages-per-bdi mm/truncate.c
--- a/mm/truncate.c~mm-count-reclaimable-pages-per-bdi
+++ a/mm/truncate.c
@@ -72,6 +72,8 @@ void cancel_dirty_page(struct page *page
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
 			dec_zone_page_state(page, NR_FILE_DIRTY);
+			dec_bdi_stat(mapping->backing_dev_info,
+					BDI_RECLAIMABLE);
 			if (account_size)
 				task_io_account_cancelled_write(account_size);
 		}
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

radix-tree-use-indirect-bit.patch
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
