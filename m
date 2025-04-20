Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CB1F9E8
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 23:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745191159; cv=none; b=fdw0q4okNTSeAwsTRfgmEYkX8Sngl5K0UgzWv62GuF+9P5rxc/s9v4mRFC6SI99t2AJ0lpJddePaGw+pt4UNlGGEN2waVVIcRxmb8f8rXLxNCWSCoJHJzXCrSa/g8x3TRcjI/HndYm4rAYu45EMhoJwYq2CRFaX4HjKB0PHFMgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745191159; c=relaxed/simple;
	bh=NvWbXLiUCJKp5LwfswM9HjA2LZXIm70yGZ5eD0yweqk=;
	h=Date:To:From:Subject:Message-Id; b=phHx9YfsJymnd6z+2/HBCZLN2a5X5UONsUYcRRyrk8zcFmTL5zbn02xX9u8fyyUUfpw7pMlhSqSvZf1/WQvbydCFsTmoJHlL3eVcBTpEwvjKVBHiIvyeNjqLJ3+PS9B7Daws46W7+TFia+EK3lt6wE2yF9RqOb1TMATsj0m835A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0B9n+3Ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0B9n+3Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8C6C4CEE2;
	Sun, 20 Apr 2025 23:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745191157;
	bh=NvWbXLiUCJKp5LwfswM9HjA2LZXIm70yGZ5eD0yweqk=;
	h=Date:To:From:Subject:From;
	b=0B9n+3LsXcevTYbelKFPLJKMtqHiYeltImMhIYvowx7PCvRCrZtV09wTQCIxbLTZz
	 Tx9qoqLnKY7PP8ycNNW+2KmAELdHP+mZMZMfqPvLYio1CKlPJrVryg1kL8vg0Fwi11
	 2QrYFoWiD1u0KNIhD8nuATgP93V1gqts7aUn+rKQ=
Date: Sun, 20 Apr 2025 16:19:16 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page-v2.patch added to mm-new branch
Message-Id: <20250420231917.0D8C6C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page-v2
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page-v2.patch

This patch will later appear in the mm-new branch at
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
From: Fan Ni <fan.ni@samsung.com>
Subject: mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page-v2
Date: Fri, 18 Apr 2025 09:57:41 -0700

v2: fixed issue mentioned here:
https://lore.kernel.org/linux-mm/aAHUluy7T32ZlYg7@debian/T/#m2b9cc1743e1907e52658815b297b9d249474f387

Link: https://lkml.kernel.org/r/20250418170834.248318-4-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page-v2
+++ a/include/linux/hugetlb.h
@@ -455,7 +455,7 @@ static inline long hugetlb_change_protec
 
 static inline void __unmap_hugepage_range(struct mmu_gather *tlb,
 			struct vm_area_struct *vma, unsigned long start,
-			unsigned long end, struct page *ref_page,
+			unsigned long end, struct folio *ref_folio,
 			zap_flags_t zap_flags)
 {
 	BUG();
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch
khugepaged-refactor-trace_mm_khugepaged_scan_pmd-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page-v2.patch
mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

