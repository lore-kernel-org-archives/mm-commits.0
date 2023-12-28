Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB52101D4
	for <mm-commits@vger.kernel.org>; Thu, 28 Dec 2023 19:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLd4mABJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70733C433C8;
	Thu, 28 Dec 2023 19:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703790537;
	bh=IgmFrrB6YgCtoAICMgSSwIOM1IR5x2jtZB6nECXCOMk=;
	h=Date:To:From:Subject:From;
	b=DLd4mABJZ8Dm1CL7ZwdVofVWwnG8LKA9fLmM2fSs4iSh2VT5ejvEQNcjgiORNqzNd
	 wPLfCX+bQVqW5i4vaBz8hy0aBD8abIK04eXzV0biolTCiSVNUVrkeB9xpspENKJy4U
	 eu2QklzF6aXLrNP34g3dLb0fxI/A9hXTIiYkHXuk=
Date: Thu, 28 Dec 2023 11:08:56 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + slub-use-a-folio-in-__kmalloc_large_node.patch added to mm-unstable branch
Message-Id: <20231228190857.70733C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: slub: use a folio in __kmalloc_large_node
has been added to the -mm mm-unstable branch.  Its filename is
     slub-use-a-folio-in-__kmalloc_large_node.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slub-use-a-folio-in-__kmalloc_large_node.patch

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
Subject: slub: use a folio in __kmalloc_large_node
Date: Thu, 28 Dec 2023 08:57:46 +0000

Mirror the code in free_large_kmalloc() and alloc_pages_node() and use a
folio directly.  Avoid the use of folio_alloc() as that will set up an
rmappable folio which we do not want here.

Link: https://lkml.kernel.org/r/20231228085748.1083901-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/slab_common.c~slub-use-a-folio-in-__kmalloc_large_node
+++ a/mm/slab_common.c
@@ -1137,7 +1137,7 @@ gfp_t kmalloc_fix_flags(gfp_t flags)
 
 static void *__kmalloc_large_node(size_t size, gfp_t flags, int node)
 {
-	struct page *page;
+	struct folio *folio;
 	void *ptr = NULL;
 	unsigned int order = get_order(size);
 
@@ -1145,10 +1145,10 @@ static void *__kmalloc_large_node(size_t
 		flags = kmalloc_fix_flags(flags);
 
 	flags |= __GFP_COMP;
-	page = alloc_pages_node(node, flags, order);
-	if (page) {
-		ptr = page_address(page);
-		mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B,
+	folio = (struct folio *)alloc_pages_node(node, flags, order);
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
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

