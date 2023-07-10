Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C86EB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbjGJX3d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjGJX33 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:29:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A64898
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B874B61259
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD77C433C9;
        Mon, 10 Jul 2023 23:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031767;
        bh=/2E0QIxxuuu8JJ1CyrYD8VeA52sMR3PzLEOqy6vr/e8=;
        h=Date:To:From:Subject:From;
        b=0S9XH0XlzM6yMtpx6XuM8ECdT9unP/iPDyRbD1mI1+o6GgBxbdRoV/zh6Zh7owxo4
         1H16YEnqhwzmuT4oPVgyDRSilzC9AingUxT56Q3e68aEUdkUj57qWQFKtZ4Dkzt3qd
         ZuZYbInqnISumheyiwjR4ZjjFj8n6n4dmRhTnPoI=
Date:   Mon, 10 Jul 2023 16:29:26 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        pasha.tatashin@soleen.com, anshuman.khandual@arm.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch added to mm-unstable branch
Message-Id: <20230710232927.1BD77C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: convert page_table_check_pte_set() to page_table_check_ptes_set()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert page_table_check_pte_set() to page_table_check_ptes_set()
Date: Mon, 10 Jul 2023 21:43:03 +0100

Tell the page table check how many PTEs & PFNs we want it to check.

Link: https://lkml.kernel.org/r/20230710204339.3554919-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    2 +-
 arch/riscv/include/asm/pgtable.h |    2 +-
 arch/x86/include/asm/pgtable.h   |    2 +-
 include/linux/page_table_check.h |   14 +++++++-------
 mm/page_table_check.c            |   14 ++++++++------
 5 files changed, 18 insertions(+), 16 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/arch/arm64/include/asm/pgtable.h
@@ -348,7 +348,7 @@ static inline void __set_pte_at(struct m
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
-	page_table_check_pte_set(mm, addr, ptep, pte);
+	page_table_check_ptes_set(mm, addr, ptep, pte, 1);
 	return __set_pte_at(mm, addr, ptep, pte);
 }
 
--- a/arch/riscv/include/asm/pgtable.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/arch/riscv/include/asm/pgtable.h
@@ -499,7 +499,7 @@ static inline void __set_pte_at(struct m
 static inline void set_pte_at(struct mm_struct *mm,
 	unsigned long addr, pte_t *ptep, pte_t pteval)
 {
-	page_table_check_pte_set(mm, addr, ptep, pteval);
+	page_table_check_ptes_set(mm, addr, ptep, pteval, 1);
 	__set_pte_at(mm, addr, ptep, pteval);
 }
 
--- a/arch/x86/include/asm/pgtable.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/arch/x86/include/asm/pgtable.h
@@ -1023,7 +1023,7 @@ static inline pud_t native_local_pudp_ge
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte)
 {
-	page_table_check_pte_set(mm, addr, ptep, pte);
+	page_table_check_ptes_set(mm, addr, ptep, pte, 1);
 	set_pte(ptep, pte);
 }
 
--- a/include/linux/page_table_check.h~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/include/linux/page_table_check.h
@@ -20,8 +20,8 @@ void __page_table_check_pmd_clear(struct
 				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud);
-void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte);
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, pte_t pte, unsigned int nr);
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd);
 void __page_table_check_pud_set(struct mm_struct *mm, unsigned long addr,
@@ -73,14 +73,14 @@ static inline void page_table_check_pud_
 	__page_table_check_pud_clear(mm, addr, pud);
 }
 
-static inline void page_table_check_pte_set(struct mm_struct *mm,
+static inline void page_table_check_ptes_set(struct mm_struct *mm,
 					    unsigned long addr, pte_t *ptep,
-					    pte_t pte)
+					    pte_t pte, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_set(mm, addr, ptep, pte);
+	__page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 }
 
 static inline void page_table_check_pmd_set(struct mm_struct *mm,
@@ -138,9 +138,9 @@ static inline void page_table_check_pud_
 {
 }
 
-static inline void page_table_check_pte_set(struct mm_struct *mm,
+static inline void page_table_check_ptes_set(struct mm_struct *mm,
 					    unsigned long addr, pte_t *ptep,
-					    pte_t pte)
+					    pte_t pte, unsigned int nr)
 {
 }
 
--- a/mm/page_table_check.c~mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set
+++ a/mm/page_table_check.c
@@ -190,20 +190,22 @@ void __page_table_check_pud_clear(struct
 }
 EXPORT_SYMBOL(__page_table_check_pud_clear);
 
-void __page_table_check_pte_set(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte)
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, pte_t pte, unsigned int nr)
 {
+	unsigned int i;
+
 	if (&init_mm == mm)
 		return;
 
-	__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
+	for (i = 0; i < nr; i++)
+		__page_table_check_pte_clear(mm, addr, ptep_get(ptep + i));
 	if (pte_user_accessible_page(pte)) {
-		page_table_check_set(mm, addr, pte_pfn(pte),
-				     PAGE_SIZE >> PAGE_SHIFT,
+		page_table_check_set(mm, addr, pte_pfn(pte), nr,
 				     pte_write(pte));
 	}
 }
-EXPORT_SYMBOL(__page_table_check_pte_set);
+EXPORT_SYMBOL(__page_table_check_ptes_set);
 
 void __page_table_check_pmd_set(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

