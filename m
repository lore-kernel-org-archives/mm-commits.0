Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C326BE728CF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 19:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233847AbjI2TIv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 15:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbjI2TIs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 15:08:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B57193
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 12:08:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ACDC433C7;
        Fri, 29 Sep 2023 19:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696014525;
        bh=df7P62RQkOqJv/JgPMZkhJH4XSnP3e7UwUr8bDcgEHU=;
        h=Date:To:From:Subject:From;
        b=gprSKSuz9TFucFdi401yXtnEMZJpV731GQb4QVDm6mKL1oJhJbN38LFr5oDXbh4j+
         hHwshTLPBCvvCUrwLf/Uz60m6RKUhttpGM9mOWnDujhoFYT6zkCSPiS8qf+d/uLDyW
         RZYp0ojN2Gq8Y6h8jaBvzLhkEIsQKYi4gQdAMQDQ=
Date:   Fri, 29 Sep 2023 12:08:44 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch added to mm-unstable branch
Message-Id: <20230929190845.73ACDC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: extend THP to allocate anonymous large folios
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm: thp: extend THP to allocate anonymous large folios
Date: Fri, 29 Sep 2023 12:44:16 +0100

Introduce the logic to allow THP to be configured (through the new
anon_orders interface we just added) to allocate large folios to back
anonymous memory, which are smaller than PMD-size (for example order-2,
order-3, order-4, etc).

These THPs continue to be PTE-mapped, but in many cases can still provide
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

The new behaviour is disabled by default because the anon_orders defaults
to only enabling PMD-order, but can be enabled at runtime by writing to
anon_orders (see documentation in previous commit).  The long term aim is
to default anon_orders to include suitable lower orders, but there are
some risks around internal fragmentation that need to be better understood
first.

Link: https://lkml.kernel.org/r/20230929114421.3761121-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
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

 Documentation/admin-guide/mm/transhuge.rst |    9 +
 include/linux/huge_mm.h                    |    6 -
 mm/memory.c                                |  108 +++++++++++++++++--
 3 files changed, 111 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/mm/transhuge.rst~mm-thp-extend-thp-to-allocate-anonymous-large-folios
+++ a/Documentation/admin-guide/mm/transhuge.rst
@@ -353,7 +353,9 @@ anonymous transparent huge pages, it is
 ``/proc/PID/smaps`` and count the AnonHugePages and AnonHugePteMap
 fields for each mapping. Note that in both cases, AnonHugePages refers
 only to PMD-mapped THPs. AnonHugePteMap refers to THPs that are mapped
-using PTEs.
+using PTEs. This includes all THPs whose order is smaller than
+PMD-order, as well as any PMD-order THPs that happen to be PTE-mapped
+for other reasons.
 
 The number of file transparent huge pages mapped to userspace is available
 by reading ShmemPmdMapped and ShmemHugePages fields in ``/proc/meminfo``.
@@ -367,6 +369,11 @@ frequently will incur overhead.
 There are a number of counters in ``/proc/vmstat`` that may be used to
 monitor how successfully the system is providing huge pages for use.
 
+.. note::
+   Currently the below counters only record events relating to
+   PMD-order THPs. Events relating to smaller order THPs are not
+   included.
+
 thp_fault_alloc
 	is incremented every time a huge page is successfully
 	allocated to handle a page fault.
--- a/include/linux/huge_mm.h~mm-thp-extend-thp-to-allocate-anonymous-large-folios
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
--- a/mm/memory.c~mm-thp-extend-thp-to-allocate-anonymous-large-folios
+++ a/mm/memory.c
@@ -4115,6 +4115,87 @@ out_release:
 	return ret;
 }
 
+static bool vmf_pte_range_changed(struct vm_fault *vmf, int nr_pages)
+{
+	int i;
+
+	if (nr_pages == 1)
+		return vmf_pte_changed(vmf);
+
+	for (i = 0; i < nr_pages; i++) {
+		if (!pte_none(ptep_get_lockless(vmf->pte + i)))
+			return true;
+	}
+
+	return false;
+}
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static struct folio *alloc_anon_folio(struct vm_fault *vmf)
+{
+	gfp_t gfp;
+	pte_t *pte;
+	unsigned long addr;
+	struct folio *folio;
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned int orders;
+	int order;
+
+	/*
+	 * If uffd is active for the vma we need per-page fault fidelity to
+	 * maintain the uffd semantics.
+	 */
+	if (userfaultfd_armed(vma))
+		goto fallback;
+
+	/*
+	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
+	 * for this vma. Then filter out the orders that can't be allocated over
+	 * the faulting address and still be fully contained in the vma.
+	 */
+	orders = hugepage_vma_check(vma, vma->vm_flags, false, true, true,
+				    BIT(PMD_ORDER) - 1);
+	orders = transhuge_vma_suitable(vma, vmf->address, orders);
+
+	if (!orders)
+		goto fallback;
+
+	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
+	if (!pte)
+		return ERR_PTR(-EAGAIN);
+
+	order = first_order(orders);
+	while (orders) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+		vmf->pte = pte + pte_index(addr);
+		if (!vmf_pte_range_changed(vmf, 1 << order))
+			break;
+		order = next_order(&orders, order);
+	}
+
+	vmf->pte = NULL;
+	pte_unmap(pte);
+
+	gfp = vma_thp_gfp_mask(vma);
+
+	while (orders) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
+		folio = vma_alloc_folio(gfp, order, vma, addr, true);
+		if (folio) {
+			clear_huge_page(&folio->page, addr, 1 << order);
+			return folio;
+		}
+		order = next_order(&orders, order);
+	}
+
+fallback:
+	return vma_alloc_zeroed_movable_folio(vma, vmf->address);
+}
+#else
+#define alloc_anon_folio(vmf) \
+		vma_alloc_zeroed_movable_folio((vmf)->vma, (vmf)->address)
+#endif
+
 /*
  * We enter with non-exclusive mmap_lock (to exclude vma changes,
  * but allow concurrent faults), and pte mapped but not yet locked.
@@ -4122,6 +4203,9 @@ out_release:
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
+	int i;
+	int nr_pages = 1;
+	unsigned long addr = vmf->address;
 	bool uffd_wp = vmf_orig_pte_uffd_wp(vmf);
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *folio;
@@ -4166,10 +4250,15 @@ static vm_fault_t do_anonymous_page(stru
 	/* Allocate our own private page. */
 	if (unlikely(anon_vma_prepare(vma)))
 		goto oom;
-	folio = vma_alloc_zeroed_movable_folio(vma, vmf->address);
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
@@ -4186,12 +4275,12 @@ static vm_fault_t do_anonymous_page(stru
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry), vma);
 
-	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, vmf->address,
-			&vmf->ptl);
+	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd, addr, &vmf->ptl);
 	if (!vmf->pte)
 		goto release;
-	if (vmf_pte_changed(vmf)) {
-		update_mmu_tlb(vma, vmf->address, vmf->pte);
+	if (vmf_pte_range_changed(vmf, nr_pages)) {
+		for (i = 0; i < nr_pages; i++)
+			update_mmu_tlb(vma, addr + PAGE_SIZE * i, vmf->pte + i);
 		goto release;
 	}
 
@@ -4206,16 +4295,17 @@ static vm_fault_t do_anonymous_page(stru
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

mm-hugetlb-add-huge-page-size-param-to-set_huge_pte_at.patch
arm64-hugetlb-fix-set_huge_pte_at-to-work-with-all-swap-entries.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-account-pte-mapped-anonymous-thp-usage.patch
mm-thp-introduce-anon_orders-and-anon_always_mask-sysfs-files.patch
mm-thp-extend-thp-to-allocate-anonymous-large-folios.patch
mm-thp-add-recommend-option-for-anon_orders.patch
arm64-mm-override-arch_wants_pte_order.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-small-order-anon-thp.patch

