Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2FB1419A9
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010988; cv=none; b=kvOhwmGUNpqu8iEcaJm0LOszL7xd2pYQJC5Z6Icn8TU65d+6u5V4xk7/cIX3e4Lz1zz4ledNWiwsInCYSRAVPo99QW8nvMW1jLqAxnprtSetOz83HPD8J4kZX2wLqWz0cN6ITIVbW2PzH3+31yGnHL7ER+LQe2qDAl9ahjhPuGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010988; c=relaxed/simple;
	bh=xLz1vmsEmIRoN9WxnFmFbfer8TTsA1ppwABdow5iv5U=;
	h=Date:To:From:Subject:Message-Id; b=rqFcgUTjvaxEfbEKmQAmDXuwFrWZ5mYZyzbYdH5NCWlTU4lcFf8OaWGQ9NJ+D/Pfinr/iUuxryTbjIK+K1kBDr0VWAF2/EnmdDCM8/0HiJ8kgdlpIWD8JzQYGl+KLqmf5FgQKTyjdNVBCSqW9to3RO6vfb/Jmgw44uRJW5vxfXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WRXC2hTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WRXC2hTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0424BC4CEE4;
	Mon, 12 May 2025 00:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010988;
	bh=xLz1vmsEmIRoN9WxnFmFbfer8TTsA1ppwABdow5iv5U=;
	h=Date:To:From:Subject:From;
	b=WRXC2hTIoO1q32NJk6g4upEjtaxb8MUOXD8g9pg0kg6e4P+i+G7/5Ge+V5CIu77pd
	 cbVgQm7hTk6Mb59qbC+QxnvNovBbzgpGI5ymkwEWhNWb2wcZGJf0x3k0D1pHepf9JR
	 EGQd+J62jFwquIMq3l9Jgm2SQR2s/xakw8XkJA14=
Date: Sun, 11 May 2025 17:49:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_mk_pmd.patch removed from -mm tree
Message-Id: <20250512004948.0424BC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add folio_mk_pmd()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_mk_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_mk_pmd()
Date: Wed, 2 Apr 2025 19:17:04 +0100

Removes five conversions from folio to page.  Also removes both callers of
mk_pmd() that aren't part of mk_huge_pmd(), getting us a step closer to
removing the confusion between mk_pmd(), mk_huge_pmd() and pmd_mkhuge().

Link: https://lkml.kernel.org/r/20250402181709.2386022-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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
@@ -1422,8 +1422,7 @@ static vm_fault_t dax_pmd_load_hole(stru
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
@@ -2024,7 +2024,24 @@ static inline pte_t folio_mk_pte(struct
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
 
@@ -4680,7 +4679,7 @@ void remove_migration_pmd(struct page_vm
 
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


