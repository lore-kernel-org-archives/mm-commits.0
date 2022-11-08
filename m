Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80964C43219
	for <mm-commits@archiver.kernel.org>; Tue,  8 Nov 2022 22:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiKHWAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 17:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbiKHWAA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 17:00:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752ED222A2
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 13:59:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFA76617AB
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 21:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507B0C433D7;
        Tue,  8 Nov 2022 21:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667944795;
        bh=iaF/OlG8KQJRXvFq7uOBEH92y2KGcTkxdoLQkwbeNxM=;
        h=Date:To:From:Subject:From;
        b=SeMLYpDD6fIyb3y37cH5R/tW4tiMTpNfp+oPPFCfzTMSCt5/ip+YWKc2r3to7FKD/
         wdMlvdwPrYEhiJ+HAD+WjWUSHbjbXHwQyxCz8gqGOehgyNl7AtJKKTqZ4EmIxFVevu
         /myM8QLnxtamiL8KB+38oO8VJahwOr6JvF2rfdiY=
Date:   Tue, 08 Nov 2022 13:59:54 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, namit@vmware.com, mpe@ellerman.id.au,
        mgorman@techsingularity.net, hughd@google.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch added to mm-unstable branch
Message-Id: <20221108215955.507B0C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/autonuma: use can_change_(pte|pmd)_writable() to replace savedwrite
has been added to the -mm mm-unstable branch.  Its filename is
     mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/autonuma: use can_change_(pte|pmd)_writable() to replace savedwrite
Date: Tue, 8 Nov 2022 18:46:50 +0100

commit b191f9b106ea ("mm: numa: preserve PTE write permissions across a
NUMA hinting fault") added remembering write permissions using ordinary
pte_write() for PROT_NONE mapped pages to avoid write faults when
remapping the page !PROT_NONE on NUMA hinting faults.

That commit noted:

    The patch looks hacky but the alternatives looked worse. The tidest was
    to rewalk the page tables after a hinting fault but it was more complex
    than this approach and the performance was worse. It's not generally
    safe to just mark the page writable during the fault if it's a write
    fault as it may have been read-only for COW so that approach was
    discarded.

Later, commit 288bc54949fc ("mm/autonuma: let architecture override how
the write bit should be stashed in a protnone pte.") introduced a family
of savedwrite PTE functions that didn't necessarily improve the whole
situation.

One confusing thing is that nowadays, if a page is pte_protnone()
and pte_savedwrite() then also pte_write() is true. Another source of
confusion is that there is only a single pte_mk_savedwrite() call in the
kernel. All other write-protection code seems to silently rely on
pte_wrprotect().

Ever since PageAnonExclusive was introduced and we started using it in
mprotect context via commit 64fe24a3e05e ("mm/mprotect: try avoiding write
faults for exclusive anonymous pages when changing protection"), we do
have machinery in place to avoid write faults when changing protection,
which is exactly what we want to do here.

Let's similarly do what ordinary mprotect() does nowadays when upgrading
write permissions and reuse can_change_pte_writable() and
can_change_pmd_writable() to detect if we can upgrade PTE permissions to be
writable.

For anonymous pages there should be absolutely no change: if an
anonymous page is not exclusive, it could not have been mapped writable --
because only exclusive anonymous pages can be mapped writable.

However, there *might* be a change for writable shared mappings that
require writenotify: if they are not dirty, we cannot map them writable.
While it might not matter in practice, we'd need a different way to
identify whether writenotify is actually required -- and ordinary mprotect
would benefit from that as well.

Note that we don't optimize for the actual migration case:
(1) When migration succeeds the new PTE will not be writable because the
    source PTE was not writable (protnone); in the future we
    might just optimize that case similarly by reusing
    can_change_pte_writable()/can_change_pmd_writable() when removing
    migration PTEs.
(2) When migration fails, we'd have to recalculate the "writable" flag
    because we temporarily dropped the PT lock; for now keep it simple and
    set "writable=false".

We'll remove all savedwrite leftovers next.

Link: https://lkml.kernel.org/r/20221108174652.198904-6-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nadav Amit <namit@vmware.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/huge_memory.c   |   26 +++++++++++++++-----------
 mm/ksm.c           |    9 ++++-----
 mm/memory.c        |   16 +++++++++++++---
 mm/mprotect.c      |    7 ++-----
 5 files changed, 36 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite
+++ a/include/linux/mm.h
@@ -2030,6 +2030,8 @@ static inline bool vma_wants_manual_pte_
 	return !!(vma->vm_flags & VM_WRITE);
 
 }
+bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t pte);
 extern unsigned long change_protection(struct mmu_gather *tlb,
 			      struct vm_area_struct *vma, unsigned long start,
 			      unsigned long end, pgprot_t newprot,
--- a/mm/huge_memory.c~mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite
+++ a/mm/huge_memory.c
@@ -1465,8 +1465,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	unsigned long haddr = vmf->address & HPAGE_PMD_MASK;
 	int page_nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid = (-1 & LAST_CPUPID_MASK);
-	bool migrated = false;
-	bool was_writable = pmd_savedwrite(oldpmd);
+	bool migrated = false, writable = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -1476,12 +1475,22 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	}
 
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
+
+	/*
+	 * Detect now whether the PMD could be writable; this information
+	 * is only valid while holding the PT lock.
+	 */
+	writable = pmd_write(pmd);
+	if (!writable && vma_wants_manual_pte_write_upgrade(vma) &&
+	    can_change_pmd_writable(vma, vmf->address, pmd))
+		writable = true;
+
 	page = vm_normal_page_pmd(vma, haddr, pmd);
 	if (!page)
 		goto out_map;
 
 	/* See similar comment in do_numa_page for explanation */
-	if (!was_writable)
+	if (!writable)
 		flags |= TNF_NO_GROUP;
 
 	page_nid = page_to_nid(page);
@@ -1500,6 +1509,7 @@ vm_fault_t do_huge_pmd_numa_page(struct
 	}
 
 	spin_unlock(vmf->ptl);
+	writable = false;
 
 	migrated = migrate_misplaced_page(page, vma, target_nid);
 	if (migrated) {
@@ -1526,7 +1536,7 @@ out_map:
 	/* Restore the PMD */
 	pmd = pmd_modify(oldpmd, vma->vm_page_prot);
 	pmd = pmd_mkyoung(pmd);
-	if (was_writable)
+	if (writable)
 		pmd = pmd_mkwrite(pmd);
 	set_pmd_at(vma->vm_mm, haddr, vmf->pmd, pmd);
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
@@ -1767,11 +1777,10 @@ int change_huge_pmd(struct mmu_gather *t
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
 	pmd_t oldpmd, entry;
-	bool preserve_write;
-	int ret;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	int ret = 1;
 
 	tlb_change_page_size(tlb, HPAGE_PMD_SIZE);
 
@@ -1782,9 +1791,6 @@ int change_huge_pmd(struct mmu_gather *t
 	if (!ptl)
 		return 0;
 
-	preserve_write = prot_numa && pmd_write(*pmd);
-	ret = 1;
-
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 	if (is_swap_pmd(*pmd)) {
 		swp_entry_t entry = pmd_to_swp_entry(*pmd);
@@ -1864,8 +1870,6 @@ int change_huge_pmd(struct mmu_gather *t
 	oldpmd = pmdp_invalidate_ad(vma, addr, pmd);
 
 	entry = pmd_modify(oldpmd, newprot);
-	if (preserve_write)
-		entry = pmd_mk_savedwrite(entry);
 	if (uffd_wp) {
 		entry = pmd_wrprotect(entry);
 		entry = pmd_mkuffd_wp(entry);
--- a/mm/ksm.c~mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite
+++ a/mm/ksm.c
@@ -1069,7 +1069,6 @@ static int write_protect_page(struct vm_
 
 	anon_exclusive = PageAnonExclusive(page);
 	if (pte_write(*pvmw.pte) || pte_dirty(*pvmw.pte) ||
-	    (pte_protnone(*pvmw.pte) && pte_savedwrite(*pvmw.pte)) ||
 	    anon_exclusive || mm_tlb_flush_pending(mm)) {
 		pte_t entry;
 
@@ -1107,11 +1106,11 @@ static int write_protect_page(struct vm_
 
 		if (pte_dirty(entry))
 			set_page_dirty(page);
+		entry = pte_mkclean(entry);
+
+		if (pte_write(entry))
+			entry = pte_wrprotect(entry);
 
-		if (pte_protnone(entry))
-			entry = pte_mkclean(pte_clear_savedwrite(entry));
-		else
-			entry = pte_mkclean(pte_wrprotect(entry));
 		set_pte_at_notify(mm, pvmw.address, pvmw.pte, entry);
 	}
 	*orig_pte = *pvmw.pte;
--- a/mm/memory.c~mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite
+++ a/mm/memory.c
@@ -4684,10 +4684,10 @@ static vm_fault_t do_numa_page(struct vm
 	struct vm_area_struct *vma = vmf->vma;
 	struct page *page = NULL;
 	int page_nid = NUMA_NO_NODE;
+	bool writable = false;
 	int last_cpupid;
 	int target_nid;
 	pte_t pte, old_pte;
-	bool was_writable = pte_savedwrite(vmf->orig_pte);
 	int flags = 0;
 
 	/*
@@ -4706,6 +4706,15 @@ static vm_fault_t do_numa_page(struct vm
 	old_pte = ptep_get(vmf->pte);
 	pte = pte_modify(old_pte, vma->vm_page_prot);
 
+	/*
+	 * Detect now whether the PTE could be writable; this information
+	 * is only valid while holding the PT lock.
+	 */
+	writable = pte_write(pte);
+	if (!writable && vma_wants_manual_pte_write_upgrade(vma) &&
+	    can_change_pte_writable(vma, vmf->address, pte))
+		writable = true;
+
 	page = vm_normal_page(vma, vmf->address, pte);
 	if (!page || is_zone_device_page(page))
 		goto out_map;
@@ -4722,7 +4731,7 @@ static vm_fault_t do_numa_page(struct vm
 	 * pte_dirty has unpredictable behaviour between PTE scan updates,
 	 * background writeback, dirty balancing and application behaviour.
 	 */
-	if (!was_writable)
+	if (!writable)
 		flags |= TNF_NO_GROUP;
 
 	/*
@@ -4749,6 +4758,7 @@ static vm_fault_t do_numa_page(struct vm
 		goto out_map;
 	}
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
+	writable = false;
 
 	/* Migrate to the requested node */
 	if (migrate_misplaced_page(page, vma, target_nid)) {
@@ -4777,7 +4787,7 @@ out_map:
 	old_pte = ptep_modify_prot_start(vma, vmf->address, vmf->pte);
 	pte = pte_modify(old_pte, vma->vm_page_prot);
 	pte = pte_mkyoung(pte);
-	if (was_writable)
+	if (writable)
 		pte = pte_mkwrite(pte);
 	ptep_modify_prot_commit(vma, vmf->address, vmf->pte, old_pte, pte);
 	update_mmu_cache(vma, vmf->address, vmf->pte);
--- a/mm/mprotect.c~mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite
+++ a/mm/mprotect.c
@@ -39,8 +39,8 @@
 
 #include "internal.h"
 
-static inline bool can_change_pte_writable(struct vm_area_struct *vma,
-					   unsigned long addr, pte_t pte)
+bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
+			     pte_t pte)
 {
 	struct page *page;
 
@@ -121,7 +121,6 @@ static unsigned long change_pte_range(st
 		oldpte = *pte;
 		if (pte_present(oldpte)) {
 			pte_t ptent;
-			bool preserve_write = prot_numa && pte_write(oldpte);
 
 			/*
 			 * Avoid trapping faults against the zero or KSM
@@ -177,8 +176,6 @@ static unsigned long change_pte_range(st
 
 			oldpte = ptep_modify_prot_start(vma, addr, pte);
 			ptent = pte_modify(oldpte, newprot);
-			if (preserve_write)
-				ptent = pte_mk_savedwrite(ptent);
 
 			if (uffd_wp) {
 				ptent = pte_wrprotect(ptent);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory.patch
selftests-vm-anon_cow-test-cow-handling-of-anonymous-memory-fix.patch
selftests-vm-factor-out-pagemap_is_populated-into-vm_util.patch
selftests-vm-anon_cow-thp-tests.patch
selftests-vm-anon_cow-hugetlb-tests.patch
selftests-vm-anon_cow-add-liburing-test-cases.patch
selftests-vm-anon_cow-add-liburing-test-cases-fix.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test.patch
mm-gup_test-start-stop-read-functionality-for-pin-longterm-test-fix.patch
selftests-vm-anon_cow-add-r-o-longterm-tests-via-gup_test.patch
selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch
mm-mprotect-minor-can_change_pte_writable-cleanups.patch
mm-huge_memory-try-avoiding-write-faults-when-changing-pmd-protection.patch
mm-mprotect-factor-out-check-whether-manual-pte-write-upgrades-are-required.patch
mm-autonuma-use-can_change_ptepmd_writable-to-replace-savedwrite.patch
mm-remove-unused-savedwrite-infrastructure.patch
selftests-vm-anon_cow-add-mprotect-optimization-tests.patch

