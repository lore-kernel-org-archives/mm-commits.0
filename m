Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEE21552E2
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171558; cv=none; b=g4HqyqwXEJOgHeCWAsr4gXSeietw8mXo1HtCeqGw+OO+2Lfni0F+phUbNCZC/B5kJrHgTJUAHBWwzdy1M6HSS2YnmPc+GvBAgIA+BBiTAuZJOmiRbw9MPVf4oqGGYN8PXn1HxRwZQ+8XVv3emJOqMKk3qav2yufxorlj4jKL0m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171558; c=relaxed/simple;
	bh=gMdoAiWKb36YTTUxhJ4lq6l/PKkB6221tDJ+Sn9G7KY=;
	h=Date:To:From:Subject:Message-Id; b=Mr5rSy9yTGvyvaT7W8f6eAC+3fFHwhN5qbRaA0lard6sd8zsENyOUu7RNSYypCg1AHTd8XDMSdlcu/4SDv+603E7bMrCgm58zMiz6WYoFQqz3w0NRWoLKQYXTPr02QrfUX9JDSsX/NF6SzVjK5fRM4ZPZOaOVvwlBZm2CHruU24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ild7iFjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ild7iFjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD5FC433C7;
	Wed,  3 Apr 2024 19:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171558;
	bh=gMdoAiWKb36YTTUxhJ4lq6l/PKkB6221tDJ+Sn9G7KY=;
	h=Date:To:From:Subject:From;
	b=ild7iFjdEYcT1tb6kqijtNjOihnsEN75O8iEZmk668wvXqZAXof2ytKFMjDg2Omtw
	 9+fk8Sd98HB6nkQdN5OQO3p5czKGlSGk2D3j1T/EJ1ay+XRJ5D18ZgHJ/8Xm+VljXK
	 HnNjfMr1Vwn6MWWman1Z/NPqWbu1Jf6K/ox42vfg=
Date: Wed, 03 Apr 2024 12:12:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-page_idle-and-page_young-wrappers.patch added to mm-unstable branch
Message-Id: <20240403191238.4CD5FC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove page_idle and page_young wrappers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-page_idle-and-page_young-wrappers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-page_idle-and-page_young-wrappers.patch

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
Subject: mm: remove page_idle and page_young wrappers
Date: Tue, 2 Apr 2024 21:12:50 +0100

All users have now been converted to the folio equivalents, so remove the
page wrappers.

Link: https://lkml.kernel.org/r/20240402201252.917342-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |   25 -------------------------
 1 file changed, 25 deletions(-)

--- a/include/linux/page_idle.h~mm-remove-page_idle-and-page_young-wrappers
+++ a/include/linux/page_idle.h
@@ -119,29 +119,4 @@ static inline void folio_clear_idle(stru
 }
 
 #endif /* CONFIG_PAGE_IDLE_FLAG */
-
-static inline bool page_is_young(struct page *page)
-{
-	return folio_test_young(page_folio(page));
-}
-
-static inline void set_page_young(struct page *page)
-{
-	folio_set_young(page_folio(page));
-}
-
-static inline bool test_and_clear_page_young(struct page *page)
-{
-	return folio_test_clear_young(page_folio(page));
-}
-
-static inline bool page_is_idle(struct page *page)
-{
-	return folio_test_idle(page_folio(page));
-}
-
-static inline void set_page_idle(struct page *page)
-{
-	folio_set_idle(page_folio(page));
-}
 #endif /* _LINUX_MM_PAGE_IDLE_H */
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

