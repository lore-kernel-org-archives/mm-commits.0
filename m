Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6261F27586F
	for <mm-commits@vger.kernel.org>; Mon,  5 May 2025 22:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746482629; cv=none; b=EtoqG0xQGvDgKOJB3Uvny7t6e75V9uYqa/87p81jUI1lWhO/TJanYEU7F3IwA+fR+4O20pxQyuSuKcnDxHE/oKC222ai1rrZfghlqi5VR3zse+bvwAae0z/UQDPhcxj2yecIyCKQe6WC3JmZSqvYZzSRaFVQt2RCCAIOp3AhKbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746482629; c=relaxed/simple;
	bh=dTnm6yYe4bHWekpmUdpwaHeTtNS8SRdpz3UOnkbUuq8=;
	h=Date:To:From:Subject:Message-Id; b=J+buo2/rH7OKfEyxmhsKQzrrmmxmQ51HheY857FPpQQi+lNvVAetC5em3+xQD4Uh9eAUToA/agTSTEShm4QxLKpcYZ45T0Gfoqwt/LkAd5sxu1ksy13ZiUOIgXwX6f85ghqCNQJtmSR3jNvuUgRkvm2rAvTc4xuAPJ8JMpTA8Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fxR57Tai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fxR57Tai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33BFC4CEE4;
	Mon,  5 May 2025 22:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746482628;
	bh=dTnm6yYe4bHWekpmUdpwaHeTtNS8SRdpz3UOnkbUuq8=;
	h=Date:To:From:Subject:From;
	b=fxR57TaiF2Rj7zp1HfM7cztB+2bwaPmSVcM9QrmXYHQ6jCgyCgVEzDqXNERZ6k1FI
	 wh9pIHd9NeUIzgSlb5Hy4qb15vclplcHg7m4ZoDiAQgjrQbkGx92X8ju+utbGSHeeO
	 I6WxmM3kn0YALob3Mqd+N/gQzkZINFfjFIseAcB0=
Date: Mon, 05 May 2025 15:03:48 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch added to mm-unstable branch
Message-Id: <20250505220348.C33BFC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: pass folio instead of page to unmap_ref_private()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch

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
Subject: mm/hugetlb: pass folio instead of page to unmap_ref_private()
Date: Mon, 5 May 2025 11:22:41 -0700

Patch series "Let unmap_hugepage_range() and several related functions
take folio instead of page".


This patch (of 4):

unmap_ref_private() has only a single user, which passes in &folio->page. 
Let it take the folio directly.

Link: https://lkml.kernel.org/r/20250505182345.506888-2-nifan.cxl@gmail.com
Link: https://lkml.kernel.org/r/20250505182345.506888-3-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private
+++ a/mm/hugetlb.c
@@ -6071,7 +6071,7 @@ void unmap_hugepage_range(struct vm_area
  * same region.
  */
 static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-			      struct page *page, unsigned long address)
+			      struct folio *folio, unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -6115,7 +6115,8 @@ static void unmap_ref_private(struct mm_
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma, address,
-					     address + huge_page_size(h), page, 0);
+					     address + huge_page_size(h),
+					     &folio->page, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
@@ -6238,8 +6239,7 @@ retry_avoidcopy:
 			hugetlb_vma_unlock_read(vma);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 
-			unmap_ref_private(mm, vma, &old_folio->page,
-					vmf->address);
+			unmap_ref_private(mm, vma, old_folio, vmf->address);
 
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 			hugetlb_vma_lock_read(vma);
_

Patches currently in -mm which might be from fan.ni@samsung.com are

mm-convert-free_page_and_swap_cache-to-free_folio_and_swap_cache.patch
khugepaged-pass-folio-instead-of-head-page-to-trace-events.patch
mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch
mm-hugetlb-refactor-unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-refactor-__unmap_hugepage_range-to-take-folio-instead-of-page.patch
mm-hugetlb-convert-use-of-struct-page-to-folio-in-__unmap_hugepage_range.patch

