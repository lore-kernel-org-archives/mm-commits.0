Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0093C27
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oAu4OxHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1DDC433C7;
	Mon, 11 Dec 2023 00:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256078;
	bh=XwCIKiWkNpcrn1kgLyfB390TP0PCSiN5PY/tpPNM5q8=;
	h=Date:To:From:Subject:From;
	b=oAu4OxHLCvQ3vrrbbCVRpmR1J7jPwDMoXjH0IM7RMZCX2szKHoIYiI8mxQ5vQSJRc
	 YnWGdjFFKIyXet8Sx2/LAc2N8qgMBQqm5s3IYMajpS9i41nBOLXidwzvou4mztKFIY
	 F7f0u+KlcZnkFYVBL22r/6JojfOL00zPz7A7OYAA=
Date: Sun, 10 Dec 2023 16:54:37 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch removed from -mm tree
Message-Id: <20231211005437.ED1DDC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory-failure: convert truncate_error_page to truncate_error_folio
has been removed from the -mm tree.  Its filename was
     memory-failure-convert-truncate_error_page-to-truncate_error_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memory-failure: convert truncate_error_page to truncate_error_folio
Date: Fri, 17 Nov 2023 16:14:46 +0000

Both callers now have a folio, so pass it in.  Nothing downstream was
expecting a tail page; that's asserted in generic_error_remove_page(), for
example.

Link: https://lkml.kernel.org/r/20231117161447.2461643-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c~memory-failure-convert-truncate_error_page-to-truncate_error_folio
+++ a/mm/memory-failure.c
@@ -927,14 +927,13 @@ static int delete_from_lru_cache(struct
 	return -EIO;
 }
 
-static int truncate_error_page(struct page *p, unsigned long pfn,
+static int truncate_error_page(struct folio *folio, unsigned long pfn,
 				struct address_space *mapping)
 {
-	struct folio *folio = page_folio(p);
 	int ret = MF_FAILED;
 
 	if (mapping->a_ops->error_remove_page) {
-		int err = mapping->a_ops->error_remove_page(mapping, p);
+		int err = mapping->a_ops->error_remove_page(mapping, &folio->page);
 
 		if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
@@ -1055,7 +1054,7 @@ static int me_pagecache_clean(struct pag
 	 *
 	 * Open: to take i_rwsem or not for this? Right now we don't.
 	 */
-	ret = truncate_error_page(p, page_to_pfn(p), mapping);
+	ret = truncate_error_page(folio, page_to_pfn(p), mapping);
 	if (has_extra_refcount(ps, p, extra_pins))
 		ret = MF_FAILED;
 
@@ -1189,7 +1188,7 @@ static int me_huge_page(struct page_stat
 
 	mapping = folio_mapping(folio);
 	if (mapping) {
-		res = truncate_error_page(&folio->page, page_to_pfn(p), mapping);
+		res = truncate_error_page(folio, page_to_pfn(p), mapping);
 		/* The page is kept in page cache. */
 		extra_pins = true;
 		folio_unlock(folio);
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

