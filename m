Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C0CF9D7
	for <mm-commits@vger.kernel.org>; Thu, 28 Dec 2023 18:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xz9vl+uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A229DC433C7;
	Thu, 28 Dec 2023 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703787336;
	bh=q7xdKA6eMXZcYh0zQhK5+UgAPYr8Gc5OHIGZx+wW0dg=;
	h=Date:To:From:Subject:From;
	b=xz9vl+uWb8x+pkwvQbroBocsusY/5claxuW2cwGWBSpFNYCMcIr9hlf2+tuQOWJOp
	 I1NH4wzEkJjJ9zv4Awx713JJjmxdw/8BmK/GhUHVtWmtntTspZyEektjWcoNJxxl7m
	 pcpVSFKMBSgE8799rYmDOg3Xwf9nYc29dJmM2uYs=
Date: Thu, 28 Dec 2023 10:15:35 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-inc-dec-lruvec-page-state-functions.patch removed from -mm tree
Message-Id: <20231228181536.A229DC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove inc/dec lruvec page state functions
has been removed from the -mm tree.  Its filename was
     mm-remove-inc-dec-lruvec-page-state-functions.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: remove inc/dec lruvec page state functions
Date: Fri, 22 Dec 2023 20:28:04 +0000

Patch series "Remove some lruvec page accounting functions".

Some functions are now unused; remove them.  Make
__mod_lruvec_page_state() unused and then remove it.


This patch (of 4):

All callers of these have been converted to their folio equivalents.

Link: https://lkml.kernel.org/r/20231222202807.2135717-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231222202807.2135717-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmstat.h |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/include/linux/vmstat.h~mm-remove-inc-dec-lruvec-page-state-functions
+++ a/include/linux/vmstat.h
@@ -597,18 +597,6 @@ static inline void mod_lruvec_page_state
 
 #endif /* CONFIG_MEMCG */
 
-static inline void __inc_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void __dec_lruvec_page_state(struct page *page,
-					   enum node_stat_item idx)
-{
-	__mod_lruvec_page_state(page, idx, -1);
-}
-
 static inline void __lruvec_stat_mod_folio(struct folio *folio,
 					   enum node_stat_item idx, int val)
 {
@@ -627,18 +615,6 @@ static inline void __lruvec_stat_sub_fol
 	__lruvec_stat_mod_folio(folio, idx, -folio_nr_pages(folio));
 }
 
-static inline void inc_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, 1);
-}
-
-static inline void dec_lruvec_page_state(struct page *page,
-					 enum node_stat_item idx)
-{
-	mod_lruvec_page_state(page, idx, -1);
-}
-
 static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios.patch
mm-convert-ksm_might_need_to_copy-to-work-on-folios-fix.patch
mm-remove-pageanonexclusive-assertions-in-unuse_pte.patch
mm-convert-unuse_pte-to-use-a-folio-throughout.patch
mm-remove-some-calls-to-page_add_new_anon_rmap.patch
mm-remove-stale-example-from-comment.patch
mm-remove-references-to-page_add_new_anon_rmap-in-comments.patch
mm-convert-migrate_vma_insert_page-to-use-a-folio.patch
mm-convert-collapse_huge_page-to-use-a-folio.patch
mm-remove-page_add_new_anon_rmap-and-lru_cache_add_inactive_or_unevictable.patch
mm-return-the-folio-from-__read_swap_cache_async.patch
mm-pass-a-folio-to-__swap_writepage.patch
mm-pass-a-folio-to-swap_writepage_fs.patch
mm-pass-a-folio-to-swap_writepage_bdev_sync.patch
mm-pass-a-folio-to-swap_writepage_bdev_async.patch
mm-pass-a-folio-to-swap_readpage_fs.patch
mm-pass-a-folio-to-swap_readpage_bdev_sync.patch
mm-pass-a-folio-to-swap_readpage_bdev_async.patch
mm-convert-swap_page_sector-to-swap_folio_sector.patch
mm-convert-swap_readpage-to-swap_read_folio.patch
mm-remove-page_swap_info.patch
mm-return-a-folio-from-read_swap_cache_async.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch
mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio-fix.patch
fs-remove-clean_page_buffers.patch
fs-convert-clean_buffers-to-take-a-folio.patch
fs-reduce-stack-usage-in-__mpage_writepage.patch
fs-reduce-stack-usage-in-do_mpage_readpage.patch
adfs-remove-writepage-implementation.patch
bfs-remove-writepage-implementation.patch
hfs-really-remove-hfs_writepage.patch
hfsplus-really-remove-hfsplus_writepage.patch
minix-remove-writepage-implementation.patch
ocfs2-remove-writepage-implementation.patch
sysv-remove-writepage-implementation.patch
ufs-remove-writepage-implementation.patch
fs-convert-block_write_full_page-to-block_write_full_folio.patch
fs-remove-the-bh_end_io-argument-from-__block_write_full_folio.patch
slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

