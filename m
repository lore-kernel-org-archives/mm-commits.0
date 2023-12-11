Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2F9322A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JQnoAkvY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953C8C433C8;
	Mon, 11 Dec 2023 00:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256062;
	bh=J5i6Zws06HNNp0wHY+4ppOfjVsCcnUmYDFUmkcxUzkI=;
	h=Date:To:From:Subject:From;
	b=JQnoAkvYeHb4SbssO2lmK6McY+kHnVZTctJVTtDk2A5iwvRze+pdDmN3RMpdnUhcp
	 /D7CPA1F6ngClcx51AJpt8M8lrxzzfQWOU9J2XDPSS0X3o9oZsIAXhDWTf0kUJzg82
	 8Su83Me46G+agz6EcBToXBguO84cYAnKZdT061Sk=
Date: Sun, 10 Dec 2023 16:54:22 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-isolate_page-to-mf_isolate_folio.patch removed from -mm tree
Message-Id: <20231211005422.953C8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert isolate_page() to mf_isolate_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-isolate_page-to-mf_isolate_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert isolate_page() to mf_isolate_folio()
Date: Wed, 8 Nov 2023 18:28:08 +0000

The only caller now has a folio, so pass it in and operate on it.  Saves
many page->folio conversions and introduces only one folio->page
conversion when calling isolate_movable_page().

Link: https://lkml.kernel.org/r/20231108182809.602073-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/mm/memory-failure.c~mm-convert-isolate_page-to-mf_isolate_folio
+++ a/mm/memory-failure.c
@@ -2602,37 +2602,37 @@ unlock_mutex:
 }
 EXPORT_SYMBOL(unpoison_memory);
 
-static bool isolate_page(struct page *page, struct list_head *pagelist)
+static bool mf_isolate_folio(struct folio *folio, struct list_head *pagelist)
 {
 	bool isolated = false;
 
-	if (PageHuge(page)) {
-		isolated = isolate_hugetlb(page_folio(page), pagelist);
+	if (folio_test_hugetlb(folio)) {
+		isolated = isolate_hugetlb(folio, pagelist);
 	} else {
-		bool lru = !__PageMovable(page);
+		bool lru = !__folio_test_movable(folio);
 
 		if (lru)
-			isolated = isolate_lru_page(page);
+			isolated = folio_isolate_lru(folio);
 		else
-			isolated = isolate_movable_page(page,
+			isolated = isolate_movable_page(&folio->page,
 							ISOLATE_UNEVICTABLE);
 
 		if (isolated) {
-			list_add(&page->lru, pagelist);
+			list_add(&folio->lru, pagelist);
 			if (lru)
-				inc_node_page_state(page, NR_ISOLATED_ANON +
-						    page_is_file_lru(page));
+				node_stat_add_folio(folio, NR_ISOLATED_ANON +
+						    folio_is_file_lru(folio));
 		}
 	}
 
 	/*
-	 * If we succeed to isolate the page, we grabbed another refcount on
-	 * the page, so we can safely drop the one we got from get_any_page().
-	 * If we failed to isolate the page, it means that we cannot go further
+	 * If we succeed to isolate the folio, we grabbed another refcount on
+	 * the folio, so we can safely drop the one we got from get_any_page().
+	 * If we failed to isolate the folio, it means that we cannot go further
 	 * and we will return an error, so drop the reference we got from
 	 * get_any_page() as well.
 	 */
-	put_page(page);
+	folio_put(folio);
 	return isolated;
 }
 
@@ -2686,7 +2686,7 @@ static int soft_offline_in_use_page(stru
 		return 0;
 	}
 
-	if (isolate_page(&folio->page, &pagelist)) {
+	if (mf_isolate_folio(folio, &pagelist)) {
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

