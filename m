Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DA579467
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GFlvSp5M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6216AC433C7;
	Thu, 21 Dec 2023 22:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197777;
	bh=AvPNlJT6wZbes/2WO7AsKAsapRYp1TJuC1EHrvjyAKg=;
	h=Date:To:From:Subject:From;
	b=GFlvSp5MLJNmIQvddC35cS7wrDykKNXTaBxnhOgKoa3TKe9svvCFcFGoJXFBxrk8z
	 dy+jF9Ae0JvTvu08AKWAkNmxYIOJDIZB4kb1zg5P3qdWLT3V8Mmw4SLmR+J/D9fIH6
	 2bArA/itPFJ9ebYeU7T8MgYH5OJYjQhEc7/zr4GM=
Date: Thu, 21 Dec 2023 14:29:36 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch added to mm-unstable branch
Message-Id: <20231221222937.6216AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memory: page_add_file_rmap() -> folio_add_file_rmap_[pte|pmd]()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-page_add_file_rmap-folio_add_file_rmap_.patch

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
Subject: mm/memory: page_add_file_rmap() -> folio_add_file_rmap_[pte|pmd]()
Date: Wed, 20 Dec 2023 23:44:32 +0100

Let's convert insert_page_into_pte_locked() and do_set_pmd().  While at
it, perform some folio conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-9-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memory-page_add_file_rmap-folio_add_file_rmap_
+++ a/mm/memory.c
@@ -1859,12 +1859,14 @@ static int validate_page_before_insert(s
 static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 			unsigned long addr, struct page *page, pgprot_t prot)
 {
+	struct folio *folio = page_folio(page);
+
 	if (!pte_none(ptep_get(pte)))
 		return -EBUSY;
 	/* Ok, finally just insert the thing.. */
-	get_page(page);
+	folio_get(folio);
 	inc_mm_counter(vma->vm_mm, mm_counter_file(page));
-	page_add_file_rmap(page, vma, false);
+	folio_add_file_rmap_pte(folio, page, vma);
 	set_pte_at(vma->vm_mm, addr, pte, mk_pte(page, prot));
 	return 0;
 }
@@ -4409,6 +4411,7 @@ static void deposit_prealloc_pte(struct
 
 vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
 {
+	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
@@ -4418,8 +4421,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	page = compound_head(page);
-	if (compound_order(page) != HPAGE_PMD_ORDER)
+	if (page != &folio->page || folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
 
 	/*
@@ -4428,7 +4430,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	 * check.  This kind of THP just can be PTE mapped.  Access to
 	 * the corrupted subpage should trigger SIGBUS as expected.
 	 */
-	if (unlikely(PageHasHWPoisoned(page)))
+	if (unlikely(folio_test_has_hwpoisoned(folio)))
 		return ret;
 
 	/*
@@ -4452,7 +4454,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
 	add_mm_counter(vma->vm_mm, mm_counter_file(page), HPAGE_PMD_NR);
-	page_add_file_rmap(page, vma, true);
+	folio_add_file_rmap_pmd(folio, page, vma);
 
 	/*
 	 * deposit and withdraw with pmd lock held
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

