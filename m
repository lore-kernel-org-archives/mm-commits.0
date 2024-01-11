Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AAA50249
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 20:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="seiyNv7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8E4C43394;
	Thu, 11 Jan 2024 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705005159;
	bh=l/DvC4hj3r7Hvuc1+blFVB27nIbBb71nYNuifYdwWX0=;
	h=Date:To:From:Subject:From;
	b=seiyNv7E9DbYYg/p8BcEz5Kpt813v4pazF2u09XOInAbpGkWEKGWGTrzfK+XqBYwc
	 2upIwkvtAqqF7Ux2fsKKP2U3KYmkR/PYxgCzRwytp24ewXeR9KZI9ONL/o3uXxm9Ee
	 q/kOMYhaoMrqU00MSXYuuBpglEr7gkGkUUSytV54=
Date: Thu, 11 Jan 2024 12:32:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch added to mm-unstable branch
Message-Id: <20240111203239.4C8E4C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use pfn_swap_entry_to_folio() in zap_huge_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use pfn_swap_entry_to_folio() in zap_huge_pmd()
Date: Thu, 11 Jan 2024 15:24:25 +0000

Call pfn_swap_entry_to_folio() in zap_huge_pmd() as preparation for
converting mm counter functions to take a folio.  Saves a call to
compound_head() embedded inside PageAnon().

Link: https://lkml.kernel.org/r/20240111152429.3374566-7-willy@infradead.org
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/huge_memory.c~mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd
+++ a/mm/huge_memory.c
@@ -1895,12 +1895,14 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 		zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
 	} else {
-		struct page *page = NULL;
+		struct folio *folio = NULL;
 		int flush_needed = 1;
 
 		if (pmd_present(orig_pmd)) {
-			page = pmd_page(orig_pmd);
-			folio_remove_rmap_pmd(page_folio(page), page, vma);
+			struct page *page = pmd_page(orig_pmd);
+
+			folio = page_folio(page);
+			folio_remove_rmap_pmd(folio, page, vma);
 			VM_BUG_ON_PAGE(page_mapcount(page) < 0, page);
 			VM_BUG_ON_PAGE(!PageHead(page), page);
 		} else if (thp_migration_supported()) {
@@ -1908,23 +1910,24 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
 			VM_BUG_ON(!is_pmd_migration_entry(orig_pmd));
 			entry = pmd_to_swp_entry(orig_pmd);
-			page = pfn_swap_entry_to_page(entry);
+			folio = pfn_swap_entry_folio(entry);
 			flush_needed = 0;
 		} else
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
 
-		if (PageAnon(page)) {
+		if (folio_test_anon(folio)) {
 			zap_deposited_table(tlb->mm, pmd);
 			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		} else {
 			if (arch_needs_pgtable_deposit())
 				zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, mm_counter_file(page), -HPAGE_PMD_NR);
+			add_mm_counter(tlb->mm, mm_counter_file(&folio->page),
+				       -HPAGE_PMD_NR);
 		}
 
 		spin_unlock(ptl);
 		if (flush_needed)
-			tlb_remove_page_size(tlb, page, HPAGE_PMD_SIZE);
+			tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 	}
 	return 1;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-memory-use-nth_page-in-clear-copy_subpage.patch
s390-use-pfn_swap_entry_folio-in-ptep_zap_swap_entry.patch
mm-use-pfn_swap_entry_folio-in-__split_huge_pmd_locked.patch
mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch
mm-use-pfn_swap_entry_folio-in-copy_nonpresent_pte.patch
mm-convert-to-should_zap_page-to-should_zap_folio.patch
mm-convert-mm_counter-to-take-a-folio.patch
mm-convert-mm_counter_file-to-take-a-folio.patch

