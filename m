From: akpm@linux-foundation.org
Subject: + mm-convert-p_numa-users-to-p_protnone_numa.patch added to -mm
 tree
Date: Fri, 09 Jan 2015 14:59:06 -0800
Message-ID: <54b05d3a./xr4D4qEuFyxt56o%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbbAIW7H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 17:59:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, davej@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mingo@redhat.com, paulus@samba.org, riel@redhat.com, sasha.levin@oracle.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert p[te|md]_numa users to p[te|md]_protnone_numa
has been added to the -mm tree.  Its filename is
     mm-convert-p_numa-users-to-p_protnone_numa.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-convert-p_numa-users-to-p_protnone_numa.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-convert-p_numa-users-to-p_protnone_numa.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: convert p[te|md]_numa users to p[te|md]_protnone_numa

Convert existing users of pte_numa and friends to the new helper.  Note
that the kernel is broken after this patch is applied until the other page
table modifiers are also altered.  This patch layout is to make review
easier.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kvm/book3s_hv_rm_mmu.c |    2 -
 arch/powerpc/mm/fault.c             |    5 ---
 arch/powerpc/mm/pgtable.c           |   11 +++++--
 arch/powerpc/mm/pgtable_64.c        |    3 +-
 arch/x86/mm/gup.c                   |    4 +-
 include/uapi/linux/mempolicy.h      |    2 -
 mm/gup.c                            |   10 +++----
 mm/huge_memory.c                    |   16 +++++------
 mm/memory.c                         |    4 +-
 mm/mprotect.c                       |   36 ++++++--------------------
 mm/pgtable-generic.c                |    2 -
 11 files changed, 39 insertions(+), 56 deletions(-)

diff -puN arch/powerpc/kvm/book3s_hv_rm_mmu.c~mm-convert-p_numa-users-to-p_protnone_numa arch/powerpc/kvm/book3s_hv_rm_mmu.c
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -212,7 +212,7 @@ long kvmppc_do_h_enter(struct kvm *kvm,
 	/* Look up the Linux PTE for the backing page */
 	pte_size = psize;
 	pte = lookup_linux_pte_and_update(pgdir, hva, writing, &pte_size);
-	if (pte_present(pte) && !pte_numa(pte)) {
+	if (pte_present(pte) && !pte_protnone(pte)) {
 		if (writing && !pte_write(pte))
 			/* make the actual HPTE be read-only */
 			ptel = hpte_make_readonly(ptel);
diff -puN arch/powerpc/mm/fault.c~mm-convert-p_numa-users-to-p_protnone_numa arch/powerpc/mm/fault.c
--- a/arch/powerpc/mm/fault.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/arch/powerpc/mm/fault.c
@@ -398,8 +398,6 @@ good_area:
 		 * processors use the same I/D cache coherency mechanism
 		 * as embedded.
 		 */
-		if (error_code & DSISR_PROTFAULT)
-			goto bad_area;
 #endif /* CONFIG_PPC_STD_MMU */
 
 		/*
@@ -423,9 +421,6 @@ good_area:
 		flags |= FAULT_FLAG_WRITE;
 	/* a read */
 	} else {
-		/* protection fault */
-		if (error_code & 0x08000000)
-			goto bad_area;
 		if (!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))
 			goto bad_area;
 	}
diff -puN arch/powerpc/mm/pgtable.c~mm-convert-p_numa-users-to-p_protnone_numa arch/powerpc/mm/pgtable.c
--- a/arch/powerpc/mm/pgtable.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/arch/powerpc/mm/pgtable.c
@@ -172,9 +172,14 @@ static pte_t set_access_flags_filter(pte
 void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
 		pte_t pte)
 {
-#ifdef CONFIG_DEBUG_VM
-	WARN_ON(pte_val(*ptep) & _PAGE_PRESENT);
-#endif
+	/*
+	 * When handling numa faults, we already have the pte marked
+	 * _PAGE_PRESENT, but we can be sure that it is not in hpte.
+	 * Hence we can use set_pte_at for them.
+	 */
+	VM_WARN_ON((pte_val(*ptep) & (_PAGE_PRESENT | _PAGE_USER)) ==
+		(_PAGE_PRESENT | _PAGE_USER));
+
 	/* Note: mm->context.id might not yet have been assigned as
 	 * this context might not have been activated yet when this
 	 * is called.
diff -puN arch/powerpc/mm/pgtable_64.c~mm-convert-p_numa-users-to-p_protnone_numa arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -718,7 +718,8 @@ void set_pmd_at(struct mm_struct *mm, un
 		pmd_t *pmdp, pmd_t pmd)
 {
 #ifdef CONFIG_DEBUG_VM
-	WARN_ON(pmd_val(*pmdp) & _PAGE_PRESENT);
+	WARN_ON((pmd_val(*pmdp) & (_PAGE_PRESENT | _PAGE_USER)) ==
+		(_PAGE_PRESENT | _PAGE_USER));
 	assert_spin_locked(&mm->page_table_lock);
 	WARN_ON(!pmd_trans_huge(pmd));
 #endif
diff -puN arch/x86/mm/gup.c~mm-convert-p_numa-users-to-p_protnone_numa arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/arch/x86/mm/gup.c
@@ -84,7 +84,7 @@ static noinline int gup_pte_range(pmd_t
 		struct page *page;
 
 		/* Similar to the PMD case, NUMA hinting must take slow path */
-		if (pte_numa(pte)) {
+		if (pte_protnone(pte)) {
 			pte_unmap(ptep);
 			return 0;
 		}
@@ -178,7 +178,7 @@ static int gup_pmd_range(pud_t pud, unsi
 			 * slowpath for accounting purposes and so that they
 			 * can be serialised against THP migration.
 			 */
-			if (pmd_numa(pmd))
+			if (pmd_protnone(pmd))
 				return 0;
 			if (!gup_huge_pmd(pmd, addr, next, write, pages, nr))
 				return 0;
diff -puN include/uapi/linux/mempolicy.h~mm-convert-p_numa-users-to-p_protnone_numa include/uapi/linux/mempolicy.h
--- a/include/uapi/linux/mempolicy.h~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/include/uapi/linux/mempolicy.h
@@ -67,7 +67,7 @@ enum mpol_rebind_step {
 #define MPOL_F_LOCAL   (1 << 1)	/* preferred local allocation */
 #define MPOL_F_REBINDING (1 << 2)	/* identify policies in rebinding */
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
-#define MPOL_F_MORON	(1 << 4) /* Migrate On pte_numa Reference On Node */
+#define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
 
 
 #endif /* _UAPI_LINUX_MEMPOLICY_H */
diff -puN mm/gup.c~mm-convert-p_numa-users-to-p_protnone_numa mm/gup.c
--- a/mm/gup.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/mm/gup.c
@@ -64,7 +64,7 @@ retry:
 		migration_entry_wait(mm, pmd, address);
 		goto retry;
 	}
-	if ((flags & FOLL_NUMA) && pte_numa(pte))
+	if ((flags & FOLL_NUMA) && pte_protnone(pte))
 		goto no_page;
 	if ((flags & FOLL_WRITE) && !pte_write(pte)) {
 		pte_unmap_unlock(ptep, ptl);
@@ -184,7 +184,7 @@ struct page *follow_page_mask(struct vm_
 			return page;
 		return no_page_table(vma, flags);
 	}
-	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
+	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
 		return no_page_table(vma, flags);
 	if (pmd_trans_huge(*pmd)) {
 		if (flags & FOLL_SPLIT) {
@@ -731,10 +731,10 @@ static int gup_pte_range(pmd_t pmd, unsi
 
 		/*
 		 * Similar to the PMD case below, NUMA hinting must take slow
-		 * path
+		 * path using the pte_protnone check.
 		 */
 		if (!pte_present(pte) || pte_special(pte) ||
-			pte_numa(pte) || (write && !pte_write(pte)))
+			pte_protnone(pte) || (write && !pte_write(pte)))
 			goto pte_unmap;
 
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
@@ -929,7 +929,7 @@ static int gup_pmd_range(pud_t pud, unsi
 			 * slowpath for accounting purposes and so that they
 			 * can be serialised against THP migration.
 			 */
-			if (pmd_numa(pmd))
+			if (pmd_protnone(pmd))
 				return 0;
 
 			if (!gup_huge_pmd(pmd, pmdp, addr, next, write,
diff -puN mm/huge_memory.c~mm-convert-p_numa-users-to-p_protnone_numa mm/huge_memory.c
--- a/mm/huge_memory.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/mm/huge_memory.c
@@ -1217,7 +1217,7 @@ struct page *follow_trans_huge_pmd(struc
 		return ERR_PTR(-EFAULT);
 
 	/* Full NUMA hinting faults to serialise migration in fault paths */
-	if ((flags & FOLL_NUMA) && pmd_numa(*pmd))
+	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
 		goto out;
 
 	page = pmd_page(*pmd);
@@ -1348,7 +1348,7 @@ int do_huge_pmd_numa_page(struct mm_stru
 
 	/*
 	 * Migrate the THP to the requested node, returns with page unlocked
-	 * and pmd_numa cleared.
+	 * and access rights restored.
 	 */
 	spin_unlock(ptl);
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
@@ -1363,7 +1363,7 @@ clear_pmdnuma:
 	BUG_ON(!PageLocked(page));
 	pmd = pmd_mknonnuma(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
-	VM_BUG_ON(pmd_numa(*pmdp));
+	VM_BUG_ON(pmd_protnone(*pmdp));
 	update_mmu_cache_pmd(vma, addr, pmdp);
 	unlock_page(page);
 out_unlock:
@@ -1509,7 +1509,7 @@ int change_huge_pmd(struct vm_area_struc
 		ret = 1;
 		if (!prot_numa) {
 			entry = pmdp_get_and_clear_notify(mm, addr, pmd);
-			if (pmd_numa(entry))
+			if (pmd_protnone(entry))
 				entry = pmd_mknonnuma(entry);
 			entry = pmd_modify(entry, newprot);
 			ret = HPAGE_PMD_NR;
@@ -1525,7 +1525,7 @@ int change_huge_pmd(struct vm_area_struc
 			 * local vs remote hits on the zero page.
 			 */
 			if (!is_huge_zero_page(page) &&
-			    !pmd_numa(*pmd)) {
+			    !pmd_protnone(*pmd)) {
 				pmdp_set_numa(mm, addr, pmd);
 				ret = HPAGE_PMD_NR;
 			}
@@ -1793,9 +1793,9 @@ static int __split_huge_page_map(struct
 			pte_t *pte, entry;
 			BUG_ON(PageCompound(page+i));
 			/*
-			 * Note that pmd_numa is not transferred deliberately
-			 * to avoid any possibility that pte_numa leaks to
-			 * a PROT_NONE VMA by accident.
+			 * Note that NUMA hinting access restrictions are not
+			 * transferred to avoid any possibility of altering
+			 * permissions across VMAs.
 			 */
 			entry = mk_pte(page + i, vma->vm_page_prot);
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
diff -puN mm/memory.c~mm-convert-p_numa-users-to-p_protnone_numa mm/memory.c
--- a/mm/memory.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/mm/memory.c
@@ -3121,7 +3121,7 @@ static int handle_pte_fault(struct mm_st
 					pte, pmd, flags, entry);
 	}
 
-	if (pte_numa(entry))
+	if (pte_protnone(entry))
 		return do_numa_page(mm, vma, address, entry, pte, pmd);
 
 	ptl = pte_lockptr(mm, pmd);
@@ -3199,7 +3199,7 @@ static int __handle_mm_fault(struct mm_s
 			if (pmd_trans_splitting(orig_pmd))
 				return 0;
 
-			if (pmd_numa(orig_pmd))
+			if (pmd_protnone(orig_pmd))
 				return do_huge_pmd_numa_page(mm, vma, address,
 							     orig_pmd, pmd);
 
diff -puN mm/mprotect.c~mm-convert-p_numa-users-to-p_protnone_numa mm/mprotect.c
--- a/mm/mprotect.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/mm/mprotect.c
@@ -75,36 +75,18 @@ static unsigned long change_pte_range(st
 		oldpte = *pte;
 		if (pte_present(oldpte)) {
 			pte_t ptent;
-			bool updated = false;
 
-			if (!prot_numa) {
-				ptent = ptep_modify_prot_start(mm, addr, pte);
-				if (pte_numa(ptent))
-					ptent = pte_mknonnuma(ptent);
-				ptent = pte_modify(ptent, newprot);
-				/*
-				 * Avoid taking write faults for pages we
-				 * know to be dirty.
-				 */
-				if (dirty_accountable && pte_dirty(ptent) &&
-				    (pte_soft_dirty(ptent) ||
-				     !(vma->vm_flags & VM_SOFTDIRTY)))
-					ptent = pte_mkwrite(ptent);
-				ptep_modify_prot_commit(mm, addr, pte, ptent);
-				updated = true;
-			} else {
-				struct page *page;
+			ptent = ptep_modify_prot_start(mm, addr, pte);
+			ptent = pte_modify(ptent, newprot);
 
-				page = vm_normal_page(vma, addr, oldpte);
-				if (page && !PageKsm(page)) {
-					if (!pte_numa(oldpte)) {
-						ptep_set_numa(mm, addr, pte);
-						updated = true;
-					}
-				}
+			/* Avoid taking write faults for known dirty pages */
+			if (dirty_accountable && pte_dirty(ptent) &&
+					(pte_soft_dirty(ptent) ||
+					 !(vma->vm_flags & VM_SOFTDIRTY))) {
+				ptent = pte_mkwrite(ptent);
 			}
-			if (updated)
-				pages++;
+			ptep_modify_prot_commit(mm, addr, pte, ptent);
+			pages++;
 		} else if (IS_ENABLED(CONFIG_MIGRATION)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
 
diff -puN mm/pgtable-generic.c~mm-convert-p_numa-users-to-p_protnone_numa mm/pgtable-generic.c
--- a/mm/pgtable-generic.c~mm-convert-p_numa-users-to-p_protnone_numa
+++ a/mm/pgtable-generic.c
@@ -193,7 +193,7 @@ void pmdp_invalidate(struct vm_area_stru
 		     pmd_t *pmdp)
 {
 	pmd_t entry = *pmdp;
-	if (pmd_numa(entry))
+	if (pmd_protnone(entry))
 		entry = pmd_mknonnuma(entry);
 	set_pmd_at(vma->vm_mm, address, pmdp, pmd_mknotpresent(entry));
 	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-debug-pagealloc-prepare-boottime-configurable-on-off.patch
mm-vmscan-prevent-kswapd-livelock-due-to-pfmemalloc-throttled-process-being-killed.patch
mm-page_alloc-place-zone_id-check-before-vm_bug_on_page-check.patch
mm-vmscan-wake-up-all-pfmemalloc-throttled-processes-at-once.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

