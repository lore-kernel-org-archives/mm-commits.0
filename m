Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E4717C9
	for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2024 00:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714006202; cv=none; b=B+paFyYO0yde2IQW1j1Z+Sv4dUl6S0XMpyk33vUYGVDQ52N3fPt2j81cs6Tl+qF7M8/iD6ycMcs7siRx4aeG+zkkmyfApqb3Io5b8TAI6YVDxFdB38ycsFa0k1hGEd/NZJ2Zbnv8b3MjpHZQP9LV8GK+P9nWjPdI+p5XO2u7VVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714006202; c=relaxed/simple;
	bh=xTVhkyLp7Rh5HLGf2eNE+iltg/tTaXfPsz2noM7JHJ4=;
	h=Date:To:From:Subject:Message-Id; b=d5FH9JN4MyW/KpVt81QC3h7CU/z7M2X+2o+CcUSzrRMitRC71S5+OYPt72lkdvAcUzVc3/SsymGDt16Z7vR01H+qJFxIwMiJggTidvYiD5n4SE9XQ/m+tMvTO3fAIT8XQ1OpzS0cpCeShQzPoPiqppY3X8dAT7Rn495+lIXM4l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yTE0fkfS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yTE0fkfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A07FC113CE;
	Thu, 25 Apr 2024 00:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714006202;
	bh=xTVhkyLp7Rh5HLGf2eNE+iltg/tTaXfPsz2noM7JHJ4=;
	h=Date:To:From:Subject:From;
	b=yTE0fkfSopmpMicQTiXFTvodzjB759wsGnNDqrHIiUKBdrFNUTMFmwd4Pxe8Sdavv
	 mlimhfaxqoN2lOTORyYaQuEYYc5Qr0+IBbvH/yawmJG1mFpKDqTRD3ZcLxaXK5L0AF
	 C3ymMjws9+HzvhBR3qVdvLiZvSFiU5KdleRFfbEQ=
Date: Wed, 24 Apr 2024 17:50:01 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-memory_failure-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240425005002.7A07FC113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory-failure: convert memory_failure() to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-memory_failure-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-memory_failure-to-use-a-folio.patch

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
Subject: mm/memory-failure: convert memory_failure() to use a folio
Date: Fri, 12 Apr 2024 20:35:04 +0100

Saves dozens of calls to compound_head().

Link: https://lkml.kernel.org/r/20240412193510.2356957-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-convert-memory_failure-to-use-a-folio
+++ a/mm/memory-failure.c
@@ -2189,7 +2189,7 @@ out:
 int memory_failure(unsigned long pfn, int flags)
 {
 	struct page *p;
-	struct page *hpage;
+	struct folio *folio;
 	struct dev_pagemap *pgmap;
 	int res = 0;
 	unsigned long page_flags;
@@ -2277,8 +2277,8 @@ try_again:
 		}
 	}
 
-	hpage = compound_head(p);
-	if (PageTransHuge(hpage)) {
+	folio = page_folio(p);
+	if (folio_test_large(folio)) {
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2292,12 +2292,13 @@ try_again:
 		 * or unhandlable page.  The refcount is bumped iff the
 		 * page is a valid handlable page.
 		 */
-		SetPageHasHWPoisoned(hpage);
+		folio_set_has_hwpoisoned(folio);
 		if (try_to_split_thp_page(p) < 0) {
 			res = action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
+		folio = page_folio(p);
 	}
 
 	/*
@@ -2308,9 +2309,9 @@ try_again:
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	shake_page(p);
+	shake_folio(folio);
 
-	lock_page(p);
+	folio_lock(folio);
 
 	/*
 	 * We're only intended to deal with the non-Compound page here.
@@ -2318,11 +2319,11 @@ try_again:
 	 * race window. If this happens, we could try again to hopefully
 	 * handle the page next round.
 	 */
-	if (PageCompound(p)) {
+	if (folio_test_large(folio)) {
 		if (retry) {
 			ClearPageHWPoison(p);
-			unlock_page(p);
-			put_page(p);
+			folio_unlock(folio);
+			folio_put(folio);
 			flags &= ~MF_COUNT_INCREASED;
 			retry = false;
 			goto try_again;
@@ -2338,29 +2339,29 @@ try_again:
 	 * folio_remove_rmap_*() in try_to_unmap_one(). So to determine page
 	 * status correctly, we save a copy of the page flags at this time.
 	 */
-	page_flags = p->flags;
+	page_flags = folio->flags;
 
 	if (hwpoison_filter(p)) {
 		ClearPageHWPoison(p);
-		unlock_page(p);
-		put_page(p);
+		folio_unlock(folio);
+		folio_put(folio);
 		res = -EOPNOTSUPP;
 		goto unlock_mutex;
 	}
 
 	/*
-	 * __munlock_folio() may clear a writeback page's LRU flag without
-	 * page_lock. We need wait writeback completion for this page or it
-	 * may trigger vfs BUG while evict inode.
+	 * __munlock_folio() may clear a writeback folio's LRU flag without
+	 * the folio lock. We need to wait for writeback completion for this
+	 * folio or it may trigger a vfs BUG while evicting inode.
 	 */
-	if (!PageLRU(p) && !PageWriteback(p))
+	if (!folio_test_lru(folio) && !folio_test_writeback(folio))
 		goto identify_page_state;
 
 	/*
 	 * It's very difficult to mess with pages currently under IO
 	 * and in many cases impossible, so we just avoid it here.
 	 */
-	wait_on_page_writeback(p);
+	folio_wait_writeback(folio);
 
 	/*
 	 * Now take care of user space mappings.
@@ -2374,7 +2375,8 @@ try_again:
 	/*
 	 * Torn down by someone else?
 	 */
-	if (PageLRU(p) && !PageSwapCache(p) && p->mapping == NULL) {
+	if (folio_test_lru(folio) && !folio_test_swapcache(folio) &&
+	    folio->mapping == NULL) {
 		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
 		goto unlock_page;
 	}
@@ -2384,7 +2386,7 @@ identify_page_state:
 	mutex_unlock(&mf_mutex);
 	return res;
 unlock_page:
-	unlock_page(p);
+	folio_unlock(folio);
 unlock_mutex:
 	mutex_unlock(&mf_mutex);
 	return res;
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
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch

