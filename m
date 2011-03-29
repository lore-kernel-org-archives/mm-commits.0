From: akpm@linux-foundation.org
Subject: [to-be-updated] memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch removed from -mm tree
Date: Tue, 29 Mar 2011 16:11:50 -0700
Message-ID: <201103292311.p2TNBomG011250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754666Ab1C2XMc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Mar 2011 19:12:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, arighi@develer.com, balbir@linux.vnet.ibm.com, ctalbott@google.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.co


The patch titled
     memcg: add kernel calls for memcg dirty page stats
has been removed from the -mm tree.  Its filename was
     memcg-add-kernel-calls-for-memcg-dirty-page-stats.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: add kernel calls for memcg dirty page stats
From: Greg Thelen <gthelen@google.com>

Add calls into memcg dirty page accounting.  Notify memcg when pages
transition between clean, file dirty, writeback, and unstable nfs.  This
allows the memory controller to maintain an accurate view of the amount of
its memory that is dirty.

Signed-off-by: Greg Thelen <gthelen@google.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chad Talbott <ctalbott@google.com>
Cc: Justin TerAvest <teravest@google.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c      |    4 ++++
 mm/filemap.c        |    1 +
 mm/page-writeback.c |   10 ++++++++--
 mm/truncate.c       |    1 +
 4 files changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/nfs/write.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats fs/nfs/write.c
--- a/fs/nfs/write.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats
+++ a/fs/nfs/write.c
@@ -456,6 +456,7 @@ nfs_mark_request_commit(struct nfs_page 
 	nfsi->ncommit++;
 	spin_unlock(&inode->i_lock);
 	pnfs_mark_request_commit(req, lseg);
+	mem_cgroup_inc_page_stat(req->wb_page, MEMCG_NR_FILE_UNSTABLE_NFS);
 	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
 	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
@@ -467,6 +468,7 @@ nfs_clear_request_commit(struct nfs_page
 	struct page *page = req->wb_page;
 
 	if (test_and_clear_bit(PG_CLEAN, &(req)->wb_flags)) {
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_UNSTABLE_NFS);
 		dec_zone_page_state(page, NR_UNSTABLE_NFS);
 		dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
 		return 1;
@@ -1380,6 +1382,8 @@ void nfs_retry_commit(struct list_head *
 		req = nfs_list_entry(page_list->next);
 		nfs_list_remove_request(req);
 		nfs_mark_request_commit(req, lseg);
+		mem_cgroup_dec_page_stat(req->wb_page,
+					 MEMCG_NR_FILE_UNSTABLE_NFS);
 		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
 		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
 			     BDI_RECLAIMABLE);
diff -puN mm/filemap.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats mm/filemap.c
--- a/mm/filemap.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats
+++ a/mm/filemap.c
@@ -145,6 +145,7 @@ void __delete_from_page_cache(struct pag
 	 * having removed the page entirely.
 	 */
 	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
 		dec_zone_page_state(page, NR_FILE_DIRTY);
 		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
 	}
diff -puN mm/page-writeback.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats mm/page-writeback.c
--- a/mm/page-writeback.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats
+++ a/mm/page-writeback.c
@@ -1124,6 +1124,7 @@ int __set_page_dirty_no_writeback(struct
 void account_page_dirtied(struct page *page, struct address_space *mapping)
 {
 	if (mapping_cap_account_dirty(mapping)) {
+		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_FILE_DIRTY);
 		__inc_zone_page_state(page, NR_DIRTIED);
 		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
@@ -1323,6 +1324,7 @@ int clear_page_dirty_for_io(struct page 
 		 * for more comments.
 		 */
 		if (TestClearPageDirty(page)) {
+			mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			dec_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
@@ -1358,8 +1360,10 @@ int test_clear_page_writeback(struct pag
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
-	if (ret)
+	if (ret) {
+		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK);
+	}
 	return ret;
 }
 
@@ -1392,8 +1396,10 @@ int test_set_page_writeback(struct page 
 	} else {
 		ret = TestSetPageWriteback(page);
 	}
-	if (!ret)
+	if (!ret) {
+		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
 		account_page_writeback(page);
+	}
 	return ret;
 
 }
diff -puN mm/truncate.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats mm/truncate.c
--- a/mm/truncate.c~memcg-add-kernel-calls-for-memcg-dirty-page-stats
+++ a/mm/truncate.c
@@ -76,6 +76,7 @@ void cancel_dirty_page(struct page *page
 	if (TestClearPageDirty(page)) {
 		struct address_space *mapping = page->mapping;
 		if (mapping && mapping_cap_account_dirty(mapping)) {
+			mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
 			dec_zone_page_state(page, NR_FILE_DIRTY);
 			dec_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
memcg-add-dirty-limits-to-mem_cgroup.patch
memcg-add-cgroupfs-interface-to-memcg-dirty-limits.patch
memcg-add-dirty-limiting-routines.patch
memcg-check-memcg-dirty-limits-in-page-writeback.patch
memcg-make-background-writeback-memcg-aware.patch

