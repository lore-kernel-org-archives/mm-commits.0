Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3C61E8326
	for <mm-commits@vger.kernel.org>; Wed,  2 Apr 2025 22:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743631393; cv=none; b=nK3udj6Z9iXStQmsOFMlHYrPfXhDW4yFA8nRauMKr6EuOdAoN2PeRyRDvRdJEk7BuVTDyIn5cu3jAvQ9q9nT4kmfQsBim7Xts8qTuH8UiBX1grXwuD34XbAfx1fL+LcwlwkfBDNfsMURq4VLUNQwF9p+HQiNB1TJ9YUkI1p1v8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743631393; c=relaxed/simple;
	bh=pXLb5T4ozTEReMzChrSMVIhU9k9obvA7gPIHYB1HLgQ=;
	h=Date:To:From:Subject:Message-Id; b=Kcd0mpJrdrApTuYgu2oqAVQQVWQtuMCC2w+cxBvo1gpcAU2GrhbhAAk7u+E/nboRHfJN+Et//cjJkKhS1VRD/y7SxetBYAvbUfniuMZA4tfTGBU804zwdoPvn6xInHF78GBTLHw9izZbuT8J0ckJvKZNPQJovcYi8woRdIAOY2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XweifwWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XweifwWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9AAC4CEDD;
	Wed,  2 Apr 2025 22:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743631392;
	bh=pXLb5T4ozTEReMzChrSMVIhU9k9obvA7gPIHYB1HLgQ=;
	h=Date:To:From:Subject:From;
	b=XweifwWOWDJDbQyQQv2gDIdOynft8B+1cFOXbAvbl0WNwf5k+5/wpei8JRuYxbsvv
	 d6OPFuBS2Si6xMS7WLtJrFYdK2ZOwtyEmJ0V9SMPKR82jrVicpXW4ro8D6kR2Qx5Vj
	 KEuD0vJiW/7A+2+F2bMmrYwlcpNIEv8IcY7OVakI=
Date: Wed, 02 Apr 2025 15:03:11 -0700
To: mm-commits@vger.kernel.org,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_mk_pmd.patch added to mm-new branch
Message-Id: <20250402220312.7A9AAC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add folio_mk_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-add-folio_mk_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_mk_pmd.patch

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
Subject: mm: add folio_mk_pmd()
Date: Wed, 2 Apr 2025 19:17:04 +0100

Removes five conversions from folio to page.  Also removes both callers of
mk_pmd() that aren't part of mk_huge_pmd(), getting us a step closer to
removing the confusion between mk_pmd(), mk_huge_pmd() and pmd_mkhuge().

Link: https://lkml.kernel.org/r/20250402181709.2386022-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Richard Weinberger <richard@nod.at>
Cc: <x86@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c           |    3 +--
 include/linux/mm.h |   17 +++++++++++++++++
 mm/huge_memory.c   |   11 +++++------
 mm/khugepaged.c    |    2 +-
 mm/memory.c        |    2 +-
 5 files changed, 25 insertions(+), 10 deletions(-)

--- a/fs/dax.c~mm-add-folio_mk_pmd
+++ a/fs/dax.c
@@ -1421,8 +1421,7 @@ static vm_fault_t dax_pmd_load_hole(stru
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
 		mm_inc_nr_ptes(vma->vm_mm);
 	}
-	pmd_entry = mk_pmd(&zero_folio->page, vmf->vma->vm_page_prot);
-	pmd_entry = pmd_mkhuge(pmd_entry);
+	pmd_entry = folio_mk_pmd(zero_folio, vmf->vma->vm_page_prot);
 	set_pmd_at(vmf->vma->vm_mm, pmd_addr, vmf->pmd, pmd_entry);
 	spin_unlock(ptl);
 	trace_dax_pmd_load_hole(inode, vmf, zero_folio, *entry);
--- a/include/linux/mm.h~mm-add-folio_mk_pmd
+++ a/include/linux/mm.h
@@ -2007,7 +2007,24 @@ static inline pte_t folio_mk_pte(struct
 {
 	return pfn_pte(folio_pfn(folio), pgprot);
 }
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+/**
+ * folio_mk_pmd - Create a PMD for this folio
+ * @folio: The folio to create a PMD for
+ * @pgprot: The page protection bits to use
+ *
+ * Create a page table entry for the first page of this folio.
+ * This is suitable for passing to set_pmd_at().
+ *
+ * Return: A page table entry suitable for mapping this folio.
+ */
+static inline pmd_t folio_mk_pmd(struct folio *folio, pgprot_t pgprot)
+{
+	return pmd_mkhuge(pfn_pmd(folio_pfn(folio), pgprot));
+}
 #endif
+#endif /* CONFIG_MMU */
 
 static inline bool folio_has_pincount(const struct folio *folio)
 {
--- a/mm/huge_memory.c~mm-add-folio_mk_pmd
+++ a/mm/huge_memory.c
@@ -1203,7 +1203,7 @@ static void map_anon_folio_pmd(struct fo
 {
 	pmd_t entry;
 
-	entry = mk_huge_pmd(&folio->page, vma->vm_page_prot);
+	entry = folio_mk_pmd(folio, vma->vm_page_prot);
 	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 	folio_add_new_anon_rmap(folio, vma, haddr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
@@ -1309,8 +1309,7 @@ static void set_huge_zero_folio(pgtable_
 		struct folio *zero_folio)
 {
 	pmd_t entry;
-	entry = mk_pmd(&zero_folio->page, vma->vm_page_prot);
-	entry = pmd_mkhuge(entry);
+	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	mm_inc_nr_ptes(mm);
@@ -2653,12 +2652,12 @@ int move_pages_huge_pmd(struct mm_struct
 		folio_move_anon_rmap(src_folio, dst_vma);
 		src_folio->index = linear_page_index(dst_vma, dst_addr);
 
-		_dst_pmd = mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot);
+		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
 		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = mk_huge_pmd(src_page, dst_vma->vm_page_prot);
+		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
 	}
 	set_pmd_at(mm, dst_addr, dst_pmd, _dst_pmd);
 
@@ -4675,7 +4674,7 @@ void remove_migration_pmd(struct page_vm
 
 	entry = pmd_to_swp_entry(*pvmw->pmd);
 	folio_get(folio);
-	pmde = mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot));
+	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
 	if (is_writable_migration_entry(entry))
--- a/mm/khugepaged.c~mm-add-folio_mk_pmd
+++ a/mm/khugepaged.c
@@ -1239,7 +1239,7 @@ static int collapse_huge_page(struct mm_
 	__folio_mark_uptodate(folio);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = mk_huge_pmd(&folio->page, vma->vm_page_prot);
+	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
 	spin_lock(pmd_ptl);
--- a/mm/memory.c~mm-add-folio_mk_pmd
+++ a/mm/memory.c
@@ -5188,7 +5188,7 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 
 	flush_icache_pages(vma, page, HPAGE_PMD_NR);
 
-	entry = mk_huge_pmd(page, vma->vm_page_prot);
+	entry = folio_mk_pmd(folio, vma->vm_page_prot);
 	if (write)
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
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

