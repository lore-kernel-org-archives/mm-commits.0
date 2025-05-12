Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA451E489
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747010984; cv=none; b=fqAS0d2tmzeFyCLMJzUlkMpKgBF9PLYYhpeJh5KJ63NM5VJnL/Zr9yAp2iXMT+4CKFSdgIfIrRBHyDLyFuhKEkjNy2bkuilsq20WqrHOxUSGSK0gn+PQ2GuL5N6uclmaCFUNDKIE0RdPrF/BsK325eLIt8t5icp3iSiaMf1roYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747010984; c=relaxed/simple;
	bh=eIB7DySYlxlhETa41EeDFxVNHUM5K7O2h1rtrLcYz8A=;
	h=Date:To:From:Subject:Message-Id; b=jGCq2D7HT/zxhC4JqmsTBbboZqAV7KYrE2BifQTzyExp0wnuBVFTTRGKpc2UqtbyCr9FzE4YzCzoJz/WOHNMcgWfe520uOLyoZHoWThIgqqaE+zWH3pnqhE6fwvPFkTNsOr1+iUD8bAOQITkG+Rpqd+4QkstErJImLXVQNj3nr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VakQA/Xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VakQA/Xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E47C4CEE4;
	Mon, 12 May 2025 00:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747010984;
	bh=eIB7DySYlxlhETa41EeDFxVNHUM5K7O2h1rtrLcYz8A=;
	h=Date:To:From:Subject:From;
	b=VakQA/Xd+eSwKGCQwasRTbngFolsL+3wwgXts4kBU+tGuci3gLOl7ASk39yGPbCt4
	 zE2TjK+y+XTQX3bbBGf64+GZRgmbwBLbIUkgHjq5rtTbGkKxppGQ5bPd/oIjWysqak
	 gv/q6RnSJK8w+I83Dpk9yOt2ZsMw0KH08/94XHiw=
Date: Sun, 11 May 2025 17:49:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,x86@kernel.org,richard@nod.at,muchun.song@linux.dev,johannes@sipsolutions.net,geert@linux-m68k.org,david@redhat.com,davem@davemloft.net,dave.hansen@linux.intel.com,anton.ivanov@cambridgegreys.com,andreas@gaisler.com,agordeev@linux.ibm.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-folio_mk_pte.patch removed from -mm tree
Message-Id: <20250512004944.25E47C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add folio_mk_pte()
has been removed from the -mm tree.  Its filename was
     mm-add-folio_mk_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_mk_pte()
Date: Wed, 2 Apr 2025 19:17:01 +0100

Remove a cast from folio to page in four callers of mk_pte().

Link: https://lkml.kernel.org/r/20250402181709.2386022-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>
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
@@ -2009,6 +2009,21 @@ static inline pte_t mk_pte(struct page *
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
 	/* Set soft dirty bit so userspace can notice the pte was moved */
 #ifdef CONFIG_MEM_SOFT_DIRTY
 	orig_dst_pte = pte_mksoft_dirty(orig_dst_pte);
_

Patches currently in -mm which might be from willy@infradead.org are


