Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170F1C4321E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiLAAEJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiLAACc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:02:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A38387CAA
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15E3961E22
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F833C433D7;
        Thu,  1 Dec 2022 00:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852874;
        bh=DgJRsW4M1MHvE/v4CprQpPiYii4CKxwUWj9Y0TAUAWY=;
        h=Date:To:From:Subject:From;
        b=VekL9pxuazSZflK7cw3erh/nXy6tBZDl6HisgT+tSWU0lZnqseggczHnR72MDrxU0
         WpyP2Oa1+95dm/R6Au+3VtUaMjrNQcQmix7nSjaGYtBa7Hq88pDL9T3xvk2jJ8ccv+
         HUluyWQhTZuSX0wmSqZcDhM4xixmiRag3NKp1Khw=
Date:   Wed, 30 Nov 2022 16:01:13 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org, peterx@redhat.com,
        npiggin@gmail.com, namit@vmware.com, mpe@ellerman.id.au,
        mgorman@techsingularity.net, hughd@google.com, david@fromorbit.com,
        anshuman.khandual@arm.com, aarcange@redhat.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unused-savedwrite-infrastructure.patch removed from -mm tree
Message-Id: <20221201000114.5F833C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove unused savedwrite infrastructure
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-savedwrite-infrastructure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm: remove unused savedwrite infrastructure
Date: Tue, 8 Nov 2022 18:46:51 +0100

NUMA hinting no longer uses savedwrite, let's rip it out.

... and while at it, drop __pte_write() and __pmd_write() on ppc64.

Link: https://lkml.kernel.org/r/20221108174652.198904-7-david@redhat.com
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

 arch/powerpc/include/asm/book3s/64/pgtable.h |   80 -----------------
 arch/powerpc/kvm/book3s_hv_rm_mmu.c          |    2 
 include/linux/pgtable.h                      |   24 -----
 mm/debug_vm_pgtable.c                        |   32 ------
 4 files changed, 5 insertions(+), 133 deletions(-)

--- a/arch/powerpc/include/asm/book3s/64/pgtable.h~mm-remove-unused-savedwrite-infrastructure
+++ a/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -401,35 +401,9 @@ static inline int __ptep_test_and_clear_
 #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
 #define pmdp_clear_flush_young pmdp_test_and_clear_young
 
-static inline int __pte_write(pte_t pte)
-{
-	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_WRITE));
-}
-
-#ifdef CONFIG_NUMA_BALANCING
-#define pte_savedwrite pte_savedwrite
-static inline bool pte_savedwrite(pte_t pte)
-{
-	/*
-	 * Saved write ptes are prot none ptes that doesn't have
-	 * privileged bit sit. We mark prot none as one which has
-	 * present and pviliged bit set and RWX cleared. To mark
-	 * protnone which used to have _PAGE_WRITE set we clear
-	 * the privileged bit.
-	 */
-	return !(pte_raw(pte) & cpu_to_be64(_PAGE_RWX | _PAGE_PRIVILEGED));
-}
-#else
-#define pte_savedwrite pte_savedwrite
-static inline bool pte_savedwrite(pte_t pte)
-{
-	return false;
-}
-#endif
-
 static inline int pte_write(pte_t pte)
 {
-	return __pte_write(pte) || pte_savedwrite(pte);
+	return !!(pte_raw(pte) & cpu_to_be64(_PAGE_WRITE));
 }
 
 static inline int pte_read(pte_t pte)
@@ -441,24 +415,16 @@ static inline int pte_read(pte_t pte)
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
 {
-	if (__pte_write(*ptep))
+	if (pte_write(*ptep))
 		pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 0);
-	else if (unlikely(pte_savedwrite(*ptep)))
-		pte_update(mm, addr, ptep, 0, _PAGE_PRIVILEGED, 0);
 }
 
 #define __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
 {
-	/*
-	 * We should not find protnone for hugetlb, but this complete the
-	 * interface.
-	 */
-	if (__pte_write(*ptep))
+	if (pte_write(*ptep))
 		pte_update(mm, addr, ptep, _PAGE_WRITE, 0, 1);
-	else if (unlikely(pte_savedwrite(*ptep)))
-		pte_update(mm, addr, ptep, 0, _PAGE_PRIVILEGED, 1);
 }
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
@@ -535,36 +501,6 @@ static inline int pte_protnone(pte_t pte
 	return (pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE | _PAGE_RWX)) ==
 		cpu_to_be64(_PAGE_PRESENT | _PAGE_PTE);
 }
-
-#define pte_mk_savedwrite pte_mk_savedwrite
-static inline pte_t pte_mk_savedwrite(pte_t pte)
-{
-	/*
-	 * Used by Autonuma subsystem to preserve the write bit
-	 * while marking the pte PROT_NONE. Only allow this
-	 * on PROT_NONE pte
-	 */
-	VM_BUG_ON((pte_raw(pte) & cpu_to_be64(_PAGE_PRESENT | _PAGE_RWX | _PAGE_PRIVILEGED)) !=
-		  cpu_to_be64(_PAGE_PRESENT | _PAGE_PRIVILEGED));
-	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_PRIVILEGED));
-}
-
-#define pte_clear_savedwrite pte_clear_savedwrite
-static inline pte_t pte_clear_savedwrite(pte_t pte)
-{
-	/*
-	 * Used by KSM subsystem to make a protnone pte readonly.
-	 */
-	VM_BUG_ON(!pte_protnone(pte));
-	return __pte_raw(pte_raw(pte) | cpu_to_be64(_PAGE_PRIVILEGED));
-}
-#else
-#define pte_clear_savedwrite pte_clear_savedwrite
-static inline pte_t pte_clear_savedwrite(pte_t pte)
-{
-	VM_WARN_ON(1);
-	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_WRITE));
-}
 #endif /* CONFIG_NUMA_BALANCING */
 
 static inline bool pte_hw_valid(pte_t pte)
@@ -641,8 +577,6 @@ static inline unsigned long pte_pfn(pte_
 /* Generic modifiers for PTE bits */
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	if (unlikely(pte_savedwrite(pte)))
-		return pte_clear_savedwrite(pte);
 	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_WRITE));
 }
 
@@ -1139,8 +1073,6 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #define pmd_mkclean(pmd)	pte_pmd(pte_mkclean(pmd_pte(pmd)))
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkwrite(pmd)	pte_pmd(pte_mkwrite(pmd_pte(pmd)))
-#define pmd_mk_savedwrite(pmd)	pte_pmd(pte_mk_savedwrite(pmd_pte(pmd)))
-#define pmd_clear_savedwrite(pmd)	pte_pmd(pte_clear_savedwrite(pmd_pte(pmd)))
 
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 #define pmd_soft_dirty(pmd)    pte_soft_dirty(pmd_pte(pmd))
@@ -1162,8 +1094,6 @@ static inline int pmd_protnone(pmd_t pmd
 #endif /* CONFIG_NUMA_BALANCING */
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
-#define __pmd_write(pmd)	__pte_write(pmd_pte(pmd))
-#define pmd_savedwrite(pmd)	pte_savedwrite(pmd_pte(pmd))
 
 #define pmd_access_permitted pmd_access_permitted
 static inline bool pmd_access_permitted(pmd_t pmd, bool write)
@@ -1241,10 +1171,8 @@ static inline int __pmdp_test_and_clear_
 static inline void pmdp_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pmd_t *pmdp)
 {
-	if (__pmd_write((*pmdp)))
+	if (pmd_write(*pmdp))
 		pmd_hugepage_update(mm, addr, pmdp, _PAGE_WRITE, 0);
-	else if (unlikely(pmd_savedwrite(*pmdp)))
-		pmd_hugepage_update(mm, addr, pmdp, 0, _PAGE_PRIVILEGED);
 }
 
 /*
--- a/arch/powerpc/kvm/book3s_hv_rm_mmu.c~mm-remove-unused-savedwrite-infrastructure
+++ a/arch/powerpc/kvm/book3s_hv_rm_mmu.c
@@ -265,7 +265,7 @@ long kvmppc_do_h_enter(struct kvm *kvm,
 		}
 		pte = kvmppc_read_update_linux_pte(ptep, writing);
 		if (pte_present(pte) && !pte_protnone(pte)) {
-			if (writing && !__pte_write(pte))
+			if (writing && !pte_write(pte))
 				/* make the actual HPTE be read-only */
 				ptel = hpte_make_readonly(ptel);
 			is_ci = pte_ci(pte);
--- a/include/linux/pgtable.h~mm-remove-unused-savedwrite-infrastructure
+++ a/include/linux/pgtable.h
@@ -503,30 +503,6 @@ static inline pte_t pte_sw_mkyoung(pte_t
 #define pte_sw_mkyoung	pte_sw_mkyoung
 #endif
 
-#ifndef pte_savedwrite
-#define pte_savedwrite pte_write
-#endif
-
-#ifndef pte_mk_savedwrite
-#define pte_mk_savedwrite pte_mkwrite
-#endif
-
-#ifndef pte_clear_savedwrite
-#define pte_clear_savedwrite pte_wrprotect
-#endif
-
-#ifndef pmd_savedwrite
-#define pmd_savedwrite pmd_write
-#endif
-
-#ifndef pmd_mk_savedwrite
-#define pmd_mk_savedwrite pmd_mkwrite
-#endif
-
-#ifndef pmd_clear_savedwrite
-#define pmd_clear_savedwrite pmd_wrprotect
-#endif
-
 #ifndef __HAVE_ARCH_PMDP_SET_WRPROTECT
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
--- a/mm/debug_vm_pgtable.c~mm-remove-unused-savedwrite-infrastructure
+++ a/mm/debug_vm_pgtable.c
@@ -171,18 +171,6 @@ static void __init pte_advanced_tests(st
 	ptep_get_and_clear_full(args->mm, args->vaddr, args->ptep, 1);
 }
 
-static void __init pte_savedwrite_tests(struct pgtable_debug_args *args)
-{
-	pte_t pte = pfn_pte(args->fixed_pte_pfn, args->page_prot_none);
-
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
-		return;
-
-	pr_debug("Validating PTE saved write\n");
-	WARN_ON(!pte_savedwrite(pte_mk_savedwrite(pte_clear_savedwrite(pte))));
-	WARN_ON(pte_savedwrite(pte_clear_savedwrite(pte_mk_savedwrite(pte))));
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 {
@@ -302,22 +290,6 @@ static void __init pmd_leaf_tests(struct
 	WARN_ON(!pmd_leaf(pmd));
 }
 
-static void __init pmd_savedwrite_tests(struct pgtable_debug_args *args)
-{
-	pmd_t pmd;
-
-	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
-		return;
-
-	if (!has_transparent_hugepage())
-		return;
-
-	pr_debug("Validating PMD saved write\n");
-	pmd = pfn_pmd(args->fixed_pmd_pfn, args->page_prot_none);
-	WARN_ON(!pmd_savedwrite(pmd_mk_savedwrite(pmd_clear_savedwrite(pmd))));
-	WARN_ON(pmd_savedwrite(pmd_clear_savedwrite(pmd_mk_savedwrite(pmd))));
-}
-
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static void __init pud_basic_tests(struct pgtable_debug_args *args, int idx)
 {
@@ -451,7 +423,6 @@ static void __init pmd_advanced_tests(st
 static void __init pud_advanced_tests(struct pgtable_debug_args *args) { }
 static void __init pmd_leaf_tests(struct pgtable_debug_args *args) { }
 static void __init pud_leaf_tests(struct pgtable_debug_args *args) { }
-static void __init pmd_savedwrite_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 #ifdef CONFIG_HAVE_ARCH_HUGE_VMAP
@@ -1288,9 +1259,6 @@ static int __init debug_vm_pgtable(void)
 	pmd_leaf_tests(&args);
 	pud_leaf_tests(&args);
 
-	pte_savedwrite_tests(&args);
-	pmd_savedwrite_tests(&args);
-
 	pte_special_tests(&args);
 	pte_protnone_tests(&args);
 	pmd_protnone_tests(&args);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-vm-add-ksm-unmerge-tests.patch
mm-pagewalk-dont-trigger-test_walk-in-walk_page_vma.patch
selftests-vm-add-test-to-measure-madv_unmergeable-performance.patch
mm-ksm-simplify-break_ksm-to-not-rely-on-vm_fault_write.patch
mm-remove-vm_fault_write.patch
mm-ksm-fix-ksm-cow-breaking-with-userfaultfd-wp-via-fault_flag_unshare.patch
mm-pagewalk-add-walk_page_range_vma.patch
mm-ksm-convert-break_ksm-to-use-walk_page_range_vma.patch
mm-gup-remove-foll_migration.patch

