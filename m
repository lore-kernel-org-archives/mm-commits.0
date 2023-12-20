Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDC84CB38
	for <mm-commits@vger.kernel.org>; Wed, 20 Dec 2023 22:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SL2OmmTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B24C433C7;
	Wed, 20 Dec 2023 22:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703112549;
	bh=5krbhG3KmoRvIZvPwEwq3mRqfx5beAU1c/caLKzCpPE=;
	h=Date:To:From:Subject:From;
	b=SL2OmmTJhESvHLLNyCfbebC6+Grcmf0svNOjS8nkNW3CBDn+CM9tYw+UuXY8b81h9
	 ngIZ/H7nEuPKXOet/K3chqOxqRvAbrwOdwGqZf3lioLVy0rCMqMr1cl0e0i2iGzu2f
	 8i64ItamrrV+CEZwU8H2dW/FsAQEOPPnYsM6L+F0=
Date: Wed, 20 Dec 2023 14:49:09 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,vbabka@suse.cz,shy828301@gmail.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-support-allocation-of-anonymous-multi-size-thp.patch removed from -mm tree
Message-Id: <20231220224909.D5B24C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: support allocation of anonymous multi-size THP
has been removed from the -mm tree.  Its filename was
     mm-thp-support-allocation-of-anonymous-multi-size-thp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: support allocation of anonymous multi-size THP
Date: Thu, 7 Dec 2023 16:12:05 +0000

Introduce the logic to allow THP to be configured (through the new sysfs
interface we just added) to allocate large folios to back anonymous
memory, which are larger than the base page size but smaller than
PMD-size.  We call this new THP extension "multi-size THP" (mTHP).

mTHP continues to be PTE-mapped, but in many cases can still provide
similar benefits to traditional PMD-sized THP: Page faults are
significantly reduced (by a factor of e.g.  4, 8, 16, etc.  depending on
the configured order), but latency spikes are much less prominent because
the size of each page isn't as huge as the PMD-sized variant and there is
less memory to clear in each page fault.  The number of per-page
operations (e.g.  ref counting, rmap management, lru list management) are
also significantly reduced since those ops now become per-folio.

Some architectures also employ TLB compression mechanisms to squeeze more
entries in when a set of PTEs are virtually and physically contiguous and
approporiately aligned.  In this case, TLB misses will occur less often.

The new behaviour is disabled by default, but can be enabled at runtime by
writing to /sys/kernel/mm/transparent_hugepage/hugepage-XXkb/enabled (see
documentation in previous commit).  The long term aim is to change the
default to include suitable lower orders, but there are some risks around
internal fragmentation that need to be better understood first.

[ryan.roberts@arm.com: resolve some multi-size THP review nits]
  Link: https://lkml.kernel.org/r/20231214160251.3574571-1-ryan.roberts@arm.com
Link: https://lkml.kernel.org/r/20231207161211.2374093-5-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    6 +-
 mm/memory.c             |  109 ++++++++++++++++++++++++++++++++++----
 2 files changed, 104 insertions(+), 11 deletions(-)

--- a/include/linux/huge_mm.h~mm-thp-support-allocation-of-anonymous-multi-size-thp
+++ a/include/linux/huge_mm.h
@@ -68,9 +68,11 @@ extern struct kobj_attribute shmem_enabl
 #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
 
 /*
- * Mask of all large folio orders supported for anonymous THP.
+ * Mask of all large folio orders supported for anonymous THP; all orders up to
+ * and including PMD_ORDER, except order-0 (which is not "huge") and order-1
+ * (which is a limitation of the THP implementation).
  */
-#define THP_ORDERS_ALL_ANON	BIT(PMD_ORDER)
+#define THP_ORDERS_ALL_ANON	((BIT(PMD_ORDER + 1) - 1) & ~(BIT(0) | BIT(1)))
 
 /*
  * Mask of all large folio orders supported for file THP.
--- a/mm/memory.c~mm-thp-support-allocation-of-anonymous-multi-size-thp
+++ a/mm/memory.c
@@ -4125,6 +4125,84 @@ out_release:
 	return ret;
 }
 
+static bool pte_range_none(pte_t *pte, int nr_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		if (!pte_none(ptep_get_lockless(pte + i)))
+			return false;
+	}
+
+	return true;
+}
+
+static struct folio *alloc_anon_folio(struct vm_fault *vmf)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long orders;
+	struct folio *folio;
+	unsigned long addr;
+	pte_t *pte;
+	gfp_t gfp;
+	int order;
+
+	/*
+	 * If uffd is active for the vma we need per-page fault fidelity to
+	 * maintain the uffd semantics.
+	 */
+	if (unlikely(userfaultfd_armed(vma)))
+		goto fallback;
+
+	/*
+	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
+	 * for this vma. Then filter out the orders that can't be allocated over
+	 * the faulting address and still be fully contained in the vma.
+	 */
+	orders = thp_vma_allowable_orders(vma, vma->vm_flags, false, true, true,
+					  BIT(PMD_ORDER) - 1);
+	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
+
+	if (!orders)
+		goto fallback;
+
+	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
+	if (!pte)
+		return ERR_PTR(-EAGAIN);
+
+	/*
+	 * Find the highest order where the aligned range is completely
+	 * pte_none(). Note that all remaining orders will be completely
+	 * pte_none().
+	 */
+	order = highest_order(orders);
+	while (orders) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+		if (pte_range_none(pte + pte_index(addr), 1 << order))
+			break;
+		order = next_order(&orders, order);
+	}
+
+	pte_unmap(pte);
+
+	/* Try allocating the highest of the remaining orders. */
+	gfp = vma_thp_gfp_mask(vma);
+	while (orders) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+		folio = vma_alloc_folio(gfp, order, vma, addr, true);
+		if (folio) {
+			clear_huge_page(&folio->page, vmf->address, 1 << order);
+			return folio;
+		}
+		order = next_order(&orders, order);
+	}
+
+fallback:
+#endif
+	return vma_alloc_zeroed_movable_folio(vmf->vma, vmf->address);
+}
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -4134,9 +4212,12 @@ static vm_fault_t do_anonymous_page(stru
 {
 	bool uffd_wp = vmf_orig_pte_uffd_wp(vmf);
 	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address;
 	struct folio *folio;
 	vm_fault_t ret = 0;
+	int nr_pages = 1;
 	pte_t entry;
+	int i;
 
 	/* File mapping without ->vm_ops ? */
 	if (vma->vm_flags & VM_SHARED)
@@ -4176,10 +4257,16 @@ static vm_fault_t do_anonymous_page(stru
 	/* Allocate our own private page. */
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
-	folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
+	/* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the fault */
+	folio = alloc_anon_folio(vmf);
+	if (IS_ERR(folio))
+		return 0;
 	if (!folio)
 		goto oom;
 
+	nr_pages = folio_nr_pages(folio);
+	addr = ALIGN_DOWN(vmf->address, nr_pages * PAGE_SIZE);
+
 	if (mem_cgroup_charge(folio, vma->vm_mm, GFP_KERNEL))
 		goto oom_free_page;
 	folio_throttle_swaprate(folio, GFP_KERNEL);
@@ -4196,12 +4283,15 @@ static vm_fault_t do_anonymous_page(stru
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry), vma);
 
-	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
-			&vmf->ptl);
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
 	if (!vmf->pte)
 		goto release;
-	if (vmf_pte_changed(vmf)) {
-		update_mmu_tlb(vma, vmf->address, vmf->pte);
+	if (nr_pages == 1 && vmf_pte_changed(vmf)) {
+		update_mmu_tlb(vma, addr, vmf->pte);
+		goto release;
+	} else if (nr_pages > 1 && !pte_range_none(vmf->pte, nr_pages)) {
+		for (i = 0; i < nr_pages; i++)
+			update_mmu_tlb(vma, addr + PAGE_SIZE * i, vmf->pte + i);
 		goto release;
 	}
 
@@ -4216,16 +4306,17 @@ static vm_fault_t do_anonymous_page(stru
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
 
-	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
-	folio_add_new_anon_rmap(folio, vma, vmf->address);
+	folio_ref_add(folio, nr_pages - 1);
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	folio_add_new_anon_rmap(folio, vma, addr);
 	folio_add_lru_vma(folio, vma);
 setpte:
 	if (uffd_wp)
 		entry = pte_mkuffd_wp(entry);
-	set_pte_at(vma->vm_mm, vmf->address, vmf->pte, entry);
+	set_ptes(vma->vm_mm, addr, vmf->pte, entry, nr_pages);
 
 	/* No need to invalidate - it was non-present before */
-	update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
+	update_mmu_cache_range(vmf, vma, addr, vmf->pte, nr_pages);
 unlock:
 	if (vmf->pte)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

selftests-mm-log-run_vmtestssh-results-in-tap-format.patch

