Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFBA172BA4
	for <mm-commits@vger.kernel.org>; Fri,  5 Apr 2024 18:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712342475; cv=none; b=fWNrqoaP2vWK3xesUL/2f7XGdgLS6CSLEX74PFMWBq29/gsbwR0oSN6DIKOPX3RtjiGdp7nqAm7/WLhAxMhJy59kUMi+W2NVHkl4AmTB/r9Y3CqB1+H7ljGf/973lLpiv7GOYkKXK+M+6eSwApHs1Z9h6VCd8Vs4XvEbaMe0mf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712342475; c=relaxed/simple;
	bh=M55RVBJwWhsXkSbQmNWl8oK2LtDlK5aNAcSBeSsxnck=;
	h=Date:To:From:Subject:Message-Id; b=NUKczUVe1taHxpiwgekNMQkUpG9rESotFDJGXlGIndFTuLRyMAlCcqOuPX/NIDlhbTDNr3UjqYzl4q5VjwRQeiiX9/p6yeAVMSRi1yX4/zFEphRBxqTR+pF0T8muee/1TqGII4NrG/tyc2psl52igGcPAzLm7C7RV9d4f7BbBSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yVVTLSaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yVVTLSaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94243C433F1;
	Fri,  5 Apr 2024 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712342474;
	bh=M55RVBJwWhsXkSbQmNWl8oK2LtDlK5aNAcSBeSsxnck=;
	h=Date:To:From:Subject:From;
	b=yVVTLSaQBwO5oz5d906t3g0dsdpkLZmWRDhB3TiB2nOlmtoDtGNWC/O3fV/oD9bQi
	 EUiR8ij2erwiPu426Nk6SpmBzbI47GYYnWQPWuwkLku6gTa87aBm1RdjOhdhsxrQNW
	 ikAk7rWvhdzRIsHGAzc9HsE6B2bN1kCrXmGZoIDU=
Date: Fri, 05 Apr 2024 11:41:14 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-pagecache_isize_extended-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240405184114.94243C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert pagecache_isize_extended to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-pagecache_isize_extended-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-pagecache_isize_extended-to-use-a-folio.patch

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
Subject: mm: convert pagecache_isize_extended to use a folio
Date: Fri, 5 Apr 2024 19:00:36 +0100

Remove four hidden calls to compound_head().  Also exit early if the
filesystem block size is >= PAGE_SIZE instead of just equal to PAGE_SIZE.

Link: https://lkml.kernel.org/r/20240405180038.2618624-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |   36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

--- a/mm/truncate.c~mm-convert-pagecache_isize_extended-to-use-a-folio
+++ a/mm/truncate.c
@@ -764,15 +764,15 @@ EXPORT_SYMBOL(truncate_setsize);
  * @from:	original inode size
  * @to:		new inode size
  *
- * Handle extension of inode size either caused by extending truncate or by
- * write starting after current i_size. We mark the page straddling current
- * i_size RO so that page_mkwrite() is called on the nearest write access to
- * the page.  This way filesystem can be sure that page_mkwrite() is called on
- * the page before user writes to the page via mmap after the i_size has been
- * changed.
+ * Handle extension of inode size either caused by extending truncate or
+ * by write starting after current i_size.  We mark the page straddling
+ * current i_size RO so that page_mkwrite() is called on the first
+ * write access to the page.  The filesystem will update its per-block
+ * information before user writes to the page via mmap after the i_size
+ * has been changed.
  *
  * The function must be called after i_size is updated so that page fault
- * coming after we unlock the page will already see the new i_size.
+ * coming after we unlock the folio will already see the new i_size.
  * The function must be called while we still hold i_rwsem - this not only
  * makes sure i_size is stable but also that userspace cannot observe new
  * i_size value before we are prepared to store mmap writes at new inode size.
@@ -781,31 +781,29 @@ void pagecache_isize_extended(struct ino
 {
 	int bsize = i_blocksize(inode);
 	loff_t rounded_from;
-	struct page *page;
-	pgoff_t index;
+	struct folio *folio;
 
 	WARN_ON(to > inode->i_size);
 
-	if (from >= to || bsize == PAGE_SIZE)
+	if (from >= to || bsize >= PAGE_SIZE)
 		return;
 	/* Page straddling @from will not have any hole block created? */
 	rounded_from = round_up(from, bsize);
 	if (to <= rounded_from || !(rounded_from & (PAGE_SIZE - 1)))
 		return;
 
-	index = from >> PAGE_SHIFT;
-	page = find_lock_page(inode->i_mapping, index);
-	/* Page not cached? Nothing to do */
-	if (!page)
+	folio = filemap_lock_folio(inode->i_mapping, from / PAGE_SIZE);
+	/* Folio not cached? Nothing to do */
+	if (IS_ERR(folio))
 		return;
 	/*
-	 * See clear_page_dirty_for_io() for details why set_page_dirty()
+	 * See folio_clear_dirty_for_io() for details why folio_mark_dirty()
 	 * is needed.
 	 */
-	if (page_mkclean(page))
-		set_page_dirty(page);
-	unlock_page(page);
-	put_page(page);
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+	folio_unlock(folio);
+	folio_put(folio);
 }
 EXPORT_SYMBOL(pagecache_isize_extended);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
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

