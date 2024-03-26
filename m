Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8436D17591
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711485995; cv=none; b=cV8gmtVeScIgHU1rLGDGHGNkiPJR1eEhbSxZLExCnR30oNLOpaTCRPaUc5f+FJMDB25Q0NBJKJaCsHqZHq4BGglORTOLpGVkIcd+loR068oTjSu5DhFPAjRRIKDwSHmZlyep+Tjb71dwcFaHUgZySfg7eEtp+3v4AOR1rbiryg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711485995; c=relaxed/simple;
	bh=8y3v99jpwkQZw6dqgh1L93aJm13Y+IRQGks0UYcprMg=;
	h=Date:To:From:Subject:Message-Id; b=T4qWpoYHJzgjb+FE1JhPGvRLU+fI1+ipRJoM7kLMqXl8vmXmEOpp8vBiLkue1MDhCFCa/r7ye0kjATdpROq3tK3aFQQKnU6HUoTvRbpssdghTeOQ3kTO+BUSfpZ+XGfZtvMZVUO6uFsO+C1KME/ZpcX9BGg7I82bRe6ClMNSLkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2dAmM2pL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2dAmM2pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83C8C43390;
	Tue, 26 Mar 2024 20:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711485994;
	bh=8y3v99jpwkQZw6dqgh1L93aJm13Y+IRQGks0UYcprMg=;
	h=Date:To:From:Subject:From;
	b=2dAmM2pLx5kehLX17jqgOxVVOK2Nzi69Ts8jjbm3CsDqG21qpVttKbmoyTGWzDwrX
	 h8+2VQhGlEFAuYBSU4s4GhLFgfEIOc0gDFS+uEFXeqWbgmsLJhAnhWX0D3Smsba8Gv
	 huHG++HOW8MU0NHy5jxPuhdO3W5CSrZ2Gp+EKoTI=
Date: Tue, 26 Mar 2024 13:46:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc-use-is_huge_zero_pmd.patch added to mm-unstable branch
Message-Id: <20240326204634.D83C8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc: use is_huge_zero_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     sparc-use-is_huge_zero_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc-use-is_huge_zero_pmd.patch

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
Subject: sparc: use is_huge_zero_pmd()
Date: Tue, 26 Mar 2024 20:28:21 +0000

Patch series "Convert huge_zero_page to huge_zero_folio".

Almost all the callers of is_huge_zero_page() already have a folio.  And
they should -- is_huge_zero_page() will return false for tail pages, even
if they're tail pages of the huge zero page.  That's confusing, and one of
the benefits of the folio conversion is to get rid of this confusion.


This patch (of 8):

There's no need to convert to a page, much less a folio.  We can tell from
the pmd whether it is a huge zero page or not.  Saves 60 bytes of text.

Link: https://lkml.kernel.org/r/20240326202833.523759-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240326202833.523759-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/tlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/sparc/mm/tlb.c~sparc-use-is_huge_zero_pmd
+++ a/arch/sparc/mm/tlb.c
@@ -183,12 +183,12 @@ static void __set_pmd_acct(struct mm_str
 		 * hugetlb_pte_count.
 		 */
 		if (pmd_val(pmd) & _PAGE_PMD_HUGE) {
-			if (is_huge_zero_page(pmd_page(pmd)))
+			if (is_huge_zero_pmd(pmd))
 				mm->context.hugetlb_pte_count++;
 			else
 				mm->context.thp_pte_count++;
 		} else {
-			if (is_huge_zero_page(pmd_page(orig)))
+			if (is_huge_zero_pmd(orig))
 				mm->context.hugetlb_pte_count--;
 			else
 				mm->context.thp_pte_count--;
@@ -259,7 +259,7 @@ pmd_t pmdp_invalidate(struct vm_area_str
 	 * Sanity check pmd before doing the actual decrement.
 	 */
 	if ((pmd_val(entry) & _PAGE_PMD_HUGE) &&
-	    !is_huge_zero_page(pmd_page(entry)))
+	    !is_huge_zero_pmd(entry))
 		(vma->vm_mm)->context.thp_pte_count--;
 
 	return old;
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

