Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E6D156C41
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 20:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713990985; cv=none; b=AA+Ih4QU95gOs1lnsZADWpV+5u08PZ8Hig3IzAs4ouHGyRgYqaB63TWr6dMAnDRoTHoUvTO9VipUrdItmquggI00roO8Yl+niTW+OhrOWfKY2AiGc/B9cRaMsZTLCvzMaJA1AZlbb3SPj4ECrkoScpzpX9ylDf6aYv8XDbT3fo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713990985; c=relaxed/simple;
	bh=ojvtbXpOEnDK976TVHgFHtFF0J79Xscgb0HrCchisLE=;
	h=Date:To:From:Subject:Message-Id; b=PA95sjPuq06S3TsjO85lciI+DLGybtJlnb11Uq683HIEW9SM0YumhJN4lW6tYWb5+wegW9V+XIeQCCFGCozqFPl5k+gbSllwl+jHxXG1vzSfF68+tiIIzrt0tTJ/XzjhTul4h+oQIdPD0ujA5rM7pm6EOxXJNLQcqghc1BX5xEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IXsrL9kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IXsrL9kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE29C3277B;
	Wed, 24 Apr 2024 20:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713990984;
	bh=ojvtbXpOEnDK976TVHgFHtFF0J79Xscgb0HrCchisLE=;
	h=Date:To:From:Subject:From;
	b=IXsrL9kgW74IzNbVs09Yr/XLcw0wL22n1hQFUxarjDztfX7b/cesSqgSJfI138+DI
	 Nf2kQY40lgauBhgSEHN6Yvz3+KB4CQ8KSXqge357l0hxuZ634zczmlVaejnSWsc+vr
	 q4sCxS2dq+3ocHfjb8ykTb70tBzM8xtaF2zfEwpc=
Date: Wed, 24 Apr 2024 13:36:24 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch added to mm-unstable branch
Message-Id: <20240424203624.CCE29C3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert put_devmap_managed_page_refs() to put_devmap_managed_folio_refs()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch

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
Subject: mm: convert put_devmap_managed_page_refs() to put_devmap_managed_folio_refs()
Date: Wed, 24 Apr 2024 20:19:08 +0100

All callers have a folio so we can remove this use of
page_ref_sub_return().

Link: https://lkml.kernel.org/r/20240424191914.361554-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   12 ++++++------
 mm/gup.c           |    6 +++---
 mm/memremap.c      |   10 +++++-----
 mm/swap.c          |    2 +-
 4 files changed, 15 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/include/linux/mm.h
@@ -1437,17 +1437,17 @@ vm_fault_t finish_fault(struct vm_fault
 #if defined(CONFIG_ZONE_DEVICE) && defined(CONFIG_FS_DAX)
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
 
-bool __put_devmap_managed_page_refs(struct page *page, int refs);
-static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
+bool __put_devmap_managed_folio_refs(struct folio *folio, int refs);
+static inline bool put_devmap_managed_folio_refs(struct folio *folio, int refs)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
-	if (!is_zone_device_page(page))
+	if (!folio_is_zone_device(folio))
 		return false;
-	return __put_devmap_managed_page_refs(page, refs);
+	return __put_devmap_managed_folio_refs(folio, refs);
 }
 #else /* CONFIG_ZONE_DEVICE && CONFIG_FS_DAX */
-static inline bool put_devmap_managed_page_refs(struct page *page, int refs)
+static inline bool put_devmap_managed_folio_refs(struct folio *folio, int refs)
 {
 	return false;
 }
@@ -1571,7 +1571,7 @@ static inline void put_page(struct page
 	 * For some devmap managed pages we need to catch refcount transition
 	 * from 2 to 1:
 	 */
-	if (put_devmap_managed_page_refs(&folio->page, 1))
+	if (put_devmap_managed_folio_refs(folio, 1))
 		return;
 	folio_put(folio);
 }
--- a/mm/gup.c~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/mm/gup.c
@@ -89,7 +89,7 @@ retry:
 	 * belongs to this folio.
 	 */
 	if (unlikely(page_folio(page) != folio)) {
-		if (!put_devmap_managed_page_refs(&folio->page, refs))
+		if (!put_devmap_managed_folio_refs(folio, refs))
 			folio_put_refs(folio, refs);
 		goto retry;
 	}
@@ -156,7 +156,7 @@ struct folio *try_grab_folio(struct page
 	 */
 	if (unlikely((flags & FOLL_LONGTERM) &&
 		     !folio_is_longterm_pinnable(folio))) {
-		if (!put_devmap_managed_page_refs(&folio->page, refs))
+		if (!put_devmap_managed_folio_refs(folio, refs))
 			folio_put_refs(folio, refs);
 		return NULL;
 	}
@@ -198,7 +198,7 @@ static void gup_put_folio(struct folio *
 			refs *= GUP_PIN_COUNTING_BIAS;
 	}
 
-	if (!put_devmap_managed_page_refs(&folio->page, refs))
+	if (!put_devmap_managed_folio_refs(folio, refs))
 		folio_put_refs(folio, refs);
 }
 
--- a/mm/memremap.c~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/mm/memremap.c
@@ -512,9 +512,9 @@ void zone_device_page_init(struct page *
 EXPORT_SYMBOL_GPL(zone_device_page_init);
 
 #ifdef CONFIG_FS_DAX
-bool __put_devmap_managed_page_refs(struct page *page, int refs)
+bool __put_devmap_managed_folio_refs(struct folio *folio, int refs)
 {
-	if (page->pgmap->type != MEMORY_DEVICE_FS_DAX)
+	if (folio->page.pgmap->type != MEMORY_DEVICE_FS_DAX)
 		return false;
 
 	/*
@@ -522,9 +522,9 @@ bool __put_devmap_managed_page_refs(stru
 	 * refcount is 1, then the page is free and the refcount is
 	 * stable because nobody holds a reference on the page.
 	 */
-	if (page_ref_sub_return(page, refs) == 1)
-		wake_up_var(&page->_refcount);
+	if (folio_ref_sub_return(folio, refs) == 1)
+		wake_up_var(&folio->_refcount);
 	return true;
 }
-EXPORT_SYMBOL(__put_devmap_managed_page_refs);
+EXPORT_SYMBOL(__put_devmap_managed_folio_refs);
 #endif /* CONFIG_FS_DAX */
--- a/mm/swap.c~mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs
+++ a/mm/swap.c
@@ -981,7 +981,7 @@ void folios_put_refs(struct folio_batch
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			if (put_devmap_managed_page_refs(&folio->page, nr_refs))
+			if (put_devmap_managed_folio_refs(folio, nr_refs))
 				continue;
 			if (folio_ref_sub_and_test(folio, nr_refs))
 				free_zone_device_folio(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-always-initialise-folio-_deferred_list.patch
mm-remove-folio_prep_large_rmappable.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
proc-rewrite-stable_page_flags-fix-2.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file-fix.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch
doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch

