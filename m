Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E150BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 20:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392446AbiDUUjj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392447AbiDUUj2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 16:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D34C4DF4C
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 13:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AF6DE61D5C
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 20:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6E8C385A5;
        Thu, 21 Apr 2022 20:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650573397;
        bh=oL3IbFmGBdhrler6ThCIk/xQy7V0mW6dpo5HtMTR/RA=;
        h=Date:To:From:Subject:From;
        b=ejUviJ3plu7HGNxtEqNk0ZwESV53s+pg8Gg1F/338jNf0x+//KNIBIwGZG8Z2hVUL
         GkcWqKx4tieiY2P1M9ugJSAA9JWSemzcGJLcZM/IX9LhWapMA4GbJq1Td12y/utR1t
         jnReM/9P/TobXG33glIpFo08ef/7TMH6nDkgn+X8=
Date:   Thu, 21 Apr 2022 13:36:36 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        tongtiangen@huawei.com, tglx@linutronix.de,
        paul.walmsley@sifive.com, pasha.tatashin@soleen.com,
        palmer@dabbelt.com, mingo@redhat.com, hpa@zytor.com,
        guohanjun@huawei.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, aou@eecs.berkeley.edu,
        anshuman.khandual@arm.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-add-support-for-page-table-check.patch added to -mm tree
Message-Id: <20220421203637.0F6E8C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: mm: add support for page table check
has been added to the -mm tree.  Its filename is
     arm64-mm-add-support-for-page-table-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/arm64-mm-add-support-for-page-table-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/arm64-mm-add-support-for-page-table-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: arm64: mm: add support for page table check

As commit d283d422c6c4 ("x86: mm: add x86_64 support for page table
check"), add some necessary page table check hooks into routines that
modify user page tables.

Link: https://lkml.kernel.org/r/20220421082042.1167967-5-tongtiangen@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig               |    1 
 arch/arm64/include/asm/pgtable.h |   65 ++++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-add-support-for-page-table-check
+++ a/arch/arm64/include/asm/pgtable.h
@@ -33,6 +33,7 @@
 #include <linux/mmdebug.h>
 #include <linux/mm_types.h>
 #include <linux/sched.h>
+#include <linux/page_table_check.h>
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
@@ -96,6 +97,7 @@ static inline pteval_t __phys_to_pte_val
 #define pte_young(pte)		(!!(pte_val(pte) & PTE_AF))
 #define pte_special(pte)	(!!(pte_val(pte) & PTE_SPECIAL))
 #define pte_write(pte)		(!!(pte_val(pte) & PTE_WRITE))
+#define pte_user(pte)		(!!(pte_val(pte) & PTE_USER))
 #define pte_user_exec(pte)	(!(pte_val(pte) & PTE_UXN))
 #define pte_cont(pte)		(!!(pte_val(pte) & PTE_CONT))
 #define pte_devmap(pte)		(!!(pte_val(pte) & PTE_DEVMAP))
@@ -312,7 +314,7 @@ static inline void __check_racy_pte_upda
 		     __func__, pte_val(old_pte), pte_val(pte));
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+static inline void __set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
 	if (pte_present(pte) && pte_user_exec(pte) && !pte_special(pte))
@@ -343,6 +345,13 @@ static inline void set_pte_at(struct mm_
 	set_pte(ptep, pte);
 }
 
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pte)
+{
+	page_table_check_pte_set(mm, addr, ptep, pte);
+	return __set_pte_at(mm, addr, ptep, pte);
+}
+
 /*
  * Huge pte definitions.
  */
@@ -438,6 +447,8 @@ static inline int pmd_trans_huge(pmd_t p
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_valid(pmd)		pte_valid(pmd_pte(pmd))
+#define pmd_user(pmd)		pte_user(pmd_pte(pmd))
+#define pmd_user_exec(pmd)	pte_user_exec(pmd_pte(pmd))
 #define pmd_cont(pmd)		pte_cont(pmd_pte(pmd))
 #define pmd_wrprotect(pmd)	pte_pmd(pte_wrprotect(pmd_pte(pmd)))
 #define pmd_mkold(pmd)		pte_pmd(pte_mkold(pmd_pte(pmd)))
@@ -485,8 +496,19 @@ static inline pmd_t pmd_mkdevmap(pmd_t p
 #define pud_pfn(pud)		((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT)
 #define pfn_pud(pfn,prot)	__pud(__phys_to_pud_val((phys_addr_t)(pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
-#define set_pmd_at(mm, addr, pmdp, pmd)	set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd))
-#define set_pud_at(mm, addr, pudp, pud)	set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud))
+static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
+			      pmd_t *pmdp, pmd_t pmd)
+{
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
+}
+
+static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
+			      pud_t *pudp, pud_t pud)
+{
+	page_table_check_pud_set(mm, addr, pudp, pud);
+	return __set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud));
+}
 
 #define __p4d_to_phys(p4d)	__pte_to_phys(p4d_pte(p4d))
 #define __phys_to_p4d_val(phys)	__phys_to_pte_val(phys)
@@ -627,6 +649,24 @@ static inline unsigned long pmd_page_vad
 #define pud_present(pud)	pte_present(pud_pte(pud))
 #define pud_leaf(pud)		pud_sect(pud)
 #define pud_valid(pud)		pte_valid(pud_pte(pud))
+#define pud_user(pud)		pte_user(pud_pte(pud))
+
+#ifdef CONFIG_PAGE_TABLE_CHECK
+static inline bool pte_user_accessible_page(pte_t pte)
+{
+	return pte_present(pte) && (pte_user(pte) || pte_user_exec(pte));
+}
+
+static inline bool pmd_user_accessible_page(pmd_t pmd)
+{
+	return pmd_present(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
+}
+
+static inline bool pud_user_accessible_page(pud_t pud)
+{
+	return pud_present(pud) && pud_user(pud);
+}
+#endif
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
@@ -856,11 +896,21 @@ static inline int pmdp_test_and_clear_yo
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
+				       unsigned long address, pte_t *ptep)
+{
+	return __pte(xchg_relaxed(&pte_val(*ptep), 0));
+}
+
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address, pte_t *ptep)
 {
-	return __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __ptep_get_and_clear(mm, address, ptep);
+
+	page_table_check_pte_clear(mm, address, pte);
+
+	return pte;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -868,7 +918,11 @@ static inline pte_t ptep_get_and_clear(s
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp)
 {
-	return pte_pmd(ptep_get_and_clear(mm, address, (pte_t *)pmdp));
+	pmd_t pmd = pte_pmd(__ptep_get_and_clear(mm, address, (pte_t *)pmdp));
+
+	page_table_check_pmd_clear(mm, address, pmd);
+
+	return pmd;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -902,6 +956,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
--- a/arch/arm64/Kconfig~arm64-mm-add-support-for-page-table-check
+++ a/arch/arm64/Kconfig
@@ -91,6 +91,7 @@ config ARM64
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-page_table_check-move-pxx_user_accessible_page-into-x86.patch
arm64-mm-add-support-for-page-table-check.patch

