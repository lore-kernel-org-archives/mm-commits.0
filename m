Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3023933DE
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bTWzkXPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03B6C433C8;
	Mon, 11 Dec 2023 00:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256076;
	bh=lphdBWDx2gl0ZLn6fj8amJpUTpE2dNPiQB9frhTjOhs=;
	h=Date:To:From:Subject:From;
	b=bTWzkXPUjmVk6f0CqyjfFot9txdbe9MZiJeWsjsgH4S0nMwOsWfbKclcOh02nsn0o
	 lO0zFYA6mqAkuTJNo8IWj8QloiUvasA7iUd4TbTWyLkJslhXWo7lx0jvhkyOdJLIgu
	 DnvziH86RnOTPhlQJ97X1ebgS96zaDHfD1qVL6L4=
Date: Sun, 10 Dec 2023 16:54:35 -0800
To: mm-commits@vger.kernel.org,naoya.horiguchi@nec.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch removed from -mm tree
Message-Id: <20231211005435.F03B6C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory-failure: convert delete_from_lru_cache() to take a folio
has been removed from the -mm tree.  Its filename was
     memory-failure-convert-delete_from_lru_cache-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memory-failure: convert delete_from_lru_cache() to take a folio
Date: Fri, 17 Nov 2023 16:14:44 +0000

All three callers now have a folio; pass it in instead of the page.
Saves five calls to compound_head().

Link: https://lkml.kernel.org/r/20231117161447.2461643-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/memory-failure.c~memory-failure-convert-delete_from_lru_cache-to-take-a-folio
+++ a/mm/memory-failure.c
@@ -902,26 +902,26 @@ static const char * const action_page_ty
  * The page count will stop it from being freed by unpoison.
  * Stress tests should be aware of this memory leak problem.
  */
-static int delete_from_lru_cache(struct page *p)
+static int delete_from_lru_cache(struct folio *folio)
 {
-	if (isolate_lru_page(p)) {
+	if (folio_isolate_lru(folio)) {
 		/*
 		 * Clear sensible page flags, so that the buddy system won't
-		 * complain when the page is unpoison-and-freed.
+		 * complain when the folio is unpoison-and-freed.
 		 */
-		ClearPageActive(p);
-		ClearPageUnevictable(p);
+		folio_clear_active(folio);
+		folio_clear_unevictable(folio);
 
 		/*
 		 * Poisoned page might never drop its ref count to 0 so we have
 		 * to uncharge it manually from its memcg.
 		 */
-		mem_cgroup_uncharge(page_folio(p));
+		mem_cgroup_uncharge(folio);
 
 		/*
-		 * drop the page count elevated by isolate_lru_page()
+		 * drop the refcount elevated by folio_isolate_lru()
 		 */
-		put_page(p);
+		folio_put(folio);
 		return 0;
 	}
 	return -EIO;
@@ -1019,7 +1019,7 @@ static int me_pagecache_clean(struct pag
 	struct address_space *mapping;
 	bool extra_pins;
 
-	delete_from_lru_cache(p);
+	delete_from_lru_cache(folio);
 
 	/*
 	 * For anonymous folios the only reference left
@@ -1146,7 +1146,7 @@ static int me_swapcache_dirty(struct pag
 	/* Trigger EIO in shmem: */
 	folio_clear_uptodate(folio);
 
-	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_DELAYED;
+	ret = delete_from_lru_cache(folio) ? MF_FAILED : MF_DELAYED;
 	folio_unlock(folio);
 
 	if (ret == MF_DELAYED)
@@ -1165,7 +1165,7 @@ static int me_swapcache_clean(struct pag
 
 	delete_from_swap_cache(folio);
 
-	ret = delete_from_lru_cache(p) ? MF_FAILED : MF_RECOVERED;
+	ret = delete_from_lru_cache(folio) ? MF_FAILED : MF_RECOVERED;
 	folio_unlock(folio);
 
 	if (has_extra_refcount(ps, p, false))
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

