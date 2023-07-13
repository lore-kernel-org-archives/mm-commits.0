Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 117E0C001DD
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbjGMRSK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbjGMRSI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC831BD4
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6AA06199C
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35113C433C8;
        Thu, 13 Jul 2023 17:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268686;
        bh=B9R5WltpNHLQ/oStht6peEWrxwAHRRYIKsjOtA7ExK8=;
        h=Date:To:From:Subject:From;
        b=nY21CpJulQRIRaQ6XXgLDWRarAsq4NYX30C+zlYx3GsLTUkCneYUvrtaWphlZcIcA
         WttpxluYla9L2rwIYM2eUjy9lRb5F1O8GULsPTbE9+hu3ZbylGtsWISYF2mg5z/7eD
         EXQPiIkDOpE8btznJNzo0sETb5nLRZE2d9PYsX/I=
Date:   Thu, 13 Jul 2023 10:18:05 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch added to mm-unstable branch
Message-Id: <20230713171806.35113C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pud_clear
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear.patch

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
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pud_clear
Date: Fri, 14 Jul 2023 01:26:33 +0800

Remove unused addr in __page_table_check_pud_clear and
page_table_check_pud_clear.

Link: https://lkml.kernel.org/r/20230713172636.1705415-6-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   11 ++++-------
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    5 ++---
 4 files changed, 8 insertions(+), 12 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1144,7 +1144,7 @@ static inline pud_t pudp_huge_get_and_cl
 {
 	pud_t pud = native_pudp_get_and_clear(pudp);
 
-	page_table_check_pud_clear(mm, addr, pud);
+	page_table_check_pud_clear(mm, pud);
 
 	return pud;
 }
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/include/linux/page_table_check.h
@@ -16,8 +16,7 @@ extern struct page_ext_operations page_t
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
-void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
-				  pud_t pud);
+void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
 void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
@@ -60,13 +59,12 @@ static inline void page_table_check_pmd_
 	__page_table_check_pmd_clear(mm, pmd);
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm,
-					      unsigned long addr, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pud_clear(mm, addr, pud);
+	__page_table_check_pud_clear(mm, pud);
 }
 
 static inline void page_table_check_pte_set(struct mm_struct *mm,
@@ -127,8 +125,7 @@ static inline void page_table_check_pmd_
 {
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm,
-					      unsigned long addr, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/include/linux/pgtable.h
@@ -438,7 +438,7 @@ static inline pud_t pudp_huge_get_and_cl
 	pud_t pud = *pudp;
 
 	pud_clear(pudp);
-	page_table_check_pud_clear(mm, address, pud);
+	page_table_check_pud_clear(mm, pud);
 
 	return pud;
 }
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pud_clear
+++ a/mm/page_table_check.c
@@ -171,8 +171,7 @@ void __page_table_check_pmd_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
 
-void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
-				  pud_t pud)
+void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 {
 	if (&init_mm == mm)
 		return;
@@ -217,7 +216,7 @@ void __page_table_check_pud_set(struct m
 	if (&init_mm == mm)
 		return;
 
-	__page_table_check_pud_clear(mm, addr, *pudp);
+	__page_table_check_pud_clear(mm, *pudp);
 	if (pud_user_accessible_page(pud)) {
 		page_table_check_set(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT,
 				     pud_write(pud));
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

