Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3F277F23
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ih6M901z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66F8C433C8;
	Thu, 21 Dec 2023 22:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197763;
	bh=7FLGP4/z0jCRCyYYjHqknPRDtjsuRMAtaj8UHCdx2eI=;
	h=Date:To:From:Subject:From;
	b=Ih6M901zNPoKeushZ6DgDs7xxPxlou17PkiDM1E30XJGeOPYNNGnyKua54mAHkHIZ
	 y/KGgomOAQbF6eaQUMssrbhGa0t463yvJLTSmyo1KDKsunPiD2xykJXD9ge4rmzbJG
	 bF5UsgALvBiACf3wyzcv/w79B1hKhzh9fPPm6wHU=
Date: Thu, 21 Dec 2023 14:29:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-rename-hugepage_add-to-hugetlb_add.patch added to mm-unstable branch
Message-Id: <20231221222923.D66F8C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: rename hugepage_add* to hugetlb_add*
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-rename-hugepage_add-to-hugetlb_add.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-rename-hugepage_add-to-hugetlb_add.patch

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

mm-rmap-rename-hugepage_add-to-hugetlb_add.patch
mm-rmap-introduce-and-use-hugetlb_remove_rmap.patch
mm-rmap-introduce-and-use-hugetlb_add_file_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_dup_anon_rmap.patch
mm-rmap-introduce-and-use-hugetlb_try_share_anon_rmap.patch
mm-rmap-add-hugetlb-sanity-checks-for-anon-rmap-handling.patch
mm-rmap-convert-folio_add_file_rmap_range-into-folio_add_file_rmap_.patch
mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch
mm-huge_memory-page_add_file_rmap-folio_add_file_rmap_pmd.patch
mm-migrate-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-userfaultfd-page_add_file_rmap-folio_add_file_rmap_pte.patch
mm-rmap-remove-page_add_file_rmap.patch
mm-rmap-factor-out-adding-folio-mappings-into-__folio_add_rmap.patch
mm-rmap-introduce-folio_add_anon_rmap_.patch
mm-huge_memory-batch-rmap-operations-in-__split_huge_pmd_locked.patch
mm-huge_memory-page_add_anon_rmap-folio_add_anon_rmap_pmd.patch
mm-migrate-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-swapfile-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-memory-page_add_anon_rmap-folio_add_anon_rmap_pte.patch
mm-rmap-remove-page_add_anon_rmap.patch
mm-rmap-remove-rmap_compound.patch
mm-rmap-introduce-folio_remove_rmap_.patch
kernel-events-uprobes-page_remove_rmap-folio_remove_rmap_pte.patch
mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch
mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch
mm-ksm-page_remove_rmap-folio_remove_rmap_pte.patch
mm-memory-page_remove_rmap-folio_remove_rmap_pte.patch
mm-migrate_device-page_remove_rmap-folio_remove_rmap_pte.patch
mm-rmap-page_remove_rmap-folio_remove_rmap_pte.patch
documentation-stop-referring-to-page_remove_rmap.patch
mm-rmap-remove-page_remove_rmap.patch
mm-rmap-convert-page_dup_file_rmap-to-folio_dup_file_rmap_.patch
mm-rmap-introduce-folio_try_dup_anon_rmap_.patch
mm-huge_memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pmd.patch
mm-memory-page_try_dup_anon_rmap-folio_try_dup_anon_rmap_pte.patch
mm-rmap-remove-page_try_dup_anon_rmap.patch
mm-convert-page_try_share_anon_rmap-to-folio_try_share_anon_rmap_.patch
mm-rmap-rename-compound_mapped-to-entirely_mapped.patch
mm-remove-one-last-reference-to-page_add__rmap.patch

