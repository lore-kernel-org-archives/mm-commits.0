Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA97470
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711770607; cv=none; b=sHuXAfmIAMeP8DvRoYU3nbu2PrOVbMKs5EUcou+92Uew1auJKvq1C0yV9RD5L3f5hGFkp9WrxZCpZvXmbdrz3XFg4ffEehWznkymBAyPeyidAjqXE9pLTyhjQuv8fellNapBJRHBY9CPnXXGFS37jfdBHa9efL10vtfbYUexNJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711770607; c=relaxed/simple;
	bh=02GkPGq64BsUFOM7eM+so6M36XgTagYzW8KWud2r0Ro=;
	h=Date:To:From:Subject:Message-Id; b=F3eR7cHGHxAn9D+FIAiB0L1OFSihEXcoC7xmNPn51hem7HeZaQqDegC6gEnMOsjPAhgTu52XO8GdgWzBzzwG+Z4+HVTH4NGGcddVzWv0uHjqNf1oRobgRw3AQaFwySTFupUlUU3y/gSc2varo4IIyiVufql17dfRzazzGCu/rYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZkyYEBFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZkyYEBFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F5C433C7;
	Sat, 30 Mar 2024 03:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711770606;
	bh=02GkPGq64BsUFOM7eM+so6M36XgTagYzW8KWud2r0Ro=;
	h=Date:To:From:Subject:From;
	b=ZkyYEBFBJbbM39cjvgxTNTf7nOXv+/+VB5MdWGiASd/LiO4d7jrfzRsz9Mx5aTufZ
	 m5onUyRVgUnf8k3i+uyYZcVxPSIJCKC0FrrTlNflFzqr/8ZEB41nXTgYTZiuLrnZDX
	 UjsVRZyrKIdAb3nriQWu8X23Sfftv92cD8IiWbjk=
Date: Fri, 29 Mar 2024 20:50:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rename-vma_pgoff_address-back-to-vma_address.patch added to mm-unstable branch
Message-Id: <20240330035006.6C5F5C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: rename vma_pgoff_address back to vma_address
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rename-vma_pgoff_address-back-to-vma_address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rename-vma_pgoff_address-back-to-vma_address.patch

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
Subject: mm: rename vma_pgoff_address back to vma_address
Date: Thu, 28 Mar 2024 22:58:29 +0000

With all callers converted, we can use the nice shorter name.  Take this
opportunity to reorder the arguments to the logical order (larger object
first).

Link: https://lkml.kernel.org/r/20240328225831.1765286-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h        |    9 ++++-----
 mm/memory-failure.c  |    2 +-
 mm/page_vma_mapped.c |    2 +-
 mm/rmap.c            |   12 ++++++------
 4 files changed, 12 insertions(+), 13 deletions(-)

--- a/mm/internal.h~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/internal.h
@@ -861,17 +861,16 @@ void mlock_drain_remote(int cpu);
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /**
- * vma_pgoff_address - Find the virtual address a page range is mapped at
+ * vma_address - Find the virtual address a page range is mapped at
+ * @vma: The vma which maps this object.
  * @pgoff: The page offset within its object.
  * @nr_pages: The number of pages to consider.
- * @vma: The vma which maps this object.
  *
  * If any page in this range is mapped by this VMA, return the first address
  * where any of these pages appear.  Otherwise, return -EFAULT.
  */
-static inline unsigned long
-vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
-		  struct vm_area_struct *vma)
+static inline unsigned long vma_address(struct vm_area_struct *vma,
+		pgoff_t pgoff, unsigned long nr_pages)
 {
 	unsigned long address;
 
--- a/mm/memory-failure.c~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/memory-failure.c
@@ -443,7 +443,7 @@ static void __add_to_kill(struct task_st
 	tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
 	if (is_zone_device_page(p)) {
 		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
-			tk->addr = vma_pgoff_address(fsdax_pgoff, 1, vma);
+			tk->addr = vma_address(vma, fsdax_pgoff, 1);
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
 	} else
 		tk->size_shift = page_shift(compound_head(p));
--- a/mm/page_vma_mapped.c~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/page_vma_mapped.c
@@ -334,7 +334,7 @@ int page_mapped_in_vma(struct page *page
 		.flags = PVMW_SYNC,
 	};
 
-	pvmw.address = vma_pgoff_address(pgoff, 1, vma);
+	pvmw.address = vma_address(vma, pgoff, 1);
 	if (pvmw.address == -EFAULT)
 		return 0;
 	if (!page_vma_mapped_walk(&pvmw))
--- a/mm/rmap.c~mm-rename-vma_pgoff_address-back-to-vma_address
+++ a/mm/rmap.c
@@ -794,7 +794,7 @@ unsigned long page_address_in_vma(struct
 
 	/* The !page__anon_vma above handles KSM folios */
 	pgoff = folio->index + folio_page_idx(folio, page);
-	return vma_pgoff_address(pgoff, 1, vma);
+	return vma_address(vma, pgoff, 1);
 }
 
 /*
@@ -1132,7 +1132,7 @@ int pfn_mkclean_range(unsigned long pfn,
 	if (invalid_mkclean_vma(vma, NULL))
 		return 0;
 
-	pvmw.address = vma_pgoff_address(pgoff, nr_pages, vma);
+	pvmw.address = vma_address(vma, pgoff, nr_pages);
 	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
 
 	return page_vma_mkclean_one(&pvmw);
@@ -2592,8 +2592,8 @@ static void rmap_walk_anon(struct folio
 	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
 			pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
-		unsigned long address = vma_pgoff_address(pgoff_start,
-				folio_nr_pages(folio), vma);
+		unsigned long address = vma_address(vma, pgoff_start,
+				folio_nr_pages(folio));
 
 		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
@@ -2654,8 +2654,8 @@ static void rmap_walk_file(struct folio
 lookup:
 	vma_interval_tree_foreach(vma, &mapping->i_mmap,
 			pgoff_start, pgoff_end) {
-		unsigned long address = vma_pgoff_address(pgoff_start,
-			       folio_nr_pages(folio), vma);
+		unsigned long address = vma_address(vma, pgoff_start,
+			       folio_nr_pages(folio));
 
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

