Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EC5C001DD
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbjGMRSP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjGMRSO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:18:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C95ED1BD4
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:18:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59B4A61AF5
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA56AC433C9;
        Thu, 13 Jul 2023 17:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268691;
        bh=OYybZjKFoG+K4SRiikkzirJaxy6LcoPqZiB7PMmp7UI=;
        h=Date:To:From:Subject:From;
        b=BCHTW3ntFxFEYmfA8iQOnDUVQbXkg/kX3zUqSpyONmQjvb5Mpcvrk3X7WScLMuKHe
         3Xgsw8c2280jFWLuRmHyPQQL9PFYpr53vjwH44vv5oL1bmc0LjEGHInTBNta30PWAz
         FvMnLd/2iCEAx6/+m8Zz4FHQFhON10L+hCPt4BjM=
Date:   Thu, 13 Jul 2023 10:18:11 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch added to mm-unstable branch
Message-Id: <20230713171811.AA56AC433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pmd_set
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch

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
From: Kemeng Shi <shikemeng@huaweicloud.com>
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pmd_set
Date: Fri, 14 Jul 2023 01:26:35 +0800

Remove unused addr in __page_table_check_pmd_set and
page_table_check_pmd_set.

Link: https://lkml.kernel.org/r/20230713172636.1705415-8-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    4 ++--
 arch/riscv/include/asm/pgtable.h |    4 ++--
 arch/x86/include/asm/pgtable.h   |    4 ++--
 include/linux/page_table_check.h |   11 ++++-------
 mm/page_table_check.c            |    3 +--
 5 files changed, 11 insertions(+), 15 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -524,7 +524,7 @@ static inline pmd_t pmd_mkdevmap(pmd_t p
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	page_table_check_pmd_set(mm, pmdp, pmd);
 	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
@@ -976,7 +976,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -687,7 +687,7 @@ static inline pmd_t pmd_mkdirty(pmd_t pm
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	page_table_check_pmd_set(mm, pmdp, pmd);
 	return __set_pte_at(mm, addr, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
@@ -758,7 +758,7 @@ static inline void pmdp_set_wrprotect(st
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
 	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1030,7 +1030,7 @@ static inline void set_pte_at(struct mm_
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	page_table_check_pmd_set(mm, pmdp, pmd);
 	set_pmd(pmdp, pmd);
 }
 
@@ -1167,7 +1167,7 @@ static inline int pud_write(pud_t pud)
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pmdp, pmd);
 	} else {
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/include/linux/page_table_check.h
@@ -18,8 +18,7 @@ void __page_table_check_pte_clear(struct
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
 void __page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep, pte_t pte);
-void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
-				pmd_t *pmdp, pmd_t pmd);
+void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd);
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -75,14 +74,13 @@ static inline void page_table_check_pte_
 	__page_table_check_pte_set(mm, ptep, pte);
 }
 
-static inline void page_table_check_pmd_set(struct mm_struct *mm,
-					    unsigned long addr, pmd_t *pmdp,
+static inline void page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp,
 					    pmd_t pmd)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmd_set(mm, addr, pmdp, pmd);
+	__page_table_check_pmd_set(mm, pmdp, pmd);
 }
 
 static inline void page_table_check_pud_set(struct mm_struct *mm,
@@ -132,8 +130,7 @@ static inline void page_table_check_pte_
 {
 }
 
-static inline void page_table_check_pmd_set(struct mm_struct *mm,
-					    unsigned long addr, pmd_t *pmdp,
+static inline void page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp,
 					    pmd_t pmd)
 {
 }
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set
+++ a/mm/page_table_check.c
@@ -195,8 +195,7 @@ void __page_table_check_pte_set(struct m
 }
 EXPORT_SYMBOL(__page_table_check_pte_set);
 
-void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
-				pmd_t *pmdp, pmd_t pmd)
+void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
_

Patches currently in -mm which might be from shikemeng@huaweicloud.com are

mm-correct-stale-comment-of-function-check_pte.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_clear.patch
mm-page_table_check-remove-unused-parameters-in-page_table_check_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pmd_set.patch
mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch

