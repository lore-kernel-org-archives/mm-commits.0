Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F11C2F7AD4
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025800; cv=none; b=KaEhFadszVnpScOvD/b2hSPOC9RKt2qulO19fJxlepq1Em8PmNq+8jFXq0b+Pb+n62WS7qjc5np5QjzaMEoDJY/n2voiXgEQQ0FF1xW5XZk2EUJcC/5MTKafPmJx1DXC2P7GjlTv91qVkhO2vfsV9Nh753//ID5jaXnGIjwXrUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025800; c=relaxed/simple;
	bh=PG8UH4BrgQu3royM+oO5p1ACX+klhO9vLiw9u493Lrk=;
	h=Date:To:From:Subject:Message-Id; b=nxe+SGQkf4gucY7erisbG+5k5eFYRHKQFgo9381tCaNrNBV/ABf9zrVGnrqS2HVTlnjwM5ExVizuSnTnnl+fEOaE8z7LYuAVurSoNXWSvvqSHnBeG7alrii7OYaycvXLOLBUz0YUfhVrsdrV9DNYS/J7DeVWCQiTtLvVSHNzpw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=j+jsKAC/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="j+jsKAC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0527BC4CEF1;
	Mon, 24 Nov 2025 23:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025800;
	bh=PG8UH4BrgQu3royM+oO5p1ACX+klhO9vLiw9u493Lrk=;
	h=Date:To:From:Subject:From;
	b=j+jsKAC/L9tkAz5t8ZuHZnjy5GjcoO51W0kHMK17OEx9sxyWK67YotmhHjX6le/sM
	 n5iEeMnl3SevyrpnSrt4xHm83bRpYNIQBnVOSOFYFl7KuW7Vdo7njIXtqMf38eFas3
	 FIPaEwiz+TD7e/93QyeNL46/AgfOwohk7Aj9l7g0=
Date: Mon, 24 Nov 2025 15:09:59 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,usamaarif642@gmail.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch removed from -mm tree
Message-Id: <20251124231000.0527BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: unify pmd folio installation with map_anon_folio_pmd()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[akpm@linux-foundation.org: remove unneeded map_anon_folio_pmd_nopf() stub, per Wei & David]
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

 include/linux/huge_mm.h |    2 ++
 mm/huge_memory.c        |   14 ++++++++++----
 mm/khugepaged.c         |    9 +--------
 3 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/huge_mm.h~mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd
+++ a/include/linux/huge_mm.h
@@ -533,6 +533,8 @@ void split_huge_pmd_locked(struct vm_are
 			   pmd_t *pmd, bool freeze);
 bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 			   pmd_t *pmdp, struct folio *folio);
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr);
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
--- a/mm/huge_memory.c~mm-khugepaged-unify-pmd-folio-installation-with-map_anon_folio_pmd
+++ a/mm/huge_memory.c
@@ -1218,7 +1218,7 @@ static struct folio *vma_alloc_anon_foli
 	return folio;
 }
 
-static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
 		struct vm_area_struct *vma, unsigned long haddr)
 {
 	pmd_t entry;
@@ -1229,11 +1229,17 @@ static void map_anon_folio_pmd(struct fo
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
@@ -1272,7 +1278,7 @@ static vm_fault_t __do_huge_pmd_anonymou
 			return ret;
 		}
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+		map_anon_folio_pmd_pf(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
 		spin_unlock(vmf->ptl);
 	}
@@ -1944,7 +1950,7 @@ static vm_fault_t do_huge_zero_wp_pmd(st
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
@@ -1226,17 +1226,10 @@ static int collapse_huge_page(struct mm_
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


