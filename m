Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A89C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 23:07:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233023AbiDDXJF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 19:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiDDXIO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 19:08:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9C655480
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 15:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D664C6164D
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 22:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083A3C2BBE4;
        Mon,  4 Apr 2022 22:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649111800;
        bh=T+Vegqy2OJ1xkMY+Kb1wK4WlFD+tcBC95qQdy9/20Yw=;
        h=Date:To:From:Subject:From;
        b=pmdJNnIE2Qf5r9Kl1vy9XSrRK21kAnOgjLUjsga5MdLJ9hC95dUZ0HNUbEZRqOoYo
         5sIbqa89Q3Gb4Jw6jn+d0flNVWCehhrWh+8+aZYtNE5uv0W+/1CF5H9w0F1lpgA0VF
         6tW1JHjyYeBGXB5t6py2ccj6+FNAYnspcygeEomU=
Date:   Mon, 04 Apr 2022 15:36:39 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com, will@kernel.org,
        tglx@linutronix.de, peterz@infradead.org, peterx@redhat.com,
        npiggin@gmail.com, luto@kernel.org, dave.hansen@linux.intel.com,
        andrew.cooper3@citrix.com, aarcange@redhat.com, namit@vmware.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mprotect-do-not-flush-when-not-required-architecturally.patch added to -mm tree
Message-Id: <20220404223640.083A3C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mprotect: do not flush when not required architecturally
has been added to the -mm tree.  Its filename is
     mm-mprotect-do-not-flush-when-not-required-architecturally.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mprotect-do-not-flush-when-not-required-architecturally.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mprotect-do-not-flush-when-not-required-architecturally.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nadav Amit <namit@vmware.com>
Subject: mm/mprotect: do not flush when not required architecturally

Currently, using mprotect() to unprotect a memory region or uffd to
unprotect a memory region causes a TLB flush.  However, in such cases the
PTE is often not modified (i.e., remain RO) and therefore not TLB flush is
needed.

Add an arch-specific pte_needs_flush() which tells whether a TLB flush is
needed based on the old PTE and the new one.  Implement an x86
pte_needs_flush().

Always flush the TLB when it is architecturally needed even when skipping
a TLB flush might only result in a spurious page-faults by skipping the
flush.

Even with such conservative manner, we can in the future further refine
the checks to test whether a PTE is present by only considering the
architectural _PAGE_PRESENT flag instead of {pte|pmd}_preesnt().  For not
be careful and use the latter.

Link: https://lkml.kernel.org/r/20220401180821.1986781-3-namit@vmware.com
Signed-off-by: Nadav Amit <namit@vmware.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable_types.h |    2 
 arch/x86/include/asm/tlbflush.h      |   97 +++++++++++++++++++++++++
 include/asm-generic/tlb.h            |   14 +++
 mm/huge_memory.c                     |    9 +-
 mm/mprotect.c                        |    3 
 5 files changed, 120 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/pgtable_types.h~mm-mprotect-do-not-flush-when-not-required-architecturally
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -115,9 +115,11 @@
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 #define _PAGE_NX	(_AT(pteval_t, 1) << _PAGE_BIT_NX)
 #define _PAGE_DEVMAP	(_AT(u64, 1) << _PAGE_BIT_DEVMAP)
+#define _PAGE_SOFTW4	(_AT(pteval_t, 1) << _PAGE_BIT_SOFTW4)
 #else
 #define _PAGE_NX	(_AT(pteval_t, 0))
 #define _PAGE_DEVMAP	(_AT(pteval_t, 0))
+#define _PAGE_SOFTW4	(_AT(pteval_t, 0))
 #endif
 
 #define _PAGE_PROTNONE	(_AT(pteval_t, 1) << _PAGE_BIT_PROTNONE)
--- a/arch/x86/include/asm/tlbflush.h~mm-mprotect-do-not-flush-when-not-required-architecturally
+++ a/arch/x86/include/asm/tlbflush.h
@@ -259,6 +259,103 @@ static inline void arch_tlbbatch_add_mm(
 
 extern void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch);
 
+static inline bool pte_flags_need_flush(unsigned long oldflags,
+					unsigned long newflags,
+					bool ignore_access)
+{
+	/*
+	 * Flags that require a flush when cleared but not when they are set.
+	 * Only include flags that would not trigger spurious page-faults.
+	 * Non-present entries are not cached. Hardware would set the
+	 * dirty/access bit if needed without a fault.
+	 */
+	const pteval_t flush_on_clear = _PAGE_DIRTY | _PAGE_PRESENT |
+					_PAGE_ACCESSED;
+	const pteval_t software_flags = _PAGE_SOFTW1 | _PAGE_SOFTW2 |
+					_PAGE_SOFTW3 | _PAGE_SOFTW4;
+	const pteval_t flush_on_change = _PAGE_RW | _PAGE_USER | _PAGE_PWT |
+			  _PAGE_PCD | _PAGE_PSE | _PAGE_GLOBAL | _PAGE_PAT |
+			  _PAGE_PAT_LARGE | _PAGE_PKEY_BIT0 | _PAGE_PKEY_BIT1 |
+			  _PAGE_PKEY_BIT2 | _PAGE_PKEY_BIT3 | _PAGE_NX;
+	unsigned long diff = oldflags ^ newflags;
+
+	BUILD_BUG_ON(flush_on_clear & software_flags);
+	BUILD_BUG_ON(flush_on_clear & flush_on_change);
+	BUILD_BUG_ON(flush_on_change & software_flags);
+
+	/* Ignore software flags */
+	diff &= ~software_flags;
+
+	if (ignore_access)
+		diff &= ~_PAGE_ACCESSED;
+
+	/*
+	 * Did any of the 'flush_on_clear' flags was clleared set from between
+	 * 'oldflags' and 'newflags'?
+	 */
+	if (diff & oldflags & flush_on_clear)
+		return true;
+
+	/* Flush on modified flags. */
+	if (diff & flush_on_change)
+		return true;
+
+	/* Ensure there are no flags that were left behind */
+	if (IS_ENABLED(CONFIG_DEBUG_VM) &&
+	    (diff & ~(flush_on_clear | software_flags | flush_on_change))) {
+		VM_WARN_ON_ONCE(1);
+		return true;
+	}
+
+	return false;
+}
+
+/*
+ * pte_needs_flush() checks whether permissions were demoted and require a
+ * flush. It should only be used for userspace PTEs.
+ */
+static inline bool pte_needs_flush(pte_t oldpte, pte_t newpte)
+{
+	/* !PRESENT -> * ; no need for flush */
+	if (!(pte_flags(oldpte) & _PAGE_PRESENT))
+		return false;
+
+	/* PFN changed ; needs flush */
+	if (pte_pfn(oldpte) != pte_pfn(newpte))
+		return true;
+
+	/*
+	 * check PTE flags; ignore access-bit; see comment in
+	 * ptep_clear_flush_young().
+	 */
+	return pte_flags_need_flush(pte_flags(oldpte), pte_flags(newpte),
+				    true);
+}
+#define pte_needs_flush pte_needs_flush
+
+/*
+ * huge_pmd_needs_flush() checks whether permissions were demoted and require a
+ * flush. It should only be used for userspace huge PMDs.
+ */
+static inline bool huge_pmd_needs_flush(pmd_t oldpmd, pmd_t newpmd)
+{
+	/* !PRESENT -> * ; no need for flush */
+	if (!(pmd_flags(oldpmd) & _PAGE_PRESENT))
+		return false;
+
+	/* PFN changed ; needs flush */
+	if (pmd_pfn(oldpmd) != pmd_pfn(newpmd))
+		return true;
+
+	/*
+	 * check PMD flags; do not ignore access-bit; see
+	 * pmdp_clear_flush_young().
+	 */
+	return pte_flags_need_flush(pmd_flags(oldpmd), pmd_flags(newpmd),
+				    false);
+}
+#define huge_pmd_needs_flush huge_pmd_needs_flush
+
 #endif /* !MODULE */
 
 static inline void __native_tlb_flush_global(unsigned long cr4)
--- a/include/asm-generic/tlb.h~mm-mprotect-do-not-flush-when-not-required-architecturally
+++ a/include/asm-generic/tlb.h
@@ -654,6 +654,20 @@ static inline void tlb_flush_p4d_range(s
 	} while (0)
 #endif
 
+#ifndef pte_needs_flush
+static inline bool pte_needs_flush(pte_t oldpte, pte_t newpte)
+{
+	return true;
+}
+#endif
+
+#ifndef huge_pmd_needs_flush
+static inline bool huge_pmd_needs_flush(pmd_t oldpmd, pmd_t newpmd)
+{
+	return true;
+}
+#endif
+
 #endif /* CONFIG_MMU */
 
 #endif /* _ASM_GENERIC__TLB_H */
--- a/mm/huge_memory.c~mm-mprotect-do-not-flush-when-not-required-architecturally
+++ a/mm/huge_memory.c
@@ -1715,7 +1715,7 @@ int change_huge_pmd(struct mmu_gather *t
 {
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *ptl;
-	pmd_t entry;
+	pmd_t oldpmd, entry;
 	bool preserve_write;
 	int ret;
 	bool prot_numa = cp_flags & MM_CP_PROT_NUMA;
@@ -1804,9 +1804,9 @@ int change_huge_pmd(struct mmu_gather *t
 	 * pmdp_invalidate() is required to make sure we don't miss
 	 * dirty/young flags set by hardware.
 	 */
-	entry = pmdp_invalidate(vma, addr, pmd);
+	oldpmd = pmdp_invalidate(vma, addr, pmd);
 
-	entry = pmd_modify(entry, newprot);
+	entry = pmd_modify(oldpmd, newprot);
 	if (preserve_write)
 		entry = pmd_mk_savedwrite(entry);
 	if (uffd_wp) {
@@ -1823,7 +1823,8 @@ int change_huge_pmd(struct mmu_gather *t
 	ret = HPAGE_PMD_NR;
 	set_pmd_at(mm, addr, pmd, entry);
 
-	tlb_flush_pmd_range(tlb, addr, HPAGE_PMD_SIZE);
+	if (huge_pmd_needs_flush(oldpmd, entry))
+		tlb_flush_pmd_range(tlb, addr, HPAGE_PMD_SIZE);
 
 	BUG_ON(vma_is_anonymous(vma) && !preserve_write && pmd_write(entry));
 unlock:
--- a/mm/mprotect.c~mm-mprotect-do-not-flush-when-not-required-architecturally
+++ a/mm/mprotect.c
@@ -152,7 +152,8 @@ static unsigned long change_pte_range(st
 				ptent = pte_mkwrite(ptent);
 			}
 			ptep_modify_prot_commit(vma, addr, pte, oldpte, ptent);
-			tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
+			if (pte_needs_flush(oldpte, ptent))
+				tlb_flush_pte_range(tlb, addr, PAGE_SIZE);
 			pages++;
 		} else if (is_swap_pte(oldpte)) {
 			swp_entry_t entry = pte_to_swp_entry(oldpte);
_

Patches currently in -mm which might be from namit@vmware.com are

userfaultfd-mark-uffd_wp-regardless-of-vm_write-flag.patch
mm-mprotect-use-mmu_gather.patch
mm-mprotect-do-not-flush-when-not-required-architecturally.patch
mm-avoid-unnecessary-flush-on-change_huge_pmd.patch

