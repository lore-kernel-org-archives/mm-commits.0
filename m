Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D54254B14
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746829563; cv=none; b=f3mhYOlLx3cm9aJg8B2e09WoOGyzEi4DsCkvPrOW9wQQi4qzzfwZVrDtH9uHsNY9kK5guN3bxqIWq8MsCFY1lGus7fV6vQOTymF5QvBfyfQyllnheEALFkm2xwLmWPNxr5gNQ61Wc71lRGFezRPjBCOuFPXuZ3Jyl5zTQDqca6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746829563; c=relaxed/simple;
	bh=9AQcJQjsIkd/aLjPsmu/aeK15GvLV2Zc+w4+jr3dTss=;
	h=Date:To:From:Subject:Message-Id; b=knfPE1Hr4fPyjWWeZ6PDgnCqQUbByOPRQEC7VSLm4sVIMhKQ4HR3J8DmLjWhXZ9vSQNAmhiW02b8jrz5JJpw/FdNG2fX6dZPe7EwpRytPP7Lsf37klW1j39F6aVVaAFH+vUdSXqrR/0GsTwXsTuYXrRfNJF6Vwvna1NQUNZJ1UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YL/u9TJE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YL/u9TJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8EFC4CEE4;
	Fri,  9 May 2025 22:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746829562;
	bh=9AQcJQjsIkd/aLjPsmu/aeK15GvLV2Zc+w4+jr3dTss=;
	h=Date:To:From:Subject:From;
	b=YL/u9TJEGsoObZbeiI6KQ3bLb8lJS+zWkUfYxkVwCgm7Lwcjnr0aJthDiZ7mSWSxJ
	 VFDZJkjtQBcyaXJD+H8bWoAZlMp4qwwMm8ontJMUQHyenISB94KgnThiqyQP2PpH1J
	 0khDT5Bk2SpY7lwIVUi2ifL/NRhu7bvwy1grZKUA=
Date: Fri, 09 May 2025 15:26:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-do_set_pmd-to-take-a-folio.patch added to mm-new branch
Message-Id: <20250509222602.DA8EFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert do_set_pmd() to take a folio
has been added to the -mm mm-new branch.  Its filename is
     mm-convert-do_set_pmd-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-do_set_pmd-to-take-a-folio.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: convert do_set_pmd() to take a folio
Date: Fri, 9 May 2025 21:01:04 +0800

In do_set_pmd(), we always use the folio->page to build PMD mappings for
the entire folio.  Since all callers of do_set_pmd() already hold a stable
folio, converting do_set_pmd() to take a folio is safe and more
straightforward.

In addition, to ensure the extensibility of do_set_pmd() for supporting
larger folios beyond PMD size, we keep the 'page' parameter to specify
which page within the folio should be mapped.

No functional changes expected.

Link: https://lkml.kernel.org/r/87097d3d5ef1d46959d09cfc7e192c4551b87771.1746795452.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/filemap.c       |    2 +-
 mm/khugepaged.c    |    2 +-
 mm/memory.c        |   11 +++++------
 4 files changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-convert-do_set_pmd-to-take-a-folio
+++ a/include/linux/mm.h
@@ -1237,7 +1237,7 @@ static inline pte_t maybe_mkwrite(pte_t
 	return pte;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page);
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page);
 void set_pte_range(struct vm_fault *vmf, struct folio *folio,
 		struct page *page, unsigned int nr, unsigned long addr);
 
--- a/mm/filemap.c~mm-convert-do_set_pmd-to-take-a-folio
+++ a/mm/filemap.c
@@ -3533,7 +3533,7 @@ static bool filemap_map_pmd(struct vm_fa
 
 	if (pmd_none(*vmf->pmd) && folio_test_pmd_mappable(folio)) {
 		struct page *page = folio_file_page(folio, start);
-		vm_fault_t ret = do_set_pmd(vmf, page);
+		vm_fault_t ret = do_set_pmd(vmf, folio, page);
 		if (!ret) {
 			/* The page is mapped successfully, reference consumed. */
 			folio_unlock(folio);
--- a/mm/khugepaged.c~mm-convert-do_set_pmd-to-take-a-folio
+++ a/mm/khugepaged.c
@@ -1478,7 +1478,7 @@ static int set_huge_pmd(struct vm_area_s
 
 	mmap_assert_locked(vma->vm_mm);
 
-	if (do_set_pmd(&vmf, &folio->page))
+	if (do_set_pmd(&vmf, folio, &folio->page))
 		return SCAN_FAIL;
 
 	folio_get(folio);
--- a/mm/memory.c~mm-convert-do_set_pmd-to-take-a-folio
+++ a/mm/memory.c
@@ -5177,9 +5177,8 @@ static void deposit_prealloc_pte(struct
 	vmf->prealloc_pte = NULL;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
 {
-	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
@@ -5252,7 +5251,7 @@ out:
 	return ret;
 }
 #else
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -5346,6 +5345,7 @@ fallback:
 	else
 		page = vmf->page;
 
+	folio = page_folio(page);
 	/*
 	 * check even for read faults because we might have lost our CoWed
 	 * page
@@ -5357,8 +5357,8 @@ fallback:
 	}
 
 	if (pmd_none(*vmf->pmd)) {
-		if (PageTransCompound(page)) {
-			ret = do_set_pmd(vmf, page);
+		if (folio_test_pmd_mappable(folio)) {
+			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
 		}
@@ -5369,7 +5369,6 @@ fallback:
 			return VM_FAULT_OOM;
 	}
 
-	folio = page_folio(page);
 	nr_pages = folio_nr_pages(folio);
 
 	/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp.patch
mm-huge_memory-add-folio_mark_accessed-when-zapping-file-thp-fix.patch
mm-khugepaged-convert-set_huge_pmd-to-take-a-folio.patch
mm-convert-do_set_pmd-to-take-a-folio.patch

