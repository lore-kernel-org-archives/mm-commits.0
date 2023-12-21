Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0A678E8D
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SqN6Ipi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58ECC433CA;
	Thu, 21 Dec 2023 22:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197797;
	bh=K2R0NUBRs4X6X6hBEKmn8Q1JS7XCJce14QFG3FrnfYI=;
	h=Date:To:From:Subject:From;
	b=SqN6Ipi1PzF3tlzbJkSxxBJTPpZVdmZJ7yLF6YnjC5GSc/Dj8ySawIMH4VjguI3ix
	 dwXV3KWanZOHsy1ZX8Z1Y84ElGD2muXULdYqTZq5GPfHbFFh6BdFK/nljVXPJWmedD
	 N2rGZWMkt7kJjnoyRxFIchbih+wyzz1E/OFm3K8M=
Date: Thu, 21 Dec 2023 14:29:57 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch added to mm-unstable branch
Message-Id: <20231221222957.B58ECC433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: page_remove_rmap() -> folio_remove_rmap_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd.patch

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
Subject: mm/huge_memory: page_remove_rmap() -> folio_remove_rmap_pmd()
Date: Wed, 20 Dec 2023 23:44:49 +0100

Let's convert zap_huge_pmd() and set_pmd_migration_entry().  While at it,
perform some more folio conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-26-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-page_remove_rmap-folio_remove_rmap_pmd
+++ a/mm/huge_memory.c
@@ -1898,7 +1898,7 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 		if (pmd_present(orig_pmd)) {
 			page = pmd_page(orig_pmd);
-			page_remove_rmap(page, vma, true);
+			folio_remove_rmap_pmd(page_folio(page), page, vma);
 			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 		} else if (thp_migration_supported()) {
@@ -2433,12 +2433,13 @@ static void __split_huge_pmd_locked(stru
 			page = pfn_swap_entry_to_page(entry);
 		} else {
 			page = pmd_page(old_pmd);
-			if (!PageDirty(page) && pmd_dirty(old_pmd))
-				set_page_dirty(page);
-			if (!PageReferenced(page) && pmd_young(old_pmd))
-				SetPageReferenced(page);
-			page_remove_rmap(page, vma, true);
-			put_page(page);
+			folio = page_folio(page);
+			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
+				folio_set_dirty(folio);
+			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
+				folio_set_referenced(folio);
+			folio_remove_rmap_pmd(folio, page, vma);
+			folio_put(folio);
 		}
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
@@ -2593,7 +2594,7 @@ static void __split_huge_pmd_locked(stru
 	pte_unmap(pte - 1);
 
 	if (!pmd_migration)
-		page_remove_rmap(page, vma, true);
+		folio_remove_rmap_pmd(folio, page, vma);
 	if (freeze)
 		put_page(page);
 
@@ -3536,6 +3537,7 @@ late_initcall(split_huge_pages_debugfs);
 int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
 		struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = pvmw->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long address = pvmw->address;
@@ -3551,14 +3553,14 @@ int set_pmd_migration_entry(struct page_
 	pmdval = pmdp_invalidate(vma, address, pvmw->pmd);
 
 	/* See page_try_share_anon_rmap(): invalidate PMD first. */
-	anon_exclusive = PageAnon(page) && PageAnonExclusive(page);
+	anon_exclusive = folio_test_anon(folio) && PageAnonExclusive(page);
 	if (anon_exclusive && page_try_share_anon_rmap(page)) {
 		set_pmd_at(mm, address, pvmw->pmd, pmdval);
 		return -EBUSY;
 	}
 
 	if (pmd_dirty(pmdval))
-		set_page_dirty(page);
+		folio_set_dirty(folio);
 	if (pmd_write(pmdval))
 		entry = make_writable_migration_entry(page_to_pfn(page));
 	else if (anon_exclusive)
@@ -3575,8 +3577,8 @@ int set_pmd_migration_entry(struct page_
 	if (pmd_uffd_wp(pmdval))
 		pmdswp = pmd_swp_mkuffd_wp(pmdswp);
 	set_pmd_at(mm, address, pvmw->pmd, pmdswp);
-	page_remove_rmap(page, vma, true);
-	put_page(page);
+	folio_remove_rmap_pmd(folio, page, vma);
+	folio_put(folio);
 	trace_set_migration_pmd(address, pmd_val(pmdswp));
 
 	return 0;
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

