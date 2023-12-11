Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7C923C4
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wE/PB7Zj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ED5C433C9;
	Mon, 11 Dec 2023 00:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256057;
	bh=5+d52qtFokvdS0oQN18YTVhIHRxrXca0MG5LE+uf3r8=;
	h=Date:To:From:Subject:From;
	b=wE/PB7Zji/ce2LzE6xWhj23VP79yMOV7uAAz4plmjsl0zqQ12a9saIlO7EACh1j8/
	 FWHuEYu4WTObm1jzQtdIXQBEoDb5+T63h6xCL/gjyYiN0oNxoU7QYltBZYtGSFacFQ
	 vIm53uwjnmFMGhjneNNWIP/iKwcht10KxDkfctIM=
Date: Sun, 10 Dec 2023 16:54:17 -0800
To: mm-commits@vger.kernel.org,sfrench@samba.org,josef@toxicpanda.com,dhowells@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-return-void-from-folio_start_writeback-and-related-functions.patch removed from -mm tree
Message-Id: <20231211005417.B6ED5C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: return void from folio_start_writeback() and related functions
has been removed from the -mm tree.  Its filename was
     mm-return-void-from-folio_start_writeback-and-related-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: return void from folio_start_writeback() and related functions
Date: Wed, 8 Nov 2023 20:46:05 +0000

Nobody now checks the return value from any of these functions, so
add an assertion at the beginning of the function and return void.

Link: https://lkml.kernel.org/r/20231108204605.745109-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 +-
 mm/folio-compat.c          |    4 +-
 mm/page-writeback.c        |   60 ++++++++++++++++-------------------
 3 files changed, 32 insertions(+), 36 deletions(-)

--- a/include/linux/page-flags.h~mm-return-void-from-folio_start_writeback-and-related-functions
+++ a/include/linux/page-flags.h
@@ -772,8 +772,8 @@ static __always_inline void SetPageUptod
 
 CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
 
-bool __folio_start_writeback(struct folio *folio, bool keep_write);
-bool set_page_writeback(struct page *page);
+void __folio_start_writeback(struct folio *folio, bool keep_write);
+void set_page_writeback(struct page *page);
 
 #define folio_start_writeback(folio)			\
 	__folio_start_writeback(folio, false)
--- a/mm/folio-compat.c~mm-return-void-from-folio_start_writeback-and-related-functions
+++ a/mm/folio-compat.c
@@ -46,9 +46,9 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-bool set_page_writeback(struct page *page)
+void set_page_writeback(struct page *page)
 {
-	return folio_start_writeback(page_folio(page));
+	folio_start_writeback(page_folio(page));
 }
 EXPORT_SYMBOL(set_page_writeback);
 
--- a/mm/page-writeback.c~mm-return-void-from-folio_start_writeback-and-related-functions
+++ a/mm/page-writeback.c
@@ -2982,67 +2982,63 @@ bool __folio_end_writeback(struct folio
 	return ret;
 }
 
-bool __folio_start_writeback(struct folio *folio, bool keep_write)
+void __folio_start_writeback(struct folio *folio, bool keep_write)
 {
 	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
-	bool ret;
 	int access_ret;
 
+	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
+
 	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
+		bool on_wblist;
 
 		xas_lock_irqsave(&xas, flags);
 		xas_load(&xas);
-		ret = folio_test_set_writeback(folio);
-		if (!ret) {
-			bool on_wblist;
-
-			on_wblist = mapping_tagged(mapping,
-						   PAGECACHE_TAG_WRITEBACK);
-
-			xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
-			if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
-				struct bdi_writeback *wb = inode_to_wb(inode);
-
-				wb_stat_mod(wb, WB_WRITEBACK, nr);
-				if (!on_wblist)
-					wb_inode_writeback_start(wb);
-			}
-
-			/*
-			 * We can come through here when swapping
-			 * anonymous folios, so we don't necessarily
-			 * have an inode to track for sync.
-			 */
-			if (mapping->host && !on_wblist)
-				sb_mark_inode_writeback(mapping->host);
+		folio_test_set_writeback(folio);
+
+		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
+
+		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
+		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
+			struct bdi_writeback *wb = inode_to_wb(inode);
+
+			wb_stat_mod(wb, WB_WRITEBACK, nr);
+			if (!on_wblist)
+				wb_inode_writeback_start(wb);
 		}
+
+		/*
+		 * We can come through here when swapping anonymous
+		 * folios, so we don't necessarily have an inode to
+		 * track for sync.
+		 */
+		if (mapping->host && !on_wblist)
+			sb_mark_inode_writeback(mapping->host);
 		if (!folio_test_dirty(folio))
 			xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
 		if (!keep_write)
 			xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
 		xas_unlock_irqrestore(&xas, flags);
 	} else {
-		ret = folio_test_set_writeback(folio);
-	}
-	if (!ret) {
-		lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
-		zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
+		folio_test_set_writeback(folio);
 	}
+
+	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 	folio_memcg_unlock(folio);
+
 	access_ret = arch_make_folio_accessible(folio);
 	/*
 	 * If writeback has been triggered on a page that cannot be made
 	 * accessible, it is too late to recover here.
 	 */
 	VM_BUG_ON_FOLIO(access_ret != 0, folio);
-
-	return ret;
 }
 EXPORT_SYMBOL(__folio_start_writeback);
 
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

