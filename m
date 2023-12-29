Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2BB13AF1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X4FjFDxc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D7EC433C7;
	Fri, 29 Dec 2023 20:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880084;
	bh=c2TxNUVKtkig9KNAJ/OgCLO0cb5HKJf7DjUmyBjhNWo=;
	h=Date:To:From:Subject:From;
	b=X4FjFDxcJyTNSRpPhmCrlGgcetTRQ1XoHfFOKjHM55JqAcVhrDAwuncUawPR11gQ2
	 ah19lNXcocE2eCjUcGYiyBd1C7TPBSx0jSY15ttDzmPHRp4LhlAg3x0uEiPLBWrK1W
	 bEp1w78uQlNVVTcrJ4n9ikKcwx/xy5Ece8iotIPg=
Date: Fri, 29 Dec 2023 12:01:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rmap-rename-hugepage_add-to-hugetlb_add.patch removed from -mm tree
Message-Id: <20231229200124.39D7EC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/rmap: rename hugepage_add* to hugetlb_add*
has been removed from the -mm tree.  Its filename was
     mm-rmap-rename-hugepage_add-to-hugetlb_add.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/rmap: rename hugepage_add* to hugetlb_add*
Date: Wed, 20 Dec 2023 23:44:25 +0100

Patch series "mm/rmap: interface overhaul", v2.

This series overhauls the rmap interface, to get rid of the "bool
compound" / RMAP_COMPOUND parameter with the goal of making the interface
less error prone, more future proof, and more natural to extend to
"batching".  Also, this converts the interface to always consume
folio+subpage, which speeds up operations on large folios.

Further, this series adds PTE-batching variants for 4 rmap functions,
whereby only folio_add_anon_rmap_ptes() is used for batching in this
series when PTE-remapping a PMD-mapped THP.  folio_remove_rmap_ptes(),
folio_try_dup_anon_rmap_ptes() and folio_dup_file_rmap_ptes() will soon
come in handy[1,2].

This series performs a lot of folio conversion along the way.  Most of the
added LOC in the diff are only due to documentation.

As we're moving to a pte/pmd interface where we clearly express the
mapping granularity we are dealing with, we first get the remainder of
hugetlb out of the way, as it is special and expected to remain special:
it treats everything as a "single logical PTE" and only currently allows
entire mappings.

Even if we'd ever support partial mappings, I strongly assume the
interface and implementation will still differ heavily: hopefull we can
avoid working on subpages/subpage mapcounts completely and only add a
"count" parameter for them to enable batching.

New (extended) hugetlb interface that operates on entire folio:
 * hugetlb_add_new_anon_rmap() -> Already existed
 * hugetlb_add_anon_rmap() -> Already existed
 * hugetlb_try_dup_anon_rmap()
 * hugetlb_try_share_anon_rmap()
 * hugetlb_add_file_rmap()
 * hugetlb_remove_rmap()

New "ordinary" interface for small folios / THP::
 * folio_add_new_anon_rmap() -> Already existed
 * folio_add_anon_rmap_[pte|ptes|pmd]()
 * folio_try_dup_anon_rmap_[pte|ptes|pmd]()
 * folio_try_share_anon_rmap_[pte|pmd]()
 * folio_add_file_rmap_[pte|ptes|pmd]()
 * folio_dup_file_rmap_[pte|ptes|pmd]()
 * folio_remove_rmap_[pte|ptes|pmd]()

folio_add_new_anon_rmap() will always map at the largest granularity
possible (currently, a single PMD to cover a PMD-sized THP).  Could be
extended if ever required.

In the future, we might want "_pud" variants and eventually "_pmds"
variants for batching.

I ran some simple microbenchmarks on an Intel(R) Xeon(R) Silver 4210R:
measuring munmap(), fork(), cow, MADV_DONTNEED on each PTE ...  and PTE
remapping PMD-mapped THPs on 1 GiB of memory.

For small folios, there is barely a change (< 1% improvement for me).

For PTE-mapped THP:
* PTE-remapping a PMD-mapped THP is more than 10% faster.
* fork() is more than 4% faster.
* MADV_DONTNEED is 2% faster
* COW when writing only a single byte on a COW-shared PTE is 1% faster
* munmap() barely changes (< 1%).

[1] https://lkml.kernel.org/r/20230810103332.3062143-1-ryan.roberts@arm.com
[2] https://lkml.kernel.org/r/20231204105440.61448-1-ryan.roberts@arm.com


This patch (of 40):

Let's just call it "hugetlb_".

Yes, it's all already inconsistent and confusing because we have a lot of
"hugepage_" functions for legacy reasons.  But "hugetlb" cannot possibly
be confused with transparent huge pages, and it matches "hugetlb.c" and
"folio_test_hugetlb()".  So let's minimize confusion in rmap code.

Link: https://lkml.kernel.org/r/20231220224504.646757-1-david@redhat.com
Link: https://lkml.kernel.org/r/20231220224504.646757-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    4 ++--
 mm/hugetlb.c         |    8 ++++----
 mm/migrate.c         |    4 ++--
 mm/rmap.c            |    8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-rename-hugepage_add-to-hugetlb_add
+++ a/include/linux/rmap.h
@@ -206,9 +206,9 @@ void folio_add_file_rmap_range(struct fo
 void page_remove_rmap(struct page *, struct vm_area_struct *,
 		bool compound);
 
-void hugepage_add_anon_rmap(struct folio *, struct vm_area_struct *,
+void hugetlb_add_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
-void hugepage_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
+void hugetlb_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address);
 
 static inline void __page_dup_rmap(struct page *page, bool compound)
--- a/mm/hugetlb.c~mm-rmap-rename-hugepage_add-to-hugetlb_add
+++ a/mm/hugetlb.c
@@ -5285,7 +5285,7 @@ hugetlb_install_folio(struct vm_area_str
 	pte_t newpte = make_huge_pte(vma, &new_folio->page, 1);
 
 	__folio_mark_uptodate(new_folio);
-	hugepage_add_new_anon_rmap(new_folio, vma, addr);
+	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
 	if (userfaultfd_wp(vma) && huge_pte_uffd_wp(old))
 		newpte = huge_pte_mkuffd_wp(newpte);
 	set_huge_pte_at(vma->vm_mm, addr, ptep, newpte, sz);
@@ -5988,7 +5988,7 @@ retry_avoidcopy:
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, haddr, ptep);
 		page_remove_rmap(&old_folio->page, vma, true);
-		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
+		hugetlb_add_new_anon_rmap(new_folio, vma, haddr);
 		if (huge_pte_uffd_wp(pte))
 			newpte = huge_pte_mkuffd_wp(newpte);
 		set_huge_pte_at(mm, haddr, ptep, newpte, huge_page_size(h));
@@ -6277,7 +6277,7 @@ static vm_fault_t hugetlb_no_page(struct
 		goto backout;
 
 	if (anon_rmap)
-		hugepage_add_new_anon_rmap(folio, vma, haddr);
+		hugetlb_add_new_anon_rmap(folio, vma, haddr);
 	else
 		page_dup_file_rmap(&folio->page, true);
 	new_pte = make_huge_pte(vma, &folio->page, ((vma->vm_flags & VM_WRITE)
@@ -6732,7 +6732,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	if (folio_in_pagecache)
 		page_dup_file_rmap(&folio->page, true);
 	else
-		hugepage_add_new_anon_rmap(folio, dst_vma, dst_addr);
+		hugetlb_add_new_anon_rmap(folio, dst_vma, dst_addr);
 
 	/*
 	 * For either: (1) CONTINUE on a non-shared VMA, or (2) UFFDIO_COPY
--- a/mm/migrate.c~mm-rmap-rename-hugepage_add-to-hugetlb_add
+++ a/mm/migrate.c
@@ -249,8 +249,8 @@ static bool remove_migration_pte(struct
 
 			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
 			if (folio_test_anon(folio))
-				hugepage_add_anon_rmap(folio, vma, pvmw.address,
-						       rmap_flags);
+				hugetlb_add_anon_rmap(folio, vma, pvmw.address,
+						      rmap_flags);
 			else
 				page_dup_file_rmap(new, true);
 			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte,
--- a/mm/rmap.c~mm-rmap-rename-hugepage_add-to-hugetlb_add
+++ a/mm/rmap.c
@@ -2625,8 +2625,8 @@ void rmap_walk_locked(struct folio *foli
  *
  * RMAP_COMPOUND is ignored.
  */
-void hugepage_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
-			    unsigned long address, rmap_t flags)
+void hugetlb_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
+		unsigned long address, rmap_t flags)
 {
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
@@ -2637,8 +2637,8 @@ void hugepage_add_anon_rmap(struct folio
 			 PageAnonExclusive(&folio->page), folio);
 }
 
-void hugepage_add_new_anon_rmap(struct folio *folio,
-			struct vm_area_struct *vma, unsigned long address)
+void hugetlb_add_new_anon_rmap(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long address)
 {
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	/* increment count (starts at -1) */
_

Patches currently in -mm which might be from david@redhat.com are


