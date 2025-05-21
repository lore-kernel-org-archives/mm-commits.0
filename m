Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1F4233728
	for <mm-commits@vger.kernel.org>; Wed, 21 May 2025 16:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846642; cv=none; b=QPv/iAWP3WgMEK4PCe37CH2wvyE1s7leYEFl66MLHuwac41jXLysWpwZGxlLEhsXtiszzZVF/xgk+5XV0pB9lB5Ry7XsTZUuL5FP1R5tqJY2ymyCsTKUFOLM87SrDXbNlA3TzH/NzaFlkqSsXlo0QgpE0TyzVQBh9RLewc0iAGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846642; c=relaxed/simple;
	bh=H4Q4QCoWWS2HV1C31bKXjE+rOhbDc/RykF0wbRNyJa4=;
	h=Date:To:From:Subject:Message-Id; b=sKeWmzuhM/yijVU1mIpqCVNCv3v/ARWXeiPFWfQMPJPIyq1UXNafj8YL5N5GBeIGxlyAKjd5RKAlZy2MNJrzX7HHX59KUvDcpilbQoV7oGClZJcWYGK7/KrWPgsjO4AWgakEXCwzuOa2c9sL6FwA4v0I58FiT+gmxbXbLzsBHik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1ykv/d0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1ykv/d0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63D5C4CEE4;
	Wed, 21 May 2025 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747846641;
	bh=H4Q4QCoWWS2HV1C31bKXjE+rOhbDc/RykF0wbRNyJa4=;
	h=Date:To:From:Subject:From;
	b=1ykv/d0rspgF5AbMnCY4xFxGZAFoULYu0+1QkRokdlWErfzPagodz285YqfurELIi
	 SmlYl6OPXU135dk6+hhffxZYiBVSzLLesGAf2h+1RuReqRRWBgPAOeqQidDugoqEyK
	 udmZVk1pJAC0eHU0vjpN4ik7aAw2u6Jq4qXxu4Io=
Date: Wed, 21 May 2025 09:57:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_set_pmd-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250521165721.D63D5C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert do_set_pmd() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-convert-do_set_pmd-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: convert do_set_pmd() to take a folio
Date: Mon, 12 May 2025 10:57:12 +0800

In do_set_pmd(), we always use the folio->page to build PMD mappings for
the entire folio.  Since all callers of do_set_pmd() already hold a stable
folio, converting do_set_pmd() to take a folio is safe and more
straightforward.

In addition, to ensure the extensibility of do_set_pmd() for supporting
larger folios beyond PMD size, we keep the 'page' parameter to specify
which page within the folio should be mapped.

No functional changes expected.

Link: https://lkml.kernel.org/r/9b488f4ecb4d3fd8634e3d448dd0ed6964482480.1747017104.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 +-
 mm/filemap.c       |    2 +-
 mm/khugepaged.c    |    2 +-
 mm/memory.c        |   11 +++++------
 4 files changed, 8 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-convert-do_set_pmd-to-take-a-folio
+++ a/include/linux/mm.h
@@ -1235,7 +1235,7 @@ static inline pte_t maybe_mkwrite(pte_t
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
 
-	if (do_set_pmd(&vmf, page))
+	if (do_set_pmd(&vmf, folio, page))
 		return SCAN_FAIL;
 
 	folio_get(folio);
--- a/mm/memory.c~mm-convert-do_set_pmd-to-take-a-folio
+++ a/mm/memory.c
@@ -5227,9 +5227,8 @@ static void deposit_prealloc_pte(struct
 	vmf->prealloc_pte = NULL;
 }
 
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
 {
-	struct folio *folio = page_folio(page);
 	struct vm_area_struct *vma = vmf->vma;
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
@@ -5302,7 +5301,7 @@ out:
 	return ret;
 }
 #else
-vm_fault_t do_set_pmd(struct vm_fault *vmf, struct page *page)
+vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *page)
 {
 	return VM_FAULT_FALLBACK;
 }
@@ -5396,6 +5395,7 @@ fallback:
 	else
 		page = vmf->page;
 
+	folio = page_folio(page);
 	/*
 	 * check even for read faults because we might have lost our CoWed
 	 * page
@@ -5407,8 +5407,8 @@ fallback:
 	}
 
 	if (pmd_none(*vmf->pmd)) {
-		if (PageTransCompound(page)) {
-			ret = do_set_pmd(vmf, page);
+		if (folio_test_pmd_mappable(folio)) {
+			ret = do_set_pmd(vmf, folio, page);
 			if (ret != VM_FAULT_FALLBACK)
 				return ret;
 		}
@@ -5419,7 +5419,6 @@ fallback:
 			return VM_FAULT_OOM;
 	}
 
-	folio = page_folio(page);
 	nr_pages = folio_nr_pages(folio);
 
 	/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


