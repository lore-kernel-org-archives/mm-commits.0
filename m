Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04C02569
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myzPN7q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA07C433C9;
	Mon, 11 Dec 2023 00:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256061;
	bh=Kmp0uPK5+ZA5XACYQxxmwj58oxOiKyyLvJaPbsjdX94=;
	h=Date:To:From:Subject:From;
	b=myzPN7q7B9KgHoW3z95N2iUIji0mbLoxxW+e4ILeGBpIwEmle2K7AMtQkKkw2TfNF
	 hHjnD8fnbKKRwDDw68r/tn1AXJuGoiQr+Z0818vIX5sENPmxd+/3Pckd5K8sYWs75T
	 21T8JddGAv8sE2xRhTIPH8+n89RaxQoazioxr+cc=
Date: Sun, 10 Dec 2023 16:54:21 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-soft_offline_in_use_page-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211005421.9CA07C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert soft_offline_in_use_page() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-soft_offline_in_use_page-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert soft_offline_in_use_page() to use a folio
Date: Wed, 8 Nov 2023 18:28:07 +0000

Replace the existing head-page logic with folio logic.

Link: https://lkml.kernel.org/r/20231108182809.602073-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/memory-failure.c~mm-convert-soft_offline_in_use_page-to-use-a-folio
+++ a/mm/memory-failure.c
@@ -2645,40 +2645,40 @@ static int soft_offline_in_use_page(stru
 {
 	long ret = 0;
 	unsigned long pfn = page_to_pfn(page);
-	struct page *hpage = compound_head(page);
+	struct folio *folio = page_folio(page);
 	char const *msg_page[] = {"page", "hugepage"};
-	bool huge = PageHuge(page);
+	bool huge = folio_test_hugetlb(folio);
 	LIST_HEAD(pagelist);
 	struct migration_target_control mtc = {
 		.nid = NUMA_NO_NODE,
 		.gfp_mask = GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL,
 	};
 
-	if (!huge && PageTransHuge(hpage)) {
+	if (!huge && folio_test_large(folio)) {
 		if (try_to_split_thp_page(page)) {
 			pr_info("soft offline: %#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
-		hpage = page;
+		folio = page_folio(page);
 	}
 
-	lock_page(page);
+	folio_lock(folio);
 	if (!huge)
-		wait_on_page_writeback(page);
+		folio_wait_writeback(folio);
 	if (PageHWPoison(page)) {
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		return 0;
 	}
 
-	if (!huge && PageLRU(page) && !PageSwapCache(page))
+	if (!huge && folio_test_lru(folio) && !folio_test_swapcache(folio))
 		/*
 		 * Try to invalidate first. This should work for
 		 * non dirty unmapped page cache pages.
 		 */
-		ret = invalidate_inode_page(page);
-	unlock_page(page);
+		ret = mapping_evict_folio(folio_mapping(folio), folio);
+	folio_unlock(folio);
 
 	if (ret) {
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
@@ -2686,7 +2686,7 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (isolate_page(hpage, &pagelist)) {
+	if (isolate_page(&folio->page, &pagelist)) {
 		ret = migrate_pages(&pagelist, alloc_migration_target, NULL,
 			(unsigned long)&mtc, MIGRATE_SYNC, MR_MEMORY_FAILURE, NULL);
 		if (!ret) {
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
nilfs2-add-nilfs_end_folio_io.patch
nilfs2-convert-nilfs_abort_logs-to-use-folios.patch
nilfs2-convert-nilfs_segctor_complete_write-to-use-folios.patch
nilfs2-convert-nilfs_forget_buffer-to-use-a-folio.patch
nilfs2-convert-to-nilfs_folio_buffers_clean.patch
nilfs2-convert-nilfs_writepage-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_write_page-to-use-a-folio.patch
nilfs2-convert-to-nilfs_clear_folio_dirty.patch
nilfs2-convert-to-__nilfs_clear_folio_dirty.patch
nilfs2-convert-nilfs_segctor_prepare_write-to-use-folios.patch
nilfs2-convert-nilfs_page_mkwrite-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_mdt_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_gccache_submit_read_data-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_create_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_submit_block-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_delete-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_prepare_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_commit_change_key-to-use-a-folio.patch
nilfs2-convert-nilfs_btnode_abort_change_key-to-use-a-folio.patch
nilfs2-remove-page_address-from-nilfs_set_link.patch
nilfs2-remove-page_address-from-nilfs_add_link.patch
nilfs2-remove-page_address-from-nilfs_delete_entry.patch
nilfs2-return-the-mapped-address-from-nilfs_get_page.patch
nilfs2-pass-the-mapped-address-to-nilfs_check_page.patch
nilfs2-switch-to-kmap_local-for-directory-handling.patch
nilfs2-add-nilfs_get_folio.patch
nilfs2-convert-nilfs_readdir-to-use-a-folio.patch
nilfs2-convert-nilfs_find_entry-to-use-a-folio.patch
nilfs2-convert-nilfs_rename-to-use-folios.patch
nilfs2-convert-nilfs_add_link-to-use-a-folio.patch
nilfs2-convert-nilfs_empty_dir-to-use-a-folio.patch
nilfs2-convert-nilfs_make_empty-to-use-a-folio.patch
nilfs2-convert-nilfs_prepare_chunk-and-nilfs_commit_chunk-to-folios.patch
nilfs2-convert-nilfs_page_bug-to-nilfs_folio_bug.patch

