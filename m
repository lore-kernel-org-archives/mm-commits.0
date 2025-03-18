Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7411C1F05
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274506; cv=none; b=HoURugt2sQ8zxyxBcRmBHTQqmFzz6jCkmcc+LCFE9fDZCsmS6mUoN8kgPVsPtxPknUoS94Q20NsBAK3AUxKlKxkrbNVSCCtueFAV8SKhFoDYmcLh6rznU8spqda9BbcysemPaqeIHVUEitaZgNxwUo3O7NKn3G3vWmIEujAq3o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274506; c=relaxed/simple;
	bh=DgDySICQoW4Xdld/6RxMvYh4CqQqLlvAXe9rbKHYBGg=;
	h=Date:To:From:Subject:Message-Id; b=b5RdeIb2OvIT/R9jQKfhfitNV9vtLpk4R6Y1LysMnmM4o2ub9+JGxh95ubek25/CEtMr5yScwF0KsDwLb7XKSmZbPfXM9NiYszhZV7cGHdeFFIY5fjeieDM30roS0URplHQyx57fl2b3I9T1Dj9+aZ39p1mZZ9lmj00eg4YzXv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KsakTrl6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KsakTrl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2115C4CEDD;
	Tue, 18 Mar 2025 05:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274505;
	bh=DgDySICQoW4Xdld/6RxMvYh4CqQqLlvAXe9rbKHYBGg=;
	h=Date:To:From:Subject:From;
	b=KsakTrl6Ggt4dOvF1o3M8NX2SA4fgrXt8cbzYOvyxiMC9aSNMEjhO6USU5Q5hTSNc
	 p6hR/gUr9mnJobnQAxV4aw5Z6WDptLWNBnKCJlUztCzL98oOOV2TJDZUe+pSNOYY8I
	 vrL3hZ67zcudllILEdF39tUFh5N9lyq98B2S/Z4U=
Date: Mon, 17 Mar 2025 22:08:25 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,vishal.l.verma@intel.com,vgoyal@redhat.com,tytso@mit.edu,svens@linux.ibm.com,peterx@redhat.com,npiggin@gmail.com,mpe@ellerman.id.au,logang@deltatee.com,linmiaohe@huawei.com,lina@asahilina.net,kernel@xen0n.name,jhubbard@nvidia.com,jgg@ziepe.ca,jgg@nvidia.com,jack@suse.cz,ira.weiny@intel.com,hch@lst.de,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,djwong@kernel.org,david@redhat.com,david@fromorbit.com,dave.jiang@intel.com,dave.hansen@linux.intel.com,dan.j.williams@intel.com,chenhuacai@kernel.org,catalin.marinas@arm.com,borntraeger@linux.ibm.com,bhelgaas@google.com,balbirs@nvidia.com,alison.schofield@intel.com,agordeev@linux.ibm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-add-vmf_insert_folio_pmd.patch removed from -mm tree
Message-Id: <20250318050825.B2115C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: add vmf_insert_folio_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-add-vmf_insert_folio_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/huge_memory: add vmf_insert_folio_pmd()
Date: Fri, 28 Feb 2025 14:31:11 +1100

Currently DAX folio/page reference counts are managed differently to
normal pages.  To allow these to be managed the same as normal pages
introduce vmf_insert_folio_pmd.  This will map the entire PMD-sized folio
and take references as it would for a normally mapped page.

This is distinct from the current mechanism, vmf_insert_pfn_pmd, which
simply inserts a special devmap PMD entry into the page table without
holding a reference to the page for the mapping.

It is not currently useful to implement a more generic vmf_insert_folio()
which selects the correct behaviour based on folio_order().  This is
because PTE faults require only a subpage of the folio to be PTE mapped
rather than the entire folio.  It would be possible to add this context
somewhere but callers already need to handle PTE faults and PMD faults
separately so a more generic function is not useful.

Link: https://lkml.kernel.org/r/7bf92a2e68225d13ea368d53bbfee327314d1c40.1740713401.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
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
Cc: Dan Wiliams <dan.j.williams@intel.com>
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

 include/linux/huge_mm.h |    2 +
 mm/huge_memory.c        |   65 ++++++++++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 12 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-add-vmf_insert_folio_pmd
+++ a/include/linux/huge_mm.h
@@ -39,6 +39,8 @@ int change_huge_pmd(struct mmu_gather *t
 
 vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
 vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
+vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
+				bool write);
 vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio,
 				bool write);
 
--- a/mm/huge_memory.c~mm-huge_memory-add-vmf_insert_folio_pmd
+++ a/mm/huge_memory.c
@@ -1375,20 +1375,20 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 	return __do_huge_pmd_anonymous_page(vmf);
 }
 
-static void insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
+static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
 		pmd_t *pmd, pfn_t pfn, pgprot_t prot, bool write,
 		pgtable_t pgtable)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
-	spinlock_t *ptl;
 
-	ptl = pmd_lock(mm, pmd);
+	lockdep_assert_held(pmd_lockptr(mm, pmd));
+
 	if (!pmd_none(*pmd)) {
 		if (write) {
 			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
-				goto out_unlock;
+				return -EEXIST;
 			}
 			entry = pmd_mkyoung(*pmd);
 			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
@@ -1396,7 +1396,7 @@ static void insert_pfn_pmd(struct vm_are
 				update_mmu_cache_pmd(vma, addr, pmd);
 		}
 
-		goto out_unlock;
+		return -EEXIST;
 	}
 
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
@@ -1412,16 +1412,11 @@ static void insert_pfn_pmd(struct vm_are
 	if (pgtable) {
 		pgtable_trans_huge_deposit(mm, pmd, pgtable);
 		mm_inc_nr_ptes(mm);
-		pgtable = NULL;
 	}
 
 	set_pmd_at(mm, addr, pmd, entry);
 	update_mmu_cache_pmd(vma, addr, pmd);
-
-out_unlock:
-	spin_unlock(ptl);
-	if (pgtable)
-		pte_free(mm, pgtable);
+	return 0;
 }
 
 /**
@@ -1440,6 +1435,8 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
 	pgtable_t pgtable = NULL;
+	spinlock_t *ptl;
+	int error;
 
 	/*
 	 * If we had pmd_special, we could avoid all these restrictions,
@@ -1462,12 +1459,56 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 	}
 
 	track_pfn_insert(vma, &pgprot, pfn);
+	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
+	error = insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write,
+			pgtable);
+	spin_unlock(ptl);
+	if (error && pgtable)
+		pte_free(vma->vm_mm, pgtable);
 
-	insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write, pgtable);
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
 
+vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio,
+				bool write)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address & PMD_MASK;
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+	pgtable_t pgtable = NULL;
+	int error;
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	if (WARN_ON_ONCE(folio_order(folio) != PMD_ORDER))
+		return VM_FAULT_SIGBUS;
+
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (!pgtable)
+			return VM_FAULT_OOM;
+	}
+
+	ptl = pmd_lock(mm, vmf->pmd);
+	if (pmd_none(*vmf->pmd)) {
+		folio_get(folio);
+		folio_add_file_rmap_pmd(folio, &folio->page, vma);
+		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
+	}
+	error = insert_pfn_pmd(vma, addr, vmf->pmd,
+			pfn_to_pfn_t(folio_pfn(folio)), vma->vm_page_prot,
+			write, pgtable);
+	spin_unlock(ptl);
+	if (error && pgtable)
+		pte_free(mm, pgtable);
+
+	return VM_FAULT_NOPAGE;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from apopple@nvidia.com are


