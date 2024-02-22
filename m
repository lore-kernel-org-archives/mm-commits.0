Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD28F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560078; cv=none; b=aUsusIK2ZgsAmRNWMfiJknyCayW19aIEawxPPaIb743NrMV9KXqgrRvW4wQ2Hr/tpi/d8jRf6sOVGj550eGwcFIxV2Si39+P35Ekmi1Fw0XXCjnROSVOZ8dSk3EjWOpaY5t8KFySEnm2E0vwdY2awRBYq5+Zu1ZtgCCoWargH0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560078; c=relaxed/simple;
	bh=a4njYF5VviNFePAGhiDI2bC/mWXM26DN+JnABn4r9nc=;
	h=Date:To:From:Subject:Message-Id; b=LsJo4yrqPv1XQ0YN5NnjGAnMMrXVqb01JrkdIh+ZGbcTlyLhoqkkAofKliOFGC/n6Yt7+b0185hjCp6SCexAS1f8c/6Bs7d42QQx9R7+LVxx2YNK65sll0Q8ZtUkXsW9TJi8oRsUEjJwwwK6Cv6qm0DXH5iur2bL3UxiHvl5OXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rlhbD1Vl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rlhbD1Vl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EC0C43399;
	Thu, 22 Feb 2024 00:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560078;
	bh=a4njYF5VviNFePAGhiDI2bC/mWXM26DN+JnABn4r9nc=;
	h=Date:To:From:Subject:From;
	b=rlhbD1Vl/jmhV9lMf/DuZlNz2IYvVh2I+gHrZ7BB023jLpZOkCzFqAgDYZSWDZHNC
	 RDIvZ9WHHb5bSRKglEm+QnIuIDAMWmU+aiMcGowGxet1Dem9YD4JCsNGO5DoNnAymc
	 8yKXzg9ehSAWv28Jluuq+IqfJZYst95h3gE0/Qj0=
Date: Wed, 21 Feb 2024 16:01:17 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch removed from -mm tree
Message-Id: <20240222000117.F2EC0C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use pfn_swap_entry_to_folio() in zap_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-use-pfn_swap_entry_to_folio-in-zap_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1905,12 +1905,14 @@ int zap_huge_pmd(struct mmu_gather *tlb,
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
@@ -1918,23 +1920,24 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 
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

mm-compaction-early-termination-in-compact_nodes.patch

