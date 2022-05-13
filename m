Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B905C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383826AbiEMTY6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383864AbiEMTXQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFBF33E0C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71337B83196
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD72C34100;
        Fri, 13 May 2022 19:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469730;
        bh=xeI8G28luJf4ix4Kp7fS7lj8Pp+NH1taVYkB3DR0NLg=;
        h=Date:To:From:Subject:From;
        b=EJDCOLXghJ6W+mBu/cPmtnF06hCuoiGyybbj3i8k7aK1cEfg/1uI2aDIctNgUwoiO
         1Xx7kH+d8nsRXX5Mbob/CPgSNjqKbV/wZgDiAYI4MOOxWERZ3n4UbKzTAeDXMzMNJq
         9ivVdbQs3wtzjSavDAwoeB21mEyMHIzA0pL65jto=
Date:   Fri, 13 May 2022 12:22:09 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        wangkefeng.wang@huawei.com, paul.walmsley@sifive.com,
        pasha.tatashin@soleen.com, palmer@dabbelt.com, mingo@redhat.com,
        hpa@zytor.com, dave.hansen@linux.intel.com,
        catalin.marinas@arm.com, bp@alien8.de, anshuman.khandual@arm.com,
        tongtiangen@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-add-hooks-to-public-helpers.patch removed from -mm tree
Message-Id: <20220513192210.2BD72C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: page_table_check: add hooks to public helpers
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-add-hooks-to-public-helpers.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tong Tiangen <tongtiangen@huawei.com>
Subject: mm: page_table_check: add hooks to public helpers

Move ptep_clear() to the include/linux/pgtable.h and add page table check
relate hooks to some helpers, it's prepare for support page table check
feature on new architecture.

Optimize the implementation of ptep_clear(), page table hooks added page
table check stubs, the interface control should be at stubs, there is no
rationale for doing a IS_ENABLED() check here.

For architectures that do not enable CONFIG_PAGE_TABLE_CHECK, they will
call a fallback page table check stubs[1] when getting their page table
helpers[2] in include/linux/pgtable.h.

[1] page table check stubs defined in include/linux/page_table_check.h
[2] ptep_clear() ptep_get_and_clear()  pmdp_huge_get_and_clear()
pudp_huge_get_and_clear()

Link: https://lkml.kernel.org/r/20220507110114.4128854-4-tongtiangen@huawei.com
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
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

 arch/x86/include/asm/pgtable.h |   10 ----------
 include/linux/pgtable.h        |   23 +++++++++++++++--------
 2 files changed, 15 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-add-hooks-to-public-helpers
+++ a/arch/x86/include/asm/pgtable.h
@@ -1072,16 +1072,6 @@ static inline pte_t ptep_get_and_clear_f
 	return pte;
 }
 
-#define __HAVE_ARCH_PTEP_CLEAR
-static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep)
-{
-	if (IS_ENABLED(CONFIG_PAGE_TABLE_CHECK))
-		ptep_get_and_clear(mm, addr, ptep);
-	else
-		pte_clear(mm, addr, ptep);
-}
-
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long addr, pte_t *ptep)
--- a/include/linux/pgtable.h~mm-page_table_check-add-hooks-to-public-helpers
+++ a/include/linux/pgtable.h
@@ -12,6 +12,7 @@
 #include <linux/bug.h>
 #include <linux/errno.h>
 #include <asm-generic/pgtable_uffd.h>
+#include <linux/page_table_check.h>
 
 #if 5 - defined(__PAGETABLE_P4D_FOLDED) - defined(__PAGETABLE_PUD_FOLDED) - \
 	defined(__PAGETABLE_PMD_FOLDED) != CONFIG_PGTABLE_LEVELS
@@ -259,14 +260,6 @@ static inline int pmdp_clear_flush_young
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-#ifndef __HAVE_ARCH_PTEP_CLEAR
-static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep)
-{
-	pte_clear(mm, addr, ptep);
-}
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address,
@@ -274,10 +267,19 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = *ptep;
 	pte_clear(mm, address, ptep);
+	page_table_check_pte_clear(mm, address, pte);
 	return pte;
 }
 #endif
 
+#ifndef __HAVE_ARCH_PTEP_CLEAR
+static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep)
+{
+	ptep_get_and_clear(mm, addr, ptep);
+}
+#endif
+
 #ifndef __HAVE_ARCH_PTEP_GET
 static inline pte_t ptep_get(pte_t *ptep)
 {
@@ -347,7 +349,10 @@ static inline pmd_t pmdp_huge_get_and_cl
 					    pmd_t *pmdp)
 {
 	pmd_t pmd = *pmdp;
+
 	pmd_clear(pmdp);
+	page_table_check_pmd_clear(mm, address, pmd);
+
 	return pmd;
 }
 #endif /* __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR */
@@ -359,6 +364,8 @@ static inline pud_t pudp_huge_get_and_cl
 	pud_t pud = *pudp;
 
 	pud_clear(pudp);
+	page_table_check_pud_clear(mm, address, pud);
+
 	return pud;
 }
 #endif /* __HAVE_ARCH_PUDP_HUGE_GET_AND_CLEAR */
_

Patches currently in -mm which might be from tongtiangen@huawei.com are


