From: akpm@linux-foundation.org
Subject: + mm-count-reclaimable-pages-per-bdi.patch added to -mm tree
Date: Sat, 21 Apr 2007 02:55:10 -0700
Message-ID: <200704210955.l3L9tAQR003694@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933083AbXDUJzO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 05:55:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mm: count reclaimable pages per BDI
has been added to the -mm tree.  Its filename is
     mm-count-reclaimable-pages-per-bdi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -726,6 +726,8 @@ int __set_page_dirty_buffers(struct page
 	if (page->mapping) {	/* Race with truncate? */
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
@@ -454,6 +454,7 @@ nfs_mark_request_commit(struct nfs_page 
 	set_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 	spin_unlock(&nfsi->req_lock);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 }
 
@@ -552,6 +553,8 @@ static void nfs_cancel_commit_list(struc
 	while(!list_empty(head)) {
 		req = nfs_list_entry(head->next);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
+				BDI_RECLAIMABLE);
 		nfs_list_remove_request(req);
 		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 		nfs_inode_remove_request(req);
@@ -1269,6 +1272,8 @@ nfs_commit_list(struct inode *inode, str
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
+				BDI_RECLAIMABLE);
 		nfs_clear_page_writeback(req);
 	}
 	return -ENOMEM;
@@ -1294,6 +1299,8 @@ static void nfs_commit_done(struct rpc_t
 		nfs_list_remove_request(req);
 		clear_bit(PG_NEED_COMMIT, &(req)->wb_flags);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
+		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
+				BDI_RECLAIMABLE);
 
 		dprintk("NFS: commit (%s/%Ld %d@%Ld)",
 			req->wb_context->dentry->d_inode->i_sb->s_id,
diff -puN include/linux/backing-dev.h~mm-count-reclaimable-pages-per-bdi include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-count-reclaimable-pages-per-bdi
+++ a/include/linux/backing-dev.h
@@ -26,6 +26,7 @@ enum bdi_state {
 typedef int (congested_fn)(void *, int);
 
 enum bdi_stat_item {
+	BDI_RECLAIMABLE,
 	NR_BDI_STAT_ITEMS
 };
 
diff -puN mm/page-writeback.c~mm-count-reclaimable-pages-per-bdi mm/page-writeback.c
--- a/mm/page-writeback.c~mm-count-reclaimable-pages-per-bdi
+++ a/mm/page-writeback.c
@@ -828,6 +828,8 @@ int __set_page_dirty_nobuffers(struct pa
 			BUG_ON(mapping2 != mapping);
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
@@ -71,6 +71,8 @@ void cancel_dirty_page(struct page *page
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

lumpy-reclaim-v4.patch
split-mmap.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
mm-remove-destroy_dirty_buffers-from-invalidate_bdev.patch
mm-optimize-kill_bdev.patch
mm-optimize-kill_bdev-fix.patch
mm-optimize-acorn-partition-truncate.patch
lazy-freeing-of-memory-through-madv_free.patch
lazy-freeing-of-memory-through-madv_free-fix.patch
lazy-freeing-of-memory-through-madv_free-vs-mm-madvise-avoid-exclusive-mmap_sem.patch
restore-madv_dontneed-to-its-original-linux-behaviour.patch
exec-fix-remove_arg_zero-add-comment.patch
lockdep-treats-down_write_trylock-like-regular-down_write.patch
nfs-fix-congestion-control-use-atomic_longs.patch
nfs-remove-congestion_end.patch
lib-dampen-the-percpu_counter-fbc_batch.patch
lib-percpu_counter_mod64.patch
mm-bdi-init-hooks.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
mm-expose-bdi-statistics-in-sysfs.patch
mm-per-device-dirty-threshold.patch
