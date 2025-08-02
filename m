Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3327E1E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160857; cv=none; b=jE/yh7dVhW02Cof4xP6xPyUYntjJ2gaSLC5j6ybfKJBeudLRUwkbZv96JN4RAeS6zLTMUdx0yfAEP/bWp+tr3CCb54jqCYZODAFN+kvlLyP0Qy9Xt5OtWoCdVy6bEcUS26fGccXIYplvRjhVQIynJofq/uYesWGTbmzp+VOUvPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160857; c=relaxed/simple;
	bh=rQRZLhf2sKDZGWmPY44ShVCKivVo4wmgo5Se6qAuvXg=;
	h=Date:To:From:Subject:Message-Id; b=LhS/Jnbn3iO1rVIl2hfUyw1p3MAbed5dnsbyC0u7SicqT+TPomS4yLZC8WqlZjftGdGzV7rvKXX3XN+7MDhY6iYRHIqSfRwoKtHHq61ix0GJg6iPZhnHTdM17dNHynoxQIPwheMsQyQ86I7kwy7g64Hj7xa/BhoX2t4/xdi9eqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tydqJToF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tydqJToF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0359EC4CEEF;
	Sat,  2 Aug 2025 18:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160857;
	bh=rQRZLhf2sKDZGWmPY44ShVCKivVo4wmgo5Se6qAuvXg=;
	h=Date:To:From:Subject:From;
	b=tydqJToFDTEu5Bu5aL+teOg9IofZaE+6yMgHdifeC+4rlomWRTv0wELEFMS/CggTv
	 rWaz9wAnD1biKY689cAXB4V1zj5/tQ5eMLsWM2DLFClrCFKx9YyoiciVc8A/bjMitP
	 iNMJZZA5Oq305WAALv2OKpnr0tFuCCTfjGzYKmpE=
Date: Sat, 02 Aug 2025 11:54:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,dev.jain@arm.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-get_and_clear_ptes-and-clear_ptes.patch removed from -mm tree
Message-Id: <20250802185417.0359EC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add get_and_clear_ptes() and clear_ptes()
has been removed from the -mm tree.  Its filename was
     mm-add-get_and_clear_ptes-and-clear_ptes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: add get_and_clear_ptes() and clear_ptes()
Date: Thu, 24 Jul 2025 10:52:59 +0530

Patch series "Optimizations for khugepaged", v4.

If the underlying folio mapped by the ptes is large, we can process those
ptes in a batch using folio_pte_batch().

For arm64 specifically, this results in a 16x reduction in the number of
ptep_get() calls, since on a contig block, ptep_get() on arm64 will
iterate through all 16 entries to collect a/d bits.  Next, ptep_clear()
will cause a TLBI for every contig block in the range via
contpte_try_unfold().  Instead, use clear_ptes() to only do the TLBI at
the first and last contig block of the range.

For split folios, there will be no pte batching; the batch size returned
by folio_pte_batch() will be 1.  For pagetable split folios, the ptes will
still point to the same large folio; for arm64, this results in the
optimization described above, and for other arches, a minor improvement is
expected due to a reduction in the number of function calls and batching
atomic operations.


This patch (of 3):

Let's add variants to be used where "full" does not apply -- which will
be the majority of cases in the future. "full" really only applies if
we are about to tear down a full MM.

Use get_and_clear_ptes() in existing code, clear_ptes() users will
be added next.

Link: https://lkml.kernel.org/r/20250724052301.23844-2-dev.jain@arm.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c     |    2 -
 include/linux/pgtable.h |   45 ++++++++++++++++++++++++++++++++++++++
 mm/mremap.c             |    2 -
 mm/rmap.c               |    2 -
 4 files changed, 48 insertions(+), 3 deletions(-)

--- a/arch/arm64/mm/mmu.c~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/arch/arm64/mm/mmu.c
@@ -1528,7 +1528,7 @@ early_initcall(prevent_bootmem_remove_in
 pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t *ptep, unsigned int nr)
 {
-	pte_t pte = get_and_clear_full_ptes(vma->vm_mm, addr, ptep, nr, /* full = */ 0);
+	pte_t pte = get_and_clear_ptes(vma->vm_mm, addr, ptep, nr);
 
 	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_2645198)) {
 		/*
--- a/include/linux/pgtable.h~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/include/linux/pgtable.h
@@ -736,6 +736,29 @@ static inline pte_t get_and_clear_full_p
 }
 #endif
 
+/**
+ * get_and_clear_ptes - Clear present PTEs that map consecutive pages of
+ *			the same folio, collecting dirty/accessed bits.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear.
+ *
+ * Use this instead of get_and_clear_full_ptes() if it is known that we don't
+ * need to clear the full mm, which is mostly the case.
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline pte_t get_and_clear_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, unsigned int nr)
+{
+	return get_and_clear_full_ptes(mm, addr, ptep, nr, 0);
+}
+
 #ifndef clear_full_ptes
 /**
  * clear_full_ptes - Clear present PTEs that map consecutive pages of the same
@@ -768,6 +791,28 @@ static inline void clear_full_ptes(struc
 }
 #endif
 
+/**
+ * clear_ptes - Clear present PTEs that map consecutive pages of the same folio.
+ * @mm: Address space the pages are mapped into.
+ * @addr: Address the first page is mapped at.
+ * @ptep: Page table pointer for the first entry.
+ * @nr: Number of entries to clear.
+ *
+ * Use this instead of clear_full_ptes() if it is known that we don't need to
+ * clear the full mm, which is mostly the case.
+ *
+ * Note that PTE bits in the PTE range besides the PFN can differ. For example,
+ * some PTEs might be write-protected.
+ *
+ * Context: The caller holds the page table lock.  The PTEs map consecutive
+ * pages that belong to the same folio.  The PTEs are all in the same PMD.
+ */
+static inline void clear_ptes(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, unsigned int nr)
+{
+	clear_full_ptes(mm, addr, ptep, nr, 0);
+}
+
 /*
  * If two threads concurrently fault at the same page, the thread that
  * won the race updates the PTE and its local TLB/Cache. The other thread
--- a/mm/mremap.c~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/mm/mremap.c
@@ -280,7 +280,7 @@ static int move_ptes(struct pagetable_mo
 							 old_pte, max_nr_ptes);
 			force_flush = true;
 		}
-		pte = get_and_clear_full_ptes(mm, old_addr, old_ptep, nr_ptes, 0);
+		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
 
--- a/mm/rmap.c~mm-add-get_and_clear_ptes-and-clear_ptes
+++ a/mm/rmap.c
@@ -2036,7 +2036,7 @@ static bool try_to_unmap_one(struct foli
 			flush_cache_range(vma, address, end_addr);
 
 			/* Nuke the page table entry. */
-			pteval = get_and_clear_full_ptes(mm, address, pvmw.pte, nr_pages, 0);
+			pteval = get_and_clear_ptes(mm, address, pvmw.pte, nr_pages);
 			/*
 			 * We clear the PTE but do not flush so potentially
 			 * a remote CPU could still be writing to the folio.
_

Patches currently in -mm which might be from david@redhat.com are


