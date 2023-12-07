Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485FEC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  7 Dec 2023 22:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjLGWEc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 7 Dec 2023 17:04:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbjLGWEb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2023 17:04:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE18122
        for <mm-commits@vger.kernel.org>; Thu,  7 Dec 2023 14:04:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE024C433CA;
        Thu,  7 Dec 2023 22:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1701986676;
        bh=S/mb9i9rtzna5dy2BkIplMQCG6T7VVg4B467WoQfltQ=;
        h=Date:To:From:Subject:From;
        b=Od0Y/qyTWcewWqcog2UJwjvrBpYzHKnllQ3lRzINEbepOcJVanw3S9Zmt1NeDLob5
         l7IAjZwg5Qg3OFsWK3wNR0hHmUwapwMulHI+WY8lDfu/ZWBP3V3nXVUg4Fx/9qxbmx
         lTaL9HuMIogpA5qTOte081wrFjBHaEp6/Bc/fCrY=
Date:   Thu, 07 Dec 2023 14:04:36 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org,
        wangkefeng.wang@huawei.com, v-songbaohua@oppo.com, vbabka@suse.cz,
        shy828301@gmail.com, rientjes@google.com, mcgrof@kernel.org,
        kirill.shutemov@linux.intel.com, jhubbard@nvidia.com,
        itaru.kitayama@gmail.com, hughd@google.com, fengwei.yin@intel.com,
        david@redhat.com, catalin.marinas@arm.com, apopple@nvidia.com,
        anshuman.khandual@arm.com, ryan.roberts@arm.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-support-allocation-of-anonymous-multi-size-thp.patch added to mm-unstable branch
Message-Id: <20231207220436.BE024C433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: thp: support allocation of anonymous multi-size THP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-support-allocation-of-anonymous-multi-size-thp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-support-allocation-of-anonymous-multi-size-thp.patch

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

Link: https://lkml.kernel.org/r/20231207161211.2374093-5-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Tested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
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
 mm/memory.c             |  111 ++++++++++++++++++++++++++++++++++----
 2 files changed, 106 insertions(+), 11 deletions(-)

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
@@ -4125,6 +4125,87 @@ out_release:
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
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static struct folio *alloc_anon_folio(struct vm_fault *vmf)
+{
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
@@ -4134,9 +4215,12 @@ static vm_fault_t do_anonymous_page(stru
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
@@ -4176,10 +4260,15 @@ static vm_fault_t do_anonymous_page(stru
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
@@ -4196,12 +4285,15 @@ static vm_fault_t do_anonymous_page(stru
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
 
@@ -4216,16 +4308,17 @@ static vm_fault_t do_anonymous_page(stru
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

mm-readahead-do-not-allow-order-1-folio.patch
mm-allow-deferred-splitting-of-arbitrary-anon-large-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-thp-introduce-multi-size-thp-sysfs-interface.patch
mm-thp-support-allocation-of-anonymous-multi-size-thp.patch
selftests-mm-kugepaged-restore-thp-settings-at-exit.patch
selftests-mm-factor-out-thp-settings-management.patch
selftests-mm-support-multi-size-thp-interface-in-thp_settings.patch
selftests-mm-khugepaged-enlighten-for-multi-size-thp.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-tests-for-anonymous-multi-size-thp.patch

