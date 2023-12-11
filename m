Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D982B23C4
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mCvsZmVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F69C433C8;
	Mon, 11 Dec 2023 00:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256059;
	bh=Xf6nDUm7daw4YOK7gdwLyqjz4ZNoDFboORR3Ae8PcYs=;
	h=Date:To:From:Subject:From;
	b=mCvsZmVUiVazWs9gaeQBoSli4eGZ697XrHM2uquF8mCSdQnHdzAsVh4enPrB5iBvj
	 15+ak/SjuNqonOQggdwznU+vBq9sU3SuBCy4RRzmB1VZ2O8z47mVwbodPB8vr1TJg9
	 mc6t1UXoWcDxV5Ls/zdRxW+Iym6ASkE2ZqXYsY7k=
Date: Sun, 10 Dec 2023 16:54:19 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-__do_fault-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211005419.A4F69C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert __do_fault() to use a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-__do_fault-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert __do_fault() to use a folio
Date: Wed, 8 Nov 2023 18:28:05 +0000

Convert vmf->page to a folio as soon as we're going to use it.  This fixes
a bug if the fault handler returns a tail page with hardware poison; tail
pages have an invalid page->index, so we would fail to unmap the page from
the page tables.  We actually have to unmap the entire folio (or
mapping_evict_folio() will fail), so use unmap_mapping_folio() instead.

This also saves various calls to compound_head() hidden in lock_page(),
put_page(), etc.

Link: https://lkml.kernel.org/r/20231108182809.602073-3-willy@infradead.org
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memory.c~mm-convert-__do_fault-to-use-a-folio
+++ a/mm/memory.c
@@ -4245,6 +4245,7 @@ oom:
 static vm_fault_t __do_fault(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
 	vm_fault_t ret;
 
 	/*
@@ -4273,27 +4274,26 @@ static vm_fault_t __do_fault(struct vm_f
 			    VM_FAULT_DONE_COW)))
 		return ret;
 
+	folio = page_folio(vmf->page);
 	if (unlikely(PageHWPoison(vmf->page))) {
-		struct page *page = vmf->page;
 		vm_fault_t poisonret = VM_FAULT_HWPOISON;
 		if (ret & VM_FAULT_LOCKED) {
-			if (page_mapped(page))
-				unmap_mapping_pages(page_mapping(page),
-						    page->index, 1, false);
-			/* Retry if a clean page was removed from the cache. */
-			if (invalidate_inode_page(page))
+			if (page_mapped(vmf->page))
+				unmap_mapping_folio(folio);
+			/* Retry if a clean folio was removed from the cache. */
+			if (mapping_evict_folio(folio->mapping, folio))
 				poisonret = VM_FAULT_NOPAGE;
-			unlock_page(page);
+			folio_unlock(folio);
 		}
-		put_page(page);
+		folio_put(folio);
 		vmf->page = NULL;
 		return poisonret;
 	}
 
 	if (unlikely(!(ret & VM_FAULT_LOCKED)))
-		lock_page(vmf->page);
+		folio_lock(folio);
 	else
-		VM_BUG_ON_PAGE(!PageLocked(vmf->page), vmf->page);
+		VM_BUG_ON_PAGE(!folio_test_locked(folio), vmf->page);
 
 	return ret;
 }
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

