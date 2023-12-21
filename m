Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF007948E
	for <mm-commits@vger.kernel.org>; Thu, 21 Dec 2023 22:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RpUt7q+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CB3C433C8;
	Thu, 21 Dec 2023 22:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703197799;
	bh=HsKioJenrWJMqSi9Qih2sNirC3GJQRMPZiT5/2ElCVw=;
	h=Date:To:From:Subject:From;
	b=RpUt7q+EY7yeb+/OVOR/Qn8lCkSD1h7Ch4TAEVksSRWzwGw2POyJGbteOHgaJXefk
	 36ezApLisGGvgy0vz4ETBhatl73bloiLmJGZSe5FP1MQRSxTd1Y81B0aZxohoea9XF
	 aME3nYJ3pRb6MdW9fdN94uSMKpqpcqPDPv4mOKKA=
Date: Thu, 21 Dec 2023 14:29:58 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,songmuchun@bytedance.com,ryan.roberts@arm.com,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch added to mm-unstable branch
Message-Id: <20231221222958.E9CB3C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: page_remove_rmap() -> folio_remove_rmap_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte.patch

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
Subject: mm/khugepaged: page_remove_rmap() -> folio_remove_rmap_pte()
Date: Wed, 20 Dec 2023 23:44:50 +0100

Let's convert __collapse_huge_page_copy_succeeded() and
collapse_pte_mapped_thp().  While at it, perform some more folio
conversion in __collapse_huge_page_copy_succeeded().

We can get rid of release_pte_page().

Link: https://lkml.kernel.org/r/20231220224504.646757-27-david@redhat.com
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

 mm/khugepaged.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-page_remove_rmap-folio_remove_rmap_pte
+++ a/mm/khugepaged.c
@@ -494,11 +494,6 @@ static void release_pte_folio(struct fol
 	folio_putback_lru(folio);
 }
 
-static void release_pte_page(struct page *page)
-{
-	release_pte_folio(page_folio(page));
-}
-
 static void release_pte_pages(pte_t *pte, pte_t *_pte,
 		struct list_head *compound_pagelist)
 {
@@ -687,6 +682,7 @@ static void __collapse_huge_page_copy_su
 						spinlock_t *ptl,
 						struct list_head *compound_pagelist)
 {
+	struct folio *src_folio;
 	struct page *src_page;
 	struct page *tmp;
 	pte_t *_pte;
@@ -708,16 +704,17 @@ static void __collapse_huge_page_copy_su
 			}
 		} else {
 			src_page = pte_page(pteval);
-			if (!PageCompound(src_page))
-				release_pte_page(src_page);
+			src_folio = page_folio(src_page);
+			if (!folio_test_large(src_folio))
+				release_pte_folio(src_folio);
 			/*
 			 * ptl mostly unnecessary, but preempt has to
 			 * be disabled to update the per-cpu stats
-			 * inside page_remove_rmap().
+			 * inside folio_remove_rmap_pte().
 			 */
 			spin_lock(ptl);
 			ptep_clear(vma->vm_mm, address, _pte);
-			page_remove_rmap(src_page, vma, false);
+			folio_remove_rmap_pte(src_folio, src_page, vma);
 			spin_unlock(ptl);
 			free_page_and_swap_cache(src_page);
 		}
@@ -1625,7 +1622,7 @@ int collapse_pte_mapped_thp(struct mm_st
 		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
 		ptep_clear(mm, addr, pte);
-		page_remove_rmap(page, vma, false);
+		folio_remove_rmap_pte(folio, page, vma);
 		nr_ptes++;
 	}
 
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

