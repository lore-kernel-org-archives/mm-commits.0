Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A52C04E69
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 16:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbjHJQbd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 12:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjHJQbd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 12:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16600E53
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 09:31:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93BE864F63
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 16:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D10C433C8;
        Thu, 10 Aug 2023 16:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691685091;
        bh=+ZVzpOu8F0ap9xB40SlSDfdCpC6Z3L/2zi9GToxqn10=;
        h=Date:To:From:Subject:From;
        b=OLfYQhLG/agALf9S3H1F8qBgjzQDIAcftvleITzJkU0cxsn1V4qoUCC23GT+hwHPq
         a32m5HHVO23hyAEFPuq7mr6mwuPGgkJqSyPyZ/9tZ3FdTrUqwPggGnAGlFx/zq+A/E
         rfKah0wd2Bg38H7QB6g+35msy01AKI4y9mDBsggM=
Date:   Thu, 10 Aug 2023 09:31:30 -0700
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, yuzhao@google.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        mcgrof@kernel.org, kirill.shutemov@linux.intel.com,
        itaru.kitayama@gmail.com, fengwei.yin@intel.com, david@redhat.com,
        catalin.marinas@arm.com, anshuman.khandual@arm.com,
        ryan.roberts@arm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-large_anon_folio-for-improved-performance.patch added to mm-unstable branch
Message-Id: <20230810163130.E3D10C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: LARGE_ANON_FOLIO for improved performance
has been added to the -mm mm-unstable branch.  Its filename is
     mm-large_anon_folio-for-improved-performance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-large_anon_folio-for-improved-performance.patch

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
Subject: mm: LARGE_ANON_FOLIO for improved performance
Date: Thu, 10 Aug 2023 15:29:40 +0100

Introduce LARGE_ANON_FOLIO feature, which allows anonymous memory to be
allocated in large folios of a determined order.  All pages of the large
folio are pte-mapped during the same page fault, significantly reducing
the number of page faults.  The number of per-page operations (e.g.  ref
counting, rmap management lru list management) are also significantly
reduced since those ops now become per-folio.

The new behaviour is hidden behind the new LARGE_ANON_FOLIO Kconfig, which
defaults to disabled for now; The long term aim is for this to defaut to
enabled, but there are some risks around internal fragmentation that need
to be better understood first.

Large anonymous folio (LAF) allocation is integrated with the existing
(PMD-order) THP and single (S) page allocation according to this policy,
where fallback (>) is performed for various reasons, such as the proposed
folio order not fitting within the bounds of the VMA, etc:

                | prctl=dis | prctl=ena   | prctl=ena     | prctl=ena
                | sysfs=X   | sysfs=never | sysfs=madvise | sysfs=always
----------------|-----------|-------------|---------------|-------------
no hint         | S         | LAF>S       | LAF>S         | THP>LAF>S
MADV_HUGEPAGE   | S         | LAF>S       | THP>LAF>S     | THP>LAF>S
MADV_NOHUGEPAGE | S         | S           | S             | S

This approach ensures that we don't violate existing hints to only
allocate single pages - this is required for QEMU's VM live migration
implementation to work correctly - while allowing us to use LAF
independently of THP (when sysfs=never).  This makes wide scale
performance characterization simpler, while avoiding exposing any new ABI
to user space.

When using LAF for allocation, the folio order is determined as follows:
The return value of arch_wants_pte_order() is used.  For vmas that have
not explicitly opted-in to use transparent hugepages (e.g.  where
sysfs=madvise and the vma does not have MADV_HUGEPAGE or sysfs=never),
then arch_wants_pte_order() is limited to 64K (or PAGE_SIZE, whichever is
bigger).  This allows for a performance boost without requiring any
explicit opt-in from the workload while limitting internal fragmentation.

If the preferred order can't be used (e.g.  because the folio would breach
the bounds of the vma, or because ptes in the region are already mapped)
then we fall back to a suitable lower order; first
PAGE_ALLOC_COSTLY_ORDER, then order-0.

arch_wants_pte_order() can be overridden by the architecture if desired. 
Some architectures (e.g.  arm64) can coalsece TLB entries if a contiguous
set of ptes map physically contigious, naturally aligned memory, so this
mechanism allows the architecture to optimize as required.

Here we add the default implementation of arch_wants_pte_order(), used
when the architecture does not define it, which returns -1, implying that
the HW has no preference.  In this case, mm will choose it's own default
order.

Link: https://lkml.kernel.org/r/20230810142942.3169679-4-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang, Ying <ying.huang@intel.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |   13 +++
 mm/Kconfig              |   10 ++
 mm/memory.c             |  144 +++++++++++++++++++++++++++++++++++---
 3 files changed, 158 insertions(+), 9 deletions(-)

--- a/include/linux/pgtable.h~mm-large_anon_folio-for-improved-performance
+++ a/include/linux/pgtable.h
@@ -369,6 +369,19 @@ static inline bool arch_has_hw_pte_young
 }
 #endif
 
+#ifndef arch_wants_pte_order
+/*
+ * Returns preferred folio order for pte-mapped memory. Must be in range [0,
+ * PMD_SHIFT-PAGE_SHIFT) and must not be order-1 since THP requires large folios
+ * to be at least order-2. Negative value implies that the HW has no preference
+ * and mm will choose it's own default order.
+ */
+static inline int arch_wants_pte_order(void)
+{
+	return -1;
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
--- a/mm/Kconfig~mm-large_anon_folio-for-improved-performance
+++ a/mm/Kconfig
@@ -1243,4 +1243,14 @@ config LOCK_MM_AND_FIND_VMA
 
 source "mm/damon/Kconfig"
 
+config LARGE_ANON_FOLIO
+	bool "Allocate large folios for anonymous memory"
+	depends on TRANSPARENT_HUGEPAGE
+	default n
+	help
+	  Use large (bigger than order-0) folios to back anonymous memory where
+	  possible, even for pte-mapped memory. This reduces the number of page
+	  faults, as well as other per-page overheads to improve performance for
+	  many workloads.
+
 endmenu
--- a/mm/memory.c~mm-large_anon_folio-for-improved-performance
+++ a/mm/memory.c
@@ -4073,6 +4073,123 @@ out_release:
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
+#ifdef CONFIG_LARGE_ANON_FOLIO
+#define ANON_FOLIO_MAX_ORDER_UNHINTED \
+		(ilog2(max_t(unsigned long, SZ_64K, PAGE_SIZE)) - PAGE_SHIFT)
+
+static int anon_folio_order(struct vm_area_struct *vma)
+{
+	int order;
+
+	/*
+	 * If the vma is eligible for thp, allocate a large folio of the size
+	 * preferred by the arch. Or if the arch requested a very small size or
+	 * didn't request a size, then use PAGE_ALLOC_COSTLY_ORDER, which still
+	 * meets the arch's requirements but means we still take advantage of SW
+	 * optimizations (e.g. fewer page faults).
+	 *
+	 * If the vma isn't eligible for thp, take the arch-preferred size and
+	 * limit it to ANON_FOLIO_MAX_ORDER_UNHINTED. This ensures workloads
+	 * that have not explicitly opted-in take benefit while capping the
+	 * potential for internal fragmentation.
+	 */
+
+	order = max(arch_wants_pte_order(), PAGE_ALLOC_COSTLY_ORDER);
+
+	if (!hugepage_vma_check(vma, vma->vm_flags, false, true, true))
+		order = min(order, ANON_FOLIO_MAX_ORDER_UNHINTED);
+
+	return order;
+}
+
+static struct folio *alloc_anon_folio(struct vm_fault *vmf)
+{
+	int i;
+	gfp_t gfp;
+	pte_t *pte;
+	unsigned long addr;
+	struct folio *folio;
+	struct vm_area_struct *vma = vmf->vma;
+	int prefer = anon_folio_order(vma);
+	int orders[] = {
+		prefer,
+		prefer > PAGE_ALLOC_COSTLY_ORDER ? PAGE_ALLOC_COSTLY_ORDER : 0,
+		0,
+	};
+
+	/*
+	 * If uffd is active for the vma we need per-page fault fidelity to
+	 * maintain the uffd semantics.
+	 */
+	if (userfaultfd_armed(vma))
+		goto fallback;
+
+	/*
+	 * If hugepages are explicitly disabled for the vma (either
+	 * MADV_NOHUGEPAGE or prctl) fallback to order-0. Failure to do this
+	 * breaks correctness for user space. We ignore the sysfs global knob.
+	 */
+	if (!hugepage_vma_check(vma, vma->vm_flags, false, true, false))
+		goto fallback;
+
+	for (i = 0; orders[i]; i++) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << orders[i]);
+		if (addr >= vma->vm_start &&
+		    addr + (PAGE_SIZE << orders[i]) <= vma->vm_end)
+			break;
+	}
+
+	if (!orders[i])
+		goto fallback;
+
+	pte = pte_offset_map(vmf->pmd, vmf->address & PMD_MASK);
+	if (!pte)
+		return ERR_PTR(-EAGAIN);
+
+	for (; orders[i]; i++) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << orders[i]);
+		vmf->pte = pte + pte_index(addr);
+		if (!vmf_pte_range_changed(vmf, 1 << orders[i]))
+			break;
+	}
+
+	vmf->pte = NULL;
+	pte_unmap(pte);
+
+	gfp = vma_thp_gfp_mask(vma);
+
+	for (; orders[i]; i++) {
+		addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << orders[i]);
+		folio = vma_alloc_folio(gfp, orders[i], vma, addr, true);
+		if (folio) {
+			clear_huge_page(&folio->page, addr, 1 << orders[i]);
+			return folio;
+		}
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
@@ -4080,6 +4197,9 @@ out_release:
  */
 static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 {
+	int i;
+	int nr_pages = 1;
+	unsigned long addr = vmf->address;
 	bool uffd_wp = vmf_orig_pte_uffd_wp(vmf);
 	struct vm_area_struct *vma = vmf->vma;
 	struct folio *folio;
@@ -4124,10 +4244,15 @@ static vm_fault_t do_anonymous_page(stru
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
@@ -4144,12 +4269,12 @@ static vm_fault_t do_anonymous_page(stru
 	if (vma->vm_flags & VM_WRITE)
 		entry = pte_mkwrite(pte_mkdirty(entry));
 
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
 
@@ -4164,16 +4289,17 @@ static vm_fault_t do_anonymous_page(stru
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

selftests-line-buffer-test-programs-stdout.patch
selftests-line-buffer-test-programs-stdout-fix.patch
selftests-mm-skip-soft-dirty-tests-on-arm64.patch
selftests-mm-enable-mrelease_test-for-arm64.patch
selftests-mm-fix-thuge-gen-test-bugs.patch
selftests-mm-va_high_addr_switch-should-skip-unsupported-arm64-configs.patch
selftests-mm-make-migration-test-robust-to-failure.patch
selftests-mm-optionally-pass-duration-to-transhuge-stress.patch
selftests-mm-run-all-tests-from-run_vmtestssh.patch
mm-allow-deferred-splitting-of-arbitrary-large-anon-folios.patch
mm-non-pmd-mappable-large-folios-for-folio_add_new_anon_rmap.patch
mm-large_anon_folio-for-improved-performance.patch
selftests-mm-cow-generalize-do_run_with_thp-helper.patch
selftests-mm-cow-add-large-anon-folio-tests.patch

