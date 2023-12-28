Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6F4101C6
	for <mm-commits@vger.kernel.org>; Thu, 28 Dec 2023 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i9384YZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EAAC433C8;
	Thu, 28 Dec 2023 19:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703790538;
	bh=BwiDBUJhnAlrC1SbXvTETEccJt6BtNRsSBzNB5h83aI=;
	h=Date:To:From:Subject:From;
	b=i9384YZQd1z/UVOtKuVRaJaARfdPA+81NlEjMfK1vyZO+STi0Ll9VsY4cmNOI1Hy9
	 5N4Pn25O+hk3tEL6kMRU1lm9wBN8t64v2tqvDiQXX4Uo/2nJL6kClNW+YBlG43gCG5
	 27BlQAjJVZrJZWRS0f9pdF1I60UtGwufCqqiRJ74=
Date: Thu, 28 Dec 2023 11:08:58 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,hannes@cmpxchg.org,42.hyeyoo@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-use-a-folio-more-in-collapse_file.patch added to mm-unstable branch
Message-Id: <20231228190858.A2EAAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: use a folio more in collapse_file()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-use-a-folio-more-in-collapse_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-use-a-folio-more-in-collapse_file.patch

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
Subject: mm/khugepaged: use a folio more in collapse_file()
Date: Thu, 28 Dec 2023 08:57:47 +0000

This function is not yet fully converted to the folio API, but this
removes a few uses of old APIs.

Link: https://lkml.kernel.org/r/20231228085748.1083901-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-a-folio-more-in-collapse_file
+++ a/mm/khugepaged.c
@@ -2122,23 +2122,23 @@ immap_locked:
 		xas_lock_irq(&xas);
 	}
 
-	nr = thp_nr_pages(hpage);
+	folio = page_folio(hpage);
+	nr = folio_nr_pages(folio);
 	if (is_shmem)
-		__mod_lruvec_page_state(hpage, NR_SHMEM_THPS, nr);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
 	else
-		__mod_lruvec_page_state(hpage, NR_FILE_THPS, nr);
+		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, nr);
 
 	if (nr_none) {
-		__mod_lruvec_page_state(hpage, NR_FILE_PAGES, nr_none);
+		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr_none);
 		/* nr_none is always 0 for non-shmem. */
-		__mod_lruvec_page_state(hpage, NR_SHMEM, nr_none);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr_none);
 	}
 
 	/*
 	 * Mark hpage as uptodate before inserting it into the page cache so
 	 * that it isn't mistaken for an fallocated but unwritten page.
 	 */
-	folio = page_folio(hpage);
 	folio_mark_uptodate(folio);
 	folio_ref_add(folio, HPAGE_PMD_NR - 1);
 
@@ -2148,7 +2148,7 @@ immap_locked:
 
 	/* Join all the small entries into a single multi-index entry. */
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
-	xas_store(&xas, hpage);
+	xas_store(&xas, folio);
 	WARN_ON_ONCE(xas_error(&xas));
 	xas_unlock_irq(&xas);
 
@@ -2159,7 +2159,7 @@ immap_locked:
 	retract_page_tables(mapping, start);
 	if (cc && !cc->is_khugepaged)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
-	unlock_page(hpage);
+	folio_unlock(folio);
 
 	/*
 	 * The collapse has succeeded, so free the old pages.
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

