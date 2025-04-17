Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BABC19CC0A
	for <mm-commits@vger.kernel.org>; Thu, 17 Apr 2025 20:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744921822; cv=none; b=H/qwGfLPsGEa4PPM5sRqHwG1TCM4XM5md2JY3FfNf6VVpsXt1/hGvF8yEORfnBLsH1ZmnHJKP2qe11CmCyr1Q7O9rJ16QTf1CDbV6dtgL39o26LINqjEFnbcdDXe0s/DXClrny7oHaxkdEsE2ryiKVteJNbfwWZKs5f35esjqvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744921822; c=relaxed/simple;
	bh=xZa3ySHkvcvoBDeTw7ZiZLNBBHMlvMbCr1qt9cuc2t4=;
	h=Date:To:From:Subject:Message-Id; b=MYG88QC1AHJsMCn52XuSwqEToxYz+tR8O/VsvtLgcD69bjbEdgMjYAEREAGrGocre0Lt0YvxZcgVFuGsCssNoJX1EvI7tctli0qugwUBAVscsVjB8RZmWKBGxSzUtUYyC+lDGQ73AxR1Zd4e46mGRR0uD/7z4n7SJuW6ciqvkt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ra1XgZ4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ra1XgZ4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2298C4CEEC;
	Thu, 17 Apr 2025 20:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744921822;
	bh=xZa3ySHkvcvoBDeTw7ZiZLNBBHMlvMbCr1qt9cuc2t4=;
	h=Date:To:From:Subject:From;
	b=Ra1XgZ4y8j3x3CnmIHM40uGgzI7y5CPDGD8ETMjnmaBnX9R7679Hb4KoLYuYK6z67
	 PeaXUUIkbPfI/6ztjtk1z69aHE1/y877xwb6NjS8FnJpQ8mRzEWV0hs2AkU33s6ZOP
	 +He6wqqN6P3V06w8dyIaKEL/t99zgd4WOamNBM9M=
Date: Thu, 17 Apr 2025 13:30:21 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch added to mm-unstable branch
Message-Id: <20250417203021.F2298C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: refactor unmap_ref_private() to take folio instead of page
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch

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
From: Fan Ni <fan.ni@samsung.com>
Subject: mm/hugetlb: refactor unmap_ref_private() to take folio instead of page
Date: Thu, 17 Apr 2025 08:43:13 -0700

The function unmap_ref_private() has only user, which passes in
&folio->page.  Let it take folio directly.

Link: https://lkml.kernel.org/r/20250417155530.124073-1-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page
+++ a/mm/hugetlb.c
@@ -6039,7 +6039,7 @@ void unmap_hugepage_range(struct vm_area
  * same region.
  */
 static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-			      struct page *page, unsigned long address)
+			      struct folio *folio, unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -6083,7 +6083,8 @@ static void unmap_ref_private(struct mm_
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma, address,
-					     address + huge_page_size(h), page, 0);
+					     address + huge_page_size(h),
+					     folio_page(folio, 0), 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
@@ -6206,8 +6207,7 @@ retry_avoidcopy:
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-			unmap_ref_private(mm, vma, &old_folio->page,
-					vmf->address);
+			unmap_ref_private(mm, vma, old_folio, vmf->address);
 
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_vma_lock_read(vma);
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-hugetlb-refactor-unmap_ref_private-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-refactor-trace_mm_collapse_huge_page_isolate-to-take-folio-instead-of-page.patch

