Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F338EE49B3
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237775AbjHXXVu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbjHXXVR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15527A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A04DB646AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041B1C433C7;
        Thu, 24 Aug 2023 23:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919274;
        bh=NSSorRgNulf45v8UK+kc/ndNdUEO6o/SCEQiQdZ6lHI=;
        h=Date:To:From:Subject:From;
        b=mBD+jljsU9L17u4D6bobvBZjsD0MZ3d5t+PFXjn7Fcb7szI5MShGs36sdS2Du+FFb
         OPsKEUsYIQmW0xGLj0tkP3tJ/YwVodC4aqMyuG50tu5rBs2nR8rd3ZCL/aUr51+c/W
         iiNKn5bZDFRSQd3J4Nl0MQWg6i1m3/3ybnD/wLTE=
Date:   Thu, 24 Aug 2023 16:21:13 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        pasha.tatashin@soleen.com, anshuman.khandual@arm.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch removed from -mm tree
Message-Id: <20230824232114.041B1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert page_table_check_pte_set() to page_table_check_ptes_set()
has been removed from the -mm tree.  Its filename was
     mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert page_table_check_pte_set() to page_table_check_ptes_set()
Date: Wed, 2 Aug 2023 16:13:30 +0100

Tell the page table check how many PTEs & PFNs we want it to check.

Link: https://lkml.kernel.org/r/20230802151406.3735276-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   13 +++++++------
 mm/page_table_check.c            |   16 +++++++++-------
 5 files changed, 19 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -348,7 +348,7 @@ static inline void __set_pte_at(struct m
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
-	page_table_check_pte_set(mm, ptep, pte);
+	page_table_check_ptes_set(mm, ptep, pte, 1);
 	return __set_pte_at(mm, addr, ptep, pte);
 }
 
--- a/arch/riscv/include/asm/pgtable.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -499,7 +499,7 @@ static inline void __set_pte_at(struct m
 static inline void set_pte_at(struct mm_struct *mm,
 	unsigned long addr, pte_t *ptep, pte_t pteval)
 {
-	page_table_check_pte_set(mm, ptep, pteval);
+	page_table_check_ptes_set(mm, ptep, pteval, 1);
 	__set_pte_at(mm, addr, ptep, pteval);
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1023,7 +1023,7 @@ static inline pud_t native_local_pudp_ge
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
-	page_table_check_pte_set(mm, ptep, pte);
+	page_table_check_ptes_set(mm, ptep, pte, 1);
 	set_pte(ptep, pte);
 }
 
--- a/include/linux/page_table_check.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/include/linux/page_table_check.h
@@ -17,7 +17,8 @@ void __page_table_check_zero(struct page
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
-void __page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep, pte_t pte);
+void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
+		unsigned int nr);
 void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd);
 void __page_table_check_pud_set(struct mm_struct *mm, pud_t *pudp, pud_t pud);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -64,13 +65,13 @@ static inline void page_table_check_pud_
 	__page_table_check_pud_clear(mm, pud);
 }
 
-static inline void page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep,
-					    pte_t pte)
+static inline void page_table_check_ptes_set(struct mm_struct *mm,
+		pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_set(mm, ptep, pte);
+	__page_table_check_ptes_set(mm, ptep, pte, nr);
 }
 
 static inline void page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp,
@@ -123,8 +124,8 @@ static inline void page_table_check_pud_
 {
 }
 
-static inline void page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep,
-					    pte_t pte)
+static inline void page_table_check_ptes_set(struct mm_struct *mm,
+		pte_t *ptep, pte_t pte, unsigned int nr)
 {
 }
 
--- a/mm/page_table_check.c~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/mm/page_table_check.c
@@ -182,18 +182,20 @@ void __page_table_check_pud_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
 
-void __page_table_check_pte_set(struct mm_struct *mm, pte_t *ptep, pte_t pte)
+void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
+		unsigned int nr)
 {
+	unsigned int i;
+
 	if (&init_mm == mm)
 		return;
 
-	__page_table_check_pte_clear(mm, ptep_get(ptep));
-	if (pte_user_accessible_page(pte)) {
-		page_table_check_set(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT,
-				     pte_write(pte));
-	}
+	for (i = 0; i < nr; i++)
+		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
+	if (pte_user_accessible_page(pte))
+		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
-EXPORT_SYMBOL(__page_table_check_pte_set);
+EXPORT_SYMBOL(__page_table_check_ptes_set);
 
 void __page_table_check_pmd_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd)
 {
_

Patches currently in -mm which might be from willy@infradead.org are


