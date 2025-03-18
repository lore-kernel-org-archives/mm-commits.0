Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FE31C1F05
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274504; cv=none; b=eXfb7LFeDaGJo1LvV0e23Y1jQwHCqVVO9up9H3+4euuaK3j1vPHLcmc4fadQ2VGH+UQHLz8fghkVm46RVtwu+/+Tr8PcY14ZY8KHpGI8YnYtGyN1EgNkIYbMW5VSud/VHQ5o/fCXgxjDXKqJBU0Xnk7QS7vn2jJHGZRz0L1bgBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274504; c=relaxed/simple;
	bh=3RpG0uhc7cOFC49gPLxcVcwWpYqSFvZWbiYnahGpiLM=;
	h=Date:To:From:Subject:Message-Id; b=keTadVJbmWjGt25JvYpTz+wXJAyFDVo7CVaItD/DEVtPMSqZi+DTFf4+iH+M3uQDxV9CoxB2hV68YxJloi+O+fzCUJJt1mDP/qD9+6/nZ73FRvZHDvV37fLajsAkY31RIITUKtd4XjdbSefHOxR1Eb1MR2eZ0NTxO/lQMk7NCws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h0Cz7Ncx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h0Cz7Ncx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13C6C4CEEE;
	Tue, 18 Mar 2025 05:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274504;
	bh=3RpG0uhc7cOFC49gPLxcVcwWpYqSFvZWbiYnahGpiLM=;
	h=Date:To:From:Subject:From;
	b=h0Cz7NcxcT9rZv3+4qv5ptPGY3q0k8wt/j4O7eIZJ309LE3XgbLFsBPgp45b0tb8N
	 Nav67B9pxb6VdhQ1np2Lqa2g42eVSn4/FJ4aa9/oXXFefByM18LneYVaSW2CxKs/zy
	 RfmSd9Je4v82KeJalk4TlXrGgdklhw33CTm/DRaQ=
Date: Mon, 17 Mar 2025 22:08:23 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-vmf_insert_folio_pud.patch removed from -mm tree
Message-Id: <20250318050823.E13C6C4CEEE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add vmf_insert_folio_pud()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-vmf_insert_folio_pud.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/huge_memory: add vmf_insert_folio_pud()
Date: Fri, 28 Feb 2025 14:31:10 +1100

Currently DAX folio/page reference counts are managed differently to
normal pages.  To allow these to be managed the same as normal pages
introduce vmf_insert_folio_pud.  This will map the entire PUD-sized folio
and take references as it would for a normally mapped page.

This is distinct from the current mechanism, vmf_insert_pfn_pud, which
simply inserts a special devmap PUD entry into the page table without
holding a reference to the page for the mapping.

Link: https://lkml.kernel.org/r/649a1ef91d556593948351e94f51ef73a14f6794.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Asahi Lina <lina@asahilina.net>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: linmiaohe <linmiaohe@huawei.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael "Camp Drill Sergeant" Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    2 
 mm/huge_memory.c        |   99 +++++++++++++++++++++++++++++++++-----
 2 files changed, 89 insertions(+), 12 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-add-vmf_insert_folio_pud
+++ a/include/linux/huge_mm.h
@@ -39,6 +39,8 @@ int change_huge_pmd(struct mmu_gather *t
 
 vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
 vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
+vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
+				bool write);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_UNSUPPORTED,
--- a/mm/huge_memory.c~mm-huge_memory-add-vmf_insert_folio_pud
+++ a/mm/huge_memory.c
@@ -1482,19 +1482,17 @@ static void insert_pfn_pud(struct vm_are
 	struct mm_struct *mm = vma->vm_mm;
 	pgprot_t prot = vma->vm_page_prot;
 	pud_t entry;
-	spinlock_t *ptl;
 
-	ptl = pud_lock(mm, pud);
 	if (!pud_none(*pud)) {
 		if (write) {
 			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn_t_to_pfn(pfn)))
-				goto out_unlock;
+				return;
 			entry = pud_mkyoung(*pud);
 			entry = maybe_pud_mkwrite(pud_mkdirty(entry), vma);
 			if (pudp_set_access_flags(vma, addr, pud, entry, 1))
 				update_mmu_cache_pud(vma, addr, pud);
 		}
-		goto out_unlock;
+		return;
 	}
 
 	entry = pud_mkhuge(pfn_t_pud(pfn, prot));
@@ -1508,9 +1506,6 @@ static void insert_pfn_pud(struct vm_are
 	}
 	set_pud_at(mm, addr, pud, entry);
 	update_mmu_cache_pud(vma, addr, pud);
-
-out_unlock:
-	spin_unlock(ptl);
 }
 
 /**
@@ -1528,6 +1523,7 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 	unsigned long addr = vmf->address & PUD_MASK;
 	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
+	spinlock_t *ptl;
 
 	/*
 	 * If we had pud_special, we could avoid all these restrictions,
@@ -1545,10 +1541,57 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_
 
 	track_pfn_insert(vma, &pgprot, pfn);
 
+	ptl = pud_lock(vma->vm_mm, vmf->pud);
 	insert_pfn_pud(vma, addr, vmf->pud, pfn, write);
+	spin_unlock(ptl);
+
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pud);
+
+/**
+ * vmf_insert_folio_pud - insert a pud size folio mapped by a pud entry
+ * @vmf: Structure describing the fault
+ * @folio: folio to insert
+ * @write: whether it's a write fault
+ *
+ * Return: vm_fault_t value.
+ */
+vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
+				bool write)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address & PUD_MASK;
+	pud_t *pud = vmf->pud;
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	if (WARN_ON_ONCE(folio_order(folio) != PUD_ORDER))
+		return VM_FAULT_SIGBUS;
+
+	ptl = pud_lock(mm, pud);
+
+	/*
+	 * If there is already an entry present we assume the folio is
+	 * already mapped, hence no need to take another reference. We
+	 * still call insert_pfn_pud() though in case the mapping needs
+	 * upgrading to writeable.
+	 */
+	if (pud_none(*vmf->pud)) {
+		folio_get(folio);
+		folio_add_file_rmap_pud(folio, &folio->page, vma);
+		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
+	}
+	insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)),
+		write);
+	spin_unlock(ptl);
+
+	return VM_FAULT_NOPAGE;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
 #endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
 
 void touch_pmd(struct vm_area_struct *vma, unsigned long addr,
@@ -2146,7 +2189,8 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
 	} else if (is_huge_zero_pmd(orig_pmd)) {
-		zap_deposited_table(tlb->mm, pmd);
+		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
+			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
 	} else {
 		struct folio *folio = NULL;
@@ -2646,12 +2690,24 @@ int zap_huge_pud(struct mmu_gather *tlb,
 	orig_pud = pudp_huge_get_and_clear_full(vma, addr, pud, tlb->fullmm);
 	arch_check_zapped_pud(vma, orig_pud);
 	tlb_remove_pud_tlb_entry(tlb, pud, addr);
-	if (vma_is_special_huge(vma)) {
+	if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {
 		spin_unlock(ptl);
 		/* No zero page support yet */
 	} else {
-		/* No support for anonymous PUD pages yet */
-		BUG();
+		struct page *page = NULL;
+		struct folio *folio;
+
+		/* No support for anonymous PUD pages or migration yet */
+		VM_WARN_ON_ONCE(vma_is_anonymous(vma) ||
+				!pud_present(orig_pud));
+
+		page = pud_page(orig_pud);
+		folio = page_folio(page);
+		folio_remove_rmap_pud(folio, page, vma);
+		add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
+
+		spin_unlock(ptl);
+		tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE);
 	}
 	return 1;
 }
@@ -2659,6 +2715,10 @@ int zap_huge_pud(struct mmu_gather *tlb,
 static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long haddr)
 {
+	struct folio *folio;
+	struct page *page;
+	pud_t old_pud;
+
 	VM_BUG_ON(haddr & ~HPAGE_PUD_MASK);
 	VM_BUG_ON_VMA(vma->vm_start > haddr, vma);
 	VM_BUG_ON_VMA(vma->vm_end < haddr + HPAGE_PUD_SIZE, vma);
@@ -2666,7 +2726,22 @@ static void __split_huge_pud_locked(stru
 
 	count_vm_event(THP_SPLIT_PUD);
 
-	pudp_huge_clear_flush(vma, haddr, pud);
+	old_pud = pudp_huge_clear_flush(vma, haddr, pud);
+
+	if (!vma_is_dax(vma))
+		return;
+
+	page = pud_page(old_pud);
+	folio = page_folio(page);
+
+	if (!folio_test_dirty(folio) && pud_dirty(old_pud))
+		folio_mark_dirty(folio);
+	if (!folio_test_referenced(folio) && pud_young(old_pud))
+		folio_set_referenced(folio);
+	folio_remove_rmap_pud(folio, page, vma);
+	folio_put(folio);
+	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
+		-HPAGE_PUD_NR);
 }
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
_

Patches currently in -mm which might be from apopple@nvidia.com are


