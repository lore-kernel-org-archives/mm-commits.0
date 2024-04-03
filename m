Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B048E1D54B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171134; cv=none; b=A2H7pisFTEKEVP/15/T76GiuXG/Jhxb+f9neoF7IRzqUlDhgZR2Klw4hcCNaNv/6aUJ+53Sr8kdk0WOYKsg/R83lcrZrlmOlHEtSjm9Kr4LDZpnYvLF4MK1fjCZKnFvzJgcpaRC7UQs/NbSt6jp2t505pYTUBEI2lnvo6GwPNeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171134; c=relaxed/simple;
	bh=hexr9wnWhaGJE4PuRxLOmNArOAV5dZNRdk6NGk+0PXE=;
	h=Date:To:From:Subject:Message-Id; b=KuVyRlYP+G5LE8gycnpXZafr6y0+VApdUCNfxC3NjPUCt4H7FlXFonsooc4KctGoFLDEMZ8aN7OE9i/3h/Sy3/D3vU9btcAMrle7xtITzjs4e3eOCwk/9+mfYDgGRzUD6Labf5aYKH7gfh7daJYfBaeo0cRLNn60TMJL7rm58bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xxMza6fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xxMza6fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D06C433C7;
	Wed,  3 Apr 2024 19:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171134;
	bh=hexr9wnWhaGJE4PuRxLOmNArOAV5dZNRdk6NGk+0PXE=;
	h=Date:To:From:Subject:From;
	b=xxMza6fn0uZszVMcfY8GYo4qVNkDQ/5SYqa1sAb21+HipEqHLqL7dqOQZcAsVMy1P
	 kSSVLo1gS52Nqr3ck7hGNrGhG3JLfAFBqeeuJA60eCjeQfeOkCEyVWNUAv0/16E9Bh
	 qvDR1s6a1P1BgoguA7LYN5Zaf6sZusuILjHwXtaE=
Date: Wed, 03 Apr 2024 12:05:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-inline-hpage_collapse_alloc_folio.patch added to mm-unstable branch
Message-Id: <20240403190534.31D06C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: inline hpage_collapse_alloc_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-inline-hpage_collapse_alloc_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-inline-hpage_collapse_alloc_folio.patch

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
Subject: khugepaged: inline hpage_collapse_alloc_folio()
Date: Wed, 3 Apr 2024 18:18:30 +0100

Patch series "khugepaged folio conversions".

We've been kind of hacking piecemeal at converting khugepaged to use
folios instead of compound pages, and so this patchset is a little larger
than it should be as I undo some of our wrong moves in the past.  In
particular, collapse_file() now consistently uses 'new_folio' for the
freshly allocated folio and 'folio' for the one that's currently in use.  


This patch (of 7):

This function has one caller, and the combined function is simpler to
read, reason about and modify.

Link: https://lkml.kernel.org/r/20240403171838.1445826-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240403171838.1445826-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/mm/khugepaged.c~khugepaged-inline-hpage_collapse_alloc_folio
+++ a/mm/khugepaged.c
@@ -891,20 +891,6 @@ static int hpage_collapse_find_target_no
 }
 #endif
 
-static bool hpage_collapse_alloc_folio(struct folio **folio, gfp_t gfp, int node,
-				      nodemask_t *nmask)
-{
-	*folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, nmask);
-
-	if (unlikely(!*folio)) {
-		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
-		return false;
-	}
-
-	count_vm_event(THP_COLLAPSE_ALLOC);
-	return true;
-}
-
 /*
  * If mmap_lock temporarily dropped, revalidate vma
  * before taking mmap_lock.
@@ -1067,11 +1053,14 @@ static int alloc_charge_hpage(struct pag
 	int node = hpage_collapse_find_target_node(cc);
 	struct folio *folio;
 
-	if (!hpage_collapse_alloc_folio(&folio, gfp, node, &cc->alloc_nmask)) {
+	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
+	if (!folio) {
 		*hpage = NULL;
+		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
 
+	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
 		*hpage = NULL;
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

