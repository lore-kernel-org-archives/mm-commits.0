Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1EC1E8326
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631390; cv=none; b=R3J8LhhS5x08gIkSy9qNU9iTjxwZZhyZnqyuf8k3h0ZFl0cCksbA2KTQTdrfmCYHz9BKtQyp+8ziuz0i0F68NSPgVtDmsvsghjiy9fXAF5HxN3sFQebO9wfNzyBK67GV2pg424AthoBLkE8gz0BTxXLPiNpsD0jmw00QBZkd7K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631390; c=relaxed/simple;
	bh=KnCqFw+plG+SzuTRHINM50thRRxgfKITtTgZq3IxClo=;
	h=Date:To:From:Subject:Message-Id; b=YGWOWL3BdTTIaEm5xTVIqIG5y25ZknhSETG92UVPDiUlbi+nn7nA7fqZfFDvz9U0wCm/YDO71a3KtK7BK9XxD7gKDUv1wlVhMfA/M3bqG6HthTKcYLB518kZW2sxgHwCly4TXhjg7OOMMtpSNXxSUWNpP+edjWR9fU7M/N0XMV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cxgMmiOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cxgMmiOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D65CBC4CEDD;
	Wed,  2 Apr 2025 22:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631389;
	bh=KnCqFw+plG+SzuTRHINM50thRRxgfKITtTgZq3IxClo=;
	h=Date:To:From:Subject:From;
	b=cxgMmiOLaca5gJwNfnJE8TPHFCqg58qJScOKsZMXB4Ycw0E0/XWsGp8cbQA22/kRn
	 0tA95meTo4mJWOAt7O7ffm4UJp7Km3Yr0yoU0CtxG8GZbR344qhR0CNrWSJr8A2C9N
	 lMw8MI+zWuP6lh90b0NHoaP/Yuc5hQpA0y8/hx7U=
Date: Wed, 02 Apr 2025 15:03:09 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-simplify-make_huge_pte.patch added to mm-new branch
Message-Id: <20250402220309.D65CBC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: simplify make_huge_pte()
has been added to the -mm mm-new branch.  Its filename is
     hugetlb-simplify-make_huge_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-simplify-make_huge_pte.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: simplify make_huge_pte()
Date: Wed, 2 Apr 2025 19:17:02 +0100

mk_huge_pte() is a bad API.  Despite its name, it creates a normal PTE
which is later transformed into a huge PTE by arch_make_huge_pte().  So
replace the page argument with a folio argument and call folio_mk_pte()
instead.  Then, because we now know this is a regular PTE rather than a
huge one, use pte_mkdirty() instead of huge_pte_mkdirty() (and similar
functions).

Link: https://lkml.kernel.org/r/20250402181709.2386022-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/hugetlb.c~hugetlb-simplify-make_huge_pte
+++ a/mm/hugetlb.c
@@ -5441,18 +5441,16 @@ const struct vm_operations_struct hugetl
 	.pagesize = hugetlb_vm_op_pagesize,
 };
 
-static pte_t make_huge_pte(struct vm_area_struct *vma, struct page *page,
+static pte_t make_huge_pte(struct vm_area_struct *vma, struct folio *folio,
 		bool try_mkwrite)
 {
-	pte_t entry;
+	pte_t entry = folio_mk_pte(folio, vma->vm_page_prot);
 	unsigned int shift = huge_page_shift(hstate_vma(vma));
 
 	if (try_mkwrite && (vma->vm_flags & VM_WRITE)) {
-		entry = huge_pte_mkwrite(huge_pte_mkdirty(mk_huge_pte(page,
-					 vma->vm_page_prot)));
+		entry = pte_mkwrite_novma(pte_mkdirty(entry));
 	} else {
-		entry = huge_pte_wrprotect(mk_huge_pte(page,
-					   vma->vm_page_prot));
+		entry = pte_wrprotect(entry);
 	}
 	entry = pte_mkyoung(entry);
 	entry = arch_make_huge_pte(entry, shift, vma->vm_flags);
@@ -5507,7 +5505,7 @@ static void
 hugetlb_install_folio(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr,
 		      struct folio *new_folio, pte_t old, unsigned long sz)
 {
-	pte_t newpte = make_huge_pte(vma, &new_folio->page, true);
+	pte_t newpte = make_huge_pte(vma, new_folio, true);
 
 	__folio_mark_uptodate(new_folio);
 	hugetlb_add_new_anon_rmap(new_folio, vma, addr);
@@ -6257,7 +6255,7 @@ retry_avoidcopy:
 	spin_lock(vmf->ptl);
 	vmf->pte = hugetlb_walk(vma, vmf->address, huge_page_size(h));
 	if (likely(vmf->pte && pte_same(huge_ptep_get(mm, vmf->address, vmf->pte), pte))) {
-		pte_t newpte = make_huge_pte(vma, &new_folio->page, !unshare);
+		pte_t newpte = make_huge_pte(vma, new_folio, !unshare);
 
 		/* Break COW or unshare */
 		huge_ptep_clear_flush(vma, vmf->address, vmf->pte);
@@ -6537,7 +6535,7 @@ static vm_fault_t hugetlb_no_page(struct
 		hugetlb_add_new_anon_rmap(folio, vma, vmf->address);
 	else
 		hugetlb_add_file_rmap(folio);
-	new_pte = make_huge_pte(vma, &folio->page, vma->vm_flags & VM_SHARED);
+	new_pte = make_huge_pte(vma, folio, vma->vm_flags & VM_SHARED);
 	/*
 	 * If this pte was previously wr-protected, keep it wr-protected even
 	 * if populated.
@@ -7022,7 +7020,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	 * For either: (1) CONTINUE on a non-shared VMA, or (2) UFFDIO_COPY
 	 * with wp flag set, don't set pte write bit.
 	 */
-	_dst_pte = make_huge_pte(dst_vma, &folio->page,
+	_dst_pte = make_huge_pte(dst_vma, folio,
 				 !wp_enabled && !(is_continue && !vm_shared));
 	/*
 	 * Always mark UFFDIO_COPY page dirty; note that this may not be
_

Patches currently in -mm which might be from willy@infradead.org are

mm-set-the-pte-dirty-if-the-folio-is-already-dirty.patch
mm-introduce-a-common-definition-of-mk_pte.patch
sparc32-remove-custom-definition-of-mk_pte.patch
x86-remove-custom-definition-of-mk_pte.patch
um-remove-custom-definition-of-mk_pte.patch
mm-make-mk_pte-definition-unconditional.patch
mm-add-folio_mk_pte.patch
hugetlb-simplify-make_huge_pte.patch
mm-remove-mk_huge_pte.patch
mm-add-folio_mk_pmd.patch
arch-remove-mk_pmd.patch
filemap-remove-readahead_page.patch
mm-remove-offset_in_thp.patch
iov_iter-convert-iter_xarray_populate_pages-to-use-folios.patch
iov_iter-convert-iov_iter_extract_xarray_pages-to-use-folios.patch
filemap-remove-find_subpage.patch
filemap-convert-__readahead_batch-to-use-a-folio.patch
filemap-remove-readahead_page_batch.patch
mm-delete-thp_nr_pages.patch

