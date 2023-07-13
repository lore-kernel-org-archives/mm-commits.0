Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FC0C001B0
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jul 2023 17:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbjGMRSD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jul 2023 13:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjGMRSC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jul 2023 13:18:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DE5110
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 10:18:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94F5E61AEF
        for <mm-commits@vger.kernel.org>; Thu, 13 Jul 2023 17:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E668DC433C7;
        Thu, 13 Jul 2023 17:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689268680;
        bh=2NeGbOrodOQ1lgrK7y18nlJxQ1s9wmMZ0R/T9j2Gxjo=;
        h=Date:To:From:Subject:From;
        b=sCUDwcCUQEqR3C06pyayrPoV+Tsi3MIWZR+v93AnQoA5e5axMWX9sK/sXoK8LK7ZX
         T1oOJKaANxKYp2WJ9rBKCbpJGAeUfc1/enJ4SOrdjvgjTSwHNcj0oQ4KftU6ktbub6
         GhbUZMGh/1xhfoYOpHt/hue+2C2dywmLaOwcvlsI=
Date:   Thu, 13 Jul 2023 10:17:59 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch added to mm-unstable branch
Message-Id: <20230713171759.E668DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pte_clear
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch

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
Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pte_clear
Date: Fri, 14 Jul 2023 01:26:31 +0800

Remove unused addr in page_table_check_pte_clear and
__page_table_check_pte_clear.

Link: https://lkml.kernel.org/r/20230713172636.1705415-4-shikemeng@huaweicloud.com
Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    4 ++--
 include/linux/page_table_check.h |   11 ++++-------
 include/linux/pgtable.h          |    2 +-
 mm/page_table_check.c            |    7 +++----
 6 files changed, 12 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear
+++ a/arch/arm64/include/asm/pgtable.h
@@ -928,7 +928,7 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
 
-	page_table_check_pte_clear(mm, address, pte);
+	page_table_check_pte_clear(mm, pte);
 
 	return pte;
 }
--- a/arch/riscv/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear
+++ a/arch/riscv/include/asm/pgtable.h
@@ -529,7 +529,7 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
-	page_table_check_pte_clear(mm, address, pte);
+	page_table_check_pte_clear(mm, pte);
 
 	return pte;
 }
--- a/arch/x86/include/asm/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear
+++ a/arch/x86/include/asm/pgtable.h
@@ -1068,7 +1068,7 @@ static inline pte_t ptep_get_and_clear(s
 				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
-	page_table_check_pte_clear(mm, addr, pte);
+	page_table_check_pte_clear(mm, pte);
 	return pte;
 }
 
@@ -1084,7 +1084,7 @@ static inline pte_t ptep_get_and_clear_f
 		 * care about updates and native needs no locking
 		 */
 		pte = native_local_ptep_get_and_clear(ptep);
-		page_table_check_pte_clear(mm, addr, pte);
+		page_table_check_pte_clear(mm, pte);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
--- a/include/linux/page_table_check.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear
+++ a/include/linux/page_table_check.h
@@ -14,8 +14,7 @@ extern struct static_key_true page_table
 extern struct page_ext_operations page_table_check_ops;
 
 void __page_table_check_zero(struct page *page, unsigned int order);
-void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
-				  pte_t pte);
+void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
@@ -46,13 +45,12 @@ static inline void page_table_check_free
 	__page_table_check_zero(page, order);
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm,
-					      unsigned long addr, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_clear(mm, addr, pte);
+	__page_table_check_pte_clear(mm, pte);
 }
 
 static inline void page_table_check_pmd_clear(struct mm_struct *mm,
@@ -123,8 +121,7 @@ static inline void page_table_check_free
 {
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm,
-					      unsigned long addr, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
 {
 }
 
--- a/include/linux/pgtable.h~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear
+++ a/include/linux/pgtable.h
@@ -322,7 +322,7 @@ static inline pte_t ptep_get_and_clear(s
 {
 	pte_t pte = ptep_get(ptep);
 	pte_clear(mm, address, ptep);
-	page_table_check_pte_clear(mm, address, pte);
+	page_table_check_pte_clear(mm, pte);
 	return pte;
 }
 #endif
--- a/mm/page_table_check.c~mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear
+++ a/mm/page_table_check.c
@@ -149,8 +149,7 @@ void __page_table_check_zero(struct page
 	page_ext_put(page_ext);
 }
 
-void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
-				  pte_t pte)
+void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
 {
 	if (&init_mm == mm)
 		return;
@@ -191,7 +190,7 @@ void __page_table_check_pte_set(struct m
 	if (&init_mm == mm)
 		return;
 
-	__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
+	__page_table_check_pte_clear(mm, ptep_get(ptep));
 	if (pte_user_accessible_page(pte)) {
 		page_table_check_set(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT,
 				     pte_write(pte));
@@ -241,7 +240,7 @@ void __page_table_check_pte_clear_range(
 		if (WARN_ON(!ptep))
 			return;
 		for (i = 0; i < PTRS_PER_PTE; i++) {
-			__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
+			__page_table_check_pte_clear(mm, ptep_get(ptep));
 			addr += PAGE_SIZE;
 			ptep++;
 		}
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

