Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B713D60A
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711485997; cv=none; b=ea8sh35LqCBNG3qx4VSMcDD4MpKN0wluWKa8Ti++Q3SXZMakL8UCAjkGNzpKt5JmaA15btIanbji4WYCScBnKx0h7wZiooTGTEaBsE/24YP1X+ly0W0yPpueQDFILPzouA4Vz/F2mhIu/FqmrmrG5Qi5wxPFpSJbg9f1FR8KLaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711485997; c=relaxed/simple;
	bh=QcOTvyu2ukMLJSR5X4geZHYc7g2+BtLeIym6KKlDTtU=;
	h=Date:To:From:Subject:Message-Id; b=R2DUa3D6ujMveqJGld9DcpomnQpP6hwd1bF4hQUpmqa/daBq1MFssF6P7O2+tCxV2g0/Aa84ZRwP4JAinaUr4sdhK4Hgm/yr6Hlo7yYcNe3Lhib6/5JbxGBQ9WYhynLXVQhYWm8jEDypMV+C53QioowzmDS1BCi5ZvBj8/mHmVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b2B+evFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b2B+evFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D22C433C7;
	Tue, 26 Mar 2024 20:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711485996;
	bh=QcOTvyu2ukMLJSR5X4geZHYc7g2+BtLeIym6KKlDTtU=;
	h=Date:To:From:Subject:From;
	b=b2B+evFFSMRFHUCk8eFHqfR1DymKHVDNlaRjCabrKD1tmqV47UbOrgyWq5SSuFZ2F
	 Ph8WGJCrhZVjOcqP+d9jgZG1zML3uS468YRB6WUOvx1pAisELqFlmP4Obw54jFSCTI
	 xvAjcgB/lcHJL/9EUfL/EMbaymqcSc5Vn/YeJepY=
Date: Tue, 26 Mar 2024 13:46:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-is_huge_zero_folio.patch added to mm-unstable branch
Message-Id: <20240326204636.B4D22C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add is_huge_zero_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-is_huge_zero_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-is_huge_zero_folio.patch

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
Subject: mm: add is_huge_zero_folio()
Date: Tue, 26 Mar 2024 20:28:22 +0000

This is the folio equivalent of is_huge_zero_page().  It doesn't add any
efficiency, but it does prevent the caller from passing a tail page and
getting confused when the predicate returns false.

Link: https://lkml.kernel.org/r/20240326202833.523759-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c          |    2 +-
 include/linux/huge_mm.h |   10 ++++++++++
 mm/huge_memory.c        |    6 +++---
 mm/mempolicy.c          |    2 +-
 mm/swap.c               |    2 +-
 mm/swap_state.c         |    2 +-
 mm/userfaultfd.c        |    2 +-
 7 files changed, 18 insertions(+), 8 deletions(-)

--- a/fs/proc/page.c~mm-add-is_huge_zero_folio
+++ a/fs/proc/page.c
@@ -155,7 +155,7 @@ u64 stable_page_flags(const struct page
 	else if (folio_test_large(folio)) {
 		if ((k & PG_lru) || is_anon)
 			u |= 1 << KPF_THP;
-		else if (is_huge_zero_page(&folio->page)) {
+		else if (is_huge_zero_folio(folio)) {
 			u |= 1 << KPF_ZERO_PAGE;
 			u |= 1 << KPF_THP;
 		}
--- a/include/linux/huge_mm.h~mm-add-is_huge_zero_folio
+++ a/include/linux/huge_mm.h
@@ -356,6 +356,11 @@ static inline bool is_huge_zero_page(con
 	return READ_ONCE(huge_zero_page) == page;
 }
 
+static inline bool is_huge_zero_folio(const struct folio *folio)
+{
+	return READ_ONCE(huge_zero_page) == &folio->page;
+}
+
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
 	return pmd_present(pmd) && READ_ONCE(huge_zero_pfn) == pmd_pfn(pmd);
@@ -484,6 +489,11 @@ static inline bool is_huge_zero_page(con
 {
 	return false;
 }
+
+static inline bool is_huge_zero_folio(const struct folio *folio)
+{
+	return false;
+}
 
 static inline bool is_huge_zero_pmd(pmd_t pmd)
 {
--- a/mm/huge_memory.c~mm-add-is_huge_zero_folio
+++ a/mm/huge_memory.c
@@ -789,12 +789,12 @@ struct deferred_split *get_deferred_spli
 }
 #endif
 
-static inline bool is_transparent_hugepage(struct folio *folio)
+static inline bool is_transparent_hugepage(const struct folio *folio)
 {
 	if (!folio_test_large(folio))
 		return false;
 
-	return is_huge_zero_page(&folio->page) ||
+	return is_huge_zero_folio(folio) ||
 		folio_test_large_rmappable(folio);
 }
 
@@ -3085,7 +3085,7 @@ int split_huge_page_to_list_to_order(str
 	}
 
 
-	is_hzp = is_huge_zero_page(&folio->page);
+	is_hzp = is_huge_zero_folio(folio);
 	if (is_hzp) {
 		pr_warn_ratelimited("Called split_huge_page for huge zero page\n");
 		return -EBUSY;
--- a/mm/mempolicy.c~mm-add-is_huge_zero_folio
+++ a/mm/mempolicy.c
@@ -510,7 +510,7 @@ static void queue_folios_pmd(pmd_t *pmd,
 		return;
 	}
 	folio = pfn_folio(pmd_pfn(*pmd));
-	if (is_huge_zero_page(&folio->page)) {
+	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
 	}
--- a/mm/swap.c~mm-add-is_huge_zero_folio
+++ a/mm/swap.c
@@ -985,7 +985,7 @@ void folios_put_refs(struct folio_batch
 		struct folio *folio = folios->folios[i];
 		unsigned int nr_refs = refs ? refs[i] : 1;
 
-		if (is_huge_zero_page(&folio->page))
+		if (is_huge_zero_folio(folio))
 			continue;
 
 		if (folio_is_zone_device(folio)) {
--- a/mm/swap_state.c~mm-add-is_huge_zero_folio
+++ a/mm/swap_state.c
@@ -301,7 +301,7 @@ void free_page_and_swap_cache(struct pag
 	struct folio *folio = page_folio(page);
 
 	free_swap_cache(folio);
-	if (!is_huge_zero_page(page))
+	if (!is_huge_zero_folio(folio))
 		folio_put(folio);
 }
 
--- a/mm/userfaultfd.c~mm-add-is_huge_zero_folio
+++ a/mm/userfaultfd.c
@@ -1699,7 +1699,7 @@ ssize_t move_pages(struct userfaultfd_ct
 			    !pmd_none(dst_pmdval)) {
 				struct folio *folio = pfn_folio(pmd_pfn(*src_pmd));
 
-				if (!folio || (!is_huge_zero_page(&folio->page) &&
+				if (!folio || (!is_huge_zero_folio(folio) &&
 					       !PageAnonExclusive(&folio->page))) {
 					spin_unlock(ptl);
 					err = -EBUSY;
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
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch

