Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C998134D8
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r1KcV1TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6933CC433C7;
	Fri, 29 Dec 2023 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880017;
	bh=Kjd2++bRkvHZiv6rps1BBtp1e0udQDmZZ70zW01eBmA=;
	h=Date:To:From:Subject:From;
	b=r1KcV1TMv4MO6xNrXV/zb5/dQVMAJIMfWlrMdEjO0uazmAX7aphX86ELz+5m+qR8z
	 RuT/2yTfDWst0xXdrZYb56Bshk+IEa6PbYCpn3/PE1bT9k9MObWMvrQt8IB7QDpYHB
	 yRi/1RlzT+DU51FlaQr1RqaJLlWwhOi/qgzGQrB4=
Date: Fri, 29 Dec 2023 12:00:16 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch removed from -mm tree
Message-Id: <20231229200017.6933CC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert swap_cluster_readahead and swap_vma_readahead to return a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert swap_cluster_readahead and swap_vma_readahead to return a folio
Date: Wed, 13 Dec 2023 21:58:42 +0000

shmem_swapin_cluster() immediately converts the page back to a folio, and
swapin_readahead() may as well call folio_file_page() once instead of
having each function call it.

[willy@infradead.org: avoid NULL pointer deref]
  Link: https://lkml.kernel.org/r/ZYI7OcVlM1voKfBl@casper.infradead.org
Link: https://lkml.kernel.org/r/20231213215842.671461-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c      |    8 +++-----
 mm/swap.h       |    6 +++---
 mm/swap_state.c |   24 +++++++++++++-----------
 3 files changed, 19 insertions(+), 19 deletions(-)

--- a/mm/shmem.c~mm-convert-swap_cluster_readahead-and-swap_vma_readahead-to-return-a-folio
+++ a/mm/shmem.c
@@ -1570,15 +1570,13 @@ static struct folio *shmem_swapin_cluste
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
@@ -879,14 +878,17 @@ struct page *swapin_readahead(swp_entry_
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
+
+	if (!folio)
+		return NULL;
+	return folio_file_page(folio, swp_offset(entry));
 }
 
 #ifdef CONFIG_SYSFS
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

