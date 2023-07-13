Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0595BC001DD
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjGMRSU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjGMRSR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:18:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29D62702
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3546D6199C
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF6CC433C7;
        Thu, 13 Jul 2023 17:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268694;
        bh=xzty4c+hWtzZkANQrR+l1kDnTOCC594v7mBv14N5jPk=;
        h=Date:To:From:Subject:From;
        b=GfUO2FckNTOjgeEEIgoTSN1b34OO/dNajxZrgM/26CzKNiiL4ylJMSvzcYrIQUQXs
         Ca9swrIFl/l1pi9tcP+FyScIKMfb5wah+/qru+OssyEgdfUwfCylT3O44c56YJTyc0
         ROxHPMeQ3731PdDDx3iS7Kb27T4YY51iSUEIRdt8=
Date:   Thu, 13 Jul 2023 10:18:14 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch added to mm-unstable branch
Message-Id: <20230713171814.8DF6CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pud_set
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set.patch

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
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pud_set
Date: Fri, 14 Jul 2023 01:26:36 +0800

Remove unused addr in __page_table_check_pud_set and
page_table_check_pud_set.

Link: https://lkml.kernel.org/r/20230713172636.1705415-9-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 ++++-------
 mm/page_table_check.c            |    3 +--
 5 files changed, 8 insertions(+), 12 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -531,7 +531,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, addr, pudp, pud);
+	page_table_check_pud_set(mm, pudp, pud);
 	return __set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud));
 }
 
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -694,7 +694,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, addr, pudp, pud);
+	page_table_check_pud_set(mm, pudp, pud);
 	return __set_pte_at(mm, addr, (pte_t *)pudp, pud_pte(pud));
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1037,7 +1037,7 @@ static inline void set_pmd_at(struct mm_
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, addr, pudp, pud);
+	page_table_check_pud_set(mm, pudp, pud);
 	native_set_pud(pudp, pud);
 }
 
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set
+++ a/include/linux/page_table_check.h
@@ -19,8 +19,7 @@ void __page_table_check_pmd_clear(struct
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
 void __page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep, pte_t pte);
 void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd);
-void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
-				pud_t *pudp, pud_t pud);
+void __page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp, pud_t pud);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
 					unsigned long addr,
 					pmd_t pmd);
@@ -83,14 +82,13 @@ static inline void page_table_check_pmd_
 	__page_table_check_pmd_set(mm, pmdp, pmd);
 }
 
-static inline void page_table_check_pud_set(struct mm_struct *mm,
-					    unsigned long addr, pud_t *pudp,
+static inline void page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp,
 					    pud_t pud)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pud_set(mm, addr, pudp, pud);
+	__page_table_check_pud_set(mm, pudp, pud);
 }
 
 static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -135,8 +133,7 @@ static inline void page_table_check_pmd_
 {
 }
 
-static inline void page_table_check_pud_set(struct mm_struct *mm,
-					    unsigned long addr, pud_t *pudp,
+static inline void page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp,
 					    pud_t pud)
 {
 }
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_set
+++ a/mm/page_table_check.c
@@ -208,8 +208,7 @@ void __page_table_check_pmd_set(struct m
 }
 EXPORT_SYMBOL(__page_table_check_pmd_set);
 
-void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
-				pud_t *pudp, pud_t pud)
+void __page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp, pud_t pud)
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

