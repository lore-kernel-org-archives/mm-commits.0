Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FE8EE49BE
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:22:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244096AbjHXXV6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243505AbjHXXV0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:21:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDB1A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FC9F64B19
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:21:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8572AC433C7;
        Thu, 24 Aug 2023 23:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919283;
        bh=Cks2BfyNw7aIhiDBQv3zwFo8bz9MeQbmhUuDw0Cqm2g=;
        h=Date:To:From:Subject:From;
        b=NdbJ8HpFffoPxyzTpUnG7SfWf4LsB6XwJjLruWviIlC8z3DWwxdOP0jweM2rRqLtl
         15UWpHyU7WM5Dn6ISI+GtP43wffycI89CMG1KWBrxxVWXa0tI1CLJXMd219Fw4p4e1
         fvR2hi8tL03xDPQAgCOZmwkSKZBk09isqE3iG/+0=
Date:   Thu, 24 Aug 2023 16:21:23 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        catalin.marinas@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-implement-the-new-page-table-range-api.patch removed from -mm tree
Message-Id: <20230824232123.8572AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: arm64: implement the new page table range API
has been removed from the -mm tree.  Its filename was
     arm64-implement-the-new-page-table-range-api.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: arm64: implement the new page table range API
Date: Wed, 2 Aug 2023 16:13:38 +0100

Add set_ptes(), update_mmu_cache_range() and flush_dcache_folio().  Change
the PG_dcache_clean flag from being per-page to per-folio.

Link: https://lkml.kernel.org/r/20230802151406.3735276-11-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/cacheflush.h |    4 ++
 arch/arm64/include/asm/pgtable.h    |   24 +++++++++++++----
 arch/arm64/mm/flush.c               |   36 ++++++++++----------------
 3 files changed, 35 insertions(+), 29 deletions(-)

--- a/arch/arm64/include/asm/cacheflush.h~arm64-implement-the-new-page-table-range-api
+++ a/arch/arm64/include/asm/cacheflush.h
@@ -114,7 +114,7 @@ extern void copy_to_user_page(struct vm_
 #define copy_to_user_page copy_to_user_page
 
 /*
- * flush_dcache_page is used when the kernel has written to the page
+ * flush_dcache_folio is used when the kernel has written to the page
  * cache page at virtual address page->virtual.
  *
  * If this page isn't mapped (ie, page_mapping == NULL), or it might
@@ -127,6 +127,8 @@ extern void copy_to_user_page(struct vm_
  */
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *);
+void flush_dcache_folio(struct folio *);
+#define flush_dcache_folio flush_dcache_folio
 
 static __always_inline void icache_inval_all_pou(void)
 {
--- a/arch/arm64/include/asm/pgtable.h~arm64-implement-the-new-page-table-range-api
+++ a/arch/arm64/include/asm/pgtable.h
@@ -345,12 +345,21 @@ static inline void __set_pte_at(struct m
 	set_pte(ptep, pte);
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pte)
+static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pte, 1);
-	return __set_pte_at(mm, addr, ptep, pte);
+	page_table_check_ptes_set(mm, ptep, pte, nr);
+
+	for (;;) {
+		__set_pte_at(mm, addr, ptep, pte);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+		pte_val(pte) += PAGE_SIZE;
+	}
 }
+#define set_ptes set_ptes
 
 /*
  * Huge pte definitions.
@@ -1049,8 +1058,9 @@ static inline void arch_swap_restore(swp
 /*
  * On AArch64, the cache coherency is handled via the set_pte_at() function.
  */
-static inline void update_mmu_cache(struct vm_area_struct *vma,
-				    unsigned long addr, pte_t *ptep)
+static inline void update_mmu_cache_range(struct vm_fault *vmf,
+		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		unsigned int nr)
 {
 	/*
 	 * We don't do anything here, so there's a very small chance of
@@ -1059,6 +1069,8 @@ static inline void update_mmu_cache(stru
 	 */
 }
 
+#define update_mmu_cache(vma, addr, ptep) \
+	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
 #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
 
 #ifdef CONFIG_ARM64_PA_BITS_52
--- a/arch/arm64/mm/flush.c~arm64-implement-the-new-page-table-range-api
+++ a/arch/arm64/mm/flush.c
@@ -51,20 +51,13 @@ void copy_to_user_page(struct vm_area_st
 
 void __sync_icache_dcache(pte_t pte)
 {
-	struct page *page = pte_page(pte);
+	struct folio *folio = page_folio(pte_page(pte));
 
-	/*
-	 * HugeTLB pages are always fully mapped, so only setting head page's
-	 * PG_dcache_clean flag is enough.
-	 */
-	if (PageHuge(page))
-		page = compound_head(page);
-
-	if (!test_bit(PG_dcache_clean, &page->flags)) {
-		sync_icache_aliases((unsigned long)page_address(page),
-				    (unsigned long)page_address(page) +
-					    page_size(page));
-		set_bit(PG_dcache_clean, &page->flags);
+	if (!test_bit(PG_dcache_clean, &folio->flags)) {
+		sync_icache_aliases((unsigned long)folio_address(folio),
+				    (unsigned long)folio_address(folio) +
+					    folio_size(folio));
+		set_bit(PG_dcache_clean, &folio->flags);
 	}
 }
 EXPORT_SYMBOL_GPL(__sync_icache_dcache);
@@ -74,17 +67,16 @@ EXPORT_SYMBOL_GPL(__sync_icache_dcache);
  * it as dirty for later flushing when mapped in user space (if executable,
  * see __sync_icache_dcache).
  */
-void flush_dcache_page(struct page *page)
+void flush_dcache_folio(struct folio *folio)
 {
-	/*
-	 * HugeTLB pages are always fully mapped and only head page will be
-	 * set PG_dcache_clean (see comments in __sync_icache_dcache()).
-	 */
-	if (PageHuge(page))
-		page = compound_head(page);
+	if (test_bit(PG_dcache_clean, &folio->flags))
+		clear_bit(PG_dcache_clean, &folio->flags);
+}
+EXPORT_SYMBOL(flush_dcache_folio);
 
-	if (test_bit(PG_dcache_clean, &page->flags))
-		clear_bit(PG_dcache_clean, &page->flags);
+void flush_dcache_page(struct page *page)
+{
+	flush_dcache_folio(page_folio(page));
 }
 EXPORT_SYMBOL(flush_dcache_page);
 
_

Patches currently in -mm which might be from willy@infradead.org are


