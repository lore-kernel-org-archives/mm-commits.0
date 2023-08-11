Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F4CBC04A6A
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237116AbjHKXDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjHKXCF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61A53585
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43E366464E
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F65C433C7;
        Fri, 11 Aug 2023 23:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794857;
        bh=3qI/XZYHJ5k0jWHfx8tVjXNhqPJ3Wijok37wK2pE0YQ=;
        h=Date:To:From:Subject:From;
        b=SSaW4R1vaU6KkdqP7JjVwFqvlzLWWQdkvlWeaS8oczuJgTWSw2U0tR3SHQ4bYLuCA
         JsEk1edk6a4QdzAjHdhISa3kSIMa89S2t5IBoGdmWwmTqTqwVrI9fyEAeOz1zMrk1y
         cK6k6RrzLEPLB+5RIM7tZn40VO7yOJd5/m4c6GFQ=
Date:   Fri, 11 Aug 2023 16:00:57 -0700
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        shikemeng@huaweicloud.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch removed from -mm tree
Message-Id: <20230811230057.96F65C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_table_check: remove unused parameter in [__]page_table_check_pte_clear
has been removed from the -mm tree.  Its filename was
     mm-page_table_check-remove-unused-parameter-in-page_table_check_pte_clear.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-page_ext-add-common-function-to-get-client-data-from-page_ext.patch
mm-page_ext-use-page_ext_data-helper-in-page_table_check.patch
mm-page_ext-use-page_ext_data-helper-in-page_owner.patch
mm-page_poison-remove-unused-page_exth-from-page_poison.patch
mm-vmstat-remove-unused-page_exth-from-vmstat.patch
mm-page_ext-move-page_ext_operations-definition-under-config_page_extension.patch
mm-compaction-set-compact_cached_free_pfn-correctly-in-update_pageblock_skip.patch
mm-compaction-remove-unnecessary-cursor-page-in-isolate_freepages_block.patch
mm-compaction-remove-unnecessary-else-continue-at-end-of-loop-in-isolate_freepages_block.patch
mm-compaction-correct-last_migrated_pfn-update-in-compact_zone.patch
mm-compaction-skip-page-block-marked-skip-in-isolate_migratepages_block.patch
mm-compaction-correct-comment-of-fast_find_migrateblock-in-isolate_migratepages.patch
mm-compaction-correct-comment-of-cached-migrate-pfn-update.patch
mm-compaction-correct-comment-to-complete-migration-failure.patch
mm-compaction-remove-unnecessary-return-for-void-function.patch
mm-compaction-only-set-skip-flag-if-cc-no_set_skip_hint-is-false.patch
mm-page_alloc-remove-track-of-active-pcp-lists-range-in-bulk-free.patch
mm-page_alloc-remove-unnecessary-parameter-batch-of-nr_pcp_free.patch
mm-compaction-remove-unused-parameter-pgdata-of-fragmentation_score_wmark.patch
mm-page_alloc-remove-unnecessary-inner-__get_pfnblock_flags_mask.patch
mm-page_alloc-use-get_pfnblock_migratetype-to-avoid-extra-page_to_pfn.patch

