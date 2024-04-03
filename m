Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D771D54B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171136; cv=none; b=NQ+brGWXJnv1BRfN2IaiKxhcZqa3VgLyuQYMDgLqTSAi/5pfPmaptZOiUI4baAUe6WLQU7XXsD1Q2Hw1gZAz8ce6K/qT336k7x9sHUDhQ7fT6Dn97w6s+pKrYCM0Xjauf4QZctZsKiA08Jcc/xuwvn0dow2vO6y3j6R3a62OaLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171136; c=relaxed/simple;
	bh=UNp5yGhBFx3vEAZ7VVnVyz24EFkUo5t+uEMI7WVuXO0=;
	h=Date:To:From:Subject:Message-Id; b=lKNZsNVPrZHnFw7/csX9Ny5kvaO2T49jKJvcv4Nu49CtQFqL/8v0cHzysuTWOKz7wtwRc3rPaXX/TMvJu5td6ZWAHDrO3WSGMaNoWLsAGqJp61Y0AQW6ySfEFdeyZbva2gu6uPJQdxvdRd1YOOyt+2mAkiQUbZO+KYxOj4enJCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0kX4aO8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0kX4aO8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BCEC433C7;
	Wed,  3 Apr 2024 19:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171135;
	bh=UNp5yGhBFx3vEAZ7VVnVyz24EFkUo5t+uEMI7WVuXO0=;
	h=Date:To:From:Subject:From;
	b=0kX4aO8fpT/Gq0v5hZj6oeuovI0pXg4YaDwn07nxTzjRl12xzye9B64Y3H0HMd5zA
	 jIOBGzh8ynJs1Eia9dPzAIwppiF3B5onC1enCtcF6veXaPLoIRaq79Y8oNAPrvaQ8+
	 PnCL0euqctxihIlqQIdq+nEKOyMt0qqs/3CZ4vsw=
Date: Wed, 03 Apr 2024 12:05:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch added to mm-unstable branch
Message-Id: <20240403190535.A8BCEC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: convert alloc_charge_hpage to alloc_charge_folio
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch

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
Subject: khugepaged: convert alloc_charge_hpage to alloc_charge_folio
Date: Wed, 3 Apr 2024 18:18:31 +0100

Both callers want to deal with a folio, so return a folio from this
function.

Link: https://lkml.kernel.org/r/20240403171838.1445826-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio
+++ a/mm/khugepaged.c
@@ -1045,7 +1045,7 @@ out:
 	return result;
 }
 
-static int alloc_charge_hpage(struct page **hpage, struct mm_struct *mm,
+static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 			      struct collapse_control *cc)
 {
 	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
@@ -1055,7 +1055,7 @@ static int alloc_charge_hpage(struct pag
 
 	folio = __folio_alloc(gfp, HPAGE_PMD_ORDER, node, &cc->alloc_nmask);
 	if (!folio) {
-		*hpage = NULL;
+		*foliop = NULL;
 		count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
 		return SCAN_ALLOC_HUGE_PAGE_FAIL;
 	}
@@ -1063,13 +1063,13 @@ static int alloc_charge_hpage(struct pag
 	count_vm_event(THP_COLLAPSE_ALLOC);
 	if (unlikely(mem_cgroup_charge(folio, mm, gfp))) {
 		folio_put(folio);
-		*hpage = NULL;
+		*foliop = NULL;
 		return SCAN_CGROUP_CHARGE_FAIL;
 	}
 
 	count_memcg_folio_events(folio, THP_COLLAPSE_ALLOC, 1);
 
-	*hpage = folio_page(folio, 0);
+	*foliop = folio;
 	return SCAN_SUCCEED;
 }
 
@@ -1098,7 +1098,8 @@ static int collapse_huge_page(struct mm_
 	 */
 	mmap_read_unlock(mm);
 
-	result = alloc_charge_hpage(&hpage, mm, cc);
+	result = alloc_charge_folio(&folio, mm, cc);
+	hpage = &folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1204,7 +1205,6 @@ static int collapse_huge_page(struct mm_
 	if (unlikely(result != SCAN_SUCCEED))
 		goto out_up_write;
 
-	folio = page_folio(hpage);
 	/*
 	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
 	 * copy_huge_page writes become visible before the set_pmd_at()
@@ -1789,7 +1789,7 @@ static int collapse_file(struct mm_struc
 	struct page *hpage;
 	struct page *page;
 	struct page *tmp;
-	struct folio *folio;
+	struct folio *folio, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
@@ -1800,7 +1800,8 @@ static int collapse_file(struct mm_struc
 	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
 	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
 
-	result = alloc_charge_hpage(&hpage, mm, cc);
+	result = alloc_charge_folio(&new_folio, mm, cc);
+	hpage = &new_folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out;
 
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

