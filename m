Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB188257F
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oHEDmZIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49EAC433C8;
	Mon, 11 Dec 2023 00:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256058;
	bh=b2f7zAhvwJj0mo04LGmzqTFZTJgPeElLZngXYawGW9k=;
	h=Date:To:From:Subject:From;
	b=oHEDmZIPsCBNHblH8oV3EAiH+/eJeOPtobWoYGR5ipoyec75yR/zxI33uWhr21ZUJ
	 DWmJnl1CnWpq94N/78f48lIc2bmiGY6yd7GVx0EGXfdc2N5JY0TCmuL+01CDYYjwLd
	 PLSX6SMGPZyz9e0KK6q6i1OUijF+GZM6bCmn/MMQ=
Date: Sun, 10 Dec 2023 16:54:18 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch removed from -mm tree
Message-Id: <20231211005418.A49EAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make mapping_evict_folio() the preferred way to evict clean folios
has been removed from the -mm tree.  Its filename was
     mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: make mapping_evict_folio() the preferred way to evict clean folios
Date: Wed, 8 Nov 2023 18:28:04 +0000

Patch series "Fix fault handler's handling of poisoned tail pages".

Since introducing the ability to have large folios in the page cache, it's
been possible to have a hwpoisoned tail page returned from the fault
handler.  We handle this situation poorly; failing to remove the affected
page from use.

This isn't a minimal patch to fix it, it's a full conversion of all the
code surrounding it.


This patch (of 6):

invalidate_inode_page() does very little beyond calling
mapping_evict_folio().  Move the check for mapping being NULL into
mapping_evict_folio() and make it available to the rest of the MM for use
in the next few patches.

Link: https://lkml.kernel.org/r/20231108182809.602073-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231108182809.602073-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    1 +
 mm/truncate.c |   33 ++++++++++++++++-----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

--- a/mm/internal.h~mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios
+++ a/mm/internal.h
@@ -138,6 +138,7 @@ void filemap_free_folio(struct address_s
 int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
 bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
 		loff_t end);
+long mapping_evict_folio(struct address_space *mapping, struct folio *folio);
 long invalidate_inode_page(struct page *page);
 unsigned long mapping_try_invalidate(struct address_space *mapping,
 		pgoff_t start, pgoff_t end, unsigned long *nr_failed);
--- a/mm/truncate.c~mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios
+++ a/mm/truncate.c
@@ -266,9 +266,22 @@ int generic_error_remove_page(struct add
 }
 EXPORT_SYMBOL(generic_error_remove_page);
 
-static long mapping_evict_folio(struct address_space *mapping,
-		struct folio *folio)
+/**
+ * mapping_evict_folio() - Remove an unused folio from the page-cache.
+ * @mapping: The mapping this folio belongs to.
+ * @folio: The folio to remove.
+ *
+ * Safely remove one folio from the page cache.
+ * It only drops clean, unused folios.
+ *
+ * Context: Folio must be locked.
+ * Return: The number of pages successfully removed.
+ */
+long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
 {
+	/* The page may have been truncated before it was locked */
+	if (!mapping)
+		return 0;
 	if (folio_test_dirty(folio) || folio_test_writeback(folio))
 		return 0;
 	/* The refcount will be elevated if any page in the folio is mapped */
@@ -281,25 +294,11 @@ static long mapping_evict_folio(struct a
 	return remove_mapping(mapping, folio);
 }
 
-/**
- * invalidate_inode_page() - Remove an unused page from the pagecache.
- * @page: The page to remove.
- *
- * Safely invalidate one page from its pagecache mapping.
- * It only drops clean, unused pages.
- *
- * Context: Page must be locked.
- * Return: The number of pages successfully removed.
- */
 long invalidate_inode_page(struct page *page)
 {
 	struct folio *folio = page_folio(page);
-	struct address_space *mapping = folio_mapping(folio);
 
-	/* The page may have been truncated before it was locked */
-	if (!mapping)
-		return 0;
-	return mapping_evict_folio(mapping, folio);
+	return mapping_evict_folio(folio_mapping(folio), folio);
 }
 
 /**
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

