Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCD31552E2
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171560; cv=none; b=d5AeYYQtySQBlboSRQ35lWj/L6kg458T2oAIcsvTZB2cYZ0JIhDo9nBGzmUDdFvo47da2DKvAEQbPtrRT1SM7+Ij77EmP4ey9zTiYVnULwbIVqTL10M6t+GB/rIWpWUVlIs9Fqx5vf0LZTDGSq5SHVu0OihpfKZXuTDEA0ksqHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171560; c=relaxed/simple;
	bh=pDZ7aVJJCb6phy0gz8NJzmv9cwRzVRwWq0dlhSVI4r4=;
	h=Date:To:From:Subject:Message-Id; b=G2ELxl8tF8l+nN7CRLjIvUfpO4Yv/y8RnNs+1utiLwo5tClx7pE9GC/pasV05UWAxlPoNLmholk4z0quHBQChbkw9LuHhLcWU+wGoLaRoGk9SNjc8m+CoQox2Pt00T4aHYfbwTkYbL3QIZkeQyO3fNlRyJpxBhlalSpxcjDJG3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pqqiXI7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pqqiXI7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF50C433F1;
	Wed,  3 Apr 2024 19:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171559;
	bh=pDZ7aVJJCb6phy0gz8NJzmv9cwRzVRwWq0dlhSVI4r4=;
	h=Date:To:From:Subject:From;
	b=pqqiXI7g03q5uOPGBi9vSaBYPbfsWyRwf3M1G/DbbhPbNZ7K9urDXcSLj3QynbU6C
	 QbF2uKwbOwtPF34JVrZs4JlgcIgrnZAO5xuXoLKOtmot1cpIK/SSiBCGtG4yLCHozS
	 EM6Ld73LSPIXroAyoqvgeGzeqYj55b6TqQK2QLI4=
Date: Wed, 03 Apr 2024 12:12:38 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-generate-page_idle_flag-definitions.patch added to mm-unstable branch
Message-Id: <20240403191239.ACF50C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: generate PAGE_IDLE_FLAG definitions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-generate-page_idle_flag-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-generate-page_idle_flag-definitions.patch

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
Subject: mm: generate PAGE_IDLE_FLAG definitions
Date: Tue, 2 Apr 2024 21:12:51 +0100

If CONFIG_PAGE_IDLE_FLAG is not set, we can use FOLIO_FLAG_FALSE() to
generate these definitions.

Link: https://lkml.kernel.org/r/20240402201252.917342-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    9 +++++++-
 include/linux/page_idle.h  |   37 +----------------------------------
 2 files changed, 10 insertions(+), 36 deletions(-)

--- a/include/linux/page-flags.h~mm-generate-page_idle_flag-definitions
+++ a/include/linux/page-flags.h
@@ -626,12 +626,19 @@ PAGEFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
-#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
+#ifdef CONFIG_PAGE_IDLE_FLAG
+#ifdef CONFIG_64BIT
 FOLIO_TEST_FLAG(young, FOLIO_HEAD_PAGE)
 FOLIO_SET_FLAG(young, FOLIO_HEAD_PAGE)
 FOLIO_TEST_CLEAR_FLAG(young, FOLIO_HEAD_PAGE)
 FOLIO_FLAG(idle, FOLIO_HEAD_PAGE)
 #endif
+/* See page_idle.h for !64BIT workaround */
+#else /* !CONFIG_PAGE_IDLE_FLAG */
+FOLIO_FLAG_FALSE(young)
+FOLIO_TEST_CLEAR_FLAG_FALSE(young)
+FOLIO_FLAG_FALSE(idle)
+#endif
 
 /*
  * PageReported() is used to track reported free pages within the Buddy
--- a/include/linux/page_idle.h~mm-generate-page_idle_flag-definitions
+++ a/include/linux/page_idle.h
@@ -6,9 +6,7 @@
 #include <linux/page-flags.h>
 #include <linux/page_ext.h>
 
-#ifdef CONFIG_PAGE_IDLE_FLAG
-
-#ifndef CONFIG_64BIT
+#if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 /*
  * If there is not enough space to store Idle and Young bits in page flags, use
  * page ext flags instead.
@@ -87,36 +85,5 @@ static inline void folio_clear_idle(stru
 	clear_bit(PAGE_EXT_IDLE, &page_ext->flags);
 	page_ext_put(page_ext);
 }
-#endif /* !CONFIG_64BIT */
-
-#else /* !CONFIG_PAGE_IDLE_FLAG */
-
-static inline bool folio_test_young(const struct folio *folio)
-{
-	return false;
-}
-
-static inline void folio_set_young(struct folio *folio)
-{
-}
-
-static inline bool folio_test_clear_young(struct folio *folio)
-{
-	return false;
-}
-
-static inline bool folio_test_idle(const struct folio *folio)
-{
-	return false;
-}
-
-static inline void folio_set_idle(struct folio *folio)
-{
-}
-
-static inline void folio_clear_idle(struct folio *folio)
-{
-}
-
-#endif /* CONFIG_PAGE_IDLE_FLAG */
+#endif /* CONFIG_PAGE_IDLE_FLAG && !64BIT */
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

