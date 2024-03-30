Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF9D7470
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711770605; cv=none; b=gLxgXNVhXOMHTd3Dv2yiJ3DWLax4srKdKeVJo3ddP0ksaUioL367LpXFTMWr+r8a9XqzjEMTjBESMOKGhDukpNCqMOgP32BIucKL4JRcSUVdwAdqh4VJ5uuSSH+tYe6mYPRRvl3G3ud0qIVia5t4nmzHfTWoHx5wpElCSRWTImc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711770605; c=relaxed/simple;
	bh=LZKzfIKRt3EtfhFQCifinyV3KYO1GFmeVegfcOYvFAA=;
	h=Date:To:From:Subject:Message-Id; b=h5SL1jKg3WwzLpKGcSGTBv9dbakvcvECHaTg83vovJTh9+UDBSoHjEnUXQhr8/qfXkI167Gc7U51KOmaR6sZ7nU++/naHRRfV9gSNCUq7noLqyB214kXUUeH16mJvdkM//GkI+HbAp3jo11oIFNv5eiep8Ud8X2xaDrBoPeDYoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FatVfHG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FatVfHG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58CCFC433F1;
	Sat, 30 Mar 2024 03:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711770604;
	bh=LZKzfIKRt3EtfhFQCifinyV3KYO1GFmeVegfcOYvFAA=;
	h=Date:To:From:Subject:From;
	b=FatVfHG2SwjBi9kwv8nDJQEkVrxNC7txewHPtSfK4DTMCIvNmLsVDxulDAj6n0HPQ
	 5s7OHtT02ZF6Tl8mStbtyJ1uDjLf+U6qJ+nRXwCmH5/VLvwBmFAAqHvBBzx/t+0UG5
	 PEuxi8sRqzYyUPM5Ct9oP8sj6eDO7qkimEgl+FjQ=
Date: Fri, 29 Mar 2024 20:50:03 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-vma_address.patch added to mm-unstable branch
Message-Id: <20240330035004.58CCFC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove vma_address()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-vma_address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-vma_address.patch

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
Subject: mm: remove vma_address()
Date: Thu, 28 Mar 2024 22:58:28 +0000

Convert the three remaining callers to call vma_pgoff_address() directly. 
This removes an ambiguity where we'd check just one page if passed a tail
page and all N pages if passed a head page.

Also add better kernel-doc for vma_pgoff_address().

Link: https://lkml.kernel.org/r/20240328225831.1765286-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |   23 ++++++++---------------
 mm/rmap.c     |   12 +++++++++---
 2 files changed, 17 insertions(+), 18 deletions(-)

--- a/mm/internal.h~mm-remove-vma_address
+++ a/mm/internal.h
@@ -860,9 +860,14 @@ void mlock_drain_remote(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
-/*
- * Return the start of user virtual address at the specific offset within
- * a vma.
+/**
+ * vma_pgoff_address - Find the virtual address a page range is mapped at
+ * @pgoff: The page offset within its object.
+ * @nr_pages: The number of pages to consider.
+ * @vma: The vma which maps this object.
+ *
+ * If any page in this range is mapped by this VMA, return the first address
+ * where any of these pages appear.  Otherwise, return -EFAULT.
  */
 static inline unsigned long
 vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
@@ -886,18 +891,6 @@ vma_pgoff_address(pgoff_t pgoff, unsigne
 }
 
 /*
- * Return the start of user virtual address of a page within a vma.
- * Returns -EFAULT if all of the page is outside the range of vma.
- * If page is a compound head, the entire compound page is considered.
- */
-static inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
-{
-	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
-	return vma_pgoff_address(page_to_pgoff(page), compound_nr(page), vma);
-}
-
-/*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
--- a/mm/rmap.c~mm-remove-vma_address
+++ a/mm/rmap.c
@@ -775,6 +775,8 @@ static bool should_defer_flush(struct mm
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
 	struct folio *folio = page_folio(page);
+	pgoff_t pgoff;
+
 	if (folio_test_anon(folio)) {
 		struct anon_vma *page__anon_vma = folio_anon_vma(folio);
 		/*
@@ -790,7 +792,9 @@ unsigned long page_address_in_vma(struct
 		return -EFAULT;
 	}
 
-	return vma_address(page, vma);
+	/* The !page__anon_vma above handles KSM folios */
+	pgoff = folio->index + folio_page_idx(folio, page);
+	return vma_pgoff_address(pgoff, 1, vma);
 }
 
 /*
@@ -2588,7 +2592,8 @@ static void rmap_walk_anon(struct folio
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 			pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_address(&folio->page, vma);
+		unsigned long address = vma_pgoff_address(pgoff_start,
+				folio_nr_pages(folio), vma);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
@@ -2649,7 +2654,8 @@ static void rmap_walk_file(struct folio
 lookup:
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
 			pgoff_start, pgoff_end) {
-		unsigned long address = vma_address(&folio->page, vma);
+		unsigned long address = vma_pgoff_address(pgoff_start,
+			       folio_nr_pages(folio), vma);
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
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

