Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8AF1E8326
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631388; cv=none; b=Kdhg0jK6VFulvgvHPXCbr5zOyuuGVSHmnUd7+KjSa+fORBzHB9vSzL1Cs4I5AuojZkQLauHbKoxiOCXxLpLxkhRNF82JWHMsXWDGIJdOfgd/qDxIVXzxz2ufl7r/gfImJGjdOhxAGMlFwGqwm/06B78UIHyCKkiHSS1tmScksoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631388; c=relaxed/simple;
	bh=GO0gTqp+a31sT9YmOTyYx+12j/EBvTlRa9AMgRmvT88=;
	h=Date:To:From:Subject:Message-Id; b=AbKTTeIUQGiaArQiFuuYxnXPozrF/n1Ljjr11SCquUEpWPR/74uKV6wBSqZtwe1NFK/SKWyimSzDEQK1X1mblrTjkwiyPwcK44j9FwCfZvdYUvT0TeGEKqCPwHhrznEyNlipQFvCRtZ2tb5LsGVlC5XOpfgJoTo1zhV8TE0W/7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H5EM6dRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H5EM6dRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50807C4CEDD;
	Wed,  2 Apr 2025 22:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631388;
	bh=GO0gTqp+a31sT9YmOTyYx+12j/EBvTlRa9AMgRmvT88=;
	h=Date:To:From:Subject:From;
	b=H5EM6dRW8XYdYB+qxAas2QFd115DCRJxvA7RZo2cjY/Je3xLJl7kAh+87Vdd5hOv1
	 NnDD30AHpsYl+PZWx2GmOhkRVfDWPAWbUEdrFxiWPm5EAuhXKsbq5SjMb8EbzUy6aV
	 PC8kojR9cxiU77islPNQPt6ODEsaUPGlKQbpnaeM=
Date: Wed, 02 Apr 2025 15:03:07 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_mk_pte.patch added to mm-new branch
Message-Id: <20250402220308.50807C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add folio_mk_pte()
has been added to the -mm mm-new branch.  Its filename is
     mm-add-folio_mk_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_mk_pte.patch

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
Subject: mm: add folio_mk_pte()
Date: Wed, 2 Apr 2025 19:17:01 +0100

Remove a cast from folio to page in four callers of mk_pte().

Link: https://lkml.kernel.org/r/20250402181709.2386022-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   15 +++++++++++++++
 mm/memory.c        |    6 +++---
 mm/userfaultfd.c   |    2 +-
 3 files changed, 19 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-add-folio_mk_pte
+++ a/include/linux/mm.h
@@ -1992,6 +1992,21 @@ static inline pte_t mk_pte(struct page *
 {
 	return pfn_pte(page_to_pfn(page), pgprot);
 }
+
+/**
+ * folio_mk_pte - Create a PTE for this folio
+ * @folio: The folio to create a PTE for
+ * @pgprot: The page protection bits to use
+ *
+ * Create a page table entry for the first page of this folio.
+ * This is suitable for passing to set_ptes().
+ *
+ * Return: A page table entry suitable for mapping this folio.
+ */
+static inline pte_t folio_mk_pte(struct folio *folio, pgprot_t pgprot)
+{
+	return pfn_pte(folio_pfn(folio), pgprot);
+}
 #endif
 
 static inline bool folio_has_pincount(const struct folio *folio)
--- a/mm/memory.c~mm-add-folio_mk_pte
+++ a/mm/memory.c
@@ -929,7 +929,7 @@ copy_present_page(struct vm_area_struct
 	rss[MM_ANONPAGES]++;
 
 	/* All done, just insert the new page copy in the child */
-	pte = mk_pte(&new_folio->page, dst_vma->vm_page_prot);
+	pte = folio_mk_pte(new_folio, dst_vma->vm_page_prot);
 	pte = maybe_mkwrite(pte_mkdirty(pte), dst_vma);
 	if (userfaultfd_pte_wp(dst_vma, ptep_get(src_pte)))
 		/* Uffd-wp needs to be delivered to dest pte as well */
@@ -3523,7 +3523,7 @@ static vm_fault_t wp_page_copy(struct vm
 			inc_mm_counter(mm, MM_ANONPAGES);
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
-		entry = mk_pte(&new_folio->page, vma->vm_page_prot);
+		entry = folio_mk_pte(new_folio, vma->vm_page_prot);
 		entry = pte_sw_mkyoung(entry);
 		if (unlikely(unshare)) {
 			if (pte_soft_dirty(vmf->orig_pte))
@@ -5013,7 +5013,7 @@ static vm_fault_t do_anonymous_page(stru
 	 */
 	__folio_mark_uptodate(folio);
 
-	entry = mk_pte(&folio->page, vma->vm_page_prot);
+	entry = folio_mk_pte(folio, vma->vm_page_prot);
 	entry = pte_sw_mkyoung(entry);
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry), vma);
--- a/mm/userfaultfd.c~mm-add-folio_mk_pte
+++ a/mm/userfaultfd.c
@@ -1063,7 +1063,7 @@ static int move_present_pte(struct mm_st
 	folio_move_anon_rmap(src_folio, dst_vma);
 	src_folio->index = linear_page_index(dst_vma, dst_addr);
 
-	orig_dst_pte = mk_pte(&src_folio->page, dst_vma->vm_page_prot);
+	orig_dst_pte = folio_mk_pte(src_folio, dst_vma->vm_page_prot);
 	/* Follow mremap() behavior and treat the entry dirty after the move */
 	orig_dst_pte = pte_mkwrite(pte_mkdirty(orig_dst_pte), dst_vma);
 
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

