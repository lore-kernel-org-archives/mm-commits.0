Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C54D212D0B
	for <mm-commits@vger.kernel.org>; Tue,  8 Oct 2024 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728411655; cv=none; b=TOms3DoKmVliIZ6k9JYIaoi7pAet2KYHPuNIdBOp4iY4+K8PnitS1UfDR6mISjCHsWsajU4vumBr1WurXAxanex5sBZmKe6qZmLfxj0pgT5rb0j5uJ+OwEF34NBNvpHfZkSBHYT1ZmyvFY686XmG+aURwb01t/2flw8QpNnHiCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728411655; c=relaxed/simple;
	bh=Y92PVQjMsxQxs1n1PUnDsPz3AMgkCTrdz/WQLc2RmCo=;
	h=Date:To:From:Subject:Message-Id; b=HB7+wdrCSxdnOWJao/o5rFfHaVDetp5XcaOjKCcJAyarxgcSKPhbz6bMsGUarxpO9UZD5adn+hV0NRssxQ1QJrlVby/3jo5DW6ma61h+XuvGTHOYAvT7v765Nb4/ft/QYRmX6fsLsQeYsM/ZXFjlakaWQw13cCFOqK2PC32cuxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=il1tgIXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="il1tgIXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9910C4CEC7;
	Tue,  8 Oct 2024 18:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728411654;
	bh=Y92PVQjMsxQxs1n1PUnDsPz3AMgkCTrdz/WQLc2RmCo=;
	h=Date:To:From:Subject:From;
	b=il1tgIXg22CovsZKjpQQncpxx91n2mswKZISKiSqPCiuFZzhH+Us3nTb2XLE4v+5x
	 C1+x7QLUFzadBpzzGsKo9J142SRNoLyI5soK4S4IFpNa/CxVkqhnS1z/XMmzwEnYLj
	 ep2mzsJMOcaYnKQtuUKsKQnwD4s2iLnp3eqIzlG8=
Date: Tue, 08 Oct 2024 11:20:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,ryan.roberts@arm.com,peterx@redhat.com,mhocko@suse.com,mark.rutland@arm.com,kirill.shutemov@linux.intel.com,jack@suse.cz,ioworker0@gmail.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,cl@gentwo.org,catalin.marinas@arm.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aneesh.kumar@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-abstract-thp-allocation.patch added to mm-unstable branch
Message-Id: <20241008182054.D9910C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: abstract THP allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-abstract-thp-allocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-abstract-thp-allocation.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: mm: abstract THP allocation
Date: Tue, 8 Oct 2024 11:47:45 +0530

Patch series "Do not shatter hugezeropage on wp-fault", v7.

It was observed at [1] and [2] that the current kernel behaviour of
shattering a hugezeropage is inconsistent and suboptimal.  For a VMA with
a THP allowable order, when we write-fault on it, the kernel installs a
PMD-mapped THP.  On the other hand, if we first get a read fault, we get a
PMD pointing to the hugezeropage; subsequent write will trigger a
write-protection fault, shattering the hugezeropage into one writable
page, and all the other PTEs write-protected.  The conclusion being, as
compared to the case of a single write-fault, applications have to suffer
512 extra page faults if they were to use the VMA as such, plus we get the
overhead of khugepaged trying to replace that area with a THP anyway.

Instead, replace the hugezeropage with a THP on wp-fault.

[1]: https://lore.kernel.org/all/3743d7e1-0b79-4eaf-82d5-d1ca29fe347d@arm.com/
[2]: https://lore.kernel.org/all/1cfae0c0-96a2-4308-9c62-f7a640520242@arm.com/


This patch (of 2):

In preparation for the second patch, abstract away the THP allocation
logic present in the create_huge_pmd() path, which corresponds to the
faulting case when no page is present.

There should be no functional change as a result of applying this patch,
except that, as David notes at [1], a PMD-aligned address should be passed
to update_mmu_cache_pmd().

[1]: https://lore.kernel.org/all/ddd3fcd2-48b3-4170-bcaa-2fe66e093f43@redhat.com/

Link: https://lkml.kernel.org/r/20241008061746.285961-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20241008061746.285961-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   98 ++++++++++++++++++++++++++-------------------
 1 file changed, 57 insertions(+), 41 deletions(-)

--- a/mm/huge_memory.c~mm-abstract-thp-allocation
+++ a/mm/huge_memory.c
@@ -1150,47 +1150,81 @@ unsigned long thp_get_unmapped_area(stru
 }
 EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 
-static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf,
-			struct page *page, gfp_t gfp)
+static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
+		unsigned long addr)
 {
-	struct vm_area_struct *vma = vmf->vma;
-	struct folio *folio = page_folio(page);
-	pgtable_t pgtable;
-	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
-	vm_fault_t ret = 0;
+	gfp_t gfp = vma_thp_gfp_mask(vma);
+	const int order = HPAGE_PMD_ORDER;
+	struct folio *folio;
 
-	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
+	folio = vma_alloc_folio(gfp, order, vma, addr & HPAGE_PMD_MASK, true);
 
+	if (unlikely(!folio)) {
+		count_vm_event(THP_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		return NULL;
+	}
+
+	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 	if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
 		folio_put(folio);
 		count_vm_event(THP_FAULT_FALLBACK);
 		count_vm_event(THP_FAULT_FALLBACK_CHARGE);
-		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
-		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
-		return VM_FAULT_FALLBACK;
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK);
+		count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
+		return NULL;
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-	pgtable = pte_alloc_one(vma->vm_mm);
-	if (unlikely(!pgtable)) {
-		ret = VM_FAULT_OOM;
-		goto release;
-	}
-
-	folio_zero_user(folio, vmf->address);
+	folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
 	 * write.
 	 */
 	__folio_mark_uptodate(folio);
+	return folio;
+}
+
+static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
+		struct vm_area_struct *vma, unsigned long haddr)
+{
+	pmd_t entry;
+
+	entry = mk_huge_pmd(&folio->page, vma->vm_page_prot);
+	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
+	folio_add_new_anon_rmap(folio, vma, haddr, RMAP_EXCLUSIVE);
+	folio_add_lru_vma(folio, vma);
+	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
+	update_mmu_cache_pmd(vma, haddr, pmd);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	count_vm_event(THP_FAULT_ALLOC);
+	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
+	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
+}
+
+static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
+{
+	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
+	struct vm_area_struct *vma = vmf->vma;
+	struct folio *folio;
+	pgtable_t pgtable;
+	vm_fault_t ret = 0;
+
+	folio = vma_alloc_anon_folio_pmd(vma, vmf->address);
+	if (unlikely(!folio))
+		return VM_FAULT_FALLBACK;
+
+	pgtable = pte_alloc_one(vma->vm_mm);
+	if (unlikely(!pgtable)) {
+		ret = VM_FAULT_OOM;
+		goto release;
+	}
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	if (unlikely(!pmd_none(*vmf->pmd))) {
 		goto unlock_release;
 	} else {
-		pmd_t entry;
-
 		ret = check_stable_address_space(vma->vm_mm);
 		if (ret)
 			goto unlock_release;
@@ -1204,21 +1238,11 @@ static vm_fault_t __do_huge_pmd_anonymou
 			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			return ret;
 		}
-
-		entry = mk_huge_pmd(page, vma->vm_page_prot);
-		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
-		folio_add_new_anon_rmap(folio, vma, haddr, RMAP_EXCLUSIVE);
-		folio_add_lru_vma(folio, vma);
 		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
-		set_pmd_at(vma->vm_mm, haddr, vmf->pmd, entry);
-		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
-		add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
 		mm_inc_nr_ptes(vma->vm_mm);
 		deferred_split_folio(folio, false);
 		spin_unlock(vmf->ptl);
-		count_vm_event(THP_FAULT_ALLOC);
-		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
-		count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
 	}
 
 	return 0;
@@ -1285,8 +1309,6 @@ static void set_huge_zero_folio(pgtable_
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
-	gfp_t gfp;
-	struct folio *folio;
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	vm_fault_t ret;
 
@@ -1337,14 +1359,8 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 		}
 		return ret;
 	}
-	gfp = vma_thp_gfp_mask(vma);
-	folio = vma_alloc_folio(gfp, HPAGE_PMD_ORDER, vma, haddr, true);
-	if (unlikely(!folio)) {
-		count_vm_event(THP_FAULT_FALLBACK);
-		count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK);
-		return VM_FAULT_FALLBACK;
-	}
-	return __do_huge_pmd_anonymous_page(vmf, &folio->page, gfp);
+
+	return __do_huge_pmd_anonymous_page(vmf);
 }
 
 static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-abstract-thp-allocation.patch
mm-allocate-thp-on-hugezeropage-wp-fault.patch

