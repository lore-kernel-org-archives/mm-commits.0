Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADBD8C1E
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 19:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745868843; cv=none; b=ugSDua5xLwbpZdwrzyKKPGbSeAc44hcb5oNdlcMT1p3zHn6QJXDKEtymBht3EEGH89iwC7UBkbgC4oEG3K47Wcui+72NN0eRPtJTrLoLCu75GqIg6uGtnoW7Mi5jNYinhyvK8ePGc5UrVbUZT75U7jmU9wCwt/s3SZ1D3JLBp8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745868843; c=relaxed/simple;
	bh=w01mTythctKa6vcizIu4HmUvwJypTxYHr0q/6nqreV4=;
	h=Date:To:From:Subject:Message-Id; b=IHQ0XE4iqlCq/B+7TjPby5nuH24nxCDWiEeSF3UwlcYNzUfEar/qloQ5Bmj+eJVVIHVZaGaW7lXyniN53RJoQ8Dj3uONg8ajd6XgIr9YrdgnE5Bnh6HccUO49WIEo1Nv4H63JvPF2ZbEX15/f1jfoFTJb/9ZSvX1bEElJ32eWfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZrLn9Zf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZrLn9Zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3630C4CEE9;
	Mon, 28 Apr 2025 19:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745868843;
	bh=w01mTythctKa6vcizIu4HmUvwJypTxYHr0q/6nqreV4=;
	h=Date:To:From:Subject:From;
	b=jZrLn9Zfp1F7MF5Vej0NGYl35P0VI7aajp7gW0on3GxnqSCF1nI8ARS00eg1IZQFH
	 ymVNVWdbRDZraMrdR3x2KCSRsZu3wmfv6ZypvVI+KLMaOEikJIqJiC4hO9ZS2URSaj
	 Q5/4iMy6qnUDZvf3U/gN5MO9A47B+LxSXuvYsrZg=
Date: Mon, 28 Apr 2025 12:34:02 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,sidhartha.kumar@oracle.com,muchun.song@linux.dev,mcgrof@kernel.org,david@redhat.com,dave@stgolabs.net,a.manzanares@samsung.com,fan.ni@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch added to mm-new branch
Message-Id: <20250428193402.E3630C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: pass folio instead of page to unmap_ref_private()
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private.patch

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
From: Fan Ni <fan.ni@samsung.com>
Subject: mm/hugetlb: pass folio instead of page to unmap_ref_private()
Date: Mon, 28 Apr 2025 10:11:44 -0700

Patch series "mm/hugetlb: Let unmap_hugepage_range() and", v3.


This patch (of 4):

unmap_ref_private() has only user, which passes in &folio->page.  Let it
take folio directly.

Link: https://lkml.kernel.org/r/20250428171608.21111-4-nifan.cxl@gmail.com
Signed-off-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Adam Manzanares <a.manzanares@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-pass-folio-instead-of-page-to-unmap_ref_private
+++ a/mm/hugetlb.c
@@ -6065,7 +6065,7 @@ void unmap_hugepage_range(struct vm_area
  * same region.
  */
 static void unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
-			      struct page *page, unsigned long address)
+			      struct folio *folio, unsigned long address)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct vm_area_struct *iter_vma;
@@ -6109,7 +6109,8 @@ static void unmap_ref_private(struct mm_
 		 */
 		if (!is_vma_resv_set(iter_vma, HPAGE_RESV_OWNER))
 			unmap_hugepage_range(iter_vma, address,
-					     address + huge_page_size(h), page, 0);
+					     address + huge_page_size(h),
+					     &folio->page, 0);
 	}
 	i_mmap_unlock_write(mapping);
 }
@@ -6232,8 +6233,7 @@ retry_avoidcopy:
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

