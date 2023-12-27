Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CDC481A3
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 22:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xoI9482f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC98C433CA;
	Wed, 27 Dec 2023 22:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703714583;
	bh=AzVgEE8fcfQ1AmSFvYFu5r4GoO1w6k9qFf0W1Feqj4g=;
	h=Date:To:From:Subject:From;
	b=xoI9482ffvPqiEXfX19euo+F6iwJlSBsL66XyX7D6wMSaIJr6ZRWc4QPiMnr5MJnT
	 SpkXfNcNnNjknN3RnXRs5kJo8NQbqLIVimmWuuaeLxTMYSpNxGA1dPiNYhtl4lMznv
	 gq3ZHDIFcwpLkL4rAfKLTbGt21tpYuwHVKflymi4=
Date: Wed, 27 Dec 2023 14:03:02 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios.patch added to mm-unstable branch
Message-Id: <20231227220303.3CC98C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slab: convert __kmalloc_large_node() and free_large_kmalloc() to use folios
has been added to the -mm mm-unstable branch.  Its filename is
     slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: slab: convert __kmalloc_large_node() and free_large_kmalloc() to use folios
Date: Fri, 22 Dec 2023 20:28:05 +0000

Add folio_alloc_node() to replace alloc_pages_node() and then use folio
APIs throughout instead of converting back to pages.

Link: https://lkml.kernel.org/r/20231222202807.2135717-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    9 +++++++++
 mm/slab_common.c    |   15 +++++++--------
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/include/linux/gfp.h~slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios
+++ a/include/linux/gfp.h
@@ -247,6 +247,15 @@ struct folio *__folio_alloc_node(gfp_t g
 	return __folio_alloc(gfp, order, nid, NULL);
 }
 
+static inline
+struct folio *folio_alloc_node(gfp_t gfp, unsigned int order, int nid)
+{
+	if (nid == NUMA_NO_NODE)
+		nid = numa_mem_id();
+
+	return __folio_alloc_node(gfp, order, nid);
+}
+
 /*
  * Allocate pages, preferring the node given as nid. When nid == NUMA_NO_NODE,
  * prefer the current CPU's closest node. Otherwise node must be valid and
--- a/mm/slab_common.c~slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios
+++ a/mm/slab_common.c
@@ -979,9 +979,9 @@ void free_large_kmalloc(struct folio *fo
 	kasan_kfree_large(object);
 	kmsan_kfree_large(object);
 
-	mod_lruvec_page_state(folio_page(folio, 0), NR_SLAB_UNRECLAIMABLE_B,
+	lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
 			      -(PAGE_SIZE << order));
-	__free_pages(folio_page(folio, 0), order);
+	folio_put(folio);
 }
 
 static void *__kmalloc_large_node(size_t size, gfp_t flags, int node);
@@ -1137,18 +1137,17 @@ gfp_t kmalloc_fix_flags(gfp_t flags)
 
 static void *__kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct page *page;
+	struct folio *folio;
 	void *ptr = NULL;
 	unsigned int order = get_order(size);
 
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);
 
-	flags |= __GFP_COMP;
-	page = alloc_pages_node(node, flags, order);
-	if (page) {
-		ptr = page_address(page);
-		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+	folio = folio_alloc_node(flags, order, node);
+	if (folio) {
+		ptr = folio_address(folio);
+		lruvec_stat_mod_folio(folio, NR_SLAB_UNRECLAIMABLE_B,
 				      PAGE_SIZE << order);
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
mm-remove-inc-dec-lruvec-page-state-functions.patch
slab-convert-__kmalloc_large_node-and-free_large_kmalloc-to-use-folios.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

