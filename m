Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02FD2569
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="071RpWYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33FCC433C7;
	Mon, 11 Dec 2023 00:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256060;
	bh=iyj016/FeCHg7TCYrXq8EzHcBzmSA0h2nQOUSF2K6nc=;
	h=Date:To:From:Subject:From;
	b=071RpWYEelPUElbV3QVgZPG2RcHZEGQr63WRxGcHEOGQeMHal+FoeQeJNSauF5q6L
	 /E1/p6+31PfMkMH/PG62vYkK4EGtHzKnNjLYzFgNpPRjuT0p1xmLvrLqMPNQW4F+/j
	 N++bOkgmR018gNTe9DFM9NbfGkohLpc+IJsTQH+c=
Date: Sun, 10 Dec 2023 16:54:20 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-mapping_evict_folio-in-truncate_error_page.patch removed from -mm tree
Message-Id: <20231211005420.A33FCC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use mapping_evict_folio() in truncate_error_page()
has been removed from the -mm tree.  Its filename was
     mm-use-mapping_evict_folio-in-truncate_error_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: use mapping_evict_folio() in truncate_error_page()
Date: Wed, 8 Nov 2023 18:28:06 +0000

We already have the folio and the mapping, so replace the call to
invalidate_inode_page() with mapping_evict_folio().

Link: https://lkml.kernel.org/r/20231108182809.602073-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory-failure.c~mm-use-mapping_evict_folio-in-truncate_error_page
+++ a/mm/memory-failure.c
@@ -930,10 +930,10 @@ static int delete_from_lru_cache(struct
 static int truncate_error_page(struct page *p, unsigned long pfn,
 				struct address_space *mapping)
 {
+	struct folio *folio = page_folio(p);
 	int ret = MF_FAILED;
 
 	if (mapping->a_ops->error_remove_page) {
-		struct folio *folio = page_folio(p);
 		int err = mapping->a_ops->error_remove_page(mapping, p);
 
 		if (err != 0)
@@ -947,7 +947,7 @@ static int truncate_error_page(struct pa
 		 * If the file system doesn't support it just invalidate
 		 * This fails on dirty or anything with private pages
 		 */
-		if (invalidate_inode_page(p))
+		if (mapping_evict_folio(mapping, folio))
 			ret = MF_RECOVERED;
 		else
 			pr_info("%#lx: Failed to invalidate\n",	pfn);
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

