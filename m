Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B882F78E64
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z4JYzr6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376EAC433C8;
	Thu, 21 Dec 2023 22:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197789;
	bh=J3NYja2HdycuSc4jKkYYesZaOKSKViinIqgz6alAuVc=;
	h=Date:To:From:Subject:From;
	b=Z4JYzr6HEDM5V9/bamrDdFJrtOiS2Xzn6zJ/DMCoVUG4xtuYQwiZEnpOjXkJtqrfV
	 hSCIh+pDwa/D4a7awp0crnDXLUYF0fbXOwR0nbYhAfAu1koyRHBLgxWM8aiaNoFaQm
	 roRWEYSUR+vLjGpgOXsWPXuSVWJsUppCFqs3k88k=
Date: Thu, 21 Dec 2023 14:29:48 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch added to mm-unstable branch
Message-Id: <20231221222949.376EAC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte.patch

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
Subject: mm/ksm: page_add_anon_rmap() -> folio_add_anon_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:42 +0100

Let's convert replace_page().  While at it, perform some folio conversion.

Link: https://lkml.kernel.org/r/20231220224504.646757-19-david@redhat.com
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

 mm/ksm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/ksm.c~mm-ksm-page_add_anon_rmap-folio_add_anon_rmap_pte
+++ a/mm/ksm.c
@@ -1369,6 +1369,7 @@ out:
 static int replace_page(struct vm_area_struct *vma, struct page *page,
 			struct page *kpage, pte_t orig_pte)
 {
+	struct folio *kfolio = page_folio(kpage);
 	struct mm_struct *mm = vma->vm_mm;
 	struct folio *folio;
 	pmd_t *pmd;
@@ -1408,15 +1409,16 @@ static int replace_page(struct vm_area_s
 		goto out_mn;
 	}
 	VM_BUG_ON_PAGE(PageAnonExclusive(page), page);
-	VM_BUG_ON_PAGE(PageAnon(kpage) && PageAnonExclusive(kpage), kpage);
+	VM_BUG_ON_FOLIO(folio_test_anon(kfolio) && PageAnonExclusive(kpage),
+			kfolio);
 
 	/*
 	 * No need to check ksm_use_zero_pages here: we can only have a
 	 * zero_page here if ksm_use_zero_pages was enabled already.
 	 */
 	if (!is_zero_pfn(page_to_pfn(kpage))) {
-		get_page(kpage);
-		page_add_anon_rmap(kpage, vma, addr, RMAP_NONE);
+		folio_get(kfolio);
+		folio_add_anon_rmap_pte(kfolio, kpage, vma, addr, RMAP_NONE);
 		newpte = mk_pte(kpage, vma->vm_page_prot);
 	} else {
 		/*
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

