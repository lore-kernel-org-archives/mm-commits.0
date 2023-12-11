Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF5A33F5
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vXd/rmih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B834C433CA;
	Mon, 11 Dec 2023 00:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256063;
	bh=iQrpq6yS0N3G+Q01va9jGUHEPqrMKSOP+F11C3LTFa0=;
	h=Date:To:From:Subject:From;
	b=vXd/rmihmiEt9ruyyK3GcdCLyNu73MF9ddzFbFFyEF9rUxja9vObOu0CUeRtvffg5
	 uxPqUsxzQqJ7ZU2ea4oarQ8dERa0bmed39HHkNhNgkSq9hHVjh6GHWVCa60t1fhQtF
	 urFCYUvHcLriyWfrsrpq61wFm/ZXmT1YcuvoD5ow=
Date: Sun, 10 Dec 2023 16:54:23 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-invalidate_inode_page.patch removed from -mm tree
Message-Id: <20231211005423.8B834C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove invalidate_inode_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-invalidate_inode_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove invalidate_inode_page()
Date: Wed, 8 Nov 2023 18:28:09 +0000

All callers are now converted to call mapping_evict_folio().

Link: https://lkml.kernel.org/r/20231108182809.602073-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 -
 mm/truncate.c |   11 ++---------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/mm/internal.h~mm-remove-invalidate_inode_page
+++ a/mm/internal.h
@@ -139,7 +139,6 @@ int truncate_inode_folio(struct address_
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
 long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
-long invalidate_inode_page(struct page *page);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
 
--- a/mm/truncate.c~mm-remove-invalidate_inode_page
+++ a/mm/truncate.c
@@ -294,13 +294,6 @@ long mapping_evict_folio(struct address_
 	return remove_mapping(mapping, folio);
 }
 
-long invalidate_inode_page(struct page *page)
-{
-	struct folio *folio = page_folio(page);
-
-	return mapping_evict_folio(folio_mapping(folio), folio);
-}
-
 /**
  * truncate_inode_pages_range - truncate range of pages specified by start & end byte offsets
  * @mapping: mapping to truncate
@@ -559,9 +552,9 @@ unsigned long invalidate_mapping_pages(s
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
 /*
- * This is like invalidate_inode_page(), except it ignores the page's
+ * This is like mapping_evict_folio(), except it ignores the folio's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
- * invalidation guarantees, and cannot afford to leave pages behind because
+ * invalidation guarantees, and cannot afford to leave folios behind because
  * shrink_page_list() has a temp ref on them, or because they're transiently
  * sitting in the folio_add_lru() caches.
  */
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

