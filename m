Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8524A8183A
	for <mm-commits@vger.kernel.org>; Wed, 13 Dec 2023 23:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cH4COznD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D399C433C7;
	Wed, 13 Dec 2023 23:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702509139;
	bh=Xo3DkkBxLiGsU/7oUCPQaE0DOQVTzOIsu37LgZTbUXM=;
	h=Date:To:From:Subject:From;
	b=cH4COznD7xi0z0xGmJemZ1tzWLaBdZMs4mLarhbdLEo/d3zONiaSMsez8knQfy24l
	 Se6Kr2DzgPQ0MtNCcnoRwuUDZvRUPySVvN1FWOfmw5bvm5qpsiGl0WxufQufkMJkpI
	 kFA5y/UT0peUtMMh0hDwK9t4F48FsOzZ3mEZnyBw=
Date: Wed, 13 Dec 2023 15:12:18 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch added to mm-unstable branch
Message-Id: <20231213231219.4D399C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert swap_cluster_readahead and swap_vma_readahead to return a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch

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
Subject: mm: convert swap_cluster_readahead and swap_vma_readahead to return a folio
Date: Wed, 13 Dec 2023 21:58:42 +0000

shmem_swapin_cluster() immediately converts the page back to a folio, and
swapin_readahead() may as well call folio_file_page() once instead of
having each function call it.

Link: https://lkml.kernel.org/r/20231213215842.671461-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c      |    8 +++-----
 mm/swap.h       |    6 +++---
 mm/swap_state.c |   21 ++++++++++-----------
 3 files changed, 16 insertions(+), 19 deletions(-)

--- a/mm/shmem.c~mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio
+++ a/mm/shmem.c
@@ -1569,15 +1569,13 @@ static struct folio *shmem_swapin_cluste
 {
 	struct mempolicy *mpol;
 	pgoff_t ilx;
-	struct page *page;
+	struct folio *folio;
 
 	mpol = shmem_get_pgoff_policy(info, index, 0, &ilx);
-	page = swap_cluster_readahead(swap, gfp, mpol, ilx);
+	folio = swap_cluster_readahead(swap, gfp, mpol, ilx);
 	mpol_cond_put(mpol);
 
-	if (!page)
-		return NULL;
-	return page_folio(page);
+	return folio;
 }
 
 /*
--- a/mm/swap.h~mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio
+++ a/mm/swap.h
@@ -52,8 +52,8 @@ struct folio *read_swap_cache_async(swp_
 struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_flags,
 		struct mempolicy *mpol, pgoff_t ilx, bool *new_page_allocated,
 		bool skip_if_exists);
-struct page *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
-				    struct mempolicy *mpol, pgoff_t ilx);
+struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
+		struct mempolicy *mpol, pgoff_t ilx);
 struct page *swapin_readahead(swp_entry_t entry, gfp_t flag,
 			      struct vm_fault *vmf);
 
@@ -80,7 +80,7 @@ static inline void show_swap_cache_info(
 {
 }
 
-static inline struct page *swap_cluster_readahead(swp_entry_t entry,
+static inline struct folio *swap_cluster_readahead(swp_entry_t entry,
 			gfp_t gfp_mask, struct mempolicy *mpol, pgoff_t ilx)
 {
 	return NULL;
--- a/mm/swap_state.c~mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio
+++ a/mm/swap_state.c
@@ -620,7 +620,7 @@ static unsigned long swapin_nr_pages(uns
  * @mpol: NUMA memory allocation policy to be applied
  * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  *
- * Returns the struct page for entry and addr, after queueing swapin.
+ * Returns the struct folio for entry and addr, after queueing swapin.
  *
  * Primitive swap readahead code. We simply read an aligned block of
  * (1 << page_cluster) entries in the swap area. This method is chosen
@@ -631,7 +631,7 @@ static unsigned long swapin_nr_pages(uns
  * are used for every page of the readahead: neighbouring pages on swap
  * are fairly likely to have been swapped out from the same node.
  */
-struct page *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
+struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 				    struct mempolicy *mpol, pgoff_t ilx)
 {
 	struct folio *folio;
@@ -683,7 +683,7 @@ skip:
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, false, NULL);
 	zswap_folio_swapin(folio);
-	return folio_file_page(folio, swp_offset(entry));
+	return folio;
 }
 
 int init_swap_address_space(unsigned int type, unsigned long nr_pages)
@@ -787,7 +787,7 @@ static void swap_ra_info(struct vm_fault
  * @targ_ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
  * @vmf: fault information
  *
- * Returns the struct page for entry and addr, after queueing swapin.
+ * Returns the struct folio for entry and addr, after queueing swapin.
  *
  * Primitive swap readahead code. We simply read in a few pages whose
  * virtual addresses are around the fault address in the same vma.
@@ -795,9 +795,8 @@ static void swap_ra_info(struct vm_fault
  * Caller must hold read mmap_lock if vmf->vma is not NULL.
  *
  */
-static struct page *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
-				       struct mempolicy *mpol, pgoff_t targ_ilx,
-				       struct vm_fault *vmf)
+static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
+		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
 {
 	struct blk_plug plug;
 	struct swap_iocb *splug = NULL;
@@ -859,7 +858,7 @@ skip:
 	if (unlikely(page_allocated))
 		swap_read_folio(folio, false, NULL);
 	zswap_folio_swapin(folio);
-	return folio_file_page(folio, swp_offset(entry));
+	return folio;
 }
 
 /**
@@ -879,14 +878,14 @@ struct page *swapin_readahead(swp_entry_
 {
 	struct mempolicy *mpol;
 	pgoff_t ilx;
-	struct page *page;
+	struct folio *folio;
 
 	mpol = get_vma_policy(vmf->vma, vmf->address, 0, &ilx);
-	page = swap_use_vma_readahead() ?
+	folio = swap_use_vma_readahead() ?
 		swap_vma_readahead(entry, gfp_mask, mpol, ilx, vmf) :
 		swap_cluster_readahead(entry, gfp_mask, mpol, ilx);
 	mpol_cond_put(mpol);
-	return page;
+	return folio_file_page(folio, swp_offset(entry));
 }
 
 #ifdef CONFIG_SYSFS
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

