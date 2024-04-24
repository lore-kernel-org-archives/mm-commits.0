Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE57815688B
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 20:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713990988; cv=none; b=GwdkQZ2RlT4hubZsZUdpukh7gHG72Ghr/bFfWS6WNMo58m2p5+WIDR+shouCIIjBMwMheAcBFusq2dSKW/FzABLxfj0uB1k1HQ6KUhL1fuKRlyln3YLvEa0xOxMO5bG8vx9TkqjAPT9zszLYyoMjUZITCHKXd3ystZJZ9ZxaGb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713990988; c=relaxed/simple;
	bh=FBhtqqK+Xbzg1fNMFRjvSTpsYsk6qX9YZwLi3jF+NGE=;
	h=Date:To:From:Subject:Message-Id; b=tJeAXYZeMB7k8jwfFL82H7gH9JyGDNhfbUKealwzQnG5Pfrm9X15w/EC6k15ZwDj0fFZlki6AcDlEs61yGhtP5hc+swOUDycwv9v6b1Re5OBkgrGpv8ioXgQT+gdqx/2HN6qyu5F1pQfKLqVIK/hAZy9eM0G1Eq8frKUXBjl1ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ck5P5ocU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ck5P5ocU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DBFC4AF0A;
	Wed, 24 Apr 2024 20:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713990988;
	bh=FBhtqqK+Xbzg1fNMFRjvSTpsYsk6qX9YZwLi3jF+NGE=;
	h=Date:To:From:Subject:From;
	b=ck5P5ocU1mjaEiRym35UinMVyHStuHmCYCw9nc9hp47IANmI3LeQq3ldJ3IHeeeCN
	 hJ5I2y/4+qxSoGqPyBAE6fY8vjH1bHNWPG8FLqZndh/oPGmkX8nSmkhy5XU2G22lef
	 yjHo5FjiWg6vUxJ+Wa/RDdS2vEFBp/V/YmG8f45k=
Date: Wed, 24 Apr 2024 13:36:27 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + gup-use-folios-for-gup_devmap.patch added to mm-unstable branch
Message-Id: <20240424203628.94DBFC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: gup: use folios for gup_devmap
has been added to the -mm mm-unstable branch.  Its filename is
     gup-use-folios-for-gup_devmap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gup-use-folios-for-gup_devmap.patch

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
Subject: gup: use folios for gup_devmap
Date: Wed, 24 Apr 2024 20:19:10 +0100

Use try_grab_folio() instead of try_grab_page() so we get the folio back
that we calculated, and then use folio_set_referenced() instead of
SetPageReferenced().  Correspondingly, use gup_put_folio() to put any
unneeded references.

Link: https://lkml.kernel.org/r/20240424191914.361554-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/mm/gup.c~gup-use-folios-for-gup_devmap
+++ a/mm/gup.c
@@ -2877,13 +2877,10 @@ static void __maybe_unused gup_fast_undo
 		unsigned int flags, struct page **pages)
 {
 	while ((*nr) - nr_start) {
-		struct page *page = pages[--(*nr)];
+		struct folio *folio = page_folio(pages[--(*nr)]);
 
-		ClearPageReferenced(page);
-		if (flags & FOLL_PIN)
-			unpin_user_page(page);
-		else
-			put_page(page);
+		folio_clear_referenced(folio);
+		gup_put_folio(folio, 1, flags);
 	}
 }
 
@@ -3024,6 +3021,7 @@ static int gup_fast_devmap_leaf(unsigned
 	struct dev_pagemap *pgmap = NULL;
 
 	do {
+		struct folio *folio;
 		struct page *page = pfn_to_page(pfn);
 
 		pgmap = get_dev_pagemap(pfn, pgmap);
@@ -3037,12 +3035,13 @@ static int gup_fast_devmap_leaf(unsigned
 			break;
 		}
 
-		SetPageReferenced(page);
-		pages[*nr] = page;
-		if (unlikely(try_grab_page(page, flags))) {
+		folio = try_grab_folio(page, 1, flags);
+		if (!folio) {
 			gup_fast_undo_dev_pagemap(nr, nr_start, flags, pages);
 			break;
 		}
+		folio_set_referenced(folio);
+		pages[*nr] = page;
 		(*nr)++;
 		pfn++;
 	} while (addr += PAGE_SIZE, addr != end);
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

