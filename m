Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE10D17A310
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846639; cv=none; b=YmDJHpeaRnSkLMCTf9NDusuzROCz7nfVXJZqIkag6ughHMaqTiaGvUcSKj6k85SVtwf9RRlGASGPkC58+8zj8IIUq1g8jRgMNTsj7q7a8YnmN99SVMjK3g7BHsgkOb1HWbkDPZSB2X1NF0F6Nak7jM78wef8kCp4vNYlkt2iiMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846639; c=relaxed/simple;
	bh=feQInEJW1Q30dhasJA97kmFTsHoKJeXPLn1PaKFw4O4=;
	h=Date:To:From:Subject:Message-Id; b=PNzz1yPsmdQuS+B7myjxVcrst5RVU7xhJamADuLNtTtvOjnTZbav58PgT/lv5FubVQUS45KPPNMcbswjl5roWYiXpXEwdKcS9mHs/mhvEPIvSW0FWLkL9dthKdtH3MdCH8ssm/1nHp1tBe5GngyGmFJBiFSnV0axn6eVKSKm478=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H0sAviLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H0sAviLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11DBC4CEE4;
	Wed, 21 May 2025 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846639;
	bh=feQInEJW1Q30dhasJA97kmFTsHoKJeXPLn1PaKFw4O4=;
	h=Date:To:From:Subject:From;
	b=H0sAviLaopyszchHKq9rO6mId0SDlryqerun8KbjMkflSctXB1Um6UlN/d0W83RL/
	 EES6B0bKrwEqo7s5LNwPTOWRnmzn4WJ5/1O0bFyFwn+yzPiJNvr9OcyOZfGHY6tIUI
	 TYpLv00UBBJ8ypV4yiGSvOGCix/HalWpHK97VfQo=
Date: Wed, 21 May 2025 09:57:19 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250521165719.A11DBC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: convert set_huge_pmd() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: convert set_huge_pmd() to take a folio
Date: Mon, 12 May 2025 10:57:11 +0800

We've already gotten the stable locked folio in collapse_pte_mapped_thp(),
so just use folio for set_huge_pmd() to set the PMD entry, which is more
straightforward.

Moreover, we will check the folio size in do_set_pmd(), so we can remove
the unnecessary VM_BUG_ON() in set_huge_pmd().  While we are at it, we can
also remove the PageTransHuge(), as it currently has no callers.

Link: https://lkml.kernel.org/r/110c3e1ec5fe7854a0e2c95ffcbc985817180ed7.1747017104.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |   15 ---------------
 mm/khugepaged.c            |   11 +++++------
 2 files changed, 5 insertions(+), 21 deletions(-)

--- a/include/linux/page-flags.h~mm-khugepaged-convert-set_huge_pmd-to-take-a-folio
+++ a/include/linux/page-flags.h
@@ -908,20 +908,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * PageHuge() only returns true for hugetlbfs pages, but not for
- * normal or transparent huge pages.
- *
- * PageTransHuge() returns true for both transparent huge and
- * hugetlbfs pages, but not normal pages. PageTransHuge() can only be
- * called only in the core VM paths where hugetlbfs pages can't exist.
- */
-static inline int PageTransHuge(const struct page *page)
-{
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	return PageHead(page);
-}
-
-/*
  * PageTransCompound returns true for both transparent huge pages
  * and hugetlbfs pages, so it should only be called when it's known
  * that hugetlbfs pages aren't involved.
@@ -931,7 +917,6 @@ static inline int PageTransCompound(cons
 	return PageCompound(page);
 }
 #else
-TESTPAGEFLAG_FALSE(TransHuge, transhuge)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
 #endif
 
--- a/mm/khugepaged.c~mm-khugepaged-convert-set_huge_pmd-to-take-a-folio
+++ a/mm/khugepaged.c
@@ -1465,9 +1465,9 @@ static void collect_mm_slot(struct khuge
 }
 
 #ifdef CONFIG_SHMEM
-/* hpage must be locked, and mmap_lock must be held */
+/* folio must be locked, and mmap_lock must be held */
 static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
-			pmd_t *pmdp, struct page *hpage)
+			pmd_t *pmdp, struct folio *folio, struct page *page)
 {
 	struct vm_fault vmf = {
 		.vma = vma,
@@ -1476,13 +1476,12 @@ static int set_huge_pmd(struct vm_area_s
 		.pmd = pmdp,
 	};
 
-	VM_BUG_ON(!PageTransHuge(hpage));
 	mmap_assert_locked(vma->vm_mm);
 
-	if (do_set_pmd(&vmf, hpage))
+	if (do_set_pmd(&vmf, page))
 		return SCAN_FAIL;
 
-	get_page(hpage);
+	folio_get(folio);
 	return SCAN_SUCCEED;
 }
 
@@ -1689,7 +1688,7 @@ int collapse_pte_mapped_thp(struct mm_st
 maybe_install_pmd:
 	/* step 5: install pmd entry */
 	result = install_pmd
-			? set_huge_pmd(vma, haddr, pmd, &folio->page)
+			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


