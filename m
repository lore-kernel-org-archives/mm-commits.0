Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2158154BE2
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 04:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759982997; cv=none; b=kpgXzM57BS/TrNnUpaZ3wRUTbn096waITVAl1waqtAzlAQkfvzf+J/ezqnRPMeZwQbQhzhtgJFu/Uo0eQqO294Eyq3IrBGdJtNUMP46ILPK+S92n0v7cJZ+ZlUOiqsQcWGrWXVoBvkSYQqfSRu3eBiGt0WXqq84OFSYrMKYlDEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759982997; c=relaxed/simple;
	bh=MnZUTEnsqYuN69Z6o8OJotPK3AWPLuo9IKbTCA3Up4c=;
	h=Date:To:From:Subject:Message-Id; b=j1h/U2279KtKcVM4mxe5+vPyaVq3HMWvEHmq9WI3Tp8mkuDqNVu6NRDjKxe/8FAugdQH//DglVqr6+EBQc7XQkwcs2k3Z2I27VW0UFUpZuotPI/1qeIgYaMmRe8JPCh6ZUPz0Us+yWVb195TTAkdVEaw32ZKaSNi5ui2Y8ezjNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lR6vMO7r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lR6vMO7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ED4C4CEE7;
	Thu,  9 Oct 2025 04:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759982997;
	bh=MnZUTEnsqYuN69Z6o8OJotPK3AWPLuo9IKbTCA3Up4c=;
	h=Date:To:From:Subject:From;
	b=lR6vMO7rWy/yUi6PTR7J/B1e0vMmp65BPzJ1oEnLndcfPZjpRUH8Ft9ZnqFhDOXD6
	 cXxNZ9NSbWxoJY6i2w0AEXYpE4DLvuS+gB20UuuSJoUKZ4X2IqsX2B+oPCMa+/+wur
	 2X9YirhhihZuqmlW00STYkWdHIkMg4589S3/7VFw=
Date: Wed, 08 Oct 2025 21:09:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch added to mm-new branch
Message-Id: <20251009040957.72ED4C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: unify pmd folio installation with map_anon_folio_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: unify pmd folio installation with map_anon_folio_pmd()
Date: Wed, 8 Oct 2025 09:54:53 +0000

Currently we install pmd folio with map_anon_folio_pmd() in
__do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd().  While in
collapse_huge_page(), it is done with identical code except statistics
adjustment.

Unify the process with map_anon_folio_pmd() to install pmd folio.  Split
it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used in
page fault or not respectively.

No functional change is intended.

Link: https://lkml.kernel.org/r/20251008095453.18772-3-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    7 +++++++
 mm/huge_memory.c        |   14 ++++++++++----
 mm/khugepaged.c         |    9 +--------
 3 files changed, 18 insertions(+), 12 deletions(-)

--- a/include/linux/huge_mm.h~mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd
+++ a/include/linux/huge_mm.h
@@ -551,6 +551,8 @@ void split_huge_pmd_locked(struct vm_are
 			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -642,6 +644,11 @@ static inline bool unmap_huge_pmd_locked
 	return false;
 }
 
+static inline void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+}
+
 #define split_huge_pud(__vma, __pmd, __address)	\
 	do { } while (0)
 
--- a/mm/huge_memory.c~mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd
+++ a/mm/huge_memory.c
@@ -1302,7 +1302,7 @@ static struct folio *vma_alloc_anon_foli
 	return folio;
 }
 
-static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 		struct vm_area_struct *vma, unsigned long haddr)
 {
 	pmd_t entry;
@@ -1313,11 +1313,17 @@ static void map_anon_folio_pmd(struct fo
 	folio_add_lru_vma(folio, vma);
 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
 	update_mmu_cache_pmd(vma, haddr, pmd);
+	deferred_split_folio(folio, false);
+}
+
+static void map_anon_folio_pmd_pf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+	map_anon_folio_pmd_nopf(folio, pmd, vma, haddr);
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
-	deferred_split_folio(folio, false);
 }
 
 static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
@@ -1356,7 +1362,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 			return ret;
 		}
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 	}
@@ -2028,7 +2034,7 @@ static vm_fault_t do_huge_zero_wp_pmd(st
 	if (ret)
 		goto release;
 	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
-	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+	map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 	goto unlock;
 release:
 	folio_put(folio);
--- a/mm/khugepaged.c~mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd
+++ a/mm/khugepaged.c
@@ -1311,17 +1311,10 @@ static int collapse_huge_page(struct mm_
 	__folio_mark_uptodate(folio);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = folio_mk_pmd(folio, vma->vm_page_prot);
-	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
-
 	spin_lock(pmd_ptl);
 	BUG_ON(!pmd_none(*pmd));
-	folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSIVE);
-	folio_add_lru_vma(folio, vma);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
-	set_pmd_at(mm, address, pmd, _pmd);
-	update_mmu_cache_pmd(vma, address, pmd);
-	deferred_split_folio(folio, false);
+	map_anon_folio_pmd_nopf(folio, pmd, vma, address);
 	spin_unlock(pmd_ptl);
 
 	folio = NULL;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-compaction-check-the-range-to-pageblock_pfn_to_page-is-within-the-zone-first.patch
mm-compaction-fix-the-range-to-pageblock_pfn_to_page.patch
mm-huge_memory-add-pmd-folio-to-ds_queue-in-do_huge_zero_wp_pmd.patch
mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch

