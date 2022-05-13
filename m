Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF54C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383865AbiEMTZH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383875AbiEMTXQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE5D3E5DE
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE83FB831A4
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B33C34113;
        Fri, 13 May 2022 19:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469733;
        bh=OIKjiY7Pb8ld81N/kPv0EsLJ06huAyGuRsE2gSUk0Vc=;
        h=Date:To:From:Subject:From;
        b=mg+Jq6ekBduGjkIQnFLK4aE2IXWd03ymffZc6XeFhOI4M1GoTQlI61csQVn+0nsmd
         HBigCx80JzInwkVHsZQMYzd4MP2YyQZdN4mijNipCaWGHwNCW4ivlSrLoQ/fvFpvw3
         CKicaUnWcguGXE+FRwY7h6z0IaIFxetTgbZclD8E=
Date:   Fri, 13 May 2022 12:22:12 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, paul.walmsley@sifive.com,
        pasha.tatashin@soleen.com, palmer@dabbelt.com, mingo@redhat.com,
        hpa@zytor.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, anshuman.khandual@arm.com,
        tongtiangen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] riscv-mm-enable-arch_supports_page_table_check.patch removed from -mm tree
Message-Id: <20220513192213.85B33C34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK
has been removed from the -mm tree.  Its filename was
     riscv-mm-enable-arch_supports_page_table_check.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: riscv/mm: enable ARCH_SUPPORTS_PAGE_TABLE_CHECK

As commit d283d422c6c4 ("x86: mm: add x86_64 support for page table
check"), enable ARCH_SUPPORTS_PAGE_TABLE_CHECK on riscv.

Add additional page table check stubs for page table helpers, these stubs
can be used to check the existing page table entries.

Link: https://lkml.kernel.org/r/20220507110114.4128854-7-tongtiangen@huawei.com
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/riscv/Kconfig               |    1 
 arch/riscv/include/asm/pgtable.h |   71 ++++++++++++++++++++++++++---
 2 files changed, 66 insertions(+), 6 deletions(-)

--- a/arch/riscv/include/asm/pgtable.h~riscv-mm-enable-arch_supports_page_table_check
+++ a/arch/riscv/include/asm/pgtable.h
@@ -114,6 +114,8 @@
 #include <asm/pgtable-32.h>
 #endif /* CONFIG_64BIT */
 
+#include <linux/page_table_check.h>
+
 #ifdef CONFIG_XIP_KERNEL
 #define XIP_FIXUP(addr) ({							\
 	uintptr_t __a = (uintptr_t)(addr);					\
@@ -315,6 +317,11 @@ static inline int pte_exec(pte_t pte)
 	return pte_val(pte) & _PAGE_EXEC;
 }
 
+static inline int pte_user(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_USER;
+}
+
 static inline int pte_huge(pte_t pte)
 {
 	return pte_present(pte) && (pte_val(pte) & _PAGE_LEAF);
@@ -446,7 +453,7 @@ static inline void set_pte(pte_t *ptep,
 
 void flush_icache_pte(pte_t pte);
 
-static inline void set_pte_at(struct mm_struct *mm,
+static inline void __set_pte_at(struct mm_struct *mm,
 	unsigned long addr, pte_t *ptep, pte_t pteval)
 {
 	if (pte_present(pteval) && pte_exec(pteval))
@@ -455,10 +462,17 @@ static inline void set_pte_at(struct mm_
 	set_pte(ptep, pteval);
 }
 
+static inline void set_pte_at(struct mm_struct *mm,
+	unsigned long addr, pte_t *ptep, pte_t pteval)
+{
+	page_table_check_pte_set(mm, addr, ptep, pteval);
+	__set_pte_at(mm, addr, ptep, pteval);
+}
+
 static inline void pte_clear(struct mm_struct *mm,
 	unsigned long addr, pte_t *ptep)
 {
-	set_pte_at(mm, addr, ptep, __pte(0));
+	__set_pte_at(mm, addr, ptep, __pte(0));
 }
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
@@ -479,7 +493,11 @@ static inline int ptep_set_access_flags(
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address, pte_t *ptep)
 {
-	return __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
+	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
+
+	page_table_check_pte_clear(mm, address, pte);
+
+	return pte;
 }
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
@@ -546,6 +564,13 @@ static inline unsigned long pmd_pfn(pmd_
 	return ((__pmd_to_phys(pmd) & PMD_MASK) >> PAGE_SHIFT);
 }
 
+#define __pud_to_phys(pud)  (pud_val(pud) >> _PAGE_PFN_SHIFT << PAGE_SHIFT)
+
+static inline unsigned long pud_pfn(pud_t pud)
+{
+	return ((__pud_to_phys(pud) & PUD_MASK) >> PAGE_SHIFT);
+}
+
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 {
 	return pte_pmd(pte_modify(pmd_pte(pmd), newprot));
@@ -567,6 +592,11 @@ static inline int pmd_young(pmd_t pmd)
 	return pte_young(pmd_pte(pmd));
 }
 
+static inline int pmd_user(pmd_t pmd)
+{
+	return pte_user(pmd_pte(pmd));
+}
+
 static inline pmd_t pmd_mkold(pmd_t pmd)
 {
 	return pte_pmd(pte_mkold(pmd_pte(pmd)));
@@ -600,15 +630,39 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
-	return set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
+}
+
+static inline int pud_user(pud_t pud)
+{
+	return pte_user(pud_pte(pud));
 }
 
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
-	return set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud));
+	page_table_check_pud_set(mm, addr, pudp, pud);
+	return __set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud));
+}
+
+#ifdef CONFIG_PAGE_TABLE_CHECK
+static inline bool pte_user_accessible_page(pte_t pte)
+{
+	return pte_present(pte) && pte_user(pte);
+}
+
+static inline bool pmd_user_accessible_page(pmd_t pmd)
+{
+	return pmd_leaf(pmd) && pmd_user(pmd);
 }
 
+static inline bool pud_user_accessible_page(pud_t pud)
+{
+	return pud_leaf(pud) && pud_user(pud);
+}
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
@@ -634,7 +688,11 @@ static inline int pmdp_test_and_clear_yo
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					unsigned long address, pmd_t *pmdp)
 {
-	return pte_pmd(ptep_get_and_clear(mm, address, (pte_t *)pmdp));
+	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
+
+	page_table_check_pmd_clear(mm, address, pmd);
+
+	return pmd;
 }
 
 #define __HAVE_ARCH_PMDP_SET_WRPROTECT
@@ -648,6 +706,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
--- a/arch/riscv/Kconfig~riscv-mm-enable-arch_supports_page_table_check
+++ a/arch/riscv/Kconfig
@@ -38,6 +38,7 @@ config RISCV
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_DEBUG_PAGEALLOC if MMU
 	select ARCH_SUPPORTS_HUGETLBFS if MMU
+	select ARCH_SUPPORTS_PAGE_TABLE_CHECK
 	select ARCH_USE_MEMTEST
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
 	select ARCH_WANT_FRAME_POINTERS
_

Patches currently in -mm which might be from tongtiangen@huawei.com are


