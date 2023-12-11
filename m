Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED933D8A
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KDKafisV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB29C433C7;
	Mon, 11 Dec 2023 00:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256077;
	bh=6gAjm20ClpYMhlLhik66PUMvr0Q8f27vkv3Cmpbt6pQ=;
	h=Date:To:From:Subject:From;
	b=KDKafisVGcBdJffw1XgZT/H7PyGDQm8ZWUOReV0HJByXcR0Zm+JvAcoWiU5Gq7x2v
	 mL/mpK9HOXXyPTQQHjXIaQmcagaBlqHeU7degFfoDg2POhD6lb63vxoTbbV3ujitOO
	 f/OiEaLFfustfrHO90ctBYGMAiOwYNzJvT6wQtk4=
Date: Sun, 10 Dec 2023 16:54:36 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-failure-use-a-folio-in-me_huge_page.patch removed from -mm tree
Message-Id: <20231211005436.ECB29C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory-failure: use a folio in me_huge_page()
has been removed from the -mm tree.  Its filename was
     memory-failure-use-a-folio-in-me_huge_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memory-failure: use a folio in me_huge_page()
Date: Fri, 17 Nov 2023 16:14:45 +0000

This function was already explicitly calling compound_head();
unfortunately the compiler can't know that and elide the redundant calls
to compound_head() buried in page_mapping(), unlock_page(), etc.  Switch
to using a folio, which does let us elide these calls.

Link: https://lkml.kernel.org/r/20231117161447.2461643-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory-failure.c~memory-failure-use-a-folio-in-me_huge_page
+++ a/mm/memory-failure.c
@@ -1182,25 +1182,25 @@ static int me_swapcache_clean(struct pag
  */
 static int me_huge_page(struct page_state *ps, struct page *p)
 {
+	struct folio *folio = page_folio(p);
 	int res;
-	struct page *hpage = compound_head(p);
 	struct address_space *mapping;
 	bool extra_pins = false;
 
-	mapping = page_mapping(hpage);
+	mapping = folio_mapping(folio);
 	if (mapping) {
-		res = truncate_error_page(hpage, page_to_pfn(p), mapping);
+		res = truncate_error_page(&folio->page, page_to_pfn(p), mapping);
 		/* The page is kept in page cache. */
 		extra_pins = true;
-		unlock_page(hpage);
+		folio_unlock(folio);
 	} else {
-		unlock_page(hpage);
+		folio_unlock(folio);
 		/*
 		 * migration entry prevents later access on error hugepage,
 		 * so we can free and dissolve it into buddy to save healthy
 		 * subpages.
 		 */
-		put_page(hpage);
+		folio_put(folio);
 		if (__page_handle_poison(p) >= 0) {
 			page_ref_inc(p);
 			res = MF_RECOVERED;
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

